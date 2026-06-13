USE pdan_bd_Segmentacion_de_clientes_de_consumo_masivo;
 GO

 --- 10 EJERCICIOS DE VISTAS, PROCEDIMIENTO, ALMACENADOS Y FUNCIONES 

---==================================
---VISTA
---==================================

--- 1) Clientes con su segmento

CREATE VIEW vw_clientes_segmento
AS
SELECT c.id_cliente,
       c.nombre_cliente,
       c.edad,
       c.genero,
       s.nombre_segmento
FROM cliente c
INNER JOIN segmento s
ON c.id_segmento = s.id_segmento;
GO

SELECT * FROM vw_clientes_segmento;

--- 2) Productos con categoría

CREATE VIEW vw_productos_categoria
AS
SELECT p.id_producto,
       p.nombre_producto,
       p.precio,
       p.stock,
       ca.nombre_categoria
FROM producto p
INNER JOIN categoria ca
ON p.id_categoria = ca.id_categoria;
GO

SELECT * FROM vw_productos_categoria;

--- 3) Ventas realizadas por cliente

CREATE VIEW vw_ventas_cliente
AS
SELECT v.id_venta,
       v.fecha_venta,
       v.monto_total,
       c.nombre_cliente
FROM venta v
INNER JOIN cliente c
ON v.id_cliente = c.id_cliente;
GO

SELECT * FROM vw_ventas_cliente;

---==================================
---PROCEDIMIENTO
---==================================

--- 1) Mostrar todos los clientes

CREATE PROCEDURE sp_listar_clientes
AS
BEGIN
    SELECT *
    FROM cliente;
END;
GO

EXEC sp_listar_clientes;

--- 2) Buscar cliente por ID

CREATE PROCEDURE sp_buscar_cliente
    @id_cliente INT
AS
BEGIN
    SELECT *
    FROM cliente
    WHERE id_cliente = @id_cliente;
END;
GO

EXEC sp_buscar_cliente 1;

--- 3) Mostrar ventas de un cliente

CREATE PROCEDURE sp_ventas_cliente
    @id_cliente INT
AS
BEGIN
    SELECT *
    FROM venta
    WHERE id_cliente = @id_cliente;
END;
GO

EXEC sp_ventas_cliente 1;

--- 4) Actualizar stock de producto

CREATE PROCEDURE sp_actualizar_stock
    @id_producto INT,
    @nuevo_stock INT
AS
BEGIN
    UPDATE producto
    SET stock = @nuevo_stock
    WHERE id_producto = @id_producto;
END;
GO

EXEC sp_actualizar_stock 1, 120;

---==================================
---FUNCION ESCALAR
---==================================

--- 1) Total de ventas de un cliente

CREATE FUNCTION fn_total_ventas_cliente
(
    @id_cliente INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @total DECIMAL(10,2);

    SELECT @total = SUM(monto_total)
    FROM venta
    WHERE id_cliente = @id_cliente;

    RETURN ISNULL(@total,0);
END;
GO

SELECT dbo.fn_total_ventas_cliente(1) AS TotalVentas;

--- 2) Cantidad de ventas realizadas por un cliente

CREATE FUNCTION fn_cantidad_ventas_cliente
(
    @id_cliente INT
)
RETURNS INT
AS
BEGIN
    DECLARE @cantidad INT;

    SELECT @cantidad = COUNT(*)
    FROM venta
    WHERE id_cliente = @id_cliente;

    RETURN @cantidad;
END;
GO

SELECT dbo.fn_cantidad_ventas_cliente(1) AS CantidadVentas;

--- 3) Productos con stock mayor a un valor

CREATE FUNCTION fn_productos_stock
(
    @stock INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT *
    FROM producto
    WHERE stock > @stock
);
GO

SELECT *
FROM dbo.fn_productos_stock(50);




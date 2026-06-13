USE pdan_bd_Segmentacion_de_clientes_de_consumo_masivo;
 GO


--- CREANDO MOELO DIMENSIONAL

---====================
---CREANDO TABLAS
---====================

--- Tabla cliente

CREATE TABLE Dim_Cliente
(
    id_cliente INT PRIMARY KEY,
    nombre_cliente VARCHAR(100),
    genero CHAR(1),
    edad INT,
    distrito VARCHAR(100),
    segmento VARCHAR(100)
);
GO

--- Tabla producto

CREATE TABLE Dim_Producto
(
    id_producto INT PRIMARY KEY,
    nombre_producto VARCHAR(100),
    categoria VARCHAR(100),
    precio DECIMAL(10,2)
);
GO

--- Tabla fecha

CREATE TABLE Dim_Fecha
(
    id_fecha INT PRIMARY KEY,
    fecha DATE,
    dia INT,
    mes INT,
    anio INT
);
GO

--- Crear la tabla de hechos

CREATE TABLE Fact_Ventas
(
    id_venta INT,
    id_cliente INT,
    id_producto INT,
    id_fecha INT,
    cantidad INT,
    subtotal DECIMAL(10,2)
);
GO

---================================
---CAMPOS DE LAS TABLAS
---================================


---Cliente

INSERT INTO Dim_Cliente
SELECT
    c.id_cliente,
    c.nombre_cliente,
    c.genero,
    c.edad,
    c.distrito,
    s.nombre_segmento
FROM cliente c
INNER JOIN segmento s
ON c.id_segmento = s.id_segmento;
GO

---producto

INSERT INTO Dim_Producto
SELECT
    p.id_producto,
    p.nombre_producto,
    ca.nombre_categoria,
    p.precio
FROM producto p
INNER JOIN categoria ca
ON p.id_categoria = ca.id_categoria;
GO


---fecha

INSERT INTO Dim_Fecha
SELECT
    ROW_NUMBER() OVER(ORDER BY fecha_venta),
    fecha_venta,
    DAY(fecha_venta),
    MONTH(fecha_venta),
    YEAR(fecha_venta)
FROM venta;
GO

CREATE TABLE Fact_Ventas
(
    id_venta INT,
    id_cliente INT,
    id_producto INT,
    id_fecha INT,
    cantidad INT,
    subtotal DECIMAL(10,2)
);
GO

INSERT INTO Fact_Ventas
SELECT
    dv.id_venta,
    v.id_cliente,
    dv.id_producto,
    ROW_NUMBER() OVER(ORDER BY v.fecha_venta),
    dv.cantidad,
    dv.subtotal
FROM detalleventa dv
INNER JOIN venta v
ON dv.id_venta = v.id_venta;
GO

SELECT * FROM Dim_Cliente;
SELECT * FROM Dim_Producto;
SELECT * FROM Dim_Fecha;
SELECT * FROM Fact_Ventas;



SELECT
    p.categoria,
    SUM(f.subtotal) AS Total_Vendido
FROM Fact_Ventas f
INNER JOIN Dim_Producto p
ON f.id_producto = p.id_producto
GROUP BY p.categoria;
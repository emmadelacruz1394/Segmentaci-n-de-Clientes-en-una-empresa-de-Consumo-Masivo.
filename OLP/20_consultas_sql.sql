--- 20 consultas de Transact sql persona(10 básicas y Intermedias, 10 avanzadas  y expertas)

USE pdan_bd_Segmentacion_de_clientes_de_consumo_masivo;
 GO

--- 5 EJERCICIOS NIVEL BASICO


--- 1) Mostrar todos los clientes con sus nombres completos y correo electrónico.

SELECT nombre_cliente, telefono, correo
FROM cliente;

--- 2) Listar todos los productos con su categoría y precio unitario.

SELECT p.nombre_producto, c.nombre_categoria, precio
FROM producto p
INNER JOIN categoria c
    ON p.id_categoria = c.id_categoria;

--- 3) Mostrar todas las ventas realizadas durante el año 2025.

SELECT *
FROM venta
WHERE YEAR(fecha_venta) = 2025;

--- 4) Listar los clientes pertenecientes al segmento Premium.

SELECT c.nombre_cliente
FROM cliente c
INNER JOIN segmento s
    ON c.id_segmento = s.id_segmento
WHERE s.nombre_segmento = 'Cliente premiun';

--- 5) Mostrar los productos ordenados por precio de mayor a menor.

SELECT nombre_producto, precio
FROM producto
ORDER BY precio DESC;

---5 EJERCICIOS NIVEL INTERMEDIO

---1) Mostrar clientes con su segmento

SELECT c.nombre_cliente,
       c.edad,
       c.genero,
       s.nombre_segmento
FROM cliente c
INNER JOIN segmento s
ON c.id_segmento = s.id_segmento;

---2) Mostrar productos con su categoría

SELECT p.nombre_producto,
       p.precio,
       p.stock,
       ca.nombre_categoria
FROM producto p
INNER JOIN categoria ca
ON p.id_categoria = ca.id_categoria;

---3) Mostrar ventas realizadas por cada cliente

SELECT c.nombre_cliente,
       v.id_venta,
       v.fecha_venta,
       v.monto_total
FROM cliente c
INNER JOIN venta v
ON c.id_cliente = v.id_cliente
ORDER BY c.nombre_cliente;

---4) Mostrar detalle de ventas con nombre de producto

SELECT dv.id_detalle,
       p.nombre_producto,
       dv.cantidad,
       dv.subtotal
FROM detalleventa dv
INNER JOIN producto p
ON dv.id_producto = p.id_producto;

---5) Calcular el total vendido por producto

SELECT p.nombre_producto,
       SUM(dv.subtotal) AS Total_Vendido
FROM producto p
INNER JOIN detalleventa dv
ON p.id_producto = dv.id_producto
GROUP BY p.nombre_producto;


---5 EJERCICIOS NIVEL AVANZADO

---1) Cantidad de ventas realizadas por cada cliente

SELECT c.nombre_cliente,
       COUNT(v.id_venta) AS Cantidad_Ventas
FROM cliente c
LEFT JOIN venta v
ON c.id_cliente = v.id_cliente
GROUP BY c.nombre_cliente;

---2) Cliente que realizó más compras

SELECT TOP 1
       c.nombre_cliente,
       COUNT(v.id_venta) AS Total_Compras
FROM cliente c
INNER JOIN venta v
ON c.id_cliente = v.id_cliente
GROUP BY c.nombre_cliente
ORDER BY Total_Compras DESC;

---3) Categoría con mayor monto vendido

SELECT TOP 1
       ca.nombre_categoria,
       SUM(dv.subtotal) AS Total_Ventas
FROM categoria ca
INNER JOIN producto p
ON ca.id_categoria = p.id_categoria
INNER JOIN detalleventa dv
ON p.id_producto = dv.id_producto
GROUP BY ca.nombre_categoria
ORDER BY Total_Ventas DESC;

---4) Promedio de gasto por cliente

SELECT c.nombre_cliente,
       AVG(v.monto_total) AS Promedio_Gasto
FROM cliente c
INNER JOIN venta v
ON c.id_cliente = v.id_cliente
GROUP BY c.nombre_cliente;

---5) Productos vendidos más de 30 unidades

SELECT p.nombre_producto,
       SUM(dv.cantidad) AS Total_Unidades
FROM producto p
INNER JOIN detalleventa dv
ON p.id_producto = dv.id_producto
GROUP BY p.nombre_producto
HAVING SUM(dv.cantidad) > 30;

---5 EJERCICIOS NIVEL EXPERTO

---1) Ranking de clientes por monto total de compras

SELECT c.nombre_cliente,
       SUM(v.monto_total) AS Total_Comprado,
       RANK() OVER(ORDER BY SUM(v.monto_total) DESC) AS Ranking
FROM cliente c
INNER JOIN venta v
ON c.id_cliente = v.id_cliente
GROUP BY c.nombre_cliente;

---2) Porcentaje de participación de cada producto en las ventas

SELECT p.nombre_producto,
       SUM(dv.subtotal) AS Total_Vendido,
       ROUND(
             SUM(dv.subtotal) * 100.0 /
             (SELECT SUM(subtotal) FROM detalleventa)
            ,2) AS Porcentaje
FROM producto p
INNER JOIN detalleventa dv
ON p.id_producto = dv.id_producto
GROUP BY p.nombre_producto;


---3) Clientes cuyo gasto total supera el promedio general

SELECT c.nombre_cliente,
       SUM(v.monto_total) AS Total_Gastado
FROM cliente c
INNER JOIN venta v
ON c.id_cliente = v.id_cliente
GROUP BY c.nombre_cliente
HAVING SUM(v.monto_total) >
(
    SELECT AVG(TotalCliente)
    FROM
    (
        SELECT SUM(monto_total) AS TotalCliente
        FROM venta
        GROUP BY id_cliente
    ) AS T
);

---4) Segmento con mayor facturación acumulada

SELECT TOP 1
       s.nombre_segmento,
       SUM(v.monto_total) AS Facturacion_Total
FROM segmento s
INNER JOIN cliente c
ON s.id_segmento = c.id_segmento
INNER JOIN venta v
ON c.id_cliente = v.id_cliente
GROUP BY s.nombre_segmento
ORDER BY Facturacion_Total DESC;

---5) Mostrar la venta más alta de cada cliente

SELECT c.nombre_cliente,
       MAX(v.monto_total) AS Venta_Mayor
FROM cliente c
INNER JOIN venta v
ON c.id_cliente = v.id_cliente
GROUP BY c.nombre_cliente;
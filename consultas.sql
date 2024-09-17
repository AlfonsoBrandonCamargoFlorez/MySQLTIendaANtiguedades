 -- Listar todas las antigüedades disponibles para la venta:
SELECT 
    a.Nombre, 
    a.CategoriaID, 
    a.Precio, 
    a.EstadoConservacionID
FROM Antiguedades a
JOIN Disponibilidad d ON a.DisponibilidadID = d.DisponibilidadID
WHERE d.Nombre = 'en venta';


-- Buscar antigüedades por categoría y rango de precio:
SELECT 
    Nombre, 
    CategoriaID, 
    Precio
FROM Antiguedades
WHERE CategoriaID = 1  -- Reemplazar con el ID de categoría deseado
  AND Precio BETWEEN 500 AND 2000;  -- Reemplazar con el rango de precios deseado


-- Mostrar el historial de ventas de un cliente específico:
SELECT 
    a.Nombre AS Antiguedad, 
    t.FechaTransaccion, 
    t.Precio, 
    u.Nombre AS Comprador
FROM Transacciones t
JOIN Antiguedades a ON t.AntiguedadID = a.AntiguedadID
JOIN Usuarios u ON t.CompradorID = u.UsuarioID
WHERE t.VendedorID = 1;  -- Reemplazar con el ID del vendedor deseado

-- Obtener el total de ventas realizadas en un periodo de tiempo:
SELECT 
    SUM(Precio) AS TotalVentas
FROM Transacciones
WHERE FechaTransaccion BETWEEN '2023-01-01 00:00:00' AND '2024-09-01 23:59:59';



--Encontrar los clientes más activos (con más compras realizadas):
SELECT 
    u.Nombre, 
    COUNT(t.TransaccionID) AS NumeroCompras
FROM Transacciones t
JOIN Usuarios u ON t.CompradorID = u.UsuarioID
GROUP BY u.Nombre
ORDER BY NumeroCompras DESC;


--Listar las antigüedades más populares por número de visitas o consultas:
SELECT 
    a.Nombre, 
    COUNT(*) AS NumeroConsultas
FROM Actividades act
JOIN Antiguedades a ON act.Detalle = a.Nombre
JOIN TipoActividad ta ON act.TipoActividadID = ta.TipoActividadID
WHERE ta.Nombre = 'consulta'
GROUP BY a.Nombre
ORDER BY NumeroConsultas DESC;


--Listar las antigüedades vendidas en un rango de fechas específico:
SELECT 
    a.Nombre, 
    t.FechaTransaccion, 
    u.Nombre AS Comprador, 
    u2.Nombre AS Vendedor
FROM Transacciones t
JOIN Antiguedades a ON t.AntiguedadID = a.AntiguedadID
JOIN Usuarios u ON t.CompradorID = u.UsuarioID
JOIN Usuarios u2 ON t.VendedorID = u2.UsuarioID
WHERE t.FechaTransaccion BETWEEN '2023-01-01' AND '2024-09-01';


--Obtener un informe de inventario actual:
SELECT 
    c.Nombre AS Categoria, 
    COUNT(a.AntiguedadID) AS Cantidad
FROM Antiguedades a
JOIN Categorias c ON a.CategoriaID = c.CategoriaID
JOIN Disponibilidad d ON a.DisponibilidadID = d.DisponibilidadID
WHERE d.Nombre = 'en venta'
GROUP BY c.Nombre;

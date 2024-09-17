DROP DATABASE antiguedades;
CREATE DATABASE antiguedades;
USE antiguedades;

CREATE TABLE Roles (
    RolID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50) UNIQUE
);

CREATE TABLE Perfiles (
    PerfilID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50) UNIQUE
);




CREATE TABLE Disponibilidad (
    DisponibilidadID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50) UNIQUE
);

CREATE TABLE MetodoPago (
    MetodoPagoID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50) UNIQUE
);

CREATE TABLE TipoActividad (
    TipoActividadID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50) UNIQUE
);

CREATE TABLE Usuarios (
    UsuarioID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100),
    Email VARCHAR(100) UNIQUE,
    Contrasena VARCHAR(255),
    RolID INT,
    PerfilID INT,
    FechaRegistro DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (RolID) REFERENCES Roles(RolID),
    FOREIGN KEY (PerfilID) REFERENCES Perfiles(PerfilID)
);

CREATE TABLE Categorias (
    CategoriaID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) UNIQUE
);

CREATE TABLE Epocas (
    EpocaID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) UNIQUE
);


CREATE TABLE EstadosConservacion (
    EstadoConservacionID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) UNIQUE
);

CREATE TABLE Antiguedades (
    AntiguedadID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(255),
    Descripcion TEXT,
    CategoriaID INT,
    EpocaID INT,
    EstadoConservacionID INT,
    Precio DECIMAL(10, 2),
    DisponibilidadID INT,
    FechaIngreso DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CategoriaID) REFERENCES Categorias(CategoriaID),
    FOREIGN KEY (EpocaID) REFERENCES Epocas(EpocaID),
    FOREIGN KEY (EstadoConservacionID) REFERENCES EstadosConservacion(EstadoConservacionID),
    FOREIGN KEY (DisponibilidadID) REFERENCES Disponibilidad(DisponibilidadID)
);

CREATE TABLE Transacciones (
    TransaccionID INT AUTO_INCREMENT PRIMARY KEY,
    AntiguedadID INT,
    VendedorID INT,
    CompradorID INT,
    FechaTransaccion DATETIME DEFAULT CURRENT_TIMESTAMP,
    Precio DECIMAL(10, 2),
    MetodoPagoID INT,
    FechaEntrega DATE,
    FOREIGN KEY (AntiguedadID) REFERENCES Antiguedades(AntiguedadID),
    FOREIGN KEY (VendedorID) REFERENCES Usuarios(UsuarioID),
    FOREIGN KEY (CompradorID) REFERENCES Usuarios(UsuarioID),
    FOREIGN KEY (MetodoPagoID) REFERENCES MetodoPago(MetodoPagoID)
);


CREATE TABLE Actividades (
    ActividadID INT AUTO_INCREMENT PRIMARY KEY,
    UsuarioID INT,
    TipoActividadID INT,
    FechaActividad DATETIME DEFAULT CURRENT_TIMESTAMP,
    Detalle TEXT,
    FOREIGN KEY (UsuarioID) REFERENCES Usuarios(UsuarioID),
    FOREIGN KEY (TipoActividadID) REFERENCES TipoActividad(TipoActividadID)
);


CREATE TABLE Inventario (
    InventarioID INT AUTO_INCREMENT PRIMARY KEY,
    AntiguedadID INT,
    Cantidad INT,
    FOREIGN KEY (AntiguedadID) REFERENCES Antiguedades(AntiguedadID)
);




-- Insertar datos en las tablas de referencia
INSERT INTO Roles (Nombre) VALUES ('vendedor'), ('comprador'), ('administrador');
INSERT INTO Disponibilidad (Nombre) VALUES ('en venta'), ('vendido'), ('retirado');
INSERT INTO MetodoPago (Nombre) VALUES ('tarjeta'), ('transferencia'), ('efectivo');
INSERT INTO TipoActividad (Nombre) VALUES ('venta'), ('compra'), ('consulta');


-- Procedimientos almacenados
DELIMITER //

-- 1. Listar todas las antigüedades disponibles para la venta
CREATE PROCEDURE ListarAntiguedadesDisponibles()
BEGIN
    SELECT 
        Nombre, 
        CategoriaID, 
        Precio, 
        EstadoConservacionID
    FROM Antiguedades
    WHERE DisponibilidadID = (SELECT DisponibilidadID FROM Disponibilidad WHERE Nombre = 'en venta');
END //

-- 2. Buscar antigüedades por categoría y rango de precio
CREATE PROCEDURE BuscarAntiguedadesPorCategoriaYRango(
    IN categoriaID INT, 
    IN precioMin DECIMAL(10, 2), 
    IN precioMax DECIMAL(10, 2)
)
BEGIN
    SELECT 
        Nombre, 
        CategoriaID, 
        Precio
    FROM Antiguedades
    WHERE CategoriaID = categoriaID
    AND Precio BETWEEN precioMin AND precioMax;
END //

-- 3. Mostrar el historial de ventas de un cliente específico
CREATE PROCEDURE HistorialVentasCliente(
    IN clienteID INT
)
BEGIN
    SELECT 
        a.Nombre AS Antiguedad, 
        t.FechaTransaccion, 
        t.Precio, 
        u.Nombre AS Comprador
    FROM Transacciones t
    JOIN Antiguedades a ON t.AntiguedadID = a.AntiguedadID
    JOIN Usuarios u ON t.CompradorID = u.UsuarioID
    WHERE t.VendedorID = clienteID;
END //

-- 4. Obtener el total de ventas realizadas en un periodo de tiempo
CREATE PROCEDURE TotalVentasPorPeriodo(
    IN fechaInicio DATETIME, 
    IN fechaFin DATETIME
)
BEGIN
    SELECT 
        SUM(Precio) AS TotalVentas
    FROM Transacciones
    WHERE FechaTransaccion BETWEEN fechaInicio AND fechaFin;
END //

-- 5. Encontrar los clientes más activos (con más compras realizadas)
CREATE PROCEDURE ClientesMasActivos()
BEGIN
    SELECT 
        u.Nombre, 
        COUNT(t.TransaccionID) AS NumeroCompras
    FROM Transacciones t
    JOIN Usuarios u ON t.CompradorID = u.UsuarioID
    GROUP BY u.Nombre
    ORDER BY NumeroCompras DESC;
END //

-- 6. Listar las antigüedades más populares por número de visitas o consultas
CREATE PROCEDURE AntiguedadesMasPopulares()
BEGIN
    SELECT 
        a.Nombre, 
        COUNT(*) AS NumeroConsultas
    FROM Actividades act
    JOIN Antiguedades a ON act.Detalle = a.Nombre
    WHERE act.TipoActividadID = (SELECT TipoActividadID FROM TipoActividad WHERE Nombre = 'consulta')
    GROUP BY a.Nombre
    ORDER BY NumeroConsultas DESC;
END //

-- 7. Listar las antigüedades vendidas en un rango de fechas específico
CREATE PROCEDURE AntiguedadesVendidasPorFecha(
    IN fechaInicio DATETIME, 
    IN fechaFin DATETIME
)
BEGIN
    SELECT 
        a.Nombre, 
        t.FechaTransaccion, 
        u.Nombre AS Comprador, 
        u2.Nombre AS Vendedor
    FROM Transacciones t
    JOIN Antiguedades a ON t.AntiguedadID = a.AntiguedadID
    JOIN Usuarios u ON t.CompradorID = u.UsuarioID
    JOIN Usuarios u2 ON t.VendedorID = u2.UsuarioID
    WHERE t.FechaTransaccion BETWEEN fechaInicio AND fechaFin;
END //

-- 8. Obtener un informe de inventario actual
CREATE PROCEDURE InformeInventarioActual()
BEGIN
    SELECT 
        c.Nombre AS Categoria, 
        COUNT(a.AntiguedadID) AS Cantidad
    FROM Antiguedades a
    JOIN Categorias c ON a.CategoriaID = c.CategoriaID
    WHERE a.DisponibilidadID = (SELECT DisponibilidadID FROM Disponibilidad WHERE Nombre = 'en venta')
    GROUP BY c.Nombre;
END //

DELIMITER ;

-- Ejecutar procedimientos almacenados para verificar resultados
CALL ListarAntiguedadesDisponibles();
CALL BuscarAntiguedadesPorCategoriaYRango(1, 500, 2000);
CALL HistorialVentasCliente(1);
CALL TotalVentasPorPeriodo('2024-01-01 23:59:59', '2024-09-18');
CALL ClientesMasActivos();
CALL AntiguedadesMasPopulares();
CALL AntiguedadesVendidasPorFecha('2024-01-01 23:59:59', '2024-09-18');
CALL InformeInventarioActual();
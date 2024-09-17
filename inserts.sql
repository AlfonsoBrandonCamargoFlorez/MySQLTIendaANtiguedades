-- Insertar datos en las tablas de referencia
INSERT INTO Roles (Nombre) VALUES 
('vendedor'), 
('comprador'), 
('administrador');

INSERT INTO Perfiles (Nombre) VALUES 
('cliente'), 
('coleccionista');

INSERT INTO Disponibilidad (Nombre) VALUES 
('en venta'), 
('vendido'), 
('retirado');

INSERT INTO MetodoPago (Nombre) VALUES 
('tarjeta'), 
('transferencia'), 
('efectivo');

INSERT INTO TipoActividad (Nombre) VALUES 
('venta'), 
('compra'), 
('consulta');

INSERT INTO Categorias (Nombre) VALUES 
('Muebles'), 
('Artes Decorativas'), 
('Joyería'), 
('Armas y Armaduras');

INSERT INTO Epocas (Nombre) VALUES 
('Renacimiento'), 
('Barroco'), 
('Victorian'), 
('Art Deco');

INSERT INTO EstadosConservacion (Nombre) VALUES 
('Excelente'), 
('Bueno'), 
('Regular'), 
('Deficiente');


INSERT INTO Antiguedades (Nombre, Descripcion, CategoriaID, EpocaID, EstadoConservacionID, Precio, DisponibilidadID) VALUES 
('Sillón Barroco', 'Sillón de estilo barroco con tallados elaborados.', (SELECT CategoriaID FROM Categorias WHERE Nombre = 'Muebles'), (SELECT EpocaID FROM Epocas WHERE Nombre = 'Barroco'), (SELECT EstadoConservacionID FROM EstadosConservacion WHERE Nombre = 'Excelente'), 1500.00, (SELECT DisponibilidadID FROM Disponibilidad WHERE Nombre = 'en venta')),
('Anillo de Rubí', 'Anillo antiguo con un rubí grande en el centro.', (SELECT CategoriaID FROM Categorias WHERE Nombre = 'Joyería'), (SELECT EpocaID FROM Epocas WHERE Nombre = 'Renacimiento'), (SELECT EstadoConservacionID FROM EstadosConservacion WHERE Nombre = 'Bueno'), 5000.00, (SELECT DisponibilidadID FROM Disponibilidad WHERE Nombre = 'en venta')),
('Espada Medieval', 'Espada de origen medieval con grabados.', (SELECT CategoriaID FROM Categorias WHERE Nombre = 'Armas y Armaduras'), (SELECT EpocaID FROM Epocas WHERE Nombre = 'Victorian'), (SELECT EstadoConservacionID FROM EstadosConservacion WHERE Nombre = 'Regular'), 3000.00, (SELECT DisponibilidadID FROM Disponibilidad WHERE Nombre = 'en venta'));

INSERT INTO Usuarios (Nombre, Email, Contrasena, RolID, PerfilID) VALUES 
('Ana López', 'ana@example.com', 'contraseña123', (SELECT RolID FROM Roles WHERE Nombre = 'vendedor'), (SELECT PerfilID FROM Perfiles WHERE Nombre = 'cliente')),
('Luis Pérez', 'luis@example.com', 'contraseña456', (SELECT RolID FROM Roles WHERE Nombre = 'comprador'), (SELECT PerfilID FROM Perfiles WHERE Nombre = 'coleccionista')),
('Marta Gómez', 'marta@example.com', 'contraseña789', (SELECT RolID FROM Roles WHERE Nombre = 'administrador'), (SELECT PerfilID FROM Perfiles WHERE Nombre = 'cliente'));


INSERT INTO Transacciones (AntiguedadID, VendedorID, CompradorID, Precio, MetodoPagoID, FechaEntrega) VALUES 
((SELECT AntiguedadID FROM Antiguedades WHERE Nombre = 'Sillón Barroco'), (SELECT UsuarioID FROM Usuarios WHERE Nombre = 'Ana López'), (SELECT UsuarioID FROM Usuarios WHERE Nombre = 'Luis Pérez'), 1500.00, (SELECT MetodoPagoID FROM MetodoPago WHERE Nombre = 'tarjeta'), '2024-09-20'),
((SELECT AntiguedadID FROM Antiguedades WHERE Nombre = 'Anillo de Rubí'), (SELECT UsuarioID FROM Usuarios WHERE Nombre = 'Ana López'), (SELECT UsuarioID FROM Usuarios WHERE Nombre = 'Luis Pérez'), 5000.00, (SELECT MetodoPagoID FROM MetodoPago WHERE Nombre = 'transferencia'), '2024-09-25');


INSERT INTO Actividades (UsuarioID, TipoActividadID, Detalle) VALUES 
((SELECT UsuarioID FROM Usuarios WHERE Nombre = 'Luis Pérez'), (SELECT TipoActividadID FROM TipoActividad WHERE Nombre = 'consulta'), 'Sillón Barroco'),
((SELECT UsuarioID FROM Usuarios WHERE Nombre = 'Luis Pérez'), (SELECT TipoActividadID FROM TipoActividad WHERE Nombre = 'consulta'), 'Consulta sobre el Anillo de Rubí');


INSERT INTO Inventario (AntiguedadID, Cantidad) VALUES 
((SELECT AntiguedadID FROM Antiguedades WHERE Nombre = 'Sillón Barroco'), 1),
((SELECT AntiguedadID FROM Antiguedades WHERE Nombre = 'Anillo de Rubí'), 1),
((SELECT AntiguedadID FROM Antiguedades WHERE Nombre = 'Espada Medieval'), 1);
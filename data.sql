-- =============================
--  EJERCICIO 5 (data)
-- =============================

-- --------------------
--  POBLAR TABLAS
-- --------------------

-- Tabla: Usuario
INSERT INTO Usuario (nombre, telefono, correo) VALUES
('María González', '555-123-4567', 'maria.gonzalez@email.com'),
('Juan Pérez', '555-234-5678', 'juan.perez@email.com'),
('Ana Rodríguez', '555-345-6789', 'ana.rodriguez@email.com'),
('Carlos Sánchez', '555-456-7890', 'carlos.sanchez@email.com'),
('Laura Martínez', '555-567-8901', 'laura.martinez@email.com'),
('Pedro López', '555-678-9012', 'pedro.lopez@email.com'),
('Sofía Ramírez', '555-789-0123', 'sofia.ramirez@email.com'),
('Jorge Torres', '555-890-1234', 'jorge.torres@email.com'),
('Elena Castro', '555-901-2345', 'elena.castro@email.com'),
('Miguel Ruiz', '555-012-3456', 'miguel.ruiz@email.com');

-- Tabla: Categoria
INSERT INTO Categoria (nombre) VALUES
('Decoración'),
('Papelería'),
('Ropa'),
('Juguetes'),
('Repostería');

-- Tabla: Tematica
INSERT INTO Tematica (nombre) VALUES
('Superhéroes'),
('Princesas'),
('Piratas'),
('Dinosaurios'),
('Espacio');

-- Tabla: Articulo
INSERT INTO Articulo (nombre, precio, stock, id_categoria, id_tematica) VALUES
('Globos de Superhéroes (paq. 10)', 12.99, 50, 1, 1),
('Mantel de Spiderman', 8.50, 30, 1, 1),
('Invitaciones de Batman', 15.75, 100, 2, 1),
('Corona de Princesa', 5.99, 40, 3, 2),
('Utencilios de Frozen', 22.50, 25, 1, 2),
('Centro de mesa de Cenicienta', 18.00, 15, 1, 2),
('Parche para ojo pirata', 3.25, 60, 3, 3),
('Bandera pirata', 7.99, 35, 1, 3),
('Cofre del tesoro', 14.50, 20, 1, 3),
('Figuras de dinosaurios (set de 6)', 9.99, 45, 4, 4),
('Gorra de dinosaurio', 6.75, 30, 3, 4),
('Molde de dinosaurio para pastel', 11.25, 15, 5, 4),
('Linternas espaciales', 10.50, 40, 1, 5),
('Cohetes de cartón', 7.25, 50, 1, 5),
('Guirnalda de estrellas', 5.99, 60, 1, 5);

-- Tabla: Transaccion
INSERT INTO Transaccion (id_usuario, fecha, total, estado) VALUES
(1, '2023-01-15', 34.48, 'Completado'),
(2, '2023-01-16', 40.47, 'Completado'),
(3, '2023-01-17', 38.73, 'Completado'),
(4, '2023-01-18', 23.49, 'Completado'),
(5, '2023-01-19', 60.50, 'Completado'),
(6, '2023-01-20', 31.50, 'Cancelado'),
(7, '2023-01-21', 32.50, 'Completado'),
(8, '2023-01-22', 23.23, 'Completado'),
(9, '2023-01-23', 28.74, 'Completado'),
(10, '2023-01-24', 54.75, 'Completado'),
(1, '2023-02-10', 20.48, 'Completado'),
(2, '2023-02-11', 25.99, 'Completado'),
(3, '2023-02-12', 19.98, 'Cancelado'),
(4, '2023-02-13', 33.00, 'Completado'),
(5, '2023-02-14', 41.73, 'Completado'),
(6, '2023-02-15', 35.50, 'Completado'),
(7, '2023-02-16', 28.00, 'Completado'),
(8, '2023-02-17', 38.97, 'Completado'),
(9, '2023-02-18', 26.47, 'Completado'),
(10, '2023-02-19', 33.98, 'Completado'),
(1, '2023-03-05', 21.24, 'Completado'),
(2, '2023-03-06', 27.49, 'Completado'),
(3, '2023-03-07', 38.25, 'Completado'),
(4, '2023-03-08', 16.25, 'Cancelado'),
(5, '2023-03-09', 21.25, 'Completado'),
(6, '2023-03-10', 43.48, 'Completado'),
(7, '2023-03-11', 20.48, 'Completado'),
(8, '2023-03-12', 25.99, 'Completado'),
(9, '2023-03-13', 31.23, 'Completado'),
(10, '2023-03-14', 41.99, 'Completado');

-- Tabla: DetalleTrasaccion
INSERT INTO DetalleTransaccion (id_transaccion, id_articulo, cantidad, subtotal) VALUES
-- Pedido 1
(1, 1, 2, 25.98),
(1, 2, 1, 8.50),
-- Pedido 2
(2, 4, 3, 17.97),
(2, 5, 1, 22.50),
-- Pedido 3
(3, 7, 5, 22.75),
(3, 8, 2, 15.98),
-- Pedido 4
(4, 10, 1, 9.99),
(4, 11, 2, 13.50),
-- Pedido 5
(5, 13, 3, 31.50),
(5, 14, 4, 29.00),
-- Pedido 6 (cancelado)
(6, 3, 2, 31.50),
-- Pedido 7
(7, 6, 1, 18.00),
(7, 9, 1, 14.50),
-- Pedido 8
(8, 12, 1, 11.25),
(8, 15, 2, 11.98),
-- Pedido 9
(9, 1, 1, 12.99),
(9, 3, 1, 15.75),
-- Pedido 10
(10, 5, 2, 45.00),
(10, 7, 3, 9.75),
-- Pedido 11
(11, 2, 1, 8.50),
(11, 4, 2, 11.98),
-- Pedido 12
(12, 6, 1, 18.00),
(12, 8, 1, 7.99),
-- Pedido 13 (cancelado)
(13, 10, 2, 19.98),
-- Pedido 14
(14, 12, 1, 11.25),
(14, 14, 3, 21.75),
-- Pedido 15
(15, 1, 2, 25.98),
(15, 3, 1, 15.75),
-- Pedido 16
(16, 5, 1, 22.50),
(16, 7, 4, 13.00),
-- Pedido 17
(17, 9, 1, 14.50),
(17, 11, 2, 13.50),
-- Pedido 18
(18, 13, 2, 21.00),
(18, 15, 3, 17.97),
-- Pedido 19
(19, 2, 1, 8.50),
(19, 4, 3, 17.97),
-- Pedido 20
(20, 6, 1, 18.00),
(20, 8, 2, 15.98),
-- Pedido 21
(21, 10, 1, 9.99),
(21, 12, 1, 11.25),
-- Pedido 22
(22, 14, 2, 14.50),
(22, 1, 1, 12.99),
-- Pedido 23
(23, 3, 1, 15.75),
(23, 5, 1, 22.50),
-- Pedido 24 (cancelado)
(24, 7, 5, 16.25),
-- Pedido 25
(25, 9, 1, 14.50),
(25, 11, 1, 6.75),
-- Pedido 26
(26, 13, 3, 31.50),
(26, 15, 2, 11.98),
-- Pedido 27
(27, 2, 1, 8.50),
(27, 4, 2, 11.98),
-- Pedido 28
(28, 6, 1, 18.00),
(28, 8, 1, 7.99),
-- Pedido 29
(29, 10, 2, 19.98),
(29, 12, 1, 11.25),
-- Pedido 30
(30, 14, 4, 29.00),
(30, 1, 1, 12.99);

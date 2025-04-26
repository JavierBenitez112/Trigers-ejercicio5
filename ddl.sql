-- =============================
--  EJERCICIO 5 (ddl)
-- =============================

-- -----------------------------
--  ELIMINAR TABLAS
-- -----------------------------

DROP TABLE IF EXISTS Usuario CASCADE;
DROP TABLE IF EXISTS Categoria CASCADE;
DROP TABLE IF EXISTS Tematica CASCADE;
DROP TABLE IF EXISTS Articulo CASCADE;
DROP TABLE IF EXISTS Transaccion CASCADE;
DROP TABLE IF EXISTS DetalleTransaccion CASCADE;

-- -----------------------------
--  CREAR TABLAS (NECESARIAS)
-- -----------------------------

-- Tabla: Usuario
CREATE TABLE Usuario (
    id_usuario SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) UNIQUE NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL
);

-- Tabla: Categoria
CREATE TABLE Categoria (
    id_categoria SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Tabla: Tematica
CREATE TABLE Tematica (
    id_tematica SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Tabla: Articulo
CREATE TABLE Articulo (
    id_articulo SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL,
    id_categoria INT NOT NULL,
    id_tematica INT NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria),
    FOREIGN KEY (id_tematica) REFERENCES Tematica(id_tematica)
);

-- Tabla: Transaccion
CREATE TABLE Transaccion (
    id_transaccion SERIAL PRIMARY KEY,
    id_usuario INT NOT NULL,
    fecha DATE NOT NULL DEFAULT CURRENT_TIMESTAMP,
	total DECIMAL(10, 2) NOT NULL,
    estado VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);

-- Tabla: DetalleTransaccion
CREATE TABLE DetalleTransaccion (
    id_detalle SERIAL PRIMARY KEY,
    id_transaccion INT NOT NULL,
    id_articulo INT NOT NULL,
    cantidad INT NOT NULL,
	subtotal DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_transaccion) REFERENCES Transaccion(id_transaccion),
    FOREIGN KEY (id_articulo) REFERENCES Articulo(id_articulo)
);

-- -----------------------------
--  CREAR TABLAS (EXTRAS)
-- -----------------------------
/*
Estas tablas se incluyen porque forman parte de la lógica de algún trigger. No son realmente
necesarias para modelar el sistema planteado (Tienda de Decoraciones Temáticas).
*/

-- Tabla: Auditoria
CREATE TABLE Auditoria (
    id_auditoria SERIAL PRIMARY KEY,
    tabla VARCHAR(50) NOT NULL,
    operacion VARCHAR(20) NOT NULL,
    usuario VARCHAR(100) NOT NULL,
    fecha TIMESTAMP NOT NULL
);

-- Tabla: Notificaciones
CREATE TABLE IF NOT EXISTS Notificaciones (
    id_notificacion SERIAL PRIMARY KEY,
    tipo VARCHAR(50) NOT NULL,
    mensaje TEXT NOT NULL,
    fecha TIMESTAMP NOT NULL,
    leido BOOLEAN DEFAULT FALSE
);

-- Tabla: HistorialArticulos
CREATE TABLE IF NOT EXISTS HistorialArticulos (
    id_historial SERIAL PRIMARY KEY,
    id_articulo_original INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    fecha_eliminacion TIMESTAMP NOT NULL,
    accion VARCHAR(20) NOT NULL
);

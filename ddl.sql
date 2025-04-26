-- Tabla: Usuario
CREATE TABLE Usuario (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    correo VARCHAR(100) UNIQUE NOT NULL
);

-- Tabla: Tematica
CREATE TABLE Tematica (
    id_tematica INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL
);

-- Tabla: Articulo
CREATE TABLE Articulo (
    id_articulo INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    cantidad INT NOT NULL,
    categoria VARCHAR(50),
    id_tematica INT,
    FOREIGN KEY (id_tematica) REFERENCES Tematica(id_tematica)
);

-- Tabla: Transaccion
CREATE TABLE Transaccion (
    id_transaccion INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);

-- Tabla: DetalleTransaccion
CREATE TABLE DetalleTransaccion (
    id_detalle INT PRIMARY KEY AUTO_INCREMENT,
    id_transaccion INT,
    id_articulo INT,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_transaccion) REFERENCES Transaccion(id_transaccion),
    FOREIGN KEY (id_articulo) REFERENCES Articulo(id_articulo)
);

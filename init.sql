-- 1. Comprobador de existencia de la base de datos
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'MarketDB')
BEGIN
    CREATE DATABASE MarketDB;
END
GO

USE MarketDB;
GO

-- 2. Creación de Tablas con restricción NOT NULL en todos los campos clave

-- Tabla USUARIO [cite: 192]
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[USUARIO]') AND type in (N'U'))
BEGIN
    CREATE TABLE USUARIO (
        id_usuario VARCHAR(10) NOT NULL PRIMARY KEY,
        nombres VARCHAR(100) NOT NULL,
        apellidos VARCHAR(100) NOT NULL,
        correo VARCHAR(150) NOT NULL UNIQUE,
        telefono VARCHAR(15) NOT NULL,
        rol VARCHAR(15) NOT NULL CHECK (rol IN ('comprador', 'vendedor', 'administrador')),
        estado_cuenta VARCHAR(15) NOT NULL
    );
END

-- Tabla CATEGORIA [cite: 193]
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CATEGORIA]') AND type in (N'U'))
BEGIN
    CREATE TABLE CATEGORIA (
        id_categoria VARCHAR(10) NOT NULL PRIMARY KEY,
        nombre_categoria VARCHAR(30) NOT NULL,
        descripcion_categoria TEXT NOT NULL,
        estado_categoria VARCHAR(10) NOT NULL
    );
END

-- Tabla PRODUCTO [cite: 194]
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PRODUCTO]') AND type in (N'U'))
BEGIN
    CREATE TABLE PRODUCTO (
        id_producto VARCHAR(10) NOT NULL PRIMARY KEY,
        nombre_producto VARCHAR(20) NOT NULL,
        descripcion_producto TEXT NOT NULL,
        marca VARCHAR(30) NOT NULL,
        modelo VARCHAR(30) NOT NULL,
        id_categoria VARCHAR(10) NOT NULL,
        CONSTRAINT FK_Producto_Categoria FOREIGN KEY (id_categoria) REFERENCES CATEGORIA(id_categoria)
    );
END

-- Tabla IMAGEN_PRODUCTO [cite: 195]
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IMAGEN_PRODUCTO]') AND type in (N'U'))
BEGIN
    CREATE TABLE IMAGEN_PRODUCTO (
        id_imagen VARCHAR(10) NOT NULL PRIMARY KEY,
        id_producto VARCHAR(10) NOT NULL,
        url_imagen TEXT NOT NULL,
        CONSTRAINT FK_Imagen_Producto FOREIGN KEY (id_producto) REFERENCES PRODUCTO(id_producto)
    );
END

-- Tabla PEDIDO [cite: 201]
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PEDIDO]') AND type in (N'U'))
BEGIN
    CREATE TABLE PEDIDO (
        id_pedido VARCHAR(10) NOT NULL PRIMARY KEY,
        id_usuario VARCHAR(10) NOT NULL,
        fecha_pedido DATETIME NOT NULL DEFAULT GETDATE(),
        total_pedido DECIMAL(10,2) NOT NULL,
        estado_pedido VARCHAR(15) NOT NULL,
        direccion_envio VARCHAR(100) NOT NULL,
        CONSTRAINT FK_Pedido_Usuario FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario)
    );
END

-- Tabla DETALLE_PEDIDO [cite: 202]
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DETALLE_PEDIDO]') AND type in (N'U'))
BEGIN
    CREATE TABLE DETALLE_PEDIDO (
        id_detalle_pedido VARCHAR(10) NOT NULL PRIMARY KEY,
        id_pedido VARCHAR(10) NOT NULL,
        id_producto VARCHAR(10) NOT NULL,
        cantidad INT NOT NULL,
        precio_unitario DECIMAL(10,2) NOT NULL,
        subtotal DECIMAL(10,2) NOT NULL,
        CONSTRAINT FK_Detalle_Pedido FOREIGN KEY (id_pedido) REFERENCES PEDIDO(id_pedido),
        CONSTRAINT FK_Detalle_Producto FOREIGN KEY (id_producto) REFERENCES PRODUCTO(id_producto)
    );
END

-- Tabla PAGO [cite: 200]
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PAGO]') AND type in (N'U'))
BEGIN
    CREATE TABLE PAGO (
        id_pago VARCHAR(10) NOT NULL PRIMARY KEY,
        id_pedido VARCHAR(10) NOT NULL,
        metodo_pago VARCHAR(30) NOT NULL,
        monto_pagado DECIMAL(10,2) NOT NULL,
        fecha_pago DATETIME NOT NULL,
        estado_pago VARCHAR(20) NOT NULL,
        CONSTRAINT FK_Pago_Pedido FOREIGN KEY (id_pedido) REFERENCES PEDIDO(id_pedido)
    );
END

-- Tabla RESEÑAS 
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[RESENAS]') AND type in (N'U'))
BEGIN
    CREATE TABLE RESENAS (
        id_reseña VARCHAR(10) NOT NULL PRIMARY KEY,
        id_usuario_evaluador VARCHAR(10) NOT NULL,
        id_usuario_evaluado VARCHAR(10) NOT NULL,
        id_producto VARCHAR(10) NOT NULL,
        calificacion_estrellas INT NOT NULL CHECK (calificacion_estrellas BETWEEN 1 AND 5),
        comentario TEXT NOT NULL,
        fecha_reseña DATETIME NOT NULL,
        CONSTRAINT FK_Resena_Evaluador FOREIGN KEY (id_usuario_evaluador) REFERENCES USUARIO(id_usuario),
        CONSTRAINT FK_Resena_Evaluado FOREIGN KEY (id_usuario_evaluado) REFERENCES USUARIO(id_usuario),
        CONSTRAINT FK_Resena_Producto FOREIGN KEY (id_producto) REFERENCES PRODUCTO(id_producto)
    );
END

-- Tabla COMENTARIOS [cite: 196]
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[COMENTARIOS]') AND type in (N'U'))
BEGIN
    CREATE TABLE COMENTARIOS (
        id_comentario VARCHAR(10) NOT NULL PRIMARY KEY,
        id_usuario VARCHAR(10) NOT NULL,
        id_producto VARCHAR(10) NOT NULL,
        id_comentario_padre VARCHAR(10) NULL, -- Se mantiene NULL solo para comentarios raíz sin padre 
        contenido TEXT NOT NULL,
        fecha_comentario DATETIME NOT NULL,
        estado_comentario VARCHAR(10) NOT NULL,
        CONSTRAINT FK_Comentario_Usuario FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario),
        CONSTRAINT FK_Comentario_Producto FOREIGN KEY (id_producto) REFERENCES PRODUCTO(id_producto),
        CONSTRAINT FK_Comentario_Padre FOREIGN KEY (id_comentario_padre) REFERENCES COMENTARIOS(id_comentario)
    );
END

-- Tabla GUARDADOS [cite: 197]
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GUARDADOS]') AND type in (N'U'))
BEGIN
    CREATE TABLE GUARDADOS (
        id_guardado VARCHAR(10) NOT NULL PRIMARY KEY,
        id_usuario VARCHAR(10) NOT NULL,
        id_producto VARCHAR(10) NOT NULL,
        fecha_guardada DATETIME NOT NULL,
        CONSTRAINT FK_Guardado_Usuario FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario),
        CONSTRAINT FK_Guardado_Producto FOREIGN KEY (id_producto) REFERENCES PRODUCTO(id_producto)
    );
END

-- Tabla DENUNCIAS [cite: 199]
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DENUNCIAS]') AND type in (N'U'))
BEGIN
    CREATE TABLE DENUNCIAS (
        id_denuncia VARCHAR(10) NOT NULL PRIMARY KEY,
        id_usuario VARCHAR(10) NOT NULL,
        id_producto VARCHAR(10) NOT NULL,
        motivo TEXT NOT NULL,
        descripcion_denuncia TEXT NOT NULL,
        fecha_denuncia DATETIME NOT NULL,
        estado_denuncia VARCHAR(10) NOT NULL,
        CONSTRAINT FK_Denuncia_Usuario FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario),
        CONSTRAINT FK_Denuncia_Producto FOREIGN KEY (id_producto) REFERENCES PRODUCTO(id_producto)
    );
END
GO
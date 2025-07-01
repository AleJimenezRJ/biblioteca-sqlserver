/*

TAREA # 3 Y # 4 - Practica de Implementacion de una Base de Datos

Estudiante: Alejandro Jimenez Rojas
Carnet: C04079

Este archivo contiene el codigo para la creacion de la base de datos (esquemas, tablas, llaves primarias, llaves foraneas e indices)

*/

-- Crear la base de datos
CREATE DATABASE Biblioteca;
GO

USE Biblioteca;
GO

-- Crear esquemas
DROP SCHEMA IF EXISTS usr;
GO
CREATE SCHEMA usr; -- Para los usuarios
GO
DROP SCHEMA IF EXISTS lib;
GO
CREATE SCHEMA lib; -- Para los libros
GO

-- Tablas

-- Crear tabla de Usuarios en esquema usr con todos los atributos de los usuarios
CREATE TABLE usr.Usuario (
    LlaveInterna INT NOT NULL PRIMARY KEY CLUSTERED IDENTITY(1,1),
    Correo NVARCHAR(100) NOT NULL UNIQUE, -- El correo debe ser unico
    Nombre NVARCHAR(100) NOT NULL, -- Se trabaja nombres en general con un NVARCHAR(100) para dar un tamaño relativamente generoso
    Apellido NVARCHAR(100) NOT NULL
);
GO

-- Crear tabla de Libros en esquema lib
CREATE TABLE lib.Libro (
    LlaveInterna INT NOT NULL PRIMARY KEY CLUSTERED IDENTITY(1,1),
    ISBN NVARCHAR(20) NOT NULL UNIQUE, -- Valor único, se usan NVARCHAR(20) debido a que suele ser un valor entre unos 10 y 17 chars
    Titulo NVARCHAR(100) NOT NULL,
    Autor NVARCHAR(100) NOT NULL,
    Editorial NVARCHAR(100) NOT NULL,
    Anno INT NOT NULL,
    Estado BIT NOT NULL DEFAULT 0, -- Booleano para saber si esta disponible o no. 0 = Disponible, 1 = Prestado
    Tematica NVARCHAR(255) NULL -- Se da un valor bastante grande por si se quisiera meter un listado de temáticas separadas por comas
);
GO

-- Crear tabla para el registro de los prestamos
CREATE TABLE Prestamo (
    LlaveInterna INT PRIMARY KEY IDENTITY(1,1),
    CorreoUsuario NVARCHAR(100) NOT NULL, -- Se relaciona al ISBN y correo por ser los datos únicos
    ISBNLibro NVARCHAR(20) NOT NULL,
    FechaPrestamo DATE NOT NULL,
    FechaDevolucionPrevista DATE NOT NULL,
    FechaDevolucionReal DATE NULL,
    FOREIGN KEY (CorreoUsuario) REFERENCES usr.Usuario(Correo),
    FOREIGN KEY (ISBNLibro) REFERENCES lib.Libro(ISBN)
);
GO

-- Crear la tabla para registrar la bitacora de los prestamos y devoluciones. No se usa FK por persistencia de datos.
CREATE TABLE BitacoraPrestamos (
    LlaveInterna INT PRIMARY KEY IDENTITY(1,1), -- Igual que todos, usa llave interna
    CorreoUsuario NVARCHAR(100) NOT NULL,
    ISBNLibro NVARCHAR(20) NOT NULL,
    FechaOperacion DATETIME NOT NULL DEFAULT GETDATE(),
    TipoOperacion NVARCHAR(20) NOT NULL CHECK (TipoOperacion IN ('Prestamo', 'Devolucion')) -- 2 posibles actions
);
GO


-- Indices para intentar optimizar lo más que se pueda las consultas.

-- Para optimizar una consulta a la bitacora cuando se buscan los datos de un usuario especifico
CREATE NONCLUSTERED INDEX IX_Bitacora_Correo ON BitacoraPrestamos (CorreoUsuario, FechaOperacion);

-- Para la consulta de los 5 libros mas prestados
CREATE NONCLUSTERED INDEX IX_Prestamo ON Prestamo (ISBNLibro);

-- Para mejorar joins de tables
CREATE UNIQUE NONCLUSTERED INDEX IX_Libro_ISBN ON lib.Libro (ISBN);

-- Para mejorar joins de tables
CREATE UNIQUE NONCLUSTERED INDEX IX_Usuario_Correo ON usr.Usuario (Correo);

-- Para optimizar la consulta de los prestamos activos
CREATE NONCLUSTERED INDEX IX_Prestamos_Activos ON Prestamo (CorreoUsuario, FechaDevolucionReal)
WHERE FechaDevolucionReal IS NULL;

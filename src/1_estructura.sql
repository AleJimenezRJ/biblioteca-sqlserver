/*

TAREA # 3 Y # 4 - Practica de Implementacion de una Base de Datos

Estudiante: Alejandro Jimenez Rojas
Carnet: C04079

Este archivo contiene el codigo para la creacion de la base de datos (esquemas, tablas, llaves primarias, llaves foraneas e indices)

*/

-- Crear base de datos (es necesario o puedo asumir que ya?)
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

-- Crear tabla de Usuarios en esquema usr con todos los atributos de los usuarios
CREATE TABLE usr.Usuario (
    LlaveInterna INT NOT NULL PRIMARY KEY CLUSTERED IDENTITY(1,1),
    Correo NVARCHAR(255) NOT NULL UNIQUE, -- El correo debe ser unico
    Nombre NVARCHAR(100) NOT NULL,
    Apellido NVARCHAR(100) NOT NULL
);
GO

-- Crear tabla de Libros en esquema lib
CREATE TABLE lib.Libro (
    LlaveInterna INT NOT NULL PRIMARY KEY CLUSTERED IDENTITY(1,1),
    ISBN NVARCHAR(20) NOT NULL UNIQUE,
    Titulo NVARCHAR(255) NOT NULL,
    Autor NVARCHAR(255) NOT NULL,
    Editorial NVARCHAR(255) NOT NULL,
    Anno INT NOT NULL,
    Estado BIT NOT NULL DEFAULT 0, -- Booleano para saber si esta disponible o no. 0 = Disponible, 1 = Prestado
    Tematica NVARCHAR(255) NULL -- Esto se esperaraba que fuera un texto separado por comas
);
GO

-- Crear tabla de Prestamos
CREATE TABLE Prestamo (
    LlaveInterna INT PRIMARY KEY IDENTITY(1,1),
    CorreoUsuario NVARCHAR(255) NOT NULL,
    ISBNLibro NVARCHAR(20) NOT NULL,
    FechaPrestamo DATE NOT NULL,
    FechaDevolucionPrevista DATE NOT NULL,
    FechaDevolucionReal DATE NULL,
    FOREIGN KEY (CorreoUsuario) REFERENCES usr.Usuario(Correo),
    FOREIGN KEY (ISBNLibro) REFERENCES lib.Libro(ISBN)
);
GO

CREATE TABLE BitacoraPrestamos (
    LlaveInterna INT PRIMARY KEY IDENTITY(1,1),
    CorreoUsuario NVARCHAR(255) NOT NULL,
    ISBNLibro NVARCHAR(20) NOT NULL,
    FechaOperacion DATETIME NOT NULL DEFAULT GETDATE(),
    TipoOperacion NVARCHAR(20) NOT NULL CHECK (TipoOperacion IN ('Prestamo', 'Devolucion'))
);
GO


-- INDICES PENDIENTES
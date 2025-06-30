/*

TAREA # 3 Y # 4 - Practica de Implementación de una Base de Datos

Estudiante: Alejandro Jimenez Rojas
Carnet: C04079

Este archivo contiene el código para insertar datos de prueba que permitan ejecutar ejemplos de las funcionalidades.
Incluye todos los datos del anexo 1 de la tarea
*/

USE Biblioteca;
GO

-- Insertar libros (estado = 0 por defecto, disponibles)
INSERT INTO lib.Libro (ISBN, Titulo, Autor, Editorial, Anno, Tematica)
VALUES
('978-12345', 'Cien años de soledad', 'Gabriel García Márquez', 'Sudamericana', 1967, 'Literatura'),
('978-98765', 'Don Quijote de la Mancha', 'Miguel de Cervantes', 'EDAF', 1605, 'Literatura'),
('978-11111', 'Programación en C# para principiantes', 'Juan Pérez', 'Anaya', 2020, 'Técnicos'),
('978-22222', 'Historia de Leonardo da Vinci', 'Anna Smith', 'Arte Press', 2018, 'Arte'),
('978-33333', 'Viajes por la Patagonia', 'Carlos Mendoza', 'Geo Libros', 2015, 'Viajes'),
('978-44444', 'Recetas tradicionales de cocina italiana', 'María Rossi', 'Cocina Fácil', 2017, 'Cocina'),
('978-55555', 'Inteligencia Artificial para todos', 'Alan Turing', 'Tech Books', 2021, 'Técnicos'),
('978-66666', 'Autobiografía de Nelson Mandela', 'Nelson Mandela', 'Biografía Plus', 1994, 'Biográficos'),
('978-77777', 'Manual de fotografía creativa', 'Laura Gómez', 'Arte Press', 2019, 'Arte'),
('978-88888', 'Explorando el Himalaya', 'Tenzing Norgay', 'Montaña Ed.', 2010, 'Viajes');

-- Insertar usuarios
INSERT INTO usr.Usuario (Correo, Nombre, Apellido)
VALUES
('ana.gomez@example.com', 'Ana', 'Gómez'),
('luis.martinez@example.com', 'Luis', 'Martínez'),
('maria.fernandez@example.com', 'María', 'Fernández'),
('jose.rodriguez@example.com', 'José', 'Rodríguez'),
('carla.soto@example.com', 'Carla', 'Soto');
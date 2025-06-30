/*

TAREA # 3 Y # 4 - Practica de Implementacion de una Base de Datos

Estudiante: Alejandro Jimenez Rojas
Carnet: C04079

Este archivo contiene el codigo para insertar datos de prueba que permitan ejecutar ejemplos de las funcionalidades.
Incluye todos los datos del anexo 1 de la tarea
*/

USE Biblioteca;
GO

-- Insertar libros (estado = 0 por defecto, disponibles)
INSERT INTO lib.Libro (ISBN, Titulo, Autor, Editorial, Anno, Tematica)
VALUES
('978-12345', 'Cien a�os de soledad', 'Gabriel Garc�a M�rquez', 'Sudamericana', 1967, 'Literatura'),
('978-98765', 'Don Quijote de la Mancha', 'Miguel de Cervantes', 'EDAF', 1605, 'Literatura'),
('978-11111', 'Programaci�n en C# para principiantes', 'Juan P�rez', 'Anaya', 2020, 'T�cnicos'),
('978-22222', 'Historia de Leonardo da Vinci', 'Anna Smith', 'Arte Press', 2018, 'Arte'),
('978-33333', 'Viajes por la Patagonia', 'Carlos Mendoza', 'Geo Libros', 2015, 'Viajes'),
('978-44444', 'Recetas tradicionales de cocina italiana', 'Mar�a Rossi', 'Cocina F�cil', 2017, 'Cocina'),
('978-55555', 'Inteligencia Artificial para todos', 'Alan Turing', 'Tech Books', 2021, 'T�cnicos'),
('978-66666', 'Autobiograf�a de Nelson Mandela', 'Nelson Mandela', 'Biograf�a Plus', 1994, 'Biogr�ficos'),
('978-77777', 'Manual de fotograf�a creativa', 'Laura G�mez', 'Arte Press', 2019, 'Arte'),
('978-88888', 'Explorando el Himalaya', 'Tenzing Norgay', 'Monta�a Ed.', 2010, 'Viajes');

-- Insertar usuarios
INSERT INTO usr.Usuario (Correo, Nombre, Apellido)
VALUES
('ana.gomez@example.com', 'Ana', 'G�mez'),
('luis.martinez@example.com', 'Luis', 'Mart�nez'),
('maria.fernandez@example.com', 'Mar�a', 'Fern�ndez'),
('jose.rodriguez@example.com', 'Jos�', 'Rodr�guez'),
('carla.soto@example.com', 'Carla', 'Soto');

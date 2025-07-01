/*

TAREA # 3 Y # 4 - Práctica de Implementación de una Base de Datos

Estudiante: Alejandro Jimenez Rojas
Carnet: C04079

Este archivo contiene el código para ejemplificar las diferentes funcionalidades de la
base de datos. Contenido de cada ejemplo sacado del Anexo 2 del enunciado de la tarea
*/


USE Biblioteca;
GO

-- Insertar un nuevo libro
EXEC lib.RegistrarLibro
    @ISBN = '978-99999',
    @Titulo = 'La Odisea',
    @Autor = 'Homero',
    @Editorial = 'Clásicos Griegos',
    @Anno = 800,
    @Tematica = 'Literatura';

-- Insertar un nuevo usuario
EXEC usr.RegistrarUsuario
    @Correo = 'sofia.ramirez@example.com',
    @Nombre = 'Sofía',
    @Apellido = 'Ramírez';

-- Registro de prestamo
EXEC RegistrarPrestamo
    @CorreoUsuario = 'ana.gomez@example.com',
    @ISBNLibro = '978-12345',
    @FechaPrestamo = '2025-07-01',
    @FechaDevolucionPrevista = '2025-07-15';

-- Registrar 3 prestamos para más adelante probar la cantidad de prestamos
EXEC RegistrarPrestamo
    @CorreoUsuario = 'sofia.ramirez@example.com',
    @ISBNLibro = '978-11111',
    @FechaPrestamo = '2025-07-01',
    @FechaDevolucionPrevista = '2025-07-15';

EXEC RegistrarPrestamo
    @CorreoUsuario = 'sofia.ramirez@example.com',
    @ISBNLibro = '978-22222',
    @FechaPrestamo = '2025-07-01',
    @FechaDevolucionPrevista = '2025-07-15';

EXEC RegistrarPrestamo
    @CorreoUsuario = 'sofia.ramirez@example.com',
    @ISBNLibro = '978-98765',
    @FechaPrestamo = '2025-07-01',
    @FechaDevolucionPrevista = '2025-07-15';

-- Registro de devolucion
EXEC RegistrarDevolucion
    @CorreoUsuario = 'ana.gomez@example.com',
    @ISBNLibro = '978-12345',
    @FechaDevolucionReal = '2025-07-10';

-- Consultar historico de prestamos y devoluciones para la usuaria ana.gomez@example.com

SELECT 
    CorreoUsuario,
    ISBNLibro,
    FechaOperacion,
    TipoOperacion
FROM BitacoraPrestamos
WHERE CorreoUsuario = 'ana.gomez@example.com'
ORDER BY FechaOperacion;


-- Consultar los 5 libros mas prestados

SELECT * FROM lib.Top5LibrosMasPrestados;

-- Consultar los usuarios con mas de 2 prestamos activos (Fecha devolucion real = NULL)

SELECT * FROM usr.UsuariosConMasDeDosPrestamosActivos;


/*

TAREA # 3 Y # 4 - Practica de Implementacion de una Base de Datos

Estudiante: Alejandro Jimenez Rojas
Carnet: C04079

Este archivo contiene el codigo de los demas objetos para la base de datos, es decir,
store procedures, functions, views y triggers. Necesarios para las funcionalidades de la base.
*/

USE Biblioteca;
GO

/*
Registrar los libros en la biblioteca

Se implenta esta funcionalidad por medio de un stored procedure, esto debido a que
se necesita el manejo de parametros y modificar las tablas insertando datos

No recibe como parametro el estado porque siempre esta disponible al agregarlo
*/
CREATE OR ALTER PROCEDURE lib.RegistrarLibro
    @ISBN NVARCHAR(20),
    @Titulo NVARCHAR(255),
    @Autor NVARCHAR(255),
    @Editorial NVARCHAR(255),
    @Anno INT,
    @Tematica NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Estado BIT; -- Por defecto, el libro est� disponible
    SET @Estado = 0;
    PRINT 'Iniciando procedimiento de registro de libro...';
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL SERIALIZABLE; -- M�s alto nivel de aislamiento para impedir errores
        BEGIN TRANSACTION;
        -- Verificar si el ISBN ya existe
        IF EXISTS (SELECT 1 FROM lib.Libro WHERE ISBN = @ISBN)
        BEGIN
            PRINT 'Error: El ISBN ya existe en la base de datos.';
            ROLLBACK TRANSACTION;
            RETURN;
        END
        -- Insertar nuevo libro
        INSERT INTO lib.Libro (ISBN, Titulo, Autor, Editorial, Anno, Tematica, Estado)
        VALUES (@ISBN, @Titulo, @Autor, @Editorial, @Anno, @Tematica, @Estado);
        PRINT 'Libro registrado exitosamente.';
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        PRINT 'Se produjo un error durante el registro del libro.'; -- Si ISBN o algun dato fuera NULL
        ROLLBACK TRANSACTION;
    END CATCH
END;
GO

/*
Registrar los usuarios en la biblioteca

Se implenta esta funcionalidad por medio de un stored procedure, esto debido a que
se necesita el manejo de parametros y modificar las tablas insertando datos

*/

CREATE OR ALTER PROCEDURE usr.RegistrarUsuario
    @Correo NVARCHAR(255),
    @Nombre NVARCHAR(100),
    @Apellido NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    PRINT 'Iniciando procedimiento de registro de usuario...';
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
        BEGIN TRANSACTION;
        -- Verificar si el correo ya existe
        IF EXISTS (SELECT 1 FROM usr.Usuario WHERE Correo = @Correo)
        BEGIN
            PRINT 'Error: El correo ya est� registrado en el sistema.';
            ROLLBACK TRANSACTION;
            RETURN;
        END
        -- Insertar nuevo usuario
        INSERT INTO usr.Usuario (Correo, Nombre, Apellido)
        VALUES (@Correo, @Nombre, @Apellido);
        PRINT 'Usuario registrado exitosamente.';
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        PRINT 'Se produjo un error durante el registro del usuario.';
        ROLLBACK TRANSACTION;
    END CATCH
END;
GO

/*
Registrar los prestamos de los libros realizados a los usuarios

Se implenta esta funcionalidad por medio de un stored procedure, esto debido a que
se necesita el manejo de parametros y modificar las tablas insertando datos
*/
CREATE OR ALTER PROCEDURE RegistrarPrestamo
    @CorreoUsuario NVARCHAR(255),
    @ISBNLibro NVARCHAR(20),
    @FechaPrestamo DATE,
    @FechaDevolucionPrevista DATE
AS
BEGIN
    SET NOCOUNT ON;
    PRINT 'Iniciando procedimiento de registro de prestamo...';
    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
        BEGIN TRANSACTION;
        -- Verificar si el libro ya esta prestado
        IF EXISTS (
            SELECT 1 FROM lib.Libro
            WHERE ISBN = @ISBNLibro AND Estado = 1
        )
        BEGIN
            PRINT 'Error: El libro ya esta en prestamo.';
            ROLLBACK TRANSACTION;
            RETURN;
        END
        -- Verificar si el usuario ya tiene 3 prestamos activos
        IF (
            SELECT COUNT(*)
            FROM Prestamo
            WHERE CorreoUsuario = @CorreoUsuario AND FechaDevolucionReal IS NULL
        ) >= 3
        BEGIN
            PRINT 'Error: El usuario ya tiene 3 prestamo activos.';
            ROLLBACK TRANSACTION;
            RETURN;
        END                 
        -- Registrar el pr�stamo
        INSERT INTO Prestamo (
            CorreoUsuario,
            ISBNLibro,
            FechaPrestamo,
            FechaDevolucionPrevista,
            FechaDevolucionReal
        )
        VALUES (
            @CorreoUsuario,
            @ISBNLibro,
            @FechaPrestamo,
            @FechaDevolucionPrevista,
            NULL -- Aun no devuelto
        );
        -- Actualizar estado del libro a 'Prestado' (1)
        UPDATE lib.Libro
        SET Estado = 1
        WHERE ISBN = @ISBNLibro;

        PRINT 'Prestamo registrado exitosamente.';
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        PRINT 'Se produjo un error al registrar el prestamo.';
        ROLLBACK TRANSACTION;
    END CATCH
END;
GO

/*
Registrar las devoluciones de los libros

Se implenta esta funcionalidad por medio de un stored procedure, esto debido a que
se necesita el manejo de parametros y modificar las tablas insertando datos
*/
CREATE OR ALTER PROCEDURE RegistrarDevolucion
    @CorreoUsuario NVARCHAR(255),
    @ISBNLibro NVARCHAR(20),
    @FechaDevolucionReal DATE
AS
BEGIN
    SET NOCOUNT ON;
    PRINT 'Iniciando procedimiento de registro de devolucion...';

    BEGIN TRY
        SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
        BEGIN TRANSACTION;
        -- Verificar si existe un pr�stamo activo para ese usuario y libro
        IF NOT EXISTS (
            SELECT 1
            FROM Prestamo
            WHERE CorreoUsuario = @CorreoUsuario
              AND ISBNLibro = @ISBNLibro
              AND FechaDevolucionReal IS NULL
        )
        BEGIN
            PRINT 'Error: No existe un prestamo activo para este usuario y libro.';
            ROLLBACK TRANSACTION;
            RETURN;
        END
        -- Actualizar prestamo con la fecha de devoluci�n real
        UPDATE Prestamo
        SET FechaDevolucionReal = @FechaDevolucionReal
        WHERE CorreoUsuario = @CorreoUsuario
          AND ISBNLibro = @ISBNLibro
          AND FechaDevolucionReal IS NULL;
        -- Marcar el libro como disponible
        UPDATE lib.Libro
        SET Estado = 0
        WHERE ISBN = @ISBNLibro;
        PRINT 'Devolucion registrada exitosamente.';
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        PRINT 'Se produjo un error al registrar la devolucion.';
        ROLLBACK TRANSACTION;
    END CATCH
END;
GO



/*
Bitacora de los prestamos y las devoluciones que realizan los usuarios
Permite consultar el historico de los prestamos y las devoluciones realizadas por un usuario
Se implemento usando un trigger, esto porque permiten automatizar el registro en la bitacora.
*/
CREATE OR ALTER TRIGGER TR_BitacoraPrestamos ON Prestamo
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Registrar nuevos prestamos (inserciones con FechaDevolucionReal = NULL)
    INSERT INTO BitacoraPrestamos (CorreoUsuario, ISBNLibro, FechaOperacion, TipoOperacion)
    SELECT
        i.CorreoUsuario,
        i.ISBNLibro,
        GETDATE(),
        'Prestamo'
    FROM inserted i
    WHERE i.FechaDevolucionReal IS NULL
      AND NOT EXISTS (
          SELECT 1
          FROM deleted d
          WHERE d.LlaveInterna = i.LlaveInterna
      );

    -- Registrar devoluciones (actualizaciones que cambian FechaDevolucionReal de NULL a valor)
    INSERT INTO BitacoraPrestamos (CorreoUsuario, ISBNLibro, FechaOperacion, TipoOperacion)
    SELECT
        i.CorreoUsuario,
        i.ISBNLibro,
        GETDATE(),
        'Devolucion'
    FROM inserted i
    JOIN deleted d ON i.LlaveInterna = d.LlaveInterna
    WHERE d.FechaDevolucionReal IS NULL
      AND i.FechaDevolucionReal IS NOT NULL;
END;
GO


/*
Consultar los cinco libros mas prestados

*/
CREATE OR ALTER VIEW Top5LibrosMasPrestados AS
SELECT TOP 5
    p.ISBNLibro,
    l.Titulo,
    COUNT(*) AS VecesPrestado
FROM Prestamo p
JOIN lib.Libro l ON p.ISBNLibro = l.ISBN
GROUP BY p.ISBNLibro, l.Titulo
ORDER BY VecesPrestado DESC;
GO


/*
Consultar los usuarios con mas de dos prestamos activos, es decir, para los que no se haya
realizado la devolucion
*/

CREATE OR ALTER VIEW UsuariosConMasDeDosPrestamosActivos AS
SELECT 
    u.Correo,
    u.Nombre,
    u.Apellido,
    COUNT(p.LlaveInterna) AS CantidadDePrestamosActivos
FROM usr.Usuario u
JOIN Prestamo p ON u.Correo = p.CorreoUsuario
WHERE p.FechaDevolucionReal IS NULL
GROUP BY u.Correo, u.Nombre, u.Apellido
HAVING COUNT(p.LlaveInterna) > 2;
GO

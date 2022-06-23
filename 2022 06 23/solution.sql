--****************************************************
-- Bases de datos: Transacciones y triggers
-- Autor: Douglas Hernández
-- Correspondencia: dohernandez@uca.edu.sv
-- Version: 1.0
--****************************************************

-- *****************************************************
-- 3.	Transacciones.
-- *****************************************************

-- IMPORTANTE:
-- Para poder realizar algunos ejercicion de esta clase es necesario actualizar la base 
-- de datos HotelManagementDB, por lo que se debe:
--		* Agregar la columna "puntos_cliente_frecuente" de tipo INT a la tabla CLIENTE.
--		* Actualizar la columna recien creada con algunos datos.

ALTER TABLE CLIENTE ADD puntos_cliente_frecuente INT;
SELECT * FROM CLIENTE;

UPDATE CLIENTE SET puntos_cliente_frecuente = 2310 WHERE id=1;
UPDATE CLIENTE SET puntos_cliente_frecuente = 4744 WHERE id=2;
UPDATE CLIENTE SET puntos_cliente_frecuente = 3626 WHERE id=3;
UPDATE CLIENTE SET puntos_cliente_frecuente = 2387 WHERE id=4;
UPDATE CLIENTE SET puntos_cliente_frecuente = 1233 WHERE id=5;
UPDATE CLIENTE SET puntos_cliente_frecuente = 4028 WHERE id=6;
UPDATE CLIENTE SET puntos_cliente_frecuente = 3089 WHERE id=7;
UPDATE CLIENTE SET puntos_cliente_frecuente = 4061 WHERE id=8;
UPDATE CLIENTE SET puntos_cliente_frecuente = 4051 WHERE id=9;
UPDATE CLIENTE SET puntos_cliente_frecuente = 1065 WHERE id=10;
UPDATE CLIENTE SET puntos_cliente_frecuente = 1759 WHERE id=11;
UPDATE CLIENTE SET puntos_cliente_frecuente = 2240 WHERE id=12;
UPDATE CLIENTE SET puntos_cliente_frecuente = 4889 WHERE id=13;
UPDATE CLIENTE SET puntos_cliente_frecuente = 2233 WHERE id=14;
UPDATE CLIENTE SET puntos_cliente_frecuente = 2021 WHERE id=15;
UPDATE CLIENTE SET puntos_cliente_frecuente = 2431 WHERE id=16;
UPDATE CLIENTE SET puntos_cliente_frecuente = 2751 WHERE id=17;
UPDATE CLIENTE SET puntos_cliente_frecuente = 2156 WHERE id=18;
UPDATE CLIENTE SET puntos_cliente_frecuente = 4470 WHERE id=19;
UPDATE CLIENTE SET puntos_cliente_frecuente = 1986 WHERE id=20;
UPDATE CLIENTE SET puntos_cliente_frecuente = 3619 WHERE id=21;
UPDATE CLIENTE SET puntos_cliente_frecuente = 3754 WHERE id=22;
UPDATE CLIENTE SET puntos_cliente_frecuente = 3745 WHERE id=23;
UPDATE CLIENTE SET puntos_cliente_frecuente = 4781 WHERE id=24;
UPDATE CLIENTE SET puntos_cliente_frecuente = 3036 WHERE id=25;
UPDATE CLIENTE SET puntos_cliente_frecuente = 4239 WHERE id=26;
UPDATE CLIENTE SET puntos_cliente_frecuente = 3178 WHERE id=27;
UPDATE CLIENTE SET puntos_cliente_frecuente = 3948 WHERE id=28;
UPDATE CLIENTE SET puntos_cliente_frecuente = 1563 WHERE id=29;
UPDATE CLIENTE SET puntos_cliente_frecuente = 4366 WHERE id=30;
UPDATE CLIENTE SET puntos_cliente_frecuente = 3624 WHERE id=31;
UPDATE CLIENTE SET puntos_cliente_frecuente = 3667 WHERE id=32;
UPDATE CLIENTE SET puntos_cliente_frecuente = 4372 WHERE id=33;
UPDATE CLIENTE SET puntos_cliente_frecuente = 3307 WHERE id=34;
UPDATE CLIENTE SET puntos_cliente_frecuente = 4883 WHERE id=35;
UPDATE CLIENTE SET puntos_cliente_frecuente = 2307 WHERE id=36;
UPDATE CLIENTE SET puntos_cliente_frecuente = 4106 WHERE id=37;
UPDATE CLIENTE SET puntos_cliente_frecuente = 3898 WHERE id=38;
UPDATE CLIENTE SET puntos_cliente_frecuente = 4610 WHERE id=39;
UPDATE CLIENTE SET puntos_cliente_frecuente = 3126 WHERE id=40;
UPDATE CLIENTE SET puntos_cliente_frecuente = 2439 WHERE id=41;
UPDATE CLIENTE SET puntos_cliente_frecuente = 1882 WHERE id=42;
UPDATE CLIENTE SET puntos_cliente_frecuente = 2043 WHERE id=43;
UPDATE CLIENTE SET puntos_cliente_frecuente = 3143 WHERE id=44;
UPDATE CLIENTE SET puntos_cliente_frecuente = 1274 WHERE id=45;
UPDATE CLIENTE SET puntos_cliente_frecuente = 4369 WHERE id=46;
UPDATE CLIENTE SET puntos_cliente_frecuente = 2939 WHERE id=47;
UPDATE CLIENTE SET puntos_cliente_frecuente = 4112 WHERE id=48;
UPDATE CLIENTE SET puntos_cliente_frecuente = 3697 WHERE id=49;
UPDATE CLIENTE SET puntos_cliente_frecuente = 2300 WHERE id=50;

SELECT * FROM CLIENTE;

-- 1.0 	Crear un procedimiento almacenado que permita registrar nuevas reservas
--		Como argumentos se reciben: el la fecha de checkin y checkout, el id de metodo de pago, 
--		el id del cliente y el id de la habitacion.
-- DROP PROCEDURE BOOKING;
GO
CREATE PROCEDURE BOOKING 
	@id INT,
	@checkin VARCHAR(12),
	@checkout VARCHAR(12),
	@id_metodo_pago INT,
	@id_cliente INT,
	@id_habitacion INT
AS
BEGIN
	INSERT INTO RESERVA 
		VALUES(@id,CONVERT(DATE, @checkin, 103),CONVERT(DATE, @checkout, 103),@id_metodo_pago,@id_cliente,@id_habitacion);		
END;

DROP PROCEDURE BOOKING;

GO
-- Ejecutando procedimiento almacenado
-- DELETE FROM RESERVA WHERE id = 201 OR id = 202;

EXEC BOOKING 201, '01/07/2022', '05/07/2022',1,13,3;
EXEC BOOKING 202, '04/07/2022', '08/07/2022',2,9,3;

-- Verificando datos:
-- Se observa alguna anomalia en los datos?

SELECT * FROM RESERVA ORDER BY id DESC;

--*****************************************************
--	TRANSACCIONES

-- 2.0	Crear un procedimiento almacenado que permita transferir puntos de cliente frecuente entre
--		2 usuarios. Como parametros se deberan recibir el id del usuario emisor, el id del usuario
--		receptor, y la cantidad de puntos a transferir.
--		NOTA: En la primera version de este ejercicio provocar un error de semantica y observar el resultado

GO
CREATE PROCEDURE TRANSFERIR_PUNTOS
	@id_emisor INT,
	@id_receptor INT,
	@puntos INT
AS BEGIN 
	-- Validando si el usuario tiene suficientes puntos
	DECLARE @puntos_emisor INT;
	SELECT @puntos_emisor = puntos_cliente_frecuente 
	FROM CLIENTE WHERE id = @id_emisor;
	
	IF @puntos_emisor <= @puntos 
		PRINT 'ERROR: El usuario emisor no tiene suficientes puntos.';
	ELSE 
	BEGIN
		BEGIN TRY  
			-- Restando puntos al emisor
			UPDATE CLIENTE 
				SET puntos_cliente_frecuente = puntos_cliente_frecuente - @puntos
			WHERE id = @id_emisor;
			-- Provocando error
			DECLARE @error INT;
			SELECT @error = 1/0;
			-- Sumando puntos al receptor
			UPDATE CLIENTE 
				SET puntos_cliente_frecuente = puntos_cliente_frecuente + @puntos
			WHERE id = @id_receptor;
		END TRY  
		BEGIN CATCH 
			DECLARE @ERROR_MESSAGE VARCHAR(100);
			SELECT @ERROR_MESSAGE=ERROR_MESSAGE();
			PRINT 'ERROR: ' + @ERROR_MESSAGE;
		END CATCH  
	END;
END;
GO;
-- DROP PROCEDURE TRANSFERIR_PUNTOS;
-- UPDATE CLIENTE SET puntos_cliente_frecuente = 2310 WHERE id=1;
-- UPDATE CLIENTE SET puntos_cliente_frecuente = 4744 WHERE id=2;

-- Ejecutando procedimiento almacenado (se espera un error)

EXEC TRANSFERIR_PUNTOS 1, 2, 2000;

-- Verificando datos

SELECT * FROM CLIENTE WHERE id = 1 OR id = 2;
UPDATE CLIENTE SET puntos_cliente_frecuente = 2310 WHERE id=1;
UPDATE CLIENTE SET puntos_cliente_frecuente = 4744 WHERE id=2;

-- 2.1	Crear una versi�n 2 del procedimiento almacenado anterior
--		Utilizar transacciones
GO
ALTER PROCEDURE TRANSFERIR_PUNTOS
	@id_emisor INT,
	@id_receptor INT,
	@puntos INT
AS BEGIN 
	-- Validando si el usuario tiene suficientes puntos
	DECLARE @puntos_emisor INT;
	SELECT @puntos_emisor = puntos_cliente_frecuente 
	FROM CLIENTE WHERE id = @id_emisor;
	
	IF @puntos_emisor <= @puntos 
		PRINT 'ERROR: El usuario emisor no tiene suficientes puntos.';
	ELSE 
	BEGIN
		BEGIN TRY 
			BEGIN TRANSACTION TRANSFERIR_PUNTOS
			-- Restando puntos al emisor
			UPDATE CLIENTE 
				SET puntos_cliente_frecuente = puntos_cliente_frecuente - @puntos
			WHERE id = @id_emisor;
			-- Provocando error
			DECLARE @error INT;
			SELECT @error = 1/0;
			-- Sumando puntos al receptor
			UPDATE CLIENTE 
				SET puntos_cliente_frecuente = puntos_cliente_frecuente + @puntos
			WHERE id = @id_receptor;
			COMMIT TRANSACTION TRANSFERIR_PUNTOS
		END TRY  
		BEGIN CATCH 
			DECLARE @ERROR_MESSAGE VARCHAR(100);
			SELECT @ERROR_MESSAGE=ERROR_MESSAGE();
			PRINT 'ERROR: ' + @ERROR_MESSAGE;
			ROLLBACK TRANSACTION TRANSFERIR_PUNTOS
		END CATCH  
	END;
END;
GO
--DROP PROCEDURE TRANSFERIR_PUNTOS;
--UPDATE CLIENTE SET puntos_cliente_frecuente = 2949 WHERE id=1;
--UPDATE CLIENTE SET puntos_cliente_frecuente = 3057 WHERE id=2;

-- Ejecutando procedimiento almacenado (se espera un error)

EXEC TRANSFERIR_PUNTOS 1, 2, 2000;

-- Verificando datos

SELECT * FROM CLIENTE WHERE id = 1 OR id = 2;


-- *****************************************************
-- 4.	Procedimientos almacenados y triggers
-- *****************************************************
-- 1.1.	Crear un procedimiento almacenado que permita registrar nuevas reservas
--		Como argumentos se reciben: el la fecha de checkin y checkout, el id del cliente
--		y el id de la habitacion.
--		NOTA: Validar que la nueva reserva no se solape con otras reservas

GO
CREATE OR ALTER PROCEDURE BOOKING 
	@id INT,
	@checkin VARCHAR(12),
	@checkout VARCHAR(12),
	@id_metodo_pago INT,
	@id_cliente INT,
	@id_habitacion INT
AS
BEGIN
	BEGIN TRY
		INSERT INTO RESERVA VALUES(@id,CONVERT(DATE, @checkin, 103),CONVERT(DATE, @checkout, 103),@id_metodo_pago,@id_cliente,@id_habitacion);		
	END TRY
	BEGIN CATCH
		PRINT ERROR_MESSAGE();
	END CATCH;
END;
GO

CREATE OR ALTER TRIGGER CHECK_BOOKING
ON RESERVA
AFTER INSERT
AS BEGIN
		--declarando variables
		DECLARE @checkin DATETIME;
		DECLARE @checkout DATETIME;
		DECLARE @id_habitacion INT;
		DECLARE @resultado INT;
		--obteniendo datos desde tabla inserted
		SELECT @id_habitacion=i.id_habitacion, @checkin=i.checkin, @checkout=i.checkout FROM inserted i;
		SELECT @resultado = COUNT(*) FROM RESERVA 
		WHERE 
			((@checkin < checkin AND (@checkout BETWEEN checkin AND checkout)) OR
			((@checkin BETWEEN checkin AND checkout) AND @checkout > checkout) OR
			(@checkin >= checkin AND @checkout <= checkout) OR
			(checkin >= @checkin AND checkout <= @checkout)) AND
			id_habitacion = @id_habitacion;
	IF @resultado > 1
	BEGIN 
		RAISERROR ('ERROR: Consulta invalida, la habitacion ya ha sido reservada en la fecha establecida...' ,11,1)
		ROLLBACK TRANSACTION
	END;
END;

-- Ejecutando procedimiento almacenado
-- DELETE FROM RESERVA WHERE id = 201 OR id = 202;
EXEC BOOKING 201, '01/07/2022', '05/07/2022',1,13,3; --funciona
EXEC BOOKING 202, '01/07/2022', '05/07/2022',2,9,3; 
EXEC BOOKING 202, '04/07/2022', '08/07/2022',2,9,3;
EXEC BOOKING 202, '29/06/2022', '02/07/2022',2,9,3;
EXEC BOOKING 202, '29/06/2022', '02/07/2022',2,9,5; -- Funciona

SELECT * FROM RESERVA WHERE id_habitacion = 3


-- 1.2.	Crear una tabla llamada "REGISTRO_PUNTOS_S#", el objetivo de esta tabla será funcionar
--		como registro de los intercambios de puntos de cliente frecuente que realizan los
--		clientes. La tabla debe almacenar: la fecha y hora de la transaccion, el id y nombre del
--		usuario involucrado, la cantidad de puntos antes y despues de la transacción y una 
--		descriptión breve del proceso realizado.


CREATE TABLE REGISTRO_PUNTOS(
	id INT PRIMARY KEY IDENTITY,
	fecha DATETIME,
	id_cliente INT,
	nombre_cliente VARCHAR(50),
	puntos_ini INT,
	puntos_fin INT,
	descripcion VARCHAR(100)
);

GO
CREATE OR ALTER PROCEDURE TRANSFERIR_PUNTOS
    @id_emisor INT,
    @id_receptor INT,
    @puntos INT
AS BEGIN
    -- Validando si los puntos del cliente emisor son suficiente para realizar la transfencia
    DECLARE @puntos_cliente_emisor INT;
    SELECT @puntos_cliente_emisor = puntos_cliente_frecuente FROM CLIENTE WHERE id = @id_emisor;
    IF @puntos_cliente_emisor < @puntos 
        BEGIN
            PRINT 'ERROR: El cliente no tiene suficientes puntos para ser transferidos :(';
        END
    ELSE   
        BEGIN
            BEGIN TRY 
                BEGIN TRANSACTION TRANSFERENCIA_DE_PUNTOS
                -- Restando puntos al emisor
                UPDATE CLIENTE SET puntos_cliente_frecuente = puntos_cliente_frecuente - @puntos 
                    WHERE id = @id_emisor;
                -- Provocando error 
                DECLARE @error INT;
                -- Sumando puntos al receptor
                UPDATE CLIENTE SET puntos_cliente_frecuente = puntos_cliente_frecuente + @puntos 
                    WHERE id = @id_receptor;
                COMMIT TRANSACTION TRANSFERENCIA_DE_PUNTOS
            END TRY
            BEGIN CATCH
                DECLARE @ERROR_MESSAGE VARCHAR(100);
                SELECT @ERROR_MESSAGE = ERROR_MESSAGE();
                PRINT 'ERROR OCURRIDO: '+ @ERROR_MESSAGE;
                ROLLBACK TRANSACTION TRANSFERENCIA_DE_PUNTOS
            END CATCH; 
        END; 
END;

Go

CREATE OR ALTER TRIGGER CHECK_POINTS
ON CLIENTE
AFTER UPDATE
AS BEGIN
	-- Seccion de declaracion de variables
	DECLARE @fecha DATETIME;
	DECLARE @id_cliente INT;
	DECLARE @nombre_cliente VARCHAR(50);
	DECLARE @puntos_ini INT;
	DECLARE @puntos_fin INT;
	DECLARE @descripcion VARCHAR (100);
	-- Sección de procesamiento de datos
	-- obteniendo fecha
	SELECT @fecha = GETDATE();
	SELECT @id_cliente = id, @nombre_cliente = nombre, @puntos_fin = puntos_cliente_frecuente FROM INSERTED;
	SELECT @puntos_ini = puntos_cliente_frecuente FROM DELETED;
	IF @puntos_ini > @puntos_fin 
		SET @descripcion = 'Cliente ha gastado o regalado puntos';
	ELSE
		SET @descripcion = 'Cliente ha recibido puntos';
	INSERT INTO REGISTRO_PUNTOS (fecha, id_cliente, nombre_cliente, puntos_ini, puntos_fin, descripcion)
		VALUES(@fecha, @id_cliente, @nombre_cliente, @puntos_ini, @puntos_fin, @descripcion);
END;

-- Verificando datos
SELECT * FROM CLIENTE WHERE id = 1 OR id = 2;
UPDATE CLIENTE SET puntos_cliente_frecuente = 2310 WHERE id=1;
UPDATE CLIENTE SET puntos_cliente_frecuente = 4744 WHERE id=2;
EXEC TRANSFERIR_PUNTOS 1, 2, 2000;
-- Verificando contenido de la tabla REGISTRO_PUNTOS
SELECT * FROM REGISTRO_PUNTOS;

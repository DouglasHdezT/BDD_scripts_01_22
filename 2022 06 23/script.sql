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

GO;

CREATE PROCEDURE TRANSFER_POINTS
	@id_client_send INT,
	@id_client_recieve INT,
	@points INT
AS BEGIN
	DECLARE @points_client_send INT
	
	SELECT @points_client_send = puntos_cliente_frecuente
	FROM CLIENTE c
	WHERE c.id = @id_client_send

	IF @points_client_send < @points
		PRINT 'Error: cant. puntos insuficientes';
	ELSE
		BEGIN
			BEGIN TRY
				UPDATE CLIENTE SET puntos_cliente_frecuente = 
					puntos_cliente_frecuente - @points
					WHERE id = @id_client_send;
				
				DECLARE @error INT
				SELECT @error = 1 / 0

				UPDATE CLIENTE SET puntos_cliente_frecuente = 
					puntos_cliente_frecuente + @points
					WHERE id = @id_client_recieve
			END TRY
			BEGIN CATCH
				DECLARE @ERROR_MESSAGE VARCHAR(100)
				SELECT @ERROR_MESSAGE = ERROR_MESSAGE()
				PRINT 'ERROR: ' + @ERROR_MESSAGE
			END CATCH
		END
END;

GO;
-- DROP PROCEDURE TRANSFERIR_PUNTOS;
-- UPDATE CLIENTE SET puntos_cliente_frecuente = 2310 WHERE id=1;
-- UPDATE CLIENTE SET puntos_cliente_frecuente = 4744 WHERE id=2;

-- Ejecutando procedimiento almacenado (se espera un error)

EXEC TRANSFER_POINTS 1, 2, 2000;

-- Verificando datos

SELECT * FROM CLIENTE WHERE id = 1 OR id = 2;
UPDATE CLIENTE SET puntos_cliente_frecuente = 2310 WHERE id=1;
UPDATE CLIENTE SET puntos_cliente_frecuente = 4744 WHERE id=2;

-- 2.1	Crear una versi�n 2 del procedimiento almacenado anterior
--		Utilizar transacciones

GO
CREATE OR ALTER PROCEDURE TRANSFER_POINTS
	@id_client_send INT,
	@id_client_recieve INT,
	@points INT
AS BEGIN
	DECLARE @points_client_send INT
	
	SELECT @points_client_send = puntos_cliente_frecuente
	FROM CLIENTE c
	WHERE c.id = @id_client_send

	IF @points_client_send < @points
		PRINT 'Error: cant. puntos insuficientes';
	ELSE
		BEGIN
			BEGIN TRY
				BEGIN TRANSACTION TRASFER_POINTS_TRANSACTION

				UPDATE CLIENTE SET puntos_cliente_frecuente = 
					puntos_cliente_frecuente - @points
					WHERE id = @id_client_send;
				
				DECLARE @error INT
				SELECT @error = 1 / 0

				UPDATE CLIENTE SET puntos_cliente_frecuente = 
					puntos_cliente_frecuente + @points
					WHERE id = @id_client_recieve

				COMMIT TRANSACTION TRASFER_POINTS_TRANSACTION
			END TRY
			BEGIN CATCH
				DECLARE @ERROR_MESSAGE VARCHAR(100)
				SELECT @ERROR_MESSAGE = ERROR_MESSAGE()
				PRINT 'ERROR: ' + @ERROR_MESSAGE
				ROLLBACK TRANSACTION TRASFER_POINTS_TRANSACTION;
			END CATCH
		END
END;

--DROP PROCEDURE TRANSFERIR_PUNTOS;
--UPDATE CLIENTE SET puntos_cliente_frecuente = 2949 WHERE id=1;
--UPDATE CLIENTE SET puntos_cliente_frecuente = 3057 WHERE id=2;

-- Ejecutando procedimiento almacenado (se espera un error)

EXEC TRANSFER_POINTS 1, 2, 2000;

-- Verificando datos

SELECT * FROM CLIENTE WHERE id = 1 OR id = 2;

-- *****************************************************
-- 4.	Procedimientos almacenados y triggers
-- *****************************************************
-- 1.1.	Crear un procedimiento almacenado que permita registrar nuevas reservas
--		Como argumentos se reciben: el la fecha de checkin y checkout, el id del cliente
--		y el id de la habitacion.
--		NOTA: Validar que la nueva reserva no se solape con otras reservas



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
	descripcion VARCHAR(140)
);

GO
CREATE OR ALTER PROCEDURE TRANSFER_POINTS
	@id_client_send INT,
	@id_client_recieve INT,
	@points INT
AS BEGIN
	DECLARE @points_client_send INT
	
	SELECT @points_client_send = puntos_cliente_frecuente
	FROM CLIENTE c
	WHERE c.id = @id_client_send

	IF @points_client_send < @points
		PRINT 'Error: cant. puntos insuficientes';
	ELSE
		BEGIN
			BEGIN TRY
				BEGIN TRANSACTION TRASFER_POINTS_TRANSACTION

				UPDATE CLIENTE SET puntos_cliente_frecuente = 
					puntos_cliente_frecuente - @points
					WHERE id = @id_client_send;
				
				--DECLARE @error INT
				--SELECT @error = 1 / 0

				UPDATE CLIENTE SET puntos_cliente_frecuente = 
					puntos_cliente_frecuente + @points
					WHERE id = @id_client_recieve

				COMMIT TRANSACTION TRASFER_POINTS_TRANSACTION
			END TRY
			BEGIN CATCH
				DECLARE @ERROR_MESSAGE VARCHAR(100)
				SELECT @ERROR_MESSAGE = ERROR_MESSAGE()
				PRINT 'ERROR: ' + @ERROR_MESSAGE
				ROLLBACK TRANSACTION TRASFER_POINTS_TRANSACTION;
			END CATCH
		END
END;

GO
CREATE OR ALTER TRIGGER AUDIT_TRANSFER_POINTS
	ON CLIENTE
	AFTER INSERT
	AS BEGIN
		DECLARE @fecha DATETIME;
		DECLARE @id_cliente INT;
		DECLARE @nombre_cliente VARCHAR(50);
		DECLARE @puntos_ini INT;
		DECLARE @puntos_fin INT;
		DECLARE @descripcion VARCHAR(140);

		SELECT @fecha = GETDATE();
		
		SELECT @id_cliente = id, @nombre_cliente = nombre,
			@puntos_fin = puntos_cliente_frecuente
		FROM inserted;

		SELECT @puntos_ini = puntos_cliente_frecuente
		FROM deleted;

		IF @puntos_ini > @puntos_fin
			SET @descripcion = 'Se han donado puntos'
		ELSE 
			BEGIN
				IF @puntos_ini < @puntos_fin
					SET @descripcion = 'Se han recibido puntos'
				ELSE
					SET @descripcion = 'No se han modificado los puntos'
			END
		
		INSERT INTO REGISTRO_PUNTOS(fecha, id_cliente, nombre_cliente, puntos_ini, puntos_fin, descripcion)
			VALUES(@fecha, @id_cliente, @nombre_cliente, @puntos_ini, @puntos_fin, @descripcion)
	END

-- Verificando datos
SELECT * FROM CLIENTE WHERE id = 1 OR id = 2;
UPDATE CLIENTE SET puntos_cliente_frecuente = 2310 WHERE id=1;
UPDATE CLIENTE SET puntos_cliente_frecuente = 4744 WHERE id=2;
EXEC TRANSFER_POINTS 1, 2, 2000;
-- Verificando contenido de la tabla REGISTRO_PUNTOS
SELECT * FROM REGISTRO_PUNTOS;

UPDATE CLIENTE SET nombre = 'Fernanda Vasquez' WHERE id = 1;
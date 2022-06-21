--****************************************************
-- Bases de datos: Funciones, procedimientos almacenados, y transacciones
-- Autor: Douglas Hernández
-- Correspondencia: dohernandez@uca.edu.sv
-- Version: 1.0
--****************************************************

-- *****************************************************
-- 1.	Funciones
-- *****************************************************
-- 1.1	Crear una funcion que tome como parametro el id de un cliente
--		y retorne el nombre del pais del que procede dicho cliente.

CREATE FUNCTION GET_CLIENT_COUNTRY(@id_cliente INT)
	RETURNS VARCHAR(30)
AS BEGIN
	DECLARE @pais VARCHAR(30);
	SELECT @pais = p.pais
	FROM PAIS p, cliente c
	WHERE c.id_pais = p.id
			AND c.id = @id_cliente;
	RETURN @pais;
END;

-- DROP FUNCTION dbo.GET_CLIENT_COUNTRY

-- 1.1.1	Ejecutando la funcion.

SELECT dbo.GET_CLIENT_COUNTRY(4) AS pais;

-- 1.1.2	Ejecutando la funcion en una consulta.

SELECT c.id, c.nombre, c.documento, 
	C.categoria_cliente, c.id_pais, 
	dbo.GET_CLIENT_COUNTRY(c.id) AS pais
FROM CLIENTE C;

-- 1.2	Crear una funcion que calcule el sub total de los servicios extras adquiridos en una reserva.
--		Si la reserva no tiene servicios extras, la funcion retorna 0.0
-- Consulta
/*
SELECT * 
FROM RESERVA R
    LEFT JOIN EXTRA X 
        ON R.id = x.id_reserva
    LEFT JOIN SERVICIO S
        ON S.id = x.id_servicio
    WHERE R.id = 2;
*/

CREATE FUNCTION GET_EXTRAS(@id_reserva INT)
	RETURNS FLOAT
	AS BEGIN
		DECLARE @subtotal_servicios FLOAT;

        SELECT @subtotal_servicios = SUM(S.precio) 
        FROM RESERVA R
            LEFT JOIN EXTRA X 
                ON R.id = x.id_reserva
            LEFT JOIN SERVICIO S
                ON S.id = x.id_servicio
            WHERE R.id = @id_reserva
        GROUP BY R.id;


		IF @subtotal_servicios IS NULL 
		BEGIN
			RETURN 0.0;
		END;

		RETURN @subtotal_servicios;
	END;

SELECT dbo.GET_EXTRAS(3);

-- 1.3 	Crear una funcion que calcula el sub total de la habitacion utilizada en cada reserva
-- Consulta
/*
SELECT R.id, R.checkin, R.checkout, H.id, H.precio, DATEDIFF(DAY, R.checkin, R.checkout)
FROM RESERVA R 
    INNER JOIN HABITACION H 
        ON H.id = R.id_habitacion;
*/

CREATE FUNCTION GET_HABITACION(@id_reserva INT)
	RETURNS FLOAT
	AS BEGIN
		DECLARE @subtotal_habitacion FLOAT;

        SELECT @subtotal_habitacion = DATEDIFF(DAY, R.checkin, R.checkout)*H.precio
            FROM RESERVA R 
                INNER JOIN HABITACION H 
                    ON H.id = R.id_habitacion
            WHERE R.id = @id_reserva;

		RETURN @subtotal_habitacion;
	END;

SELECT dbo.GET_HABITACION(2);

-- 2.1.1	Calcular el total de cada reserva 
-- consulta realizada en la clase 15:
/*
SELECT R.id, R.checkin, R.checkout, HO.nombre 'Hotel', H.numero 'Habitacion', (H.precio*DATEDIFF(DAY,R.checkin, R.checkout)) 'subtotal reserva',
		ISNULL(SUM(S.precio),0) 'subtotal servicios', ((H.precio*DATEDIFF(DAY,R.checkin, R.checkout))+ISNULL(SUM(S.precio),0)) 'TOTAL'
FROM RESERVA R
	INNER JOIN HABITACION H
		ON H.id = R.id_habitacion
	INNER JOIN HOTEL HO 
		ON HO.id = H.id_hotel
	LEFT JOIN EXTRA X
		ON R.id = X.id_reserva
	LEFT JOIN SERVICIO S 
		ON S.id = X.id_servicio
GROUP BY R.id, R.checkin, R.checkout, HO.nombre, H.numero, H.precio;
*/
-- consulta utilizando funciones.

SELECT R.id, R.checkin, R.checkout, HO.nombre 'hotel', H.numero 'habitacion', 
		dbo.get_habitacion(R.id) 'subtotal habitacion', dbo.get_extras(R.id) 'subtotal servicios',
		dbo.get_habitacion(R.id) + dbo.get_extras(R.id) 'total'
FROM HOTEL HO, HABITACION H, RESERVA R 
WHERE HO.id = H.id_hotel 
	AND H.id = R.id_habitacion
ORDER BY R.id ASC;

-- 1.3	Crear una funcion que calcule el total de una reserva
--		La funcion recibira como parametro el id de una reserva.

CREATE FUNCTION GET_TOTAL(@id_reserva INT)
	RETURNS FLOAT
	AS BEGIN
		DECLARE @total FLOAT;

		SELECT @total = ((H.precio*DATEDIFF (DAY, R.checkin, R.checkout)) + dbo.GET_EXTRAS(r.id))
		FROM reserva r, habitacion h
		WHERE r.id_habitacion = h.id
				AND r.id = @id_reserva;

		RETURN @total;
	END;


-- 1.3.1	Haciendo uso de la funcion

SELECT dbo.GET_TOTAL(6);
SELECT *, dbo.GET_TOTAL(R.id) 'TOTAL'
FROM reserva R

-- 1.4	Crear la funcion llamada, RESERVA_DETALLE. Debe mostrar el subtotal
--		obtenido de la multiplicaci�n del precio de la habitaci�n y el numero de dias reservados (A).
--		mostrar el total de la suma de los servicios extra incluidos (B).
--		y el total resultante de toda la reserva (A+B).

CREATE FUNCTION RESERVA_DETALLE()
	RETURNS TABLE
	AS
		RETURN (
			SELECT R.id, R.checkin, R.checkout, HO.nombre 'hotel', H.numero 'habitacion',
					dbo.GET_TOTAL(R.id) 'total'
			FROM HOTEL HO, HABITACION H, RESERVA R 
			WHERE HO.id = H.id_hotel 
				AND H.id = R.id_habitacion
		);

SELECT * FROM dbo.RESERVA_DETALLE();

-- *****************************************************
-- 2.	Procedimientos almacenados basicos.
-- *****************************************************

-- 2.1	Crear un procedimiento almacenado que reciba como par�metro el id
--		de una habitaci�n y retorne la cantidad de veces que ha sido reservada

CREATE PROCEDURE GET_RESERVATIONS  
	@id_habitacion INT
AS
BEGIN
	DECLARE @cantidad_reserva INT;
	SELECT  @cantidad_reserva= COUNT(r.id)
	FROM habitacion h, reserva r
	WHERE h.id = r.id_habitacion
		AND h.id = @id_habitacion
	GROUP BY h.id, h.numero;

	IF @cantidad_reserva IS NULL
		PRINT('La habitacion con id=' +
			CAST(@id_habitacion AS VARCHAR(5)) + ', Ha tenido 0 reservas.');
	ELSE
		PRINT('La habitacion con id=' +
			CAST(@id_habitacion AS VARCHAR(5)) + ', Ha tenido ' + 
			CAST(@cantidad_reserva AS VARCHAR(5)) + ' reservas.');
END;

EXEC GET_RESERVATIONS 3;

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

CREATE PROCEDURE BOOKING 
	@id INT,
	@checkin VARCHAR(12),
	@checkout VARCHAR(12),
	@id_metodo_pago INT,
	@id_cliente INT,
	@id_habitacion INT
AS
BEGIN
	INSERT INTO RESERVA VALUES(@id,CONVERT(DATE, @checkin, 103),CONVERT(DATE, @checkout, 103),@id_metodo_pago,@id_cliente,@id_habitacion);		
END;

DROP PROCEDURE BOOKING;

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

--DROP PROCEDURE TRANSFERIR_PUNTOS;
--UPDATE CLIENTE SET puntos_cliente_frecuente = 2949 WHERE id=1;
--UPDATE CLIENTE SET puntos_cliente_frecuente = 3057 WHERE id=2;

-- Ejecutando procedimiento almacenado (se espera un error)

EXEC TRANSFERIR_PUNTOS 1, 2, 2000;

-- Verificando datos

SELECT * FROM CLIENTE WHERE id = 1 OR id = 2;


-- Procedimientos almacenados con tratamiento de tablas.
-- 2.2. Crear un procedimiento almacenado que reciba como parametros dos enteros
--		El objetivo es mostrar la ganancia de cada hotel y la suma total de la ganancia
--		Parametro 1: numero entero entre 1 y 12 que representa un mes
--		Parametro 2: numero entero que representa un año.

CREATE PROCEDURE GET_MONTH_PROFIT 
	@MM INT,
	@YYYY INT
AS
BEGIN
	SET ANSI_WARNINGS OFF;
    --Declaracion de variables
	DECLARE @contador INT;
	DECLARE @id_hotel INT, @hotel VARCHAR(25);
	DECLARE @ganancia FLOAT, @total FLOAT;
	DECLARE cursor_ganancia_h CURSOR FOR
        SELECT HO.id, HO.nombre, CAST (SUM(dbo.get_total(R.id)) AS DECIMAL (10,2)) 'total'
        FROM HOTEL HO, HABITACION H, RESERVA R
        WHERE HO.id = H.id_hotel 
            AND H.id = R.id_habitacion
            AND MONTH(R.checkin) = @MM
            AND YEAR(R.checkin) = @YYYY
        GROUP BY HO.id, HO.nombre
        ORDER BY HO.id ASC;

	SET @total = 0;
	SELECT @contador = COUNT(*) FROM hotel;
	OPEN cursor_ganancia_h;
	WHILE @contador > 0
		BEGIN
			FETCH cursor_ganancia_h INTO @id_hotel, @hotel, @ganancia;
			PRINT('id:  '+ CAST(@id_hotel AS VARCHAR(2)) +' - Hotel: ' + @hotel + ' -> Ganancia: ' + CAST(@ganancia AS VARCHAR(10)));
			SET @total = @ganancia + @total;
			SET @contador = @contador - 1;
		END
	PRINT('------------------------');
	PRINT('TOTAL: ' + CAST(@ganancia AS VARCHAR(10)));
	CLOSE cursor_ganancia_h;
	DEALLOCATE cursor_ganancia_h;
END;

DROP PROCEDURE GET_MONTH_PROFIT;

EXEC GET_MONTH_PROFIT 5, 2022;
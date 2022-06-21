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
GO
CREATE FUNCTION get_client_country(@id_client INT)
	RETURNS VARCHAR(30) AS
	BEGIN
		DECLARE @country VARCHAR(30);
		
		SELECT @country = p.pais
		FROM CLIENTE c
		INNER JOIN PAIS p
			ON c.id_pais = p.id
		WHERE c.id = @id_client;

		RETURN @country;
	END
GO
-- DROP FUNCTION dbo.GET_CLIENT_COUNTRY

-- 1.1.1	Ejecutando la funcion.

SELECT dbo.get_client_country(4) as Pais;

-- 1.1.2	Ejecutando la funcion en una consulta.

SELECT c.id, c.nombre, c.documento,
	dbo.get_client_country(c.id) as Pais
FROM CLIENTE c;

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
GO

CREATE FUNCTION get_total_extras(@id_reserva INT)
	RETURNS FLOAT AS
	BEGIN
		DECLARE @total FLOAT;

		SELECT @total = SUM(s.precio)
		FROM RESERVA r
		LEFT JOIN EXTRA x
			ON x.id_reserva = r.id
		LEFT JOIN SERVICIO s
			ON x.id_servicio = s.id
		WHERE r.id = @id_reserva
		GROUP BY r.id;

		IF @total IS NULL
		BEGIN
			RETURN 0.0;
		END

		RETURN @total;
	END;

GO

SELECT dbo.get_total_extras(2);

-- 1.3 	Crear una funcion que calcula el sub total de la habitacion utilizada en cada reserva
-- Consulta
/*
SELECT R.id, R.checkin, R.checkout, H.id, H.precio, DATEDIFF(DAY, R.checkin, R.checkout), DATEDIFF(DAY, R.checkin, R.checkout) * H.precio
FROM RESERVA R 
    INNER JOIN HABITACION H 
        ON H.id = R.id_habitacion;
*/
GO

CREATE FUNCTION get_total_hab(@id_reserva INT)
	RETURNS FLOAT AS
	BEGIN
		DECLARE @total FLOAT

		SELECT @total = DATEDIFF(DAY, r.checkin, r.checkout) * hab.precio
		FROM RESERVA r
		INNER JOIN HABITACION hab
			ON r.id_habitacion = hab.id
		WHERE r.id = @id_reserva

		RETURN @total
	END;
GO

SELECT dbo.get_total_hab(3);

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

SELECT R.id 'Fact. #', R.checkin, R.checkout, 
	hot.nombre 'Hotel', hab.numero '# hab',
	dbo.get_total_hab(R.id) 'Subtotal habitación',
	dbo.get_total_extras(R.id) 'Subtotal extras',
	dbo.get_total_extras(R.id) + dbo.get_total_hab(R.id) 'Total' 
FROM RESERVA r
INNER JOIN HABITACION hab
	ON r.id_habitacion = hab.id
INNER JOIN HOTEL hot
	ON hab.id_hotel = hot.id
ORDER BY R.id ASC;

-- 1.3	Crear una funcion que calcule el total de una reserva
--		La funcion recibira como parametro el id de una reserva.
GO
CREATE FUNCTION get_total(@id_reserva INT)
	RETURNS FLOAT AS
	BEGIN
		DECLARE @total FLOAT

		SELECT @total = dbo.get_total_extras(R.id) + dbo.get_total_hab(R.id)
		FROM RESERVA r
		WHERE r.id = @id_reserva

		RETURN @total;
	END;
GO

-- 1.3.1	Haciendo uso de la funcion

SELECT *, dbo.get_total(r.id) 'Total a pagar'
FROM RESERVA r;

-- 1.4	Crear la funcion llamada, RESERVA_DETALLE. Debe mostrar el subtotal
--		obtenido de la multiplicaci�n del precio de la habitaci�n y el numero de dias reservados (A).
--		mostrar el total de la suma de los servicios extra incluidos (B).
--		y el total resultante de toda la reserva (A+B).
GO
CREATE FUNCTION RESERVA_DETALLE()
	RETURNS TABLE AS
	RETURN (
		SELECT R.id 'Fact. #', R.checkin, R.checkout, 
			hot.nombre 'Hotel', hab.numero '# hab',
			DATEDIFF(DAY, r.checkin, r.checkout) 'Días', 
			dbo.get_total_hab(R.id) 'Subtotal habitación',
			dbo.get_total_extras(R.id) 'Subtotal extras',
			dbo.get_total(R.id) 'Total' 
		FROM RESERVA r
		INNER JOIN HABITACION hab
			ON r.id_habitacion = hab.id
		INNER JOIN HOTEL hot
			ON hab.id_hotel = hot.id
	);
GO

SELECT * FROM dbo.RESERVA_DETALLE();

-- *****************************************************
-- 2.	Procedimientos almacenados basicos.
-- *****************************************************

-- 2.1	Crear un procedimiento almacenado que reciba como par�metro el id
--		de una habitaci�n y retorne la cantidad de veces que ha sido reservada
GO
CREATE PROCEDURE get_reservations_by_hab
	@id_habitation INT
	AS
	BEGIN
		DECLARE @reservations_qnt INT;

		SELECT @reservations_qnt = COUNT(R.id)
		FROM RESERVA r
		INNER JOIN HABITACION hab
			ON r.id_habitacion = hab.id
		WHERE hab.id = @id_habitation

		PRINT(
			'La Habitación con id: ' +
			CAST(@id_habitation AS VARCHAR(5)) + 
			' ha sido reservada ' +
			CAST(@reservations_qnt AS VARCHAR(5)) + 
			' veces'  
		)
	END;
GO

EXEC get_reservations_by_hab 200;

GO

-- Mismo procedimiento pero almacenando en tabla

CREATE TABLE RESERVATIONS_RESULTS(
	id INT IDENTITY(1,1) PRIMARY KEY,
	id_hab INT,
	hotel VARCHAR(100),
	numero INT,
	reservas INT,
);

GO
CREATE PROCEDURE get_reservations_by_hab_into_table
	@id_habitation INT 
	AS
	BEGIN
		INSERT INTO RESERVATIONS_RESULTS (id_hab, hotel, numero, reservas)
		SELECT hab.id, hot.nombre 'Hotel', hab.numero '#', COUNT(R.id) 'Reservas'
		FROM RESERVA r
		INNER JOIN HABITACION hab
			ON r.id_habitacion = hab.id
		INNER JOIN HOTEL hot
			ON hab.id_hotel = hot.id
		WHERE hab.id = @id_habitation
		GROUP BY hab.id, hot.nombre, hab.numero
	END;
GO

EXEC get_reservations_by_hab_into_table 16;

SELECT * FROM RESERVATIONS_RESULTS;

-- Mismo procedimiento pero con INTO

GO
CREATE PROCEDURE get_reservations_by_hab_into
	@id_habitation INT 
	AS
	BEGIN
		SELECT hab.id, hot.nombre 'Hotel', hab.numero '#', COUNT(R.id) 'Reservas'
		INTO RESERVATIONS_RESULTS_TEMP
		FROM RESERVA r
		INNER JOIN HABITACION hab
			ON r.id_habitacion = hab.id
		INNER JOIN HOTEL hot
			ON hab.id_hotel = hot.id
		WHERE hab.id = @id_habitation
		GROUP BY hab.id, hot.nombre, hab.numero
	END;
GO

-- Con la segunda ejecución falla, al tratar de crear la tabla del into

EXEC get_reservations_by_hab_into 16;

-- *****************************************************
-- 3.	Transacciones.
-- *****************************************************

-- IMPORTANTE:
-- Para poder realizar algunos ejercicion de esta clase es necesario actualizar la base 
-- de datos HotelManagementDB, por lo que se debe:
--		* Agregar la columna "puntos_cliente_frecuente" de tipo INT a la tabla CLIENTE.
--		* Actualizar la columna recien creada con algunos datos.



-- 1.0 	Crear un procedimiento almacenado que permita registrar nuevas reservas
--		Como argumentos se reciben: el la fecha de checkin y checkout, el id de metodo de pago, 
--		el id del cliente y el id de la habitacion.
-- DROP PROCEDURE BOOKING;



-- Ejecutando procedimiento almacenado
-- DELETE FROM RESERVA WHERE id = 201 OR id = 202;



-- Verificando datos:
-- Se observa alguna anomalia en los datos?



--*****************************************************
--	TRANSACCIONES

-- 2.0	Crear un procedimiento almacenado que permita transferir puntos de cliente frecuente entre
--		2 usuarios. Como parametros se deberan recibir el id del usuario emisor, el id del usuario
--		receptor, y la cantidad de puntos a transferir.
--		NOTA: En la primera version de este ejercicio provocar un error de semantica y observar el resultado



-- DROP PROCEDURE TRANSFERIR_PUNTOS;
-- UPDATE CLIENTE SET puntos_cliente_frecuente = 2310 WHERE id=1;
-- UPDATE CLIENTE SET puntos_cliente_frecuente = 4744 WHERE id=2;

-- Ejecutando procedimiento almacenado (se espera un error)



-- Verificando datos



-- 2.1	Crear una versi�n 2 del procedimiento almacenado anterior
--		Utilizar transacciones



--DROP PROCEDURE TRANSFERIR_PUNTOS;
--UPDATE CLIENTE SET puntos_cliente_frecuente = 2949 WHERE id=1;
--UPDATE CLIENTE SET puntos_cliente_frecuente = 3057 WHERE id=2;

-- Ejecutando procedimiento almacenado (se espera un error)



-- Verificando datos



-- Procedimientos almacenados con tratamiento de tablas.
-- 2.2. Crear un procedimiento almacenado que reciba como parametros dos enteros
--		El objetivo es mostrar la ganancia de cada hotel y la suma total de la ganancia
--		Parametro 1: numero entero entre 1 y 12 que representa un mes
--		Parametro 2: numero entero que representa un año.
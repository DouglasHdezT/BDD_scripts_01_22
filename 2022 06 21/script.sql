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



-- DROP FUNCTION dbo.GET_CLIENT_COUNTRY

-- 1.1.1	Ejecutando la funcion.



-- 1.1.2	Ejecutando la funcion en una consulta.



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



-- 1.3 	Crear una funcion que calcula el sub total de la habitacion utilizada en cada reserva
-- Consulta
/*
SELECT R.id, R.checkin, R.checkout, H.id, H.precio, DATEDIFF(DAY, R.checkin, R.checkout)
FROM RESERVA R 
    INNER JOIN HABITACION H 
        ON H.id = R.id_habitacion;
*/



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



-- 1.3	Crear una funcion que calcule el total de una reserva
--		La funcion recibira como parametro el id de una reserva.



-- 1.3.1	Haciendo uso de la funcion



-- 1.4	Crear la funcion llamada, RESERVA_DETALLE. Debe mostrar el subtotal
--		obtenido de la multiplicaci�n del precio de la habitaci�n y el numero de dias reservados (A).
--		mostrar el total de la suma de los servicios extra incluidos (B).
--		y el total resultante de toda la reserva (A+B).



-- *****************************************************
-- 2.	Procedimientos almacenados basicos.
-- *****************************************************

-- 2.1	Crear un procedimiento almacenado que reciba como par�metro el id
--		de una habitaci�n y retorne la cantidad de veces que ha sido reservada



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
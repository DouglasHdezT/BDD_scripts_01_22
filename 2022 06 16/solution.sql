--****************************************************
-- Bases de datos: Introduccion a T-SQL
-- Autor: Douglas Hernández
-- Correspondencia: dohernandez@uca.edu.sv
-- Version: 1.0
--****************************************************

SELECT * FROM CLIENTE;

-- *****************************************************
-- 1.	T-SQL
-- *****************************************************
-- 1.0	Declarando variables T-SQL
DECLARE @variable varchar(15);
SET @variable = 'bases de datos';
-- Imprimiendo variables.
PRINT @variable;
-- Concatenando cadenas de texto:
PRINT @variable + ' relacionales.';

-- 1.1	Concantenando numeros
DECLARE @numero2 INT;
SET @numero2 = 25;
--PRINT 'el numero es ' +  @numero2; -- falla!
PRINT 'el numero es '+CONVERT(VARCHAR(2),@numero2);

-- Integrando T-SQL con SQL
-- 1.2  Mostrar las habitaciones que hayan sido reservadas durante al menos 10 dias 
--		durante junio de 2022.
-- Consulta original:
/*SELECT H.id 'id habitacion', H.numero, SUM(DATEDIFF (DAY, R.checkin, R.checkout)) 'dias en reserva'
FROM RESERVA R, HABITACION H
WHERE R.id_habitacion = H.id
	AND MONTH(R.checkin) = 6
GROUP BY H.id, H.numero
HAVING SUM(DATEDIFF (DAY, R.checkin, R.checkout)) >= 10
ORDER BY H.id ASC;*/

DECLARE @mes INT, 
		@dias_objetivo INT
SET @mes = 6
SET @dias_objetivo = 10
SELECT H.id 'id habitacion', H.numero, SUM(DATEDIFF (DAY, R.checkin, R.checkout)) 'dias en reserva'
FROM RESERVA R, HABITACION H
WHERE R.id_habitacion = H.id
	AND MONTH(R.checkin) = @mes
GROUP BY H.id, H.numero
HAVING SUM(DATEDIFF (DAY, R.checkin, R.checkout)) >= @dias_objetivo
ORDER BY H.id ASC;

-- 2.0	¿cuantos clientes hay por cada pais?
-- Consulta original:
/*SELECT p.pais, COUNT(c.nombre) as 'cantidad de clientes'
FROM pais p LEFT JOIN cliente c
ON p.id = c.id_pais
GROUP BY  p.pais
ORDER BY COUNT(c.nombre) DESC;*/

--Utilizando CASE para dar formato a la salida de una consulta.
SELECT p.id, p.pais,
		CASE COUNT(c.nombre)
			WHEN 0 THEN
				'Sin clientes registrados'
			WHEN 1 THEN
				'1 cliente'
			ELSE
				CONCAT(COUNT(c.nombre), ' clientes')
		END as 'Cantidad lientes'
FROM pais p LEFT JOIN cliente c
ON p.id = c.id_pais
GROUP BY p.id, p.pais
ORDER BY COUNT(c.nombre) DESC;

-- 3.0	Eliminando sub-consultas al utilizar T-SQL
-- 3.1	¿Cual es el porcentaje de clientes que vienen de cada pais?
-- partiendo de esta subconsulta:
/*
SELECT P.id, P.pais, CONCAT((CAST(COUNT(C.nombre) AS FLOAT)/(SELECT COUNT(*) FROM CLIENTE))*100,'%') 'cantidad de clientes'
FROM PAIS P 
	LEFT JOIN CLIENTE C
ON P.id = C.id_pais
GROUP BY P.id, P.pais
ORDER BY COUNT(C.nombre) DESC;*/

DECLARE @cantidad_clientes FLOAT;
SELECT @cantidad_clientes = COUNT(*) FROM cliente;
SELECT P.id, P.pais, CONCAT((CAST(COUNT(C.nombre) AS FLOAT)/@cantidad_clientes)*100,'%') 'cantidad de clientes'
FROM PAIS P 
	LEFT JOIN CLIENTE C
ON P.id = C.id_pais
GROUP BY P.id, P.pais
ORDER BY COUNT(C.nombre) DESC;

-- 3.2  Mostrar la lista de clientes 'VIP'
--		Un cliente VIP se define si el promedio del total de cada reserva es mayor a $1000
-- partiendo de esta subconsulta:
SELECT reserva_total.id_cliente, reserva_total.nombre, AVG(reserva_total.total) 'promedio'
FROM (
	SELECT C.id 'id_cliente', C.nombre, ((DATEDIFF (DAY, R.checkin, R.checkout)*H.precio)+ISNULL(SUM(S.precio),0)) 'total'
	FROM CLIENTE C 
		INNER JOIN RESERVA R
			ON C.id = R.id_cliente_reserva
		INNER JOIN HABITACION H
			ON H.id = R.id_habitacion
		LEFT JOIN EXTRA X
			ON R.id = X.id_reserva
		LEFT JOIN SERVICIO S
			ON S.id = X.id_servicio
	GROUP BY R.id, R.checkin, R.checkout, C.id, C.nombre, H.precio
) reserva_total
GROUP BY reserva_total.id_cliente, reserva_total.nombre
HAVING AVG(reserva_total.total) >= 550.00
ORDER BY reserva_total.id_cliente ASC;

DECLARE @RESERVA_DETALLE TABLE(
	id_cliente INT NOT NULL,
	nombre VARCHAR(50) NOT NULL,
	total_reserva FLOAT NOT NULL
);
INSERT INTO @RESERVA_DETALLE (id_cliente,nombre,total_reserva)
SELECT C.id 'id_cliente', C.nombre, ((DATEDIFF (DAY, R.checkin, R.checkout)*H.precio)+ISNULL(SUM(S.precio),0)) 'total'
	FROM CLIENTE C 
		INNER JOIN RESERVA R
			ON C.id = R.id_cliente_reserva
		INNER JOIN HABITACION H
			ON H.id = R.id_habitacion
		LEFT JOIN EXTRA X
			ON R.id = X.id_reserva
		LEFT JOIN SERVICIO S
			ON S.id = X.id_servicio
	GROUP BY R.id, R.checkin, R.checkout, C.id, C.nombre, H.precio
	ORDER BY C.id ASC;

SELECT R.id_cliente, R.nombre, AVG(R.total_reserva) 'promedio'
FROM @RESERVA_DETALLE R
GROUP BY R.id_cliente, R.nombre
HAVING AVG(R.total_reserva) >= 550.00
ORDER BY R.id_cliente ASC;
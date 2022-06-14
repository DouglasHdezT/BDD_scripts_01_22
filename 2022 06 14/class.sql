--****************************************************
-- Bases de datos: Sub consultas
-- Autor: Douglas Hernández
-- Correspondencia: dohernandez@uca.edu.sv
-- Version: 1.0
--****************************************************

-- *****************************************************
-- 1.	Subconsultas
-- *****************************************************

-- 1.1	¿Cual es el porcentaje de clientes que vienen de cada pais?

-- Paso 1: 		Contando cantidad de clientes que vienen de cada pais y total de clientes. Antes de iniciar el ejercicio, borrar los dos clientes que utilizamos en la clase de JOINS

DELETE FROM CLIENTE WHERE id = 51 OR id = 52;

SELECT p.id, p.pais, COUNT(c.nombre) as 'Cant. de personas'
FROM PAIS p
LEFT JOIN CLIENTE c
	ON c.id_pais = p.id
GROUP BY p.id, p.pais
ORDER BY COUNT(c.nombre) DESC;

-- Paso 2: 		Mostrando la lista de paises y el promedio a partir de la divisiòn de la cantidad de clientes de cada pais entre la cantidad total de clientes

SELECT COUNT(*) FROM CLIENTE;

SELECT p.id, p.pais, 
	(COUNT(c.nombre) / (SELECT COUNT(*) FROM CLIENTE)) as '% de personas'
FROM PAIS p
LEFT JOIN CLIENTE c
	ON c.id_pais = p.id
GROUP BY p.id, p.pais
ORDER BY COUNT(c.nombre) DESC;

-- Paso 2.5:	Aplicando un casteo a float

SELECT p.id, p.pais, 
	(CAST(COUNT(c.nombre) as float) / (SELECT COUNT(*) FROM CLIENTE)) as '% de personas'
FROM PAIS p
LEFT JOIN CLIENTE c
	ON c.id_pais = p.id
GROUP BY p.id, p.pais
ORDER BY COUNT(c.nombre) DESC;


-- paso 3: 		Dando formato al resultado:

SELECT p.id, p.pais, 
	CONCAT((CAST(COUNT(c.nombre) as float) / (SELECT COUNT(*) FROM CLIENTE) * 100), ' %' )
		as '% de personas'
FROM PAIS p
LEFT JOIN CLIENTE c
	ON c.id_pais = p.id
GROUP BY p.id, p.pais
ORDER BY COUNT(c.nombre) DESC;

-- 1.2  Mostrar la lista de clientes 'VIP'; Nuestro criterio cambia: un cliente adquiere el estado VIP si el promedio de sus estancias es igual o mayor a $550.00 partiendo de esta consulta:

SELECT R.id, R.checkin, R.checkout, C.nombre,
			((DATEDIFF (DAY, R.checkin, R.checkout)*H.precio)+ISNULL(SUM(S.precio),0)) 'TOTAL RESERVA'
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

-- paso 1:		Removiendo columnas de poco interes.

SELECT C.id, C.nombre,
			((DATEDIFF (DAY, R.checkin, R.checkout)*H.precio)+ISNULL(SUM(S.precio),0)) 'TOTAL RESERVA'
FROM CLIENTE C 
	INNER JOIN RESERVA R
		ON C.id = R.id_cliente_reserva
	INNER JOIN HABITACION H
		ON H.id = R.id_habitacion
	LEFT JOIN EXTRA X
		ON R.id = X.id_reserva
	LEFT JOIN SERVICIO S
		ON S.id = X.id_servicio
GROUP BY R.checkin, R.checkout, C.id, C.nombre, H.precio
ORDER BY C.id ASC;

-- paso 2:		Calculando promedio
-- ESTO DA ERROR -> FA(FA())
SELECT C.id, C.nombre,
			AVG((DATEDIFF (DAY, R.checkin, R.checkout)*H.precio)+ISNULL(SUM(S.precio),0)) 'TOTAL RESERVA'
FROM CLIENTE C 
	INNER JOIN RESERVA R
		ON C.id = R.id_cliente_reserva
	INNER JOIN HABITACION H
		ON H.id = R.id_habitacion
	LEFT JOIN EXTRA X
		ON R.id = X.id_reserva
	LEFT JOIN SERVICIO S
		ON S.id = X.id_servicio
GROUP BY R.checkin, R.checkout, C.id, C.nombre, H.precio
ORDER BY C.id ASC;

-- Paso 2.5: 	Aplicando subconsultas

SELECT ticket.id, ticket.nombre, AVG(ticket.total)
FROM (
	SELECT C.id, C.nombre,
			((DATEDIFF (DAY, R.checkin, R.checkout)*H.precio)+ISNULL(SUM(S.precio),0)) 'total'
	FROM CLIENTE C 
		INNER JOIN RESERVA R
			ON C.id = R.id_cliente_reserva
		INNER JOIN HABITACION H
			ON H.id = R.id_habitacion
		LEFT JOIN EXTRA X
			ON R.id = X.id_reserva
		LEFT JOIN SERVICIO S
			ON S.id = X.id_servicio
	GROUP BY R.checkin, R.checkout, C.id, C.nombre, H.precio
) ticket
GROUP BY ticket.id, ticket.nombre;

-- Paso 3: 		Aplicando filtro para identificar a los clientes VIP

SELECT ticket.id, ticket.nombre, AVG(ticket.total)
FROM (
	SELECT C.id, C.nombre,
			((DATEDIFF (DAY, R.checkin, R.checkout)*H.precio)+ISNULL(SUM(S.precio),0)) 'total'
	FROM CLIENTE C 
		INNER JOIN RESERVA R
			ON C.id = R.id_cliente_reserva
		INNER JOIN HABITACION H
			ON H.id = R.id_habitacion
		LEFT JOIN EXTRA X
			ON R.id = X.id_reserva
		LEFT JOIN SERVICIO S
			ON S.id = X.id_servicio
	GROUP BY R.checkin, R.checkout, C.id, C.nombre, H.precio
) ticket
GROUP BY ticket.id, ticket.nombre
HAVING AVG(ticket.total) >= 550
ORDER BY ticket.id;

-- 1.3	Agregar una columna a la tabla cliente llamada 'vip' de tipo entero. Configurar el valor 1 a todos los usuarios VIP

ALTER TABLE CLIENTE ADD vip TINYINT NOT NULL DEFAULT 0;
SELECT * FROM CLIENTE;

-- Paso 1: 		Obteniendo id de los usuarios VIP a partir de la consulta del ejercicio anterior

SELECT ticket.id
FROM (
	SELECT C.id, C.nombre,
			((DATEDIFF (DAY, R.checkin, R.checkout)*H.precio)+ISNULL(SUM(S.precio),0)) 'total'
	FROM CLIENTE C 
		INNER JOIN RESERVA R
			ON C.id = R.id_cliente_reserva
		INNER JOIN HABITACION H
			ON H.id = R.id_habitacion
		LEFT JOIN EXTRA X
			ON R.id = X.id_reserva
		LEFT JOIN SERVICIO S
			ON S.id = X.id_servicio
	GROUP BY R.checkin, R.checkout, C.id, C.nombre, H.precio
) ticket
GROUP BY ticket.id
HAVING AVG(ticket.total) >= 550
ORDER BY ticket.id;

-- Paso 2: 		Actualizando a los clientes VIP

-- Esto sería estático

UPDATE CLIENTE SET vip = 1 WHERE id IN (11,31,36,42,46)

-- Subqueries

UPDATE CLIENTE SET vip = 1 WHERE id IN (
	SELECT ticket.id
		FROM (
			SELECT C.id, C.nombre,
					((DATEDIFF (DAY, R.checkin, R.checkout)*H.precio)+ISNULL(SUM(S.precio),0)) 'total'
			FROM CLIENTE C 
				INNER JOIN RESERVA R
					ON C.id = R.id_cliente_reserva
				INNER JOIN HABITACION H
					ON H.id = R.id_habitacion
				LEFT JOIN EXTRA X
					ON R.id = X.id_reserva
				LEFT JOIN SERVICIO S
					ON S.id = X.id_servicio
			GROUP BY R.checkin, R.checkout, C.id, C.nombre, H.precio
		) ticket
		GROUP BY ticket.id
		HAVING AVG(ticket.total) >= 550
);

SELECT * FROM CLIENTE;

-- Extra: 		Borrando columna VIP en table cliente

ALTER TABLE CLIENTE DROP COLUMN vip;
SELECT * FROM CLIENTE;

-- 1.4 	Mostrar en una vista los 2 servicios que más ingresos generan y los 2 servicios que menos ingresos generan

-- Paso 1: 		Mostrando ganancia de cada servicio

SELECT S.id, S.nombre, SUM(s.precio)
FROM EXTRA x
INNER JOIN SERVICIO s
	ON x.id_servicio = s.id
GROUP BY S.id, S.nombre
ORDER BY SUM(s.precio) DESC;

-- Paso 2: 		Mostrando servicios que mayores ganancias tienen

SELECT TOP 2 S.id, S.nombre, SUM(s.precio)
FROM EXTRA x
INNER JOIN SERVICIO s
	ON x.id_servicio = s.id
GROUP BY S.id, S.nombre
ORDER BY SUM(s.precio) DESC;

-- Paso 3: 		Mostrando servicios que menores ganancias tienen

SELECT TOP 2 S.id, S.nombre, SUM(s.precio)
FROM EXTRA x
INNER JOIN SERVICIO s
	ON x.id_servicio = s.id
GROUP BY S.id, S.nombre
ORDER BY SUM(s.precio) ASC;

-- Paso 4: Mostrando el resultado en una sola vista:

SELECT S.id, S.nombre, SUM(s.precio)
FROM EXTRA x
INNER JOIN SERVICIO s
	ON x.id_servicio = s.id
WHERE 
	s.id IN (
		SELECT TOP 2 S.id
		FROM EXTRA x
		INNER JOIN SERVICIO s
			ON x.id_servicio = s.id
		GROUP BY S.id, S.nombre
		ORDER BY SUM(s.precio) DESC
	) 
	OR 
	s.id IN (
		SELECT TOP 2 S.id
		FROM EXTRA x
		INNER JOIN SERVICIO s
			ON x.id_servicio = s.id
		GROUP BY S.id, S.nombre
		ORDER BY SUM(s.precio) ASC
	)
GROUP BY S.id, S.nombre
ORDER BY SUM(s.precio) DESC;
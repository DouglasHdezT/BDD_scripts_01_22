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

DECLARE @variable VARCHAR(50);
SET @variable = 'Bases de datos, Ciclo 01/2022';

-- 1.1  Imprimiendo variables.

PRINT @variable;

-- 1.2  Concatenando cadenas de texto:

PRINT @variable + ', DEI, UCA.';

-- 1.3	Concantenando numeros

DECLARE @x INT, @y INT, @z INT;
SET @x = 25;
SET @y = 50;
SET @z = @x * @y;

PRINT @z;

PRINT 'El resultado es: ' + CONVERT(VARCHAR(10), @z);

-- Integrando T-SQL con SQL
-- 2.0  Mostrar las habitaciones que hayan sido reservadas al menos 10 dias durante junio de 2022.
-- Consulta original:
/*
    SELECT H.id 'id habitacion', H.numero, 
        SUM(DATEDIFF (DAY, R.checkin, R.checkout)) 'dias en reserva'
    FROM RESERVA R 
    INNER JOIN HABITACION H
        ON R.id_habitacion = H.id
    WHERE MONTH(R.checkin) = 6
    GROUP BY H.id, H.numero
    HAVING SUM(DATEDIFF (DAY, R.checkin, R.checkout)) >= 10
    ORDER BY H.id ASC;
*/

DECLARE @month INT, @days_qnt INT;
SET @month = 5;
SET @days_qnt = 10;

SELECT H.id 'id habitacion', H.numero, 
    SUM(DATEDIFF (DAY, R.checkin, R.checkout)) 'dias en reserva'
FROM RESERVA R 
INNER JOIN HABITACION H
    ON R.id_habitacion = H.id
WHERE MONTH(R.checkin) = @month
GROUP BY H.id, H.numero
HAVING SUM(DATEDIFF (DAY, R.checkin, R.checkout)) >= @days_qnt
ORDER BY H.id ASC;

-- 3.0	¿cuantos clientes hay por cada pais?
-- Consulta original:
/*
    SELECT p.pais, COUNT(c.nombre) as 'cantidad de clientes'
    FROM pais p 
    LEFT JOIN cliente c
        ON p.id = c.id_pais
    GROUP BY  p.pais
    ORDER BY COUNT(c.nombre) DESC;
*/

--Utilizando CASE para dar formato a la salida de una consulta.

SELECT p.pais, 
    CASE(COUNT(c.nombre))
        WHEN 0 THEN
            'Sin clientes'
        WHEN 1 THEN
            '1 Cliente'
        ELSE
            CONCAT(COUNT(c.nombre), ' Clientes')
    END as 'cantidad de clientes'
FROM pais p 
LEFT JOIN cliente c
    ON p.id = c.id_pais
GROUP BY  p.pais
ORDER BY COUNT(c.nombre) DESC;

-- 4.0	Eliminando sub-consultas al utilizar T-SQL
-- 4.1	¿Cual es el porcentaje de clientes que vienen de cada pais?
-- Partiendo de esta subconsulta:
/*
    SELECT P.id, P.pais, 
        CONCAT((CAST(COUNT(C.nombre) AS FLOAT)/(SELECT COUNT(*) FROM CLIENTE))*100,'%') 'cantidad de clientes'
    FROM PAIS P 
    LEFT JOIN CLIENTE C
        ON P.id = C.id_pais
    GROUP BY P.id, P.pais
    ORDER BY COUNT(C.nombre) DESC;
*/

DECLARE @people_qnt FLOAT;
SELECT @people_qnt = COUNT(*) FROM CLIENTE;

SELECT P.id, P.pais, 
    CONCAT((CAST(COUNT(C.nombre) AS FLOAT)/(@people_qnt))*100,'%') 'cantidad de clientes'
FROM PAIS P 
LEFT JOIN CLIENTE C
    ON P.id = C.id_pais
GROUP BY P.id, P.pais
ORDER BY COUNT(C.nombre) DESC;

-- 4.2  Mostrar la lista de clientes 'VIP'Un cliente VIP se define si el promedio del total de cada reserva es mayor a $1000
-- partiendo de esta subconsulta:
/*
    SELECT ticket.id, ticket.nombre, AVG(ticket.total) promedio
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
*/

DECLARE @TICKETS TABLE (
    client_id INT NOT NULL,
    client_name VARCHAR(50) NOT NULL,
    total FLOAT NOT NULL
)

INSERT INTO @TICKETS(client_id, client_name, total)
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
GROUP BY R.checkin, R.checkout, C.id, C.nombre, H.precio;

SELECT ticket.client_id, ticket.client_name, AVG(ticket.total) promedio
FROM @TICKETS ticket
GROUP BY ticket.client_id, ticket.client_name
HAVING AVG(ticket.total) >= 550
ORDER BY ticket.client_id;
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



-- 1.1  Imprimiendo variables.



-- 1.2  Concatenando cadenas de texto:



-- 1.3	Concantenando numeros



-- Integrando T-SQL con SQL
-- 2.0  Mostrar las habitaciones que hayan sido reservadas durante al menos 10 dias durante junio de 2022.
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
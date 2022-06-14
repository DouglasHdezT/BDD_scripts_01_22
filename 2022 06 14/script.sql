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

-- Paso 2: 		Mostrando la lista de paises y el promedio a partir de la divisiòn de la cantidad de clientes de cada pais entre la cantidad total de clientes




-- Paso 2.5:	Aplicando un casteo a float



-- paso 3: 		Dando formato al resultado:



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



-- paso 2:		Calculando promedio



-- Paso 2.5: 	Aplicando subconsultas



-- Paso 3: 		Aplicando filtro para identificar a los clientes VIP



-- 1.3	Agregar una columna a la tabla cliente llamada 'vip' de tipo entero. Configurar el valor 1 a todos los usuarios VIP

ALTER TABLE CLIENTE ADD vip TINYINT NOT NULL DEFAULT 0;
SELECT * FROM CLIENTE;

-- Paso 1: 		Obteniendo id de los usuarios VIP a partir de la consulta del ejercicio anterior


-- Paso 2: 		Actualizando a los clientes VIP



-- Extra: 		Borrando columna VIP en table cliente

ALTER TABLE CLIENTE DROP COLUMN vip;
SELECT * FROM CLIENTE;

-- 1.4 	Mostrar en una vista los 2 servicios que más ingresos generan y los 2 servicios que menos ingresos generan

-- Paso 1: 		Mostrando ganancia de cada servicio



-- Paso 2: 		Mostrando servicios que mayores ganancias tienen



-- Paso 3: 		Mostrando servicios que menores ganancias tienen



-- Paso 4: Mostrando el resultado en una sola vista:
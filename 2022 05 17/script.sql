--****************************************************
-- Bases de datos: Introducción a SQL
-- Autor: Douglas Hernández
-- Correspondencia: dohernandez@uca.edu.sv
-- Version: 1.0
--****************************************************

-- 01.1     JOIN USANDO FROM EN EL SELECT

SELECT H.id, H.nombre, H.telefono, Cat.categoria
FROM HOTEL H, CATEGORIA_HOTEL Cat;

-- 01.2     JOIN USANDO FROM Y DELIMITANDO

SELECT H.id, H.nombre, H.telefono, Cat.categoria
FROM HOTEL H, CATEGORIA_HOTEL Cat
WHERE H.id_categoria_hotel = Cat.id;

-- 02.0     USO DE LAS INSTRUCCIONES JOIN
-- 02.1     PREPARANDO EL TERRENO - MODIFICACIÓN PARA TENER CAMPOS NULOS EN LAS FK

DELETE FROM CLIENTE WHERE id in(51, 52);
ALTER TABLE CLIENTE ALTER COLUMN id_pais INT NOT NULL;

ALTER TABLE CLIENTE ALTER COLUMN id_pais INT NULL;
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (51,'Finley Armstrong','M26375757',NULL,5);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (52,'Naomi Lee','X14183183',NULL,1);

-- 02.2     INNER JOIN



-- 02.3     LEFT JOIN



-- 02.3     LEFT JOIN EXCLUSIVE



-- 02.4     RIGHT JOIN



-- 02.5     RIGHT JOIN EXCLUSIVE



-- 02.6     FULL JOIN



-- 02.7     FULL JOIN EXCLUSIVE



-- 03.0     EJEMPLOS
-- 03.1     EX.1: Mostrar el id, nombre, dirección de cada hotel y el titulo de la categoría a la que pertenece



-- 03.2     EX.2: Mostrar toda la información de cada cliente, la vista debe incluir el nombre del pais al cual pertenece y el tipo de cliente que es.

-- 03.2.1   VERSION CON FROM



-- 03.2.2   VERSION CON JOINS



-- 03.3     EX.3: Mostrar toda la información de cada cliente, la vista debe incluir el nombre del pais al cual pertenece y el tipo de cliente que es, y filtrar por el tipo 'viajero'.



-- 03.4     EX.4: ¿Existe algún cliente que no ha registrado ningún correo electrónico?, si es así, realizar una consulta que identifique a este grupo de clientes



-- 03.5     EX.5: Mostrar todas las reservas realizadas para la segunda semana de Mayo. Incluir el nombre del cliente que ha realizado la reserva, el método de pago, que habitacion reservó junto a su tipo, y el hotel en el que se hospedará.

-- 03.5.1   FILTRAR FECHAS DE LA RESERVA



-- 03.5.2   AÑADIR CLIENTE



-- 03.5.3   AÑADIR METODO DE PAGO



-- 03.5.4   AÑADIR HABITACION



-- 03.5.6   AÑADIR TIPO DE HABITACIÓN



-- 03.5.7 AÑADIENDO HOTEL
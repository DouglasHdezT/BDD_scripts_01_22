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

SELECT p.id, p.pais, c.id, c.nombre, c.documento, c.id_pais
FROM PAIS p
	INNER JOIN CLIENTE c
ON p.id = c.id_pais;

-- 02.3     LEFT JOIN

SELECT p.id, p.pais, c.id, c.nombre, c.documento, c.id_pais
FROM PAIS p
	LEFT JOIN CLIENTE c
ON p.id = c.id_pais;

-- 02.3     LEFT JOIN EXCLUSIVE

SELECT p.id, p.pais, c.id, c.nombre, c.documento, c.id_pais
FROM PAIS p
	LEFT JOIN CLIENTE c
ON p.id = c.id_pais
WHERE c.id IS NULL;

-- 02.4     RIGHT JOIN

SELECT p.id, p.pais, c.id, c.nombre, c.documento, c.id_pais
FROM PAIS p
	RIGHT JOIN CLIENTE c
ON p.id = c.id_pais;

-- 02.5     RIGHT JOIN EXCLUSIVE

SELECT p.id, p.pais, c.id, c.nombre, c.documento, c.id_pais
FROM PAIS p
	RIGHT JOIN CLIENTE c
ON p.id = c.id_pais
WHERE p.id IS NULL;

-- 02.6     FULL JOIN

SELECT p.id, p.pais, c.id, c.nombre, c.documento, c.id_pais
FROM PAIS p
	FULL OUTER JOIN CLIENTE c
ON p.id = c.id_pais;

-- 02.7     FULL JOIN EXCLUSIVE

SELECT p.id, p.pais, c.id, c.nombre, c.documento, c.id_pais
FROM PAIS p
	FULL OUTER JOIN CLIENTE c
ON p.id = c.id_pais
WHERE p.id IS NULL OR c.id IS NULL;

-- 03.0     EJEMPLOS
-- 03.1     EX.1: Mostrar el id, nombre, dirección de cada hotel y el titulo de la categoría a la que pertenece

SELECT h.id, h.nombre, h.direccion, c.categoria
FROM HOTEL h 
    INNER JOIN CATEGORIA_HOTEL c 
ON h.id_categoria_hotel = c.id;

-- 03.2     EX.2: Mostrar toda la información de cada cliente, la vista debe incluir el nombre del pais al cual pertenece y el tipo de cliente que es.

-- 03.2.1   VERSION CON FROM

SELECT c.id, c.nombre, p.pais, cc.categoria
FROM cliente c, pais p, categoria_cliente cc
WHERE c.id_pais = p.id
	AND c.categoria_cliente = cc.id;

-- 03.2.2   VERSION CON JOINS

SELECT c.id, c.nombre, p.pais, cc.categoria
FROM cliente c
INNER JOIN pais p
    ON p.id = c.id_pais
INNER JOIN categoria_cliente cc
    ON cc.id = c.categoria_cliente;

-- 03.3     EX.3: Mostrar toda la información de cada cliente, la vista debe incluir el nombre del pais al cual pertenece y el tipo de cliente que es, y filtrar por el tipo 'viajero'.

SELECT c.id, c.nombre, p.pais, cc.categoria
FROM cliente c
INNER JOIN pais p
    ON p.id = c.id_pais
INNER JOIN categoria_cliente cc
    ON cc.id = c.categoria_cliente
WHERE cc.categoria = 'viajero';

-- 03.4     EX.4: ¿Existe algún cliente que no ha registrado ningún correo electrónico?, si es así, realizar una consulta que identifique a este grupo de clientes

SELECT c.id, c.nombre, c.documento, cc.correo
FROM CLIENTE c
    LEFT JOIN CORREO_CLIENTE cc
ON cc.id_cliente = c.id
WHERE cc.id IS NULL;

-- 03.5     EX.5: Mostrar todas las reservas realizadas para la segunda semana de Mayo. Incluir el nombre del cliente que ha realizado la reserva, el método de pago, que habitacion reservó junto a su tipo, y el hotel en el que se hospedará.

-- 03.5.1   FILTRAR FECHAS DE LA RESERVA

SELECT r.id 'id de reserva', r.checkin, r.checkout
FROM RESERVA r
WHERE r.checkin BETWEEN '2022-05-09' AND '2022-05-15';

-- 03.5.2   AÑADIR CLIENTE

SELECT r.id 'id de reserva', r.checkin, r.checkout, 
    c.documento 'identificación de cliente', c.nombre 'Nombre de cliente'
FROM RESERVA r
INNER JOIN CLIENTE c
    ON r.id_cliente_reserva = c.id
WHERE r.checkin BETWEEN '2022-05-09' AND '2022-05-15';

-- 03.5.3   AÑADIR METODO DE PAGO

SELECT r.id 'id de reserva', r.checkin, r.checkout, 
    c.documento 'identificación de cliente', c.nombre 'Nombre de cliente',
    mp.metodo_pago 'Método de pago'
FROM RESERVA r
INNER JOIN CLIENTE c
    ON r.id_cliente_reserva = c.id
INNER JOIN METODO_PAGO mp
    ON r.id_metodo_pago = mp.id
WHERE r.checkin BETWEEN '2022-05-09' AND '2022-05-15';

-- 03.5.4   AÑADIR HABITACION

SELECT r.id 'id de reserva', r.checkin, r.checkout, 
    c.documento 'identificación de cliente', c.nombre 'Nombre de cliente',
    mp.metodo_pago 'Método de pago',
    H.numero 'Número de habitación'
FROM RESERVA r
INNER JOIN CLIENTE c
    ON r.id_cliente_reserva = c.id
INNER JOIN METODO_PAGO mp
    ON r.id_metodo_pago = mp.id
INNER JOIN HABITACION H
    ON r.id_habitacion = H.id
WHERE r.checkin BETWEEN '2022-05-09' AND '2022-05-15';

-- 03.5.6   AÑADIR TIPO DE HABITACIÓN

SELECT r.id 'id de reserva', r.checkin, r.checkout, 
    c.documento 'identificación de cliente', c.nombre 'Nombre de cliente',
    mp.metodo_pago 'Método de pago',
    h.numero 'Número de habitación', th.tipo 'Tipo de habitación'
FROM RESERVA r
INNER JOIN CLIENTE c
    ON r.id_cliente_reserva = c.id
INNER JOIN METODO_PAGO mp
    ON r.id_metodo_pago = mp.id
INNER JOIN HABITACION h
    ON r.id_habitacion = h.id
INNER JOIN TIPO_HABITACION th
    ON h.id_tipo_habitacion = th.id
WHERE r.checkin BETWEEN '2022-05-09' AND '2022-05-15';

-- 03.5.7 AÑADIENDO HOTEL

SELECT r.id 'id de reserva', r.checkin, r.checkout, 
    c.documento 'identificación de cliente', c.nombre 'Nombre de cliente',
    mp.metodo_pago 'Método de pago',
    ho.nombre 'Hotel', ho.direccion 'Dirección del hotel',
    h.numero 'Número de habitación', th.tipo 'Tipo de habitación'
FROM RESERVA r
INNER JOIN CLIENTE c
    ON r.id_cliente_reserva = c.id
INNER JOIN METODO_PAGO mp
    ON r.id_metodo_pago = mp.id
INNER JOIN HABITACION h
    ON r.id_habitacion = h.id
INNER JOIN TIPO_HABITACION th
    ON h.id_tipo_habitacion = th.id
INNER JOIN HOTEL ho
    ON h.id_hotel = ho.id
WHERE r.checkin BETWEEN '2022-05-09' AND '2022-05-15';
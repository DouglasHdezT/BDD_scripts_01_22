--****************************************************
-- Bases de datos: Introducción a SQL
-- Autor: Douglas Hernández
-- Correspondencia: dohernandez@uca.edu.sv
-- Version: 1.0
--****************************************************

-- 01.1     JOIN USANDO FROM EN EL SELECT

SELECT H.id, H.nombre, H.telefono, H.id_categoria_hotel, Cat.id, Cat.categoria
FROM HOTEL H, CATEGORIA_HOTEL Cat;

-- 01.2     JOIN USANDO FROM Y DELIMITANDO

SELECT H.id, H.nombre, H.telefono, Cat.categoria
FROM HOTEL H, CATEGORIA_HOTEL Cat
WHERE H.id_categoria_hotel = Cat.id;

-- 02.0     USO DE LAS INSTRUCCIONES JOIN
-- 02.1     PREPARANDO EL TERRENO - MODIFICACIÓN PARA TENER CAMPOS NULOS EN LAS FK

-- DELETE FROM CLIENTE WHERE id in(51, 52);
-- ALTER TABLE CLIENTE ALTER COLUMN id_pais INT NOT NULL;

ALTER TABLE CLIENTE ALTER COLUMN id_pais INT NULL;
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (51,'Finley Armstrong','M26375757',NULL,5);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (52,'Naomi Lee','X14183183',NULL,1);

-- 02.2     INNER JOIN

SELECT * FROM CLIENTE;

SELECT c.nombre, c.documento, p.pais
FROM PAIS p
INNER JOIN CLIENTE c
    ON c.id_pais = p.id;

-- 02.3     LEFT JOIN

SELECT c.nombre, c.documento, p.pais
FROM PAIS p
LEFT JOIN CLIENTE c
    ON c.id_pais = p.id;

-- 02.3     LEFT JOIN EXCLUSIVE: ¿Qué paises no tiene clientes asignados?

SELECT c.nombre, c.documento, p.pais
FROM PAIS p
LEFT JOIN CLIENTE c
    ON c.id_pais = p.id
WHERE c.id IS NULL;

-- 02.4     RIGHT JOIN

SELECT c.nombre, c.documento, p.pais
FROM PAIS p
RIGHT JOIN CLIENTE c
    ON c.id_pais = p.id;

-- 02.5     RIGHT JOIN EXCLUSIVE: ¿Qué clientes no tienen un pais asignado?

SELECT c.nombre, c.documento, p.pais
FROM PAIS p
RIGHT JOIN CLIENTE c
    ON c.id_pais = p.id
WHERE c.id_pais IS NULL;

-- 02.6     FULL JOIN

SELECT c.nombre, c.documento, p.pais
FROM PAIS p
FULL OUTER JOIN CLIENTE c
    ON c.id_pais = p.id;

-- 02.7     FULL JOIN EXCLUSIVE

SELECT c.nombre, c.documento, p.pais
FROM PAIS p
FULL OUTER JOIN CLIENTE c
    ON c.id_pais = p.id
WHERE c.id IS NULL OR p.id IS NULL;

-- 03.0     EJEMPLOS
-- 03.1     EX.1: Mostrar el id, nombre, dirección de cada hotel y el titulo de la categoría a la que pertenece

SELECT h.id, h.nombre, h.direccion, ch.categoria
FROM HOTEL h
INNER JOIN CATEGORIA_HOTEL ch
    ON h.id_categoria_hotel = ch.id;

-- 03.2     EX.2: Mostrar toda la información de cada cliente, la vista debe incluir el nombre del pais al cual pertenece y el tipo de cliente que es.

-- 03.2.1   VERSION CON FROM

SELECT c.documento, c.nombre, p.pais, cc.categoria
FROM CLIENTE c, CATEGORIA_CLIENTE cc, PAIS p
WHERE c.id_pais = p.id AND c.categoria_cliente = cc.id;

-- 03.2.2   VERSION CON JOINS

SELECT c.documento, c.nombre, p.pais, cc.categoria
FROM CLIENTE c
INNER JOIN CATEGORIA_CLIENTE cc
    ON c.categoria_cliente = cc.id
INNER JOIN PAIS p
    ON c.id_pais = p.id;


-- 03.3     EX.3: Mostrar toda la información de cada cliente, la vista debe incluir el nombre del pais al cual pertenece y el tipo de cliente que es, y filtrar por el tipo 'viajero'.

SELECT c.documento, c.nombre, p.pais, cc.categoria
FROM CLIENTE c
INNER JOIN CATEGORIA_CLIENTE cc
    ON c.categoria_cliente = cc.id
INNER JOIN PAIS p
    ON c.id_pais = p.id
WHERE cc.categoria = 'viajero';

-- 03.4     EX.4: ¿Existe algún cliente que no ha registrado ningún correo electrónico?, si es así, realizar una consulta que identifique a este grupo de clientes

SELECT * 
FROM CLIENTE;

SELECT * 
FROM CORREO_CLIENTE;

SELECT *
FROM CLIENTE c
LEFT JOIN CORREO_CLIENTE cc
    ON cc.id_cliente = c.id
WHERE cc.id IS NULL;

-- 03.5     EX.5: Mostrar todas las reservas realizadas para la segunda semana de Mayo. Incluir el nombre del cliente que ha realizado la reserva, el método de pago, que habitacion reservó junto a su tipo, y el hotel en el que se hospedará junto a su categoria.

-- 03.5.1   FILTRAR FECHAS DE LA RESERVA

SELECT r.id 'id de Reserva', r.checkin, r.checkout
FROM RESERVA r
WHERE r.checkin BETWEEN '2022-05-08' AND '2022-05-14';

-- 03.5.2   AÑADIR CLIENTE

SELECT r.id 'id de Reserva', r.checkin, r.checkout,
    c.documento 'DUI', c.nombre 'Nombre del Cliente'
FROM RESERVA r
INNER JOIN CLIENTE c
    ON r.id_cliente_reserva = c.id
WHERE r.checkin BETWEEN '2022-05-08' AND '2022-05-14';

-- 03.5.3   AÑADIR METODO DE PAGO

SELECT r.id 'id de Reserva', r.checkin, r.checkout,
    c.documento 'DUI', c.nombre 'Nombre del Cliente',
    mp.metodo_pago 'Método de pago'
FROM RESERVA r
INNER JOIN CLIENTE c
    ON r.id_cliente_reserva = c.id
INNER JOIN METODO_PAGO mp
    ON r.id_metodo_pago = mp.id
WHERE r.checkin BETWEEN '2022-05-08' AND '2022-05-14';

-- 03.5.4   AÑADIR HABITACION

SELECT r.id 'id de Reserva', r.checkin, r.checkout,
    c.documento 'DUI', c.nombre 'Nombre del Cliente',
    mp.metodo_pago 'Método de pago',
    h.numero '# de habitación'
FROM RESERVA r
INNER JOIN CLIENTE c
    ON r.id_cliente_reserva = c.id
INNER JOIN METODO_PAGO mp
    ON r.id_metodo_pago = mp.id
INNER JOIN HABITACION h
    ON r.id_habitacion = h.id
WHERE r.checkin BETWEEN '2022-05-08' AND '2022-05-14';

-- 03.5.6   AÑADIR TIPO DE HABITACIÓN
-- VIENDO LAS FK'S

SELECT *
FROM RESERVA r
INNER JOIN CLIENTE c
    ON r.id_cliente_reserva = c.id
INNER JOIN METODO_PAGO mp
    ON r.id_metodo_pago = mp.id
INNER JOIN HABITACION h
    ON r.id_habitacion = h.id
WHERE r.checkin BETWEEN '2022-05-08' AND '2022-05-14';

-- CONSULTA

SELECT r.id 'id de Reserva', r.checkin, r.checkout,
    c.documento 'DUI', c.nombre 'Nombre del Cliente',
    mp.metodo_pago 'Método de pago',
    h.numero '# de habitación', th.tipo 'Tipo de Habitación'
FROM RESERVA r
INNER JOIN CLIENTE c
    ON r.id_cliente_reserva = c.id
INNER JOIN METODO_PAGO mp
    ON r.id_metodo_pago = mp.id
INNER JOIN HABITACION h
    ON r.id_habitacion = h.id
INNER JOIN TIPO_HABITACION th
    ON h.id_tipo_habitacion = th.id
WHERE r.checkin BETWEEN '2022-05-08' AND '2022-05-14';

-- 03.5.7   AÑADIENDO HOTEL

SELECT r.id 'id de Reserva', r.checkin, r.checkout,
    c.documento 'DUI', c.nombre 'Nombre del Cliente',
    mp.metodo_pago 'Método de pago',
    h.numero '# de habitación', th.tipo 'Tipo de Habitación',
    ht.nombre 'Hotel', ht.telefono 'Contacto', ht.direccion 'Dirección del Hotel'
FROM RESERVA r
INNER JOIN CLIENTE c
    ON r.id_cliente_reserva = c.id
INNER JOIN METODO_PAGO mp
    ON r.id_metodo_pago = mp.id
INNER JOIN HABITACION h
    ON r.id_habitacion = h.id
INNER JOIN TIPO_HABITACION th
    ON h.id_tipo_habitacion = th.id
INNER JOIN HOTEL ht
    ON h.id_hotel = ht.id
WHERE r.checkin BETWEEN '2022-05-08' AND '2022-05-14';

-- 03.5.7   AÑADIENDO CATEGORIA HOTEL

-- VIENDO FK'S

SELECT *
FROM RESERVA r
INNER JOIN CLIENTE c
    ON r.id_cliente_reserva = c.id
INNER JOIN METODO_PAGO mp
    ON r.id_metodo_pago = mp.id
INNER JOIN HABITACION h
    ON r.id_habitacion = h.id
INNER JOIN TIPO_HABITACION th
    ON h.id_tipo_habitacion = th.id
INNER JOIN HOTEL ht
    ON h.id_hotel = ht.id
WHERE r.checkin BETWEEN '2022-05-08' AND '2022-05-14';

-- CONSULTA

SELECT r.id 'id de Reserva', r.checkin, r.checkout,
    c.documento 'DUI', c.nombre 'Nombre del Cliente',
    mp.metodo_pago 'Método de pago',
    h.numero '# de habitación', th.tipo 'Tipo de Habitación',
    ht.nombre 'Hotel', ht.telefono 'Contacto', ht.direccion 'Dirección del Hotel',
    ch.categoria 'Categoría'
FROM RESERVA r
INNER JOIN CLIENTE c
    ON r.id_cliente_reserva = c.id
INNER JOIN METODO_PAGO mp
    ON r.id_metodo_pago = mp.id
INNER JOIN HABITACION h
    ON r.id_habitacion = h.id
INNER JOIN TIPO_HABITACION th
    ON h.id_tipo_habitacion = th.id
INNER JOIN HOTEL ht
    ON h.id_hotel = ht.id
INNER JOIN CATEGORIA_HOTEL ch
    ON ht.id_categoria_hotel = ch.id
WHERE r.checkin BETWEEN '2022-05-08' AND '2022-05-14';
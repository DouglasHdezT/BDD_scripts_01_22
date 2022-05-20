--****************************************************
-- Bases de datos: Introducción a SQL
-- Autor: Douglas Hernández
-- Correspondencia: dohernandez@uca.edu.sv
-- Version: 1.0
--****************************************************

-- 01.0     ORDER BY
-- 01.1     Mostar los datos de la tabla reserva e identificar como estan ordenados los datos... ¿Se utiliza siempre el mismo criterio?

SELECT *
FROM RESERVA;

-- 01.2     Mostrar los datos de la tabla reserva... Ordenar los datos a partir del id de cliente en orden descendente

SELECT *
FROM RESERVA
ORDER BY id DESC;

-- 01.3     Mostrar los datos de la tabla reserva. Incluir el nombre del cliente, el hotel y el numero de habitacion reservada. Ordenar la tabla con respecto al nombre del cliente en forma ascendente.

SELECT r.id, r.checkin, r.checkout, c.nombre 'Cliente', ht.nombre 'Hotel', hab.numero '# Hab'
FROM RESERVA r
INNER JOIN CLIENTE c
    ON r.id_cliente_reserva = c.id
INNER JOIN HABITACION hab
    ON r.id_habitacion = hab.id
INNER JOIN HOTEL ht
    ON hab.id_hotel = ht.id
ORDER BY c.nombre;

-- 01.4     Observar que cada cliente ha realizado 0, 1 o varias reservas, ordenar la lista segun el nombre del cliente en orden descendente y por cada cliente ordenar sus RESERVAS de forma cronologica.

SELECT r.id, r.checkin, r.checkout, c.nombre 'Cliente', ht.nombre 'Hotel', hab.numero '# Hab'
FROM RESERVA r
INNER JOIN CLIENTE c
    ON r.id_cliente_reserva = c.id
INNER JOIN HABITACION hab
    ON r.id_habitacion = hab.id
INNER JOIN HOTEL ht
    ON hab.id_hotel = ht.id
ORDER BY c.nombre DESC, r.checkin;

-- 01.5     Mostrar los datos de la tabla reserva. Incluir el nombre del cliente, el hotel y el nomero de habitacion reservada. Ordenar la tabla con respecto al nombre del cliente en forma ascendente. Como segundo y tercer criterio de orden utilizar el hotel y el numero de habitacion

SELECT r.id, r.checkin, r.checkout, c.nombre 'Cliente', ht.nombre 'Hotel', hab.numero '# Hab'
FROM RESERVA r
INNER JOIN CLIENTE c
    ON r.id_cliente_reserva = c.id
INNER JOIN HABITACION hab
    ON r.id_habitacion = hab.id
INNER JOIN HOTEL ht
    ON hab.id_hotel = ht.id
ORDER BY c.nombre, ht.nombre, hab.numero;

-- 02.0     GROUP BY
-- 02.1     ¿Cuantos clientes hay por cada pais? Ordenar la lista en orden descendente con respecto a la cantidad

SELECT p.pais, COUNT(c.nombre) 'Clientes'
FROM CLIENTE c
INNER JOIN PAIS p
    ON c.id_pais = p.id
GROUP BY p.pais
ORDER BY COUNT(c.nombre) DESC;

-- 02.2     ¿Cuantos clientes hay por cada pais? Ordenar la lista en orden descendente. Incluir en el resultado los paises sin ningún cliente. Ordenar el resultado de forma descendente.

SELECT p.pais, COUNT(c.nombre) 'Clientes'
FROM CLIENTE c
RIGHT JOIN PAIS p
    ON c.id_pais = p.id
GROUP BY p.pais
ORDER BY COUNT(c.nombre) DESC;

-- 02.3     ¿Cuantas RESERVAs se han realizado en cada hotel? Ordenar el resultado con respecto al id de cada hotel de forma ascendente.

SELECT ht.nombre, COUNT(r.id) 'Cant. Reservas'
FROM RESERVA r
INNER JOIN HABITACION hab
    ON r.id_habitacion = hab.id
INNER JOIN HOTEL ht
    ON hab.id_hotel = ht.id
GROUP BY ht.nombre, ht.id
ORDER BY ht.id ASC;

-- 02.5     Mostrar el detalle de cada RESERVA con respecto a los precios. incluir el precio de la habitacion y el total de los servicios. Nota: se asume que el precio de la habitacion es por noche
-- 02.5.1   Mostrar los datos de reserva, nombre del hotel, numero de habitación, y días de reserva

SELECT r.id, r.checkin, r.checkout,
    ht.nombre 'Hotel', hab.numero '# Hab',
    DATEDIFF(DAY, r.checkin, r.checkout) 'Días de hospedaje'
FROM RESERVA r
INNER JOIN HABITACION hab
    ON r.id_habitacion = hab.id
INNER JOIN HOTEL ht
    ON hab.id_hotel = ht.id;

-- 02.5.2   Incluyendo subtotal de la reserva (Dias * precio hab)

SELECT r.id, r.checkin, r.checkout,
    ht.nombre 'Hotel', hab.numero '# Hab',
    DATEDIFF(DAY, r.checkin, r.checkout) 'Días de hospedaje',
    (hab.precio * DATEDIFF(DAY, r.checkin, r.checkout)) 'Subtotal de Reserva (USD)'
FROM RESERVA r
INNER JOIN HABITACION hab
    ON r.id_habitacion = hab.id
INNER JOIN HOTEL ht
    ON hab.id_hotel = ht.id;

-- 02.5.3   Incluir los detalles de extras por cada reserva. Tomar en cuenta que pueden haber reservas sin servicios

SELECT r.id, r.checkin, r.checkout,
    ht.nombre 'Hotel', hab.numero '# Hab',
    DATEDIFF(DAY, r.checkin, r.checkout) 'Días de hospedaje',
    (hab.precio * DATEDIFF(DAY, r.checkin, r.checkout)) 'Subtotal de Reserva (USD)',
    s.nombre 'Servicio extra', s.precio 'Precio Extra'
FROM RESERVA r
INNER JOIN HABITACION hab
    ON r.id_habitacion = hab.id
INNER JOIN HOTEL ht
    ON hab.id_hotel = ht.id
LEFT JOIN EXTRA x
    ON x.id_reserva = r.id
LEFT JOIN SERVICIO s
    ON x.id_servicio = s.id;

-- 02.5.4   Sumar el precio de los servicios contratados

SELECT r.id, r.checkin, r.checkout,
    ht.nombre 'Hotel', hab.numero '# Hab',
    DATEDIFF(DAY, r.checkin, r.checkout) 'Días de hospedaje',
    (hab.precio * DATEDIFF(DAY, r.checkin, r.checkout)) 'Subtotal de Reserva (USD)',
    SUM(s.precio) 'Subtotal de Extras (USD)'
FROM RESERVA r
INNER JOIN HABITACION hab
    ON r.id_habitacion = hab.id
INNER JOIN HOTEL ht
    ON hab.id_hotel = ht.id
LEFT JOIN EXTRA x
    ON x.id_reserva = r.id
LEFT JOIN SERVICIO s
    ON x.id_servicio = s.id
GROUP BY r.id, r.checkin, r.checkout, ht.nombre, hab.numero, hab.precio;

-- 02.5.5   Cambiar el formato de los nulos en el subtotal de servicios

SELECT r.id, r.checkin, r.checkout,
    ht.nombre 'Hotel', hab.numero '# Hab',
    DATEDIFF(DAY, r.checkin, r.checkout) 'Días de hospedaje',
    (hab.precio * DATEDIFF(DAY, r.checkin, r.checkout)) 'Subtotal de Reserva (USD)',
    ISNULL(SUM(s.precio), 0) 'Subtotal de Extras (USD)'
FROM RESERVA r
INNER JOIN HABITACION hab
    ON r.id_habitacion = hab.id
INNER JOIN HOTEL ht
    ON hab.id_hotel = ht.id
LEFT JOIN EXTRA x
    ON x.id_reserva = r.id
LEFT JOIN SERVICIO s
    ON x.id_servicio = s.id
GROUP BY r.id, r.checkin, r.checkout, ht.nombre, hab.numero, hab.precio;

-- 02.5.6   Obtener el total de la reserva (subtotal de reserva + subtotal de servicios

SELECT r.id, r.checkin, r.checkout,
    ht.nombre 'Hotel', hab.numero '# Hab',
    DATEDIFF(DAY, r.checkin, r.checkout) 'Días de hospedaje',
    (hab.precio * DATEDIFF(DAY, r.checkin, r.checkout)) 'Subtotal de Reserva (USD)',
    ISNULL(SUM(s.precio), 0) 'Subtotal de Extras (USD)',
    ((hab.precio * DATEDIFF(DAY, r.checkin, r.checkout)) + ISNULL(SUM(s.precio), 0)) 'Total a pagar (USD)'
FROM RESERVA r
INNER JOIN HABITACION hab
    ON r.id_habitacion = hab.id
INNER JOIN HOTEL ht
    ON hab.id_hotel = ht.id
LEFT JOIN EXTRA x
    ON x.id_reserva = r.id
LEFT JOIN SERVICIO s
    ON x.id_servicio = s.id
GROUP BY r.id, r.checkin, r.checkout, ht.nombre, hab.numero, hab.precio;
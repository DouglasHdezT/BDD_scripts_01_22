--****************************************************
-- Bases de datos: Introducción a SQL
-- Autor: Douglas Hernández
-- Correspondencia: dohernandez@uca.edu.sv
-- Version: 1.0
--****************************************************

-- 01.0     INSTRUCCIÓN HAVING
-- 01.1     Ex1: Mostar las habitaciones que han sido reservadas al menos 10 días en junio de 2022

-- 01.11    Obtener datos simples

SELECT hot.nombre 'Hotel', hab.numero 
FROM RESERVA r
INNER JOIN HABITACION hab
    ON r.id_habitacion = hab.id
INNER JOIN HOTEL hot
    ON hab.id_hotel = hot.id
WHERE r.checkin BETWEEN '2022-06-01' AND '2022-06-30';

-- 01.12    Calcular días de reserva

SELECT hot.nombre 'Hotel', hab.numero, DATEDIFF(DAY, r.checkin, r.checkout) 'Días de reserva'
FROM RESERVA r
INNER JOIN HABITACION hab
    ON r.id_habitacion = hab.id
INNER JOIN HOTEL hot
    ON hab.id_hotel = hot.id
WHERE r.checkin BETWEEN '2022-06-01' AND '2022-06-30';

-- 01.13    Agrupar y sumar los días de reserva

SELECT hot.nombre 'Hotel', hab.numero, SUM(DATEDIFF(DAY, r.checkin, r.checkout)) 'Días de reserva'
FROM RESERVA r
INNER JOIN HABITACION hab
    ON r.id_habitacion = hab.id
INNER JOIN HOTEL hot
    ON hab.id_hotel = hot.id
WHERE r.checkin BETWEEN '2022-06-01' AND '2022-06-30'
GROUP BY hot.nombre, hab.numero;

-- 01.14    Filtrar las habitaciones con mas de 10 días

SELECT hot.nombre 'Hotel', hab.numero, SUM(DATEDIFF(DAY, r.checkin, r.checkout)) 'Días de reserva'
FROM RESERVA r
INNER JOIN HABITACION hab
    ON r.id_habitacion = hab.id
INNER JOIN HOTEL hot
    ON hab.id_hotel = hot.id
WHERE r.checkin BETWEEN '2022-06-01' AND '2022-06-30'
GROUP BY hot.nombre, hab.numero
HAVING SUM(DATEDIFF(DAY, r.checkin, r.checkout)) >= 10;

-- 01.2     Mostrar la lista de clientes VIP: Es rango se obtiene al gastar una suma igual o superior a 999.99 USD en alguna reserva
-- 01.21    Mostrar la información base

SELECT r.id 'Fact. #', c.nombre 'Cliente', ht.nombre 'Hotel', hab.numero '# Hab',
    DATEDIFF(DAY, r.checkin, r.checkout) 'Días de reserva',
    (DATEDIFF(DAY, r.checkin, r.checkout) * hab.precio) 'Subtotal de habitaciones',
    ISNULL(SUM(s.precio), 0) 'Subtotal de servicios (USD)',
    ((DATEDIFF(DAY, r.checkin, r.checkout) * hab.precio) + ISNULL(SUM(s.precio), 0)) 'Total de factura (USD)'
FROM RESERVA r
INNER JOIN CLIENTE c
    ON r.id_cliente_reserva = c.id
INNER JOIN HABITACION hab
    ON r.id_habitacion = hab.id
INNER JOIN HOTEL ht
    ON hab.id_hotel = ht.id
LEFT JOIN EXTRA x
    ON x.id_reserva = r.id
LEFT JOIN SERVICIO s
    ON x.id_servicio = s.id
GROUP BY r.id, c.nombre, ht.nombre, hab.numero, hab.precio, r.checkin, r.checkout;

-- 01.22        Filtrar VIP

SELECT r.id 'Fact. #', c.nombre 'Cliente', ht.nombre 'Hotel', hab.numero '# Hab',
    DATEDIFF(DAY, r.checkin, r.checkout) 'Días de reserva',
    (DATEDIFF(DAY, r.checkin, r.checkout) * hab.precio) 'Subtotal de habitaciones',
    ISNULL(SUM(s.precio), 0) 'Subtotal de servicios (USD)',
    ((DATEDIFF(DAY, r.checkin, r.checkout) * hab.precio) + ISNULL(SUM(s.precio), 0)) 'Total de factura (USD)'
FROM RESERVA r
INNER JOIN CLIENTE c
    ON r.id_cliente_reserva = c.id
INNER JOIN HABITACION hab
    ON r.id_habitacion = hab.id
INNER JOIN HOTEL ht
    ON hab.id_hotel = ht.id
LEFT JOIN EXTRA x
    ON x.id_reserva = r.id
LEFT JOIN SERVICIO s
    ON x.id_servicio = s.id
GROUP BY r.id, c.nombre, ht.nombre, hab.numero, hab.precio, r.checkin, r.checkout
HAVING ((DATEDIFF(DAY, r.checkin, r.checkout) * hab.precio) + ISNULL(SUM(s.precio), 0)) >= 999.999;

-- 02.0     INSTRUCCIÓN: INTO
-- 02.1     El resultado del detalle completo de factura -> Almacenarlo en Detalle_Reserva con Into

SELECT r.id 'Fact. #', c.nombre 'Cliente', ht.nombre 'Hotel', hab.numero '# Hab',
    DATEDIFF(DAY, r.checkin, r.checkout) 'Días de reserva',
    (DATEDIFF(DAY, r.checkin, r.checkout) * hab.precio) 'Subtotal de habitaciones',
    ISNULL(SUM(s.precio), 0) 'Subtotal de servicios (USD)',
    ((DATEDIFF(DAY, r.checkin, r.checkout) * hab.precio) + ISNULL(SUM(s.precio), 0)) 'Total de factura (USD)'
INTO DETALLE_RESERVA
FROM RESERVA r
INNER JOIN CLIENTE c
    ON r.id_cliente_reserva = c.id
INNER JOIN HABITACION hab
    ON r.id_habitacion = hab.id
INNER JOIN HOTEL ht
    ON hab.id_hotel = ht.id
LEFT JOIN EXTRA x
    ON x.id_reserva = r.id
LEFT JOIN SERVICIO s
    ON x.id_servicio = s.id
GROUP BY r.id, c.nombre, ht.nombre, hab.numero, hab.precio, r.checkin, r.checkout;

SELECT * FROM DETALLE_RESERVA;

-- 02.2     Crear una tabla vacía con la estructura de otra

SELECT *
INTO SERVICIO_BACKUP
FROM SERVICIO
WHERE 1=0;

SELECT * FROM SERVICIO_BACKUP;

-- DROP TABLE SERVICIO_BACKUP;

SELECT *
INTO EXTRA_BACKUP
FROM EXTRA
WHERE 1=0;

SELECT * FROM EXTRA_BACKUP;

-- DROP TABLE EXTRA_BACKUP;
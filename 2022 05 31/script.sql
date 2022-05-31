--****************************************************
-- Bases de datos: Introducción a SQL
-- Autor: Douglas Hernández
-- Correspondencia: dohernandez@uca.edu.sv
-- Version: 1.0
--****************************************************

-- 01.0     INSTRUCCIÓN HAVING
-- 01.1     Ex1: Mostar las habitaciones que han sido reservadas al menos 10 días en junio de 2022
-- 01.11    Obtener datos simples

SELECT r.id 'Fact. #', ht.nombre 'Hotel', hab.numero '# Hab'
FROM RESERVA r
INNER JOIN HABITACION hab
    ON r.id_habitacion = hab.id
INNER JOIN HOTEL ht
    ON hab.id_hotel = ht.id;

-- 01.12    Calcular días de reserva

SELECT r.id 'Fact. #', ht.nombre 'Hotel', hab.numero '# Hab',
    DATEDIFF(DAY, r.checkin, r.checkout) 'Días reservado'
FROM RESERVA r
INNER JOIN HABITACION hab
    ON r.id_habitacion = hab.id
INNER JOIN HOTEL ht
    ON hab.id_hotel = ht.id;

-- 01.13    Agrupar y sumar los días de reserva

SELECT ht.nombre 'Hotel', hab.numero '# Hab',
    SUM(DATEDIFF(DAY, r.checkin, r.checkout)) 'Días reservado'
FROM RESERVA r
INNER JOIN HABITACION hab
    ON r.id_habitacion = hab.id
INNER JOIN HOTEL ht
    ON hab.id_hotel = ht.id
GROUP BY ht.nombre, hab.numero;

-- 01.14    Filtrar las habitaciones con mas de 10 días en el mes de junio de 2022

SELECT ht.nombre 'Hotel', hab.numero '# Hab',
    SUM(DATEDIFF(DAY, r.checkin, r.checkout)) 'Días reservado'
FROM RESERVA r
INNER JOIN HABITACION hab
    ON r.id_habitacion = hab.id
INNER JOIN HOTEL ht
    ON hab.id_hotel = ht.id
WHERE r.checkin BETWEEN '2022-06-01' AND '2022-06-30'
GROUP BY ht.nombre, hab.numero
HAVING SUM(DATEDIFF(DAY, r.checkin, r.checkout)) >= 10;

-- 01.2     Mostrar la lista de clientes VIP: Es rango se obtiene al gastar una suma igual o superior a 999.99 USD en alguna reserva
-- 01.21    Mostrar la información base

SELECT r.id 'Fact. #', c.nombre 'Cliente', ht.nombre 'Hotel', hab.numero '# Hab.',
    DATEDIFF(DAY, r.checkin, r.checkout) 'Días de reserva',
    (DATEDIFF(DAY, r.checkin, r.checkout) * hab.precio) 'Subtotal de habitación (USD)',
    ISNULL(SUM(s.precio), 0) 'Subtotal de servicios (USD)',
    (ISNULL(SUM(s.precio), 0) + (DATEDIFF(DAY, r.checkin, r.checkout) * hab.precio)) 'Total (USD)'
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
GROUP BY r.id, c.nombre, ht.nombre, hab.numero, r.checkin, r.checkout, hab.precio;

-- 01.22        Filtrar VIP

SELECT r.id 'Fact. #', c.nombre 'Cliente', ht.nombre 'Hotel', hab.numero '# Hab.',
    DATEDIFF(DAY, r.checkin, r.checkout) 'Días de reserva',
    (DATEDIFF(DAY, r.checkin, r.checkout) * hab.precio) 'Subtotal de habitación (USD)',
    ISNULL(SUM(s.precio), 0) 'Subtotal de servicios (USD)',
    (ISNULL(SUM(s.precio), 0) + (DATEDIFF(DAY, r.checkin, r.checkout) * hab.precio)) 'Total (USD)'
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
GROUP BY r.id, c.nombre, ht.nombre, hab.numero, r.checkin, r.checkout, hab.precio
HAVING (ISNULL(SUM(s.precio), 0) + (DATEDIFF(DAY, r.checkin, r.checkout) * hab.precio)) >= 999.99;

-- 02.0     INSTRUCCIÓN: INTO
-- 02.1     El resultado del detalle completo de factura -> Almacenarlo en Detalle_Reserva con Into

SELECT r.id 'Fact. #', c.nombre 'Cliente', ht.nombre 'Hotel', hab.numero '# Hab.',
    DATEDIFF(DAY, r.checkin, r.checkout) 'Días de reserva',
    (DATEDIFF(DAY, r.checkin, r.checkout) * hab.precio) 'Subtotal de habitación (USD)',
    ISNULL(SUM(s.precio), 0) 'Subtotal de servicios (USD)',
    (ISNULL(SUM(s.precio), 0) + (DATEDIFF(DAY, r.checkin, r.checkout) * hab.precio)) 'Total (USD)'
INTO FACTURAS_2022_05
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
GROUP BY r.id, c.nombre, ht.nombre, hab.numero, r.checkin, r.checkout, hab.precio;

SELECT * FROM FACTURAS_2022_05;

-- 02.2     Crear una tabla vacía con la estructura de otra

SELECT *
INTO HOTEL_BACKUP
FROM HOTEL
WHERE 0 = 1;

SELECT * FROM HOTEL_BACKUP;

SELECT *
INTO SERVICIO_BACKUP
FROM SERVICIO;

SELECT * FROM SERVICIO_BACKUP;
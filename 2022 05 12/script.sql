--****************************************************
-- Bases de datos: Introducción a SQL
-- Autor: Douglas Hernández
-- Correspondencia: dohernandez@uca.edu.sv
-- Version: 1.0
--****************************************************

-- 01.00    QUERIES PLANAS
-- 01.01    MOSTRAR TODAS LAS RESERVAS



-- 01.02    MOSTRAR LOS CAMPOS checkin, checkout, id_cliente_reserva, id_habitacion



-- 01.03    MOSTRAR LOS MISMOS CAMPOS PERO CON OTROS IDENTIFICADORES


-- ************************************************************************************************ --

-- 02.00    CONDICIONES EN QUERIES
-- 02.01    MOSTRAR TODAS LAS RESERVAS CON id MAYOR A 90



-- 02.02    AND: MOSTRAR TODAS LAS RESERVAS CON ID ENTRE 25 Y 40



-- 02.03    BETWEEN: MOSTRAR TODAS LAS RESERVAS CON id ENTRE 25 Y 40



-- 02.04    NOT: MOSTRAR TODAS LAS RESERVAS CON id FUERA DEL RANGO 25 - 40



-- 02.05    OR: MOSTRAR TODAS LAS RESERVAS CON id ENTRE ESTOS RANGOS [10-15] | [30-40]



-- 02.06    ¿Y SI LO CAMBIAMOS POR AND? NO TENDRIA SENTIDO



-- 02.07    COMBINADO CONDICIONES: MOSTRAR LAS RESERVAS CON id MENORES A 10, MAYORES A 90, Y MENORES A 100



-- 02.08    MANEJO DE DATE: MOSTRAR LAS RESERVAS PLANIFICADAS PARA MAYO



-- 02.09    DATE&BETWEEN: MOSTRAR LAS RESERVAS PLANIFICADAS PARA MAYO



-- 02.10    FUNCION MONTH: MOSTRAR LAS RESERVAS PLANIFICADAS PARA MAYO



-- 02.11    FUNCION YEAR: MOSTRAR LAS RESERVAS PLANIFICADAS PARA MAYO DE 2022



-- 02.12    FUNCION DAY: MOSTRAR LAS RESERVAS PLANIFICADAS PARA DESPUES DEL 10 DE MAYO



-- 02.13    FUNCION DATEDIFF: MOSTRAR TODAS LAS RESERVAS CON ESTANCIA MAYOR A 3 DIAS


-- 02.14    LIMPIANDO LA SALIDA DE LA EJECUCIÓN 02.13



-- 02.15    LIKE 01: MOSTRAR LOS CORREOS QUE FINALICEN EN ".edu"



-- 02.16    LIKE 02: MOSTRAR LOS CORREOS QUE SE ENCUENTREN EN EL DOMINIO "outlook"



-- 02.18    LIKE 03: MOSTRAR LOS CORREOS QUE NO SE ENCUENTREN EN EL DOMINIO "outlook"



-- 02.17    LIKE 04: MOSTRAR LOS CORREOS QUE TENGAN UN PUNTO EN SU NOMBRE (.)


-- 03.00    AGRUPAMIENTO DE TABLAS
-- 03.00    CONSULTANDO EL CLIENTE CON id = 1 Y EL CORREO CON id_cliente = 1



-- 03.01    MOSTRAR TODOS LOS CORREOS CON EL NOMBRE DEL CLIENTE ASIGNADO



-- 03.02    MOSTRAR DE CADA HOTEL EL id, nombre, telefono, Y NOMBRE DE LA CATEGORIA A LA QUE PERTENCE



-- 03.03    MOSTRAR TODA LA INFORMACIÓN DE CLIENTE INLUYENDO EL PAIS DE ORIGEN Y LA CATEGORIA A LA QUE PERTENECE



-- 03.03    MOSTRAR TODA LA INFORMACIÓN DE CLIENTE INLUYENDO EL PAIS DE ORIGEN DE AQUELLOS CUYA CATEGORIA SEA "backpacker"



-- 03.03    MOSTRAR TODA LA INFORMACIÓN DE CLIENTE INLUYENDO EL PAIS DE ORIGEN DE AQUELLOS CUYA CATEGORIA SEA "backpacker" USANDO EL ID DE CATEGORIA



-- 03.04    MOSTRAR TODA LA INFORMACIÓN DE CLIENTE INLUYENDO EL PAIS DE ORIGEN Y CATEGORIA DE AQUELLOS CUYO ORIGEN SEA CENTROAMERICANO



-- 03.04    MOSTRAR TODA LA INFORMACIÓN DE CLIENTE INLUYENDO EL PAIS DE ORIGEN Y CATEGORIA DE AQUELLOS CUYO ORIGEN SEA CENTROAMERICANO USANDO LAS PK DE PAIS



-- 03.04    IN: MOSTRAR TODA LA INFORMACIÓN DE CLIENTE INLUYENDO EL PAIS DE ORIGEN Y CATEGORIA DE AQUELLOS CUYO ORIGEN SEA CENTROAMERICANO USANDO LAS PK DE PAIS
--****************************************************
-- Bases de datos: Introducción a SQL
-- Autor: Douglas Hernández
-- Correspondencia: dohernandez@uca.edu.sv
-- Version: 1.0
--****************************************************

CREATE DATABASE HOTELMANAGEMENTDB;
GO
USE HOTELMANAGEMENTDB;
GO

-- ******************************************************************************
-- Table definition
--
CREATE TABLE [TIPO_EMPLEADO] (
    [id] INTEGER NOT NULL,
    [tipo] VARCHAR(64) NOT NULL,
    PRIMARY KEY ([id])
);
GO

CREATE TABLE [CATEGORIA_HOTEL] (
    [id] INTEGER NOT NULL,
    [categoria] VARCHAR(12) NOT NULL,
    PRIMARY KEY ([id])
);
GO

CREATE TABLE [REGION_HOTEL] (
    [id] INTEGER NOT NULL,
    [region] CHAR(8) NOT NULL,
    PRIMARY KEY ([id])
);
GO

CREATE TABLE [HOTEL] (
    [id] INTEGER NOT NULL,
    [nombre] VARCHAR(50) NOT NULL,
    [direccion] VARCHAR(100) NOT NULL,
    [telefono] CHAR(12) NOT NULL,
    [id_categoria_hotel] INT NOT NULL,
    [id_region] INT NOT NULL,
	[id_hotel_coordinador] INT NOT NULL,
    PRIMARY KEY ([id])
);
GO

CREATE TABLE [EMPLEADO] (
    [dui] CHAR(10) NOT NULL,
    [nombre] VARCHAR(50) NOT NULL,
    [numero_pension] CHAR(8) NOT NULL,
    [isss] CHAR(8) NOT NULL,
    [fecha_nacimiento] DATE NOT NULL,
    [salario] MONEY NOT NULL,
	[correo] VARCHAR(50) NOT NULL,
	[id_tipo_empleado] INT NOT NULL,
	[id_hotel] INT NOT NULL,
    PRIMARY KEY ([dui])
);
GO 

CREATE TABLE [REPRESENTANTE] (
    [id] INT NOT NULL,
    [dui_empleado] CHAR(10) NOT NULL,
    [id_hotel] INT NOT NULL,
    [periodo_inicio] DATE NOT NULL,
    [periodo_fin] DATE NOT NULL,
    PRIMARY KEY ([id])
);
GO 

CREATE TABLE [TIPO_HABITACION] (
    [id] INT NOT NULL,
    [tipo] VARCHAR(16) NOT NULL,
    PRIMARY KEY ([id])
);
GO 

CREATE TABLE [HABITACION] (
    [id] INT NOT NULL,
    [numero] CHAR(10) NOT NULL,
    [precio] MONEY NOT NULL,
    [id_tipo_habitacion] INT NOT NULL,
    [id_hotel] INT NOT NULL,
    PRIMARY KEY ([id])
);
GO 

CREATE TABLE [PAIS] (
    [id] INT NOT NULL,
    [pais] VARCHAR(32) NOT NULL,
    PRIMARY KEY ([id])
);
GO 

CREATE TABLE [CATEGORIA_CLIENTE] (
    [id] INT NOT NULL,
    [categoria] VARCHAR(32) NOT NULL,
    PRIMARY KEY ([id])
);
GO 

CREATE TABLE [CLIENTE] (
    [id] INT NOT NULL,
    [nombre] VARCHAR(64) NOT NULL,
    [documento] VARCHAR(16) NULL,
    [id_pais] INT NOT NULL,
    [categoria_cliente] INT NOT NULL,
    PRIMARY KEY ([id])
);
GO 

CREATE TABLE [CORREO_CLIENTE] (
    [id] INT NOT NULL,
    [correo] VARCHAR(64) NOT NULL,
    [id_cliente] INT NOT NULL,
    PRIMARY KEY ([id])
);
GO 

CREATE TABLE [SERVICIO] (
	id INT NOT NULL,
	nombre VARCHAR(32) NOT NULL,
	precio MONEY NOT NULL
    PRIMARY KEY ([id])
);
GO 

CREATE TABLE [METODO_PAGO] (
	id INT NOT NULL,
	metodo_pago VARCHAR(32) NOT NULL,
    PRIMARY KEY ([id])
);
GO 

CREATE TABLE [RESERVA] (
    [id] INT NOT NULL,
    [checkin] DATE NOT NULL,
	[checkout] DATE NOT NULL,
	[id_metodo_pago] INT NOT NULL,
	[id_cliente_reserva] INT NOT NULL,
	[id_habitacion] INT NOT NULL,
    PRIMARY KEY ([id])
);
GO 

CREATE TABLE [CANCELACION_RESERVA] (
    [id] INT NOT NULL,
    [fecha] DATE NOT NULL,
	[justificacion] VARCHAR(512) NOT NULL,
	[id_reserva] INT NOT NULL,
    PRIMARY KEY ([id])
);
GO 

CREATE TABLE [EXTRA] (
    [id_servicio] INTEGER NOT NULL,
    [id_reserva] INTEGER NOT NULL
);
GO

CREATE TABLE [COMENTARIO] (
    [id] INT NOT NULL,
    [id_cliente] INT  NOT NULL,
	[id_hotel] INT NOT NULL,
	[fecha] DATE NOT NULL,
	[comentario] VARCHAR(512) NOT NULL,
	[calificacion] INT NOT NULL,
    PRIMARY KEY ([id])
);
GO 

-- ******************************************************************************
-- PK/FK definition 
--
ALTER TABLE HOTEL ADD FOREIGN KEY (id_categoria_hotel) REFERENCES CATEGORIA_HOTEL (id);
ALTER TABLE HOTEL ADD FOREIGN KEY (id_region) REFERENCES REGION_HOTEL (id);
ALTER TABLE HOTEL ADD FOREIGN KEY (id_hotel_coordinador) REFERENCES HOTEL (id);
ALTER TABLE EMPLEADO ADD CONSTRAINT fk_tipo_to_empleado FOREIGN KEY (id_tipo_empleado) REFERENCES TIPO_EMPLEADO (id);
ALTER TABLE EMPLEADO ADD CONSTRAINT fk_hotel_to_empleado FOREIGN KEY (id_hotel) REFERENCES HOTEL (id);
ALTER TABLE REPRESENTANTE ADD CONSTRAINT fk_hotel_representante FOREIGN KEY (id_hotel) REFERENCES HOTEL (id);
ALTER TABLE REPRESENTANTE ADD CONSTRAINT fk_empleado_representante FOREIGN KEY (dui_empleado) REFERENCES EMPLEADO (dui);
ALTER TABLE HABITACION ADD CONSTRAINT fk_tipo_habitacion FOREIGN KEY (id_tipo_habitacion) REFERENCES TIPO_HABITACION (id);
ALTER TABLE HABITACION ADD CONSTRAINT fk_hotel_habitacion FOREIGN KEY (id_hotel) REFERENCES HOTEL (id);
ALTER TABLE CLIENTE ADD CONSTRAINT fk_pais_cliente FOREIGN KEY (id_pais) REFERENCES PAIS (id);
ALTER TABLE CLIENTE ADD CONSTRAINT fk_tipo_cliente FOREIGN KEY (categoria_cliente) REFERENCES CATEGORIA_CLIENTE (id);
ALTER TABLE CORREO_CLIENTE ADD CONSTRAINT fk_cliente_correo FOREIGN KEY (id_cliente) REFERENCES CLIENTE (id);
ALTER TABLE RESERVA ADD CONSTRAINT fk_metodopago_reserva FOREIGN KEY (id_metodo_pago) REFERENCES METODO_PAGO (id);
ALTER TABLE RESERVA ADD CONSTRAINT fk_cliente_reserva FOREIGN KEY (id_cliente_reserva) REFERENCES CLIENTE (id);
ALTER TABLE RESERVA ADD CONSTRAINT fk_habitacion_reserva FOREIGN KEY (id_habitacion) REFERENCES HABITACION (id);
ALTER TABLE CANCELACION_RESERVA ADD CONSTRAINT fk_reserva_cancelacion FOREIGN KEY (id_reserva) REFERENCES RESERVA (id);
ALTER TABLE EXTRA ADD CONSTRAINT pk_extra  PRIMARY KEY (id_reserva, id_servicio);
ALTER TABLE EXTRA ADD CONSTRAINT fK_servicio_extra FOREIGN KEY (id_servicio) REFERENCES SERVICIO (id);
ALTER TABLE EXTRA ADD CONSTRAINT fk_reserva_extra FOREIGN KEY (id_reserva) REFERENCES RESERVA (id);
ALTER TABLE COMENTARIO ADD CONSTRAINT fk_hotel_comentario FOREIGN KEY (id_hotel) REFERENCES HOTEL (id);
ALTER TABLE COMENTARIO ADD CONSTRAINT fk_cliente_comentario FOREIGN KEY (id_cliente) REFERENCES CLIENTE (id);


-- ******************************************************************************
-- DATABANK
--
INSERT INTO [TIPO_EMPLEADO] (id,tipo) VALUES(1,'Recepcionista');
INSERT INTO [TIPO_EMPLEADO] (id,tipo) VALUES(2,'Botones y conserje');
INSERT INTO [TIPO_EMPLEADO] (id,tipo) VALUES(3,'Gobernanta');
INSERT INTO [TIPO_EMPLEADO] (id,tipo) VALUES(4,'Camarero');
INSERT INTO [TIPO_EMPLEADO] (id,tipo) VALUES(5,'Cocinero');
INSERT INTO [TIPO_EMPLEADO] (id,tipo) VALUES(6,'Personal de seguridad y mantenimiento');
INSERT INTO [TIPO_EMPLEADO] (id,tipo) VALUES(7,'Animador');
INSERT INTO [TIPO_EMPLEADO] (id,tipo) VALUES(8,'Primeros Auxilios');

INSERT INTO [CATEGORIA_HOTEL] (id,categoria) VALUES(1,'1 estrella');
INSERT INTO [CATEGORIA_HOTEL] (id,categoria) VALUES(2,'2 estrellas');
INSERT INTO [CATEGORIA_HOTEL] (id,categoria) VALUES(3,'3 estrellas');
INSERT INTO [CATEGORIA_HOTEL] (id,categoria) VALUES(4,'4 estrellas');
INSERT INTO [CATEGORIA_HOTEL] (id,categoria) VALUES(5,'5 estrellas');

INSERT INTO [REGION_HOTEL] (id,region) VALUES(1,'Region 1');
INSERT INTO [REGION_HOTEL] (id,region) VALUES(2,'Region 2');
INSERT INTO [REGION_HOTEL] (id,region) VALUES(3,'Region 3');

INSERT INTO HOTEL (id, nombre,direccion, telefono, id_categoria_hotel, id_region, id_hotel_coordinador) 
    VALUES (3,'Hotel Remfort','Avenida Independencia Sur y 11 Calle Pte, Santa Ana, 0210, El Salvador','+50378503544',3,1,3);
INSERT INTO HOTEL (id, nombre,direccion, telefono, id_categoria_hotel, id_region, id_hotel_coordinador) 
    VALUES (8,'Real InterContinental San Salvador','Blvd. de Los Heroes, San Salvador, 544, SS, El Salvador','+50375303997',5,2,8);
INSERT INTO HOTEL (id, nombre,direccion, telefono, id_categoria_hotel, id_region, id_hotel_coordinador) 
    VALUES (13,'Comfort Inn Real San Miguel','Final Alameda Roosevelt, San Miguel, SM, El Salvador','+50371998061',4,3,13);
INSERT INTO HOTEL (id, nombre, direccion, telefono, id_categoria_hotel, id_region, id_hotel_coordinador) 
    VALUES (1,'Equinoccio Hotel','SAN24E, El Congo, Santa Ana, Santa Ana, El Salvador','+50373095227',2,1,3);
INSERT INTO HOTEL (id, nombre,direccion, telefono, id_categoria_hotel, id_region, id_hotel_coordinador) 
    VALUES (2,'Hostal & Restaurante Bar Xtream','Cantón Potrerillos de la Laguna, Santa Ana, 01101, SA, El Salvador','+50375688289',2,1,3);
INSERT INTO HOTEL (id, nombre,direccion, telefono, id_categoria_hotel, id_region, id_hotel_coordinador) 
    VALUES (4,'Hostal La Toscana','Km 62.5 Carretera Antigua A San Salvador, Santa Ana, Santa Ana, El Salvador','+50375294741',2,1,3);
INSERT INTO HOTEL (id, nombre,direccion, telefono, id_categoria_hotel, id_region, id_hotel_coordinador) 
    VALUES (5,'Cardedeu Hotel','La Bendicion, Cardedeu, El Congo, Santa Ana Department, El Salvador','+50377057695',3,1,3);
INSERT INTO HOTEL (id, nombre,direccion, telefono, id_categoria_hotel, id_region, id_hotel_coordinador) 
    VALUES (6,'Barceló San Salvador','Ave Las Magnolias Y Blvd Del Hipodromo, San Salvador, SS, El Salvador','+50371068452',4,2,8);
INSERT INTO HOTEL (id, nombre,direccion, telefono, id_categoria_hotel, id_region, id_hotel_coordinador) 
    VALUES (7,'Sheraton Presidente San Salvador Hotel','Av. De La Revolucion, San Salvador','+50375408040',4,2,8);
INSERT INTO HOTEL (id, nombre,direccion, telefono, id_categoria_hotel, id_region, id_hotel_coordinador) 
    VALUES (9,'Quality Hotel Real Aeropuerto','KM 40.5, San Luis Talpa, 1601, PA, El Salvador','+50373570892',4,2,8);
INSERT INTO HOTEL (id, nombre,direccion, telefono, id_categoria_hotel, id_region, id_hotel_coordinador) 
    VALUES (10,'Hotel Gardenia Inn','Prolongacion Alameda Juan Pablo II, San Salvador, San Salvador, El Salvador','+50371901095',3,2,8);
INSERT INTO HOTEL (id, nombre,direccion, telefono, id_categoria_hotel, id_region, id_hotel_coordinador) 
    VALUES (11,'Hotel Plaza Floresta','AVENIDA ROOSEVELT, San Miguel, CP 3301, San Miguel, El Salvador','+50375425826',2,3,13);
INSERT INTO HOTEL (id, nombre,direccion, telefono, id_categoria_hotel, id_region, id_hotel_coordinador) 
    VALUES (12,'Hotel Tropico Inn','Avenida Roosevelt Sur #303, San Miguel, SM, El Salvador','+50372310206',3,3,13);
INSERT INTO HOTEL (id, nombre,direccion, telefono, id_categoria_hotel, id_region, id_hotel_coordinador) 
    VALUES (14,'Hotel Mediterraneo Inn','Calle a las Trojitas, Santa Rosa de Lima, 01101, La Unión, El Salvador','+50371603731',3,3,13);
INSERT INTO HOTEL (id, nombre,direccion, telefono, id_categoria_hotel, id_region, id_hotel_coordinador) 
    VALUES (15,'Puerto Barillas Marina & Lodge','Km. 108.5 - CA-2, Usulután, US, El Salvador','+50372074933',3,3,13);

INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('71055435-9','Branden Henderson','78667815','18203394',CONVERT(DATE,'16/1/1988',103),900,'He1988@ciccaba.com',8,2);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('33601641-5','Griffith Atkinson','76639262','97408008',CONVERT(DATE,'11/5/1986',103),800,'At1986@ciccaba.com',3,11);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('62712375-8','Marsden Castro','68721686','67853654',CONVERT(DATE,'6/8/1990',103),800,'Ca1990@ciccaba.com',1,2);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('16974665-8','Abbot Lane','59210726','75682731',CONVERT(DATE,'19/10/1991',103),900,'La1991@ciccaba.com',4,9);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('56165800-8','Cameron Wilson','70482422','28277615',CONVERT(DATE,'17/6/1996',103),900,'Wi1996@ciccaba.com',8,8);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('18409093-2','Mallory Jones','87388606','51009528',CONVERT(DATE,'20/11/1989',103),800,'Jo1989@ciccaba.com',7,14);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('92366368-3','Jared Meyer','26329630','86149272',CONVERT(DATE,'18/5/1990',103),800,'Me1990@ciccaba.com',1,4);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('49111658-1','Ruth Gay','80574664','50691668',CONVERT(DATE,'3/4/1996',103),900,'Ga1996@ciccaba.com',8,11);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('61959083-5','Caryn Sosa','12919171','98045484',CONVERT(DATE,'2/9/1995',103),800,'So1995@ciccaba.com',1,8);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('54343416-1','Russell Shelton','76084727','75405502',CONVERT(DATE,'6/5/1983',103),1100,'Sh1983@ciccaba.com',5,2);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('61739088-1','Vance Haney','57439967','68523509',CONVERT(DATE,'23/2/1998',103),800,'Ha1998@ciccaba.com',7,11);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('35483743-6','Laurel Jones','13442271','31426359',CONVERT(DATE,'4/12/1989',103),900,'Jo1989@ciccaba.com',8,5);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('82750950-8','Kato Banks','40309429','79007499',CONVERT(DATE,'17/8/1994',103),800,'Ba1994@ciccaba.com',7,15);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('58623744-6','Hakeem Cantrell','86988601','87647261',CONVERT(DATE,'19/7/1988',103),750,'Ca1988@ciccaba.com',2,6);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('23174051-5','Colorado Francis','78374668','35830652',CONVERT(DATE,'4/11/1995',103),700,'Fr1995@ciccaba.com',6,5);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('28937476-2','Zena Hodges','77817786','14891452',CONVERT(DATE,'26/2/2000',103),1100,'Ho2000@ciccaba.com',5,15);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('13904302-6','Galena Benjamin','10915144','73084509',CONVERT(DATE,'14/2/1989',103),750,'Be1989@ciccaba.com',2,10);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('40204935-4','Lamar Daniel','79915435','54723252',CONVERT(DATE,'25/8/2001',103),800,'Da2001@ciccaba.com',7,13);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('89963178-6','Ella Stout','54384543','47496927',CONVERT(DATE,'20/9/1997',103),700,'St1997@ciccaba.com',6,5);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('78037011-1','Gannon Medina','37279901','43388702',CONVERT(DATE,'28/1/2002',103),700,'Me2002@ciccaba.com',6,10);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('60507273-9','Avye Rodgers','43695514','31133117',CONVERT(DATE,'15/10/1989',103),700,'Ro1989@ciccaba.com',6,10);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('75554422-6','Macy Coffey','29772467','18418146',CONVERT(DATE,'24/7/2002',103),800,'Co2002@ciccaba.com',1,1);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('44680851-6','Ivan Levine','85262751','83559460',CONVERT(DATE,'17/10/1993',103),800,'Le1993@ciccaba.com',3,15);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('45417555-4','Gage Dalton','64705697','72680452',CONVERT(DATE,'13/10/2000',103),900,'Da2000@ciccaba.com',8,3);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('71897105-9','Madison Terrell','50990630','11867187',CONVERT(DATE,'9/3/1992',103),800,'Te1992@ciccaba.com',7,15);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('83790721-7','Josephine Shepard','17415111','76620907',CONVERT(DATE,'1/1/1996',103),700,'Sh1996@ciccaba.com',6,9);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('96725942-8','Cheryl Gates','25185844','71409095',CONVERT(DATE,'6/7/1990',103),800,'Ga1990@ciccaba.com',1,11);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('95449785-1','Xanthus Carr','75700024','33080925',CONVERT(DATE,'24/10/1997',103),800,'Ca1997@ciccaba.com',7,11);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('97651858-1','Robert William','58840365','40762680',CONVERT(DATE,'24/4/1985',103),750,'Wi1985@ciccaba.com',2,5);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('71432842-5','Rahim Alford','78905792','48184978',CONVERT(DATE,'18/9/1994',103),900,'Al1994@ciccaba.com',8,1);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('22833736-8','Alexander Zamora','50617587','63738746',CONVERT(DATE,'26/7/1980',103),800,'Za1980@ciccaba.com',1,11);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('80085236-5','Thane Stephenson','30532476','16601319',CONVERT(DATE,'21/4/1991',103),800,'St1991@ciccaba.com',3,4);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('71414728-8','Austin Hughes','57741697','24311216',CONVERT(DATE,'26/2/1997',103),750,'Hu1997@ciccaba.com',2,7);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('37257591-1','Dieter Carrillo','66649524','45845147',CONVERT(DATE,'15/2/1982',103),750,'Ca1982@ciccaba.com',2,5);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('21879055-8','Lareina Sanders','72470816','65504497',CONVERT(DATE,'28/4/1990',103),800,'Sa1990@ciccaba.com',7,14);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('68913479-4','Armando Watkins','37418052','88373138',CONVERT(DATE,'17/8/1986',103),750,'Wa1986@ciccaba.com',2,7);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('82138376-2','Laurel Wooten','72282051','19371230',CONVERT(DATE,'24/7/1986',103),700,'Wo1986@ciccaba.com',6,6);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('35711032-1','Brenden Trevino','10372493','65513743',CONVERT(DATE,'5/6/1988',103),800,'Tr1988@ciccaba.com',7,9);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('55595033-3','Dana Floyd','54553666','95315388',CONVERT(DATE,'1/4/2002',103),1100,'Fl2002@ciccaba.com',5,1);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('74901979-2','Zenia Dale','48791737','78718138',CONVERT(DATE,'16/11/1980',103),900,'Da1980@ciccaba.com',4,1);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('26154581-3','Curran Frank','81461218','61572054',CONVERT(DATE,'5/2/1989',103),800,'Fr1989@ciccaba.com',3,10);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('59559585-4','Stone Howard','43201338','49932787',CONVERT(DATE,'5/4/1982',103),1100,'Ho1982@ciccaba.com',5,6);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('48299154-8','Adria Strickland','75359927','84588966',CONVERT(DATE,'25/3/1981',103),800,'St1981@ciccaba.com',7,4);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('97407276-8','Emmanuel Oliver','41356343','26967155',CONVERT(DATE,'25/11/2002',103),900,'Ol2002@ciccaba.com',8,11);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('37757700-4','Medge Perry','44876258','84013578',CONVERT(DATE,'5/12/1998',103),800,'Pe1998@ciccaba.com',7,14);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('52662721-5','William Mcpherson','14108382','11010286',CONVERT(DATE,'2/6/1982',103),900,'Mc1982@ciccaba.com',8,14);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('26596273-4','Suki Aguilar','63977358','95522536',CONVERT(DATE,'28/7/2002',103),800,'Ag2002@ciccaba.com',3,7);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('29691581-1','Quemby Grimes','10567931','84405382',CONVERT(DATE,'13/2/1994',103),900,'Gr1994@ciccaba.com',8,10);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('25341713-7','Perry Peterson','54180133','94260302',CONVERT(DATE,'15/4/1980',103),800,'Pe1980@ciccaba.com',7,14);
INSERT INTO EMPLEADO (dui, nombre, numero_pension, isss, fecha_nacimiento, salario, correo, id_tipo_empleado, id_hotel) 
    VALUES('70155827-5','Stephen Brock','66484864','11358585',CONVERT(DATE,'3/9/1986',103),750,'Br1986@ciccaba.com',2,6);

INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (1,'55595033-3',1, CONVERT(DATE,'01/03/2020',103), CONVERT(DATE,'28/02/2022'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (2,'71432842-5',1, CONVERT(DATE,'01/03/2022',103), CONVERT(DATE,'29/02/2024'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (3,'71432842-5',1, CONVERT(DATE,'01/03/2024',103), CONVERT(DATE,'28/02/2026'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (4,'71055435-9',2, CONVERT(DATE,'01/03/2020',103), CONVERT(DATE,'28/02/2022'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (5,'54343416-1',2, CONVERT(DATE,'01/03/2022',103), CONVERT(DATE,'29/02/2024'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (6,'62712375-8',2, CONVERT(DATE,'01/03/2024',103), CONVERT(DATE,'28/02/2026'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (7,'45417555-4',3, CONVERT(DATE,'01/03/2020',103), CONVERT(DATE,'28/02/2022'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (8,'45417555-4',3, CONVERT(DATE,'01/03/2022',103), CONVERT(DATE,'29/02/2024'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (9,'45417555-4',3, CONVERT(DATE,'01/03/2024',103), CONVERT(DATE,'28/02/2026'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (10,'48299154-8',4, CONVERT(DATE,'01/03/2020',103), CONVERT(DATE,'28/02/2022'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (11,'80085236-5',4, CONVERT(DATE,'01/03/2022',103), CONVERT(DATE,'29/02/2024'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (12,'48299154-8',4, CONVERT(DATE,'01/03/2024',103), CONVERT(DATE,'28/02/2026'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (13,'89963178-6',5, CONVERT(DATE,'01/03/2020',103), CONVERT(DATE,'28/02/2022'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (14,'35483743-6',5, CONVERT(DATE,'01/03/2022',103), CONVERT(DATE,'29/02/2024'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (15,'97651858-1',5, CONVERT(DATE,'01/03/2024',103), CONVERT(DATE,'28/02/2026'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (16,'59559585-4',6, CONVERT(DATE,'01/03/2020',103), CONVERT(DATE,'28/02/2022'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (17,'59559585-4',6, CONVERT(DATE,'01/03/2022',103), CONVERT(DATE,'29/02/2024'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (18,'59559585-4',6, CONVERT(DATE,'01/03/2024',103), CONVERT(DATE,'28/02/2026'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (19,'68913479-4',7, CONVERT(DATE,'01/03/2020',103), CONVERT(DATE,'28/02/2022'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (20,'68913479-4',7, CONVERT(DATE,'01/03/2022',103), CONVERT(DATE,'29/02/2024'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (21,'71414728-8',7, CONVERT(DATE,'01/03/2024',103), CONVERT(DATE,'28/02/2026'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (22,'61959083-5',8, CONVERT(DATE,'01/03/2020',103), CONVERT(DATE,'28/02/2022'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (23,'56165800-8',8, CONVERT(DATE,'01/03/2022',103), CONVERT(DATE,'29/02/2024'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (24,'56165800-8',8, CONVERT(DATE,'01/03/2024',103), CONVERT(DATE,'28/02/2026'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (25,'83790721-7',9, CONVERT(DATE,'01/03/2020',103), CONVERT(DATE,'28/02/2022'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (26,'16974665-8',9, CONVERT(DATE,'01/03/2022',103), CONVERT(DATE,'29/02/2024'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (27,'16974665-8',9, CONVERT(DATE,'01/03/2024',103), CONVERT(DATE,'28/02/2026'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (28,'78037011-1',10, CONVERT(DATE,'01/03/2020',103), CONVERT(DATE,'28/02/2022'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (29,'78037011-1',10, CONVERT(DATE,'01/03/2022',103), CONVERT(DATE,'29/02/2024'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (30,'78037011-1',10, CONVERT(DATE,'01/03/2024',103), CONVERT(DATE,'28/02/2026'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (31,'33601641-5',11, CONVERT(DATE,'01/03/2020',103), CONVERT(DATE,'28/02/2022'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (32,'22833736-8',11, CONVERT(DATE,'01/03/2022',103), CONVERT(DATE,'29/02/2024'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (33,'95449785-1',11, CONVERT(DATE,'01/03/2024',103), CONVERT(DATE,'28/02/2026'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (34,'40204935-4',13, CONVERT(DATE,'01/03/2020',103), CONVERT(DATE,'28/02/2022'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (35,'40204935-4',13, CONVERT(DATE,'01/03/2022',103), CONVERT(DATE,'29/02/2024'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (36,'40204935-4',13, CONVERT(DATE,'01/03/2024',103), CONVERT(DATE,'28/02/2026'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (37,'21879055-8',14, CONVERT(DATE,'01/03/2020',103), CONVERT(DATE,'28/02/2022'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (38,'21879055-8',14, CONVERT(DATE,'01/03/2022',103), CONVERT(DATE,'29/02/2024'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (39,'21879055-8',14, CONVERT(DATE,'01/03/2024',103), CONVERT(DATE,'28/02/2026'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (40,'71897105-9',15, CONVERT(DATE,'01/03/2020',103), CONVERT(DATE,'28/02/2022'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (41,'82750950-8',15, CONVERT(DATE,'01/03/2022',103), CONVERT(DATE,'29/02/2024'));
INSERT INTO REPRESENTANTE (id, dui_empleado, id_hotel, periodo_inicio, periodo_fin) VALUES (42,'44680851-6',15, CONVERT(DATE,'01/03/2024',103), CONVERT(DATE,'28/02/2026'));

INSERT INTO TIPO_HABITACION (id, tipo) VALUES (1,'Individual');
INSERT INTO TIPO_HABITACION (id, tipo) VALUES (2,'Doble');
INSERT INTO TIPO_HABITACION (id, tipo) VALUES (3,'Familiar');
INSERT INTO TIPO_HABITACION (id, tipo) VALUES (4,'Suite');

INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(1,'101',139.0,2,1);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(2,'102',98.0,2,1);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(3,'103',168.99,3,1);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(4,'10',197.99,3,2);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(5,'11',70.0,1,2);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(6,'12',160.99,3,2);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(7,'1',162.99,4,3);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(8,'2',70.99,3,3);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(9,'3',111.0,1,3);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(10,'101',142.0,2,4);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(11,'102',154.99,3,4);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(12,'103',183.0,2,4);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(13,'10',172.99,4,5);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(14,'11',137.0,1,5);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(15,'12',149.0,2,5);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(16,'1',165.99,3,6);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(17,'2',86.99,3,6);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(18,'3',66.99,4,6);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(19,'101',199.99,4,7);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(20,'102',145.99,3,7);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(21,'103',182.0,1,7);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(22,'10',150.99,3,8);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(23,'11',97.99,4,8);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(24,'12',118.99,4,8);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(25,'1',175.0,2,9);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(26,'2',106.99,3,9);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(27,'3',90.0,1,9);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(28,'101',183.99,4,10);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(29,'102',140.0,2,10);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(30,'103',138.0,1,10);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(31,'10',85.0,1,11);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(32,'11',157.99,4,11);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(33,'12',102.0,2,11);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(34,'1',72.99,3,12);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(35,'2',185.0,2,12);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(36,'3',190.0,1,12);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(37,'101',114.0,1,13);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(38,'102',103.0,1,13);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(39,'103',130.0,2,13);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(40,'10',163.99,3,14);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(41,'11',133.0,2,14);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(42,'12',79.99,4,14);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(43,'1',90.99,4,15);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(44,'2',88.0,2,15);
INSERT INTO HABITACION (id, numero, precio, id_tipo_habitacion, id_hotel) VALUES(45,'3',95.99,3,15);

INSERT INTO PAIS (id, pais) VALUES(1,'Costa Rica');
INSERT INTO PAIS (id, pais) VALUES(2,'El Salvador');
INSERT INTO PAIS (id, pais) VALUES(3,'Guatemala');
INSERT INTO PAIS (id, pais) VALUES(4,'Honduras');
INSERT INTO PAIS (id, pais) VALUES(5,'Nicaragua');
INSERT INTO PAIS (id, pais) VALUES(6,'Panamá');
INSERT INTO PAIS (id, pais) VALUES(7,'Estados Unidos');
INSERT INTO PAIS (id, pais) VALUES(8,'Canadá');
INSERT INTO PAIS (id, pais) VALUES(9,'México');
INSERT INTO PAIS (id, pais) VALUES(10,'Ecuador');
INSERT INTO PAIS (id, pais) VALUES(11,'Argentina');
INSERT INTO PAIS (id, pais) VALUES(12,'Chile');
INSERT INTO PAIS (id, pais) VALUES(13,'Colombia');
INSERT INTO PAIS (id, pais) VALUES(14,'Francia');
INSERT INTO PAIS (id, pais) VALUES(15,'España');
INSERT INTO PAIS (id, pais) VALUES(16,'Italia');
INSERT INTO PAIS (id, pais) VALUES(17,'Cuba');
INSERT INTO PAIS (id, pais) VALUES(18,'Puerto Rico');
INSERT INTO PAIS (id, pais) VALUES(19,'Egipto');
INSERT INTO PAIS (id, pais) VALUES(20,'India');

INSERT INTO CATEGORIA_CLIENTE (id, categoria) VALUES(1,'backpacker');
INSERT INTO CATEGORIA_CLIENTE (id, categoria) VALUES(2,'viajero');
INSERT INTO CATEGORIA_CLIENTE (id, categoria) VALUES(3,'senior');
INSERT INTO CATEGORIA_CLIENTE (id, categoria) VALUES(4,'trabajador');
INSERT INTO CATEGORIA_CLIENTE (id, categoria) VALUES(5,'ejecutivo');

INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (1,'Otto Keller','U26375757',19,5);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (2,'Emi Martin','A14183183',15,1);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (3,'Yuri Newton','V56601953',6,2);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (4,'Melinda Nolan','C77451997',12,5);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (5,'Avram Knapp','D20814237',2,3);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (6,'Allegra Davidson','T99308210',17,5);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (7,'Cedric Powell','V53839369',4,2);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (8,'Lance Fernandez','Z30753232',20,5);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (9,'Randall Kirk','H32946806',13,3);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (10,'Craig Wagner','F26853618',7,5);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (11,'Colorado Hill','V41667181',6,5);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (12,'Perry Hendricks','M12854335',1,2);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (13,'Buckminster Robinson','S26563471',8,2);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (14,'Gary Wilkerson','R38498923',17,4);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (15,'Raven Hickman','U83403320',16,4);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (16,'Bernard Osborne','T72434716',1,1);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (17,'Karleigh Rhodes','J60173801',12,5);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (18,'Cailin Bonner','X53838667',20,4);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (19,'Harper Cash','R23628180',5,5);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (20,'Alec Rodgers','V79045000',7,5);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (21,'Harriet Fisher','V30561986',12,1);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (22,'Paul Wagner','Z43555089',16,5);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (23,'Ginger Gross','L27832034',14,2);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (24,'Beau Rutledge','Z25933015',12,1);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (25,'Plato Graves','M43158350',17,2);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (26,'Kirsten Harrison','C15056702',18,3);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (27,'Sade Maxwell','S22200578',13,3);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (28,'Octavius Baldwin','H58684434',16,3);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (29,'Travis Ware','Z72280790',13,5);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (30,'Addison Lloyd','N71931875',19,2);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (31,'Adena Simpson','F83686757',14,5);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (32,'Jin Pierce','E43691109',8,2);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (33,'Shelly Haney','C55573494',6,4);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (34,'Alika Bryant','C94954045',18,5);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (35,'Yetta Solomon','M69417173',3,3);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (36,'Ingrid Frank','T26235821',11,2);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (37,'Asher Hays','W91387824',9,3);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (38,'Deborah Gomez','D33938709',20,2);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (39,'Erich Mayer','O35094849',9,1);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (40,'Georgia Alston','S83242846',1,5);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (41,'Drew Gallegos','T93136919',18,3);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (42,'Kelly Patel','S20369363',19,5);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (43,'Delilah Hoover','N20191730',4,3);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (44,'Stephen Bradshaw','U34653457',3,3);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (45,'Xavier Moran','H71225279',17,2);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (46,'Fletcher Glass','L12504598',7,2);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (47,'Sydnee Knight','Y38449397',6,3);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (48,'Ross Sampson','X35081350',4,5);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (49,'Roary Norris','C41567724',14,5);
INSERT INTO CLIENTE (id, nombre, documento, id_pais, categoria_cliente) VALUES (50,'Briar Zamora','Y73797483',20,3);

INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (1,'vestibulum.ante@yahoo.couk',1);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (2,'gravida@protonmail.net',1);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (3,'interdum.ligula@protonmail.edu',1);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (4,'auctor@aol.edu',2);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (5,'nullam@protonmail.ca',4);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (6,'et.magnis@aol.org',4);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (7,'nulla.interdum.curabitur@hotmail.ca',5);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (8,'vitae.semper.egestas@outlook.edu',6);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (9,'urna.et.arcu@google.com',6);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (10,'placerat.velit@hotmail.couk',6);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (11,'neque.et@protonmail.ca',6);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (12,'lorem@hotmail.edu',6);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (13,'vitae.aliquet@icloud.net',7);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (14,'arcu.vivamus.sit@outlook.edu',7);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (15,'ornare.sagittis@outlook.net',7);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (16,'nisi.sem@hotmail.net',7);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (17,'aenean.euismod.mauris@icloud.org',8);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (18,'congue.in@aol.org',8);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (19,'nullam@protonmail.com',9);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (20,'orci.tincidunt@icloud.net',9);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (21,'massa.vestibulum.accumsan@icloud.org',9);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (22,'dis.parturient@yahoo.net',10);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (23,'sollicitudin.orci@aol.edu',10);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (24,'quis.massa@yahoo.org',11);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (25,'sollicitudin@outlook.com',11);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (26,'mollis.nec@aol.net',12);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (27,'parturient.montes@protonmail.net',12);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (28,'eleifend.cras.sed@outlook.net',12);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (29,'pretium@google.com',12);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (30,'cum.sociis@icloud.ca',13);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (31,'lacinia.mattis@aol.org',13);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (32,'egestas.aliquam@aol.net',14);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (33,'dictum.eu.eleifend@google.couk',15);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (34,'facilisis.non@outlook.com',16);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (35,'hendrerit.consectetuer@outlook.net',16);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (36,'nisi.mauris@hotmail.couk',17);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (37,'neque.venenatis@hotmail.net',18);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (38,'semper.tellus.id@protonmail.edu',18);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (39,'commodo.at@google.org',19);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (40,'ipsum.dolor@hotmail.edu',19);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (41,'morbi.vehicula.pellentesque@protonmail.couk',21);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (42,'orci@google.com',21);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (43,'quam@outlook.com',21);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (44,'mollis@protonmail.org',22);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (45,'duis@icloud.net',22);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (46,'lorem@aol.couk',24);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (47,'donec.egestas@icloud.couk',26);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (48,'auctor.mauris@outlook.net',26);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (49,'odio.tristique@protonmail.net',26);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (50,'consectetuer.adipiscing@google.net',26);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (51,'ullamcorper.velit@hotmail.com',27);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (52,'erat@yahoo.ca',27);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (53,'non.nisi@aol.couk',27);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (54,'malesuada.integer@hotmail.net',27);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (55,'elementum.at.egestas@google.ca',28);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (56,'montes.nascetur@hotmail.net',28);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (57,'nec.urna@icloud.ca',29);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (58,'ut@aol.couk',29);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (59,'enim.diam@yahoo.edu',30);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (60,'mi.fringilla@protonmail.org',30);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (61,'mi.lacinia.mattis@protonmail.com',31);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (62,'eu.sem@yahoo.ca',31);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (63,'tempus.risus.donec@yahoo.com',32);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (64,'convallis.convallis@google.edu',33);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (65,'et@hotmail.net',33);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (66,'risus.quis@google.net',35);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (67,'lobortis@google.com',35);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (68,'nunc@hotmail.couk',36);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (69,'tellus.non.magna@outlook.couk',37);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (70,'cursus.et@hotmail.net',37);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (71,'massa.quisque@google.edu',38);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (72,'nullam.enim@icloud.couk',38);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (73,'nullam.vitae@icloud.ca',38);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (74,'ullamcorper.magna@icloud.edu',39);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (75,'et@google.ca',39);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (76,'bibendum.fermentum@aol.com',39);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (77,'arcu.eu@icloud.ca',39);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (78,'aliquam@icloud.edu',40);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (79,'purus@aol.net',41);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (80,'risus@hotmail.edu',41);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (81,'vitae.orci@aol.couk',43);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (82,'dolor@yahoo.edu',44);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (83,'magna.sed@protonmail.edu',44);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (84,'mi.pede@yahoo.edu',45);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (85,'sed.dictum@aol.edu',45);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (86,'porttitor.vulputate@outlook.ca',46);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (87,'scelerisque.scelerisque@yahoo.org',46);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (88,'praesent.interdum@hotmail.net',46);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (89,'at@yahoo.net',46);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (90,'pharetra.nam.ac@yahoo.couk',46);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (91,'non@outlook.com',46);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (92,'maecenas.malesuada@aol.org',47);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (93,'nulla.facilisi@yahoo.net',47);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (94,'amet.luctus@google.org',47);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (95,'luctus@protonmail.ca',48);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (96,'non@icloud.net',48);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (97,'felis.eget@aol.com',49);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (98,'tortor.nibh@aol.edu',49);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (99,'nulla.eu@outlook.net',49);
INSERT INTO CORREO_CLIENTE (id, correo, id_cliente) VALUES (100,'aliquet.diam@hotmail.ca',50);

INSERT INTO servicio (id, nombre, precio) VALUES(1, 'Minibar', 9.50);
INSERT INTO servicio (id, nombre, precio) VALUES(2, 'Moet & Chandon', 79.50);
INSERT INTO servicio (id, nombre, precio) VALUES(3, 'Champagne & chocolates', 20.99);
INSERT INTO servicio (id, nombre, precio) VALUES(4, 'Uso de spa', 30.00);
INSERT INTO servicio (id, nombre, precio) VALUES(5, 'Guía turístico', 10.50);
INSERT INTO servicio (id, nombre, precio) VALUES(6, 'Transporte privado', 20.00);
INSERT INTO servicio (id, nombre, precio) VALUES(7, 'Cambio de moneda', 5.63);
INSERT INTO servicio (id, nombre, precio) VALUES(8, 'Acompañamiento en compras', 23.75);
INSERT INTO servicio (id, nombre, precio) VALUES(9, 'Babysitter', 10.00);
INSERT INTO servicio (id, nombre, precio) VALUES(10,'Flores', 14.99);

INSERT INTO METODO_PAGO (id, metodo_pago) VALUES(1, 'Mastercard');
INSERT INTO METODO_PAGO (id, metodo_pago) VALUES(2, 'Visa');
INSERT INTO METODO_PAGO (id, metodo_pago) VALUES(3, 'Efectivo');
INSERT INTO METODO_PAGO (id, metodo_pago) VALUES(4, 'Bitcoin');
INSERT INTO METODO_PAGO (id, metodo_pago) VALUES(5, 'Puntos de cliente');

INSERT INTO RESERVA VALUES(1,CONVERT(DATE,'01/05/2022',103),CONVERT(DATE,'02/05/2022',103),1,6,24);
INSERT INTO RESERVA VALUES(2,CONVERT(DATE,'01/05/2022',103),CONVERT(DATE,'05/05/2022',103),2,9,36);
INSERT INTO RESERVA VALUES(3,CONVERT(DATE,'01/05/2022',103),CONVERT(DATE,'04/05/2022',103),3,9,8);
INSERT INTO RESERVA VALUES(4,CONVERT(DATE,'01/05/2022',103),CONVERT(DATE,'03/05/2022',103),3,3,42);
INSERT INTO RESERVA VALUES(5,CONVERT(DATE,'01/05/2022',103),CONVERT(DATE,'02/05/2022',103),5,29,32);
INSERT INTO RESERVA VALUES(6,CONVERT(DATE,'01/05/2022',103),CONVERT(DATE,'03/05/2022',103),1,15,29);
INSERT INTO RESERVA VALUES(7,CONVERT(DATE,'02/05/2022',103),CONVERT(DATE,'04/05/2022',103),4,47,13);
INSERT INTO RESERVA VALUES(8,CONVERT(DATE,'03/05/2022',103),CONVERT(DATE,'08/05/2022',103),2,10,41);
INSERT INTO RESERVA VALUES(9,CONVERT(DATE,'03/05/2022',103),CONVERT(DATE,'04/05/2022',103),4,17,4);
INSERT INTO RESERVA VALUES(10,CONVERT(DATE,'03/05/2022',103),CONVERT(DATE,'08/05/2022',103),4,48,30);
INSERT INTO RESERVA VALUES(11,CONVERT(DATE,'03/05/2022',103),CONVERT(DATE,'04/05/2022',103),2,39,37);
INSERT INTO RESERVA VALUES(12,CONVERT(DATE,'04/05/2022',103),CONVERT(DATE,'07/05/2022',103),5,1,43);
INSERT INTO RESERVA VALUES(13,CONVERT(DATE,'04/05/2022',103),CONVERT(DATE,'08/05/2022',103),4,30,23);
INSERT INTO RESERVA VALUES(14,CONVERT(DATE,'04/05/2022',103),CONVERT(DATE,'05/05/2022',103),1,2,39);
INSERT INTO RESERVA VALUES(15,CONVERT(DATE,'04/05/2022',103),CONVERT(DATE,'05/05/2022',103),3,39,18);
INSERT INTO RESERVA VALUES(16,CONVERT(DATE,'04/05/2022',103),CONVERT(DATE,'09/05/2022',103),3,46,4);
INSERT INTO RESERVA VALUES(17,CONVERT(DATE,'04/05/2022',103),CONVERT(DATE,'05/05/2022',103),1,17,27);
INSERT INTO RESERVA VALUES(18,CONVERT(DATE,'04/05/2022',103),CONVERT(DATE,'06/05/2022',103),4,29,14);
INSERT INTO RESERVA VALUES(19,CONVERT(DATE,'04/05/2022',103),CONVERT(DATE,'06/05/2022',103),2,41,14);
INSERT INTO RESERVA VALUES(20,CONVERT(DATE,'04/05/2022',103),CONVERT(DATE,'09/05/2022',103),5,48,37);
INSERT INTO RESERVA VALUES(21,CONVERT(DATE,'05/05/2022',103),CONVERT(DATE,'10/05/2022',103),2,26,5);
INSERT INTO RESERVA VALUES(22,CONVERT(DATE,'05/05/2022',103),CONVERT(DATE,'09/05/2022',103),4,11,14);
INSERT INTO RESERVA VALUES(23,CONVERT(DATE,'05/05/2022',103),CONVERT(DATE,'10/05/2022',103),5,3,19);
INSERT INTO RESERVA VALUES(24,CONVERT(DATE,'06/05/2022',103),CONVERT(DATE,'07/05/2022',103),4,14,4);
INSERT INTO RESERVA VALUES(25,CONVERT(DATE,'06/05/2022',103),CONVERT(DATE,'09/05/2022',103),4,30,40);
INSERT INTO RESERVA VALUES(26,CONVERT(DATE,'07/05/2022',103),CONVERT(DATE,'08/05/2022',103),3,8,37);
INSERT INTO RESERVA VALUES(27,CONVERT(DATE,'07/05/2022',103),CONVERT(DATE,'10/05/2022',103),2,34,9);
INSERT INTO RESERVA VALUES(28,CONVERT(DATE,'07/05/2022',103),CONVERT(DATE,'11/05/2022',103),1,32,45);
INSERT INTO RESERVA VALUES(29,CONVERT(DATE,'07/05/2022',103),CONVERT(DATE,'10/05/2022',103),3,5,21);
INSERT INTO RESERVA VALUES(30,CONVERT(DATE,'07/05/2022',103),CONVERT(DATE,'12/05/2022',103),1,8,42);
INSERT INTO RESERVA VALUES(31,CONVERT(DATE,'07/05/2022',103),CONVERT(DATE,'12/05/2022',103),4,39,40);
INSERT INTO RESERVA VALUES(32,CONVERT(DATE,'07/05/2022',103),CONVERT(DATE,'09/05/2022',103),2,12,27);
INSERT INTO RESERVA VALUES(33,CONVERT(DATE,'08/05/2022',103),CONVERT(DATE,'13/05/2022',103),1,14,25);
INSERT INTO RESERVA VALUES(34,CONVERT(DATE,'08/05/2022',103),CONVERT(DATE,'12/05/2022',103),5,6,3);
INSERT INTO RESERVA VALUES(35,CONVERT(DATE,'08/05/2022',103),CONVERT(DATE,'12/05/2022',103),3,2,38);
INSERT INTO RESERVA VALUES(36,CONVERT(DATE,'08/05/2022',103),CONVERT(DATE,'09/05/2022',103),5,13,22);
INSERT INTO RESERVA VALUES(37,CONVERT(DATE,'08/05/2022',103),CONVERT(DATE,'12/05/2022',103),2,50,25);
INSERT INTO RESERVA VALUES(38,CONVERT(DATE,'08/05/2022',103),CONVERT(DATE,'09/05/2022',103),2,21,12);
INSERT INTO RESERVA VALUES(39,CONVERT(DATE,'09/05/2022',103),CONVERT(DATE,'10/05/2022',103),5,44,11);
INSERT INTO RESERVA VALUES(40,CONVERT(DATE,'09/05/2022',103),CONVERT(DATE,'13/05/2022',103),5,17,37);
INSERT INTO RESERVA VALUES(41,CONVERT(DATE,'09/05/2022',103),CONVERT(DATE,'14/05/2022',103),3,31,13);
INSERT INTO RESERVA VALUES(42,CONVERT(DATE,'09/05/2022',103),CONVERT(DATE,'12/05/2022',103),4,30,29);
INSERT INTO RESERVA VALUES(43,CONVERT(DATE,'09/05/2022',103),CONVERT(DATE,'14/05/2022',103),5,11,20);
INSERT INTO RESERVA VALUES(44,CONVERT(DATE,'09/05/2022',103),CONVERT(DATE,'10/05/2022',103),5,26,30);
INSERT INTO RESERVA VALUES(45,CONVERT(DATE,'09/05/2022',103),CONVERT(DATE,'10/05/2022',103),3,17,32);
INSERT INTO RESERVA VALUES(46,CONVERT(DATE,'10/05/2022',103),CONVERT(DATE,'15/05/2022',103),3,26,34);
INSERT INTO RESERVA VALUES(47,CONVERT(DATE,'10/05/2022',103),CONVERT(DATE,'15/05/2022',103),2,36,27);
INSERT INTO RESERVA VALUES(48,CONVERT(DATE,'11/05/2022',103),CONVERT(DATE,'13/05/2022',103),5,9,4);
INSERT INTO RESERVA VALUES(49,CONVERT(DATE,'11/05/2022',103),CONVERT(DATE,'15/05/2022',103),3,20,12);
INSERT INTO RESERVA VALUES(50,CONVERT(DATE,'12/05/2022',103),CONVERT(DATE,'17/05/2022',103),4,42,19);
INSERT INTO RESERVA VALUES(51,CONVERT(DATE,'12/05/2022',103),CONVERT(DATE,'13/05/2022',103),2,34,44);
INSERT INTO RESERVA VALUES(52,CONVERT(DATE,'13/05/2022',103),CONVERT(DATE,'17/05/2022',103),2,25,14);
INSERT INTO RESERVA VALUES(53,CONVERT(DATE,'14/05/2022',103),CONVERT(DATE,'19/05/2022',103),2,5,29);
INSERT INTO RESERVA VALUES(54,CONVERT(DATE,'14/05/2022',103),CONVERT(DATE,'16/05/2022',103),4,38,1);
INSERT INTO RESERVA VALUES(55,CONVERT(DATE,'14/05/2022',103),CONVERT(DATE,'16/05/2022',103),2,41,25);
INSERT INTO RESERVA VALUES(56,CONVERT(DATE,'14/05/2022',103),CONVERT(DATE,'19/05/2022',103),1,46,8);
INSERT INTO RESERVA VALUES(57,CONVERT(DATE,'14/05/2022',103),CONVERT(DATE,'19/05/2022',103),2,29,32);
INSERT INTO RESERVA VALUES(58,CONVERT(DATE,'15/05/2022',103),CONVERT(DATE,'16/05/2022',103),4,22,29);
INSERT INTO RESERVA VALUES(59,CONVERT(DATE,'15/05/2022',103),CONVERT(DATE,'16/05/2022',103),1,48,19);
INSERT INTO RESERVA VALUES(60,CONVERT(DATE,'15/05/2022',103),CONVERT(DATE,'19/05/2022',103),4,3,15);
INSERT INTO RESERVA VALUES(61,CONVERT(DATE,'15/05/2022',103),CONVERT(DATE,'18/05/2022',103),2,19,6);
INSERT INTO RESERVA VALUES(62,CONVERT(DATE,'16/05/2022',103),CONVERT(DATE,'18/05/2022',103),5,3,1);
INSERT INTO RESERVA VALUES(63,CONVERT(DATE,'16/05/2022',103),CONVERT(DATE,'21/05/2022',103),4,13,43);
INSERT INTO RESERVA VALUES(64,CONVERT(DATE,'16/05/2022',103),CONVERT(DATE,'18/05/2022',103),3,19,32);
INSERT INTO RESERVA VALUES(65,CONVERT(DATE,'16/05/2022',103),CONVERT(DATE,'18/05/2022',103),3,47,24);
INSERT INTO RESERVA VALUES(66,CONVERT(DATE,'17/05/2022',103),CONVERT(DATE,'21/05/2022',103),4,2,38);
INSERT INTO RESERVA VALUES(67,CONVERT(DATE,'17/05/2022',103),CONVERT(DATE,'21/05/2022',103),5,31,7);
INSERT INTO RESERVA VALUES(68,CONVERT(DATE,'17/05/2022',103),CONVERT(DATE,'20/05/2022',103),1,33,29);
INSERT INTO RESERVA VALUES(69,CONVERT(DATE,'18/05/2022',103),CONVERT(DATE,'23/05/2022',103),1,19,24);
INSERT INTO RESERVA VALUES(70,CONVERT(DATE,'18/05/2022',103),CONVERT(DATE,'19/05/2022',103),3,7,33);
INSERT INTO RESERVA VALUES(71,CONVERT(DATE,'18/05/2022',103),CONVERT(DATE,'20/05/2022',103),3,43,26);
INSERT INTO RESERVA VALUES(72,CONVERT(DATE,'18/05/2022',103),CONVERT(DATE,'23/05/2022',103),4,21,39);
INSERT INTO RESERVA VALUES(73,CONVERT(DATE,'18/05/2022',103),CONVERT(DATE,'20/05/2022',103),3,37,19);
INSERT INTO RESERVA VALUES(74,CONVERT(DATE,'19/05/2022',103),CONVERT(DATE,'24/05/2022',103),3,30,4);
INSERT INTO RESERVA VALUES(75,CONVERT(DATE,'19/05/2022',103),CONVERT(DATE,'23/05/2022',103),2,24,44);
INSERT INTO RESERVA VALUES(76,CONVERT(DATE,'20/05/2022',103),CONVERT(DATE,'24/05/2022',103),4,11,10);
INSERT INTO RESERVA VALUES(77,CONVERT(DATE,'20/05/2022',103),CONVERT(DATE,'22/05/2022',103),5,6,40);
INSERT INTO RESERVA VALUES(78,CONVERT(DATE,'20/05/2022',103),CONVERT(DATE,'21/05/2022',103),5,18,33);
INSERT INTO RESERVA VALUES(79,CONVERT(DATE,'21/05/2022',103),CONVERT(DATE,'24/05/2022',103),2,30,5);
INSERT INTO RESERVA VALUES(80,CONVERT(DATE,'21/05/2022',103),CONVERT(DATE,'24/05/2022',103),4,45,10);
INSERT INTO RESERVA VALUES(81,CONVERT(DATE,'22/05/2022',103),CONVERT(DATE,'24/05/2022',103),3,27,2);
INSERT INTO RESERVA VALUES(82,CONVERT(DATE,'23/05/2022',103),CONVERT(DATE,'27/05/2022',103),5,36,36);
INSERT INTO RESERVA VALUES(83,CONVERT(DATE,'23/05/2022',103),CONVERT(DATE,'28/05/2022',103),1,12,43);
INSERT INTO RESERVA VALUES(84,CONVERT(DATE,'23/05/2022',103),CONVERT(DATE,'28/05/2022',103),2,40,31);
INSERT INTO RESERVA VALUES(85,CONVERT(DATE,'23/05/2022',103),CONVERT(DATE,'25/05/2022',103),4,36,40);
INSERT INTO RESERVA VALUES(86,CONVERT(DATE,'24/05/2022',103),CONVERT(DATE,'25/05/2022',103),1,7,39);
INSERT INTO RESERVA VALUES(87,CONVERT(DATE,'24/05/2022',103),CONVERT(DATE,'25/05/2022',103),2,10,25);
INSERT INTO RESERVA VALUES(88,CONVERT(DATE,'24/05/2022',103),CONVERT(DATE,'25/05/2022',103),5,41,34);
INSERT INTO RESERVA VALUES(89,CONVERT(DATE,'24/05/2022',103),CONVERT(DATE,'28/05/2022',103),3,33,22);
INSERT INTO RESERVA VALUES(90,CONVERT(DATE,'26/05/2022',103),CONVERT(DATE,'31/05/2022',103),2,36,45);
INSERT INTO RESERVA VALUES(91,CONVERT(DATE,'26/05/2022',103),CONVERT(DATE,'30/05/2022',103),1,20,6);
INSERT INTO RESERVA VALUES(92,CONVERT(DATE,'26/05/2022',103),CONVERT(DATE,'28/05/2022',103),1,35,28);
INSERT INTO RESERVA VALUES(93,CONVERT(DATE,'26/05/2022',103),CONVERT(DATE,'31/05/2022',103),3,40,13);
INSERT INTO RESERVA VALUES(94,CONVERT(DATE,'27/05/2022',103),CONVERT(DATE,'31/05/2022',103),2,25,32);
INSERT INTO RESERVA VALUES(95,CONVERT(DATE,'27/05/2022',103),CONVERT(DATE,'01/06/2022',103),1,23,10);
INSERT INTO RESERVA VALUES(96,CONVERT(DATE,'27/05/2022',103),CONVERT(DATE,'28/05/2022',103),4,40,25);
INSERT INTO RESERVA VALUES(97,CONVERT(DATE,'27/05/2022',103),CONVERT(DATE,'31/05/2022',103),5,50,45);
INSERT INTO RESERVA VALUES(98,CONVERT(DATE,'28/05/2022',103),CONVERT(DATE,'31/05/2022',103),3,17,20);
INSERT INTO RESERVA VALUES(99,CONVERT(DATE,'29/05/2022',103),CONVERT(DATE,'02/06/2022',103),1,23,3);
INSERT INTO RESERVA VALUES(100,CONVERT(DATE,'29/05/2022',103),CONVERT(DATE,'31/05/2022',103),4,27,32);
INSERT INTO RESERVA VALUES(101,CONVERT(DATE,'30/05/2022',103),CONVERT(DATE,'04/06/2022',103),5,15,5);
INSERT INTO RESERVA VALUES(102,CONVERT(DATE,'30/05/2022',103),CONVERT(DATE,'04/06/2022',103),2,36,22);
INSERT INTO RESERVA VALUES(103,CONVERT(DATE,'31/05/2022',103),CONVERT(DATE,'05/06/2022',103),3,32,16);
INSERT INTO RESERVA VALUES(104,CONVERT(DATE,'31/05/2022',103),CONVERT(DATE,'04/06/2022',103),5,12,10);
INSERT INTO RESERVA VALUES(105,CONVERT(DATE,'31/05/2022',103),CONVERT(DATE,'01/06/2022',103),4,25,17);
INSERT INTO RESERVA VALUES(106,CONVERT(DATE,'01/06/2022',103),CONVERT(DATE,'03/06/2022',103),4,27,13);
INSERT INTO RESERVA VALUES(107,CONVERT(DATE,'01/06/2022',103),CONVERT(DATE,'05/06/2022',103),3,13,13);
INSERT INTO RESERVA VALUES(108,CONVERT(DATE,'02/06/2022',103),CONVERT(DATE,'07/06/2022',103),2,27,33);
INSERT INTO RESERVA VALUES(109,CONVERT(DATE,'02/06/2022',103),CONVERT(DATE,'05/06/2022',103),4,34,2);
INSERT INTO RESERVA VALUES(110,CONVERT(DATE,'02/06/2022',103),CONVERT(DATE,'04/06/2022',103),3,21,21);
INSERT INTO RESERVA VALUES(111,CONVERT(DATE,'02/06/2022',103),CONVERT(DATE,'03/06/2022',103),4,33,21);
INSERT INTO RESERVA VALUES(112,CONVERT(DATE,'03/06/2022',103),CONVERT(DATE,'08/06/2022',103),3,40,42);
INSERT INTO RESERVA VALUES(113,CONVERT(DATE,'03/06/2022',103),CONVERT(DATE,'04/06/2022',103),2,32,10);
INSERT INTO RESERVA VALUES(114,CONVERT(DATE,'03/06/2022',103),CONVERT(DATE,'04/06/2022',103),4,22,10);
INSERT INTO RESERVA VALUES(115,CONVERT(DATE,'04/06/2022',103),CONVERT(DATE,'06/06/2022',103),1,49,5);
INSERT INTO RESERVA VALUES(116,CONVERT(DATE,'04/06/2022',103),CONVERT(DATE,'09/06/2022',103),1,10,19);
INSERT INTO RESERVA VALUES(117,CONVERT(DATE,'05/06/2022',103),CONVERT(DATE,'09/06/2022',103),5,14,20);
INSERT INTO RESERVA VALUES(118,CONVERT(DATE,'05/06/2022',103),CONVERT(DATE,'10/06/2022',103),5,21,7);
INSERT INTO RESERVA VALUES(119,CONVERT(DATE,'05/06/2022',103),CONVERT(DATE,'07/06/2022',103),4,50,4);
INSERT INTO RESERVA VALUES(120,CONVERT(DATE,'06/06/2022',103),CONVERT(DATE,'10/06/2022',103),5,16,43);
INSERT INTO RESERVA VALUES(121,CONVERT(DATE,'06/06/2022',103),CONVERT(DATE,'09/06/2022',103),3,31,27);
INSERT INTO RESERVA VALUES(122,CONVERT(DATE,'06/06/2022',103),CONVERT(DATE,'10/06/2022',103),4,41,37);
INSERT INTO RESERVA VALUES(123,CONVERT(DATE,'06/06/2022',103),CONVERT(DATE,'08/06/2022',103),1,23,27);
INSERT INTO RESERVA VALUES(124,CONVERT(DATE,'06/06/2022',103),CONVERT(DATE,'08/06/2022',103),1,15,1);
INSERT INTO RESERVA VALUES(125,CONVERT(DATE,'07/06/2022',103),CONVERT(DATE,'09/06/2022',103),3,49,44);
INSERT INTO RESERVA VALUES(126,CONVERT(DATE,'07/06/2022',103),CONVERT(DATE,'08/06/2022',103),2,18,44);
INSERT INTO RESERVA VALUES(127,CONVERT(DATE,'07/06/2022',103),CONVERT(DATE,'12/06/2022',103),4,47,12);
INSERT INTO RESERVA VALUES(128,CONVERT(DATE,'07/06/2022',103),CONVERT(DATE,'09/06/2022',103),1,19,33);
INSERT INTO RESERVA VALUES(129,CONVERT(DATE,'07/06/2022',103),CONVERT(DATE,'09/06/2022',103),3,18,39);
INSERT INTO RESERVA VALUES(130,CONVERT(DATE,'08/06/2022',103),CONVERT(DATE,'12/06/2022',103),2,19,38);
INSERT INTO RESERVA VALUES(131,CONVERT(DATE,'08/06/2022',103),CONVERT(DATE,'10/06/2022',103),1,23,41);
INSERT INTO RESERVA VALUES(132,CONVERT(DATE,'08/06/2022',103),CONVERT(DATE,'13/06/2022',103),5,38,23);
INSERT INTO RESERVA VALUES(133,CONVERT(DATE,'09/06/2022',103),CONVERT(DATE,'10/06/2022',103),1,8,3);
INSERT INTO RESERVA VALUES(134,CONVERT(DATE,'09/06/2022',103),CONVERT(DATE,'11/06/2022',103),4,19,25);
INSERT INTO RESERVA VALUES(135,CONVERT(DATE,'10/06/2022',103),CONVERT(DATE,'14/06/2022',103),1,18,3);
INSERT INTO RESERVA VALUES(136,CONVERT(DATE,'10/06/2022',103),CONVERT(DATE,'11/06/2022',103),2,19,7);
INSERT INTO RESERVA VALUES(137,CONVERT(DATE,'10/06/2022',103),CONVERT(DATE,'11/06/2022',103),2,28,12);
INSERT INTO RESERVA VALUES(138,CONVERT(DATE,'10/06/2022',103),CONVERT(DATE,'12/06/2022',103),2,39,35);
INSERT INTO RESERVA VALUES(139,CONVERT(DATE,'11/06/2022',103),CONVERT(DATE,'13/06/2022',103),4,37,21);
INSERT INTO RESERVA VALUES(140,CONVERT(DATE,'12/06/2022',103),CONVERT(DATE,'14/06/2022',103),4,30,30);
INSERT INTO RESERVA VALUES(141,CONVERT(DATE,'12/06/2022',103),CONVERT(DATE,'17/06/2022',103),5,11,22);
INSERT INTO RESERVA VALUES(142,CONVERT(DATE,'12/06/2022',103),CONVERT(DATE,'14/06/2022',103),4,20,24);
INSERT INTO RESERVA VALUES(143,CONVERT(DATE,'12/06/2022',103),CONVERT(DATE,'15/06/2022',103),4,19,12);
INSERT INTO RESERVA VALUES(144,CONVERT(DATE,'13/06/2022',103),CONVERT(DATE,'14/06/2022',103),1,43,5);
INSERT INTO RESERVA VALUES(145,CONVERT(DATE,'13/06/2022',103),CONVERT(DATE,'16/06/2022',103),1,5,19);
INSERT INTO RESERVA VALUES(146,CONVERT(DATE,'13/06/2022',103),CONVERT(DATE,'15/06/2022',103),1,35,32);
INSERT INTO RESERVA VALUES(147,CONVERT(DATE,'14/06/2022',103),CONVERT(DATE,'15/06/2022',103),1,48,15);
INSERT INTO RESERVA VALUES(148,CONVERT(DATE,'14/06/2022',103),CONVERT(DATE,'16/06/2022',103),1,22,40);
INSERT INTO RESERVA VALUES(149,CONVERT(DATE,'14/06/2022',103),CONVERT(DATE,'15/06/2022',103),3,35,5);
INSERT INTO RESERVA VALUES(150,CONVERT(DATE,'15/06/2022',103),CONVERT(DATE,'19/06/2022',103),4,47,1);
INSERT INTO RESERVA VALUES(151,CONVERT(DATE,'15/06/2022',103),CONVERT(DATE,'20/06/2022',103),2,12,17);
INSERT INTO RESERVA VALUES(152,CONVERT(DATE,'16/06/2022',103),CONVERT(DATE,'18/06/2022',103),2,36,19);
INSERT INTO RESERVA VALUES(153,CONVERT(DATE,'16/06/2022',103),CONVERT(DATE,'19/06/2022',103),3,30,16);
INSERT INTO RESERVA VALUES(154,CONVERT(DATE,'16/06/2022',103),CONVERT(DATE,'17/06/2022',103),2,32,23);
INSERT INTO RESERVA VALUES(155,CONVERT(DATE,'17/06/2022',103),CONVERT(DATE,'18/06/2022',103),5,47,26);
INSERT INTO RESERVA VALUES(156,CONVERT(DATE,'17/06/2022',103),CONVERT(DATE,'21/06/2022',103),1,32,23);
INSERT INTO RESERVA VALUES(157,CONVERT(DATE,'17/06/2022',103),CONVERT(DATE,'19/06/2022',103),3,28,16);
INSERT INTO RESERVA VALUES(158,CONVERT(DATE,'18/06/2022',103),CONVERT(DATE,'22/06/2022',103),4,28,5);
INSERT INTO RESERVA VALUES(159,CONVERT(DATE,'18/06/2022',103),CONVERT(DATE,'21/06/2022',103),5,14,43);
INSERT INTO RESERVA VALUES(160,CONVERT(DATE,'19/06/2022',103),CONVERT(DATE,'22/06/2022',103),2,34,23);
INSERT INTO RESERVA VALUES(161,CONVERT(DATE,'19/06/2022',103),CONVERT(DATE,'23/06/2022',103),4,48,15);
INSERT INTO RESERVA VALUES(162,CONVERT(DATE,'19/06/2022',103),CONVERT(DATE,'20/06/2022',103),2,17,37);
INSERT INTO RESERVA VALUES(163,CONVERT(DATE,'19/06/2022',103),CONVERT(DATE,'20/06/2022',103),2,45,20);
INSERT INTO RESERVA VALUES(164,CONVERT(DATE,'19/06/2022',103),CONVERT(DATE,'20/06/2022',103),1,4,30);
INSERT INTO RESERVA VALUES(165,CONVERT(DATE,'20/06/2022',103),CONVERT(DATE,'25/06/2022',103),1,20,29);
INSERT INTO RESERVA VALUES(166,CONVERT(DATE,'20/06/2022',103),CONVERT(DATE,'22/06/2022',103),1,50,21);
INSERT INTO RESERVA VALUES(167,CONVERT(DATE,'20/06/2022',103),CONVERT(DATE,'22/06/2022',103),4,21,42);
INSERT INTO RESERVA VALUES(168,CONVERT(DATE,'20/06/2022',103),CONVERT(DATE,'21/06/2022',103),2,5,43);
INSERT INTO RESERVA VALUES(169,CONVERT(DATE,'20/06/2022',103),CONVERT(DATE,'25/06/2022',103),2,10,33);
INSERT INTO RESERVA VALUES(170,CONVERT(DATE,'20/06/2022',103),CONVERT(DATE,'22/06/2022',103),2,28,42);
INSERT INTO RESERVA VALUES(171,CONVERT(DATE,'21/06/2022',103),CONVERT(DATE,'23/06/2022',103),4,27,24);
INSERT INTO RESERVA VALUES(172,CONVERT(DATE,'21/06/2022',103),CONVERT(DATE,'26/06/2022',103),2,31,19);
INSERT INTO RESERVA VALUES(173,CONVERT(DATE,'22/06/2022',103),CONVERT(DATE,'27/06/2022',103),4,23,6);
INSERT INTO RESERVA VALUES(174,CONVERT(DATE,'22/06/2022',103),CONVERT(DATE,'23/06/2022',103),4,26,30);
INSERT INTO RESERVA VALUES(175,CONVERT(DATE,'22/06/2022',103),CONVERT(DATE,'24/06/2022',103),4,18,31);
INSERT INTO RESERVA VALUES(176,CONVERT(DATE,'22/06/2022',103),CONVERT(DATE,'23/06/2022',103),3,45,24);
INSERT INTO RESERVA VALUES(177,CONVERT(DATE,'23/06/2022',103),CONVERT(DATE,'25/06/2022',103),1,10,44);
INSERT INTO RESERVA VALUES(178,CONVERT(DATE,'23/06/2022',103),CONVERT(DATE,'25/06/2022',103),1,15,28);
INSERT INTO RESERVA VALUES(179,CONVERT(DATE,'23/06/2022',103),CONVERT(DATE,'28/06/2022',103),5,49,15);
INSERT INTO RESERVA VALUES(180,CONVERT(DATE,'24/06/2022',103),CONVERT(DATE,'26/06/2022',103),5,3,25);
INSERT INTO RESERVA VALUES(181,CONVERT(DATE,'24/06/2022',103),CONVERT(DATE,'27/06/2022',103),5,18,21);
INSERT INTO RESERVA VALUES(182,CONVERT(DATE,'24/06/2022',103),CONVERT(DATE,'27/06/2022',103),3,19,4);
INSERT INTO RESERVA VALUES(183,CONVERT(DATE,'24/06/2022',103),CONVERT(DATE,'26/06/2022',103),5,12,17);
INSERT INTO RESERVA VALUES(184,CONVERT(DATE,'25/06/2022',103),CONVERT(DATE,'30/06/2022',103),2,41,18);
INSERT INTO RESERVA VALUES(185,CONVERT(DATE,'25/06/2022',103),CONVERT(DATE,'29/06/2022',103),4,42,39);
INSERT INTO RESERVA VALUES(186,CONVERT(DATE,'26/06/2022',103),CONVERT(DATE,'29/06/2022',103),5,39,17);
INSERT INTO RESERVA VALUES(187,CONVERT(DATE,'26/06/2022',103),CONVERT(DATE,'29/06/2022',103),2,20,43);
INSERT INTO RESERVA VALUES(188,CONVERT(DATE,'26/06/2022',103),CONVERT(DATE,'29/06/2022',103),2,35,31);
INSERT INTO RESERVA VALUES(189,CONVERT(DATE,'26/06/2022',103),CONVERT(DATE,'29/06/2022',103),1,1,16);
INSERT INTO RESERVA VALUES(190,CONVERT(DATE,'26/06/2022',103),CONVERT(DATE,'27/06/2022',103),1,22,34);
INSERT INTO RESERVA VALUES(191,CONVERT(DATE,'26/06/2022',103),CONVERT(DATE,'01/07/2022',103),5,36,14);
INSERT INTO RESERVA VALUES(192,CONVERT(DATE,'26/06/2022',103),CONVERT(DATE,'27/06/2022',103),4,31,7);
INSERT INTO RESERVA VALUES(193,CONVERT(DATE,'27/06/2022',103),CONVERT(DATE,'29/06/2022',103),1,2,21);
INSERT INTO RESERVA VALUES(194,CONVERT(DATE,'27/06/2022',103),CONVERT(DATE,'01/07/2022',103),1,35,4);
INSERT INTO RESERVA VALUES(195,CONVERT(DATE,'27/06/2022',103),CONVERT(DATE,'02/07/2022',103),4,45,10);
INSERT INTO RESERVA VALUES(196,CONVERT(DATE,'27/06/2022',103),CONVERT(DATE,'01/07/2022',103),3,30,14);
INSERT INTO RESERVA VALUES(197,CONVERT(DATE,'28/06/2022',103),CONVERT(DATE,'30/06/2022',103),5,14,39);
INSERT INTO RESERVA VALUES(198,CONVERT(DATE,'29/06/2022',103),CONVERT(DATE,'04/07/2022',103),3,40,24);
INSERT INTO RESERVA VALUES(199,CONVERT(DATE,'30/06/2022',103),CONVERT(DATE,'03/07/2022',103),1,6,44);
INSERT INTO RESERVA VALUES(200,CONVERT(DATE,'30/06/2022',103),CONVERT(DATE,'01/07/2022',103),3,21,32);

INSERT INTO CANCELACION_RESERVA VALUES (1,CONVERT(DATETIME, '29/04/2022 07:08:19', 103),'elit fermentum risus, at fringilla purus mauris a nunc.',17);
INSERT INTO CANCELACION_RESERVA VALUES (2,CONVERT(DATETIME, '02/05/2022 05:53:09', 103),'vel quam dignissim pharetra. Nam ac nulla.',37);
INSERT INTO CANCELACION_RESERVA VALUES (3,CONVERT(DATETIME, '12/05/2022 17:11:14', 103),'tortor at risus. Nunc ac sem ut dolor dapibus gravida.',52);
INSERT INTO CANCELACION_RESERVA VALUES (4,CONVERT(DATETIME, '12/05/2022 16:08:32', 103),'ullamcorper eu, euismod ac, fermentum vel, mauris.',55);
INSERT INTO CANCELACION_RESERVA VALUES (5,CONVERT(DATETIME, '11/05/2022 13:23:31', 103),'Vivamus non lorem vitae odio sagittis',69);
INSERT INTO CANCELACION_RESERVA VALUES (6,CONVERT(DATETIME, '16/05/2022 05:24:59', 103),'rutrum magna. Cras convallis convallis',71);
INSERT INTO CANCELACION_RESERVA VALUES (7,CONVERT(DATETIME, '30/05/2022 21:53:50', 103),'viverra. Donec tempus, lorem fringilla ornare',122);
INSERT INTO CANCELACION_RESERVA VALUES (8,CONVERT(DATETIME, '06/06/2022 03:29:28', 103),'at, nisi. Cum sociis natoque penatibus',141);
INSERT INTO CANCELACION_RESERVA VALUES (9,CONVERT(DATETIME, '07/06/2022 10:09:00', 103),'massa non ante bibendum ullamcorper. Duis cursus, diam at pretium',142);
INSERT INTO CANCELACION_RESERVA VALUES (10,CONVERT(DATETIME, '11/06/2022 14:59:02', 103),'fringilla ornare placerat, orci lacus vestibulum',143);
INSERT INTO CANCELACION_RESERVA VALUES (11,CONVERT(DATETIME, '12/06/2022 08:54:41', 103),'imperdiet dictum magna. Ut tincidunt orci quis',145);
INSERT INTO CANCELACION_RESERVA VALUES (12,CONVERT(DATETIME, '14/06/2022 05:18:59', 103),'vitae purus gravida sagittis. Duis',163);
INSERT INTO CANCELACION_RESERVA VALUES (13,CONVERT(DATETIME, '15/06/2022 05:58:34', 103),'auctor ullamcorper, nisl arcu iaculis enim, sit amet',173);
INSERT INTO CANCELACION_RESERVA VALUES (14,CONVERT(DATETIME, '21/06/2022 21:59:33', 103),'felis eget varius ultrices, mauris ipsum',181);
INSERT INTO CANCELACION_RESERVA VALUES (15,CONVERT(DATETIME, '21/06/2022 10:24:11', 103),'posuere, enim nisl elementum purus, accumsan',189);
INSERT INTO CANCELACION_RESERVA VALUES (16,CONVERT(DATETIME, '22/06/2022 05:23:51', 103),'neque pellentesque massa lobortis ultrices. Vivamus rhoncus. Donec',198);

INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(2,2);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(2,9);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(2,6);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(3,3);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(6,4);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(6,6);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(7,2);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(8,1);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(8,10);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(8,3);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(8,4);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(8,7);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(8,9);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(9,6);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(9,5);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(11,9);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(12,5);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(12,8);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(13,6);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(13,4);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(16,1);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(16,3);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(16,7);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(17,4);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(17,9);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(17,10);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(18,5);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(18,3);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(18,6);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(18,4);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(19,9);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(20,9);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(21,3);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(21,5);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(22,2);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(22,9);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(23,8);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(25,5);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(25,6);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(26,9);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(26,2);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(28,9);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(28,8);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(29,5);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(29,6);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(31,6);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(31,1);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(31,9);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(32,2);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(32,5);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(33,3);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(33,5);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(33,7);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(34,4);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(35,5);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(35,6);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(36,1);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(36,5);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(36,4);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(37,3);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(37,6);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(38,2);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(39,1);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(42,4);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(42,8);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(43,2);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(44,8);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(45,10);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(45,7);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(45,6);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(47,10);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(47,1);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(48,9);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(49,2);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(49,6);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(52,7);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(53,9);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(53,10);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(54,9);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(54,10);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(55,8);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(55,9);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(55,4);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(55,7);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(55,10);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(56,8);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(58,7);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(58,5);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(59,2);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(59,10);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(60,2);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(60,7);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(61,7);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(61,1);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(61,3);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(62,10);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(62,3);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(63,7);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(64,2);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(65,2);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(65,6);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(65,7);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(66,1);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(67,2);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(67,1);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(67,7);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(69,4);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(69,10);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(69,3);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(70,5);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(70,2);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(72,4);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(73,1);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(73,9);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(76,5);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(76,1);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(77,2);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(79,8);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(79,3);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(80,1);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(80,8);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(82,7);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(84,7);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(85,9);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(85,5);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(86,3);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(86,1);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(87,7);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(89,10);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(89,9);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(90,1);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(92,9);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(92,8);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(93,10);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(94,3);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(97,1);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(98,4);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(98,6);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(98,7);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(99,8);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(101,5);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(101,3);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(103,9);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(103,3);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(104,2);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(105,7);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(106,2);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(108,9);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(111,1);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(112,5);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(113,10);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(114,7);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(114,2);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(115,3);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(116,6);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(116,7);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(116,10);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(117,7);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(118,3);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(119,10);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(120,6);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(120,2);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(120,10);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(121,6);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(121,4);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(122,1);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(123,6);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(123,7);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(124,5);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(124,3);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(125,10);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(126,5);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(128,6);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(132,7);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(133,8);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(133,9);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(134,9);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(134,10);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(136,9);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(137,3);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(138,9);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(138,3);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(139,8);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(140,1);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(140,8);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(141,5);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(141,10);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(142,10);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(143,6);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(143,3);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(143,7);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(143,1);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(144,7);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(144,3);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(144,4);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(145,5);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(145,7);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(146,6);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(146,9);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(147,8);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(148,5);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(148,4);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(148,2);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(148,3);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(150,6);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(150,10);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(151,7);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(151,4);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(151,8);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(152,10);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(154,10);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(154,5);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(154,9);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(155,8);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(155,3);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(156,5);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(157,4);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(157,8);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(158,6);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(158,9);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(158,5);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(160,5);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(160,2);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(160,6);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(161,3);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(161,6);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(161,4);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(163,2);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(164,10);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(165,10);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(166,6);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(167,4);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(167,10);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(169,4);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(169,5);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(169,7);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(170,8);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(170,5);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(170,6);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(172,5);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(174,4);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(175,7);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(176,6);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(180,4);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(181,2);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(181,4);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(181,7);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(181,3);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(181,5);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(183,1);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(183,6);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(184,1);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(185,8);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(185,6);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(186,9);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(188,5);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(189,6);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(189,7);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(191,10);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(191,6);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(192,8);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(193,7);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(193,10);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(194,3);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(194,9);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(194,4);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(194,10);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(195,1);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(197,2);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(198,6);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(198,9);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(198,4);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(198,1);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(198,8);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(198,7);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(198,5);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(199,3);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(199,4);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(199,10);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(199,8);
INSERT INTO EXTRA (id_reserva, id_servicio) VALUES(200,9);

INSERT INTO COMENTARIO VALUES (1,31,2,CONVERT(DATE,'01/05/2022',103),'interdum feugiat. Sed nec metus facilisis lorem tristique',5);
INSERT INTO COMENTARIO VALUES (2,5,13,CONVERT(DATE,'02/05/2022',103),'sit amet, consectetuer adipiscing',4);
INSERT INTO COMENTARIO VALUES (3,22,14,CONVERT(DATE,'08/05/2022',103),'In mi pede, nonummy ut,',4);
INSERT INTO COMENTARIO VALUES (4,33,2,CONVERT(DATE,'08/05/2022',103),'Nulla semper tellus id nunc interdum feugiat.',5);
INSERT INTO COMENTARIO VALUES (5,31,11,CONVERT(DATE,'08/05/2022',103),'enim diam vel arcu. Curabitur',3);
INSERT INTO COMENTARIO VALUES (6,30,2,CONVERT(DATE,'08/05/2022',103),'nisi. Cum sociis natoque penatibus et',5);
INSERT INTO COMENTARIO VALUES (7,46,2,CONVERT(DATE,'09/05/2022',103),'aliquam eu, accumsan sed, facilisis vitae, orci. Phasellus',5);
INSERT INTO COMENTARIO VALUES (8,4,2,CONVERT(DATE,'10/05/2022',103),'nulla magna, malesuada vel, convallis',5);
INSERT INTO COMENTARIO VALUES (9,26,10,CONVERT(DATE,'19/05/2022',103),'vulputate, posuere vulputate, lacus. Cras interdum. Nunc sollicitudin commodo',5);
INSERT INTO COMENTARIO VALUES (10,35,7,CONVERT(DATE,'21/05/2022',103),'aliquet lobortis, nisi nibh',4);
INSERT INTO COMENTARIO VALUES (11,1,13,CONVERT(DATE,'22/05/2022',103),'scelerisque neque. Nullam nisl. Maecenas malesuada fringilla est.',3);
INSERT INTO COMENTARIO VALUES (12,38,11,CONVERT(DATE,'23/05/2022',103),'malesuada fames ac turpis egestas. Aliquam fringilla',5);
INSERT INTO COMENTARIO VALUES (13,2,13,CONVERT(DATE,'23/05/2022',103),'ipsum non arcu. Vivamus sit amet risus. Donec',4);
INSERT INTO COMENTARIO VALUES (14,48,1,CONVERT(DATE,'26/05/2022',103),'arcu. Aliquam ultrices iaculis odio. Nam interdum',4);
INSERT INTO COMENTARIO VALUES (15,7,8,CONVERT(DATE,'27/05/2022',103),'cursus. Nunc mauris elit, dictum eu, eleifend nec,',1);
INSERT INTO COMENTARIO VALUES (16,47,9,CONVERT(DATE,'29/05/2022',103),'ante, iaculis nec, eleifend non, dapibus',5);
INSERT INTO COMENTARIO VALUES (17,13,5,CONVERT(DATE,'30/05/2022',103),'Morbi metus. Vivamus euismod urna.',5);
INSERT INTO COMENTARIO VALUES (18,15,12,CONVERT(DATE,'30/05/2022',103),'ac tellus. Suspendisse sed dolor.',1);
INSERT INTO COMENTARIO VALUES (19,46,13,CONVERT(DATE,'31/05/2022',103),'gravida nunc sed pede. Cum',4);
INSERT INTO COMENTARIO VALUES (20,43,10,CONVERT(DATE,'31/05/2022',103),'nisl sem, consequat nec,',4);
INSERT INTO COMENTARIO VALUES (21,18,13,CONVERT(DATE,'02/06/2022',103),'justo sit amet nulla. Donec non',5);
INSERT INTO COMENTARIO VALUES (22,10,13,CONVERT(DATE,'03/06/2022',103),'tellus sem mollis dui, in sodales elit erat vitae',4);
INSERT INTO COMENTARIO VALUES (23,41,6,CONVERT(DATE,'04/06/2022',103),'at pretium aliquet, metus urna',4);
INSERT INTO COMENTARIO VALUES (24,46,3,CONVERT(DATE,'04/06/2022',103),'sagittis placerat. Cras dictum ultricies ligula.',4);
INSERT INTO COMENTARIO VALUES (25,25,3,CONVERT(DATE,'04/06/2022',103),'Nulla facilisis. Suspendisse commodo tincidunt nibh. Phasellus',3);
INSERT INTO COMENTARIO VALUES (26,5,5,CONVERT(DATE,'05/06/2022',103),'mauris blandit mattis. Cras eget nisi dictum augue malesuada',4);
INSERT INTO COMENTARIO VALUES (27,20,4,CONVERT(DATE,'05/06/2022',103),'sit amet, consectetuer adipiscing elit. Aliquam auctor, velit',4);
INSERT INTO COMENTARIO VALUES (28,10,10,CONVERT(DATE,'05/06/2022',103),'sagittis felis. Donec tempor,',4);
INSERT INTO COMENTARIO VALUES (29,7,5,CONVERT(DATE,'06/06/2022',103),'sed dictum eleifend, nunc risus varius',5);
INSERT INTO COMENTARIO VALUES (30,32,3,CONVERT(DATE,'09/06/2022',103),'Quisque varius. Nam porttitor scelerisque neque. Nullam nisl.',5);
INSERT INTO COMENTARIO VALUES (31,21,7,CONVERT(DATE,'11/06/2022',103),'sapien. Cras dolor dolor,',4);
INSERT INTO COMENTARIO VALUES (32,5,1,CONVERT(DATE,'16/06/2022',103),'pede et risus. Quisque libero lacus,',5);
INSERT INTO COMENTARIO VALUES (33,47,4,CONVERT(DATE,'16/06/2022',103),'neque tellus, imperdiet non, vestibulum nec,',4);
INSERT INTO COMENTARIO VALUES (34,9,10,CONVERT(DATE,'18/06/2022',103),'magna nec quam. Curabitur vel lectus. Cum',4);
INSERT INTO COMENTARIO VALUES (35,22,12,CONVERT(DATE,'19/06/2022',103),'eleifend nec, malesuada ut, sem. Nulla',4);
INSERT INTO COMENTARIO VALUES (36,8,15,CONVERT(DATE,'19/06/2022',103),'at auctor ullamcorper, nisl arcu',5);
INSERT INTO COMENTARIO VALUES (37,18,4,CONVERT(DATE,'20/06/2022',103),'at, iaculis quis, pede. Praesent eu dui. Cum',4);
INSERT INTO COMENTARIO VALUES (38,6,11,CONVERT(DATE,'20/06/2022',103),'dictum. Phasellus in felis. Nulla tempor augue ac',4);
INSERT INTO COMENTARIO VALUES (39,38,15,CONVERT(DATE,'21/06/2022',103),'aliquam eu, accumsan sed, facilisis',4);
INSERT INTO COMENTARIO VALUES (40,30,12,CONVERT(DATE,'21/06/2022',103),'fames ac turpis egestas.',2);
INSERT INTO COMENTARIO VALUES (41,20,2,CONVERT(DATE,'24/06/2022',103),'morbi tristique senectus et netus',3);
INSERT INTO COMENTARIO VALUES (42,39,14,CONVERT(DATE,'24/06/2022',103),'placerat. Cras dictum ultricies ligula. Nullam enim. Sed',4);
INSERT INTO COMENTARIO VALUES (43,30,8,CONVERT(DATE,'25/06/2022',103),'blandit mattis. Cras eget nisi dictum augue',5);
INSERT INTO COMENTARIO VALUES (44,16,13,CONVERT(DATE,'27/06/2022',103),'risus. Duis a mi fringilla mi lacinia',4);
INSERT INTO COMENTARIO VALUES (45,47,5,CONVERT(DATE,'28/06/2022',103),'dignissim tempor arcu. Vestibulum ut',4);
INSERT INTO COMENTARIO VALUES (46,22,7,CONVERT(DATE,'28/06/2022',103),'non lorem vitae odio sagittis semper. Nam tempor',5);
INSERT INTO COMENTARIO VALUES (47,47,11,CONVERT(DATE,'29/06/2022',103),'in faucibus orci luctus et ultrices posuere',5);
INSERT INTO COMENTARIO VALUES (48,33,13,CONVERT(DATE,'01/07/2022',103),'tristique ac, eleifend vitae,',4);
INSERT INTO COMENTARIO VALUES (49,25,6,CONVERT(DATE,'01/07/2022',103),'quam dignissim pharetra. Nam ac nulla. In',1);
INSERT INTO COMENTARIO VALUES (50,9,10,CONVERT(DATE,'01/07/2022',103),'consequat enim diam vel arcu. Curabitur ut',5);

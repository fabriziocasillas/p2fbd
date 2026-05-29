-- =============================================================
-- Proyecto: Farmacia de otro mundo
-- Equipo: Añañines
-- Fundamentos de Bases de Datos, Facultad de Ciencias, UNAM 2026-II
-- =============================================================
-- Creación del esquema

DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;

-------------TABLAS CON LLAVES PRIMARIAS-----------------
--Cliente
CREATE TABLE Cliente (
    id_cliente INT,
    nombre VARCHAR(50),
    apellido_paterno VARCHAR(50),
    apellido_materno VARCHAR(50),
    fecha_nacimiento DATE,
    metodo_pago VARCHAR(30),
    calle VARCHAR(100),
    num_int VARCHAR(10),
    num_ext VARCHAR(10),
    colonia VARCHAR(50),
    usuario VARCHAR(50),
    contrasenia VARCHAR(50),
    numero_tarjeta VARCHAR(20),
    fecha_vencimiento DATE,
    esClienteOnline BOOLEAN,
    esClienteFisico BOOLEAN
);

COMMENT ON TABLE Cliente IS 'Tabla que almacena la informacion de los clientes del sistema';

COMMENT ON COLUMN Cliente.id_cliente IS 'Identificador unico del cliente';
COMMENT ON COLUMN Cliente.nombre IS 'Nombre del cliente';
COMMENT ON COLUMN Cliente.apellido_paterno IS 'Apellido paterno del cliente';
COMMENT ON COLUMN Cliente.apellido_materno IS 'Apellido materno del cliente';
COMMENT ON COLUMN Cliente.fecha_nacimiento IS 'Fecha de nacimiento del cliente';
COMMENT ON COLUMN Cliente.metodo_pago IS 'Metodo de pago preferido del cliente';
COMMENT ON COLUMN Cliente.calle IS 'Calle de la direccion del cliente';
COMMENT ON COLUMN Cliente.num_int IS 'Numero interior del domicilio';
COMMENT ON COLUMN Cliente.num_ext IS 'Numero exterior del domicilio';
COMMENT ON COLUMN Cliente.colonia IS 'Colonia del domicilio';
COMMENT ON COLUMN Cliente.usuario IS 'Nombre de usuario para acceso al sistema';
COMMENT ON COLUMN Cliente.contrasenia IS 'Contrasenia del usuario';
COMMENT ON COLUMN Cliente.numero_tarjeta IS 'Numero de tarjeta bancaria del cliente';
COMMENT ON COLUMN Cliente.fecha_vencimiento IS 'Fecha de vencimiento de la tarjeta';
COMMENT ON COLUMN Cliente.esClienteOnline IS 'Indica si el cliente es de tipo online';
COMMENT ON COLUMN Cliente.esClienteFisico IS 'Indica si el cliente es de tipo fisico';

 --Restricciones Cliente
ALTER TABLE Cliente ADD CONSTRAINT cliente_d1
CHECK(nombre <> '');
ALTER TABLE Cliente ADD CONSTRAINT cliente_d2
CHECK(apellido_paterno <> '');
ALTER TABLE Cliente ADD CONSTRAINT cliente_d3
CHECK(apellido_materno <> '');
ALTER TABLE Cliente ADD CONSTRAINT cliente_d4
CHECK(calle <> '');
ALTER TABLE Cliente ADD CONSTRAINT cliente_d5
CHECK(colonia <> '');
ALTER TABLE Cliente ADD CONSTRAINT cliente_d6
CHECK(usuario <> '');
ALTER TABLE Cliente ADD CONSTRAINT cliente_d7
CHECK(contrasenia <> '');
ALTER TABLE Cliente ADD CONSTRAINT cliente_d8
CHECK(numero_tarjeta IS NULL OR CHAR_LENGTH(numero_tarjeta) >= 16);
ALTER TABLE Cliente ADD CONSTRAINT cliente_d9
CHECK(esClienteOnline = TRUE OR esClienteFisico = TRUE);
ALTER TABLE Cliente ADD CONSTRAINT cliente_d10
CHECK(
    metodo_pago <> 'tarjeta' OR 
    (numero_tarjeta IS NOT NULL AND fecha_vencimiento IS NOT NULL)
);
ALTER TABLE Cliente ALTER COLUMN nombre SET NOT NULL;
ALTER TABLE Cliente ALTER COLUMN apellido_paterno SET NOT NULL;
ALTER TABLE Cliente ALTER COLUMN usuario SET NOT NULL;
ALTER TABLE Cliente ALTER COLUMN contrasenia SET NOT NULL;
ALTER TABLE Cliente ADD CONSTRAINT cliente_d11
CHECK(fecha_nacimiento < CURRENT_DATE);
ALTER TABLE Cliente ADD CONSTRAINT cliente_d12 
CHECK(num_ext IS NULL OR num_ext <> '');
ALTER TABLE Cliente ADD CONSTRAINT cliente_d13
CHECK(num_int IS NULL OR num_int <> '');

COMMENT ON CONSTRAINT cliente_d1 ON Cliente IS 'Valida que el nombre no sea vacio';
COMMENT ON CONSTRAINT cliente_d2 ON Cliente IS 'Valida que el apellido paterno no sea vacio';
COMMENT ON CONSTRAINT cliente_d3 ON Cliente IS 'Valida que el apellido materno no sea vacio';
COMMENT ON CONSTRAINT cliente_d4 ON Cliente IS 'Valida que la calle no sea vacia';
COMMENT ON CONSTRAINT cliente_d5 ON Cliente IS 'Valida que la colonia no sea vacia';
COMMENT ON CONSTRAINT cliente_d6 ON Cliente IS 'Valida que el usuario no sea vacio';
COMMENT ON CONSTRAINT cliente_d7 ON Cliente IS 'Valida que la contrasenia no sea vacia';
COMMENT ON CONSTRAINT cliente_d8 ON Cliente IS 'Valida que el numero de tarjeta tenga al menos 16 digitos si existe';
COMMENT ON CONSTRAINT cliente_d9 ON Cliente IS 'Valida que el cliente sea online o fisico';
COMMENT ON CONSTRAINT cliente_d10 ON Cliente IS 'Si el metodo de pago es tarjeta, se requieren datos de tarjeta';
COMMENT ON CONSTRAINT cliente_d11 ON Cliente IS 'Valida que la fecha de nacimiento sea anterior a la actual';
COMMENT ON CONSTRAINT cliente_d12 ON Cliente IS 'Valida que el numero exterior no sea vacio si existe';
COMMENT ON CONSTRAINT cliente_d13 ON Cliente IS 'Valida que el numero interior no sea vacio si existe';

--Pk CLiente
ALTER TABLE Cliente ADD CONSTRAINT cliente_pkey
PRIMARY KEY (id_cliente);

COMMENT ON CONSTRAINT cliente_pkey ON Cliente IS 'Llave primaria de la tabla Cliente';

--TelefonoCliente(multivaluado)
CREATE TABLE TelefonoCliente(
    id_cliente INT,
    telefono VARCHAR(15)
);

COMMENT ON TABLE TelefonoCliente IS 'Tabla multivaluada que almacena los telefonos de cada cliente';

COMMENT ON COLUMN TelefonoCliente.id_cliente IS 'Identificador del cliente asociado';
COMMENT ON COLUMN TelefonoCliente.telefono IS 'Numero de telefono del cliente';

-- Politica de mantenimiento para TelefonoCliente
ALTER TABLE TelefonoCliente ADD CONSTRAINT telefono_cliente_fkey
FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
ON DELETE CASCADE
ON UPDATE CASCADE;

COMMENT ON CONSTRAINT telefono_cliente_fkey ON TelefonoCliente IS 
'Llave foranea hacia Cliente. Si el cliente se elimina o su ID se actualiza, los teléfonos se eliminan o actualizan respectivamente';

--Pk TC
ALTER TABLE TelefonoCliente ADD CONSTRAINT telefono_cliente_pkey
PRIMARY KEY (id_cliente, telefono);

COMMENT ON CONSTRAINT telefono_cliente_pkey ON TelefonoCliente IS 'Llave primaria compuesta por id_cliente y telefono';

--Dominio TC
ALTER TABLE TelefonoCliente ADD CONSTRAINT telefono_cliente_d1
CHECK(telefono <> '');


COMMENT ON CONSTRAINT telefono_cliente_d1 ON TelefonoCliente IS 'Valida que el telefono no sea vacio';

--CorreoCliente(multivaluado)
CREATE TABLE CorreoCliente(
    id_cliente INT,
    correo VARCHAR(100)
);

COMMENT ON TABLE CorreoCliente IS 'Tabla multivaluada que almacena los correos electronicos de cada cliente';

COMMENT ON COLUMN CorreoCliente.id_cliente IS 'Identificador del cliente asociado';
COMMENT ON COLUMN CorreoCliente.correo IS 'Correo electronico del cliente';

--Pk CC
ALTER TABLE CorreoCliente ADD CONSTRAINT correo_cliente_pkey
PRIMARY KEY (id_cliente, correo);

COMMENT ON CONSTRAINT correo_cliente_pkey ON CorreoCliente IS 
'Llave primaria compuesta por id_cliente y correo';

--Politica 
ALTER TABLE CorreoCliente ADD CONSTRAINT correo_cliente_fkey
FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
ON DELETE CASCADE
ON UPDATE CASCADE;

COMMENT ON CONSTRAINT correo_cliente_fkey ON CorreoCliente IS 
'Llave foranea hacia Cliente. Si el cliente se elimina o su ID se actualiza, sus correos se eliminan o actualizan respectivamente';

--Dominio CC
ALTER TABLE CorreoCliente ADD CONSTRAINT correo_cliente_d1
CHECK(correo <> '');

COMMENT ON CONSTRAINT correo_cliente_d1 ON CorreoCliente IS 
'Valida que el correo no sea vacio';

--Sucursal
CREATE TABLE Sucursal(
    id_sucursal INT,
    nombre VARCHAR(100),
    encargado VARCHAR(100),
    telefono VARCHAR(15),
    calle VARCHAR(100),
    num_int VARCHAR(10),
    num_ext VARCHAR(10),
    colonia VARCHAR(50)
);

COMMENT ON TABLE Sucursal IS 'Tabla que almacena la informacion de las sucursales';

COMMENT ON COLUMN Sucursal.id_sucursal IS 'Identificador unico de la sucursal';
COMMENT ON COLUMN Sucursal.nombre IS 'Nombre de la sucursal';
COMMENT ON COLUMN Sucursal.encargado IS 'Nombre del encargado de la sucursal';
COMMENT ON COLUMN Sucursal.telefono IS 'Telefono de contacto de la sucursal';
COMMENT ON COLUMN Sucursal.calle IS 'Calle de la sucursal';
COMMENT ON COLUMN Sucursal.num_int IS 'Numero interior de la sucursal';
COMMENT ON COLUMN Sucursal.num_ext IS 'Numero exterior de la sucursal';
COMMENT ON COLUMN Sucursal.colonia IS 'Colonia donde se ubica la sucursal';

--Restricciones Sucursal
ALTER TABLE Sucursal ADD CONSTRAINT sucursal_d1
CHECK(nombre <> '');
ALTER TABLE Sucursal ADD CONSTRAINT sucursal_d2
CHECK(encargado <> '');
ALTER TABLE Sucursal ADD CONSTRAINT sucursal_d3
CHECK(telefono <> '');
ALTER TABLE Sucursal ADD CONSTRAINT sucursal_d4
CHECK(calle <> '');
ALTER TABLE Sucursal ADD CONSTRAINT sucursal_d5
CHECK(colonia <> '');
ALTER TABLE Sucursal ALTER COLUMN nombre SET NOT NULL;
ALTER TABLE Sucursal ALTER COLUMN encargado SET NOT NULL;
ALTER TABLE Sucursal ALTER COLUMN telefono SET NOT NULL;
ALTER TABLE Sucursal ADD CONSTRAINT sucursal_d6 
CHECK(num_ext IS NULL OR num_ext <> '');
ALTER TABLE Sucursal ADD CONSTRAINT sucursal_d7 
CHECK(num_int IS NULL OR num_int <> '');

COMMENT ON CONSTRAINT sucursal_d1 ON Sucursal IS 'Valida que el nombre no sea vacio';
COMMENT ON CONSTRAINT sucursal_d2 ON Sucursal IS 'Valida que el encargado no sea vacio';
COMMENT ON CONSTRAINT sucursal_d3 ON Sucursal IS 'Valida que el telefono no sea vacio';
COMMENT ON CONSTRAINT sucursal_d4 ON Sucursal IS 'Valida que la calle no sea vacia';
COMMENT ON CONSTRAINT sucursal_d5 ON Sucursal IS 'Valida que la colonia no sea vacia';
COMMENT ON CONSTRAINT sucursal_d6 ON Sucursal IS 'Valida que el numero exterior no sea vacio si existe';
COMMENT ON CONSTRAINT sucursal_d7 ON Sucursal IS 'Valida que el numero interior no sea vacio si existe';

--Pk Sucursal
ALTER TABLE Sucursal ADD CONSTRAINT sucursal_pkey
PRIMARY KEY (id_sucursal);

COMMENT ON CONSTRAINT sucursal_pkey ON Sucursal IS 'Llave primaria de la tabla Sucursal';

--HorarioSucursal(multivaluado)
CREATE TABLE HorarioSucursal(
    id_sucursal INT,
    horario VARCHAR(100)
);

COMMENT ON TABLE HorarioSucursal IS 'Tabla multivaluada que almacena los horarios de cada sucursal';
COMMENT ON COLUMN HorarioSucursal.id_sucursal IS 'Identificador de la sucursal asociada';
COMMENT ON COLUMN HorarioSucursal.horario IS 'Horario de atencion de la sucursal';

--Pk HS
ALTER TABLE HorarioSucursal ADD CONSTRAINT horario_sucursal_pkey
PRIMARY KEY (id_sucursal, horario);

COMMENT ON CONSTRAINT horario_sucursal_pkey ON HorarioSucursal IS 
'Llave primaria compuesta por id_sucursal y horario';

--Fk HS
ALTER TABLE HorarioSucursal ADD CONSTRAINT horario_sucursal_fkey
FOREIGN KEY (id_sucursal) REFERENCES Sucursal(id_sucursal)
ON DELETE CASCADE
ON UPDATE CASCADE;

COMMENT ON CONSTRAINT horario_sucursal_fkey ON HorarioSucursal IS 
'Llave foranea hacia Sucursal. Si la sucursal se elimina o su ID se actualiza, sus horarios se eliminan o actualizan respectivamente';

--Domino HS
ALTER TABLE HorarioSucursal ADD CONSTRAINT horario_sucursal_d1
CHECK(horario <> '');

COMMENT ON CONSTRAINT horario_sucursal_d1 ON HorarioSucursal IS 
'Valida que el horario no sea vacio';

--Medicamento
CREATE TABLE Medicamento(
    id_producto INT,
    nombre VARCHAR(100),
    nombre_generico VARCHAR(100),
    nombre_comercial VARCHAR(100),
    descripcion TEXT,
    laboratorio_fabricante VARCHAR(100),
    forma_farmaceutica VARCHAR(50),
    via_administracion VARCHAR(50),
    presentacion VARCHAR(50),
    potencia VARCHAR(50),
    esteril BOOLEAN,
    clasificacion VARCHAR(50),
    tipo_control VARCHAR(50),
    precio_publico NUMERIC(10,2),
    precio_unitario NUMERIC(10,2),
    fecha_recibimiento DATE,
    fecha_caducidad DATE,
    preparacion_oficial TEXT,
    preparacion_pediatrica TEXT,
    preparacion_dermatologica TEXT
);

COMMENT ON TABLE Medicamento IS 'Tabla que almacena la informacion de los medicamentos';
COMMENT ON COLUMN Medicamento.id_producto IS 'Identificador unico del medicamento';
COMMENT ON COLUMN Medicamento.nombre IS 'Nombre del medicamento';
COMMENT ON COLUMN Medicamento.nombre_generico IS 'Nombre generico del medicamento';
COMMENT ON COLUMN Medicamento.nombre_comercial IS 'Nombre comercial del medicamento';
COMMENT ON COLUMN Medicamento.descripcion IS 'Descripcion del medicamento';
COMMENT ON COLUMN Medicamento.laboratorio_fabricante IS 'Laboratorio fabricante del medicamento';
COMMENT ON COLUMN Medicamento.forma_farmaceutica IS 'Forma farmaceutica (tableta, jarabe, etc.)';
COMMENT ON COLUMN Medicamento.via_administracion IS 'Via de administracion (oral, intravenosa, etc.)';
COMMENT ON COLUMN Medicamento.presentacion IS 'Presentacion del medicamento';
COMMENT ON COLUMN Medicamento.potencia IS 'Potencia del medicamento';
COMMENT ON COLUMN Medicamento.esteril IS 'Indica si el medicamento es esteril';
COMMENT ON COLUMN Medicamento.clasificacion IS 'Clasificacion del medicamento';
COMMENT ON COLUMN Medicamento.tipo_control IS 'Tipo de control del medicamento';
COMMENT ON COLUMN Medicamento.precio_publico IS 'Precio publico del medicamento';
COMMENT ON COLUMN Medicamento.precio_unitario IS 'Precio unitario del medicamento';
COMMENT ON COLUMN Medicamento.fecha_recibimiento IS 'Fecha de recibimiento del medicamento';
COMMENT ON COLUMN Medicamento.fecha_caducidad IS 'Fecha de caducidad del medicamento';
COMMENT ON COLUMN Medicamento.preparacion_oficial IS 'Preparacion oficial del medicamento';
COMMENT ON COLUMN Medicamento.preparacion_pediatrica IS 'Preparacion pediatrica del medicamento';
COMMENT ON COLUMN Medicamento.preparacion_dermatologica IS 'Preparacion dermatologica del medicamento';

--Restricciones Medicamento
ALTER TABLE Medicamento ADD CONSTRAINT medicamento_d1
CHECK(nombre <> '');
ALTER TABLE Medicamento ADD CONSTRAINT medicamento_d2
CHECK(nombre_generico <> '');
ALTER TABLE Medicamento ADD CONSTRAINT medicamento_d3
CHECK(nombre_comercial <> '');
ALTER TABLE Medicamento ADD CONSTRAINT medicamento_d4
CHECK(laboratorio_fabricante <> '');
ALTER TABLE Medicamento ADD CONSTRAINT medicamento_d5
CHECK(forma_farmaceutica <> '');
ALTER TABLE Medicamento ADD CONSTRAINT medicamento_d6
CHECK(via_administracion <> '');
ALTER TABLE Medicamento ALTER COLUMN nombre SET NOT NULL;
ALTER TABLE Medicamento ALTER COLUMN nombre_generico SET NOT NULL;
ALTER TABLE Medicamento ALTER COLUMN precio_publico SET NOT NULL;
ALTER TABLE Medicamento ADD CONSTRAINT medicamento_d7
CHECK(precio_publico >= 0 AND precio_unitario >= 0);
ALTER TABLE Medicamento ADD CONSTRAINT medicamento_d8
CHECK(fecha_caducidad IS NULL OR fecha_caducidad > fecha_recibimiento);
ALTER TABLE Medicamento ADD CONSTRAINT medicamento_d9 
CHECK(clasificacion <> '');
ALTER TABLE Medicamento ADD CONSTRAINT medicamento_d10 
CHECK(descripcion IS NULL OR descripcion <> '');
ALTER TABLE Medicamento ADD CONSTRAINT medicamento_d11 
CHECK(esteril IS NOT NULL);
ALTER TABLE Medicamento ADD CONSTRAINT medicamento_d12 
CHECK(potencia <> '');
ALTER TABLE Medicamento ADD CONSTRAINT medicamento_d13 
CHECK(preparacion_dermatologica IS NULL OR preparacion_dermatologica <> '');
ALTER TABLE Medicamento ADD CONSTRAINT medicamento_d14 
CHECK(preparacion_oficial IS NULL OR preparacion_oficial <> '');
ALTER TABLE Medicamento ADD CONSTRAINT medicamento_d15 
CHECK(preparacion_pediatrica IS NULL OR preparacion_pediatrica <> '');
ALTER TABLE Medicamento ADD CONSTRAINT medicamento_d16 
CHECK(presentacion <> '');
ALTER TABLE Medicamento ADD CONSTRAINT medicamento_d17 
CHECK(tipo_control <> '');

COMMENT ON CONSTRAINT medicamento_d1 ON Medicamento IS 'Valida que el nombre no sea vacio';
COMMENT ON CONSTRAINT medicamento_d2 ON Medicamento IS 'Valida que el nombre generico no sea vacio';
COMMENT ON CONSTRAINT medicamento_d3 ON Medicamento IS 'Valida que el nombre comercial no sea vacio';
COMMENT ON CONSTRAINT medicamento_d4 ON Medicamento IS 'Valida que el laboratorio fabricante no sea vacio';
COMMENT ON CONSTRAINT medicamento_d5 ON Medicamento IS 'Valida que la forma farmaceutica no sea vacia';
COMMENT ON CONSTRAINT medicamento_d6 ON Medicamento IS 'Valida que la via de administracion no sea vacia';
COMMENT ON CONSTRAINT medicamento_d7 ON Medicamento IS 'Valida que los precios sean mayores o iguales a 0';
COMMENT ON CONSTRAINT medicamento_d8 ON Medicamento IS 'Valida que la fecha de caducidad sea posterior a la fecha de recibimiento';
COMMENT ON CONSTRAINT medicamento_d9 ON Medicamento IS 'Valida que la clasificacion no sea vacia';
COMMENT ON CONSTRAINT medicamento_d10 ON Medicamento IS 'Valida que la descripcion no sea vacia si existe';
COMMENT ON CONSTRAINT medicamento_d11 ON Medicamento IS 'Valida que el campo esteril no sea nulo';
COMMENT ON CONSTRAINT medicamento_d12 ON Medicamento IS 'Valida que la potencia no sea vacia';
COMMENT ON CONSTRAINT medicamento_d13 ON Medicamento IS 'Valida que la preparacion dermatologica no sea vacia si existe';
COMMENT ON CONSTRAINT medicamento_d14 ON Medicamento IS 'Valida que la preparacion oficial no sea vacia si existe';
COMMENT ON CONSTRAINT medicamento_d15 ON Medicamento IS 'Valida que la preparacion pediatrica no sea vacia si existe';
COMMENT ON CONSTRAINT medicamento_d16 ON Medicamento IS 'Valida que la presentacion no sea vacia';
COMMENT ON CONSTRAINT medicamento_d17 ON Medicamento IS 'Valida que el tipo de control no sea vacio';

--Pk Medicamento
ALTER TABLE Medicamento ADD CONSTRAINT medicamento_pkey
PRIMARY KEY (id_producto);

COMMENT ON CONSTRAINT medicamento_pkey ON Medicamento IS 'Llave primaria de la tabla Medicamento';

--CondAlmMed(multivaluado)
CREATE TABLE CondicionAlmacenamientoMedicamento(
    id_producto INT,
    condicion VARCHAR(100)
);

COMMENT ON TABLE CondicionAlmacenamientoMedicamento IS 'Tabla multivaluada que almacena las condiciones de almacenamiento de cada medicamento';
COMMENT ON COLUMN CondicionAlmacenamientoMedicamento.id_producto IS 'Identificador del medicamento asociado';
COMMENT ON COLUMN CondicionAlmacenamientoMedicamento.condicion IS 'Condicion de almacenamiento del medicamento';

--Pk CondAlmMed
ALTER TABLE CondicionAlmacenamientoMedicamento 
ADD CONSTRAINT cond_med_pkey
PRIMARY KEY (id_producto, condicion);

COMMENT ON CONSTRAINT cond_med_pkey ON CondicionAlmacenamientoMedicamento IS 
'Llave primaria compuesta por id_producto y condicion';

-- FK CondAlmMed (con politica de mantenimiento)
ALTER TABLE CondicionAlmacenamientoMedicamento 
ADD CONSTRAINT cond_med_fkey
FOREIGN KEY (id_producto) REFERENCES Medicamento(id_producto)
ON DELETE CASCADE
ON UPDATE CASCADE;

COMMENT ON CONSTRAINT cond_med_fkey ON CondicionAlmacenamientoMedicamento IS 
'Llave foranea hacia Medicamento. Si el medicamento se elimina o su ID se actualiza, sus condiciones de almacenamiento se eliminan o actualizann';

--Dominio CondALMed
ALTER TABLE CondicionAlmacenamientoMedicamento 
ADD CONSTRAINT cond_med_d1
CHECK(condicion <> '');

COMMENT ON CONSTRAINT cond_med_d1 ON CondicionAlmacenamientoMedicamento IS 
'Valida que la condicion de almacenamiento no sea vacia';


--Insumo
CREATE TABLE Insumo(
    id_producto INT,
    nombre VARCHAR(100),
    nombre_generico VARCHAR(100),
    nombre_comercial VARCHAR(100),
    descripcion TEXT,
    laboratorio_fabricante VARCHAR(100),
    forma_farmaceutica VARCHAR(50),
    via_administracion VARCHAR(50),
    presentacion VARCHAR(50),
    potencia VARCHAR(50),
    esteril BOOLEAN,
    clasificacion VARCHAR(50),
    tipo_control VARCHAR(50),
    precio_publico NUMERIC(10,2),
    precio_unitario NUMERIC(10,2),
    fecha_recibimiento DATE,
    fecha_caducidad DATE,
    observaciones TEXT,
    sensibilidad VARCHAR(100),
    riesgo VARCHAR(50),
    tipo_insumo VARCHAR(50),
    forma_fisica VARCHAR(50),
    nombre_cientifico VARCHAR(100),
    grado_farmacopeico VARCHAR(50)
);

COMMENT ON TABLE Insumo IS 'Tabla que almacena la informacion de los insumos';
COMMENT ON COLUMN Insumo.id_producto IS 'Identificador unico del insumo';
COMMENT ON COLUMN Insumo.nombre IS 'Nombre del insumo';
COMMENT ON COLUMN Insumo.nombre_generico IS 'Nombre generico del insumo';
COMMENT ON COLUMN Insumo.nombre_comercial IS 'Nombre comercial del insumo';
COMMENT ON COLUMN Insumo.descripcion IS 'Descripcion del insumo';
COMMENT ON COLUMN Insumo.laboratorio_fabricante IS 'Laboratorio fabricante del insumo';
COMMENT ON COLUMN Insumo.forma_farmaceutica IS 'Forma farmaceutica del insumo';
COMMENT ON COLUMN Insumo.via_administracion IS 'Via de administracion del insumo';
COMMENT ON COLUMN Insumo.presentacion IS 'Presentacion del insumo';
COMMENT ON COLUMN Insumo.potencia IS 'Potencia del insumo';
COMMENT ON COLUMN Insumo.esteril IS 'Indica si el insumo es esteril';
COMMENT ON COLUMN Insumo.clasificacion IS 'Clasificacion del insumo';
COMMENT ON COLUMN Insumo.tipo_control IS 'Tipo de control del insumo';
COMMENT ON COLUMN Insumo.precio_publico IS 'Precio publico del insumo';
COMMENT ON COLUMN Insumo.precio_unitario IS 'Precio unitario del insumo';
COMMENT ON COLUMN Insumo.fecha_recibimiento IS 'Fecha de recibimiento del insumo';
COMMENT ON COLUMN Insumo.fecha_caducidad IS 'Fecha de caducidad del insumo';
COMMENT ON COLUMN Insumo.observaciones IS 'Observaciones del insumo';
COMMENT ON COLUMN Insumo.sensibilidad IS 'Sensibilidad del insumo';
COMMENT ON COLUMN Insumo.riesgo IS 'Nivel de riesgo del insumo';
COMMENT ON COLUMN Insumo.tipo_insumo IS 'Tipo de insumo';
COMMENT ON COLUMN Insumo.forma_fisica IS 'Forma fisica del insumo';
COMMENT ON COLUMN Insumo.nombre_cientifico IS 'Nombre cientifico del insumo';
COMMENT ON COLUMN Insumo.grado_farmacopeico IS 'Grado farmacopeico del insumo';

--Restricciones Insumo
ALTER TABLE Insumo ADD CONSTRAINT insumo_d1
CHECK(nombre <> '');
ALTER TABLE Insumo ADD CONSTRAINT insumo_d2
CHECK(nombre_generico <> '');
ALTER TABLE Insumo ADD CONSTRAINT insumo_d3
CHECK(nombre_comercial <> '');
ALTER TABLE Insumo ADD CONSTRAINT insumo_d4
CHECK(laboratorio_fabricante <> '');
ALTER TABLE Insumo ADD CONSTRAINT insumo_d5
CHECK(tipo_insumo <> '');
ALTER TABLE Insumo ADD CONSTRAINT insumo_d6
CHECK(forma_fisica <> '');
ALTER TABLE Insumo ALTER COLUMN nombre SET NOT NULL;
ALTER TABLE Insumo ALTER COLUMN nombre_generico SET NOT NULL;
ALTER TABLE Insumo ALTER COLUMN precio_publico SET NOT NULL;
ALTER TABLE Insumo ADD CONSTRAINT insumo_d7
CHECK(precio_publico >= 0 AND precio_unitario >= 0);
ALTER TABLE Insumo ADD CONSTRAINT insumo_d8
CHECK(fecha_caducidad IS NULL OR fecha_caducidad > fecha_recibimiento);
ALTER TABLE Insumo ADD CONSTRAINT insumo_d9 
CHECK(clasificacion <> '');
ALTER TABLE Insumo ADD CONSTRAINT insumo_d10 
CHECK(descripcion IS NULL OR descripcion <> '');
ALTER TABLE Insumo ADD CONSTRAINT insumo_d11 
CHECK(esteril IS NOT NULL);
ALTER TABLE Insumo ADD CONSTRAINT insumo_d12 
CHECK(forma_farmaceutica <> '');
ALTER TABLE Insumo ADD CONSTRAINT insumo_d13 
CHECK(grado_farmacopeico IS NULL OR grado_farmacopeico <> '');
ALTER TABLE Insumo ADD CONSTRAINT insumo_d14 
CHECK(nombre_cientifico IS NULL OR nombre_cientifico <> '');
ALTER TABLE Insumo ADD CONSTRAINT insumo_d15 
CHECK(observaciones IS NULL OR observaciones <> '');
ALTER TABLE Insumo ADD CONSTRAINT insumo_d16 
CHECK(potencia <> '');
ALTER TABLE Insumo ADD CONSTRAINT insumo_d17 
CHECK(presentacion <> '');
ALTER TABLE Insumo ADD CONSTRAINT insumo_d18 
CHECK(riesgo <> '');
ALTER TABLE Insumo ADD CONSTRAINT insumo_d19 
CHECK(sensibilidad <> '');
ALTER TABLE Insumo ADD CONSTRAINT insumo_d20 
CHECK(tipo_control <> '');
ALTER TABLE Insumo ADD CONSTRAINT insumo_d21 
CHECK(via_administracion <> '');

COMMENT ON CONSTRAINT insumo_d1 ON Insumo IS 'Valida que el nombre no sea vacio';
COMMENT ON CONSTRAINT insumo_d2 ON Insumo IS 'Valida que el nombre generico no sea vacio';
COMMENT ON CONSTRAINT insumo_d3 ON Insumo IS 'Valida que el nombre comercial no sea vacio';
COMMENT ON CONSTRAINT insumo_d4 ON Insumo IS 'Valida que el laboratorio fabricante no sea vacio';
COMMENT ON CONSTRAINT insumo_d5 ON Insumo IS 'Valida que el tipo de insumo no sea vacio';
COMMENT ON CONSTRAINT insumo_d6 ON Insumo IS 'Valida que la forma fisica no sea vacia';
COMMENT ON CONSTRAINT insumo_d7 ON Insumo IS 'Valida que los precios sean mayores o iguales a 0';
COMMENT ON CONSTRAINT insumo_d8 ON Insumo IS 'Valida que la fecha de caducidad sea posterior a la fecha de recibimiento';
COMMENT ON CONSTRAINT insumo_d9 ON Insumo IS 'Valida que la clasificacion no sea vacia';
COMMENT ON CONSTRAINT insumo_d10 ON Insumo IS 'Valida que la descripcion no sea vacia si existe';
COMMENT ON CONSTRAINT insumo_d11 ON Insumo IS 'Valida que el campo esteril no sea nulo';
COMMENT ON CONSTRAINT insumo_d12 ON Insumo IS 'Valida que la forma farmaceutica no sea vacia';
COMMENT ON CONSTRAINT insumo_d13 ON Insumo IS 'Valida que el grado farmacopeico no sea vacio si existe';
COMMENT ON CONSTRAINT insumo_d14 ON Insumo IS 'Valida que el nombre cientifico no sea vacio si existe';
COMMENT ON CONSTRAINT insumo_d15 ON Insumo IS 'Valida que las observaciones no sean vacias si existen';
COMMENT ON CONSTRAINT insumo_d16 ON Insumo IS 'Valida que la potencia no sea vacia';
COMMENT ON CONSTRAINT insumo_d17 ON Insumo IS 'Valida que la presentacion no sea vacia';
COMMENT ON CONSTRAINT insumo_d18 ON Insumo IS 'Valida que el riesgo no sea vacio';
COMMENT ON CONSTRAINT insumo_d19 ON Insumo IS 'Valida que la sensibilidad no sea vacia';
COMMENT ON CONSTRAINT insumo_d20 ON Insumo IS 'Valida que el tipo de control no sea vacio';
COMMENT ON CONSTRAINT insumo_d21 ON Insumo IS 'Valida que la via de administracion no sea vacia';

--Pk Insumo
ALTER TABLE Insumo ADD CONSTRAINT insumo_pkey
PRIMARY KEY (id_producto);

COMMENT ON CONSTRAINT insumo_pkey ON Insumo IS 'Llave primaria de la tabla Insumo';

--CondAlmIns(multivaluado)
CREATE TABLE CondicionAlmacenamientoInsumo(
    id_producto INT,
    condicion VARCHAR(100)
);

COMMENT ON TABLE CondicionAlmacenamientoInsumo IS 'Tabla multivaluada que almacena las condiciones de almacenamiento de cada insumo';
COMMENT ON COLUMN CondicionAlmacenamientoInsumo.id_producto IS 'Identificador del insumo asociado';
COMMENT ON COLUMN CondicionAlmacenamientoInsumo.condicion IS 'Condicion de almacenamiento del insumo';

--Pk CondAlmIns
ALTER TABLE CondicionAlmacenamientoInsumo 
ADD CONSTRAINT cond_insumo_pkey
PRIMARY KEY (id_producto, condicion);

COMMENT ON CONSTRAINT cond_insumo_pkey ON CondicionAlmacenamientoInsumo IS 
'Llave primaria compuesta por id_producto y condicion';

-- FK CondAlmIns (con politica de mantenimiento)
ALTER TABLE CondicionAlmacenamientoInsumo 
ADD CONSTRAINT cond_insumo_fkey
FOREIGN KEY (id_producto) REFERENCES Insumo(id_producto)
ON DELETE CASCADE
ON UPDATE CASCADE;

COMMENT ON CONSTRAINT cond_insumo_fkey ON CondicionAlmacenamientoInsumo IS 
'Llave foranea hacia Insumo. Si el insumo se elimina o su ID se actualiza, sus condiciones de almacenamiento se eliminan o actualizan respectivamente';

--Dominio CondAlmIns
ALTER TABLE CondicionAlmacenamientoInsumo 
ADD CONSTRAINT cond_insumo_d1
CHECK(condicion <> '');

COMMENT ON CONSTRAINT cond_insumo_d1 ON CondicionAlmacenamientoInsumo IS 
'Valida que la condicion de almacenamiento no sea vacia';

--Proveedor
CREATE TABLE Proveedor(
    numero_proveedor INT,
    razon_social VARCHAR(150),
    calle VARCHAR(100),
    num_int VARCHAR(10),
    num_ext VARCHAR(10),
    colonia VARCHAR(50)
);

COMMENT ON TABLE Proveedor IS 'Tabla que almacena la informacion de los proveedores';
COMMENT ON COLUMN Proveedor.numero_proveedor IS 'Numero unico que identifica al proveedor';
COMMENT ON COLUMN Proveedor.razon_social IS 'Razon social del proveedor';
COMMENT ON COLUMN Proveedor.calle IS 'Calle de la direccion del proveedor';
COMMENT ON COLUMN Proveedor.num_int IS 'Numero interior del domicilio del proveedor';
COMMENT ON COLUMN Proveedor.num_ext IS 'Numero exterior del domicilio del proveedor';
COMMENT ON COLUMN Proveedor.colonia IS 'Colonia del domicilio del proveedor';

--Restricciones Proveedor
ALTER TABLE Proveedor ADD CONSTRAINT proveedor_d1
CHECK(razon_social <> '');
ALTER TABLE Proveedor ADD CONSTRAINT proveedor_d2
CHECK(calle <> '');
ALTER TABLE Proveedor ADD CONSTRAINT proveedor_d3
CHECK(colonia <> '');
ALTER TABLE Proveedor ALTER COLUMN razon_social SET NOT NULL;
ALTER TABLE Proveedor ALTER COLUMN calle SET NOT NULL;
ALTER TABLE Proveedor ADD CONSTRAINT proveedor_d4 
CHECK(num_ext IS NULL OR num_ext <> '');
ALTER TABLE Proveedor ADD CONSTRAINT proveedor_d5 
CHECK(num_int IS NULL OR num_int <> '');

COMMENT ON CONSTRAINT proveedor_d1 ON Proveedor IS 'Valida que la razon social no sea vacia';
COMMENT ON CONSTRAINT proveedor_d2 ON Proveedor IS 'Valida que la calle no sea vacia';
COMMENT ON CONSTRAINT proveedor_d3 ON Proveedor IS 'Valida que la colonia no sea vacia';
COMMENT ON CONSTRAINT proveedor_d4 ON Proveedor IS 'Valida que el numero exterior no sea vacio si existe';
COMMENT ON CONSTRAINT proveedor_d5 ON Proveedor IS 'Valida que el numero interior no sea vacio si existe';

--Pk Proveedor
ALTER TABLE Proveedor ADD CONSTRAINT proveedor_pkey
PRIMARY KEY (numero_proveedor);

COMMENT ON CONSTRAINT proveedor_pkey ON Proveedor IS 'Llave primaria de la tabla Proveedor';

--TelefonoProveedor(multivaluado)
CREATE TABLE TelefonoProveedor(
    numero_proveedor INT,
    telefono VARCHAR(15)
);
COMMENT ON TABLE TelefonoProveedor IS 'Tabla multivaluada que almacena los telefonos de cada proveedor';
COMMENT ON COLUMN TelefonoProveedor.numero_proveedor IS 'Numero de proveedor asociado';
COMMENT ON COLUMN TelefonoProveedor.telefono IS 'Numero de telefono del proveedor';

--Pk TP
ALTER TABLE TelefonoProveedor 
ADD CONSTRAINT tel_proveedor_pkey
PRIMARY KEY (numero_proveedor, telefono);

COMMENT ON CONSTRAINT tel_proveedor_pkey ON TelefonoProveedor IS 
'Llave primaria compuesta por numero_proveedor y telefono';

-- FK TP (con politica de mantenimiento)
ALTER TABLE TelefonoProveedor 
ADD CONSTRAINT tel_proveedor_fkey
FOREIGN KEY (numero_proveedor) REFERENCES Proveedor(numero_proveedor)
ON DELETE CASCADE
ON UPDATE CASCADE;

COMMENT ON CONSTRAINT tel_proveedor_fkey ON TelefonoProveedor IS 
'Llave foranea hacia Proveedor. Si el proveedor se elimina o su numero se actualiza, sus telefonos se eliminan o actualizan respectivamente';

--Dominio TP
ALTER TABLE TelefonoProveedor 
ADD CONSTRAINT tel_proveedor_d1
CHECK(telefono <> '');

COMMENT ON CONSTRAINT tel_proveedor_d1 ON TelefonoProveedor IS 
'Valida que el telefono no sea vacio';

--Clinica
CREATE TABLE Clinica(
    id_clinica INT,
    id_sucursal INT,
    nombre_clinica VARCHAR(100),
    numero_cuartos INT
);

COMMENT ON TABLE Clinica IS 'Tabla que almacena la informacion de las clinicas';
COMMENT ON COLUMN Clinica.id_clinica IS 'Identificador unico de la clinica';
COMMENT ON COLUMN Clinica.id_sucursal IS 'Identificador de la sucursal a la que pertenece la clinica';
COMMENT ON COLUMN Clinica.nombre_clinica IS 'Nombre de la clinica';
COMMENT ON COLUMN Clinica.numero_cuartos IS 'Numero de cuartos de la clinica';

--Restricciones Clinica
ALTER TABLE Clinica ADD CONSTRAINT clinica_d1
CHECK(nombre_clinica <> '');
ALTER TABLE Clinica ADD CONSTRAINT clinica_d2
CHECK(numero_cuartos >= 0);
ALTER TABLE Clinica ALTER COLUMN nombre_clinica SET NOT NULL;
ALTER TABLE Clinica ALTER COLUMN id_sucursal SET NOT NULL;

COMMENT ON CONSTRAINT clinica_d1 ON Clinica IS 'Valida que el nombre de la clinica no sea vacio';
COMMENT ON CONSTRAINT clinica_d2 ON Clinica IS 'Valida que el numero de cuartos sea mayor o igual a 0';	

--Pk Clinica
ALTER TABLE Clinica ADD CONSTRAINT clinica_pkey
PRIMARY KEY (id_clinica);

COMMENT ON CONSTRAINT clinica_pkey ON Clinica IS 'Llave primaria de la tabla Clinica';

--fk Clinica (con politica)
ALTER TABLE Clinica ADD CONSTRAINT clinica_fkey
FOREIGN KEY (id_sucursal) REFERENCES Sucursal(id_sucursal)
ON DELETE RESTRICT
ON UPDATE RESTRICT;

COMMENT ON CONSTRAINT clinica_fkey ON Clinica IS 
'Llave foranea hacia Sucursal. No se permite eliminar o actualizar una sucursal si tiene clinicas asociadas (RESTRICT)';


--HorarioClinica(multivaluado)
CREATE TABLE HorarioClinica(
    id_clinica INT,
    horario VARCHAR(100)
);

COMMENT ON TABLE HorarioClinica IS 'Tabla multivaluada que almacena los horarios de cada clinica';
COMMENT ON COLUMN HorarioClinica.id_clinica IS 'Identificador de la clinica asociada';
COMMENT ON COLUMN HorarioClinica.horario IS 'Horario de atencion de la clinica';

--Pk HC
ALTER TABLE HorarioClinica 
ADD CONSTRAINT horario_clinica_pkey
PRIMARY KEY (id_clinica, horario);

COMMENT ON CONSTRAINT horario_clinica_pkey ON HorarioClinica IS 
'Llave primaria compuesta por id_clinica y horario';

--fk HorarioClinica hacia Clinica (con politica)
ALTER TABLE HorarioClinica 
ADD CONSTRAINT horario_clinica_fkey
FOREIGN KEY (id_clinica) REFERENCES Clinica(id_clinica)
ON DELETE CASCADE
ON UPDATE CASCADE;

COMMENT ON CONSTRAINT horario_clinica_fkey ON HorarioClinica IS 
'Llave foranea hacia Clinica. Si la clinica se elimina o su ID se actualiza, sus horarios se eliminan o actualizan respectivamente (CASCADE)';

--Dominio HC
ALTER TABLE HorarioClinica 
ADD CONSTRAINT horario_clinica_d1
CHECK(horario <> '');

COMMENT ON CONSTRAINT horario_clinica_d1 ON HorarioClinica IS 
'Valida que el horario no sea vacio';

--Personal
CREATE TABLE Personal(
    cedula_profesional VARCHAR(20),
    id_sucursal INT,
    nombre VARCHAR(50),
    apellido_paterno VARCHAR(50),
    apellido_materno VARCHAR(50),
    RFC VARCHAR(13),
    horario VARCHAR(100),
    salario NUMERIC(10,2),
    calle VARCHAR(100),
    num_int VARCHAR(10),
    num_ext VARCHAR(10),
    colonia VARCHAR(50)
);

COMMENT ON TABLE Personal IS 'Tabla que almacena la informacion del personal de la sucursal';
COMMENT ON COLUMN Personal.cedula_profesional IS 'Cedula profesional del empleado (llave primaria)';
COMMENT ON COLUMN Personal.id_sucursal IS 'Identificador de la sucursal donde labora el empleado';
COMMENT ON COLUMN Personal.nombre IS 'Nombre del empleado';
COMMENT ON COLUMN Personal.apellido_paterno IS 'Apellido paterno del empleado';
COMMENT ON COLUMN Personal.apellido_materno IS 'Apellido materno del empleado';
COMMENT ON COLUMN Personal.RFC IS 'Registro Federal de Contribuyentes del empleado';
COMMENT ON COLUMN Personal.horario IS 'Horario laboral del empleado';
COMMENT ON COLUMN Personal.salario IS 'Salario del empleado';
COMMENT ON COLUMN Personal.calle IS 'Calle de la direccion del empleado';
COMMENT ON COLUMN Personal.num_int IS 'Numero interior del domicilio del empleado';
COMMENT ON COLUMN Personal.num_ext IS 'Numero exterior del domicilio del empleado';
COMMENT ON COLUMN Personal.colonia IS 'Colonia del domicilio del empleado';

--Restricciones Personal
ALTER TABLE Personal ADD CONSTRAINT personal_d1
CHECK(nombre <> '');
ALTER TABLE Personal ADD CONSTRAINT personal_d2
CHECK(apellido_paterno <> '');
ALTER TABLE Personal ADD CONSTRAINT personal_d3
CHECK(RFC <> '');
ALTER TABLE Personal ALTER COLUMN nombre SET NOT NULL;
ALTER TABLE Personal ALTER COLUMN apellido_paterno SET NOT NULL;
ALTER TABLE Personal ALTER COLUMN id_sucursal SET NOT NULL;
ALTER TABLE Personal ADD CONSTRAINT personal_d4 
CHECK(apellido_materno IS NULL OR apellido_materno <> '');
ALTER TABLE Personal ADD CONSTRAINT personal_d5 
CHECK(calle <> '');
ALTER TABLE Personal ADD CONSTRAINT personal_d6 
CHECK(colonia <> '');
ALTER TABLE Personal ADD CONSTRAINT personal_d7 
CHECK(num_ext IS NULL OR num_ext <> '');
ALTER TABLE Personal ADD CONSTRAINT personal_d8 
CHECK(num_int IS NULL OR num_int <> '');
ALTER TABLE Personal ADD CONSTRAINT personal_d9 
CHECK(salario >= 0);
ALTER TABLE Personal ADD CONSTRAINT personal_d10
CHECK(horario IN ('matutino', 'vespertino', 'nocturno'));

COMMENT ON CONSTRAINT personal_d1 ON Personal IS 'Valida que el nombre no sea vacio';
COMMENT ON CONSTRAINT personal_d2 ON Personal IS 'Valida que el apellido paterno no sea vacio';
COMMENT ON CONSTRAINT personal_d3 ON Personal IS 'Valida que el RFC no sea vacio';
COMMENT ON CONSTRAINT personal_d4 ON Personal IS 'Valida que el apellido materno no sea vacio si existe';
COMMENT ON CONSTRAINT personal_d5 ON Personal IS 'Valida que la calle no sea vacia';
COMMENT ON CONSTRAINT personal_d6 ON Personal IS 'Valida que la colonia no sea vacia';
COMMENT ON CONSTRAINT personal_d7 ON Personal IS 'Valida que el numero exterior no sea vacio si existe';
COMMENT ON CONSTRAINT personal_d8 ON Personal IS 'Valida que el numero interior no sea vacio si existe';
COMMENT ON CONSTRAINT personal_d9 ON Personal IS 'Valida que el salario sea mayor o igual a 0';
COMMENT ON CONSTRAINT personal_d10 ON Personal IS 'Valida que el turno de trabajo del personal sea alguno de los tres válidos: matutino, vespertino o nocturno';


--Pk Personal
ALTER TABLE Personal ADD CONSTRAINT personal_pkey
PRIMARY KEY (cedula_profesional);

COMMENT ON CONSTRAINT personal_pkey ON Personal IS 'Llave primaria de la tabla Personal';

-- FK Personal
ALTER TABLE Personal ADD CONSTRAINT personal_fkey
FOREIGN KEY (id_sucursal) REFERENCES Sucursal(id_sucursal)
ON DELETE RESTRICT
ON UPDATE RESTRICT;

COMMENT ON CONSTRAINT personal_fkey ON Personal IS 
'Llave foranea hacia Sucursal. No se permite eliminar o actualizar una sucursal si tiene personal asociado (RESTRICT)';

--TelefonoPersonal(muLtivaluado)
CREATE TABLE TelefonoPersonal(
    cedula_profesional VARCHAR(20),
    telefono VARCHAR(15)
);

COMMENT ON TABLE TelefonoPersonal IS 'Tabla multivaluada que almacena los telefonos de cada empleado';
COMMENT ON COLUMN TelefonoPersonal.cedula_profesional IS 'Cedula profesional del empleado asociado';
COMMENT ON COLUMN TelefonoPersonal.telefono IS 'Numero de telefono del empleado';

--Pk TP
ALTER TABLE TelefonoPersonal ADD CONSTRAINT tel_personal_pkey
PRIMARY KEY (cedula_profesional, telefono);

COMMENT ON CONSTRAINT tel_personal_pkey ON TelefonoPersonal IS 
'Llave primaria compuesta por cedula_profesional y telefono';

--Fk TP
ALTER TABLE TelefonoPersonal ADD CONSTRAINT tel_personal_fkey
FOREIGN KEY (cedula_profesional) REFERENCES Personal(cedula_profesional)
ON DELETE CASCADE
ON UPDATE CASCADE;

COMMENT ON CONSTRAINT tel_personal_fkey ON TelefonoPersonal IS 
'Llave foranea hacia Personal. Si el empleado se elimina o su cedula se actualiza, sus telefonos se eliminan o actualizan respectivamente';

--Dominio TP
ALTER TABLE TelefonoPersonal ADD CONSTRAINT tel_personal_d1
CHECK(telefono <> '');

COMMENT ON CONSTRAINT tel_personal_d1 ON TelefonoPersonal IS 
'Valida que el telefono no sea vacio';

--CorreoPersonal(multivaluado)
CREATE TABLE CorreoPersonal(
    cedula_profesional VARCHAR(20),
    correo VARCHAR(100)
);

COMMENT ON TABLE CorreoPersonal IS 'Tabla multivaluada que almacena los correos electronicos de cada empleado';
COMMENT ON COLUMN CorreoPersonal.cedula_profesional IS 'Cedula profesional del empleado asociado';
COMMENT ON COLUMN CorreoPersonal.correo IS 'Correo electronico del empleado';

--Pk CP
ALTER TABLE CorreoPersonal ADD CONSTRAINT correo_personal_pkey
PRIMARY KEY (cedula_profesional, correo);

COMMENT ON CONSTRAINT correo_personal_pkey ON CorreoPersonal IS 
'Llave primaria compuesta por cedula_profesional y correo';

-- FK CP
ALTER TABLE CorreoPersonal ADD CONSTRAINT correo_personal_fkey
FOREIGN KEY (cedula_profesional) REFERENCES Personal(cedula_profesional)
ON DELETE CASCADE
ON UPDATE CASCADE;

COMMENT ON CONSTRAINT correo_personal_fkey ON CorreoPersonal IS 
'Llave foranea hacia Personal. Si el empleado se elimina o su cedula se actualiza, sus correos se eliminan o actualizan respectivamente';

--Dominio CP
ALTER TABLE CorreoPersonal ADD CONSTRAINT correo_personal_d1
CHECK(correo <> '');

COMMENT ON CONSTRAINT correo_personal_d1 ON CorreoPersonal IS 
'Valida que el correo no sea vacio';

--Subtipo: Medico
CREATE TABLE Medico(
    cedula_profesional VARCHAR(20),
    especialidad VARCHAR(100),
    institucion VARCHAR(100),
    vigencia_certificacion DATE
);

COMMENT ON TABLE Medico IS 'Subtipo de Personal que representa a los medicos';
COMMENT ON COLUMN Medico.cedula_profesional IS 'Cedula profesional del medico (hereda de Personal)';
COMMENT ON COLUMN Medico.especialidad IS 'Especialidad del medico';
COMMENT ON COLUMN Medico.institucion IS 'Institucion donde estudio el medico';
COMMENT ON COLUMN Medico.vigencia_certificacion IS 'Fecha de vigencia de la certificacion del medico';

--Restricciones Medico
ALTER TABLE Medico ADD CONSTRAINT medico_d1 
CHECK(especialidad <> '');
ALTER TABLE Medico ADD CONSTRAINT medico_d2 
CHECK(institucion <> '');
ALTER TABLE Medico ADD CONSTRAINT medico_d3 
CHECK(vigencia_certificacion >= CURRENT_DATE);

COMMENT ON CONSTRAINT medico_d1 ON Medico IS 'Valida que la especialidad no sea vacia';
COMMENT ON CONSTRAINT medico_d2 ON Medico IS 'Valida que la institucion no sea vacia';
COMMENT ON CONSTRAINT medico_d3 ON Medico IS 'Valida que la vigencia de certificacion sea hoy o posterior';

--Pk Medico
ALTER TABLE Medico ADD CONSTRAINT medico_pkey
PRIMARY KEY (cedula_profesional);

COMMENT ON CONSTRAINT medico_pkey ON Medico IS 'Llave primaria de la tabla Medico (hereda de Personal)';

-- FK Medico
ALTER TABLE Medico ADD CONSTRAINT medico_fkey
FOREIGN KEY (cedula_profesional) REFERENCES Personal(cedula_profesional)
ON DELETE CASCADE
ON UPDATE CASCADE;

COMMENT ON CONSTRAINT medico_fkey ON Medico IS 
'Llave foranea hacia Personal. Si el personal se elimina o su cedula se actualiza, el medico se elimina o actualiza automaticamente (CASCADE)';

--Subtipo: Enfermera
CREATE TABLE Enfermera(
    cedula_profesional VARCHAR(20),
    tipo_procedimiento VARCHAR(100),
    certificacion_reanimacion BOOLEAN
);

COMMENT ON TABLE Enfermera IS 'Subtipo de Personal que representa a las enfermeras';
COMMENT ON COLUMN Enfermera.cedula_profesional IS 'Cedula profesional de la enfermera (hereda de Personal)';
COMMENT ON COLUMN Enfermera.tipo_procedimiento IS 'Tipo de procedimiento que realiza la enfermera';
COMMENT ON COLUMN Enfermera.certificacion_reanimacion IS 'Indica si tiene certificacion en reanimacion';

--Resttriciones Enfermera
ALTER TABLE Enfermera ADD CONSTRAINT enfermera_d1
CHECK(tipo_procedimiento IS NULL OR tipo_procedimiento <> '');
ALTER TABLE Enfermera ALTER COLUMN certificacion_reanimacion SET DEFAULT FALSE;

COMMENT ON CONSTRAINT enfermera_d1 ON Enfermera IS 'Valida que el tipo de procedimiento no sea vacio si existe';

--Pk Enfermera
ALTER TABLE Enfermera ADD CONSTRAINT enfermera_pkey
PRIMARY KEY (cedula_profesional);

COMMENT ON CONSTRAINT enfermera_pkey ON Enfermera IS 'Llave primaria de la tabla Enfermera (hereda de Personal)';

-- FK Enfermera
ALTER TABLE Enfermera ADD CONSTRAINT enfermera_fkey
FOREIGN KEY (cedula_profesional) REFERENCES Personal(cedula_profesional)
ON DELETE CASCADE
ON UPDATE CASCADE;

COMMENT ON CONSTRAINT enfermera_fkey ON Enfermera IS 
'Llave foranea hacia Personal. Si el personal se elimina o su cedula se actualiza, la enfermera se elimina o actualiza automaticamente (CASCADE)';


--Subtipo: Farmaceutico
CREATE TABLE Farmaceutico(
    cedula_profesional VARCHAR(20)
);

COMMENT ON TABLE Farmaceutico IS 'Subtipo de Personal que representa a los farmaceuticos';
COMMENT ON COLUMN Farmaceutico.cedula_profesional IS 'Cedula profesional del farmaceutico (hereda de Personal)';

--Pk Farmaceutico
ALTER TABLE Farmaceutico ADD CONSTRAINT farmaceutico_pkey
PRIMARY KEY (cedula_profesional);

COMMENT ON CONSTRAINT farmaceutico_pkey ON Farmaceutico IS 'Llave primaria de la tabla Farmaceutico (hereda de Personal)';

-- FK Farmaceutico hacia Personal (con politica CASCADE)
ALTER TABLE Farmaceutico ADD CONSTRAINT farmaceutico_fkey
FOREIGN KEY (cedula_profesional) REFERENCES Personal(cedula_profesional)
ON DELETE CASCADE
ON UPDATE CASCADE;

COMMENT ON CONSTRAINT farmaceutico_fkey ON Farmaceutico IS 
'Llave foranea hacia Personal. Si el personal se elimina o su cedula se actualiza, el farmaceutico se elimina o actualiza automaticamente (CASCADE)';

--Ticket
CREATE TABLE Ticket(
    id_ticket INT,
    id_cliente INT,
    id_sucursal INT,
    fecha DATE,
    hora TIME
);

COMMENT ON TABLE Ticket IS 'Tabla que almacena los tickets de venta o servicio';
COMMENT ON COLUMN Ticket.id_ticket IS 'Identificador unico del ticket';
COMMENT ON COLUMN Ticket.id_cliente IS 'Identificador del cliente asociado al ticket';
COMMENT ON COLUMN Ticket.id_sucursal IS 'Identificador de la sucursal donde se genero el ticket';
COMMENT ON COLUMN Ticket.fecha IS 'Fecha del ticket';
COMMENT ON COLUMN Ticket.hora IS 'Hora del ticket';

--Restricciones Ticket
ALTER TABLE Ticket ADD CONSTRAINT ticket_d1
CHECK(fecha IS NOT NULL);
ALTER TABLE Ticket ADD CONSTRAINT ticket_d2
CHECK(hora IS NOT NULL);
ALTER TABLE Ticket ALTER COLUMN id_sucursal SET NOT NULL;
ALTER TABLE Ticket ALTER COLUMN fecha SET NOT NULL;
ALTER TABLE Ticket ALTER COLUMN hora SET NOT NULL;
ALTER TABLE Ticket ALTER COLUMN id_cliente SET NOT NULL;
ALTER TABLE Ticket ADD CONSTRAINT ticket_cliente_check
CHECK(id_cliente > 0);


COMMENT ON CONSTRAINT ticket_d1 ON Ticket IS 'Valida que la fecha no sea nula';
COMMENT ON CONSTRAINT ticket_d2 ON Ticket IS 'Valida que la hora no sea nula';
COMMENT ON CONSTRAINT ticket_cliente_check ON Ticket IS 'Valida que el id del cliente sea un número positivo';

--Pk Ticket
ALTER TABLE Ticket ADD CONSTRAINT ticket_pkey
PRIMARY KEY (id_ticket);

COMMENT ON CONSTRAINT ticket_pkey ON Ticket IS 'Llave primaria de la tabla Ticket';

-- FK Ticket
ALTER TABLE Ticket ALTER COLUMN id_cliente DROP NOT NULL;

ALTER TABLE Ticket ADD CONSTRAINT ticket_cliente_fkey
FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
ON DELETE SET NULL
ON UPDATE SET NULL;

COMMENT ON CONSTRAINT ticket_cliente_fkey ON Ticket IS 
'Llave foranea hacia Cliente. Si el cliente se elimina o su ID se actualiza, el ticket conserva el valor NULL en id_cliente (SET NULL) para preservar historial';

-- FK Ticket-Sucursal
ALTER TABLE Ticket ADD CONSTRAINT ticket_sucursal_fkey
FOREIGN KEY (id_sucursal) REFERENCES Sucursal(id_sucursal)
ON DELETE RESTRICT
ON UPDATE RESTRICT;

COMMENT ON CONSTRAINT ticket_sucursal_fkey ON Ticket IS 
'Llave foranea hacia Sucursal. No se permite eliminar o actualizar una sucursal si tiene tickets asociados (RESTRICT)';

--Consulta
CREATE TABLE Consulta(
    id_consulta INT,
    id_ticket INT,
    cedula_profesional_medico VARCHAR(20),
    cedula_profesional_enfermera VARCHAR(20),
    precio NUMERIC(10,2),
    fecha DATE,
    hora TIME,
    diagnostico TEXT
);

COMMENT ON TABLE Consulta IS 'Tabla que almacena las consultas realizadas por medicos';
COMMENT ON COLUMN Consulta.id_consulta IS 'Identificador unico de la consulta';
COMMENT ON COLUMN Consulta.id_ticket IS 'Identificador del ticket asociado a la consulta';
COMMENT ON COLUMN Consulta.cedula_profesional_medico IS 'Cedula profesional del medico que realizo la consulta';
COMMENT ON COLUMN Consulta.cedula_profesional_enfermera IS 'Cedula profesional de la enfermera que asistió la consulta';
COMMENT ON COLUMN Consulta.precio IS 'Precio de la consulta';
COMMENT ON COLUMN Consulta.fecha IS 'Fecha de la consulta';
COMMENT ON COLUMN Consulta.hora IS 'Hora de la consulta';
COMMENT ON COLUMN Consulta.diagnostico IS 'Diagnostico del medico';

--Restricciones CM
ALTER TABLE Consulta ADD CONSTRAINT cm_d1
CHECK(precio >= 0);

ALTER TABLE Consulta ALTER COLUMN id_ticket SET NOT NULL;
ALTER TABLE Consulta ALTER COLUMN cedula_profesional_medico SET NOT NULL;
ALTER TABLE Consulta ALTER COLUMN fecha SET NOT NULL;
ALTER TABLE Consulta ALTER COLUMN hora SET NOT NULL;
ALTER TABLE Consulta ALTER COLUMN precio SET NOT NULL;


ALTER TABLE Consulta ADD CONSTRAINT cm_d2
CHECK(diagnostico IS NULL OR diagnostico <> '');

ALTER TABLE Consulta ADD CONSTRAINT cm_d3
CHECK(cedula_profesional_medico <> '');

ALTER TABLE Consulta ADD CONSTRAINT cm_d4 -- Puede no ser obligatorio que una enfermera asista siempre una consulta
CHECK(
    cedula_profesional_enfermera IS NULL 
    OR cedula_profesional_enfermera <> ''
);

COMMENT ON CONSTRAINT cm_d1 ON Consulta IS 'Valida que el precio sea mayor o igual a 0';
COMMENT ON CONSTRAINT cm_d2 ON Consulta IS 'Valida que el diagnostico no sea vacio si existe';
COMMENT ON CONSTRAINT cm_d3 ON Consulta IS 'Valida que la cédula profesional del médico no sea una cadena vacía';
COMMENT ON CONSTRAINT cm_d4 ON Consulta IS 'Valida que la cédula profesional de la enfermera no sea una cadena vacía si existe';


--Pk CM
ALTER TABLE Consulta ADD CONSTRAINT cm_pkey
PRIMARY KEY (id_consulta);

COMMENT ON CONSTRAINT cm_pkey ON Consulta IS 'Llave primaria de la tabla Consulta';

-- FK Consulta-Ticket
ALTER TABLE Consulta ADD CONSTRAINT cm_ticket_fkey
FOREIGN KEY (id_ticket) REFERENCES Ticket(id_ticket)
ON DELETE CASCADE
ON UPDATE CASCADE;

COMMENT ON CONSTRAINT cm_ticket_fkey ON Consulta IS
'Llave foranea hacia Ticket. Si el ticket se elimina o su ID se actualiza, la consulta se elimina o actualiza automaticamente (CASCADE)';

-- FK a Medico 
ALTER TABLE Consulta ADD CONSTRAINT cm_medico_fkey
FOREIGN KEY (cedula_profesional_medico)
REFERENCES Medico(cedula_profesional)
ON DELETE SET NULL
ON UPDATE SET NULL;

COMMENT ON CONSTRAINT cm_medico_fkey ON Consulta IS
'Llave foranea hacia Medico. Si el medico se elimina o su cedula se actualiza, la consulta conserva NULL para mantener historial';

--Fk a Enfermera 
ALTER TABLE Consulta ADD CONSTRAINT cm_enfermera_fkey
FOREIGN KEY (cedula_profesional_enfermera)
REFERENCES Enfermera(cedula_profesional)
ON DELETE SET NULL
ON UPDATE SET NULL;

COMMENT ON CONSTRAINT cm_enfermera_fkey ON Consulta IS
'Llave foranea hacia Enfermera. Si la enfermera se elimina o su cedula se actualiza, la consulta conserva NULL para mantener historial';

--Receta
CREATE TABLE Receta(
    numero_receta INT,
    id_consulta INT,
    duracion VARCHAR(50),
    forma_farmaceutica VARCHAR(50),
    concentracion VARCHAR(50),
    presentacion VARCHAR(50),
    via_administracion VARCHAR(50),
    alergias TEXT,
    consultorio VARCHAR(50),
    diagnostico TEXT,
    turno VARCHAR(50),
    dosis VARCHAR(50),
    frecuencia VARCHAR(50),
    peso NUMERIC(5,2),
    talla NUMERIC(5,2)
);

COMMENT ON TABLE Receta IS 'Tabla que almacena las recetas medicas generadas en consultas';
COMMENT ON COLUMN Receta.numero_receta IS 'Numero unico de la receta';
COMMENT ON COLUMN Receta.id_consulta IS 'Identificador de la consulta medica asociada';
COMMENT ON COLUMN Receta.duracion IS 'Duracion del tratamiento';
COMMENT ON COLUMN Receta.forma_farmaceutica IS 'Forma farmaceutica del medicamento recetado';
COMMENT ON COLUMN Receta.concentracion IS 'Concentracion del medicamento recetado';
COMMENT ON COLUMN Receta.presentacion IS 'Presentacion del medicamento recetado';
COMMENT ON COLUMN Receta.via_administracion IS 'Via de administracion del medicamento';
COMMENT ON COLUMN Receta.alergias IS 'Alergias del paciente registradas en la receta';
COMMENT ON COLUMN Receta.consultorio IS 'Consultorio donde se realizo la receta';
COMMENT ON COLUMN Receta.diagnostico IS 'Diagnostico asociado a la receta';
COMMENT ON COLUMN Receta.turno IS 'Turno en que se genero la receta';
COMMENT ON COLUMN Receta.dosis IS 'Dosis del medicamento recetado';
COMMENT ON COLUMN Receta.frecuencia IS 'Frecuencia de administracion del medicamento';
COMMENT ON COLUMN Receta.peso IS 'Peso del paciente al momento de la receta';
COMMENT ON COLUMN Receta.talla IS 'Talla del paciente al momento de la receta';

--Restricciones Receta
ALTER TABLE Receta ADD CONSTRAINT receta_d1
CHECK(peso >= 0 AND talla >= 0);
ALTER TABLE Receta ALTER COLUMN id_consulta SET NOT NULL;
ALTER TABLE Receta ADD CONSTRAINT receta_d2 
CHECK(alergias IS NULL OR alergias <> '');
ALTER TABLE Receta ADD CONSTRAINT receta_d3 
CHECK(concentracion <> '');
ALTER TABLE Receta ADD CONSTRAINT receta_d4 
CHECK(consultorio <> '');
ALTER TABLE Receta ADD CONSTRAINT receta_d5 
CHECK(diagnostico <> '');
ALTER TABLE Receta ADD CONSTRAINT receta_d6 
CHECK(dosis <> '');
ALTER TABLE Receta ADD CONSTRAINT receta_d7 
CHECK(duracion <> '');
ALTER TABLE Receta ADD CONSTRAINT receta_d8 
CHECK(forma_farmaceutica <> '');
ALTER TABLE Receta ADD CONSTRAINT receta_d9 
CHECK(frecuencia <> '');
ALTER TABLE Receta ADD CONSTRAINT receta_d10 
CHECK(presentacion <> '');
ALTER TABLE Receta ADD CONSTRAINT receta_d11 
CHECK(turno <> '');
ALTER TABLE Receta ADD CONSTRAINT receta_d12 
CHECK(via_administracion <> '');

COMMENT ON CONSTRAINT receta_d1 ON Receta IS 'Valida que el peso y la talla sean mayores o iguales a 0';
COMMENT ON CONSTRAINT receta_d2 ON Receta IS 'Valida que las alergias no sean vacias si existen';
COMMENT ON CONSTRAINT receta_d3 ON Receta IS 'Valida que la concentracion no sea vacia';
COMMENT ON CONSTRAINT receta_d4 ON Receta IS 'Valida que el consultorio no sea vacio';
COMMENT ON CONSTRAINT receta_d5 ON Receta IS 'Valida que el diagnostico no sea vacio';
COMMENT ON CONSTRAINT receta_d6 ON Receta IS 'Valida que la dosis no sea vacia';
COMMENT ON CONSTRAINT receta_d7 ON Receta IS 'Valida que la duracion no sea vacia';
COMMENT ON CONSTRAINT receta_d8 ON Receta IS 'Valida que la forma farmaceutica no sea vacia';
COMMENT ON CONSTRAINT receta_d9 ON Receta IS 'Valida que la frecuencia no sea vacia';
COMMENT ON CONSTRAINT receta_d10 ON Receta IS 'Valida que la presentacion no sea vacia';
COMMENT ON CONSTRAINT receta_d11 ON Receta IS 'Valida que el turno no sea vacio';
COMMENT ON CONSTRAINT receta_d12 ON Receta IS 'Valida que la via de administracion no sea vacia';

--Pk Receta
ALTER TABLE Receta ADD CONSTRAINT receta_pkey
PRIMARY KEY (numero_receta);

COMMENT ON CONSTRAINT receta_pkey ON Receta IS 'Llave primaria de la tabla Receta';

-- FK Receta
ALTER TABLE Receta ADD CONSTRAINT receta_fkey
FOREIGN KEY (id_consulta) REFERENCES Consulta(id_consulta)
ON DELETE CASCADE
ON UPDATE CASCADE;

COMMENT ON CONSTRAINT receta_fkey ON Receta IS 
'Llave foranea hacia Consulta. Si la consulta medica se elimina o su ID se actualiza, la receta se elimina o actualiza automaticamente (CASCADE)';

--Apartir de aqui
--RELACIONES
--IncluirMedicamento
CREATE TABLE IncluirMedicamento(
    id_ticket INT,
    id_producto INT,
    cantidad INT
);

COMMENT ON TABLE IncluirMedicamento IS 'Tabla que relaciona tickets con medicamentos incluidos';
COMMENT ON COLUMN IncluirMedicamento.id_ticket IS 'Identificador del ticket';
COMMENT ON COLUMN IncluirMedicamento.id_producto IS 'Identificador del medicamento';
COMMENT ON COLUMN IncluirMedicamento.cantidad IS 'Cantidad del medicamento incluido en el ticket';

--Restricciones IM
ALTER TABLE IncluirMedicamento ALTER COLUMN id_producto SET NOT NULL;
ALTER TABLE IncluirMedicamento ALTER COLUMN id_ticket SET NOT NULL;
ALTER TABLE IncluirMedicamento ADD CONSTRAINT incluir_medicamento_ids_check
CHECK(id_producto > 0 AND id_ticket > 0);

COMMENT ON CONSTRAINT incluir_medicamento_ids_check ON IncluirMedicamento IS 
'Asegura que los ids de producto y ticket sean ids válidos, es decir, positivos';

--FKs IM
ALTER TABLE IncluirMedicamento ADD CONSTRAINT inc_med_ticket_fkey
FOREIGN KEY (id_ticket) REFERENCES Ticket(id_ticket)
ON DELETE CASCADE
ON UPDATE CASCADE;

COMMENT ON CONSTRAINT inc_med_ticket_fkey ON IncluirMedicamento IS 
'Llave foranea hacia Ticket. Si el ticket se elimina o su ID se actualiza, los registros de inclusion se eliminan o actualizan (CASCADE)';

ALTER TABLE IncluirMedicamento ADD CONSTRAINT inc_med_producto_fkey
FOREIGN KEY (id_producto) REFERENCES Medicamento(id_producto)
ON DELETE RESTRICT
ON UPDATE RESTRICT;

COMMENT ON CONSTRAINT inc_med_producto_fkey ON IncluirMedicamento IS 
'Llave foranea hacia Medicamento. No se permite eliminar o actualizar un medicamento si ha sido incluido en tickets (RESTRICT)';

--Dominio IM
ALTER TABLE IncluirMedicamento ADD CONSTRAINT inc_med_d1
CHECK(cantidad > 0);

COMMENT ON CONSTRAINT inc_med_d1 ON IncluirMedicamento IS 'Valida que la cantidad sea mayor a 0';

--IncluirInsumo
CREATE TABLE IncluirInsumo(
    id_ticket INT,
    id_producto INT,
    cantidad INT
);

COMMENT ON TABLE IncluirInsumo IS 'Tabla que relaciona tickets con insumos incluidos';
COMMENT ON COLUMN IncluirInsumo.id_ticket IS 'Identificador del ticket';
COMMENT ON COLUMN IncluirInsumo.id_producto IS 'Identificador del insumo';
COMMENT ON COLUMN IncluirInsumo.cantidad IS 'Cantidad del insumo incluido en el ticket';

--Restricciones II
ALTER TABLE IncluirInsumo ALTER COLUMN id_producto SET NOT NULL;
ALTER TABLE IncluirInsumo ALTER COLUMN id_ticket SET NOT NULL;
ALTER TABLE IncluirInsumo ADD CONSTRAINT incluir_insumo_ids_check
CHECK(id_producto > 0 AND id_ticket > 0);

COMMENT ON CONSTRAINT incluir_insumo_ids_check ON IncluirInsumo IS 
'Asegura que los ids de producto y ticket sean ids válidos, es decir, positivos';

--FKs II
ALTER TABLE IncluirInsumo ADD CONSTRAINT inc_insumo_ticket_fkey
FOREIGN KEY (id_ticket) REFERENCES Ticket(id_ticket)
ON DELETE CASCADE
ON UPDATE CASCADE;

COMMENT ON CONSTRAINT inc_insumo_ticket_fkey ON IncluirInsumo IS 
'Llave foranea hacia Ticket. Si el ticket se elimina o su ID se actualiza, los registros de inclusion se eliminan o actualizan (CASCADE)';

ALTER TABLE IncluirInsumo ADD CONSTRAINT inc_insumo_producto_fkey
FOREIGN KEY (id_producto) REFERENCES Insumo(id_producto)
ON DELETE RESTRICT
ON UPDATE RESTRICT;

COMMENT ON CONSTRAINT inc_insumo_producto_fkey ON IncluirInsumo IS 
'Llave foranea hacia Insumo. No se permite eliminar o actualizar un insumo si ha sido incluido en tickets (RESTRICT)';


--Dominio II
ALTER TABLE IncluirInsumo ADD CONSTRAINT inc_insumo_d1
CHECK(cantidad > 0);

COMMENT ON CONSTRAINT inc_insumo_d1 ON IncluirInsumo IS 'Valida que la cantidad sea mayor a 0';

--ProveerMedicamento
CREATE TABLE ProveerMedicamento(
    numero_proveedor INT,
    id_producto INT,
    id_sucursal INT,
    cantidad INT,
    fecha_recibimiento DATE
);

COMMENT ON TABLE ProveerMedicamento IS 'Tabla que relaciona proveedores con medicamentos suministrados a sucursales';
COMMENT ON COLUMN ProveerMedicamento.numero_proveedor IS 'Numero del proveedor';
COMMENT ON COLUMN ProveerMedicamento.id_producto IS 'Identificador del medicamento suministrado';
COMMENT ON COLUMN ProveerMedicamento.id_sucursal IS 'Identificador de la sucursal que recibe el suministro';
COMMENT ON COLUMN ProveerMedicamento.cantidad IS 'Cantidad suministrada';
COMMENT ON COLUMN ProveerMedicamento.fecha_recibimiento IS 'La fecha en la que se recibió el medicamento';

--Restricciones PM
ALTER TABLE ProveerMedicamento ALTER COLUMN numero_proveedor SET NOT NULL;
ALTER TABLE ProveerMedicamento ALTER COLUMN id_producto SET NOT NULL;
ALTER TABLE proveermedicamento ALTER COLUMN id_sucursal SET NOT NULL;
ALTER TABLE ProveerMedicamento ALTER COLUMN cantidad SET NOT NULL;
ALTER TABLE ProveerMedicamento ALTER COLUMN fecha_recibimiento SET NOT NULL;
ALTER TABLE ProveerMedicamento ADD CONSTRAINT proveer_medicamento_check
CHECK(
    id_producto > 0 AND 
    id_sucursal > 0 AND 
    numero_proveedor > 0 AND
    fecha_recibimiento <= CURRENT_DATE
);

COMMENT ON CONSTRAINT proveer_medicamento_check ON ProveerMedicamento IS 
'Revisa de manera general que id_producto, id_sucursal, numero_proveedor y fecha_recibimiento sean datos válidos en nivel de forma y congruencia con la fecha.';

--FKs PM
ALTER TABLE ProveerMedicamento ADD CONSTRAINT prov_med_proveedor_fkey
FOREIGN KEY (numero_proveedor) REFERENCES Proveedor(numero_proveedor)
ON DELETE RESTRICT
ON UPDATE RESTRICT;

COMMENT ON CONSTRAINT prov_med_proveedor_fkey ON ProveerMedicamento IS 
'Llave foranea hacia Proveedor. No se permite eliminar o actualizar un proveedor con historial de suministros (RESTRICT)';

ALTER TABLE ProveerMedicamento ADD CONSTRAINT prov_med_producto_fkey
FOREIGN KEY (id_producto) REFERENCES Medicamento(id_producto)
ON DELETE RESTRICT
ON UPDATE RESTRICT;

COMMENT ON CONSTRAINT prov_med_producto_fkey ON ProveerMedicamento IS 
'Llave foranea hacia Medicamento. No se permite eliminar o actualizar un medicamento con historial de suministros (RESTRICT)';


ALTER TABLE ProveerMedicamento ADD CONSTRAINT prov_med_sucursal_fkey
FOREIGN KEY (id_sucursal) REFERENCES Sucursal(id_sucursal)
ON DELETE CASCADE
ON UPDATE CASCADE;

COMMENT ON CONSTRAINT prov_med_sucursal_fkey ON ProveerMedicamento IS 
'Llave foranea hacia Sucursal. Si la sucursal se elimina o su ID se actualiza, los suministros asociados se eliminan o actualizan (CASCADE)';

--Dominio PM
ALTER TABLE ProveerMedicamento ADD CONSTRAINT prov_med_d1
CHECK(cantidad >= 0);

COMMENT ON CONSTRAINT prov_med_d1 ON ProveerMedicamento IS 'Valida que la cantidad sea mayor o igual a 0';

--VenderMedicamento
CREATE TABLE VenderMedicamento(
    id_producto INT,
    id_sucursal INT
);

COMMENT ON TABLE VenderMedicamento IS 'Tabla que relaciona las ventas con medicamentos vendidos por sucursales';
COMMENT ON COLUMN VenderMedicamento.id_producto IS 'Identificador del medicamento vendido';
COMMENT ON COLUMN VenderMedicamento.id_sucursal IS 'Identificador de la sucursal que vende el suministro';


--Restricciones VM
ALTER TABLE VenderMedicamento ALTER COLUMN id_producto SET NOT NULL;
ALTER TABLE VenderMedicamento ALTER COLUMN id_sucursal SET NOT NULL;
ALTER TABLE VenderMedicamento ADD CONSTRAINT vender_medicamento_check
CHECK(
    id_producto > 0 AND 
    id_sucursal > 0
);

COMMENT ON CONSTRAINT vender_medicamento_check ON VenderMedicamento IS
'Revisa que el id de producto y sucursal sean números positivos';

--FKs VM
ALTER TABLE VenderMedicamento ADD CONSTRAINT vender_med_producto_fkey
FOREIGN KEY (id_producto) REFERENCES Medicamento(id_producto)
ON DELETE RESTRICT
ON UPDATE RESTRICT;

COMMENT ON CONSTRAINT vender_med_producto_fkey ON VenderMedicamento IS 
'Llave foranea hacia Medicamento. No se permite eliminar o actualizar un medicamento con historial de suministros (RESTRICT)';


ALTER TABLE VenderMedicamento ADD CONSTRAINT vender_med_sucursal_fkey
FOREIGN KEY (id_sucursal) REFERENCES Sucursal(id_sucursal)
ON DELETE CASCADE
ON UPDATE CASCADE;

COMMENT ON CONSTRAINT vender_med_sucursal_fkey ON VenderMedicamento IS 
'Llave foranea hacia Sucursal. Si la sucursal se elimina o su ID se actualiza, los suministros asociados se eliminan o actualizan (CASCADE)';

-- TODO: TERMINA

--ProveerInsumo
CREATE TABLE ProveerInsumo(
    numero_proveedor INT,
    id_producto INT,
    id_sucursal INT,
    cantidad INT,
    fecha_recibimiento DATE
);

COMMENT ON TABLE ProveerInsumo IS 'Tabla que relaciona proveedores con insumos suministrados a sucursales';
COMMENT ON COLUMN ProveerInsumo.numero_proveedor IS 'Numero del proveedor';
COMMENT ON COLUMN ProveerInsumo.id_producto IS 'Identificador del insumo suministrado';
COMMENT ON COLUMN ProveerInsumo.id_sucursal IS 'Identificador de la sucursal que recibe el suministro';
COMMENT ON COLUMN ProveerInsumo.cantidad IS 'Cantidad suministrada';
COMMENT ON COLUMN ProveerInsumo.fecha_recibimiento IS 'Fecha en la que se recibió el insumo';

--Restricciones PI
ALTER TABLE ProveerInsumo ALTER COLUMN fecha_recibimiento SET NOT NULL;
ALTER TABLE ProveerInsumo ALTER COLUMN id_producto SET NOT NULL;
ALTER TABLE ProveerInsumo ALTER COLUMN id_sucursal SET NOT NULL;
ALTER TABLE ProveerInsumo ALTER COLUMN numero_proveedor SET NOT NULL;
ALTER TABLE ProveerInsumo ADD CONSTRAINT proveer_insumo_check
CHECK(
    id_producto > 0 AND 
    id_sucursal > 0 AND 
    numero_proveedor > 0 AND
    fecha_recibimiento <= CURRENT_DATE
);

COMMENT ON CONSTRAINT proveer_insumo_check ON ProveerInsumo IS 
'Revisa de manera general que id_producto, id_sucursal, numero_proveedor y fecha_recibimiento sean datos válidos en nivel de forma y congruencia con la fecha.';

--FKs PI
ALTER TABLE ProveerInsumo ADD CONSTRAINT prov_insumo_proveedor_fkey
FOREIGN KEY (numero_proveedor) REFERENCES Proveedor(numero_proveedor)
ON DELETE RESTRICT
ON UPDATE RESTRICT;

COMMENT ON CONSTRAINT prov_insumo_proveedor_fkey ON ProveerInsumo IS 
'Llave foranea hacia Proveedor. No se permite eliminar o actualizar un proveedor con historial de suministros (RESTRICT)';

ALTER TABLE ProveerInsumo ADD CONSTRAINT prov_insumo_producto_fkey
FOREIGN KEY (id_producto) REFERENCES Insumo(id_producto)
ON DELETE RESTRICT
ON UPDATE RESTRICT;

COMMENT ON CONSTRAINT prov_insumo_producto_fkey ON ProveerInsumo IS 
'Llave foranea hacia Insumo. No se permite eliminar o actualizar un insumo con historial de suministros (RESTRICT)';


ALTER TABLE ProveerInsumo ADD CONSTRAINT prov_insumo_sucursal_fkey
FOREIGN KEY (id_sucursal) REFERENCES Sucursal(id_sucursal)
ON DELETE CASCADE
ON UPDATE CASCADE;

COMMENT ON CONSTRAINT prov_insumo_sucursal_fkey ON ProveerInsumo IS 
'Llave foranea hacia Sucursal. Si la sucursal se elimina o su ID se actualiza, los suministros asociados se eliminan o actualizan (CASCADE)';


--Dominio PI
ALTER TABLE ProveerInsumo ADD CONSTRAINT prov_insumo_d1
CHECK(cantidad >= 0);

COMMENT ON CONSTRAINT prov_insumo_d1 ON ProveerInsumo IS 'Valida que la cantidad sea mayor o igual a 0';


--VenderInsumo
CREATE TABLE VenderInsumo(
    id_producto INT,
    id_sucursal INT
);

COMMENT ON TABLE VenderInsumo IS 'Tabla que relaciona la venta entre producto y sucursal';
COMMENT ON COLUMN VenderInsumo.id_producto IS 'Identificador del insumo vendido';
COMMENT ON COLUMN VenderInsumo.id_sucursal IS 'Identificador de la sucursal vende el insumo';


--Restricciones VI
ALTER TABLE VenderInsumo ALTER COLUMN id_producto SET NOT NULL;
ALTER TABLE VenderInsumo ALTER COLUMN id_sucursal SET NOT NULL;
ALTER TABLE VenderInsumo ADD CONSTRAINT vender_insumo_check
CHECK(
    id_producto > 0 AND 
    id_sucursal > 0
);

COMMENT ON CONSTRAINT vender_insumo_check ON VenderInsumo IS 
'Revisa que el id de producto y sucursal sean números positivos';

--FKs VI
ALTER TABLE VenderInsumo ADD CONSTRAINT vender_insumo_producto_fkey
FOREIGN KEY (id_producto) REFERENCES Insumo(id_producto)
ON DELETE RESTRICT
ON UPDATE RESTRICT;

COMMENT ON CONSTRAINT vender_insumo_producto_fkey ON VenderInsumo IS 
'Llave foranea hacia Insumo. No se permite eliminar o actualizar un insumo con historial de suministros (RESTRICT)';


ALTER TABLE VenderInsumo ADD CONSTRAINT vender_insumo_sucursal_fkey
FOREIGN KEY (id_sucursal) REFERENCES Sucursal(id_sucursal)
ON DELETE CASCADE
ON UPDATE CASCADE;

COMMENT ON CONSTRAINT vender_insumo_sucursal_fkey ON VenderInsumo IS 
'Llave foranea hacia Sucursal. Si la sucursal se elimina o su ID se actualiza, los suministros asociados se eliminan o actualizan (CASCADE)';


--Preparar
CREATE TABLE Preparar(
    cedula_profesional VARCHAR(20),
    id_producto INT,
    cantidad INT
);

COMMENT ON TABLE Preparar IS 'Tabla que relaciona farmaceuticos con medicamentos que preparan';
COMMENT ON COLUMN Preparar.cedula_profesional IS 'Cedula profesional del farmaceutico';
COMMENT ON COLUMN Preparar.id_producto IS 'Identificador del medicamento preparado';
COMMENT ON COLUMN Preparar.cantidad IS 'Cantidad preparada';

--Restricciones Preparar
ALTER TABLE Preparar ALTER COLUMN cedula_profesional SET NOT NULL;
ALTER TABLE Preparar ALTER COLUMN id_producto SET NOT NULL;
ALTER TABLE Preparar ADD CONSTRAINT preparar_check
CHECK(cedula_profesional ~ '^[0-9]+$' AND id_producto > 0);
ALTER TABLE Preparar ALTER COLUMN cantidad SET NOT NULL;

COMMENT ON CONSTRAINT preparar_check ON Preparar IS 
'Valida que la cédula profesional sea válida y que el id de producyo sea un entero positivo';

--FK a Farmaceutico
ALTER TABLE Preparar ADD CONSTRAINT preparar_farmaceutico_fkey
FOREIGN KEY (cedula_profesional) REFERENCES Farmaceutico(cedula_profesional)
ON DELETE SET NULL
ON UPDATE SET NULL;

COMMENT ON CONSTRAINT preparar_farmaceutico_fkey ON Preparar IS 
'Llave foranea hacia Farmaceutico. Si el farmaceutico se elimina o su cedula se actualiza, el registro de preparacion conserva NULL (SET NULL) para preservar historial';

--FK a Medicamento
ALTER TABLE Preparar ADD CONSTRAINT preparar_producto_fkey
FOREIGN KEY (id_producto) REFERENCES Medicamento(id_producto)
ON DELETE RESTRICT
ON UPDATE RESTRICT;

COMMENT ON CONSTRAINT preparar_producto_fkey ON Preparar IS 
'Llave foranea hacia Medicamento. No se permite eliminar o actualizar un medicamento con registros de preparacion (RESTRICT)';

--Dominio Preparar
ALTER TABLE Preparar ADD CONSTRAINT preparar_d1
CHECK(cantidad > 0);

COMMENT ON CONSTRAINT preparar_d1 ON Preparar IS 'Valida que la cantidad sea mayor a 0';

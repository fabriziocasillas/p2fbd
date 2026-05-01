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

--Pk CLiente
ALTER TABLE Cliente ADD CONSTRAINT cliente_pkey
PRIMARY KEY (id_cliente);

--TelefonoCliente(multivaluado)
CREATE TABLE TelefonoCliente(
    id_cliente INT,
    telefono VARCHAR(15)
);

--Pk TC
ALTER TABLE TelefonoCliente ADD CONSTRAINT telefono_cliente_pkey
PRIMARY KEY (id_cliente, telefono);

--Fk TC
ALTER TABLE TelefonoCliente ADD CONSTRAINT telefono_cliente_fkey
FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente);

--Dominio TC
ALTER TABLE TelefonoCliente ADD CONSTRAINT telefono_cliente_d1
CHECK(telefono <> '');

--CorreoCliente(multivaluado)
CREATE TABLE CorreoCliente(
    id_cliente INT,
    correo VARCHAR(100)
);

--Pk CC
ALTER TABLE CorreoCliente ADD CONSTRAINT correo_cliente_pkey
PRIMARY KEY (id_cliente, correo);

--Fk CC
ALTER TABLE CorreoCliente ADD CONSTRAINT correo_cliente_fkey
FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente);

--Dominio CC
ALTER TABLE CorreoCliente ADD CONSTRAINT correo_cliente_d1
CHECK(correo <> '');

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

--Pk Sucursal
ALTER TABLE Sucursal ADD CONSTRAINT sucursal_pkey
PRIMARY KEY (id_sucursal);

--HorarioSucursal(multivaluado)
CREATE TABLE HorarioSucursal(
    id_sucursal INT,
    horario VARCHAR(100)
);

--Pk HS
ALTER TABLE HorarioSucursal ADD CONSTRAINT horario_sucursal_pkey
PRIMARY KEY (id_sucursal, horario);

--Fk HS
ALTER TABLE HorarioSucursal ADD CONSTRAINT horario_sucursal_fkey
FOREIGN KEY (id_sucursal) REFERENCES Sucursal(id_sucursal);

--Domino HS
ALTER TABLE HorarioSucursal ADD CONSTRAINT horario_sucursal_d1
CHECK(horario <> '');

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

--Pk Medicamento
ALTER TABLE Medicamento ADD CONSTRAINT medicamento_pkey
PRIMARY KEY (id_producto);

--CondAlmMed(multivaluado)
CREATE TABLE CondicionAlmacenamientoMedicamento(
    id_producto INT,
    condicion VARCHAR(100)
);

--Pk CondAlmMed
ALTER TABLE CondicionAlmacenamientoMedicamento 
ADD CONSTRAINT cond_med_pkey
PRIMARY KEY (id_producto, condicion);

--Fk CondAlmMed
ALTER TABLE CondicionAlmacenamientoMedicamento 
ADD CONSTRAINT cond_med_fkey
FOREIGN KEY (id_producto) REFERENCES Medicamento(id_producto);

--Dominio CondALMed
ALTER TABLE CondicionAlmacenamientoMedicamento 
ADD CONSTRAINT cond_med_d1
CHECK(condicion <> '');

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

--Pk Insumo
ALTER TABLE Insumo ADD CONSTRAINT insumo_pkey
PRIMARY KEY (id_producto);

--CondAlmIns(multivaluado)
CREATE TABLE CondicionAlmacenamientoInsumo(
    id_producto INT,
    condicion VARCHAR(100)
);

--Pk CondAlmIns
ALTER TABLE CondicionAlmacenamientoInsumo 
ADD CONSTRAINT cond_insumo_pkey
PRIMARY KEY (id_producto, condicion);

--Fk CondAlmIns
ALTER TABLE CondicionAlmacenamientoInsumo 
ADD CONSTRAINT cond_insumo_fkey
FOREIGN KEY (id_producto) REFERENCES Insumo(id_producto);

--Dominio CondAlmIns
ALTER TABLE CondicionAlmacenamientoInsumo 
ADD CONSTRAINT cond_insumo_d1
CHECK(condicion <> '');

--Proveedor
CREATE TABLE Proveedor(
    numero_proveedor INT,
    razon_social VARCHAR(150),
    calle VARCHAR(100),
    num_int VARCHAR(10),
    num_ext VARCHAR(10),
    colonia VARCHAR(50)
);

--Restricciones Proveedor
ALTER TABLE Proveedor ADD CONSTRAINT proveedor_d1
CHECK(razon_social <> '');
ALTER TABLE Proveedor ADD CONSTRAINT proveedor_d2
CHECK(calle <> '');
ALTER TABLE Proveedor ADD CONSTRAINT proveedor_d3
CHECK(colonia <> '');
ALTER TABLE Proveedor ALTER COLUMN razon_social SET NOT NULL;
ALTER TABLE Proveedor ALTER COLUMN calle SET NOT NULL;

--Pk Proveedor
ALTER TABLE Proveedor ADD CONSTRAINT proveedor_pkey
PRIMARY KEY (numero_proveedor);

--TelefonoProveedor(multivaluado)
CREATE TABLE TelefonoProveedor(
    numero_proveedor INT,
    telefono VARCHAR(15)
);

--Pk TP
ALTER TABLE TelefonoProveedor 
ADD CONSTRAINT tel_proveedor_pkey
PRIMARY KEY (numero_proveedor, telefono);

--Fk TP
ALTER TABLE TelefonoProveedor 
ADD CONSTRAINT tel_proveedor_fkey
FOREIGN KEY (numero_proveedor) REFERENCES Proveedor(numero_proveedor);

--Dominio TP
ALTER TABLE TelefonoProveedor 
ADD CONSTRAINT tel_proveedor_d1
CHECK(telefono <> '');

--Clinica
CREATE TABLE Clinica(
    id_clinica INT,
    id_sucursal INT,
    nombre_clinica VARCHAR(100),
    numero_cuartos INT
);

--Restricciones Clinica
ALTER TABLE Clinica ADD CONSTRAINT clinica_d1
CHECK(nombre_clinica <> '');
ALTER TABLE Clinica ADD CONSTRAINT clinica_d2
CHECK(numero_cuartos >= 0);
ALTER TABLE Clinica ALTER COLUMN nombre_clinica SET NOT NULL;
ALTER TABLE Clinica ALTER COLUMN id_sucursal SET NOT NULL;

--Pk Clinica
ALTER TABLE Clinica ADD CONSTRAINT clinica_pkey
PRIMARY KEY (id_clinica);

--Fk Clinica
ALTER TABLE Clinica ADD CONSTRAINT clinica_fkey
FOREIGN KEY (id_sucursal) REFERENCES Sucursal(id_sucursal);

--HorarioClinica(multivaluado)
CREATE TABLE HorarioClinica(
    id_clinica INT,
    horario VARCHAR(100)
);

--Pk HC
ALTER TABLE HorarioClinica 
ADD CONSTRAINT horario_clinica_pkey
PRIMARY KEY (id_clinica, horario);

--Fk HC
ALTER TABLE HorarioClinica 
ADD CONSTRAINT horario_clinica_fkey
FOREIGN KEY (id_clinica) REFERENCES Clinica(id_clinica);

--Dominio HC
ALTER TABLE HorarioClinica 
ADD CONSTRAINT horario_clinica_d1
CHECK(horario <> '');

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

--Pk Personal
ALTER TABLE Personal ADD CONSTRAINT personal_pkey
PRIMARY KEY (cedula_profesional);

--Fk Personal
ALTER TABLE Personal ADD CONSTRAINT personal_fkey
FOREIGN KEY (id_sucursal) REFERENCES Sucursal(id_sucursal);

--TelefonoPersonal(muLtivaluado)
CREATE TABLE TelefonoPersonal(
    cedula_profesional VARCHAR(20),
    telefono VARCHAR(15)
);

--Pk TP
ALTER TABLE TelefonoPersonal ADD CONSTRAINT tel_personal_pkey
PRIMARY KEY (cedula_profesional, telefono);

--Fk TP
ALTER TABLE TelefonoPersonal ADD CONSTRAINT tel_personal_fkey
FOREIGN KEY (cedula_profesional) REFERENCES Personal(cedula_profesional);

--Dominio TP
ALTER TABLE TelefonoPersonal ADD CONSTRAINT tel_personal_d1
CHECK(telefono <> '');

--CorreoPersonal(multivaluado)
CREATE TABLE CorreoPersonal(
    cedula_profesional VARCHAR(20),
    correo VARCHAR(100)
);

--Pk CP
ALTER TABLE CorreoPersonal ADD CONSTRAINT correo_personal_pkey
PRIMARY KEY (cedula_profesional, correo);

--Fk CP
ALTER TABLE CorreoPersonal ADD CONSTRAINT correo_personal_fkey
FOREIGN KEY (cedula_profesional) REFERENCES Personal(cedula_profesional);

--Dominio CP
ALTER TABLE CorreoPersonal ADD CONSTRAINT correo_personal_d1
CHECK(correo <> '');

--Subtipo: Medico
CREATE TABLE Medico(
    cedula_profesional VARCHAR(20),
    especialidad VARCHAR(100),
    institucion VARCHAR(100),
    vigencia_certificacion DATE
);

--Pk Medico
ALTER TABLE Medico ADD CONSTRAINT medico_pkey
PRIMARY KEY (cedula_profesional);

--Fk Medico
ALTER TABLE Medico ADD CONSTRAINT medico_fkey
FOREIGN KEY (cedula_profesional) REFERENCES Personal(cedula_profesional);

--Subtipo: Enfermera
CREATE TABLE Enfermera(
    cedula_profesional VARCHAR(20),
    tipo_procedimiento VARCHAR(100),
    certificacion_reanimacion BOOLEAN
);

--Pk Enfermera
ALTER TABLE Enfermera ADD CONSTRAINT enfermera_pkey
PRIMARY KEY (cedula_profesional);

--Fk Enfermera
ALTER TABLE Enfermera ADD CONSTRAINT enfermera_fkey
FOREIGN KEY (cedula_profesional) REFERENCES Personal(cedula_profesional);

--Subtipo: Farmaceutico
CREATE TABLE Farmaceutico(
    cedula_profesional VARCHAR(20)
);

--Pk Farmaceutico
ALTER TABLE Farmaceutico ADD CONSTRAINT farmaceutico_pkey
PRIMARY KEY (cedula_profesional);

--Fk Farmaceutico
ALTER TABLE Farmaceutico ADD CONSTRAINT farmaceutico_fkey
FOREIGN KEY (cedula_profesional) REFERENCES Personal(cedula_profesional);

--Ticket
CREATE TABLE Ticket(
    id_ticket INT,
    id_cliente INT,
    id_sucursal INT,
    fecha DATE,
    hora TIME
);

--Restricciones Ticket
ALTER TABLE Ticket ADD CONSTRAINT ticket_d1
CHECK(fecha IS NOT NULL);
ALTER TABLE Ticket ADD CONSTRAINT ticket_d2
CHECK(hora IS NOT NULL);
ALTER TABLE Ticket ALTER COLUMN id_cliente SET NOT NULL;
ALTER TABLE Ticket ALTER COLUMN id_sucursal SET NOT NULL;
ALTER TABLE Ticket ALTER COLUMN fecha SET NOT NULL;
ALTER TABLE Ticket ALTER COLUMN hora SET NOT NULL;

--Pk Ticket
ALTER TABLE Ticket ADD CONSTRAINT ticket_pkey
PRIMARY KEY (id_ticket);

--Fk Ticket-Cliente
ALTER TABLE Ticket ADD CONSTRAINT ticket_cliente_fkey
FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente);

--Fk Ticket-Sucursal
ALTER TABLE Ticket ADD CONSTRAINT ticket_sucursal_fkey
FOREIGN KEY (id_sucursal) REFERENCES Sucursal(id_sucursal);

--ConsultaMedico
CREATE TABLE ConsultaMedico(
    id_consulta INT,
    id_ticket INT,
    cedula_profesional VARCHAR(20),
    precio NUMERIC(10,2),
    fecha DATE,
    hora TIME,
    diagnostico TEXT
);

--Restricciones CM
ALTER TABLE ConsultaMedico ADD CONSTRAINT cm_d1
CHECK(precio >= 0);
ALTER TABLE ConsultaMedico ALTER COLUMN id_ticket SET NOT NULL;
ALTER TABLE ConsultaMedico ALTER COLUMN cedula_profesional SET NOT NULL;
ALTER TABLE ConsultaMedico ALTER COLUMN fecha SET NOT NULL;
ALTER TABLE ConsultaMedico ALTER COLUMN hora SET NOT NULL;

--Pk CM
ALTER TABLE ConsultaMedico ADD CONSTRAINT cm_pkey
PRIMARY KEY (id_consulta);

--Fk a Ticket
ALTER TABLE ConsultaMedico ADD CONSTRAINT cm_ticket_fkey
FOREIGN KEY (id_ticket) REFERENCES Ticket(id_ticket);

--FK a Medico
ALTER TABLE ConsultaMedico ADD CONSTRAINT cm_medico_fkey
FOREIGN KEY (cedula_profesional) REFERENCES Medico(cedula_profesional);

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

--Restricciones Receta
ALTER TABLE Receta ADD CONSTRAINT receta_d1
CHECK(peso >= 0 AND talla >= 0);
ALTER TABLE Receta ALTER COLUMN id_consulta SET NOT NULL;

--Pk Receta
ALTER TABLE Receta ADD CONSTRAINT receta_pkey
PRIMARY KEY (numero_receta);

--Fk Receta
ALTER TABLE Receta ADD CONSTRAINT receta_fkey
FOREIGN KEY (id_consulta) REFERENCES ConsultaMedico(id_consulta);

--ConsultaEnfermera
CREATE TABLE ConsultaEnfermera(
    id_consulta INT,
    id_ticket INT,
    cedula_profesional VARCHAR(20),
    precio NUMERIC(10,2),
    fecha DATE,
    hora TIME,
    diagnostico TEXT
);

--Restricciones CE
ALTER TABLE ConsultaEnfermera ADD CONSTRAINT ce_d1
CHECK(precio >= 0);
ALTER TABLE ConsultaEnfermera ALTER COLUMN id_ticket SET NOT NULL;
ALTER TABLE ConsultaEnfermera ALTER COLUMN cedula_profesional SET NOT NULL;
ALTER TABLE ConsultaEnfermera ALTER COLUMN fecha SET NOT NULL;
ALTER TABLE ConsultaEnfermera ALTER COLUMN hora SET NOT NULL;

--Pk CE
ALTER TABLE ConsultaEnfermera ADD CONSTRAINT ce_pkey
PRIMARY KEY (id_consulta);

--Fk a Ticket
ALTER TABLE ConsultaEnfermera ADD CONSTRAINT ce_ticket_fkey
FOREIGN KEY (id_ticket) REFERENCES Ticket(id_ticket);

--Fk a Enfermera
ALTER TABLE ConsultaEnfermera ADD CONSTRAINT ce_enfermera_fkey
FOREIGN KEY (cedula_profesional) REFERENCES Enfermera(cedula_profesional);

--Apartir de aqui
--RELACIONES
--IncluirMedicamento
CREATE TABLE IncluirMedicamento(
    id_ticket INT,
    id_producto INT,
    cantidad INT
);

--PK IM
ALTER TABLE IncluirMedicamento ADD CONSTRAINT inc_med_pkey
PRIMARY KEY (id_ticket, id_producto);

--FKs IM
ALTER TABLE IncluirMedicamento ADD CONSTRAINT inc_med_ticket_fkey
FOREIGN KEY (id_ticket) REFERENCES Ticket(id_ticket);

ALTER TABLE IncluirMedicamento ADD CONSTRAINT inc_med_producto_fkey
FOREIGN KEY (id_producto) REFERENCES Medicamento(id_producto);

--Dominio IM
ALTER TABLE IncluirMedicamento ADD CONSTRAINT inc_med_d1
CHECK(cantidad > 0);

--IncluirInsumo
CREATE TABLE IncluirInsumo(
    id_ticket INT,
    id_producto INT,
    cantidad INT
);

--PK II
ALTER TABLE IncluirInsumo ADD CONSTRAINT inc_insumo_pkey
PRIMARY KEY (id_ticket, id_producto);

--FKs II
ALTER TABLE IncluirInsumo ADD CONSTRAINT inc_insumo_ticket_fkey
FOREIGN KEY (id_ticket) REFERENCES Ticket(id_ticket);

ALTER TABLE IncluirInsumo ADD CONSTRAINT inc_insumo_producto_fkey
FOREIGN KEY (id_producto) REFERENCES Insumo(id_producto);

--Dominio II
ALTER TABLE IncluirInsumo ADD CONSTRAINT inc_insumo_d1
CHECK(cantidad > 0);

--ProveerMedicamento
CREATE TABLE ProveerMedicamento(
    numero_proveedor INT,
    id_producto INT,
    id_sucursal INT,
    cantidad INT
);

--PK PM
ALTER TABLE ProveerMedicamento ADD CONSTRAINT prov_med_pkey
PRIMARY KEY (numero_proveedor, id_producto, id_sucursal);

--FKs PM
ALTER TABLE ProveerMedicamento ADD CONSTRAINT prov_med_proveedor_fkey
FOREIGN KEY (numero_proveedor) REFERENCES Proveedor(numero_proveedor);

ALTER TABLE ProveerMedicamento ADD CONSTRAINT prov_med_producto_fkey
FOREIGN KEY (id_producto) REFERENCES Medicamento(id_producto);

ALTER TABLE ProveerMedicamento ADD CONSTRAINT prov_med_sucursal_fkey
FOREIGN KEY (id_sucursal) REFERENCES Sucursal(id_sucursal);

--Dominio PM
ALTER TABLE ProveerMedicamento ADD CONSTRAINT prov_med_d1
CHECK(cantidad >= 0);

--ProveerInsumo
CREATE TABLE ProveerInsumo(
    numero_proveedor INT,
    id_producto INT,
    id_sucursal INT,
    cantidad INT
);

--PK PI
ALTER TABLE ProveerInsumo ADD CONSTRAINT prov_insumo_pkey
PRIMARY KEY (numero_proveedor, id_producto, id_sucursal);

--FKs PI
ALTER TABLE ProveerInsumo ADD CONSTRAINT prov_insumo_proveedor_fkey
FOREIGN KEY (numero_proveedor) REFERENCES Proveedor(numero_proveedor);

ALTER TABLE ProveerInsumo ADD CONSTRAINT prov_insumo_producto_fkey
FOREIGN KEY (id_producto) REFERENCES Insumo(id_producto);

ALTER TABLE ProveerInsumo ADD CONSTRAINT prov_insumo_sucursal_fkey
FOREIGN KEY (id_sucursal) REFERENCES Sucursal(id_sucursal);

--Dominio PI
ALTER TABLE ProveerInsumo ADD CONSTRAINT prov_insumo_d1
CHECK(cantidad >= 0);

--Preparar
CREATE TABLE Preparar(
    cedula_profesional VARCHAR(20),
    id_producto INT,
    cantidad INT
);

--PK Preparar
ALTER TABLE Preparar ADD CONSTRAINT preparar_pkey
PRIMARY KEY (cedula_profesional, id_producto);

--FK a Farmaceutico
ALTER TABLE Preparar ADD CONSTRAINT preparar_farmaceutico_fkey
FOREIGN KEY (cedula_profesional) REFERENCES Farmaceutico(cedula_profesional);

--FK a Medicamento
ALTER TABLE Preparar ADD CONSTRAINT preparar_producto_fkey
FOREIGN KEY (id_producto) REFERENCES Medicamento(id_producto);

--Dominio Preparar
ALTER TABLE Preparar ADD CONSTRAINT preparar_d1
CHECK(cantidad > 0);


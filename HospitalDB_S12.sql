
/****MÓDULO I: CREACIÓN****/
--Si existe se borra y si no se crea
USE MASTER;
GO

IF DB_ID('HospitalDB') IS NOT NULL
BEGIN
	ALTER DATABASE HospitalDB
	SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

	DROP DATABASE IF EXISTS HospitalDB;
END
GO

CREATE DATABASE HospitalDB;
GO

USE HospitalDB;
GO

--Consulta para enseñar todas las bases de datos
SELECT name
FROM sys.databases;
GO

--Seleccionar base de datos
USE HospitalDB;
GO

--Creación de tabla especialidades
CREATE TABLE Especialidades(
	id_especialidades INT IDENTITY(1,1),
	nombre VARCHAR(50) NOT NULL,
	CONSTRAINT PK_Especialidades PRIMARY KEY(id_especialidades)
);

--Tabla pacientes
CREATE TABLE Pacientes(
	id_paciente INT IDENTITY(1,1),
	nombre VARCHAR(50) NOT NULL,
	apellido VARCHAR(50) NOT NULL,
	edad INT,
	correo VARCHAR(100) NOT NULL,
	fecha_registro DATETIME DEFAULT GETDATE(),

	CONSTRAINT PK_Pacientes PRIMARY KEY(id_paciente),
	CONSTRAINT UQ_Pacientes_correo UNIQUE(correo),
	CONSTRAINT CHK_Paciente_Edad CHECK(edad >= 0)
);

--Tabla medicos
CREATE TABLE Medicos(
	id_medico INT IDENTITY(1,1),
	nombre VARCHAR(50) NOT NULL,
	apellido VARCHAR(50) NOT NULL,
	salario DECIMAL(10,2),
	edad INT,
	correo VARCHAR(100) NOT NULL,
	id_especialidades INT,

	CONSTRAINT PK_Medicos PRIMARY KEY(id_medico),
	CONSTRAINT UQ_Medicos_correo UNIQUE(correo),
	CONSTRAINT CHK_Medicos_salario CHECK(salario >= 0),
	CONSTRAINT CHK_Medicos_edad CHECK(edad >= 0),

	CONSTRAINT FK_Medicos_Especialidades
		FOREIGN KEY(id_especialidades)
		REFERENCES Especialidades(id_especialidades)
);

-- Tabla Citas
CREATE TABLE Citas(
    id_cita INT IDENTITY(1,1),
    fecha_cita DATETIME,
    id_paciente INT,
    id_medico INT,

    CONSTRAINT PK_Citas PRIMARY KEY(id_cita),

    CONSTRAINT FK_Citas_Pacientes
        FOREIGN KEY(id_paciente)
        REFERENCES Pacientes(id_paciente),

    CONSTRAINT FK_Citas_Medicos
        FOREIGN KEY(id_medico)
        REFERENCES Medicos(id_medico)
);

-- Tabla Tratamientos
CREATE TABLE Tratamientos(
    id_tratamiento INT IDENTITY(1,1),
    descripcion VARCHAR(200),
    estado VARCHAR(20),
    id_paciente INT,

    CONSTRAINT PK_Tratamientos PRIMARY KEY(id_tratamiento),

    CONSTRAINT FK_Tratamientos_Pacientes
        FOREIGN KEY(id_paciente)
        REFERENCES Pacientes(id_paciente)
);

-- Tabla Medicamentos
CREATE TABLE Medicamentos(
    id_medicamento INT IDENTITY(1,1),
    nombre VARCHAR(100),
    fecha_vencimiento DATE,
    id_tratamiento INT,

    CONSTRAINT PK_Medicamentos PRIMARY KEY(id_medicamento),

    CONSTRAINT FK_Medicamentos_Tratamientos
        FOREIGN KEY(id_tratamiento)
        REFERENCES Tratamientos(id_tratamiento)
);

--Tabla de habitaciones
CREATE TABLE Habitaciones(
	id_habitacion INT IDENTITY(1,1),
	numero_habitacion VARCHAR(10) NOT NULL,
	tipo_habitacion VARCHAR(50) NOT NULL,
    id_paciente INT,

    CONSTRAINT PK_Habitaciones PRIMARY KEY(id_habitacion),
	CONSTRAINT CHK_Habitaciones_numero_habitacion CHECK(numero_habitacion LIKE('[A-Z][0-9][0-9][0-9]')),
	CONSTRAINT CHK_Habitaciones_tipo_habitacion CHECK(tipo_habitacion IN('General', 'Privada', 'UCI', 'Emergencia', 'Maternidad')),

    CONSTRAINT FK_Habitaciones_Pacientes
        FOREIGN KEY(id_paciente)
        REFERENCES Pacientes(id_paciente)
);
GO



/****MÓDULO III: ALTER****/
-- Pacientes
ALTER TABLE Pacientes ADD telefono VARCHAR(20);

ALTER TABLE Pacientes ADD direccion VARCHAR(150);

ALTER TABLE Pacientes ADD genero VARCHAR(20);

ALTER TABLE Pacientes ADD tipo_sangre VARCHAR(5);

ALTER TABLE Pacientes ADD fecha_nacimiento DATE;

ALTER TABLE Pacientes ALTER COLUMN nombre VARCHAR(100);

ALTER TABLE Pacientes ALTER COLUMN direccion VARCHAR(250);

-- Médicos
ALTER TABLE Medicos ADD experiencia INT;

ALTER TABLE Medicos ADD turno VARCHAR(20);

ALTER TABLE Medicos ADD observaciones VARCHAR(200);

ALTER TABLE Medicos DROP COLUMN observaciones;

-- Citas
ALTER TABLE Citas ADD estado VARCHAR(20);

ALTER TABLE Citas ADD costo_consulta FLOAT;

ALTER TABLE Citas ALTER COLUMN costo_consulta DECIMAL(10,2);

-- Habitaciones
ALTER TABLE Habitaciones ADD disponibilidad BIT;

GO



/****MÓDULO IV: DROP****/
-- Tabla temporal
CREATE TABLE Temporal(id INT);
DROP TABLE Temporal;

-- Eliminar CHECK
ALTER TABLE Pacientes DROP CONSTRAINT CHK_Pacientes_Edad;

-- Eliminar UNIQUE
ALTER TABLE Pacientes DROP CONSTRAINT UQ_Pacientes_Correo;

-- Eliminar columna
ALTER TABLE Pacientes DROP COLUMN genero;

-- Tabla de pruebas
CREATE TABLE Pruebas(id INT);
DROP TABLE Pruebas;

-- Auditoria
CREATE TABLE Auditoria(id INT);
DROP TABLE Auditoria;

-- Logs
CREATE TABLE Logs(id INT);
DROP TABLE Logs;

-- Eliminar FK
ALTER TABLE Habitaciones DROP CONSTRAINT FK_Habitaciones_Pacientes;

-- Tabla MedicamentosPrueba
CREATE TABLE MedicamentosPrueba(id INT);
DROP TABLE MedicamentosPrueba;

-- Base de datos prueba
CREATE DATABASE HospitalDB;
GO

DROP DATABASE HospitalDB;
GO


/****MÓDULO V: INSERT****/
--Especialidades
INSERT INTO Especialidades(nombre)
VALUES
('Cardiologia'),
('Pediatria'),
('Neurologia'),
('Dermatologia'),
('Ginecologia');

--Medicos
INSERT INTO Medicos(nombre,apellido,salario,edad,correo,id_especialidades)
VALUES
('Juan','Perez',1200,40,'juan@hospital.com',1),
('Maria','Lopez',1500,38,'maria@hospital.com',2),
('Carlos','Ruiz',1800,45,'carlos@hospital.com',3),
('Ana','Gomez',1300,35,'ana@hospital.com',4),
('Pedro','Torres',1600,42,'pedro@hospital.com',5),
('Jose','Cruz',1700,44,'jose@hospital.com',1),
('Laura','Silva',1900,39,'laura@hospital.com',2),
('Mario','Diaz',2000,50,'mario@hospital.com',3),
('Lucia','Vega',1400,37,'lucia@hospital.com',4),
('Sofia','Ramos',2100,46,'sofia@hospital.com',5);

--Pacientes
INSERT INTO Pacientes(nombre,apellido,edad,correo)
VALUES
('Luis','Martinez',20,'l1@gmail.com'),('Ana','Lopez',21,'l2@gmail.com'),
('Pedro','Perez',22,'l3@gmail.com'),('Jose','Ruiz',23,'l4@gmail.com'),
('Maria','Silva',24,'l5@gmail.com'),('Carlos','Torres',25,'l6@gmail.com'),
('Rosa','Gomez',26,'l7@gmail.com'),('Miguel','Diaz',27,'l8@gmail.com'),
('Luisa','Mora',28,'l9@gmail.com'),('Jorge','Castro',29,'l10@gmail.com'),
('Kevin','Reyes',30,'l11@gmail.com'),('Julia','Vega',31,'l12@gmail.com'),
('Sonia','Perez',32,'l13@gmail.com'),('Marco','Ruiz',33,'l14@gmail.com'),
('Diana','Lopez',34,'l15@gmail.com'),('Pablo','Silva',35,'l16@gmail.com'),
('Marta','Gomez',36,'l17@gmail.com'),('Diego','Diaz',37,'l18@gmail.com'),
('Elena','Torres',38,'l19@gmail.com'),('Victor','Mora',39,'l20@gmail.com');

--Citas
INSERT INTO Citas(fecha_cita,id_paciente,id_medico)
VALUES
(GETDATE(),1,1),(GETDATE(),2,2),(GETDATE(),3,3),(GETDATE(),4,4),(GETDATE(),5,5),
(DATEADD(DAY,1,GETDATE()),6,6),(DATEADD(DAY,2,GETDATE()),7,7),(DATEADD(DAY,3,GETDATE()),8,8),
(DATEADD(DAY,4,GETDATE()),9,9),(DATEADD(DAY,5,GETDATE()),10,10),
(GETDATE(),11,1),(GETDATE(),12,2),(GETDATE(),13,3),(GETDATE(),14,4),(GETDATE(),15,5);




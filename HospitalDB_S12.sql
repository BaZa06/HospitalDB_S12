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


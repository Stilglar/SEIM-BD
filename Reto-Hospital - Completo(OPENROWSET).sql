USE Hospital
GO

/*COMENTARIOS DEL ALUMNO: He cambiado el tipo de datos de las columnas que son el origen de una FK. Lo he hecho para que el tipo de dato sea el mismo*/

CREATE SCHEMA hosp
GO

/****************************************************************
********************   CREACION DE TABLAS   *********************
****************************************************************/

--Tabla de pacientes
CREATE TABLE hosp.pacientes (	numSegSocial char(15),
								nombre varchar(15),
								apellidos varchar(30),
								domicilio varchar(30),
								poblacion varchar(25),
								provincia varchar(15),
								CP char(5),
								telefono char(12),
								numHistorial char(15) PRIMARY KEY,
								sexo char(1) CHECK (sexo='H' OR sexo='M' OR sexo='O'),
                                foto varbinary(MAX))

--Tabla de medicos
CREATE TABLE hosp.medicos (	IDMedico varchar(4) PRIMARY KEY,
							nombre varchar(15),
							apellido varchar(30),
							especialidad varchar(25),
							fechaPosesionPlaza date,
							cargo varchar(25),
							numColegiado smallint,
							observaciones varchar(MAX))

--Tabla de Ingresos
CREATE TABLE hosp.ingresos (numIngreso int PRIMARY KEY IDENTITY (1,1),
							numHistorial char(15) CONSTRAINT FK_ingresosPacientes FOREIGN KEY REFERENCES hosp.pacientes(numHistorial),
							fechaIngreso date,
							IDMedico varchar(4) CONSTRAINT FK_ingresosMedicos FOREIGN KEY REFERENCES hosp.medicos(IDMedico),
							numPlanta tinyint CHECK (numPlanta<=10),
							numCama tinyint CHECK (numCama<=200),
							alergias char(2),
							observaciones varchar(MAX),
							coste money,
							diagnostico varchar(40))

/****************************************************************
********************   INSERCION DE DATOS   *********************
****************************************************************/

--Insercion de datos en la tabla medicos
INSERT INTO hosp.medicos (IDMedico,nombre,apellido,especialidad,fechaPosesionPlaza,cargo,numColegiado,observaciones)
VALUES ('AJH','Antonio','Jaen Hernandez','Pediatria','12/08/82','Adjunto',2113,'A punto de jubilarse')

INSERT INTO hosp.medicos (IDMedico,nombre,apellido,especialidad,fechaPosesionPlaza,cargo,numColegiado)
VALUES ('CEM','Carmen','Esterill Manrique','Psiquiatria','13/02/92','Jefe de Seccion',1231)

INSERT INTO hosp.medicos (IDMedico,nombre,apellido,especialidad,fechaPosesionPlaza,cargo,numColegiado)
VALUES ('RLQ','Rocio','Lopez Quijada','Medico de familia','23/09/94','Titular',1331)

--Insercion de datos en la tabla pacientes
INSERT INTO hosp.pacientes(numSegSocial,nombre,apellidos,domicilio,poblacion,provincia,CP,telefono,numHistorial,sexo,foto)
VALUES ('08/7888888','Jose Eduardo','Romerales Pinto','C/ Azorin 34 3o','Mostoles','Madrid',28935,'91-345-87-45','10203-F','H',
            (SELECT * FROM OPENROWSET(BULK 'C:\Users\Sands\Desktop\Fotos\1.txt', SINGLE_BLOB) AS foto))

INSERT INTO hosp.pacientes(numSegSocial,nombre,apellidos,domicilio,poblacion,provincia,CP,telefono,numHistorial,sexo,foto)
VALUES ('08/7234823','Angel','Ruiz Picasso','C/ Salmeron, 212','Madrid','Madrid',28028,'91-565-34-33','11454-L','H',
            (SELECT * FROM OPENROWSET(BULK 'C:\Users\Sands\Desktop\Fotos\2.txt', SINGLE_BLOB) AS foto))

INSERT INTO hosp.pacientes(numSegSocial,nombre,apellidos,domicilio,poblacion,provincia,CP,telefono,numHistorial,sexo,foto)
VALUES ('08/7333333','Mercedes','Romero Carvajal','C/ Malaga, 13',' Mostoles','Madrid',28935,'91-455-67-45','14546-E','M',
            (SELECT * FROM OPENROWSET(BULK 'C:\Users\Sands\Desktop\Fotos\3.txt', SINGLE_BLOB) AS foto))

INSERT INTO hosp.pacientes(numSegSocial,nombre,apellidos,domicilio,poblacion,provincia,CP,telefono,numHistorial,sexo,foto)
VALUES ('08/7555555','Martin','Fernandez Lopez','C/ Sastres, 21','Madrid','Madrid',28028,'91-333-33-33','15413-S','H',
            (SELECT * FROM OPENROWSET(BULK 'C:\Users\Sands\Desktop\Fotos\4.txt', SINGLE_BLOB) AS foto))

--Insercion de datos en la tabla ingresos
INSERT INTO hosp.ingresos (numHistorial,fechaIngreso,IDMedico,numPlanta,numCama,alergias,observaciones)
VALUES ('10203-F','23/01/2009','AJH',5,121,'No','Epileptico')

INSERT INTO hosp.ingresos (numHistorial,fechaIngreso,IDMedico,numPlanta,numCama,alergias,observaciones)
VALUES ('15413-S','13/03/2009','RLQ',2,5,'Si','Alergico a la Penicilina')

INSERT INTO hosp.ingresos (numHistorial,fechaIngreso,IDMedico,numPlanta,numCama,alergias)
VALUES ('11454-L','25/05/2009','RLQ',3,31,'No')

INSERT INTO hosp.ingresos (numHistorial,fechaIngreso,IDMedico,numPlanta,numCama,alergias)
VALUES ('15413-S','29/01/2010','CEM',2,13,'No')

INSERT INTO hosp.ingresos (numHistorial,fechaIngreso,IDMedico,numPlanta,numCama,alergias,observaciones)
VALUES ('14546-E','24/02/2010','AJH',1,5,'Si','Alergico a la Paidoterin')

GO

/****************************************************************
****************   CREACION DE PROCEDIMIENTOS   *****************
****************************************************************/

--Procedimiento para insertar los datos de un nuevo medico
CREATE PROCEDURE hosp.pr_nuevoMedico
    @p_nombre varchar(15),
    @p_apellidos varchar(30),
    @p_especialidad varchar(25),
    @p_cargo varchar(25),
    @p_numColegiado SMALLINT,
    @p_observaciones varchar(MAX)
    AS

    BEGIN
        IF @p_numColegiado NOT BETWEEN 0 AND 999
        BEGIN
            INSERT INTO hosp.medicos (  nombre,
                                        apellido,
                                        especialidad,
                                        fechaPosesionPlaza,
                                        cargo,
                                        numColegiado,
                                        observaciones)
            VALUES (@p_nombre,
                    @p_apellidos,
                    @p_especialidad,
                    GETDATE(),
                    @p_cargo,
                    @p_numColegiado,
                    @p_observaciones)
        END
        ELSE
        BEGIN
            PRINT 'El numero de colegiado no es valido.'
        END
    END
GO
--Procecimiento para mostrar los datos de los pacientes ingresados entre dos fechas
CREATE PROCEDURE hosp.pr_ingresadosEntreFechas
    @p_fechaInicio DATE,
    @p_fechaFinal DATE
    
    AS

    BEGIN
        SELECT P.apellidos, P.nombre, P.sexo, I.fechaIngreso, I.numPlanta, I.numCama, I.alergias, I.observaciones
        FROM hosp.pacientes AS P
        JOIN hosp.ingresos AS I
        ON P.numHistorial = I.numHistorial
        WHERE I.fechaIngreso BETWEEN @p_fechaInicio AND @p_fechaFinal
    END

GO

/****************************************************************
*******************   CREACION DE FUNCIONES   *******************
****************************************************************/

--Funcion para contar el numero de pacientes ingresados
CREATE FUNCTION hosp.fContarPacientes
(

)
RETURNS INT
AS
BEGIN
    DECLARE @Resultado smallint

    SET @Resultado = (  SELECT COUNT(numHistorial)
                        FROM hosp.pacientes)
    RETURN @Resultado
END

GO
--Funcion para contar el numero de pacientes ingresados separados por sexo
CREATE FUNCTION hosp.fpacientesPorSexo
(

)
RETURNS TABLE
AS
RETURN
(
    SELECT COUNT(numHistorial) AS 'Numero de Pacientes', sexo
    FROM hosp.pacientes
    GROUP BY sexo
)

GO

/****************************************************************
*************************   CONSULTAS   *************************
****************************************************************/

--Consulta 1
SELECT nombre, fechaPosesionPlaza
FROM hosp.medicos
WHERE especialidad='Pediatria'
--Consulta 2
SELECT nombre
FROM hosp.pacientes
WHERE poblacion='Madrid'
--Consulta 3
SELECT M.nombre
FROM hosp.ingresos AS I
JOIN hosp.medicos AS M
ON I.IDMedico=M.IDMedico
WHERE I.fechaIngreso BETWEEN '01/01/2010' AND '28/02/2010'
--Consulta 4
SELECT P.nombre, P.apellidos
FROM hosp.ingresos AS I
JOIN hosp.pacientes AS P
ON I.numHistorial=P.numHistorial
WHERE (I.fechaIngreso BETWEEN '01/01/2009' AND '31/05/2010') AND (I.alergias='Si')
--Consulta 5 (version con doble JOIN)
SELECT P.nombre, P.apellidos
FROM hosp.ingresos AS I
JOIN hosp.pacientes AS P
ON I.numHistorial=P.numHistorial
JOIN hosp.medicos AS M
ON I.IDMedico = M.IDMedico
WHERE M.nombre = 'Antonio' AND M.apellido = 'Jaen Hernandez'
--Consulta 5 (version con subselect)
/*
SELECT P.nombre, P.apellidos
FROM hosp.ingresos AS I
JOIN hosp.pacientes AS P
ON I.numHistorial=P.numHistorial
WHERE IDMedico=(SELECT IDMedico
				FROM hosp.medicos
				WHERE nombre='Antonio' AND apellido='Jaen Hernandez')
*/

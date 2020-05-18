-- Cursores


CREATE TABLE Juegos ( 
 idJuego int identity(1,1) primary key, 
 Titulo varchar(100), 
 Descripción varchar(max),
 FechadeEstreno datetime
); 


-- OJO mis fechas estan en formato USA
DBCC USEROPTIONS


INSERT INTO Juegos (Titulo, Descripción, FechadeEstreno )
VALUES('Fornite', 'Fortnite es un videojuego del año 2017 desarrollado por la empresa Epic Games, lanzado como diferentes paquetes de software que presentan diferentes modos de juego, pero que comparten el mismo motor general de juego y las mecánicas', '6/21/2017')


INSERT INTO Juegos (Titulo, Descripción, FechadeEstreno )
VALUES('Minecraft', 'Minecraft es un videojuego de construcción, de tipo «mundo abierto» o sandbox creado originalmente por el sueco Markus Persson, ​ y posteriormente desarrollado por su empresa, Mojang AB', '5/6/2010')

INSERT INTO Juegos (Titulo, Descripción, FechadeEstreno )
VALUES('Roblox', 'Roblox es una plataforma multijugador en línea en la que los usuarios pueden crear sus propios mundos virtuales', '1/1/2005')

SELECT * FROM Juegos

/*
Declarar el cursor, utilizando DECLARE 
Abrir el cursor, utilizando OPEN  
Leer los datos del cursor, utilizando FETCH ... INTO 
Cerrar el cursor, utilizando CLOSE 
Liberar el cursor, utilizando DEALLOCATE
*/

SELECT * FROM Juegos

declare @Titulo VARCHAR(100)
declare @Descripción varchar(max)

DECLARE cursor_juegos CURSOR FOR

SELECT Titulo, Descripción FROM Juegos

OPEN cursor_juegos

-- rellenar las variables con datos del cursor
FETCH NEXT FROM cursor_juegos into @Titulo, @Descripción

WHILE @@FETCH_STATUS = 0
	BEGIN
		-- Hacer algo aqui con las variables de la fila
		print @Titulo 
		print @Descripción
        print '------------------------------'
		FETCH NEXT FROM cursor_juegos into @Titulo, @Descripción
	END 



CLOSE cursor_juegos
DEALLOCATE cursor_juegos



-- 2. Usando tipos de CURSORES
declare @Titulo VARCHAR(100)
declare @Descripción varchar(max)

DECLARE cursor_juegos CURSOR SCROLL FOR

SELECT Titulo, Descripción FROM Juegos

OPEN cursor_juegos

--
/*
FORWARD_ONLY - Specifies that the cursor can only be scrolled from the first to the last row.
SCROLL - It provides 6 options to fetch the data (FIRST, LAST, PRIOR, NEXT, RELATIVE and ABSOLUTE).
*/

--Con SCROLL, puedo ir a diferentes filas usando FIRST, LAST, PRIOR, NEXT, RELATIVE, ABSOLUTE
FETCH FIRST FROM cursor_juegos INTO @Titulo, @Descripción 
print 'primera fila'
print @Titulo
print @Descripción

print '--------------------------'


FETCH LAST FROM cursor_juegos INTO @Titulo, @Descripción  
print 'ultima fila'
print @Titulo
print @Descripción 

FETCH FIRST FROM cursor_juegos INTO @Titulo, @Descripción 
print 'primera fila'
print @Titulo
print @Descripción

print '--------------------------'

CLOSE cursor_juegos
DEALLOCATE cursor_juegos

---------------------
-- ACTIVIDADES

CREATE TABLE [dbo].[Estudiantes](  
    [Estudiante_ID] [int] NOT NULL,  
    [Nombre] [nvarchar](50) NOT NULL,  
    [Saldo] [int] NOT NULL,  
    [Ciudad] [nvarchar](50) NOT NULL
)

  
GO  

Insert into Estudiantes  
Select 1,'Pankaj',25000,'Donostia' Union All  
Select 2,'Raul',21000,'Bilbao' Union All  
Select 3,'Sandeep',25000,'Valencia' Union All  
Select 4,'Sanjeev',24000,'Madrid' Union All  
Select 5,'Neeraj',28000,'Bilbao' Union All  
Select 6,'Naru',20000,'Valencia' Union All  
Select 7,'Omi',23000,'Donostia'   


SELECT * FROM Estudiantes

-- Usando CURSORes, llevar a cabo las actividades:
-- Actividad 1: Imprimir los alumnos de Bilbao en formato CSV e.g 2,Rahul,Bilboa 
-- Actividad 2: Cambiar la actividad 2 para IMPRIMIR el Saldo mas 10%, solo en el caso  que
-- el Saldo es mayor a 23,000. e.g. 1,Pankaj,Donostia,27500

-- Actividad 1
--********************************
DECLARE @IDestudiante int
DECLARE @nombre varchar(50)
DECLARE @apellido varchar(50)

DECLARE cursEstudiantes CURSOR FOR

SELECT Estudiante_ID, Nombre, Ciudad
FROM dbo.Estudiantes
WHERE Ciudad = 'Bilbao'

OPEN cursEstudiantes

FETCH NEXT FROM cursEstudiantes INTO @IDestudiante, @nombre, @apellido

WHILE @@FETCH_STATUS = 0
	BEGIN
	PRINT CAST(@IDestudiante AS varchar(20)) + ',' + @nombre + ',' + @apellido
	PRINT '__________________________'
	FETCH NEXT FROM cursEstudiantes INTO @IDestudiante, @nombre, @apellido
	END

CLOSE cursEstudiantes
DEALLOCATE cursEstudiantes

-- Actividad 2
--********************************
DECLARE @IDestudiante int
DECLARE @nombre varchar(50)
DECLARE @apellido varchar(50)
DECLARE @saldo money

DECLARE cursEstudiantes CURSOR FOR

SELECT Estudiante_ID, Nombre, Ciudad, Saldo
FROM dbo.Estudiantes
WHERE Ciudad = 'Bilbao'

OPEN cursEstudiantes

FETCH NEXT FROM cursEstudiantes INTO @IDestudiante, @nombre, @apellido, @saldo

WHILE @@FETCH_STATUS = 0
	BEGIN
	IF @saldo > 23000
		BEGIN
		PRINT CAST(@IDestudiante AS varchar(20)) + ',' + @nombre + ',' + @apellido + ',' + CAST(@saldo * 1.1 AS varchar(20))
		PRINT '__________________________'
		END
	FETCH NEXT FROM cursEstudiantes INTO @IDestudiante, @nombre, @apellido
		
	END

CLOSE cursEstudiantes
DEALLOCATE cursEstudiantes

USE [RepuestosWeb_DWH]
GO

--Creamos tabla para log de fact batches
CREATE TABLE FactLog
(
	ID_Batch UNIQUEIDENTIFIER DEFAULT(NEWID()),
	FechaEjecucion DATETIME DEFAULT(GETDATE()),
	NuevosRegistros INT,
	CONSTRAINT [PK_FactLog] PRIMARY KEY
	(
		ID_Batch
	)
)
GO

--Actualizamos nuestra columna de ID_batch
update fact.Orden
set ID_Batch = newid()
go

--select * from Fact.Orden
go

--Insertamos el entry en factlog para el registro que ya existe
INSERT INTO FactLog VALUES (newid(),'1900-07-01 21:52:37.500',1)
go

--select * from FactLog
go

--Transformamos nuestra columna a UNIQUEID
ALTER TABLE Fact.Orden
ALTER COLUMN ID_Batch UNIQUEIDENTIFIER
GO


--Agregamos FK
ALTER TABLE Fact.Orden ADD CONSTRAINT [FK_IDBatch] FOREIGN KEY (ID_Batch) 
REFERENCES Factlog(ID_Batch)
go


/****** Object:  Table [staging].[Examen]    Script Date: 8/31/2020 6:34:39 PM ******/
create schema [staging]
go

DROP TABLE IF EXISTS [staging].[Orden]
GO

CREATE TABLE [staging].[Orden](
	ID_Orden [int] null,
	ID_Cliente [int] null,
	ID_Ciudad [int] null,
	ID_DetalleOrden [int] null,
	ID_Parte varchar(50) null,
	ID_Descuento [int] null,
	VehiculoID [int] null,
	ID_StatusOrden [int] null,
	Total_Orden [decimal](12, 2) NULL,
	Fecha_Orden DATETIME null,
	NumeroOrden varchar(20) null,
	Cantidad int null,
	FechaModificacionSource datetime null
) ON [PRIMARY]
GO

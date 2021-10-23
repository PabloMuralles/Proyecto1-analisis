--Queries para llenar datos

--Dimensiones
	--DimCliente
	select C.ID_Cliente,
			C.PrimerNombre,
			C.SegundoNombre,
			C.PrimerApellido,
			C.SegundoApellido,
			C.Genero,
			C.Correo_Electronico,
			C.FechaNacimiento,
			C.Direccion
			--Columnas Auditoria
			,GETDATE() AS FechaCreacion
			,CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioCreacion
			,GETDATE() AS FechaModificacion
			,CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioModificacion
			,CAST('2020-01-01' AS DATETIME) as FechaInicioValidez
	from DBO.Clientes C
	go

	--DimGeografia
	SELECT c.ID_Ciudad,
			c.ID_Region,
			r.ID_Pais,
			c.Nombre as NombreCiudad,
			c.CodigoPostal,
			r.Nombre as NombreRegion,
			p.Nombre as NombrePais
			--Columnas Auditoria
			,GETDATE() AS FechaCreacion
			,CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioCreacion
			,GETDATE() AS FechaModificacion
			,CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioModificacion
			,CAST('2020-01-01' AS DATETIME) as FechaInicioValidez
	FROM dbo.Ciudad c inner join dbo.Region r on (c.ID_Region = c.ID_Region)
	inner join dbo.Pais p on (r.ID_Pais = p.ID_Pais)
	go

	--DimVehiculos
	SELECT top 100 V.VehiculoID,
			V.VIN_Patron,
			V.Anio,
			V.Marca,
			V.Modelo,
			V.SubModelo,
			V.Estilo,
			V.FechaCreacion
			--Columnas Auditoria
			,GETDATE() AS FechaCreacion
			,CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioCreacion
			,GETDATE() AS FechaModificacion
			,CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioModificacion
			,CAST('2020-01-01' AS DATETIME) as FechaInicioValidez
	FROM dbo.Vehiculo v
	go

	--DimPartes
	SELECT P.ID_Parte,
			L.ID_Linea, C.ID_Categoria, 
			P.Nombre, P.Descripcion, 
			P.Precio, C.Nombre, 
			C.Descripcion, 
			L.Nombre, 
			L.Descripcion
			--Columnas Auditoria
			,GETDATE() AS FechaCreacion
			,CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioCreacion
			,GETDATE() AS FechaModificacion
			,CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioModificacion
			,CAST('2020-01-01' AS DATETIME) as FechaInicioValidez
	FROM dbo.Partes AS P
	INNER JOIN dbo.Categoria AS C ON P.ID_Categoria = C.ID_Categoria
	INNER JOIN dbo.Linea AS L ON C.ID_Linea = L.ID_Linea
	go

	--DimStatus
	SELECT s.ID_StatusOrden, 
			s.NombreStatus
			--Columnas Auditoria
			,GETDATE() AS FechaCreacion
			,CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioCreacion
			,GETDATE() AS FechaModificacion
			,CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioModificacion
			,CAST('2020-01-01' AS DATETIME) as FechaInicioValidez
	FROM dbo.StatusOrden s
	go

	--DimDescuento
	SELECT ID_Descuento,
			NombreDescuento,
			PorcentajeDescuento
			--Columnas Auditoria
			,GETDATE() AS FechaCreacion
			,CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioCreacion
			,GETDATE() AS FechaModificacion
			,CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioModificacion
			,CAST('2020-01-01' AS DATETIME) as FechaInicioValidez
		FROM dbo.Descuento
	go

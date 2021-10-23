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

		 --DimCotizacion
		 SELECT c.IDCotizacion
				  ,c.[status]
				  ,c.TipoDocumento
				  ,c.FechaCreacion
				  ,c.FechaModificacion
				  ,c.ProcesadoPor
				  ,c.IDAseguradora
				  ,c.AseguradoraSubsidiaria
				  ,c.NumeroReclamo
				  ,c.IDPlantaReparacion
				  ,c.OrdenRealizada
				  ,c.CotizacionRealizada
				  ,c.CotizacionDuplicada
				  ,c.procurementFolderID
				  ,c.DireccionEntrega1
				  ,c.DireccionEntrega2
				  ,c.MarcadoEntrega
				  ,c.IDPartner
				  ,c.CodigoPostal
				  ,c.LeidoPorPlantaReparacion
				  ,c.LeidoPorPlantaReparacionFecha
				  ,c.CotizacionReabierta
				  ,c.EsAseguradora
				  ,c.CodigoVerificacion
				  ,c.IDClientePlantaReparacion
				  ,c.FechaCreacionRegistro
				  ,c.IDRecotizacion
				  ,c.PartnerConfirmado
				  ,c.WrittenBy
				  ,c.SeguroValidado
				  ,c.FechaCaptura
				  ,c.IDOrden
				  ,c.Ruta
				  ,c.FechaLimiteRuta
				  ,c.TelefonoEntrega
				  ,pr.CompanyNombre
				  ,pr.Direccion
				  ,pr.Direccion2
				  ,pr.Ciudad
				  ,pr.Estado
				  ,pr.CodigoPostal
				  ,pr.Pais
				  ,pr.TelefonoAlmacen
				  ,pr.FaxAlmacen
				  ,pr.CorreoContacto
				  ,pr.NombreContacto
				  ,pr.TelefonoContacto
				  ,pr.TituloTrabajo
				  ,pr.AlmacenKeystone
				  ,pr.IDPredio
				  ,pr.LocalizadorCotizacion
				  ,pr.FechaAgregado
				  ,pr.IDEmpresa
				  ,pr.ValidacionSeguro
				  ,pr.Activo
				  ,pr.CreadoPor
				  ,pr.ActualizadoPor
				  ,pr.UltimaFechaActualizacion
				  ,a.IDAseguradora
				  ,a.NombreAseguradora
				  ,a.RowCreatedDate
				  ,a.Activa
				  ,cd.NumLinea
				  ,cd.ID_Parte
				  ,cd.OETipoParte
				  ,cd.AltPartNum
				  ,cd.AltTipoParte
				  ,cd.ciecaTipoParte
				  ,cd.partDescripcion
				  ,cd.Cantidad
				  ,cd.PrecioListaOnRO
				  ,cd.PrecioNetoOnRO
				  ,cd.NecesitadoParaFecha
				  ,cd.VehiculoID
				  --Columnas Auditoria
				,GETDATE() AS FechaCreacion
				,CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioCreacion
				,GETDATE() AS FechaModificacion
				,CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioModificacion
				,CAST('2020-01-01' AS DATETIME) as FechaInicioValidez
			FROM dbo.Cotizacion c inner join dbo.CotizacionDetalle cd on (c.IDCotizacion = cd.IDCotizacion)
			  inner join dbo.PlantaReparacion pr on (c.IDPlantaReparacion = pr.IDPlantaReparacion)
			  inner join dbo.Aseguradoras a on (c.IDAseguradora = a.IDAseguradora)
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


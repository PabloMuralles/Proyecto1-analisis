--Queries para llenar datos

--Dimensiones

	--DimGeografia
	SELECT C.ID_Carrera, 
			F.ID_Facultad, 
			C.Nombre, 
			F.Nombre
	FROM Admisiones.dbo.Facultad F
		INNER JOIN Admisiones.dbo.Carrera C ON(C.ID_Facultad = F.ID_Facultad);
	go

	--DimParte
	SELECT C.ID_Carrera, 
			F.ID_Facultad, 
			C.Nombre, 
			F.Nombre
	FROM Admisiones.dbo.Facultad F
		INNER JOIN Admisiones.dbo.Carrera C ON(C.ID_Facultad = F.ID_Facultad);
	go

	--DimCliente
	SELECT C.ID_Carrera, 
			F.ID_Facultad, 
			C.Nombre, 
			F.Nombre
	FROM Admisiones.dbo.Facultad F
		INNER JOIN Admisiones.dbo.Carrera C ON(C.ID_Facultad = F.ID_Facultad);
	go

	--DimCotizacion
	SELECT C.ID_Carrera, 
			F.ID_Facultad, 
			C.Nombre, 
			F.Nombre
	FROM Admisiones.dbo.Facultad F
		INNER JOIN Admisiones.dbo.Carrera C ON(C.ID_Facultad = F.ID_Facultad);
	go

	--DimVehiculo
	SELECT C.ID_Carrera, 
			F.ID_Facultad, 
			C.Nombre, 
			F.Nombre
	FROM Admisiones.dbo.Facultad F
		INNER JOIN Admisiones.dbo.Carrera C ON(C.ID_Facultad = F.ID_Facultad);
	go

	--DimDescuento
	SELECT C.ID_Carrera, 
			F.ID_Facultad, 
			C.Nombre, 
			F.Nombre
	FROM Admisiones.dbo.Facultad F
		INNER JOIN Admisiones.dbo.Carrera C ON(C.ID_Facultad = F.ID_Facultad);
	go

	--DimStatusOrden
	SELECT C.ID_Carrera, 
			F.ID_Facultad, 
			C.Nombre, 
			F.Nombre
	FROM Admisiones.dbo.Facultad F
		INNER JOIN Admisiones.dbo.Carrera C ON(C.ID_Facultad = F.ID_Facultad);
	go

	--DimCandidato
	SELECT C.ID_Candidato, 
			CC.ID_Colegio, 
			D.ID_Diversificado, 
			C.Nombre as NombreCandidato, 
			C.Apellido as ApellidoCandidato, 
			C.Genero, 
			C.FechaNacimiento, 
			CC.Nombre as NombreColegio, 
			D.Nombre as NombreDiversificado
	FROM Admisiones.DBO.Candidato C
		INNER JOIN Admisiones.DBO.ColegioCandidato CC ON(C.ID_Colegio = CC.ID_Colegio)
		INNER JOIN Admisiones.DBO.Diversificado D ON(C.ID_Diversificado = D.ID_Diversificado);
	go


--------------------------------------------------------------------------------------------
-----------------------CORRER CREATE de USP_FillDimDate PRIMERO!!!--------------------------
--------------------------------------------------------------------------------------------

	DECLARE @FechaMaxima DATETIME=DATEADD(YEAR,2,GETDATE())
	--Fecha
	IF ISNULL((SELECT MAX(Date) FROM Dimension.Fecha),'1900-01-01')<@FechaMaxima
	begin
		EXEC USP_FillDimDate @CurrentDate = '2016-01-01', 
							 @EndDate     = @FechaMaxima
	end
	SELECT * FROM Dimension.Fecha
	
	--Fact
	INSERT INTO [Fact].[Examen]
	([SK_Candidato], 
	 [SK_Carrera], 
	 [DateKey], 
	 [ID_Examen], 
	 [ID_Descuento], 	
	 [DescripcionDescuento], 
	 [PorcentajeDescuento], 
	 [Precio], 
	 [NotaTotal], 
	 [NotaArea], 
	 [NombreMateria]
	)
	SELECT  --Columnas de mis dimensiones en DWH
			SK_Candidato, 
			SK_Carrera, 
			F.DateKey, 
			R.ID_Examen, 
			R.ID_Descuento, 			
			D.Descripcion, 
			D.PorcentajeDescuento, 
			R.Precio, 
			R.Nota,
			RR.NotaArea, 
			EA.NombreMateria
				 
	FROM Admisiones.DBO.Examen R
		INNER JOIN Admisiones.DBO.Examen_Detalle RR ON(R.ID_Examen = RR.ID_Examen)
		INNER JOIN Admisiones.DBO.Materia EA ON(EA.ID_Materia = RR.ID_Materia)
		INNER JOIN Admisiones.DBO.Descuento D ON(D.ID_Descuento = R.ID_Descuento)
		--Referencias a DWH
		INNER JOIN Dimension.Candidato C ON(C.ID_Candidato = R.ID_Candidato)
		INNER JOIN Dimension.Carrera CA ON(CA.ID_Carrera = R.ID_Carrera)
		INNER JOIN Dimension.Fecha F ON(CAST((CAST(YEAR(R.FechaPrueba) AS VARCHAR(4)))+left('0'+CAST(MONTH(R.FechaPrueba) AS VARCHAR(4)),2)+left('0'+(CAST(DAY(R.FechaPrueba) AS VARCHAR(4))),2) AS INT)  = F.DateKey);
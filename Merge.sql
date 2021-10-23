USE [RepuestosWeb_DWH]
GO

--Script de SP para MERGE
CREATE PROCEDURE USP_MergeFact
as
BEGIN

	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRAN
		DECLARE @NuevoGUIDInsert UNIQUEIDENTIFIER = NEWID(), @MaxFechaEjecucion DATETIME, @RowsAffected INT

		INSERT INTO FactLog ([ID_Batch], [FechaEjecucion], [NuevosRegistros])
		VALUES (@NuevoGUIDInsert,NULL,NULL)
		
		MERGE Fact.Examen AS T
		USING (
			SELECT [SK_Candidato], [SK_Carrera], [DateKey], [ID_Examen], [ID_Descuento], r.Descripcion AS DescripcionDescuento, [PorcentajeDescuento], [Precio], r.Nota as NotaTotal, [NotaArea], [NombreMateria], getdate() as FechaCreacion, 'ETL' as UsuarioCreacion, NULL as FechaModificacion, NULL as UsuarioModificacion, @NuevoGUIDINsert as ID_Batch, 'ssis' as ID_SourceSystem, r.FechaPrueba, r.FechaModificacionSource
			FROM STAGING.Examen R
				INNER JOIN Dimension.Candidato C ON(C.ID_Candidato = R.ID_Candidato and
													R.FechaPrueba BETWEEN c.FechaInicioValidez AND ISNULL(c.FechaFinValidez, '9999-12-31')) 
				INNER JOIN Dimension.Carrera CA ON(CA.ID_Carrera = R.ID_Carrera and
													R.FechaPrueba BETWEEN CA.FechaInicioValidez AND ISNULL(CA.FechaFinValidez, '9999-12-31')) 
				LEFT JOIN Dimension.Fecha F ON(CAST( (CAST(YEAR(R.FechaPrueba) AS VARCHAR(4)))+left('0'+CAST(MONTH(R.FechaPrueba) AS VARCHAR(4)),2)+left('0'+(CAST(DAY(R.FechaPrueba) AS VARCHAR(4))),2) AS INT)  = F.DateKey)
				) AS S ON (S.ID_examen = T.ID_Examen)

		WHEN NOT MATCHED BY TARGET THEN --No existe en Fact
		INSERT ([SK_Candidato], [SK_Carrera], [DateKey], [ID_Examen], [ID_Descuento], [DescripcionDescuento], [PorcentajeDescuento], [Precio], [NotaTotal], [NotaArea], [NombreMateria], [FechaCreacion], [UsuarioCreacion], [FechaModificacion], [UsuarioModificacion], [ID_Batch], [ID_SourceSystem], FechaPrueba, FechaModificacionSource)
		VALUES (S.[SK_Candidato], S.[SK_Carrera], S.[DateKey], S.[ID_Examen], S.[ID_Descuento], S.[DescripcionDescuento], S.[PorcentajeDescuento], S.[Precio], S.[NotaTotal], S.[NotaArea], S.[NombreMateria], S.[FechaCreacion], S.[UsuarioCreacion], S.[FechaModificacion], S.[UsuarioModificacion], S.[ID_Batch], S.[ID_SourceSystem], S.FechaPrueba, S.FechaModificacionSource);

		SET @RowsAffected =@@ROWCOUNT

		SELECT @MaxFechaEjecucion=MAX(MaxFechaEjecucion)
		FROM(
			SELECT MAX(FechaPrueba) as MaxFechaEjecucion
			FROM FACT.Examen
			UNION
			SELECT MAX(FechaModificacionSource)  as MaxFechaEjecucion
			FROM FACT.Examen
		)AS A

		UPDATE FactLog
		SET NuevosRegistros=@RowsAffected, FechaEjecucion = @MaxFechaEjecucion
		WHERE ID_Batch = @NuevoGUIDInsert

		COMMIT
	END TRY
	BEGIN CATCH
		SELECT @@ERROR,'Ocurrio el siguiente error: '+ERROR_MESSAGE()
		IF (@@TRANCOUNT>0)
			ROLLBACK;
	END CATCH

END
go

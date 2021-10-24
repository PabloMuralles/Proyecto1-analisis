USE [RepuestosWeb_DWH]
GO

--Script de SP para MERGE
create or alter PROCEDURE USP_MergeFact
as
BEGIN

	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRAN
		DECLARE @NuevoGUIDInsert UNIQUEIDENTIFIER = NEWID(), @MaxFechaEjecucion DATETIME, @RowsAffected INT

		INSERT INTO FactLog ([ID_Batch], [FechaEjecucion], [NuevosRegistros])
		VALUES (@NuevoGUIDInsert,NULL,NULL)
		
		MERGE Fact.Orden AS T
		USING (
			SELECT SK_Geografia,
			SK_Parte,
			SK_Cliente,
			SK_Cotizacion,
			SK_Vehiculo,
			SK_Descuento,
			SK_StatusOrden,
			DateKey,
			o.ID_Orden,
			o.ID_Cliente,
			o.ID_Ciudad,
			o.ID_DetalleOrden,
			o.ID_Parte,
			o.ID_Descuento,
			o.VehiculoID,
			o.ID_StatusOrden,
			o.Total_Orden,
			o.Fecha_Orden,
			o.NumeroOrden,
			o.Cantidad,
			o.FechaModificacionSource,
			getdate() as FechaCreacion,
			'ETL' as UsuarioCreacion,
			NULL as FechaModificacion,
			NULL as UsuarioModificacion,
			@NuevoGUIDINsert as ID_Batch,
			'ssis' as ID_SourceSystem
			FROM staging.Orden o
				LEFT JOIN Dimension.Geografia g ON(g.ID_Ciudad = o.ID_Ciudad) 
				LEFT JOIN Dimension.Parte p ON(p.ID_Parte = o.ID_Parte)
				LEFT JOIN Dimension.Cliente c ON(c.ID_Cliente = o.ID_Cliente)
				LEFT JOIN Dimension.Cotizacion co ON(co.IDOrden = o.ID_Orden)
				LEFT JOIN Dimension.Vehiculo v ON(v.VehiculoID = o.VehiculoID)
				LEFT JOIN Dimension.Descuento d ON(d.ID_Descuento = o.ID_Descuento)
				LEFT JOIN Dimension.StatusOrden so ON(so.ID_StatusOrden = o.ID_StatusOrden)				
				LEFT JOIN Dimension.Fecha F ON(CAST( (CAST(YEAR(o.Fecha_Orden) AS VARCHAR(4)))+left('0'+CAST(MONTH(o.Fecha_Orden) AS VARCHAR(4)),2)+left('0'+(CAST(DAY(o.Fecha_Orden) AS VARCHAR(4))),2) AS INT)  = F.DateKey)
				) AS S ON (S.ID_Orden = T.ID_Orden)

		WHEN NOT MATCHED BY TARGET THEN --No existe en Fact
		INSERT (
		SK_Geografia,
			SK_Parte,
			SK_Cliente,
			SK_Cotizacion,
			SK_Vehiculo,
			SK_Descuento,
			SK_StatusOrden,
			DateKey,
			ID_Orden,
			ID_Cliente,
			ID_Ciudad,
			ID_DetalleOrden,
			ID_Parte,
			ID_Descuento,
			VehiculoID,
			ID_StatusOrden,
			Total_Orden,
			Fecha_Orden,
			NumeroOrden,
			Cantidad,
			FechaModificacionSource,
			FechaCreacion,
			UsuarioCreacion,
			FechaModificacion,
			UsuarioModificacion,
			ID_Batch,
			ID_SourceSystem)
		VALUES (
		s.SK_Geografia,
			s.SK_Parte,
			s.SK_Cliente,
			s.SK_Cotizacion,
			s.SK_Vehiculo,
			s.SK_Descuento,
			s.SK_StatusOrden,
			s.DateKey,
			s.ID_Orden,
			s.ID_Cliente,
			s.ID_Ciudad,
			s.ID_DetalleOrden,
			s.ID_Parte,
			s.ID_Descuento,
			s.VehiculoID,
			s.ID_StatusOrden,
			s.Total_Orden,
			s.Fecha_Orden,
			s.NumeroOrden,
			s.Cantidad,
			s.FechaModificacionSource,
			s.FechaCreacion,
			s.UsuarioCreacion,
			s.FechaModificacion,
			s.UsuarioModificacion,
			s.ID_Batch,
			s.ID_SourceSystem
		);

		SET @RowsAffected =@@ROWCOUNT

		SELECT @MaxFechaEjecucion=MAX(MaxFechaEjecucion)
		FROM(
			SELECT MAX(Fecha_Orden) as MaxFechaEjecucion
			FROM FACT.Orden
			UNION
			SELECT MAX(FechaModificacionSource)  as MaxFechaEjecucion
			FROM FACT.Orden
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

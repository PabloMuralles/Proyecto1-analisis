--Query para llenar datos en Staging -SSMS
SELECT o.ID_Orden, 
       o.ID_Cliente, 
       o.ID_Ciudad, 
       do.ID_DetalleOrden, 
	   do.ID_Parte,
       do.ID_Descuento, 
       do.VehiculoID, 
       o.Total_Orden, 
       o.Fecha_Orden, 
	   o.NumeroOrden,
       do.Cantidad
FROM RepuestosWeb.DBO.Orden o
     INNER JOIN RepuestosWeb.DBO.Detalle_Orden do ON(o.ID_Orden = do.ID_Orden)
	 WHERE (Fecha_Orden>'2018-07-01 21:52:37.500')


--Query para llenar datos en Staging - SSIS
SELECT o.ID_Orden, 
       o.ID_Cliente, 
       o.ID_Ciudad, 
       do.ID_DetalleOrden, 
	   do.ID_Parte,
       do.ID_Descuento, 
       do.VehiculoID, 
       o.Total_Orden, 
       o.Fecha_Orden, 
	   o.NumeroOrden,
       do.Cantidad
FROM DBO.Orden o
     INNER JOIN DBO.Detalle_Orden do ON(o.ID_Orden = do.ID_Orden)
WHERE ((Fecha_Orden>?) OR (FechaModificacion>?))
go

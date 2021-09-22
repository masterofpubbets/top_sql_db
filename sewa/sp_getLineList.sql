ALTER PROC sp_getLineList
AS
SELECT [lineId] AS ID,[status] AS [Status],[plant] AS Plant,[unit] AS Unit,[system] AS [System]
,[subsystem] AS Subsystem,[equipmentCode] AS [Equipment Code],[branchNumber] AS [Branch Number]
,[lineKKS] AS [Line KKS],[lineKKS2] AS [Engineering Line KKS],dbo.tblUnits.unit_name AS [Unit Name]
,[drawingNumber] AS [Drawing Number],[sheet] AS Sheet,[revision] AS Revision,[nominalSize] AS [Nominal Size]
,[rating] AS Rating,[materialClass] AS [Material Class],[material] AS Material,[schedule] AS [Schedule]
,Schedule_mm AS [Schedule mm]
,[fluidService] AS [Fluid Service],[enviroment] AS Enviroment,[streamId] AS StreamId,[designPressure] AS [Design Pressure]
,[designTemperature] AS [Design Temperature],[operatingPressure] AS [Operating Pressure],[operatingTemprature] AS [Operating Temprature]
,[operatingMaxTemprature] AS [Operating Max Temprature],[active] AS Active
,[appCreatedDate] AS [App Created Date],[engineeringBy] AS [Engineering By]
FROM [PIPING].[tblLineList]
INNER JOIN tblUnits ON [PIPING].[tblLineList].unitId = tblUnits.unit_id
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[sp_InsSummary]

AS
DECLARE @date date
SELECT @date = [cutoffDate] FROM [tblOptions] WHERE id=1

SELECT 
CASE WHEN Unit IS NULL THEN 'Total' ELSE Unit END AS Unit
,CASE WHEN device_type IS NULL THEN 'Total' ELSE device_type END AS [Type]
,Scope,[Actual],Weekly
FROM (
SELECT
Unit,device_type
,SUM(Scope) as Scope
,SUM([Actual]) as [Actual]
,SUM([Weekly]) AS Weekly
FROM (
SELECT
tblunits.unit_name as Unit,tblInstruments.device_type
,COUNT(tag) as Scope
,SUM(CASE WHEN tblInstruments.[installed_date] <= @date THEN 1 ELSE 0 END) as [Actual]
,SUM(CASE WHEN tblInstruments.[installed_date] BETWEEN DATEADD(day,-6,@date) AND @date THEN 1 ELSE 0 END) AS [Weekly]

FROM tblInstruments
INNER JOIN tblUnits ON tblUnits.unit_id = tblInstruments.unit_id
WHERE tblInstruments.main_device = 1 AND Installation_scope <> 'Vendor'
AND tblunits.unit_name in ('00','10')
AND tblInstruments.active=1
GROUP BY tblunits.unit_name,tblInstruments.device_type

) as vDet
GROUP BY ROLLUP(UNIT,device_type)
) as vTotoal
WHERE vTotoal.Unit IS NOT NULL

UNION ALL

SELECT 
'Total' AS Unit
,CASE WHEN device_type IS NULL THEN 'Total' ELSE device_type END AS [Type]
,Scope,[Actual],Weekly
FROM (
SELECT
device_type
,SUM(Scope) as Scope
,SUM([Actual]) as [Actual]
,SUM([Weekly]) AS Weekly
FROM (
SELECT
tblInstruments.device_type
,COUNT(tag) as Scope
,SUM(CASE WHEN tblInstruments.[installed_date] <= @date THEN 1 ELSE 0 END) as [Actual]
,SUM(CASE WHEN tblInstruments.[installed_date] BETWEEN DATEADD(day,-6,@date) AND @date THEN 1 ELSE 0 END) AS [Weekly]

FROM tblInstruments
INNER JOIN tblUnits ON tblUnits.unit_id = tblInstruments.unit_id
WHERE tblInstruments.main_device = 1 AND Installation_scope <> 'Vendor'
AND tblunits.unit_name in ('00','10')
AND tblInstruments.active=1
GROUP BY tblInstruments.device_type

) as vDet
GROUP BY ROLLUP(device_type)
) as vTotoal
GO


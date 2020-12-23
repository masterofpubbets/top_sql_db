
CREATE PROC sp_insSummaryMini
AS
DECLARE @date date
SELECT @date = [cutoffDate] FROM [tblOptions] WHERE id=1

SELECT
CASE WHEN Unit IS NULL THEN 'Total' ELSE Unit END AS Unit
,SUM([Electronic Scope]) AS [Electronic Scope]
,SUM([Electronic Actual]) AS [Electronic Actual]
,SUM([Mechanical Scope]) AS [Mechanical Scope]
,SUM([Mechanical Actual]) AS [Mechanical Actual]
FROM (
SELECT 
Unit
,[Electronic Scope],[Electronic Actual],[Mechanical Scope],[Mechanical Actual]
FROM (
SELECT
tblunits.unit_name as Unit,'Electronic' AS device_type
,COUNT(tag) as [Electronic Scope]
,SUM(CASE WHEN tblInstruments.[installed_date] <= @date THEN 1 ELSE 0 END) as [Electronic Actual]
,0 AS [Mechanical Scope],0 AS [Mechanical Actual]

FROM tblInstruments
INNER JOIN tblUnits ON tblUnits.unit_id = tblInstruments.unit_id
WHERE tblInstruments.main_device = 1 AND Installation_scope <> 'Vendor'
AND tblInstruments.device_type = 'Electronic'
GROUP BY tblunits.unit_name
) AS vEle

UNION ALL

SELECT 
Unit
,[Electronic Scope],[Electronic Actual],[Mechanical Scope],[Mechanical Actual]
FROM (
SELECT
tblunits.unit_name as Unit,'Mechanical' AS device_type
,0 as [Electronic Scope]
,0 as [Electronic Actual]
,COUNT(tag) AS [Mechanical Scope]
,SUM(CASE WHEN tblInstruments.[installed_date] <= @date THEN 1 ELSE 0 END) AS [Mechanical Actual]

FROM tblInstruments
INNER JOIN tblUnits ON tblUnits.unit_id = tblInstruments.unit_id
WHERE tblInstruments.main_device = 1 AND Installation_scope <> 'Vendor'
AND tblInstruments.device_type = 'Mechanical'
GROUP BY tblunits.unit_name
) AS vMec
) AS vAll
GROUP BY ROLLUP(Unit)
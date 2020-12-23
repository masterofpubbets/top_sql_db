CREATE PROC sp_instHookupSummaryMini
AS
DECLARE @date date
SELECT @date = [cutoffDate] FROM [tblOptions] WHERE id=1

SELECT 
CASE WHEN Unit IS NULL THEN 'Total' ELSE Unit END AS Unit
,[Hookup Scope],[Hookup Actual],[Hookup Weekly]

FROM (

SELECT
Unit
,SUM([Hookup Scope]) AS [Hookup Scope]
,SUM([Hookup Actual]) AS [Hookup Actual]
,SUM([Hookup Weekly]) AS [Hookup Weekly]

FROM (
SELECT
tblunits.unit_name as Unit
,0 AS [Calibration Scope]
,0 AS [Calibration Actual]
,0 AS [Calibration Weekly]
,COUNT(tag) AS [Hookup Scope]
,SUM(CASE WHEN hookup_date <= @date THEN 1 ELSE 0 END) AS [Hookup Actual]
,SUM(CASE WHEN tblInstruments.hookup_date BETWEEN DATEADD(day,-6,@date) AND @date THEN 1 ELSE 0 END) AS [Hookup Weekly]
FROM tblInstruments
INNER JOIN tblUnits ON tblUnits.unit_id = tblInstruments.unit_id
WHERE [hookup_require]=1
GROUP BY tblunits.unit_name
) as vDet
GROUP BY ROLLUP(UNIT)
) as vTotoal



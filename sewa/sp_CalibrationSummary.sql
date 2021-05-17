SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[sp_CalibrationSummary]

AS
DECLARE @date date
SELECT @date = [cutoffDate] FROM [tblOptions] WHERE id=1

SELECT 
CASE WHEN Unit IS NULL THEN 'Total' ELSE Unit END AS Unit
,[Calibration Scope],[Calibration Actual],[Calibration Weekly]

FROM (

SELECT
Unit
,SUM([Calibration Scope]) AS [Calibration Scope]
,SUM([Calibration Actual]) AS [Calibration Actual]
,SUM([Calibration Weekly]) AS [Calibration Weekly]

FROM (
SELECT
tblunits.unit_name as Unit
,COUNT(tag) AS [Calibration Scope]
,COUNT(calibration_date) AS [Calibration Actual]
,SUM(CASE WHEN tblInstruments.calibration_date BETWEEN DATEADD(day,-6,@date) AND @date THEN 1 ELSE 0 END) AS [Calibration Weekly]
FROM tblInstruments
INNER JOIN tblUnits ON tblUnits.unit_id = tblInstruments.unit_id
WHERE tblunits.unit_name in ('00','10')
AND calibration_require=1
AND tblInstruments.active=1
GROUP BY tblunits.unit_name

) as vDet
GROUP BY ROLLUP(UNIT)
) as vTotoal
GO

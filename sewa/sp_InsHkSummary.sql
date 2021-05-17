SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[sp_InsHkSummary]

AS
DECLARE @date date
SELECT @date = [cutoffDate] FROM [tblOptions] WHERE id=1

SELECT 
CASE WHEN Unit IS NULL THEN 'Total' ELSE Unit END AS Unit
,CASE WHEN [Hookup Type] IS NULL THEN 'Total' ELSE [Hookup Type] END AS [Hookup Type]
,[Hookup Scope],[Hookup Actual],[Hookup Weekly]

FROM (

SELECT
Unit,hookup_type as [Hookup Type]
,SUM([Hookup Scope]) AS [Hookup Scope]
,SUM([Hookup Actual]) AS [Hookup Actual]
,SUM([Hookup Weekly]) AS [Hookup Weekly]

FROM (
SELECT
tblunits.unit_name as Unit
,tblInstruments.hookup_type
,0 AS [Calibration Scope]
,0 AS [Calibration Actual]
,0 AS [Calibration Weekly]
,COUNT(tag) AS [Hookup Scope]
,SUM(CASE WHEN hookup_date <= @date THEN 1 ELSE 0 END) AS [Hookup Actual]
,SUM(CASE WHEN tblInstruments.hookup_date BETWEEN DATEADD(day,-6,@date) AND @date THEN 1 ELSE 0 END) AS [Hookup Weekly]
FROM tblInstruments
INNER JOIN tblUnits ON tblUnits.unit_id = tblInstruments.unit_id
WHERE tblunits.unit_name in ('00','10')
AND [hookup_require]=1
AND tblInstruments.active=1
GROUP BY tblunits.unit_name,hookup_type
) as vDet
GROUP BY ROLLUP(UNIT,hookup_type)
) as vTotoal
WHERE Unit IS NOT NULL

UNION ALL

SELECT 'Total' AS Unit
,CASE WHEN [Hookup Type] IS NULL THEN 'Total' ELSE [Hookup Type] END AS [Hookup Type]
,[Hookup Scope],[Hookup Actual],[Hookup Weekly]

FROM (

SELECT
hookup_type as [Hookup Type]
,SUM([Hookup Scope]) AS [Hookup Scope]
,SUM([Hookup Actual]) AS [Hookup Actual]
,SUM([Hookup Weekly]) AS [Hookup Weekly]

FROM (
SELECT
tblInstruments.hookup_type
,0 AS [Calibration Scope]
,0 AS [Calibration Actual]
,0 AS [Calibration Weekly]
,COUNT(tag) AS [Hookup Scope]
,SUM(CASE WHEN hookup_date <= @DATE THEN 1 ELSE 0 END) AS [Hookup Actual]
,SUM(CASE WHEN tblInstruments.hookup_date BETWEEN DATEADD(day,-6,@date) AND @date THEN 1 ELSE 0 END) AS [Hookup Weekly]
FROM tblInstruments
INNER JOIN tblUnits ON tblUnits.unit_id = tblInstruments.unit_id
WHERE tblunits.unit_name in ('00','10')
AND [hookup_require]=1
AND tblInstruments.active=1
GROUP BY hookup_type
) as vDet
GROUP BY ROLLUP(hookup_type)
) as vTotoal

GO

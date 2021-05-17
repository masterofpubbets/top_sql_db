SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[sp_LoopSummary]
AS
DECLARE @date date
SELECT @date = [cutoffDate] FROM [tblOptions] WHERE id=1
SELECT
CASE WHEN comm_responsible IS NULL THEN 'Total' ELSE comm_responsible END AS [Commissioning Responsible]
,CASE WHEN tblSignals.category IS NULL THEN 'Total' ELSE tblSignals.category END AS [Category]
,CASE WHEN tblUnits.unit_name IS NULL THEN 'Total' ELSE tblUnits.unit_name END AS Unit
,COUNT(tblSignals.TAG) AS Scope
,SUM(CASE WHEN tblSignals.loop_done <= @date THEN 1 ELSE 0 END) AS Actual
,SUM(CASE WHEN tblSignals.loop_done BETWEEN DATEADD(day,-6,@date) AND @date THEN 1 ELSE 0 END) AS Weekly
,COUNT(tblSignals.TAG) - COUNT(tblSignals.loop_done) AS Pending
FROM tblSignals
INNER JOIN tblUnits ON tblSignals.unit_id = tblUnits.unit_id
WHERE tblSignals.active=1
AND tblUnits.unit_name IN ('00','10')
GROUP BY ROLLUP(comm_responsible,tblUnits.unit_name,tblSignals.category)

GO

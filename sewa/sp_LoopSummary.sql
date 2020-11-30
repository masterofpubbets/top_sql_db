ALTER PROC [dbo].[sp_LoopSummary]
AS
DECLARE @date date
SELECT @date = [cutoffDate] FROM [tblOptions] WHERE id=1
SELECT
CASE WHEN tblSignals.category IS NULL THEN 'Total' ELSE tblSignals.category END AS [Category]
,COUNT(tblSignals.TAG) AS Scope
,SUM(CASE WHEN tblSignals.loop_done <= @date THEN 1 ELSE 0 END) AS Actual
,SUM(CASE WHEN tblSignals.loop_done BETWEEN DATEADD(day,-6,@date) AND @date THEN 1 ELSE 0 END) AS Weekly
,COUNT(tblSignals.TAG) - COUNT(tblSignals.loop_done) AS Pending
FROM tblSignals
GROUP BY ROLLUP(tblSignals.category)
GO

CREATE PROC [dbo].[sp_LoopSummaryMini]
AS
DECLARE @date date
SELECT @date = [cutoffDate] FROM [tblOptions] WHERE id=1
SELECT
CASE WHEN tblSignals.category IS NULL THEN 'Total' ELSE tblSignals.category END AS [Category]
,COUNT(tblSignals.TAG) AS Scope
,SUM(CASE WHEN tblSignals.loop_done <= @date THEN 1 ELSE 0 END) AS Actual
FROM tblSignals
WHERE comm_responsible = 'tr'
GROUP BY ROLLUP(tblSignals.category)


GO

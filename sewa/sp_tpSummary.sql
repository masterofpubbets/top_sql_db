ALTER PROC sp_tpSummary
AS
DECLARE @dte DATE
SELECT @dte = cutoffDate FROM tblOptions WHERE id = 1
SELECT
tblUnits.unit_name as Unit
,COUNT(tblHT.ht_name) AS Scope
,COUNT(tblHt.tested_date) AS Tested
,COUNT(tblHt.reinstated_date) AS Reinstated
,SUM(CASE WHEN tblHt.tested_date BETWEEN DATEADD(day,-6,@dte) AND @dte THEN 1 ELSE 0 END) AS [Tested Weekly]
,SUM(CASE WHEN tblHt.reinstated_date BETWEEN DATEADD(day,-6,@dte) AND @dte THEN 1 ELSE 0 END) AS [Reinstated Weekly]
FROM tblHT
INNER JOIN tblUnits ON tblHT.unit_id = tblUnits.unit_id
GROUP BY tblUnits.unit_name
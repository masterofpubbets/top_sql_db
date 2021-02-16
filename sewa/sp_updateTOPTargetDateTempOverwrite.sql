CREATE PROC sp_updateTOPTargetDateTempOverwrite
AS
UPDATE v
SET resolve_issues_date = targetDate
FROM (
SELECT 
tblTopStatus_temp.topName,tblTopStatus_temp.targetDate
,tblTOP.resolve_issues_date
FROM tblTopStatus_temp
INNER JOIN tblTOP ON tblTopStatus_temp.topName = tblTOP.top_name
) AS v
CREATE PROC sp_updateTOPIssueTempOverwrite
AS
UPDATE v
SET issues = Issue
FROM (
SELECT 
tblTopStatus_temp.topName,tblTopStatus_temp.Issue
,tblTOP.issues
FROM tblTopStatus_temp
INNER JOIN tblTOP ON tblTopStatus_temp.topName = tblTOP.top_name
) AS v
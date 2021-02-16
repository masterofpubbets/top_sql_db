CREATE PROC sp_updateTOPResponsibleTempOverwrite
AS
UPDATE v
SET resolve_issues_res = responsible
FROM (
SELECT 
tblTopStatus_temp.topName,tblTopStatus_temp.responsible
,tblTOP.resolve_issues_res
FROM tblTopStatus_temp
INNER JOIN tblTOP ON tblTopStatus_temp.topName = tblTOP.top_name
) AS v
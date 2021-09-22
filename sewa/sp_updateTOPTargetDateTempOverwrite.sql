ALTER PROC sp_updateTOPTargetDateTempOverwrite
AS
UPDATE v
SET currentTargetDate = targetDate
FROM (
SELECT 
tblTopStatus_temp.topName,tblTopStatus_temp.targetDate
,tblTOP.targetDate AS currentTargetDate
FROM tblTopStatus_temp
INNER JOIN tblTOP ON tblTopStatus_temp.topName = tblTOP.top_name
) AS v
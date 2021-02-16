CREATE PROC sp_updateTOPPartialTempOverwrite
AS
UPDATE v
SET topPartial = isPartial
FROM (
SELECT 
tblTopStatus_temp.topName,tblTopStatus_temp.isPartial
,tblTOP.isPartial AS [topPartial]
FROM tblTopStatus_temp
INNER JOIN tblTOP ON tblTopStatus_temp.topName = tblTOP.top_name
) AS v
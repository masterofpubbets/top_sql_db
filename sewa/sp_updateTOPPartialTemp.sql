ALTER PROC sp_updateTOPPartialTemp
AS
UPDATE v
SET topPartial = isPartial
FROM (
SELECT 
tblTopStatus_temp.topName,tblTopStatus_temp.isPartial
,tblTOP.isPartial AS [topPartial]
FROM tblTopStatus_temp
INNER JOIN tblTOP ON tblTopStatus_temp.topName = tblTOP.top_name
WHERE tblTOP.isPartial IS NULL OR tblTOP.isPartial = 1
) AS v

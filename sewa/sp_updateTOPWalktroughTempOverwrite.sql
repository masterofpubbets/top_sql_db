CREATE PROC sp_updateTOPWalktroughTempOverwrite
AS
UPDATE v
SET walk_through_date = walkthroughDate
FROM (
SELECT 
tblTopStatus_temp.topName,tblTopStatus_temp.walkthroughDate
,tblTOP.walk_through_date
FROM tblTopStatus_temp
INNER JOIN tblTOP ON tblTopStatus_temp.topName = tblTOP.top_name
) AS v
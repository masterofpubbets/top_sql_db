CREATE PROC sp_updateTOPTransferTemp
AS
UPDATE v
SET topPartial = 0
,transfer_date = transferDate
FROM (
SELECT 
tblTopStatus_temp.topName,tblTopStatus_temp.transferDate
,tblTOP.isPartial AS [topPartial],tblTOP.transfer_date
FROM tblTopStatus_temp
INNER JOIN tblTOP ON tblTopStatus_temp.topName = tblTOP.top_name
WHERE tblTOP.transfer_date IS NULL
) AS v

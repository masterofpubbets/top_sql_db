ALTER PROC sp_updateTOPTransferTempOverwrite
AS
UPDATE v
SET transfer_date = transferDate
,[topPartial] = partialStatus
FROM (
SELECT 
tblTopStatus_temp.topName
,tblTopStatus_temp.transferDate
,CASE WHEN tblTop.transfer_date IS NOT NULL THEN 0 ELSE tblTOP.isPartial END AS partialStatus
,tblTOP.transfer_date,tblTOP.isPartial AS [topPartial]
FROM tblTopStatus_temp
INNER JOIN tblTOP ON tblTopStatus_temp.topName = tblTOP.top_name
) AS v

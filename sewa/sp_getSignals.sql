ALTER PROC sp_getSignals
AS
SELECT 
tblSystems.systemName,tblSystems.systemDescription
,tblTOP.top_name,tblTop.transfer_date,tblUnits.unit_name
, tblSignals.* 
FROM tblSignals 
INNER JOIN tblTOP ON tbltop.top_id = tblSignals.top_id 
INNER JOIN tblUnits ON tblSignals.unit_id = tblUnits.unit_id
INNER JOIN tblSystems ON tbltop.systemId = tblSystems.sysId
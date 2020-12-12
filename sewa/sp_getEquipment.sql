CREATE PROC sp_getEquipment
AS
SELECT 
tblEquipment.eq_id,tblTop.top_name,tblUnits.unit_name
,tblEquipment.tag,tblEquipment.[type],tblEquipment.area,tblEquipment.[description],tblEquipment.erected_date,tblEquipment.remarks
FROM tblEquipment
INNER JOIN tblTOP ON tblEquipment.top_id = tblTop.top_id
INNER JOIN tblUnits ON tblEquipment.unit_id = tblUnits.unit_id
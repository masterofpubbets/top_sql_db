ALTER PROC sp_getEquipment
AS
SELECT 
tblEquipment.eq_id AS Id,tblTop.top_name AS [TOP],tblUnits.unit_name AS [Unit]
,tblEquipment.tag AS Tag,tblEquipment.[type] AS [Type],className AS [Class]
,tblEquipment.area AS Area,tblEquipment.[description] AS [Description]
,tblEquipment.shipmentNumber AS [Shipment Number]
,tblEquipment.etaDate AS [ETA Date],tblEquipment.[deliveryDate] AS [Delivery Date]
,tblEquipment.erected_date AS [Erected Date],tblEquipment.remarks AS Remarks
FROM tblEquipment
INNER JOIN tblTOP ON tblEquipment.top_id = tblTop.top_id
INNER JOIN tblUnits ON tblEquipment.unit_id = tblUnits.unit_id
ALTER PROC sp_getEqDetail
@tag NVARCHAR(100)
AS
SELECT
tblUnits.unit_name AS Unit
,tbltop.top_name AS [Top]
,tblEquipment.Tag,tblEquipment.[type] AS [Type]
,tblEquipment.[description] AS [Description]
,FORMAT(tblEquipment.[erected_date],'dd/MM/yyyy') AS [Erected Date]
  FROM [dbo].[tblEquipment]
  INNER JOIN tblUnits ON tblEquipment.unit_id = tblUnits.unit_id
  INNER JOIN tblTop ON tblEquipment.top_id = tblTop.top_id
WHERE tblEquipment.tag = @tag
CREATE VIEW EquipmentScope
AS
SELECT
unit_id,[type] AS [Type],
COUNT(tag) AS Scope
FROM tblEquipment
WHERE active = 1
GROUP BY unit_id,[type]
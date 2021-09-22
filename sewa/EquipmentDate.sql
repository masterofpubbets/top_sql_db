ALTER VIEW EquipmentDate
AS
SELECT
unit_id,[type] AS [Type],erected_date AS [Erected Date],
COUNT(tag) AS Done
FROM tblEquipment
WHERE active = 1
AND erected_date IS NOT NULL
GROUP BY unit_id,[type],erected_date
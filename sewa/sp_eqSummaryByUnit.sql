CREATE PROC sp_eqSummaryByUnit
AS
SELECT
CASE WHEN unit_name IS NULL THEN 'Total' ELSE unit_name END AS unit_name
,Scope,Done
FROM (
SELECT
tblUnits.unit_name
,COUNT(tblEquipment.tag) AS Scope
,COUNT(tblEquipment.erected_date) AS Done
FROM tblEquipment
INNER JOIN tblUnits ON tblEquipment.unit_id = tblUnits.unit_id
GROUP BY ROLLUP(tblUnits.unit_name)
) AS vSummary
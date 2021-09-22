ALTER VIEW CableScope
AS
SELECT
unit_id,[discipline],cable_type
,SUM(design_length) AS [Total Length]
,Count(tag)*2 AS [Termination Scope]
FROM tblCables
WHERE active = 1
GROUP BY unit_id,[discipline],cable_type
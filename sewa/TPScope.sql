CREATE VIEW TPScope
AS
SELECT
unit_id,[test_type] AS [Type],
COUNT(ht_id) AS Scope
FROM tblHT
GROUP BY unit_id,[test_type]
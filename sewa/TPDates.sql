CREATE VIEW TPDates
AS
SELECT
unit_id,[test_type] AS [Type],tested_date,
COUNT(ht_id) AS Done
FROM tblHT
WHERE tested_date IS NOT NULL
GROUP BY unit_id,[test_type],tested_date
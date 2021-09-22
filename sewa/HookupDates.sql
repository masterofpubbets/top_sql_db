CREATE VIEW HookupDates
AS
SELECT
unit_id,hookup_type AS [Hookup Type],hookup_date,
COUNT(tag) AS Done
FROM tblInstruments
WHERE active = 1
AND hookup_require = 1
AND calibration_date IS NOT NULL
GROUP BY unit_id,hookup_type,hookup_date
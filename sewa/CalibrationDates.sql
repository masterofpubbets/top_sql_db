ALTER VIEW CalibrationDates
AS
SELECT
unit_id,calibration_date,
COUNT(tag) AS Done
FROM tblInstruments
WHERE active = 1
AND calibration_require = 1
AND calibration_date IS NOT NULL
GROUP BY unit_id,calibration_date
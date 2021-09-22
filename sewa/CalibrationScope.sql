CREATE VIEW CalibrationScope
AS
SELECT
unit_id,
COUNT(tag) AS Scope
FROM tblInstruments
WHERE active = 1
AND calibration_require = 1
GROUP BY unit_id
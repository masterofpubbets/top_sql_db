CREATE VIEW InstrumentsInstalled
AS
SELECT
unit_id,device_type,installed_date AS [Installed Date]
,COUNT(installed_date) AS Installed
FROM tblInstruments
WHERE active = 1
AND tblInstruments.main_device = 1 
AND Installation_scope <> 'Vendor'
GROUP BY unit_id,device_type,installed_date
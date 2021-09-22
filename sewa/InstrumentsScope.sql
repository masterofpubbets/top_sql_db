CREATE VIEW InstrumentsScope
AS
SELECT
unit_id,device_type
,COUNT(tag) AS Scope
FROM tblInstruments
WHERE active = 1
AND tblInstruments.main_device = 1 
AND Installation_scope <> 'Vendor'
GROUP BY unit_id,device_type
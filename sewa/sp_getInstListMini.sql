CREATE PROC sp_getInstListMini
AS
SELECT
tblUnits.unit_name AS Unit
,tblInstruments.tag AS Tag
,CASE WHEN (tblInstruments.main_device = 1) THEN 'Device' ELSE 'Accessory' END AS [Device]
,tblInstruments.device_type AS [Category]
,tblInstruments.installation_scope AS [Install By]
,tblInstruments.[type] AS [Type]
,CASE WHEN tblInstruments.calibration_require = 0 THEN 'n/a' 
ELSE CONVERT(NVARCHAR(50),FORMAT(tblInstruments.calibration_date,'dd/MM/yyyy')) END AS Calibration
,FORMAT(tblInstruments.installed_date,'dd/MM/yyyy') AS [Installed]
,CASE WHEN tblInstruments.hookup_require = 0 THEN 'n/a' 
ELSE CONVERT(NVARCHAR(50),FORMAT(tblInstruments.hookup_date,'dd/MM/yyyy')) END AS Hookup
FROM tblInstruments
INNER JOIN tblUnits ON tblInstruments.unit_id = tblUnits.unit_id
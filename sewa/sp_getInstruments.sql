ALTER PROC sp_getInstruments
AS
SELECT tblUnits.unit_name AS Unit,tblTOP.top_name AS [TOP Name]
,tblInstruments.ins_id AS ID,tblInstruments.tag AS Tag,tblInstruments.installation_actid AS [Installation ActId]
,tblInstruments.Installation_scope AS [Installation Scope],tblInstruments.device_type AS [Device Type]
,CASE WHEN tblInstruments.main_device = 1 THEN 'Yes' ELSE 'Accessory' END AS [Main Device]
,tblInstruments.description AS [Description],tblInstruments.type AS [type],tblInstruments.rev_no AS [Revision]
,tblInstruments.po AS [PO],tblInstruments.pid AS [P&ID]
,CASE WHEN tblInstruments.calibration_require =1 THEN 'Yes' ELSE 'No' END AS [Calibration Required]
,tblInstruments.calibration_date AS [Calibration Date]
,tblInstruments.calibrationRFINo AS [Calibration RFI No]
,tblInstruments.installed_date AS [Installed Date]
,CASE WHEN tblInstruments.hookup_require = 1 THEN 'Yes' ELSe 'No' END AS [Hookup Required]
,CASE WHEN tblInstruments.hookup_require = 1 THEN tblInstruments.hookup_type ELSE 'N/A' END AS [Hookup Type]
,tblInstruments.hookup_date AS [Hookup Date]
,tblInstruments.hookupRFINo AS [Hookup RFI No]
,CASE WHEN tblInstruments.leak_test_require = 1 THEN 'Yes' ELSE 'No' END AS [Leak Test Required]
,tblInstruments.leak_test_date AS [Leak Test Date]
,tblInstruments.leakTestRFINo AS [Leak Test RFI No]
,tblInstruments.test_date AS [Test Date],tblInstruments.remarks AS Remarks,tblInstruments.last_update_source AS [Last Update Source]
,tblInstruments.oldTag AS [Old Tag],tblInstruments.active AS Active
FROM tblInstruments WITH (NoLock)
INNER JOIN tblUnits On tblUnits.unit_id = tblInstruments.unit_id 
INNER JOIN tblTOP On tblTOP.top_id = tblInstruments.top_id
ALTER PROC sp_getTP
AS
SELECT tblHT.ht_id AS [Id],tblunits.unit_name AS Unit, tblTOP.top_name AS [TOP]
,tblHT.ht_name AS [Test Pack],tblHT.subcon AS Subcontractor,tblHT.test_type AS [Test Type]
,tblHT.test_pressure AS [Test Pressure],tblHT.prio AS Priority
,tblHT.dia_scope AS [Dia Scope]
,tblHT.dia_complete AS [Dia Complete]
,tblHT.dia_scope - tblHT.dia_complete AS [Dia Pending]
,tblHT.joints_scope AS [Joints Scope],tblHT.joints_welded AS [Joints Welded]
,tblHT.joints_qc_done AS [QC Done],tblHT.a_punch AS [Punch A],tblHT.target_date AS [Target Date]
,tblHT.tested_date AS [Tested Date],tblHT.reinstated_date AS [Reinstated Date]
,tblHT.remarks AS Remarks
,tblHT.testPackRev AS [Test Pack Rev]
,tblHT.engRemark AS [Eng Remark]

FROM tblHT 
Inner JOIN tblUnits ON tblUnits.unit_id = tblHT.unit_id 
INNER JOIN tblTOP ON tbltop.top_id = tblHT.top_id
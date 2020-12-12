ALTER PROC sp_getTestPackDetails
@tp NVARCHAR(100) = NULL
AS
IF @tp IS NULL
    SELECT 
    tblUnits.unit_name AS Unit,tblTop.top_name AS [Top]
    ,tblHT.ht_name AS Tag,tblHT.subcon AS Subcontractor,tblHT.test_type AS [Test Type]
    ,tblHT.dia_scope AS [Dia Scope]
    ,tblHT.joints_scope AS [Joints Scope],tblHT.joints_welded AS [Welded]
    ,tblHT.joints_qc_done AS [Joints Qc Released]
    ,FORMAT(tblHT.tested_date,'dd/MM/yyyy') AS [Test Date]
    ,FORMAT(tblHT.reinstated_date,'dd/MM/yyyy') AS [Reinstated Date]
    FROM tblHT
    INNER JOIN tblTOP ON tblHT.top_id = tblTOP.top_id
    INNER JOIN tblUnits ON tblHT.unit_id = tblUnits.unit_id
ELSE
    SELECT 
    tblUnits.unit_name AS Unit,tblTop.top_name AS [Top]
    ,tblHT.ht_name AS Tag,tblHT.subcon AS Subcontractor,tblHT.test_type AS [Test Type]
    ,tblHT.dia_scope AS [Dia Scope]
    ,tblHT.joints_scope AS [Joints Scope],tblHT.joints_welded AS [Welded]
    ,tblHT.joints_qc_done AS [Joints Qc Released]
    ,FORMAT(tblHT.tested_date,'dd/MM/yyyy') AS [Test Date]
    ,FORMAT(tblHT.reinstated_date,'dd/MM/yyyy') AS [Reinstated Date]
    FROM tblHT
    INNER JOIN tblTOP ON tblHT.top_id = tblTOP.top_id
    INNER JOIN tblUnits ON tblHT.unit_id = tblUnits.unit_id
    WHERE tblHT.ht_name = @tp
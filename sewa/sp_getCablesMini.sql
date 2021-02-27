ALTER PROC sp_getCablesMini
AS
SELECT 
tblUnits.unit_name AS Unit
,tblCables.tag AS Tag
,tblTop.top_name AS [Top]
,tblCables.from_eq AS [From],tblCables.to_eq AS [To]
,tblCables.design_length AS [Design Length],tblCables.actual_length AS [Actual Length]
,FORMAT(tblCables.pulled_date,'dd/MM/yyyy') AS [Pulled Date]
,FORMAT(tblCables.con_from_date,'dd/MM/yyyy') AS [Con From Date]
,FORMAT(tblCables.con_to_date,'dd/MM/yyyy') AS [Con To Date]
,FORMAT(tblCables.test_date,'dd/MM/yyyy') AS [Test Date]
FROM tblCables
INNER JOIN tblUnits ON tblCables.unit_id = tblUnits.unit_id
INNER JOIN tblTop ON tblCables.top_id = tblTop.top_id
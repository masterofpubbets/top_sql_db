ALTER PROC sp_getTops
AS
SELECT
tblTop.top_id AS Id
,tblUnits.unit_name AS Unit
,tblTOP.top_name AS [TOP],tblTOP.subsystem_description AS [TOP Description],tblTOP.type_name AS [Type],tblTop.alternate_tag AS [Alternate Tag],tblTOP.div_name AS DIV
,tblSystems.systemName AS [System Name],tblSystems.systemKKS AS [System KKS],tblSystems.systemDescription AS [System Description]
,tblTOP.res AS [Responsible],tblTOP.supervisor AS Supervisor,tblTOP.warroom_pri AS [Handover Priority],tblTOP.comm_block AS [Block]
,tblTOP.comm_pri AS [Comm Priority],tblTOP.discipline AS Discipline,tblTOP.remarks AS Remarks,tblTOP.issues AS Issues,tblTOP.resolve_issues_res AS [Issue Responsible]
,tblTOP.resolve_issues_date AS [Resolve Date]
,tblTOP.war_room_selected AS Selected,tblTOP.late_start_date AS [Late Start Date],tblTOP.walk_through_date AS [Walkthrough Date],tblTOP.transfer_date AS [Transfer Date]
,tblTOP.week_target AS [Week Target Date],tblTOP.isPartial AS [isPartial],tblTOP.priority AS Priority
,tblTOP.internal_date AS [Internal Date],tblTOP.plan_ho_date AS [Plan Handover Date]
,tblTOP.cod AS COD
,tblTOP.sequenceName AS [Sequence]
FROM tblTOP
INNER JOIN tblUnits ON tblTOP.unit_id = tblUnits.unit_id
INNER JOIN tblSystems ON tblTop.systemId = tblSystems.sysId

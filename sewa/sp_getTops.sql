CREATE PROC sp_getTops
AS
SELECT
tblTop.top_id
,tblUnits.unit_name
,tblTOP.type_name,tblTOP.top_name,tblTOP.div_name,tblTOP.system_name,tblTOP.kks,tblTOP.system_description,tblTOP.subsystem_description,tblTOP.res
,tblTOP.supervisor,tblTOP.warroom_pri,tblTOP.comm_block,tblTOP.comm_pri,tblTOP.discipline,tblTOP.remarks,tblTOP.issues,tblTOP.resolve_issues_date,tblTOP.resolve_issues_res
,tblTOP.war_room_selected,tblTOP.late_start_date,tblTOP.walk_through_date,tblTOP.transfer_date,tblTOP.week_target,tblTOP.isPartial,tblTOP.priority,tblTOP.internal_date,tblTOP.plan_ho_date
FROM tblTOP
INNER JOIN tblUnits ON tblTOP.unit_id = tblUnits.unit_id

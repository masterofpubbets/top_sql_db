ALTER PROC sp_getCables
AS
SELECT 
tblCables.cable_id
,tblTop.top_name
,tblUnits.unit_name
,tblCables.pulling_actid,tblCables.con_actid,tblCables.status,tblCables.discipline,tblCables.cable_type,tblCables.tag,tblCables.code,tblCables.description
,tblCables.diameter,tblCables.service_level,tblCables.from_eq,tblCables.from_decription,tblCables.to_eq,tblCables.to_description,tblCables.pulling_area_from,tblCables.pulling_area_to
,tblCables.wiring_diagram,tblCables.wd_sheet,tblCables.wd_rev,tblCables.routing_status,tblCables.routing_rev,tblCables.route,tblCables.drum,tblCables.design_length
,tblCables.pulled_date,tblCables.plan_pulling_date,tblCables.actual_length,tblCables.con_from_date,tblCables.con_to_date,tblCables.plan_connected_date,tblCables.test_date,tblCables.rfi_no
,tblCables.batch_no,tblCables.team,tblCables.remarks,tblCables.area,tblCables.incentive_area,tblCables.actual_subcon_con_from,tblCables.actual_subcon_con_to,tblCables.last_update_source
FROM tblCables
INNER JOIN tblUnits ON tblCables.unit_id = tblUnits.unit_id
INNER JOIN tblTop ON tblCables.top_id = tblTop.top_id
ALTER PROC sp_getCables
AS
SELECT 
tblUnits.unit_name AS Unit,tblTOP.top_name AS [TOP],tblTOP.type_name AS [TOP Type]
,tblCables.cable_id AS CableID,tblCables.[sequenceNumber] AS [Sequence Number]
,tblCables.tag AS Tag,tblCables.[from_eq] AS [From Eq],tblCables.[from_decription] AS [From Decription]
,tblCables.[to_eq] AS [To Eq],tblCables.[to_description] AS [To Description],tblCables.[discipline] AS [Discipline],tblCables.[cable_type] AS [Cable Type]
,tblCables.[design_length] AS [Design Length],tblCables.[description] AS [Description],tblCables.[pulled_date] AS [Pulled Date],tblCables.[actual_length] AS [Actual Length]
,tblCables.[plan_pulling_date] AS [Plan Pulling Date],tblCables.[con_from_date] AS [Con From Date],tblCables.[con_to_date] AS [Con To Date]
,tblCables.[plan_connected_date] AS [Plan Connected Date],tblCables.[test_date] AS [Test Date],tblCables.[rfi_no] AS [RFI No]
,tblCables.[last_update_source] AS [Last Update Source]
,tblCables.[pulling_area_from] AS [Pulling Area From],tblCables.[pulling_area_to] AS [Pulling Area To],tblCables.[wiring_diagram] AS [Wiring Diagram]
,tblCables.[wd_sheet] AS [WD Sheet],tblCables.[wd_rev] AS [WD Rev],tblCables.[routing_status] AS [Routing Status],tblCables.[routing_rev] AS [Routing Rev]
,tblCables.[route] AS [Route],tblCables.[diameter] AS [Diameter],tblCables.[service_level] AS [Service Level]
,tblDrums.[tag] AS [Drum],tblCables.[code] AS [Code],tblCables.[status] AS [Status],tblCables.[batch_no] AS [Batch No],tblCables.revision AS Revision
,tblCables.[team] AS [Team],tblCables.[area] AS [Area],tblCables.[incentive_area] AS [Incentive Area],tblCables.[actual_subcon_con_from] AS [Actual Subcon Con From]
,tblCables.[actual_subcon_con_to] AS [Actual Subcon Con To],tblCables.[pulling_actid] AS [Pulling Actid],tblCables.[con_actid] AS [Con Actid]
,tblCables.[last_update_source] AS [Last Update Source]
,tblCables.[oldTag] AS [Old Tag]
,tblCables.[remarks] AS [Remarks]
,tblCables.[active] AS [Active]

FROM tblCables WITH (NOLOCK)
INNER JOIN tblUnits On tblUnits.unit_id = tblCables.unit_id 
INNER JOIN tblTOP On tblTOP.top_id = tblCables.top_id
LEFT JOIN tblDrums ON tblCables.drumId = tblDrums.drumId
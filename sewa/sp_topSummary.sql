SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[sp_topSummary]
AS

SELECT 
[index],[WAR ROOM PRIORITY],[COMM BLOCK],[COMMISSIONING PRIROITY],[TOP],[PLAN HO DATE] as [CLIENT/GE BASE LINE DATE]
,[Target Date],[LATE DATE],walk_through_date as [Walkthrough Date],transfer_date as [Trensfer Date],isPartial
,[Subsystem description],[Resp.],
[TP SCP],[TP ACT],[TP % COMPLETED],[RST SCP],[RST ACT],[RST % COMPLETED],[EQ SCP],[EQ ACT],[EQ % COMPLETED],[CL SCP],[CL ACT],[CL % COMPLETED],
[CT SCP],[CT ACT],[CT % COMPLETED],[INS SCP],[INS ACT],[INS % COMPLETED],[HK SCP],[HK ACT],[HK % COMPLETED],[SI SCP],[SI ACT],[SI % COMPLETED],
Issues,[Responsible]

,CASE WHEN ([TP % COMPLETED]+[RST % COMPLETED]+[EQ % COMPLETED]+[CL % COMPLETED]+[CT % COMPLETED]+[INS % COMPLETED]+[HK % COMPLETED]+[SI % COMPLETED]) = 0 THEN 0
ELSE
ROUND(CONVERT(FLOAT,([TP % COMPLETED]+[RST % COMPLETED]+[EQ % COMPLETED]+[CL % COMPLETED]+[CT % COMPLETED]+[INS % COMPLETED]+[HK % COMPLETED]+[SI % COMPLETED])) / 8,0)
END AS [TOTAL % DONE]

,CASE WHEN (transfer_date IS NOT NULL) THEN 'Trensfered'
 WHEN ([Target Date] IS NOT NULL) AND ([Target Date] < getdate()) AND (transfer_date IS NULL) THEN 'Late' 
 ELSE 'Pending' END AS [Status]

,[Type],SELECTED,[Division]
,tblUnits.unit_name as Unit
,[Week Target Date]
,[Priority],internal_date as [Internal Date],cod as COD

FROM
(
SELECT dbo.tblTOP.top_id as [index],[warroom_pri] as [WAR ROOM PRIORITY],[comm_block] as [COMM BLOCK]
,[comm_pri] as [COMMISSIONING PRIROITY],[top_name] as [TOP]
,[plan_ho_date] as [PLAN HO DATE],resolve_issues_date as [Target Date],late_start_date as [LATE DATE],[subsystem_description] as [Subsystem description],[res] as [Resp.]

,CASE WHEN vItems.[HT SCOPE] IS NULL THEN 0 ELSE vItems.[HT SCOPE] END AS [TP SCP]
,CASE WHEN vItems.[HT ACTUAL] IS NULL THEN 0 ELSE vItems.[HT ACTUAL] END AS [TP ACT]
,CASE WHEN vItems.[HT % COMPLETED] IS NULL THEN 100 ELSE vItems.[HT % COMPLETED] END AS [TP % COMPLETED]
,CASE WHEN vItems.[REINSTATED SCOPE] IS NULL THEN 0 ELSE vItems.[REINSTATED SCOPE] END AS [RST SCP]
,CASE WHEN vItems.[REINSTATED ACTUAL] IS NULL THEN 0 ELSE vItems.[REINSTATED ACTUAL] END AS [RST ACT]
,CASE WHEN vItems.[REINSTATED % COMPLETED] IS NULL THEN 100 ELSE vItems.[REINSTATED % COMPLETED] END AS [RST % COMPLETED]
,CASE WHEN vItems.[EQUIPMENT SCOPE] IS NULL THEN 0 ELSE vItems.[EQUIPMENT SCOPE] END AS [EQ SCP]
,CASE WHEN vItems.[EQUIPMENT ACTUAL] IS NULL THEN 0 ELSE vItems.[EQUIPMENT ACTUAL] END AS [EQ ACT]
,CASE WHEN vItems.[EQUIPMENT % COMPLETED] IS NULL THEN 100 ELSE vItems.[EQUIPMENT % COMPLETED] END AS [EQ % COMPLETED]
,CASE WHEN vItems.[CABLE LAYING SCOPE (NO)] IS NULL THEN 0 ELSE vItems.[CABLE LAYING SCOPE (NO)] END AS [CL SCP]
,CASE WHEN vItems.[CABLE LAYING ACTUAL (NO)] IS NULL THEN 0 ELSE vItems.[CABLE LAYING ACTUAL (NO)] END AS [CL ACT]
,CASE WHEN vItems.[CABLE LAYING % COMPLETED] IS NULL THEN 100 ELSE vItems.[CABLE LAYING % COMPLETED] END AS [CL % COMPLETED]
,CASE WHEN vItems.[CABLE TERMINATION SCOPE (NO)] IS NULL THEN 0 ELSE vItems.[CABLE TERMINATION SCOPE (NO)] END AS [CT SCP]
,CASE WHEN vItems.[CABLE TERMINATION ACTUAL (NO)] IS NULL THEN 0 ELSE vItems.[CABLE TERMINATION ACTUAL (NO)] END AS [CT ACT]
,CASE WHEN vItems.[CABLE TERMINATION % COMPLETED] IS NULL THEN 100 ELSE vItems.[CABLE TERMINATION % COMPLETED] END AS [CT % COMPLETED]
,CASE WHEN vItems.[INSTRUMENT SCOPE] IS NULL THEN 0 ELSE vItems.[INSTRUMENT SCOPE] END AS [INS SCP]
,CASE WHEN vItems.[INSTRUMENT ACTUAL] IS NULL THEN 0 ELSE vItems.[INSTRUMENT ACTUAL] END AS [INS ACT]
,CASE WHEN vItems.[INSTRUMENT % COMPLETED] IS NULL THEN 100 ELSE vItems.[INSTRUMENT % COMPLETED] END AS [INS % COMPLETED]
,CASE WHEN vItems.[HOOKUP SCOPE] IS NULL THEN 0 ELSE vItems.[HOOKUP SCOPE] END AS [HK SCP]
,CASE WHEN vItems.[HOOKUP ACTUAL] IS NULL THEN 0 ELSE vItems.[HOOKUP ACTUAL] END AS [HK ACT]
,CASE WHEN vItems.[HOOKUP % COMPLETED] IS NULL THEN 100 ELSE vItems.[HOOKUP % COMPLETED] END AS [HK % COMPLETED]
,CASE WHEN vItems.[SIGNAL SCOPE] IS NULL THEN 0 ELSE vItems.[SIGNAL SCOPE] END AS [SI SCP]
,CASE WHEN vItems.[SIGNAL ACTUAL] IS NULL THEN 0 ELSE vItems.[SIGNAL ACTUAL] END AS [SI ACT]
,CASE WHEN vItems.[SIGNAL % COMPLETED] IS NULL THEN 100 ELSE vItems.[SIGNAL % COMPLETED] END AS [SI % COMPLETED]

,Issues,resolve_issues_res as [Responsible]
,war_room_selected as SELECTED
,walk_through_date,transfer_date
,tblTOP.[type_name] as [TYPE]
,div_name as [Division]
,unit_id,week_target as [Week Target Date],isPartial
,[Priority],internal_date,cod


FROM dbo.tblTOP WITH (NOLOCK)
LEFT JOIN (
--Main Items
SELECT
top_id
,CASE WHEN [HT SCOPE] IS NULL THEN 0 ELSE [HT SCOPE] END AS [HT SCOPE]
,CASE WHEN [HT ACTUAL] IS NULL THEN 0 ELSE [HT ACTUAL] END AS [HT ACTUAL]
,CASE WHEN [HT SCOPE] IS NULL THEN 100 ELSE ROUND(CONVERT(FLOAT,[HT ACTUAL]) *100 / CONVERT(FLOAT,[HT SCOPE]),0) END AS [HT % COMPLETED]

,CASE WHEN [REINSTATED SCOPE] IS NULL THEN 0 ELSE [REINSTATED SCOPE] END AS [REINSTATED SCOPE]
,CASE WHEN [REINSTATED ACTUAL] IS NULL THEN 0 ELSE [REINSTATED ACTUAL] END AS [REINSTATED ACTUAL]
,CASE WHEN [REINSTATED SCOPE] IS NULL THEN 100 ELSE ROUND(CONVERT(FLOAT,[REINSTATED ACTUAL]) *100 / CONVERT(FLOAT,[REINSTATED SCOPE]),0) END AS [REINSTATED % COMPLETED]

,CASE WHEN [EQUIPMENT SCOPE] IS NULL THEN 0 ELSE [EQUIPMENT SCOPE] END AS [EQUIPMENT SCOPE]
,CASE WHEN [EQUIPMENT ACTUAL] IS NULL THEN 0 ELSE [EQUIPMENT ACTUAL] END AS [EQUIPMENT ACTUAL]
,CASE WHEN [EQUIPMENT SCOPE] IS NULL THEN 100 ELSE ROUND(CONVERT(FLOAT,[EQUIPMENT ACTUAL]) *100 / CONVERT(FLOAT,[EQUIPMENT SCOPE]),0) END AS [EQUIPMENT % COMPLETED]

,CASE WHEN [CABLE LAYING SCOPE (NO)] IS NULL THEN 0 ELSE [CABLE LAYING SCOPE (NO)] END AS [CABLE LAYING SCOPE (NO)]
,CASE WHEN [CABLE LAYING ACTUAL (NO)] IS NULL THEN 0 ELSE [CABLE LAYING ACTUAL (NO)] END AS [CABLE LAYING ACTUAL (NO)]
,CASE WHEN [CABLE LAYING SCOPE (NO)] IS NULL THEN 100 ELSE ROUND(CONVERT(FLOAT,[CABLE LAYING ACTUAL (NO)]) *100 / CONVERT(FLOAT,[CABLE LAYING SCOPE (NO)]),0) END AS [CABLE LAYING % COMPLETED]

,CASE WHEN [CABLE TERMINATION SCOPE (NO)] IS NULL THEN 0 ELSE [CABLE TERMINATION SCOPE (NO)] END AS [CABLE TERMINATION SCOPE (NO)]
,CASE WHEN [CABLE TERMINATION ACTUAL (NO)] IS NULL THEN 0 ELSE [CABLE TERMINATION ACTUAL (NO)] END AS [CABLE TERMINATION ACTUAL (NO)]
,CASE WHEN [CABLE TERMINATION SCOPE (NO)] IS NULL THEN 100 ELSE ROUND(CONVERT(FLOAT,[CABLE TERMINATION ACTUAL (NO)]) *100 / CONVERT(FLOAT,[CABLE TERMINATION SCOPE (NO)]),0) END AS [CABLE TERMINATION % COMPLETED]

,CASE WHEN [INSTRUMENT SCOPE] IS NULL THEN 0 ELSE [INSTRUMENT SCOPE] END AS [INSTRUMENT SCOPE]
,CASE WHEN [INSTRUMENT ACTUAL] IS NULL THEN 0 ELSE [INSTRUMENT ACTUAL] END AS [INSTRUMENT ACTUAL]
,CASE WHEN [INSTRUMENT SCOPE] IS NULL THEN 100 ELSE ROUND(CONVERT(FLOAT,[INSTRUMENT ACTUAL]) *100 / CONVERT(FLOAT,[INSTRUMENT SCOPE]),0) END AS [INSTRUMENT % COMPLETED]

,CASE WHEN [HOOKUP SCOPE] IS NULL THEN 0 ELSE [HOOKUP SCOPE] END AS [HOOKUP SCOPE]
,CASE WHEN [HOOKUP ACTUAL] IS NULL THEN 0 ELSE [HOOKUP ACTUAL] END AS [HOOKUP ACTUAL]
,CASE WHEN [HOOKUP SCOPE] IS NULL THEN 100 ELSE ROUND(CONVERT(FLOAT,[HOOKUP ACTUAL]) *100 / CONVERT(FLOAT,[HOOKUP SCOPE]),0) END AS [HOOKUP % COMPLETED]

,CASE WHEN [Signal SCOPE] IS NULL THEN 0 ELSE [Signal SCOPE] END AS [SIGNAL SCOPE]
,CASE WHEN [Signal ACTUAL] IS NULL THEN 0 ELSE [Signal ACTUAL] END AS [SIGNAL ACTUAL]
,CASE WHEN [Signal SCOPE] IS NULL THEN 100 ELSE ROUND(CONVERT(FLOAT,[Signal ACTUAL]) *100 / CONVERT(FLOAT,[Signal SCOPE]),0) END AS [SIGNAL % COMPLETED]

FROM (

SELECT * FROM (

SELECT 'HT SCOPE' as Discipline
,[top_id]
,count([ht_name]) as dataValue
FROM [dbo].[tblHT] WITH (NOLOCK)
group by [top_id]

UNION ALL

SELECT 'HT ACTUAL' as Discipline
,[top_id]
,count([tested_date]) as dataValue
FROM [dbo].[tblHT] WITH (NOLOCK)
group by [top_id]

---------------------------------------------------------------------------------------------------------

UNION ALL

SELECT 'REINSTATED SCOPE' as Discipline
,[top_id]
,count([ht_name]) as dataValue
FROM [dbo].[tblHT] WITH (NOLOCK)
group by [top_id]

UNION ALL

SELECT 'REINSTATED ACTUAL' as Discipline
,[top_id]
,count([reinstated_date]) as dataValue
FROM [dbo].[tblHT] WITH (NOLOCK)
group by [top_id]

---------------------------------------------------------------------------------------------------------

UNION ALL

SELECT 'EQUIPMENT SCOPE' as Discipline
,[top_id]
,count([tag]) as dataValue
FROM [dbo].[tblEquipment] WITH (NOLOCK)
group by [top_id]

UNION ALL

SELECT 'EQUIPMENT ACTUAL' as Discipline
,[top_id]
,count([erected_date]) as dataValue
FROM [dbo].[tblEquipment] WITH (NOLOCK)
group by [top_id]
---------------------------------------------------------------------------------------------------------

UNION ALL

SELECT 'CABLE LAYING SCOPE (NO)' as Discipline
,[top_id]
,count([tag]) as dataValue
FROM [dbo].[tblCables] WITH (NOLOCK)
group by [top_id]

UNION ALL

SELECT 'CABLE LAYING ACTUAL (NO)' as Discipline
,[top_id]
,count([pulled_date]) as dataValue
FROM [dbo].[tblCables] WITH (NOLOCK)
group by [top_id]
---------------------------------------------------------------------------------------------------------

UNION ALL

SELECT 'CABLE TERMINATION SCOPE (NO)' as Discipline
,[top_id]
,count([tag]) as dataValue
FROM [dbo].[tblCables] WITH (NOLOCK)
group by [top_id]

UNION ALL

SELECT 'CABLE TERMINATION ACTUAL (NO)' as Discipline
,[top_id]
,SUM(case when ([con_from_date] is not null) and ([con_to_date] is not null) THEN 1 else 0 END) as dataValue
FROM [dbo].[tblCables] WITH (NOLOCK)
group by [top_id]
---------------------------------------------------------------------------------------------------------

UNION ALL

SELECT 'INSTRUMENT SCOPE' as Discipline
,[top_id]
,count([tag]) as dataValue
FROM [dbo].[tblInstruments] WITH (NOLOCK)
where main_device=1
group by [top_id]

UNION ALL

SELECT 'INSTRUMENT ACTUAL' as Discipline
,[top_id]
,count([installed_date]) as dataValue
FROM [dbo].[tblInstruments] WITH (NOLOCK)
where main_device=1
group by [top_id]

---------------------------------------------------------------------------------------------------------

UNION ALL

SELECT 'HOOKUP SCOPE' as Discipline
,[top_id]
,count([tag]) as dataValue
FROM [dbo].[tblInstruments] WITH (NOLOCK)
where [hookup_require]=1
group by [top_id]

UNION ALL

SELECT 'HOOKUP ACTUAL' as Discipline
,[top_id]
,count([hookup_date]) as dataValue
FROM [dbo].[tblInstruments] WITH (NOLOCK)
where [hookup_require]=1
group by [top_id]

---------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------

UNION ALL

SELECT 'Signal SCOPE' as Discipline
,[top_id]
,count([tag]) as dataValue
FROM [dbo].[tblSignals] WITH (NOLOCK)
group by [top_id]

UNION ALL

SELECT 'Signal ACTUAL' as Discipline
,[top_id]
,count([loop_done]) as dataValue
FROM [dbo].[tblSignals] WITH (NOLOCK)
group by [top_id]

---------------------------------------------------------------------------------------------------------

) as vAllDetails

PIVOT 
(
	SUM(dataValue)
	FOR Discipline IN ([HT SCOPE],[HT ACTUAL],[REINSTATED SCOPE],[REINSTATED ACTUAL],[EQUIPMENT SCOPE],[EQUIPMENT ACTUAL],[CABLE LAYING SCOPE (NO)],[CABLE LAYING ACTUAL (NO)],[CABLE TERMINATION SCOPE (NO)],[CABLE TERMINATION ACTUAL (NO)],[INSTRUMENT SCOPE],[INSTRUMENT ACTUAL],[HOOKUP SCOPE],[HOOKUP ACTUAL],[Signal SCOPE],[Signal ACTUAL])
) p
) as vAllItems
--END MAIN ITEMS
) as vItems
on dbo.tblTOP.top_id = vItems.top_id
) as vItemsAll
INNER JOIN tblUnits ON vItemsAll.unit_id = tblUnits.unit_id
ORDER BY vItemsAll.[priority]

GO

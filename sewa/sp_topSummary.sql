ALTER PROC sp_topSummary
AS

SELECT 
[index],[WAR ROOM PRIORITY],[COMM BLOCK],[COMMISSIONING PRIROITY],[vItemsAll].[TOP],[Subsystem description] AS [TOP Description],[Resp.] AS [Responsible]
,[PLAN HO DATE] as [CLIENT/GE BASE LINE DATE]
,[LATE DATE],[Target Date]
,walk_through_date as [Walkthrough Date],transfer_date as [Trensfer Date]
,CASE WHEN isPartial = 1 THEN 'Yes' ELSE 'No' END AS isPartial
,CASE WHEN TOPPunchAOpen.[Punch Open] IS NULL THEN 0 ELSE TOPPunchAOpen.[Punch Open] END AS [Punch A Open]
,CASE WHEN TOPPunchAOpenOfficially.[Punch Open Officially] IS NULL THEN 0 ELSE TOPPunchAOpenOfficially.[Punch Open Officially] END AS [Punch A Open Officially]

,[TP SCP],[TP ACT],[TP SCP] - [TP ACT] AS [TP PEN],[TP % COMPLETED]
,[RST SCP],[RST ACT],[RST SCP] - [RST ACT] AS [RST PEN],[RST % COMPLETED]
,[EQ SCP],[EQ ACT],[EQ SCP] - [EQ ACT] AS [EQ PEN],[EQ % COMPLETED]

,[CL SCP],[CL ACT],[CL SCP] - [CL ACT] AS [CL PEN],[CL % COMPLETED]
,[CL LM SCP],[CL LM ACT],[CL LM SCP] - [CL LM ACT] AS [CL LM PEN],[CL LM % COMPLETED]

,[CT SCP],[CT ACT],[CT SCP] - [CT ACT] AS [CT PEN],[CT % COMPLETED]
,[CE SCP],[CE ACT],[CE SCP] - [CE ACT] AS [CE PEN],[CE % COMPLETED]
,[INS SCP],[INS ACT],[INS SCP] - [INS ACT] AS [INS PEN],[INS % COMPLETED]
,[HK SCP],[HK ACT],[HK SCP] - [HK ACT] AS [HK PEN],[HK % COMPLETED]
,[SI SCP],[SI ACT],[SI SCP] - [SI ACT] AS [SI PEN],[SI % COMPLETED]

,CASE WHEN ([TP % COMPLETED]+[RST % COMPLETED]+[EQ % COMPLETED]+[CL % COMPLETED]+[CT % COMPLETED]+[INS % COMPLETED]+[HK % COMPLETED]) = 0 THEN 0
ELSE
ROUND(CONVERT(FLOAT,([TP % COMPLETED]+[RST % COMPLETED]+[EQ % COMPLETED]+[CL % COMPLETED]+[CT % COMPLETED]+[INS % COMPLETED]+[HK % COMPLETED])) / 7,0)
END AS [TOTAL % DONE]

,CASE WHEN (transfer_date IS NOT NULL) THEN 'Trensfered'
 WHEN ([Target Date] IS NOT NULL) AND ([Target Date] < getdate()) AND (transfer_date IS NULL) THEN 'Late' 
 ELSE 'Pending' END AS [Status]

,[Type],SELECTED AS Flag,[Division]
,tblUnits.unit_name as Unit
,[Week Target Date]
,[Priority],internal_date as [Internal Date],cod as COD
,[Sequence]
,Remarks
,Issues,[Responsible] AS [Issue Responsible]
,[Resolve Date]

FROM
(
SELECT dbo.tblTOP.top_id as [index],[warroom_pri] as [WAR ROOM PRIORITY],[comm_block] as [COMM BLOCK]
,[comm_pri] as [COMMISSIONING PRIROITY],[top_name] as [TOP]
,[plan_ho_date] as [PLAN HO DATE],targetDate as [Target Date],late_start_date as [LATE DATE],[subsystem_description] as [Subsystem description],[res] as [Resp.]

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

,CASE WHEN vItems.[CABLE LAYING SCOPE (LM)] IS NULL THEN 0 ELSE vItems.[CABLE LAYING SCOPE (LM)] END AS [CL LM SCP]
,CASE WHEN vItems.[CABLE LAYING ACTUAL (LM)] IS NULL THEN 0 ELSE vItems.[CABLE LAYING ACTUAL (LM)] END AS [CL LM ACT]
,CASE WHEN vItems.[CABLE LAYING LM % COMPLETED] IS NULL THEN 100 ELSE vItems.[CABLE LAYING LM % COMPLETED] END AS [CL LM % COMPLETED]

,CASE WHEN vItems.[CABLE TERMINATION SCOPE (NO)] IS NULL THEN 0 ELSE vItems.[CABLE TERMINATION SCOPE (NO)] END AS [CT SCP]
,CASE WHEN vItems.[CABLE TERMINATION ACTUAL (NO)] IS NULL THEN 0 ELSE vItems.[CABLE TERMINATION ACTUAL (NO)] END AS [CT ACT]
,CASE WHEN vItems.[CABLE TERMINATION % COMPLETED] IS NULL THEN 100 ELSE vItems.[CABLE TERMINATION % COMPLETED] END AS [CT % COMPLETED]
,CASE WHEN vItems.[CABLE ENDS SCOPE (NO)] IS NULL THEN 0 ELSE vItems.[CABLE ENDS SCOPE (NO)] END AS [CE SCP]
,CASE WHEN vItems.[CABLE ENDS ACTUAL (NO)] IS NULL THEN 0 ELSE vItems.[CABLE ENDS ACTUAL (NO)] END AS [CE ACT]
,CASE WHEN vItems.[CABLE ENDS % COMPLETED] IS NULL THEN 100 ELSE vItems.[CABLE ENDS % COMPLETED] END AS [CE % COMPLETED]
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
,resolve_issues_date AS [Resolve Date]
,war_room_selected as SELECTED
,walk_through_date,transfer_date
,tblTOP.[type_name] as [TYPE]
,div_name as [Division]
,unit_id,week_target as [Week Target Date],isPartial
,[Priority],internal_date,cod
,sequenceName AS [Sequence]
,tblTOP.remarks AS [Remarks]

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

,CASE WHEN [CABLE LAYING SCOPE (LM)] IS NULL THEN 0 ELSE [CABLE LAYING SCOPE (LM)] END AS [CABLE LAYING SCOPE (LM)]
,CASE WHEN [CABLE LAYING ACTUAL (LM)] IS NULL THEN 0 ELSE [CABLE LAYING ACTUAL (LM)] END AS [CABLE LAYING ACTUAL (LM)]
,CASE WHEN [CABLE LAYING SCOPE (LM)] IS NULL THEN 100 ELSE ROUND(CONVERT(FLOAT,[CABLE LAYING ACTUAL (LM)]) *100 / CONVERT(FLOAT,[CABLE LAYING SCOPE (LM)]),0) END AS [CABLE LAYING LM % COMPLETED]


,CASE WHEN [CABLE TERMINATION SCOPE (NO)] IS NULL THEN 0 ELSE [CABLE TERMINATION SCOPE (NO)] END AS [CABLE TERMINATION SCOPE (NO)]
,CASE WHEN [CABLE TERMINATION ACTUAL (NO)] IS NULL THEN 0 ELSE [CABLE TERMINATION ACTUAL (NO)] END AS [CABLE TERMINATION ACTUAL (NO)]
,CASE WHEN [CABLE TERMINATION SCOPE (NO)] IS NULL THEN 100 ELSE ROUND(CONVERT(FLOAT,[CABLE TERMINATION ACTUAL (NO)]) *100 / CONVERT(FLOAT,[CABLE TERMINATION SCOPE (NO)]),0) END AS [CABLE TERMINATION % COMPLETED]

,CASE WHEN [CABLE ENDS SCOPE (NO)] IS NULL THEN 0 ELSE [CABLE ENDS SCOPE (NO)] END AS [CABLE ENDS SCOPE (NO)]
,CASE WHEN [CABLE ENDS ACTUAL (NO)] IS NULL THEN 0 ELSE [CABLE ENDS ACTUAL (NO)] END AS [CABLE ENDS ACTUAL (NO)]
,CASE WHEN [CABLE ENDS SCOPE (NO)] IS NULL THEN 100 ELSE ROUND(CONVERT(FLOAT,[CABLE ENDS ACTUAL (NO)]) *100 / CONVERT(FLOAT,[CABLE ENDS SCOPE (NO)]),0) END AS [CABLE ENDS % COMPLETED]

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
WHERE active=1
group by [top_id]

UNION ALL

SELECT 'EQUIPMENT ACTUAL' as Discipline
,[top_id]
,count([erected_date]) as dataValue
FROM [dbo].[tblEquipment] WITH (NOLOCK)
WHERE active=1
group by [top_id]
---------------------------------------------------------------------------------------------------------

UNION ALL

SELECT 'CABLE LAYING SCOPE (NO)' as Discipline
,[top_id]
,count([tag]) as dataValue
FROM [dbo].[tblCables] WITH (NOLOCK)
WHERE active=1
group by [top_id]

UNION ALL

SELECT 'CABLE LAYING ACTUAL (NO)' as Discipline
,[top_id]
,count([pulled_date]) as dataValue
FROM [dbo].[tblCables] WITH (NOLOCK)
WHERE active=1
group by [top_id]
---------------------------------------------------------------------------------------------------------

UNION ALL

SELECT 'CABLE LAYING SCOPE (LM)' as Discipline
,[top_id]
,SUM([design_length]) as dataValue
FROM [dbo].[tblCables] WITH (NOLOCK)
WHERE active=1
group by [top_id]

UNION ALL

SELECT 'CABLE LAYING ACTUAL (LM)' as Discipline
,[top_id]
,SUM([design_length]) as dataValue
FROM [dbo].[tblCables] WITH (NOLOCK)
WHERE pulled_date IS NOT NULL
AND active=1
group by [top_id]
---------------------------------------------------------------------------------------------------------

UNION ALL

SELECT 'CABLE TERMINATION SCOPE (NO)' as Discipline
,[top_id]
,count([tag]) as dataValue
FROM [dbo].[tblCables] WITH (NOLOCK)
WHERE active=1
group by [top_id]

UNION ALL

SELECT 'CABLE TERMINATION ACTUAL (NO)' as Discipline
,[top_id]
,SUM(case when ([con_from_date] is not null) and ([con_to_date] is not null) THEN 1 else 0 END) as dataValue
FROM [dbo].[tblCables] WITH (NOLOCK)
WHERE active=1
group by [top_id]
---------------------------------------------------------------------------------------------------------

UNION ALL

SELECT 'CABLE ENDS SCOPE (NO)' as Discipline
,[top_id]
,count([tag]) * 2 as dataValue
FROM [dbo].[tblCables] WITH (NOLOCK)
WHERE active=1
group by [top_id]

UNION ALL

SELECT 'CABLE ENDS ACTUAL (NO)' as Discipline
,[top_id]
,SUM(case when ([con_from_date] is not null) THEN 1 else 0 END) + SUM(case when ([con_to_date] is not null) THEN 1 else 0 END) as dataValue
FROM [dbo].[tblCables] WITH (NOLOCK)
WHERE active=1
group by [top_id]
---------------------------------------------------------------------------------------------------------

UNION ALL

SELECT 'INSTRUMENT SCOPE' as Discipline
,[top_id]
,count([tag]) as dataValue
FROM [dbo].[tblInstruments] WITH (NOLOCK)
where main_device=1
AND active=1
group by [top_id]

UNION ALL

SELECT 'INSTRUMENT ACTUAL' as Discipline
,[top_id]
,count([installed_date]) as dataValue
FROM [dbo].[tblInstruments] WITH (NOLOCK)
where main_device=1
AND active=1
group by [top_id]

---------------------------------------------------------------------------------------------------------

UNION ALL

SELECT 'HOOKUP SCOPE' as Discipline
,[top_id]
,count([tag]) as dataValue
FROM [dbo].[tblInstruments] WITH (NOLOCK)
where [hookup_require]=1
AND active=1
group by [top_id]

UNION ALL

SELECT 'HOOKUP ACTUAL' as Discipline
,[top_id]
,count([hookup_date]) as dataValue
FROM [dbo].[tblInstruments] WITH (NOLOCK)
where [hookup_require]=1
AND active=1
group by [top_id]

---------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------

UNION ALL

SELECT 'Signal SCOPE' as Discipline
,[top_id]
,count([tag]) as dataValue
FROM [dbo].[tblSignals] WITH (NOLOCK)
WHERE active=1 AND comm_responsible LIKE '%TR%'
group by [top_id]

UNION ALL

SELECT 'Signal ACTUAL' as Discipline
,[top_id]
,count([loop_done]) as dataValue
FROM [dbo].[tblSignals] WITH (NOLOCK)
WHERE active=1 AND comm_responsible LIKE '%TR%'
group by [top_id]

---------------------------------------------------------------------------------------------------------

) as vAllDetails

PIVOT 
(
	SUM(dataValue)
	FOR Discipline IN ([HT SCOPE],[HT ACTUAL],[REINSTATED SCOPE],[REINSTATED ACTUAL],[EQUIPMENT SCOPE],[EQUIPMENT ACTUAL],
	[CABLE LAYING SCOPE (NO)],[CABLE LAYING ACTUAL (NO)],[CABLE LAYING SCOPE (LM)],[CABLE LAYING ACTUAL (LM)],
	[CABLE TERMINATION SCOPE (NO)],[CABLE TERMINATION ACTUAL (NO)],
	[CABLE ENDS SCOPE (NO)],[CABLE ENDS ACTUAL (NO)],[INSTRUMENT SCOPE],[INSTRUMENT ACTUAL],[HOOKUP SCOPE],[HOOKUP ACTUAL],[Signal SCOPE],[Signal ACTUAL])
) p
) as vAllItems
--END MAIN ITEMS
) as vItems
on dbo.tblTOP.top_id = vItems.top_id
) as vItemsAll
INNER JOIN tblUnits ON vItemsAll.unit_id = tblUnits.unit_id
LEFT JOIN (
	SELECT
	top_name AS [TOP],punchCategory AS [Punch Category]
	,COUNT(punchNo) AS [Punch Open]
	FROM (
    	SELECT 
    	tblTOP.top_name
    	,tblPunchList.punchNo,tblPunchCategory.punchCategory
    	FROM tblPunchList
    	INNER JOIN tblPunchCategory ON tblPunchList.punchCatId = tblPunchCategory.punchCatId
    	INNER JOIN tblTOP ON tblPunchList.top_id = tblTOP.top_id
    	WHERE NOT ((tblPunchList.internalClosedDate IS NOT NULL) OR (tblPunchList.closedDate IS NOT NULL))
	) AS vTOPPUnchOpen
	WHERE punchCategory = 'A'
	GROUP BY top_name,punchCategory
) AS TOPPunchAOpen ON vItemsAll.[TOP] = TOPPunchAOpen.[TOP]
LEFT JOIN (
	SELECT
	top_name AS [TOP],punchCategory AS [Punch Category]
	,COUNT(punchNo) AS [Punch Open Officially]
	FROM (
    	SELECT 
    	tblTOP.top_name
    	,tblPunchList.punchNo,tblPunchCategory.punchCategory
    	FROM tblPunchList
    	INNER JOIN tblPunchCategory ON tblPunchList.punchCatId = tblPunchCategory.punchCatId
    	INNER JOIN tblTOP ON tblPunchList.top_id = tblTOP.top_id
    	WHERE tblPunchList.closedDate IS NULL
	) AS vTOPPUnchOpen
	WHERE punchCategory = 'A'
	GROUP BY top_name,punchCategory
) AS TOPPunchAOpenOfficially ON vItemsAll.[TOP] = TOPPunchAOpenOfficially.[TOP]



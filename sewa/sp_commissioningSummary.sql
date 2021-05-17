CREATE PROC sp_commissioningSummary
AS
SELECT
CASE WHEN Unit IS NULL THEN 'Total' ELSE Unit END AS Unit
,CASE WHEN [System] IS NULL THEN 'Total' ELSE [System] END AS [System]
,CASE WHEN [Discipline] IS NULL THEN 'Total' ELSE [Discipline] END AS [Discipline]
,CASE WHEN [Description] IS NULL THEN 'Total' ELSE [Description] END AS [Description]
,COUNT([System]) AS Scope
,COUNT(doneDate) AS Done
FROM (
SELECT
tblUnits.unit_name AS Unit
,tblSystems.systemKKS + '-' + tblSystems.systemDescription AS [System]
,tblPunchDiscipline.punchDisciplineDesc AS [Discipline]
,tblCommTasks.sheetDescription AS [Description]
,tblCommTasks.doneDate
FROM tblCommTasks
INNER JOIN tblSystems ON tblCommTasks.systemId = tblSystems.sysID
INNER JOIN tblUnits ON tblCommTasks.unitId = tblUnits.unit_id
INNER JOIN tblPunchDiscipline ON tblCommTasks.disciplineId = tblPunchDiscipline.punchDiscId

UNION ALL

SELECT 
tblUnits.unit_name AS Unit
,tblSystems.systemKKS + '-' + tblSystems.systemDescription AS [System]
,'Instrumentation Signals' AS [Discipline]
,tblSignals.category AS [Description]
,tblSignals.loop_done AS doneDate
FROM tblSignals
INNER JOIN tblTOP ON tblSignals.top_id = tbltop.top_id
INNER JOIN tblSystems ON tblTop.systemId = tblSystems.sysId
INNER JOIN tblUnits ON tblSignals.unit_id = tblUnits.unit_id

) AS vSummary
GROUP BY Unit,[System],[Discipline],[Description]
ORDER BY Unit,[System],[Discipline],[Description]
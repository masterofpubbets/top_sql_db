CREATE PROC sp_getCommTasks
AS
SELECT
tblCommTasks.comTaskId AS [ID]
,tblUnits.unit_name AS [Unit],tblSystems.systemName AS [System Name],tblSystems.systemKKS AS [System KKS]
,tblTop.top_name AS [TOP]
, tblCommTasks.typeName AS [Type],tblCommTasks.className AS [Class],tblCommTasks.sheetDescription AS [Sheet Description]
,tblCommTasks.reportNumber AS [Report Number]
,tblPunchDiscipline.punchDiscipline AS [Discipline]
,tblCommTasks.itemKKS AS [Item KKS],tblCommTasks.itemDescription AS [Item Description]
,tblCommTasks.doneDate AS [Done Date]
FROM tblCommTasks
INNER JOIN tblUnits ON tblCommTasks.unitId = tblUnits.unit_id
INNER JOIN tblSystems ON tblCommTasks.systemId = tblSystems.sysId
INNER JOIN tblPunchDiscipline ON tblCommTasks.disciplineId = tblPunchDiscipline.punchDiscId
LEFT JOIN tblTop ON tblCommTasks.topId = tblTop.top_id
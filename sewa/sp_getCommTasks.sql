ALTER PROC sp_getCommTasks
AS
SELECT
tblCommTasks.comTaskId AS [ID]
,tblUnits.unit_name AS [Unit],tblSystems.systemKKS AS [System KKS],tblSystems.systemDescription AS [System Description]
,tblTop.top_name AS [TOP]
,tblCommTasks.itemKKS AS [Item KKS],tblCommTasks.itemDescription AS [Item Description]
,tblCommTasks.typeName AS [Type],tblCommTasks.className AS [Class],tblPunchDiscipline.punchDiscipline AS [Discipline]
,tblCommTasks.sheetDescription AS [Sheet Description]
,tblCommTasks.reportNumber AS [Report Number]
,tblCommTasks.doneDate AS [Done Date]
FROM tblCommTasks
INNER JOIN tblUnits ON tblCommTasks.unitId = tblUnits.unit_id
INNER JOIN tblSystems ON tblCommTasks.systemId = tblSystems.sysId
INNER JOIN tblPunchDiscipline ON tblCommTasks.disciplineId = tblPunchDiscipline.punchDiscId
LEFT JOIN tblTop ON tblCommTasks.topId = tblTop.top_id
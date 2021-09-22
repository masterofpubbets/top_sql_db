ALTER PROC sp_getCommTasks
AS
SELECT
tblCommTasks.comTaskId AS [ID]
,tblCommTasks.phase AS Phase
,tblUnits.unit_name AS [Unit],tblSystems.systemKKS AS [System KKS],tblSystems.systemDescription AS [System Description]
,tblTop.top_name AS [TOP]
,tblCommTasks.itemKKS AS [Item KKS],tblCommTasks.itemDescription AS [Item Description]
,tblCommTasks.typeName AS [Type],tblCommTasks.className AS [Class],tblPunchDiscipline.punchDiscipline AS [Discipline]
,tblCommTasks.sheetDescription AS [Sheet Description]
,tblCommTasks.reportNumber AS [Report Number]
,tblCommTasks.doneDate AS [Done Date]
,tblCommTasks.clientDate AS [Client Date],tblCommTasks.constraints AS [Constraint]
,responsible.fullName AS [Constraint Responsible]
,responsible.title AS [Constraint Responsible Title]
,sysOwner.fullName AS [System Owner],sysOwner.title AS [System Owner Title]
FROM tblCommTasks
INNER JOIN tblUnits ON tblCommTasks.unitId = tblUnits.unit_id
INNER JOIN tblSystems ON tblCommTasks.systemId = tblSystems.sysId
INNER JOIN tblPunchDiscipline ON tblCommTasks.disciplineId = tblPunchDiscipline.punchDiscId
LEFT JOIN tblTop ON tblCommTasks.topId = tblTop.top_id
LEFT JOIN tblMembers AS responsible ON tblCommTasks.constResponsibleId = responsible.memberId
LEFT JOIN tblMembers AS sysOwner ON tblCommTasks.systemOwnerId = sysOwner.memberId
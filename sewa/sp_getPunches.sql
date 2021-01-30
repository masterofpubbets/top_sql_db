ALTER PROC sp_getPunches
AS
SELECT 
tblPunchList.punchId as ID
,tblPunchList.punchNo as [Punch No]
,tblTop.top_name AS [Top],tblTop.subsystem_description AS [Top Description]
,tblPunchCategory.punchCategory AS [Category]
,tblPunchList.punchDes AS [Description]
,tblPunchList.punchBlock AS [Unit],tblPunchDiscipline.punchDiscipline AS [Discipline],tblSubcontractor.subconName AS Subcontractor
,CASE WHEN tblMembers.fullName IS NULL THEN 'Not Assigned' ELSE tblMembers.fullName END AS [Responsible]
,tblPunchList.createdDate AS [Created On]
,tblPunchList.internalClosedDate AS [Clear Date],tblPunchList.closedDate AS [Official Closed Date]
,tblPunchList.targetDate AS [Target Date]
,tblPunchList.Issues
,tblPunchList.remarks AS Remarks
,tblTop.war_room_selected AS [Top Flag]
,tblPunchList.appCreatedDate

FROM tblPunchList
INNER JOIN tblPunchDiscipline ON tblPunchList.punchDiscId = tblPunchDiscipline.punchDiscId
INNER JOIN tblPunchCategory ON tblPunchList.punchCatId = tblPunchCategory.punchCatId
INNER JOIN tblSubcontractor ON tblPunchList.subconID = tblSubcontractor.subconID
LEFT JOIN tblMembers ON tblPunchList.memberId = tblMembers.memberId
INNER JOIN tblTop ON tblPunchList.top_id = tblTop.top_id
ORDER BY tblPunchCategory.punchCategory
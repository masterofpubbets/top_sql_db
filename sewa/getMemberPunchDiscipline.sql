CREATE PROC getMemberPunchDiscipline
AS
SELECT
tblMembers.memberId AS [ID]
,tblMembers.fullName AS [Full Name],tblMembers.mail AS Mail,tblMembers.memCode AS [Code],tblMembers.phoneNumber AS [Phone],tblMembers.title AS Title
,tblPunchDiscipline.punchDiscipline AS [Discipline],tblPunchDiscipline.punchDisciplineDesc AS [Discipline Description]
FROM tblMembers
LEFT JOIN tblMemberDiscipline ON tblMembers.memberId = tblMemberDiscipline.memberId
LEFT JOIN tblPunchDiscipline ON tblMemberDiscipline.punchDiscId = tblPunchDiscipline.punchDiscId
ORDER BY tblMembers.fullName,tblPunchDiscipline.punchDiscipline
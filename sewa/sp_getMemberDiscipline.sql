CREATE PROC sp_getMemberDiscipline
AS
SELECT
tblMembers.fullName AS [Full Name],tblMembers.mail AS Mail
,tblPunchDiscipline.punchDiscipline as [Discipline Code],tblPunchDiscipline.punchDisciplineDesc as [Discipline Description]
FROM tblMembers
INNER JOIN tblMemberDiscipline ON tblMembers.memberid = tblMemberDiscipline.memberid
INNER JOIN tblPunchDiscipline ON tblMemberDiscipline.punchDiscId = tblPunchDiscipline.punchDiscId
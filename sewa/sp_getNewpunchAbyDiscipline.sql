CREATE PROC sp_getNewpunchAbyDiscipline
AS
SELECT DISTINCT
tblPunchDiscipline.punchDisciplineDesc
FROM tblPunchList 
INNER JOIN tblMemberDiscipline ON tblPunchList.punchDiscId = tblMemberDiscipline.punchDiscId
INNER JOIN tblMembers ON tblMemberDiscipline.memberId = tblMembers.memberId
INNER JOIN tblPunchDiscipline ON tblPunchList.punchDiscId = tblPunchDiscipline.punchDiscId
INNER JOIN tblPunchCategory ON tblPunchList.punchCatId = tblPunchCategory.punchCatId
WHERE tblPunchList.mailSended = 0
AND tblPunchCategory.punchCategory = 'A'
GROUP BY tblPunchDiscipline.punchDisciplineDesc,tblMembers.fullName,tblMembers.mail,tblPunchCategory.punchCategory
CREATE PROC sp_getNewpunchAbyMember
AS
SELECT DISTINCT
tblMembers.fullName,tblMembers.mail
--,tblPunchDiscipline.punchDisciplineDesc
,tblPunchCategory.punchCategory
,COUNT(tblPunchList.punchId) AS openPunches
FROM tblPunchList 
INNER JOIN tblMemberDiscipline ON tblPunchList.punchDiscId = tblMemberDiscipline.punchDiscId
INNER JOIN tblMembers ON tblMemberDiscipline.memberId = tblMembers.memberId
INNER JOIN tblPunchDiscipline ON tblPunchList.punchDiscId = tblPunchDiscipline.punchDiscId
INNER JOIN tblPunchCategory ON tblPunchList.punchCatId = tblPunchCategory.punchCatId
WHERE closedDate IS NULL AND tblPunchList.memberId IS NULL
AND tblPunchCategory.punchCategory = 'A'
GROUP BY tblMembers.fullName,tblMembers.mail,tblPunchCategory.punchCategory
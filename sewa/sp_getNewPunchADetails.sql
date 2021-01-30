CREATE PROC sp_getNewPunchADetails
AS
SELECT DISTINCT
tblPunchDiscipline.punchDisciplineDesc
,tblPunchCategory.punchCategory
,tblPunchList.punchNo
,tblMembers.fullName,tblMembers.mail
,tblTop.top_name
,FORMAT(tblPunchList.createdDate,'dd/MM/yyyy') AS createdDate
,tblPunchList.punchDes
FROM tblPunchList 
INNER JOIN tblMemberDiscipline ON tblPunchList.punchDiscId = tblMemberDiscipline.punchDiscId
INNER JOIN tblMembers ON tblMemberDiscipline.memberId = tblMembers.memberId
INNER JOIN tblPunchDiscipline ON tblPunchList.punchDiscId = tblPunchDiscipline.punchDiscId
INNER JOIN tblPunchCategory ON tblPunchList.punchCatId = tblPunchCategory.punchCatId
INNER JOIN tblTop ON tblPunchList.top_Id = tblTop.top_id
WHERE tblPunchList.mailSended = 0
AND tblPunchCategory.punchCategory = 'A'
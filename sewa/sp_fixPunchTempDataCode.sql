ALTER PROC sp_fixPunchTempDataCode
AS

--Discipline
UPDATE v
SET punchDisc = punchDiscipline
,isDiscFixed = 1
FROM (
SELECT 
tblPunchList_temp.punchDisc,PunchDiscipline.punchDiscipline
,tblPunchList_temp.isDiscFixed
FROM tblPunchList_temp
LEFT JOIN (
    SELECT tblPunchDiscipline.punchDiscipline,tblPunchDiscipline.punchDiscipline + ':' + REPLACE(tblPunchDiscipline.punchDisciplineDesc,' ','') AS ident FROM tblPunchDiscipline
) AS PunchDiscipline
ON REPLACE(tblPunchList_temp.punchDisc,' ','') = PunchDiscipline.ident
WHERE PunchDiscipline.punchDiscipline IS NOT NULL
) AS v


--Category
UPDATE v
SET punchCat = punchCategory
,isCatFixed = 1
FROM (
SELECT 
tblPunchList_temp.punchCat,PunchCategory.punchCategory
,tblPunchList_temp.isCatFixed
FROM tblPunchList_temp
LEFT JOIN (
    SELECT tblPunchCategory.punchCategory,tblPunchCategory.punchCategoryDes FROM tblPunchCategory
) AS PunchCategory
ON REPLACE(tblPunchList_temp.punchCat,' ','') = PunchCategory.punchCategory + ':' + REPLACE(PunchCategory.punchCategoryDes,' ','')
WHERE PunchCategory.punchCategory IS NOT NULL
) AS v


--Subcontractor
UPDATE v
SET subcon = subconCode
,isSubconFixed = 1
FROM (
SELECT 
tblPunchList_temp.subcon,subcon.subconCode
,tblPunchList_temp.isSubconFixed
FROM tblPunchList_temp
LEFT JOIN (
    SELECT tblSubcontractor.subconCode,tblSubcontractor.subconName FROM tblSubcontractor
) AS subcon
ON REPLACE(tblPunchList_temp.subcon,' ','') = subcon.subconCode + ':' + REPLACE(subcon.subconName,' ','')
WHERE subcon.subconCode IS NOT NULL
) AS v

--Members
UPDATE v
SET responsible = memberId
,isResponsibleFixed = 1
FROM (
SELECT 
tblPunchList_temp.responsible,member.fullName,member.memberId
,tblPunchList_temp.isResponsibleFixed
FROM tblPunchList_temp
LEFT JOIN (
    SELECT tblMembers.memCode,tblMembers.fullName,tblMembers.memberId FROM tblMembers
) AS member
ON REPLACE(tblPunchList_temp.responsible,' ','') = REPLACE(member.memCode,' ','')
WHERE member.memCode IS NOT NULL
) AS v

--Raised By
UPDATE v
SET raisedBy = memberId
,isRaisedByFixed = 1
FROM (
SELECT 
tblPunchList_temp.raisedBy,member.fullName,member.memberId
,tblPunchList_temp.isRaisedByFixed
FROM tblPunchList_temp
LEFT JOIN (
    SELECT tblMembers.memCode,tblMembers.fullName,tblMembers.memberId FROM tblMembers
) AS member
ON REPLACE(REPLACE(tblPunchList_temp.raisedBy,' ',''),'.','') = REPLACE(REPLACE(member.memCode,' ',''),'.','')
WHERE member.memCode IS NOT NULL
) AS v
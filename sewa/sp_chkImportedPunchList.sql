ALTER PROC sp_chkImportedPunchList
AS
--Discipline
SELECT 
'Unknown Discipline' as Error
,tblPunchList_temp.*
FROM tblPunchList_temp
LEFT JOIN (
    SELECT tblPunchDiscipline.punchDiscipline,tblPunchDiscipline.punchDiscipline + ':' + REPLACE(tblPunchDiscipline.punchDisciplineDesc,' ','') AS ident FROM tblPunchDiscipline
) AS PunchDiscipline
ON REPLACE(tblPunchList_temp.punchDisc,' ','') = PunchDiscipline.ident
WHERE PunchDiscipline.punchDiscipline IS NULL AND tblPunchList_temp.isDiscFixed = 0
UNION ALL
--Category
SELECT 
'Unknown Category' as Error
,tblPunchList_temp.*
FROM tblPunchList_temp
LEFT JOIN (
    SELECT tblPunchCategory.punchCategory,tblPunchCategory.punchCategoryDes FROM tblPunchCategory
) AS PunchCategory
ON REPLACE(tblPunchList_temp.punchCat,' ','') = PunchCategory.punchCategory + ':' + REPLACE(PunchCategory.punchCategoryDes,' ','')
WHERE PunchCategory.punchCategory IS NULL AND tblPunchList_temp.isCatFixed = 0
UNION ALL
--Subcontractor
SELECT 
'Unknown Subcontractor' as Error
,tblPunchList_temp.*
FROM tblPunchList_temp
LEFT JOIN (
    SELECT tblSubcontractor.subconCode,tblSubcontractor.subconName FROM tblSubcontractor
) AS subcon
ON REPLACE(tblPunchList_temp.subcon,' ','') = subcon.subconCode + ':' + REPLACE(subcon.subconName,' ','')
WHERE subcon.subconCode IS NULL AND tblPunchList_temp.isSubconFixed = 0
UNION ALL
--Raised By
SELECT 
'Unknown Originator' as Error
,tblPunchList_temp.*
FROM tblPunchList_temp
LEFT JOIN (
    SELECT tblMembers.memCode,tblMembers.fullName FROM tblMembers
) AS members
ON REPLACE(REPLACE(tblPunchList_temp.raisedBy,' ',''),'.','') = REPLACE(REPLACE(members.memCode,' ',''),'.','')
WHERE members.memCode IS NULL AND tblPunchList_temp.isRaisedByFixed = 0
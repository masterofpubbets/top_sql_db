CREATE PROC sp_fixPunchTempDataCode
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
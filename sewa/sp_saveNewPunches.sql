ALTER PROC sp_saveNewPunches
AS
INSERT INTO [tblPunchList] ([punchDiscId],[punchCatId],[subconId],[top_id],[punchNo],[punchBlock],[punchDes],[createdDate],[closedDate],appCreatedDate)
SELECT 
tblPunchDiscipline.punchDiscId,tblPunchCategory.punchCatId,tblSubcontractor.subconId,tblTop.top_id
,tempPunch.punchNo,tempPunch.punchBlock,tempPunch.punchDes,tempPunch.createdDate
,CASE WHEN tempPunch.isClosed = 1 THEN GETDATE() ELSE NULL END AS closedDate
,GETDATE() AS appCreatedDate
FROM (
SELECT 
tblPunchList_temp.* 
FROM tblPunchList_temp
LEFT JOIN [tblPunchList] ON tblPunchList_temp.punchNo = tblPunchList.punchNo
WHERE tblPunchList.punchNo IS NULL
AND isDiscFixed = 1 AND isCatFixed = 1 AND isSubconFixed = 1
) AS tempPunch
INNER JOIN tblSubcontractor ON tempPunch.subcon = tblSubcontractor.subconCode
INNER JOIN tblPunchCategory ON tempPunch.punchCat = tblPunchCategory.punchCategory
INNER JOIN tblPunchDiscipline ON tempPunch.punchDisc = tblPunchDiscipline.punchDiscipline
INNER JOIN tblTOP ON tempPunch.topName = tblTop.top_name

CREATE PROC sp_updateCurrentPunchesClosedDate
AS

UPDATE v
SET 
v.[Current closedDate] = v.closedDate
FROM (
SELECT 
tblPunchList.punchId
,tblPunchList.punchDiscId AS [Current punchDiscId],tblPunchList.punchCatId AS [Current punchCatId],tblPunchList.subconId AS [Current subconId]
,tblPunchList.punchBlock AS [Current punchBlock],tblPunchList.punchDes AS [Current punchDes]
,tblPunchList.closedDate AS [Current closedDate]
,punchs.*
FROM tblPunchList
INNER JOIN (
SELECT 
tblPunchDiscipline.punchDiscId,tblPunchCategory.punchCatId,tblSubcontractor.subconId,tblTop.top_id
,tempPunch.punchNo,tempPunch.punchBlock,tempPunch.punchDes,tempPunch.createdDate
,CASE WHEN tempPunch.isClosed = 1 THEN GETDATE() ELSE NULL END AS closedDate
FROM (
SELECT 
tblPunchList_temp.* 
FROM tblPunchList_temp
INNER JOIN [tblPunchList] ON tblPunchList_temp.punchNo = tblPunchList.punchNo
WHERE isDiscFixed = 1 AND isCatFixed = 1 AND isSubconFixed = 1
) AS tempPunch
INNER JOIN tblSubcontractor ON tempPunch.subcon = tblSubcontractor.subconCode
INNER JOIN tblPunchCategory ON tempPunch.punchCat = tblPunchCategory.punchCategory
INNER JOIN tblPunchDiscipline ON tempPunch.punchDisc = tblPunchDiscipline.punchDiscipline
INNER JOIN tblTOP ON tempPunch.topName = tblTop.top_name
) AS punchs
ON tblPunchList.punchNo = punchs.punchNo
WHERE tblPunchList.closedDate IS NULL
) AS v

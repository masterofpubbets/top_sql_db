ALTER PROC sp_getTopClearedPunchA
AS

SELECT 
tblTop.top_name AS [Top],tblTop.subsystem_description AS [Top Description]

,COUNT(tblPunchList.punchNo) As [Punch A Count]
,MAX(tblPunchList.internalClosedDate) AS [Last Punch Cleared Date]
,MIN(tblPunchList.createdDate) AS [First Punch Created Date]
,CASE WHEN MAX(CASE WHEN tblPunchList.closedDate IS NULL THEN 1 ELSE 0 END) = 0
        THEN MAX(tblPunchList.closedDate)
ELSE NULL
END AS [Official Closed Date]
,CASE WHEN 
    MAX(tblPunchList.internalClosedDate) IS NULL THEN DATEDIFF(DAY,MIN(tblPunchList.createdDate),MAX(tblPunchList.closedDate))
ELSE
    DATEDIFF(DAY,MIN(tblPunchList.createdDate),MAX(tblPunchList.internalClosedDate)) 
END AS [Working Days To Close]


FROM tblPunchList
INNER JOIN tblTop ON tblPunchList.top_id = tblTop.top_id
INNER JOIN tblPunchDiscipline ON tblPunchList.punchDiscId = tblPunchDiscipline.punchDiscId
INNER JOIN tblPunchCategory ON tblPunchList.punchCatId = tblPunchCategory.punchCatId

WHERE tblPunchCategory.punchCategory = 'A'
--AND tblPunchList.closedDate IS NULL

GROUP BY tblTop.top_name,tblTop.subsystem_description
HAVING ((COUNT(tblPunchList.punchNo) = COUNT(tblPunchList.internalClosedDate))
        OR
        (COUNT(tblPunchList.punchNo) = COUNT(tblPunchList.closedDate)))

ORDER BY MAX(tblPunchList.internalClosedDate) DESC
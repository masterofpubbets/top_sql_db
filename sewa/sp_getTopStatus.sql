ALTER PROC sp_getTopStatus
AS
SELECT
tblUnits.unit_name AS Unit
,topStatus.Cod,topStatus.top_name AS [Top],topStatus.div_name AS [Div],topStatus.subsystem_description AS [Description]
,topStatus.walk_through_date AS [Walkthrough Date],topStatus.transfer_date AS [Transfer Date]
,topStatus.isPartial,topStatus.[Status]
FROM (


--Top Has No Punches
SELECT DISTINCT
tblTop.subsystem_description,tblTop.cod,tblTop.Unit_id,tblTop.top_name,tblTop.div_name,tblTop.walk_through_date,tblTop.transfer_date,tblTop.isPartial
,CASE 
        WHEN transfer_date IS NOT NULL THEN 'Transfered'
        WHEN (walk_through_date IS NOT NULL) THEN 'Walkthrough Done and Pending Punches'
        WHEN walk_through_date IS NULL THEN 'Pending'
        
        
    ELSE 'Unknown'
    END AS [Status]
FROM tblTop
LEFT Join tblPunchList ON tblTop.top_id = tblPunchList.top_id
WHERE tblPunchList.top_id IS NULL
AND tblTOP.top_name <> 'UNDEFINED'

UNION ALL
--Top has Punches But Transfered
SELECT DISTINCT
tblTop.subsystem_description,tblTop.cod,tblTop.Unit_id,tblTop.top_name,tblTop.div_name,tblTop.walk_through_date,tblTop.transfer_date,tblTop.isPartial
,'Transfered' AS [Status]
FROM tblTop
INNER Join tblPunchList ON tblTop.top_id = tblPunchList.top_id
WHERE tblTOP.top_name <> 'UNDEFINED'
AND tblTOP.transfer_date IS NOT NULL

UNION ALL
--Top has Punches A Not Cleared
SELECT DISTINCT
tblTop.subsystem_description,tblTop.cod,tblTop.Unit_id,tblTop.top_name,tblTop.div_name,tblTop.walk_through_date,tblTop.transfer_date,tblTop.isPartial
,'Punch A Open' AS [Status]
FROM tblTop
INNER JOIN (
    --Top has Punch A Not Cleared
    SELECT
    tblPunchList.top_id,tblPunchCategory.punchCategory
    ,COUNT(tblPunchCategory.punchCategory) AS [Punches Count]
    ,COUNT(tblPunchList.internalClosedDate) AS [Punches Cleared]
    FROM tblPunchList
    INNER JOIN tblPunchCategory ON tblPunchList.punchCatId = tblPunchCategory.punchCatId
    WHERE tblPunchCategory.punchCategory = 'A'
    AND tblPunchList.closedDate IS NULL
    GROUP BY tblPunchList.top_id,tblPunchCategory.punchCategory
    HAVING COUNT(tblPunchCategory.punchCategory) > 0
    AND COUNT(tblPunchList.internalClosedDate) < COUNT(tblPunchCategory.punchCategory)
) punchAOpen
ON tblTop.top_id = punchAOpen.top_id

UNION ALL
--Top has No Punches A Cleared
SELECT DISTINCT
tblTop.subsystem_description,tblTop.cod,tblTop.Unit_id,tblTop.top_name,tblTop.div_name,tblTop.walk_through_date,tblTop.transfer_date,tblTop.isPartial
,'Ready To Transfer' AS [Status]
FROM tblTop
INNER JOIN (
    --Top has No Punch A Cleared
    SELECT
    tblPunchList.top_id,tblPunchCategory.punchCategory
    ,COUNT(tblPunchCategory.punchCategory) AS [Punches Count]
    ,COUNT(tblPunchList.internalClosedDate) AS [Punches Cleared]
    FROM tblPunchList
    INNER JOIN tblPunchCategory ON tblPunchList.punchCatId = tblPunchCategory.punchCatId
    WHERE tblPunchCategory.punchCategory = 'A'
    AND tblPunchList.closedDate IS NULL
    GROUP BY tblPunchList.top_id,tblPunchCategory.punchCategory
    HAVING COUNT(tblPunchCategory.punchCategory) > 0
    AND COUNT(tblPunchList.internalClosedDate) = COUNT(tblPunchCategory.punchCategory)
) punchAOpen
ON tblTop.top_id = punchAOpen.top_id
WHERE tblTOP.transfer_date IS NULL

UNION ALL
--Top has No Punches A At All
SELECT DISTINCT
tblTop.subsystem_description,tblTop.cod,tblTop.Unit_id,tblTop.top_name,tblTop.div_name,tblTop.walk_through_date,tblTop.transfer_date,tblTop.isPartial
,'Ready To Transfer' AS [Status]
FROM tblTop
INNER JOIN (
    --Top has No Punch A At Al
    SELECT DISTINCT
    tblPunchList.top_id
    FROM tblPunchList
    LEFT JOIN (
        SELECT
        tblPunchList.top_id,tblPunchCategory.punchCategory
        ,COUNT(tblPunchCategory.punchCategory) AS [Punches Count]
        ,COUNT(tblPunchList.closedDate) AS [Punches Closed]
        FROM tblPunchList
        INNER JOIN tblPunchCategory ON tblPunchList.punchCatId = tblPunchCategory.punchCatId
        WHERE tblPunchCategory.punchCategory = 'A'
        AND tblPunchList.closedDate IS NULL
        GROUP BY tblPunchList.top_id,tblPunchCategory.punchCategory
        HAVING COUNT(tblPunchCategory.punchCategory) > 0
    ) AS punchA
    ON tblPunchList.top_id = punchA.top_id
    WHERE punchA.top_id IS NULL
    ) punchAOpen
ON tblTop.top_id = punchAOpen.top_id
WHERE tblTOP.transfer_date IS NULL
) AS topStatus
INNER JOIN tblUnits ON topStatus.unit_id = tblUnits.unit_id
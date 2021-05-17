ALTER PROC sp_drumUsedLength
AS
SELECT tblDrums.tag AS Tag,tblDrums.purchasedLength AS [Purchased Length],tblDrums.receivedLength AS [Received Length]
,CASE WHEN drumUsed.usedLength IS NULL THEN 0 ELSE drumUsed.usedLength END AS [Used Length]
,CASE WHEN drumUsed.usedLength IS NULL THEN tblDrums.receivedLength ELSE tblDrums.receivedLength-drumUsed.usedLength END AS [Remaining Length]
,tblDrums.drumDescription AS [Description]

FROM tblDrums
LEFT JOIN (
    SELECT
    drumId
    ,SUM(CASE WHEN (pulled_date IS NOT NULL) AND actual_length IS NOT NULL THEN actual_length ELSE design_length END) AS usedLength
    FROM tblCables
    GROUP BY drumId
) AS drumUsed
ON tblDrums.drumId = drumUsed.drumId
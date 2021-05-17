CREATE FUNCTION dbo.drumUsedLengthByDrum (
@drum NVARCHAR(100)
)
RETURNS FLOAT
AS
BEGIN
DECLARE @drumId INT
SELECT @drumId = tblDrums.drumId FROM tblDrums WHERE tag = @drum

RETURN (
SELECT CASE WHEN drumUsed.usedLength IS NULL THEN tblDrums.receivedLength ELSE tblDrums.receivedLength-drumUsed.usedLength END AS [Remaining Length]

FROM tblDrums
LEFT JOIN (
    SELECT
    drumId
    ,SUM(CASE WHEN (pulled_date IS NOT NULL) AND actual_length IS NOT NULL THEN actual_length ELSE design_length END) AS usedLength
    FROM tblCables
    WHERE tblCables.drumId = @drumId
    GROUP BY drumId
) AS drumUsed
ON tblDrums.drumId = drumUsed.drumId
WHERE tblDrums.drumId = @drumId
)
END
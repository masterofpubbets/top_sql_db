CREATE PROC QC.ApplyHTRule
AS
--HT
WITH CheckValues AS (
    SELECT
    JointId,Property
    ,MAX(AppliedValue) AS AppliedValue
    FROM TEMP.Joints AS AppliedValues WITH (NOLOCK)
    GROUP BY JointId,Property
)

UPDATE v
SET v.HTChkValue = v.AppliedValue
FROM (
    SELECT 
    WM.Id,WM.HTChkValue,CheckValues.AppliedValue
    FROM PIPING.tblWeldingMap AS WM WITH (NOLOCK)
    INNER JOIN CheckValues ON WM.Id = CheckValues.JointId
    WHERE CheckValues.Property = 'HT'
) AS v
---------------------------------------
CREATE PROC QC.ApplyPWHTRule
AS
--PWHT
WITH CheckValues AS (
    SELECT
    JointId,Property
    ,MAX(AppliedValue) AS AppliedValue
    FROM TEMP.Joints AS AppliedValues WITH (NOLOCK)
    GROUP BY JointId,Property
)

UPDATE v
SET v.PWHTChkValue = v.AppliedValue
FROM (
    SELECT 
    WM.Id,WM.PWHTChkValue,CheckValues.AppliedValue
    FROM PIPING.tblWeldingMap AS WM WITH (NOLOCK)
    INNER JOIN CheckValues ON WM.Id = CheckValues.JointId
    WHERE CheckValues.Property = 'PWHT'
) AS v
-----------------------------------

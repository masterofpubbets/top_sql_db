CREATE PROC QC.ApplyRTUTRule
AS
--RTUT
WITH CheckValues AS (
    SELECT
    JointId,Property
    ,MAX(AppliedValue) AS AppliedValue
    FROM TEMP.Joints AS AppliedValues WITH (NOLOCK)
    GROUP BY JointId,Property
)

UPDATE v
SET v.RTUTChkValue = v.AppliedValue
FROM (
    SELECT 
    WM.Id,WM.RTUTChkValue,CheckValues.AppliedValue
    FROM PIPING.tblWeldingMap AS WM WITH (NOLOCK)
    INNER JOIN CheckValues ON WM.Id = CheckValues.JointId
    WHERE CheckValues.Property = 'RTUT'
) AS v
---------------------------------------
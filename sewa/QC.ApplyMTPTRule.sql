CREATE PROC QC.ApplyMTPTRule
AS
--MTPT
WITH CheckValues AS (
    SELECT
    JointId,Property
    ,MAX(AppliedValue) AS AppliedValue
    FROM TEMP.Joints AS AppliedValues WITH (NOLOCK)
    GROUP BY JointId,Property
)

UPDATE v
SET v.MTPTChkValue = v.AppliedValue
FROM (
    SELECT 
    WM.Id,WM.MTPTChkValue,CheckValues.AppliedValue
    FROM PIPING.tblWeldingMap AS WM WITH (NOLOCK)
    INNER JOIN CheckValues ON WM.Id = CheckValues.JointId
    WHERE CheckValues.Property = 'MTPT'
) AS v
---------------------------------------
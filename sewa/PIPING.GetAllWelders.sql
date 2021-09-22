ALTER PROC PIPING.GetAllWelders
AS
SELECT
WelderID AS Id,WelderName AS [Welder]
,JointId
FROM PIPING.tblWelders
ALTER PROC sp_addCablePlanPullDate
@tag NVARCHAR(100),
@date DATE
AS
UPDATE tblcables SET plan_pulling_date = @date 
WHERE tag = @tag
AND plan_pulling_date IS NULL
GO
ALTER PROC sp_addCablePlanConnDate
@tag NVARCHAR(100),
@date DATE
AS
UPDATE tblcables SET plan_connected_date = @date 
WHERE tag = @tag
AND plan_connected_date IS NULL
GO
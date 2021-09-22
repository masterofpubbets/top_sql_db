ALTER PROC sp_TOPSetTargetDateBYTOP
@top nvarchar(100),
@tDate date = null
AS
update tblTOP
set targetDate = @tDate
where top_name = @top 

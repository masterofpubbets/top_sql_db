CREATE PROC sp_TOPSetResolveDateBYTOP
@top nvarchar(100),
@tDate date = null
AS
update tblTOP
set resolve_issues_date = @tDate
where top_name = @top 

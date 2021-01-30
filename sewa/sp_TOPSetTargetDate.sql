ALTER PROC [dbo].[sp_TOPSetTargetDate]
@id int,
@tDate date = null
AS
update tblTOP
set resolve_issues_date = @tDate
where top_id = @id 
GO

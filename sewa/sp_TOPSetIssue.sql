ALTER PROC sp_TOPSetIssue
@id int,
@isseu text = null,
@res nvarchar(255) = null
AS
update tblTOP
set issues = @isseu,
resolve_issues_res = @res
where top_id = @id 
GO

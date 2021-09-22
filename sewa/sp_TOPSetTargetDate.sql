ALTER PROC [dbo].[sp_TOPSetTargetDate]
@id int,
@tDate date = null
AS
update tblTOP
set targetDate = @tDate
where top_id = @id 
GO

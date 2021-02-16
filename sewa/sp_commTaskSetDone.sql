CREATE PROC sp_commTaskSetDone
@id INT
AS
UPDATE tblCommTasks SET doneDate = GETDATE() WHERE comTaskId = @id AND doneDate IS NULL
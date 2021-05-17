CREATE PROC sp_deleteCommTasks
@comTaskId INT
AS
DELETE FROM tblCommTasks WHERE comTaskId = @comTaskId
CREATE PROC sp_ClearSysOwnerToTask
@commId INT

AS
    UPDATE tblCommTasks SET systemOwnerId = NULL WHERE comTaskId = @commId 

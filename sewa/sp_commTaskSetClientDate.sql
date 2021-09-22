CREATE PROC sp_commTaskSetClientDate
@commId INT,
@clientDate DATE = NULL
AS
UPDATE tblCommTasks SET clientDate = @clientDate WHERE comTaskId = @commId

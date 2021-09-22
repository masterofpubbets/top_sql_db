CREATE PROC sp_clearCommTasksConstraint
@commId INT
AS
UPDATE tblCommTasks SET constraints = NULL, constraintResolvedDate = NULL, constResponsibleId = NULL
WHERE comTaskId = @commId

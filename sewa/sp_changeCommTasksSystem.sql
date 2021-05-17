CREATE PROC sp_changeCommTasksSystem
@comTaskId INT,
@systemKKS NVARCHAR(50)
AS
DECLARE @sysId INT
SELECT @sysId = tblSystems.sysId FROM tblSystems WHERE tblSystems.systemKKS = @systemKKS
UPDATE tblCommTasks SET systemId = @sysId WHERE comTaskId = @comTaskId

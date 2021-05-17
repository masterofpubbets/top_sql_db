CREATE PROC sp_changeCommTasksItemKKS
@comTaskId INT,
@ItemKKS NVARCHAR(100)
AS
UPDATE tblCommTasks SET tblCommTasks.itemKKS = @ItemKKS WHERE comTaskId = @comTaskId
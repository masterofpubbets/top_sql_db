CREATE PROC sp_changeCommTasksItemDescription
@comTaskId INT,
@ItemDescription NVARCHAR(255)
AS
UPDATE tblCommTasks SET tblCommTasks.itemDescription = @ItemDescription WHERE comTaskId = @comTaskId
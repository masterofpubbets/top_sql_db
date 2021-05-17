CREATE PROC sp_changeCommTasksSheetDescription
@comTaskId INT,
@sheet NVARCHAR(100)
AS
UPDATE tblCommTasks SET tblCommTasks.sheetDescription = @sheet WHERE comTaskId = @comTaskId
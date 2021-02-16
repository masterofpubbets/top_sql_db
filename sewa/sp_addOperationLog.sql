CREATE PROC sp_addOperationLog
@description NVARCHAR(250),
@user NVARCHAR(50)
AS
INSERT INTO tblLog (logDescription,userName,logDate)
VALUES (@description,@user,GETDATE())

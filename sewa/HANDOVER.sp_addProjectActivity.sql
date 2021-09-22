ALTER PROC HANDOVER.sp_addProjectActivity
@systemOwner NVARCHAR(255),
@subcon NVARCHAR(255),
@siNo NVARCHAR(255),
@piItemNo NVARCHAR(255),
@description NVARCHAR(MAX),
@scope NVARCHAR(MAX),
@comments NVARCHAR(MAX),
@username NVARCHAR(100)

AS

DECLARE @temp NVARCHAR(250)

SELECT @temp = 'Add Project Activity: ' + @description

BEGIN TRANSACTION

INSERT INTO HANDOVER.tblProjectActivity (systemOwner, subcon, siNo, piItemNo, [description], scope, comments)
    VALUES (@systemOwner, @subcon, @siNo, @piItemNo, @description, @scope, @comments)

INSERT INTO [dbo].[tblLog] (logDescription, userName, logDate)
    VALUES (@temp, @username, GETDATE())

COMMIT



    
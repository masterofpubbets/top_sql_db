ALTER PROC HANDOVER.sp_editProjectActivity
@id INT,
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

SELECT @temp = 'Edit Project Activity: ' + @description

BEGIN TRANSACTION

UPDATE HANDOVER.tblProjectActivity 
    SET systemOwner = @systemOwner,
        subcon = @subcon,
        siNo = @siNo,
        piItemNo = @piItemNo,
        [description] = @description,
        scope = @scope,
        comments = @comments
    WHERE HANDOVER.tblProjectActivity.projectActId = @id

INSERT INTO [dbo].[tblLog] (logDescription, userName, logDate)
    VALUES (@temp, @username, GETDATE())

COMMIT



    
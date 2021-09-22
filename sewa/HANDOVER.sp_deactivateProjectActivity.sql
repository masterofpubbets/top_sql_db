ALTER PROC HANDOVER.sp_deactivateProjectActivity
@id INT,
@description NVARCHAR(100),
@username NVARCHAR(100)

AS
DECLARE @temp NVARCHAR(250)

SELECT @temp = 'Deactivate Project Activity: ' + @description

BEGIN TRANSACTION

UPDATE HANDOVER.tblProjectActivity 
    SET active = 0
WHERE projectActId = @id AND doneDate IS NULL

INSERT INTO [dbo].[tblLog] (logDescription, userName, logDate)
    VALUES (@temp, @username, GETDATE())

COMMIT
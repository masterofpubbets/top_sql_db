CREATE PROC HANDOVER.sp_ctivateProjectActivity
@id INT,
@description NVARCHAR(100),
@username NVARCHAR(100)

AS
DECLARE @temp NVARCHAR(250)

SELECT @temp = 'Activate Project Activity: ' + @description

BEGIN TRANSACTION

UPDATE HANDOVER.tblProjectActivity 
    SET active = 1
WHERE projectActId = @id

INSERT INTO [dbo].[tblLog] (logDescription, userName, logDate)
    VALUES (@temp, @username, GETDATE())

COMMIT
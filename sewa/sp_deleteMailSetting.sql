CREATE PROC sp_deleteMailSetting
@id INT
AS
DELETE FROM tblMailSettings WHERE mailSetId = @id
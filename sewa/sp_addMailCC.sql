CREATE PROC sp_addMailCC
@mailCat NVARCHAR(50),
@cc NVARCHAR(MAX)
AS
DECLARE @id INT
SELECT @id = tblMailSettings.mailSetId FROM tblMailSettings WHERE mailCategory = @mailCat
IF @id IS NULL
    INSERT INTO tblMailSettings(mailCategory, cc) VALUES (@mailCat, @cc)
ELSE
    UPDATE tblMailSettings SET cc = @cc WHERE mailSetId = @id

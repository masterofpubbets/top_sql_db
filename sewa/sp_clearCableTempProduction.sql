CREATE PROC sp_clearCableTempProduction
@userName NVARCHAR(50)
AS
DELETE FROM tblCablePro_temp WHERE user_name = @userName
GO

CREATE PROC sp_delPunch
@punchId INT
AS
DELETE FROM tblPunchList WHERE punchId = @punchId
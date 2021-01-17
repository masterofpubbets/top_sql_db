CREATE PROC sp_clearPunch
@punchNo NVARCHAR(50)

AS
UPDATE tblPunchList SET tblPunchList.internalClosedDate = GETDATE() WHERE tblPunchList.punchNo = @punchNo AND tblPunchList.internalClosedDate IS NULL

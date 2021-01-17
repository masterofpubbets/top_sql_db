CREATE PROC sp_unclearPunch
@punchNo NVARCHAR(50)

AS
UPDATE tblPunchList SET tblPunchList.internalClosedDate = NULL WHERE tblPunchList.punchNo = @punchNo

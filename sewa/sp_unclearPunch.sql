ALTER PROC sp_unclearPunch
@punchNo NVARCHAR(50),
@memberName NVARCHAR(100)

AS
DECLARE @des NVARCHAR(255)

UPDATE tblPunchList SET tblPunchList.internalClosedDate = NULL WHERE tblPunchList.punchNo = @punchNo
SELECT @des = 'Unclear Punch No:' + @punchNo
EXEC sp_addOperationLog @des ,@memberName
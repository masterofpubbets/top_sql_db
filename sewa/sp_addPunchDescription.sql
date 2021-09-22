CREATE PROC sp_addPunchDescription
@punchNo NVARCHAR(100),
@desc NVARCHAR(255)

AS

UPDATE tblPunchList SET punchDes  = @desc WHERE punchNo = @punchNo
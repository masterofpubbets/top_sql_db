ALTER PROC sp_assignRemarktoPunch
@punchNo NVARCHAR(50)
,@remark NVARCHAR(max) = NULL

AS
UPDATE tblPunchList SET tblPunchList.Remarks = @remark WHERE tblPunchList.punchNo = @punchNo 

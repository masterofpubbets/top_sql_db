ALTER PROC sp_assignIssuetoPunch
@punchNo NVARCHAR(50)
,@issue NVARCHAR(max) = NULL

AS
UPDATE tblPunchList SET tblPunchList.issues = @issue WHERE tblPunchList.punchNo = @punchNo 

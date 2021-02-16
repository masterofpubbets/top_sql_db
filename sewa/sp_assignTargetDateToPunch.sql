ALTER PROC sp_assignTargetDateToPunch
@punchNo NVARCHAR(50),
@date DATE = NULL

AS
IF @date IS NOT NULL
    BEGIN
        UPDATE tblPunchList SET tblPunchList.targetDate = @date WHERE tblPunchList.punchNo = @punchNo AND tblPunchList.internalClosedDate IS NULL
    END
ELSE
    BEGIN
        UPDATE tblPunchList SET tblPunchList.targetDate = NULL WHERE tblPunchList.punchNo = @punchNo
    END

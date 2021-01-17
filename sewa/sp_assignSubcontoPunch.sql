CREATE PROC sp_assignSubcontoPunch
@subconName NVARCHAR(100)
,@punchNo NVARCHAR(50)

AS
DECLARE @subId INT

SELECT @subId = subconId FROM tblSubcontractor WHERE subconName = @subconName
IF @subId IS NOT NULL
    BEGIN
        UPDATE tblPunchList SET tblPunchList.subconId = @subId WHERE tblPunchList.punchNo = @punchNo 
    END

CREATE PROC sp_assignMembertoPunch
@memberName NVARCHAR(100)
,@punchNo NVARCHAR(50)

AS
DECLARE @memId INT

SELECT @memId = tblMembers.memberId FROM tblMembers WHERE tblMembers.fullName = @memberName
IF @memId IS NOT NULL
    BEGIN
        UPDATE tblPunchList SET tblPunchList.memberId = @memId WHERE tblPunchList.punchNo = @punchNo 
    END

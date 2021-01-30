ALTER PROC sp_assignMembertoPunch
@memberName NVARCHAR(100)
,@punchNo NVARCHAR(50)
,@user NVARCHAR(50) = NULL
AS
DECLARE @memId INT
DECLARE @des NVARCHAR(255)

SELECT @memId = tblMembers.memberId FROM tblMembers WHERE tblMembers.fullName = @memberName
IF @memId IS NOT NULL
    BEGIN
        UPDATE tblPunchList SET tblPunchList.memberId = @memId WHERE tblPunchList.punchNo = @punchNo 
    END
SELECT @des = 'Assign Responsible: ' + @memberName + ' to Punch No:' + @punchNo
EXEC sp_addOperationLog @des ,@user
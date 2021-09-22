CREATE PROC sp_assignSysOwnerToTask
@commId INT,
@memberName NVARCHAR(100)

AS
DECLARE @memId INT
DECLARE @des NVARCHAR(255)

SELECT @memId = tblMembers.memberId FROM tblMembers WHERE tblMembers.fullName = @memberName
IF @memId IS NOT NULL
    BEGIN
        UPDATE tblCommTasks SET systemOwnerId = @memId WHERE comTaskId = @commId 
    END

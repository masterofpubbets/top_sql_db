CREATE PROC sp_addCommTasksConstraint
@commId INT,
@date DATE,
@responsible NVARCHAR(255),
@constraint NVARCHAR(255)
AS
DECLARE @memID INT
SELECT @memID = tblMembers.memberId FROM tblMembers WHERE tblMembers.fullName = @responsible
UPDATE tblCommTasks SET constraints = @constraint, constraintResolvedDate = @date, constResponsibleId = @memID
WHERE comTaskId = @commId

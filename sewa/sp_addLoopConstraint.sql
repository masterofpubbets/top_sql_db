CREATE PROC sp_addLoopConstraint
@tag NVARCHAR(100),
@date DATE,
@responsible NVARCHAR(255),
@constraint NVARCHAR(255)
AS
DECLARE @memID INT
SELECT @memID = tblMembers.memberId FROM tblMembers WHERE tblMembers.fullName = @responsible
UPDATE tblSignals SET signalConstraint = @constraint, constraintResolvedDate = @date, constraintResponsibleId = @memID
WHERE tblSignals.tag = @tag

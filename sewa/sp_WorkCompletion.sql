CREATE PROC sp_WorkCompletion
@permitNumber INT,
@systemReceiver NVARCHAR(250)
AS
DECLARE @systemReceiverId INT

SELECT @systemReceiverId = HSE.tblHSEMember.memId FROM HSE.tblHSEMember WHERE memberName = @systemReceiver

UPDATE HSE.tblLotoPermit
        SET workCompletionDate = GETDATE(),
            workCompletionReceiverId = @systemReceiverId
WHERE HSE.tblLotoPermit.permitNumber = @permitNumber
CREATE PROC sp_WorkCompletionValidation
@permitNumber INT,
@systemOwner NVARCHAR(250)
AS
DECLARE @systemOwnerId INT

SELECT @systemOwnerId = HSE.tblHSEMember.memId FROM HSE.tblHSEMember WHERE memberName = @systemOwner

UPDATE HSE.tblLotoPermit
        SET workCompletionValidationDate = GETDATE(),
            workValidationOwnerId = @systemOwnerId
WHERE HSE.tblLotoPermit.permitNumber = @permitNumber
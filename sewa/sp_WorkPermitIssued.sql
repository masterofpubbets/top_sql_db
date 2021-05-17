CREATE PROC sp_WorkPermitIssued
@permitNumber INT,
@workPermitIssuer NVARCHAR(250),
@workPermitReceiver NVARCHAR(250)
AS
DECLARE @workPermitIssuerId INT
DECLARE @workPermitReceiverId INT

SELECT @workPermitIssuerId = HSE.tblHSEMember.memId FROM HSE.tblHSEMember WHERE memberName = @workPermitIssuer
SELECT @workPermitReceiverId = HSE.tblHSEMember.memId FROM HSE.tblHSEMember WHERE memberName = @workPermitReceiver

UPDATE HSE.tblLotoPermit
        SET workPermitIssuedDate = GETDATE(),
            workPermitIssuerId = @workPermitIssuerId,
            workPermitReceiverId = @workPermitReceiverId
WHERE HSE.tblLotoPermit.permitNumber = @permitNumber

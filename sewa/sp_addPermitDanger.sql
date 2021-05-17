CREATE PROC sp_addPermitDanger
@danger NVARCHAR(50),
@permitNumber INT,
@description NVARCHAR(255)
AS
DECLARE @permitId INT
DECLARE @dangerID INT

SELECT @permitId = HSE.tblLotoPermit.lotoPermitId FROM HSE.tblLotoPermit WHERE permitNumber = @permitNumber
SELECT @dangerId = HSE.tblDangers.dangerId FROM HSE.tblDangers WHERE dangerName = @danger

INSERT INTO [HSE].[tblLotoPermitDanger] ([dangerId],[permitId],[dangerDescription])
    VALUES (@dangerId,@permitId,@description)
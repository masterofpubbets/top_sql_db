CREATE PROC sp_addPermitType
@type NVARCHAR(50),
@permitNumber INT,
@description NVARCHAR(255)
AS
DECLARE @permitId INT
DECLARE @typeID INT

SELECT @permitId = HSE.tblLotoPermit.lotoPermitId FROM HSE.tblLotoPermit WHERE permitNumber = @permitNumber
SELECT @typeId = HSE.tblPermitType.typeId FROM HSE.tblPermitType WHERE typeName = @type

INSERT INTO [HSE].[tblLotoPermitType] ([typeId],[permitId],[typeDescription])
    VALUES (@typeId,@permitId,@description)
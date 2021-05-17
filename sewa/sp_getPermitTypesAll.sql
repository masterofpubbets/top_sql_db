CREATE PROC sp_getPermitTypesAll
AS
SELECT
HSE.tblPermitType.typeName AS [Specific Permit/Requirement]
,HSE.tblLotoPermitType.typeDescription AS [Description]
,HSE.tblLotoPermitType.permitId
FROM HSE.tblLotoPermitType
INNER JOIN HSE.tblPermitType ON HSE.tblLotoPermitType.typeId = HSE.tblPermitType.typeId
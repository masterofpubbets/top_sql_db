CREATE PROC sp_getPermitDangerAll
AS
SELECT
HSE.tblDangers.dangerName AS [Description Of Task]
,HSE.tblLotoPermitDanger.dangerDescription AS [Description]
,HSE.tblLotoPermitDanger.permitId
FROM HSE.tblDangers
INNER JOIN HSE.tblLotoPermitDanger ON HSE.tblDangers.dangerId = HSE.tblLotoPermitDanger.dangerId
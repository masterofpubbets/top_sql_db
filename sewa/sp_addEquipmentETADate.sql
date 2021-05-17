CREATE PROC sp_addEquipmentETADate
@tag NVARCHAR(100),
@etaDate DATE = NULL
AS
UPDATE tblEquipment SET etaDate = @etaDate WHERE tag = @tag
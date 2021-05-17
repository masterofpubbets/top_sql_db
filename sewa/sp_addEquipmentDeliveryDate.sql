CREATE PROC sp_addEquipmentDeliveryDate
@tag NVARCHAR(100),
@deliveryDate DATE = NULL
AS
UPDATE tblEquipment SET deliveryDate = @deliveryDate WHERE tag = @tag
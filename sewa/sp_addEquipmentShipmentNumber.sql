CREATE PROC sp_addEquipmentShipmentNumber
@tag NVARCHAR(100),
@shipment NVARCHAR(100) = NULL
AS
UPDATE tblEquipment SET shipmentNumber = @shipment WHERE tag = @tag
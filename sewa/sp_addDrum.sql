CREATE PROC sp_addDrum
@tag NVARCHAR(100),
@purchasedLength FLOAT,
@receivedLength FLOAT,
@drumDescription NVARCHAR(255)
AS
INSERT INTO tblDrums (tag,purchasedLength,receivedLength,drumDescription)
VALUES (@tag,@purchasedLength,@receivedLength,@drumDescription)
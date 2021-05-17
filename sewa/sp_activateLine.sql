CREATE PROC sp_activateLine
@lineId INT,
@active BIT
AS
UPDATE PIPING.tblLineList SET active = @active WHERE lineId = @lineId
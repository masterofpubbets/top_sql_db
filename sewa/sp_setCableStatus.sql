CREATE PROC sp_setCableStatus
@cableID INT,
@active BIT
AS
UPDATE tblCables SET active = @active WHERE cable_id = @cableID

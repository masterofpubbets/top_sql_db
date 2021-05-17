CREATE PROC sp_assignCableDrumBruteForce
@drum NVARCHAR(100),
@cable NVARCHAR(100)
AS
DECLARE @drumId INT

SELECT @drumId = drumId FROM tblDrums WHERE tag = @drum
UPDATE tblCables SET drumId = @drumId WHERE tag = @cable


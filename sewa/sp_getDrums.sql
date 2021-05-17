CREATE PROC sp_getDrums
AS
SELECT 
drumId AS ID,tag AS Tag,purchasedLength AS [Purchased Length],receivedLength AS [Received Length],drumDescription AS [Description]
FROM tblDrums
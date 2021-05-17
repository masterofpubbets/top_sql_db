CREATE PROC sp_addLock
@lockBy INT,
@position NVARCHAR(50),
@lockNumber NVARCHAR(50),
@boxNumber NVARCHAR(50),
@ptw NVARCHAR(50),
@kks NVARCHAR(100),
@location NVARCHAR(255),
@isElectricalIsolated BIT,
@lockPosition BIT,
@lockDate DATE,
@remarks NVARCHAR(255)
AS
INSERT INTO HSE.tblLocks (lockBy,position,lockNumber,boxNumber,ptw,kks,[location],isElectricalIsolated,lockPosition,lockDate,remarks)
VALUES (@lockBy,@position,@lockNumber,@boxNumber,@ptw,@kks,@location,@isElectricalIsolated,@lockPosition,@lockDate,@remarks)
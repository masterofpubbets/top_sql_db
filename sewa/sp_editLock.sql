CREATE PROC sp_editLock
@lockID INT,
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
UPDATE HSE.tblLocks 
    SET lockBy = @lockBy,
        position = @position,
        lockNumber = @lockNumber,
        boxNumber = @boxNumber,
        ptw = @ptw,
        kks = @kks,
        [location] = @location,
        isElectricalIsolated = @isElectricalIsolated,
        lockPosition = @lockPosition,
        lockDate = @lockDate,
        remarks = @remarks
WHERE lockId = @lockID
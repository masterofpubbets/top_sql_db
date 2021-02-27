CREATE PROC sp_addTempCableProductionConTo
@tag NVARCHAR(100),
@userName NVARCHAR(50),
@conToDate DATE = NULL
AS
DECLARE @conTo_Date DATE
IF @conToDate IS NULL
    BEGIN
        SELECT @conTo_Date = GETDATE()
    END
ELSE
    BEGIN
        SELECT @conTo_Date = @conToDate
    END
INSERT INTO tblCablePro_temp (tag, con_to_date, user_name)
VALUES (@tag, @conTo_Date, @userName)
GO
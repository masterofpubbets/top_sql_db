CREATE PROC sp_addTempCableProductionConFrom
@tag NVARCHAR(100),
@userName NVARCHAR(50),
@conFromDate DATE = NULL
AS
DECLARE @conFrom_Date DATE
IF @conFromDate IS NULL
    BEGIN
        SELECT @conFrom_Date = GETDATE()
    END
ELSE
    BEGIN
        SELECT @conFrom_Date = @conFromDate
    END
INSERT INTO tblCablePro_temp (tag, con_from_date, user_name)
VALUES (@tag, @conFrom_Date, @userName)
GO
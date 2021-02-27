CREATE PROC sp_addTempCableProductionPulling
@tag NVARCHAR(100),
@actualLength FLOAT,
@userName NVARCHAR(50),
@pullingDate DATE = NULL
AS
DECLARE @Pulled_Date DATE
IF @pullingDate IS NULL
    BEGIN
        SELECT @Pulled_Date = GETDATE()
    END
ELSE
    BEGIN
        SELECT @Pulled_Date = @pullingDate
    END
INSERT INTO tblCablePro_temp (tag, pulling_date, actual_length, user_name)
VALUES (@tag, @Pulled_Date, @actualLength, @userName)
GO
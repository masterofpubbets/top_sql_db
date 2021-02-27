CREATE PROC sp_addTempCableProductionTest
@tag NVARCHAR(100),
@userName NVARCHAR(50),
@testDate DATE = NULL
AS
DECLARE @cableTest_Date DATE
IF @testDate IS NULL
    BEGIN
        SELECT @cableTest_Date = GETDATE()
    END
ELSE
    BEGIN
        SELECT @cableTest_Date = @testDate
    END
INSERT INTO tblCablePro_temp (tag, test_date, user_name)
VALUES (@tag, @cableTest_Date, @userName)
GO
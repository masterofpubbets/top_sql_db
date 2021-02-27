CREATE PROC sp_addTempCableProduction
@tag NVARCHAR(100),
@pullingDate DATE,
@actualLength FLOAT,
@conFromDate DATE,
@conToDate DATE,
@testDate DATE,
@userName NVARCHAR(50),
@updateSource NVARCHAR(100)
AS
INSERT INTO tblCablePro_temp (tag, pulling_date, actual_length, con_from_date, con_to_date, test_date, user_name, last_update_source)
VALUES (@tag, @pullingDate, @actualLength, @conFromDate, @conToDate, @testDate, @userName, @updateSource)
GO
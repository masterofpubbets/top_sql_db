ALTER PROC [dbo].[sp_CABLE_setTested]
@cbleID INT,
@rfiNumber NVARCHAR(100) = NULL
AS
IF @rfiNUmber IS NULL
    BEGIN
        UPDATE [tblCables] SET [test_date] = getdate() where [cable_id] = @cbleID and [test_date] is null
    END
ELSE
    BEGIN
        UPDATE [tblCables] SET [test_date] = getdate() where [cable_id] = @cbleID and [test_date] is null
        UPDATE [tblCables] SET rfi_no = @rfiNumber where [cable_id] = @cbleID
    END

GO

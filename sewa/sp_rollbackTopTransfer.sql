CREATE PROC sp_rollbackTopTransfer
@top nvarchar(100)
AS
UPDATE tblTOP SET transfer_date = NULL WHERE top_name = @top
GO
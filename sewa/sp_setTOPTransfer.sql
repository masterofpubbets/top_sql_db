CREATE PROC sp_setTOPTransfer
@topID INT
AS
UPDATE tblTOP SET transfer_date = GETDATE() WHERE top_id = @topID AND transfer_date IS NULL
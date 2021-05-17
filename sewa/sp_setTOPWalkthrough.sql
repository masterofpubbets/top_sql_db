CREATE PROC sp_setTOPWalkthrough
@topID INT
AS
UPDATE tblTOP SET walk_through_date = GETDATE() WHERE top_id = @topID AND walk_through_date IS NULL
CREATE PROC sp_setTOPPartial
@topID INT
AS
UPDATE tblTOP SET isPartial = 1 WHERE top_id = @topID
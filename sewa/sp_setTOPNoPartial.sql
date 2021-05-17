CREATE PROC sp_setTOPNoPartial
@topID INT
AS
UPDATE tblTOP SET isPartial = 0 WHERE top_id = @topID
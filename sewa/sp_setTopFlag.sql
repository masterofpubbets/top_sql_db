CREATE PROC sp_setTopFlag
@top NVARCHAR(100)
,@flag NVARCHAR(max) = NULL

AS
UPDATE tblTOP SET war_room_selected = @flag WHERE top_name = @top
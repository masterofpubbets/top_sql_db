SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[sp_pendingCables]
@username nvarchar(50)
AS
select tblUnits.unit_name,tblTOP.top_name,tblCables.* from tblCables 
INNER JOIN tblUnits On tblUnits.unit_id = tblCables.unit_id 
INNER JOIN tblTOP On tblTOP.top_id = tblCables.top_id
INNER JOIN tblTOPSelected ON tblTOPSelected.top_name = tblTOP.top_name
WHERE 
((tblCables.pulled_date IS NULL OR tblCables.con_from_date IS NULL OR tblCables.con_to_date IS NULL)
AND (
tblTOPSelected.user_name = @username
))
AND tblCables.active=1
GO

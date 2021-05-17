SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[sp_CABLE_setPulled]
@cbleID int
AS
update [tblCables] set [pulled_date] = getdate() where [cable_id] = @cbleID and [pulled_date] is null
GO

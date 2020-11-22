SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[sp_updateSignalProduction]
@username nvarchar(50)
AS
UPDATE V
SET v.ldate = v.loop_done
FROM (
select tblSignalsPro_temp.tag,tblSignalsPro_temp.loop_done 
,tblSignals.loop_done as [ldate]
from tblSignalsPro_temp
inner join tblSignals on tblSignals.tag = tblSignalsPro_temp.tag
where tblSignals.loop_done is null
AND tblSignalsPro_temp.[user_name] = @username
) as v
GO

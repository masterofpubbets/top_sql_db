ALTER PROC [dbo].[sp_updateCableProduction]
@username nvarchar(50)
AS
update v
set v.pulled_date = v.pulling_date
,lus = last_update_source
,al = actual_length
FROM
(
select tblCablePro_temp.tag,tblCablePro_temp.pulling_date,tblCables.pulled_date
,tblCablePro_temp.last_update_source,tblCables.last_update_source as [lus]
,tblCablePro_temp.actual_length,tblCables.actual_length AS al
from tblCablePro_temp
INNER JOIN tblCables on tblCablePro_temp.tag = tblCables.tag
and tblCablePro_temp.user_name =@username
and tblCablePro_temp.pulling_date is not null
and tblCables.pulled_date is null
) as v

update v
set v.[from_date] = v.con_from_date
,[subcon_from] = actual_subcon_con_from
,lus = last_update_source
FROM
(
select tblCablePro_temp.tag,tblCablePro_temp.con_from_date,tblCables.con_from_date as [from_date]
,tblCablePro_temp.actual_subcon_con_from,tblCables.actual_subcon_con_from as [subcon_from]
,tblCablePro_temp.last_update_source,tblCables.last_update_source as [lus]
from tblCablePro_temp
INNER JOIN tblCables on tblCablePro_temp.tag = tblCables.tag
and tblCablePro_temp.user_name =@username
and tblCablePro_temp.con_from_date is not null
and tblCables.con_from_date is null
) as v

update v
set v.[to_date] = v.con_to_date
,[subcon_to] = actual_subcon_con_to
,lus = last_update_source
FROM
(
select tblCablePro_temp.tag,tblCablePro_temp.con_to_date,tblCables.con_to_date as [to_date]
,tblCablePro_temp.actual_subcon_con_to,tblCables.actual_subcon_con_to as [subcon_to]
,tblCablePro_temp.last_update_source,tblCables.last_update_source as [lus]
from tblCablePro_temp
INNER JOIN tblCables on tblCablePro_temp.tag = tblCables.tag
and tblCablePro_temp.user_name =@username
and tblCablePro_temp.con_to_date is not null
and tblCables.con_to_date is null
) as v

update v
set v.[t_date] = v.test_date
,lus = last_update_source
FROM
(
select tblCablePro_temp.tag,tblCablePro_temp.test_date,tblCables.test_date as [t_date]
,tblCablePro_temp.last_update_source,tblCables.last_update_source as [lus]
from tblCablePro_temp
INNER JOIN tblCables on tblCablePro_temp.tag = tblCables.tag
and tblCablePro_temp.user_name =@username
and tblCablePro_temp.test_date is not null
and tblCables.test_date is null
) as v

update v
set v.[t_rfi] = v.rfi_no
,lus = last_update_source
FROM
(
select tblCablePro_temp.tag,tblCablePro_temp.rfi_no,tblCables.rfi_no as [t_rfi]
,tblCablePro_temp.last_update_source,tblCables.last_update_source as [lus]
from tblCablePro_temp
INNER JOIN tblCables on tblCablePro_temp.tag = tblCables.tag
and tblCablePro_temp.user_name =@username
and tblCablePro_temp.rfi_no is not null
and tblCables.rfi_no is null
) as v
GO

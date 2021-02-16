ALTER PROC [dbo].[spImportTempCables]

AS

DECLARE cable_cursor CURSOR FOR SELECT [top_name],[unit_name],sequenceNumber,[pulling_actid],[con_actid],[status],[discipline],[cable_type],[tag],[code],[description],[service_level],[from_eq],[from_decription],[to_eq],[to_description],[pulling_area_from],[pulling_area_to],[wiring_diagram],[wd_sheet],[wd_rev],[routing_status],[routing_rev],[drum],[design_length],[batch_no],[team],[remarks] from dbo.tblCables_temp; 

DECLARE @top_name nvarchar(100)
DECLARE @unit_name nvarchar(50)
DECLARE @sequenceNumber INT
DECLARE @pulling_actid nvarchar(50)
DECLARE @con_actid nvarchar(50)
DECLARE @status nvarchar(50)
DECLARE @discipline nvarchar(50)
DECLARE @cable_type nvarchar(50)
DECLARE @tag nvarchar(50)
DECLARE @code nvarchar(50)
DECLARE @description nvarchar(255)
DECLARE @service_level nvarchar(50)
DECLARE @from_eq nvarchar(255)
DECLARE @from_decription nvarchar(255)
DECLARE @to_eq nvarchar(255)
DECLARE @to_description nvarchar(255)
DECLARE @pulling_area_from nvarchar(255)
DECLARE @pulling_area_to nvarchar(255)
DECLARE @wiring_diagram nvarchar(255)
DECLARE @wd_sheet nvarchar(50)
DECLARE @wd_rev nvarchar(50)
DECLARE @routing_status nvarchar(255)
DECLARE @routing_rev nvarchar(50)
DECLARE @drum nvarchar(255)
DECLARE @design_length float
DECLARE @batch_no int
DECLARE @team nvarchar(50)
DECLARE @remarks nvarchar(255)

DECLARE @id int
DECLARE @unitId int
DECLARE @topId int
DECLARE @tu nvarchar(50)
DECLARE @tt nvarchar(50)

OPEN cable_cursor;
FETCH NEXT FROM cable_cursor INTO @top_name,@unit_name,@sequenceNumber,@pulling_actid,@con_actid,@status,@discipline,@cable_type,@tag,@code,@description,@service_level,@from_eq,@from_decription,@to_eq,@to_description,@pulling_area_from,@pulling_area_to,@wiring_diagram,@wd_sheet,@wd_rev,@routing_status,@routing_rev,@drum,@design_length,@batch_no,@team,@remarks;
WHILE @@FETCH_STATUS = 0  
BEGIN  

		SELECT @id = null
		SELECT @unitId = null
		SELECT @topId = null
       SELECT @id = cable_id from [dbo].tblCables where tag = @tag
	   SELECT @unitId = unit_id from dbo.tblUnits where unit_name = @unit_name
	   SELECT @topId = top_id from dbo.tblTOP where top_name = @top_name

	   if @unitId is null
			BEGIN
				select @tu = 'Invalid Unit: ' + @unit_name
				select @tt = 'Add or Edit Cable: ' + @tag
				EXEC sp_addLog @tu,@tt
			END
		ELSE
			BEGIN
				if @topId is null
					BEGIN
						select @tu = 'Invalid TOP: ' + @top_name
						select @tt = 'Add or Edit Cable: ' + @tag
						EXEC sp_addLog @tu,@tt
					END
				ELSE
					BEGIN
						if @id is null
							BEGIN
								INSERT INTO [dbo].tblCables ([top_id],[unit_id],sequenceNumber,[pulling_actid],[con_actid],[status],[discipline],[cable_type],[tag],[code],[description],[service_level],[from_eq],[from_decription],[to_eq],[to_description],[pulling_area_from],[pulling_area_to],[wiring_diagram],[wd_sheet],[wd_rev],[routing_status],[routing_rev],[drum],[design_length],[batch_no],[team],[remarks])
								VALUES (@topId,@unitId,@sequenceNumber,@pulling_actid,@con_actid,@status,@discipline,@cable_type,@tag,@code,@description,@service_level,@from_eq,@from_decription,@to_eq,@to_description,@pulling_area_from,@pulling_area_to,@wiring_diagram,@wd_sheet,@wd_rev,@routing_status,@routing_rev,@drum,@design_length,@batch_no,@team,@remarks)
							END
						ELSE
							BEGIN
								UPDATE [dbo].tblCables
								SET [top_id] = @topId,
									[unit_id] = @unitId,
                                    [sequenceNumber] = @sequenceNumber,
									[pulling_actid] = @pulling_actid,
									[con_actid] = @con_actid,
									[status] = @status,
									[discipline] = @discipline,
									[cable_type] = @cable_type,
									[code] = @code,
									[description] = @description,
									[service_level] = @service_level,
									[from_eq] = @from_eq,
									[from_decription] = @from_decription,
									[to_eq] = @to_eq,
									[to_description] = @to_description,
									[pulling_area_from] = @pulling_area_from,
									[pulling_area_to] = @pulling_area_to,
									[wiring_diagram] = @wiring_diagram,
									[wd_sheet] = @wd_sheet,
									[wd_rev] = @wd_rev,
									[routing_status] = @routing_status,
									[routing_rev] = @routing_rev,
									[drum] = @drum,
									[design_length] = @design_length,
									[batch_no] = @batch_no,
									[team] = @team,
									[remarks] = @remarks
								WHERE tag = @tag
							END
					END
			END
			


       FETCH NEXT FROM cable_cursor INTO @top_name,@unit_name,@sequenceNumber,@pulling_actid,@con_actid,@status,@discipline,@cable_type,@tag,@code,@description,@service_level,@from_eq,@from_decription,@to_eq,@to_description,@pulling_area_from,@pulling_area_to,@wiring_diagram,@wd_sheet,@wd_rev,@routing_status,@routing_rev,@drum,@design_length,@batch_no,@team,@remarks;
END;
CLOSE cable_cursor;
DEALLOCATE cable_cursor;

GO

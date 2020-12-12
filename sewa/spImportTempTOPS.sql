
ALTER PROC [dbo].[spImportTempTOPS]

AS

DECLARE top_cursor CURSOR FOR SELECT [unit_name],[top_name],[div_name],[system_name],[kks],[system_description],[subsystem_description],[res],[plan_ho_date],late_start_date,[supervisor],[warroom_pri],[comm_block],[comm_pri],[discipline],cod,[remarks] FROM [dbo].[tblTOP_temp]; 

DECLARE @unit_name nvarchar(50)
DECLARE @top_name nvarchar(100)
DECLARE @div_name nvarchar(100)
DECLARE @system_name nvarchar(50)
DECLARE @kks nvarchar(50)
DECLARE @system_description nvarchar(255)
DECLARE @subsystem_description nvarchar(255)
DECLARE @res nvarchar(50)
DECLARE @plan_ho_date date
DECLARE @late_start_date date
DECLARE @supervisor nvarchar(50)
DECLARE @warroom_pri int
DECLARE @comm_block nvarchar(50)
DECLARE @comm_pri nvarchar(50)
DECLARE @discipline nvarchar(50)
DECLARE @cod nvarchar(50)
DECLARE @remarks nvarchar(255)
DECLARE @id int
DECLARE @unitId int

OPEN top_cursor;
FETCH NEXT FROM top_cursor INTO @unit_name, @top_name, @div_name,@system_name,@kks,@system_description,@subsystem_description,@res,@plan_ho_date,@late_start_date,@supervisor,@warroom_pri,@comm_block,@comm_pri,@discipline,@cod,@remarks;
WHILE @@FETCH_STATUS = 0  
BEGIN  
		
		SELECT @id = null
		SELECT @unitId = null
       SELECT @id = top_id from [dbo].[tblTOP] where top_name = @top_name
	   SELECT @unitId = unit_id from dbo.tblUnits where unit_name = @unit_name

	   if @unitId is null
			BEGIN
				DECLARE @tu nvarchar(50)
				DECLARE @tt nvarchar(50)
				select @tu = 'Invalid Unit: ' + @unit_name
				select @tt = 'Add or Edit TOP: ' + @top_name
				EXEC sp_addLog @tu,@tt
			END
		ELSE
			BEGIN
				   if @id is null
						BEGIN
							INSERT INTO [dbo].[tblTOP] ([unit_id],[top_name],[div_name],[system_name],[kks],[system_description],[subsystem_description],[res],[plan_ho_date],[late_start_date],[supervisor],[warroom_pri],[comm_block],[comm_pri],[discipline],cod,[remarks])
							VALUES (@unitId, @top_name, @div_name,@system_name,@kks,@system_description,@subsystem_description,@res,@plan_ho_date,@late_start_date,@supervisor,@warroom_pri,@comm_block,@comm_pri,@discipline,@cod,@remarks)
						END
					ELSE
						BEGIN
							UPDATE [dbo].[tblTOP]
							SET [unit_id] = @unitId,
								[div_name] = @div_name,
								[system_name] = @system_name,
								[kks] = @kks,
								[system_description] = @system_description,
								[subsystem_description] = @subsystem_description,
								[res] = @res,
								[plan_ho_date] = @plan_ho_date,
								[late_start_date] = @late_start_date,
								[supervisor] = @supervisor,
								[warroom_pri] = @warroom_pri,
								[comm_block] = @comm_block,
								[comm_pri] = @comm_pri,
								[discipline] = @discipline,
                                cod = @cod,
								[remarks] = @remarks
							WHERE [top_name] = @top_name
						END
			END


       FETCH NEXT FROM top_cursor INTO @unit_name, @top_name, @div_name,@system_name,@kks,@system_description,@subsystem_description,@res,@plan_ho_date,@late_start_date,@supervisor,@warroom_pri,@comm_block,@comm_pri,@discipline,@cod,@remarks;
END;
CLOSE top_cursor;
DEALLOCATE top_cursor;


GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[spImportTempSignals]

AS

DECLARE si_cursor CURSOR FOR SELECT [top_name],[unit_name],[tag],[category],[loop_type],[cons_responsible],[owner],[comm_responsible],[Service],[plan_date],[remarks] FROM [tblSignals_temp]; 

DECLARE @top_name nvarchar(100)
DECLARE @unit_name nvarchar(50)
DECLARE @signal_name nvarchar(100)
DECLARE @category nvarchar(50)
DECLARE @loop_type nvarchar(50)
DECLARE @cons_responsible nvarchar(50)
DECLARE @comm_responsible nvarchar(50)
DECLARE @owner nvarchar(50)
DECLARE @Service nvarchar(255)
DECLARE @plan_date date
DECLARE @remarks nvarchar(255)
DECLARE @id int
DECLARE @topId int
DECLARE @unitId int
DECLARE @tu nvarchar(50)
DECLARE @tt nvarchar(50)

OPEN si_cursor;
FETCH NEXT FROM si_cursor INTO @top_name,@unit_name, @signal_name,@category,@loop_type,@cons_responsible,@owner,@comm_responsible,@Service,@plan_date,@remarks;
WHILE @@FETCH_STATUS = 0  
BEGIN  

		SELECT @id = null
		SELECT @topId = null
		SELECT @unitId = null

       SELECT @id = signal_id from [dbo].tblSignals where tag = @signal_name
	   SELECT @topId = top_id from dbo.tblTOP where top_name = @top_name
	   SELECT @unitId = unit_id from dbo.tblUnits where unit_name = @unit_name
	   if @topId is null
			BEGIN
				select @tu = 'Invalid TOP: ' + @top_name
				select @tt = 'Add or Edit Signal: ' + @signal_name
				EXEC sp_addLog @tu,@tt
			END
		ELSE
			if @topId is null
				BEGIN
					select @tu = 'Invalid Unit: ' + @unit_name
					select @tt = 'Add or Edit Signal: ' + @signal_name
					EXEC sp_addLog @tu,@tt
				END
			ELSE
				BEGIN
					if @id is null
						BEGIN
							INSERT INTO [dbo].tblSignals ([top_id],[unit_id],[tag],[category],[loop_type],[cons_responsible],[owner],[comm_responsible],[Service],[plan_date],[remarks])
							VALUES (@topID,@unitID, @signal_name,@category,@loop_type,@cons_responsible,@owner,@comm_responsible,@Service,@plan_date,@remarks)
						END
					ELSE
						BEGIN
							UPDATE dbo.tblSignals
							SET [top_id] = @topId,
								unit_id = @unitId,
								[category] = @category,
								[loop_type] = @loop_type,
								[cons_responsible] = @cons_responsible,
								[owner] = @owner,
								[comm_responsible] = @comm_responsible,
								[Service] = @Service,
								[plan_date] = @plan_date,
								[remarks] = @remarks
							WHERE [tag] = @signal_name
						END
				END



       FETCH NEXT FROM si_cursor INTO @top_name,@unit_name, @signal_name,@category,@loop_type,@cons_responsible,@owner,@comm_responsible,@Service,@plan_date,@remarks;
END;
CLOSE si_cursor;
DEALLOCATE si_cursor;

GO

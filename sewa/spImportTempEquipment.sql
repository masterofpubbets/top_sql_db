ALTER PROC [dbo].[spImportTempEquipment]

AS

DECLARE eq_cursor CURSOR FOR SELECT [top_name],[unit_name],[type],area,[tag],[description],[erected_date],[remarks],className FROM [dbo].[tblEquipment_temp]; 

DECLARE @top_name nvarchar(100)
DECLARE @unit_name nvarchar(50)
DECLARE @type nvarchar(50)
DECLARE @area nvarchar(255)
DECLARE @tag nvarchar(50)
DECLARE @description nvarchar(255)
DECLARE @erected_date date
DECLARE @remarks nvarchar(255)
DECLARE @className nvarchar(100)

DECLARE @id int
DECLARE @unitId int
DECLARE @topId int
DECLARE @tu nvarchar(50)
DECLARE @tt nvarchar(50)

OPEN eq_cursor;
FETCH NEXT FROM eq_cursor INTO @top_name,@unit_name,@type,@area,@tag,@description,@erected_date,@remarks,@className;
WHILE @@FETCH_STATUS = 0  
BEGIN  

		SELECT @id = null
		SELECT @unitId = null
		SELECT @topId = null

       SELECT @id = eq_id from [dbo].tblEquipment where tag = @tag
	   SELECT @unitId = unit_id from dbo.tblUnits where unit_name = @unit_name
	   SELECT @topId = top_id from dbo.tblTOP where top_name = @top_name

	   if @unitId is null
			BEGIN
				select @tu = 'Invalid Unit: ' + @unit_name
				select @tt = 'Add or Edit Equipment: ' + @tag
				EXEC sp_addLog @tu,@tt
			END
		ELSE
			BEGIN
				if @topId is null
					BEGIN
						select @tu = 'Invalid TOP: ' + @top_name
						select @tt = 'Add or Edit Equipment: ' + @tag
						EXEC sp_addLog @tu,@tt
					END
				ELSE
					BEGIN
						if @id is null
							BEGIN
								INSERT INTO [dbo].tblEquipment([top_id],[unit_id],[type],area,tag,[description],[erected_date],remarks,className)
								VALUES (@topId,@unitId,@type,@area,@tag,@description,@erected_date,@remarks,@className)
							END
						ELSE
							BEGIN
								UPDATE [dbo].tblEquipment
								SET [top_id] = @topId,
									[unit_id] = @unitId,
									[type] = @type,
									area = @area,
									[description] = @description,
									[erected_date] = @erected_date,
									[remarks] = @remarks,
                                    className = @className
								WHERE tag = @tag
							END
					END
			END
			


       FETCH NEXT FROM eq_cursor INTO @top_name,@unit_name,@type,@area,@tag,@description,@erected_date,@remarks,@className;
END;
CLOSE eq_cursor;
DEALLOCATE eq_cursor;

GO

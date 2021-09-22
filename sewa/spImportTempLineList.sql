ALTER PROC [dbo].[spImportTempLineList]

AS

DECLARE lineList_cursor CURSOR FOR 
    SELECT [status],[plant],[unit],[system],[subsystem],[equipmentCode],[branchNumber],[unitName],[drawingNumber]
    ,[sheet],[revision],[nominalSize],[rating],[materialClass],[material],[schedule],[Schedule_mm],[fluidService],[enviroment]
    ,[streamId],[designPressure],[designTemperature],[operatingPressure],[operatingTemprature],[operatingMaxTemprature],[userFullName] 
    FROM [PIPING].[tblLineList_temp]; 

DECLARE @status NVARCHAR(50)
DECLARE @plant NVARCHAR(50)
DECLARE @unit NVARCHAR(50)
DECLARE @system NVARCHAR(50)
DECLARE @subsystem NVARCHAR(50)
DECLARE @equipmentCode NVARCHAR(50)
DECLARE @branchNumber NVARCHAR(50)
DECLARE @unitName NVARCHAR(50)
DECLARE @drawingNumber NVARCHAR(100)
DECLARE @sheet NVARCHAR(50)
DECLARE @revision NVARCHAR(50)
DECLARE @nominalSize NVARCHAR(50)
DECLARE @rating NVARCHAR(50)
DECLARE @materialClass NVARCHAR(100)
DECLARE @material NVARCHAR(100)
DECLARE @schedule NVARCHAR(50)
DECLARE @schedule_mm FLOAT
DECLARE @fluidService NVARCHAR(100)
DECLARE @enviroment NVARCHAR(50)
DECLARE @streamId NVARCHAR(50)
DECLARE @designPressure NVARCHAR(50)
DECLARE @designTemperature NVARCHAR(50)
DECLARE @operatingPressure NVARCHAR(50)
DECLARE @operatingTemprature NVARCHAR(50)
DECLARE @operatingMaxTemprature NVARCHAR(50)
DECLARE @userFullName NVARCHAR(100)


DECLARE @id int
DECLARE @unitId int
DECLARE @tu NVARCHAR(50)
DECLARE @tt NVARCHAR(50)

OPEN lineList_cursor;
FETCH NEXT FROM lineList_cursor INTO @status,@plant,@unit,@system,@subsystem,@equipmentCode,@branchNumber,@unitName,@drawingNumber,@sheet,@revision,@nominalSize,@rating,@materialClass,
@material,@schedule,@schedule_mm,@fluidService,@enviroment,@streamId,@designPressure,@designTemperature,
@operatingPressure,@operatingTemprature,@operatingMaxTemprature,@userFullName;
WHILE @@FETCH_STATUS = 0  
BEGIN  

		SELECT @id = NULL
		SELECT @unitId = NULL

       SELECT @id = lineId from [PIPING].[tblLineList] where lineKKS = @plant + '-' + @unit + '-' + @system + '-' + @subsystem + '-' + @equipmentCode + '-' + @branchNumber
	   SELECT @unitId = unit_id from dbo.tblUnits where unit_name = @unitName

	   if @unitId is NULL
			BEGIN
				select @tu = 'Invalid Unit: ' + @unitName
				select @tt = 'Add or Edit Line List: ' +  @plant + '-' + @unit + '-' + @system + '-' + @subsystem + '-' + @equipmentCode + '-' + @branchNumber
				EXEC sp_addLog @tu,@tt
			END
		ELSE
			BEGIN
				if @id IS NULL
					BEGIN
						INSERT INTO [PIPING].[tblLineList] (
                            [status],[plant],[unit],[system],[subsystem],[equipmentCode],[branchNumber]
                            ,[unitId],[drawingNumber],[sheet],[revision],[nominalSize],[rating],[materialClass],[material]
                            ,[schedule],[Schedule_mm],[fluidService],[enviroment],[streamId],[designPressure],[designTemperature],[operatingPressure]
                            ,[operatingTemprature],[operatingMaxTemprature],[active],[engineeringBy])
						VALUES (
                            @status,@plant,@unit,@system,@subsystem,@equipmentCode,@branchNumber
                            ,@unitId,@drawingNumber,@sheet,@revision,@nominalSize,@rating,@materialClass,@material
                            ,@schedule,@schedule_mm,@fluidService,@enviroment,@streamId,@designPressure,@designTemperature,@operatingPressure
                            ,@operatingTemprature,@operatingMaxTemprature,1,@userFullName)
					END
				ELSE
					BEGIN
						UPDATE [PIPING].[tblLineList]
						SET status = @status,
                            plant = @plant,
                            unit = @unit,
                            [system] = @system,
                            subsystem = @subsystem,
                            equipmentCode = @equipmentCode,
                            branchNumber = @branchNumber,
                            unitId = @unitId,
                            drawingNumber = @drawingNumber,
                            sheet = @sheet,
                            revision = @revision,
                            nominalSize = @nominalSize,
                            rating = @rating,
                            materialClass = @materialClass,
                            material = @material,
                            schedule = @schedule,
                            Schedule_mm = @schedule_mm,
                            fluidService = @fluidService,
                            enviroment = @enviroment,
                            streamId = @streamId,
                            designPressure = @designPressure,
                            designTemperature = @designTemperature,
                            operatingPressure = @operatingPressure,
                            operatingTemprature = @operatingTemprature,
                            operatingMaxTemprature = @operatingMaxTemprature,
                            engineeringBy = @userFullName
						WHERE lineId = @id
					END
			END
			


FETCH NEXT FROM lineList_cursor INTO @status,@plant,@unit,@system,@subsystem,@equipmentCode,@branchNumber,@unitName,@drawingNumber,@sheet,@revision,@nominalSize,@rating,@materialClass,
@material,@schedule,@schedule_mm,@fluidService,@enviroment,@streamId,@designPressure,@designTemperature,
@operatingPressure,@operatingTemprature,@operatingMaxTemprature,@userFullName;

END;
CLOSE lineList_cursor;
DEALLOCATE lineList_cursor;

GO

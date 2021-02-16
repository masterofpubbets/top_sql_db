CREATE PROC [dbo].[spImportTempCommTasks]

AS

DECLARE cable_cursor CURSOR FOR SELECT [discipline], [systemKKS], [unitName], [topName], [typeName], [className], [sheetDescription], [reportNumber], itemKKS, itemDescription
FROM [tblCommTasks_temp]

DECLARE @discipline NVARCHAR(50)
DECLARE @systemKKS NVARCHAR(50)
DECLARE @unitName NVARCHAR(50)
DECLARE @topName NVARCHAR(100)
DECLARE @typeName NVARCHAR(50)
DECLARE @className NVARCHAR(50)
DECLARE @sheetDescription NVARCHAR(100)
DECLARE @reportNumber NVARCHAR(250)
DECLARE @itemKKS NVARCHAR(100)
DECLARE @itemDescription NVARCHAR(250)

DECLARE @id int
DECLARE @unitId int
DECLARE @topId int
DECLARE @disciplineId int
DECLARE @sysId int
DECLARE @tu NVARCHAR(50)
DECLARE @tt NVARCHAR(50)
DECLARE @td NVARCHAR(50)

OPEN cable_cursor;
FETCH NEXT FROM cable_cursor INTO @discipline,@systemKKS,@unitName,@topName,@typeName,@className,@sheetDescription,@reportNumber,@itemKKS,@itemDescription;
WHILE @@FETCH_STATUS = 0  
BEGIN

	SELECT @id = NULL
	SELECT @unitId = NULL
	SELECT @topId = NULL
	SELECT @disciplineId = NULL
	SELECT @sysId = NULL

	SELECT @unitId = unit_id FROM dbo.tblUnits WHERE unit_name = @unitName
	SELECT @topId = top_id FROM dbo.tblTOP WHERE top_name = @topName
	SELECT @disciplineId = punchDiscId FROM [tblPunchDiscipline] WHERE [punchDiscipline] = @discipline
	SELECT @sysId = sysId FROM tblSystems WHERE systemKKS = @systemKKS

	IF @unitId is NULL
		BEGIN
			SELECT @tu = 'Invalid Unit: ' + @unitName
			SELECT @tt = 'Add or Edit Commissioning Tasks'
			EXEC sp_addLog @tu,@tt
		END
	ELSE
		BEGIN
			IF @topId is NULL
				BEGIN
					SELECT @tu = 'Invalid TOP: ' + @topName
					SELECT @tt = 'Add or Edit Commissioning Tasks'
					EXEC sp_addLog @tu,@tt
				END
			ELSE
				BEGIN
					IF @disciplineId is NULL
						BEGIN
							SELECT @tu = 'Invalid Discipline: ' + @discipline
							SELECT @tt = 'Add or Edit Commissioning Tasks'
							EXEC sp_addLog @tu,@tt
						END
					ELSE
						IF @sysId is NULL
							BEGIN
								SELECT @tu = 'Invalid System: ' + @systemKKS
								SELECT @tt = 'Add or Edit Commissioning Tasks'
								EXEC sp_addLog @tu,@tt
							END
						ELSE
							BEGIN
								INSERT INTO [dbo].tblCommTasks
									([disciplineId],[systemId],unitId,[topId],[typeName],[className],[sheetDescription],[reportNumber],[itemKKS],[itemDescription])
								VALUES
									(@disciplineId, @sysId, @unitId, @topId, @typeName, @className, @sheetDescription, @reportNumber, @itemKKS, @itemDescription)
							END
				END
		END



FETCH NEXT FROM cable_cursor INTO  @discipline,@systemKKS,@unitName,@topName,@typeName,@className,@sheetDescription,@reportNumber,@itemKKS,@itemDescription;
END;
CLOSE cable_cursor;
DEALLOCATE cable_cursor;

GO

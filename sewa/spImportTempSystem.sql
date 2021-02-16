ALTER PROC [dbo].[spImportTempSystem]

AS

DECLARE si_cursor CURSOR FOR SELECT [systemName], [systemKKS], [systemDescription]
FROM [tblSystems_temp];

DECLARE @id INT
DECLARE @systemName nvarchar(100)
DECLARE @systemKKS nvarchar(50)
DECLARE @systemDescription nvarchar(255)

OPEN si_cursor;
FETCH NEXT FROM si_cursor INTO @systemName,@systemKKS,@systemDescription;
WHILE @@FETCH_STATUS = 0  
BEGIN

	SELECT @id = null
	SELECT @id = sysId
	from [dbo].tblSystems
	where systemName = @systemName

	IF @id IS NULL
		BEGIN
			INSERT INTO [dbo].tblSystems
				([systemName], [systemKKS], [systemDescription])
			VALUES
				(@systemName, @systemKKS, @systemDescription)
		END
	ELSE
		BEGIN
			UPDATE dbo.tblSystems
							SET systemKKS = @systemKKS,
                                systemDescription = @systemDescription
							WHERE [systemName] = @systemName
		END

	FETCH NEXT FROM si_cursor INTO @systemName,@systemKKS,@systemDescription;
END;
CLOSE si_cursor;
DEALLOCATE si_cursor;

GO

ALTER PROC [dbo].[spImportTempDrums]

AS

DECLARE drum_cursor CURSOR FOR SELECT [tag], [purchasedLength], [receivedLength], drumDescription
FROM [dbo].[tblDrums_Temp]; 

DECLARE @tag NVARCHAR(100)
DECLARE @purchasedLength FLOAT
DECLARE @receivedLength FLOAT
DECLARE @drumDescription NVARCHAR(255)
DECLARE @id int


OPEN drum_cursor;
FETCH NEXT FROM drum_cursor INTO @tag,@purchasedLength,@receivedLength,@drumDescription;
WHILE @@FETCH_STATUS = 0  
BEGIN

	SELECT @id = null
	SELECT @id = drumId
	from [dbo].tblDrums
	where tag = @tag

	if @id is null
		BEGIN
			INSERT INTO [dbo].tblDrums
				([tag],[purchasedLength],[receivedLength],drumDescription)
			VALUES
				(@tag, @purchasedLength, @receivedLength, @drumDescription)
		END
	ELSE
		BEGIN
			UPDATE [dbo].tblDrums
					SET 
						[purchasedLength] = @purchasedLength,
						[receivedLength] = @receivedLength,
						drumDescription = @drumDescription
					WHERE tag = @tag
		END

FETCH NEXT FROM drum_cursor INTO @tag,@purchasedLength,@receivedLength,@drumDescription;
END;
CLOSE drum_cursor;
DEALLOCATE drum_cursor;

GO

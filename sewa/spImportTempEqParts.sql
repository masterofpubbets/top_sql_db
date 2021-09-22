CREATE PROC [dbo].[spImportTempEqParts]

AS

DECLARE EqPart_Cursor CURSOR FOR SELECT Equipment,PartName,PartDescription,Long,Width,Height,[Weight]
FROM [tblEquipmentPartsTemp]

DECLARE @Equipment NVARCHAR(100)
DECLARE @PartName NVARCHAR(100)
DECLARE @PartDescription NVARCHAR(255)
DECLARE @Long FLOAT
DECLARE @Width FLOAT
DECLARE @Height FLOAT
DECLARE @Weight FLOAT

DECLARE @Eqid int
DECLARE @tu NVARCHAR(50)
DECLARE @tt NVARCHAR(50)

OPEN EqPart_Cursor;
FETCH NEXT FROM EqPart_Cursor INTO @Equipment,@PartName,@PartDescription,@Long,@Width,@Height,@Weight;
WHILE @@FETCH_STATUS = 0  
BEGIN

	SELECT @Eqid = NULL

	SELECT @Eqid = eq_id FROM tblEquipment WHERE tag = @Equipment

	IF @Eqid is NULL
		BEGIN
			SELECT @tu = 'Invalid Equipment: ' + @Equipment
			SELECT @tt = 'Add or Edit Equipment Parts'
			EXEC sp_addLog @tu,@tt
		END
	ELSE
		BEGIN
			DECLARE @PartID INT
			SELECT @PartID = NULL
			SELECT @PartID = tblEquipmentParts.Id FROM tblEquipmentParts WHERE PartName = @PartName
								AND EqID = @Eqid
			IF @PartID IS NULL
				BEGIN
					INSERT INTO [dbo].tblEquipmentParts
						(EqId,[PartName],[PartDescription],Long,[Width],[Height],[Weight])
					VALUES
						(@EqId,@PartName, @PartDescription, @Long, @Width, @Height, @Weight)
				END
			ELSE
				BEGIN
					UPDATE tblEquipmentParts
						SET PartName = @PartName,
						PartDescription = @PartDescription,
						Long = @Long,
						[Width] = @Width,
						Height = @Height,
						[Weight] = @Weight
					WHERE Id = @PartID
				END
		END

FETCH NEXT FROM EqPart_Cursor INTO  @Equipment,@PartName,@PartDescription,@Long,@Width,@Height,@Weight;
END;
CLOSE EqPart_Cursor;
DEALLOCATE EqPart_Cursor;

GO

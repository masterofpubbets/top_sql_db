ALTER PROC sp_clearPunch
@punchNo NVARCHAR(50),
@memberName NVARCHAR(100)

AS
DECLARE @des NVARCHAR(255)

UPDATE tblPunchList 
SET tblPunchList.internalClosedDate = GETDATE(),
    tblPunchList.internalClosedResponsible = @memberName
WHERE tblPunchList.punchNo = @punchNo AND tblPunchList.internalClosedDate IS NULL

SELECT @des = 'Clear Punch No:' + @punchNo
EXEC sp_addOperationLog @des ,@memberName
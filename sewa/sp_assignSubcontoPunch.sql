ALTER PROC sp_assignSubcontoPunch
@subconName NVARCHAR(100)
,@punchNo NVARCHAR(50)
,@user NVARCHAR(50) = NULL
AS
DECLARE @subId INT
DECLARE @des NVARCHAR(255)

SELECT @subId = subconId FROM tblSubcontractor WHERE subconName = @subconName
IF @subId IS NOT NULL
    BEGIN
        UPDATE tblPunchList SET tblPunchList.subconId = @subId WHERE tblPunchList.punchNo = @punchNo 
    END
SELECT @des = 'Assign Subcontractor: ' + @subconName + ' to Punch No:' + @punchNo
EXEC sp_addOperationLog @des ,@user
CREATE PROC HANDOVER.ChangePunchTOP
@punchNo NVARCHAR(100),
@TOP NVARCHAR(100)

AS
DECLARE @Id INT
SELECT @id = dbo.tblTOP.top_id FROM dbo.tblTOP WHERE top_name = @TOP
IF @id IS NOT NULL
    UPDATE tblPunchList SET top_id = @Id WHERE punchNo = @punchNo
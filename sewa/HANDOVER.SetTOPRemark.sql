CREATE PROC HANDOVER.SetTOPRemark
@top NVARCHAR(100),
@Remark NVARCHAR(255) = NULL
AS
UPDATE tblTop SET remarks = @Remark WHERE top_name = @top

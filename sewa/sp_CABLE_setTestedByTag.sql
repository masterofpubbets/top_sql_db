CREATE PROC [dbo].[sp_CABLE_setTestedByTag]
@tag NVARCHAR(100)
AS
update [tblCables] set [test_date] = getdate() where [tag] = @tag and [test_date] is null
GO

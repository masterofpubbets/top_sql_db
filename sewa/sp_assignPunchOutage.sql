ALTER PROC sp_assignPunchOutage
@punchNumber NVARCHAR(100),
@outage NVARCHAR(100) = NULL
AS
   UPDATE tblPunchList SET outage = @outage WHERE punchNo = @punchNumber


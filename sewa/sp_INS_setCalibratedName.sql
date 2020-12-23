CREATE PROC [dbo].[sp_INS_setCalibratedName]
@tag NVARCHAR(100)
AS
update tblInstruments set calibration_date = getdate() where tag = @tag and calibration_date is null

GO

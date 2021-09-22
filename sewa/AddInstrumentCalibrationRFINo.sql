CREATE PROC AddInstrumentCalibrationRFINo
@Id INT,
@RFI NVARCHAR(100)
AS
UPDATE tblInstruments SET 
    calibrationRFINo = @RFI
WHERE ins_id = @Id
UPDATE tblInstruments SET 
    calibration_date = GETDATE()
WHERE ins_id = @Id AND calibration_date IS NULL
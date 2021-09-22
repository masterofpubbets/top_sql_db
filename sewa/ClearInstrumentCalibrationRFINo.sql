CREATE PROC ClearInstrumentCalibrationRFINo
@Id INT
AS
UPDATE tblInstruments SET 
    calibrationRFINo = NULL
WHERE ins_id = @Id

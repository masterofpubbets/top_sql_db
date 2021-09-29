ALTER PROC QC.CleanWeldingMapCheckValues
AS
UPDATE PIPING.tblWeldingMap SET 
    PWHTChkValue = 0,
    HTChkValue = 0,
    RTUTChkValue = 0,
    PMIChkValue = 0,
    MTPTChkValue = 0,
    PTTCChkValue = 0

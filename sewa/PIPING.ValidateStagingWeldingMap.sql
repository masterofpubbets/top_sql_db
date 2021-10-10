ALTER PROC PIPING.ValidateStagingWeldingMap
@datetype INT
AS


EXEC PIPING.ValidateStagingWeldingMap01
EXEC PIPING.ValidateStagingWeldingMapDuplicatedJoints
EXEC PIPING.ValidateStagingWeldingMap02
EXEC PIPING.ValidateStagingWeldingMap03
EXEC PIPING.ValidateStagingWeldingMap04
EXEC PIPING.ValidateStagingWeldingMap05 @datetype
EXEC PIPING.ValidateStagingWeldingMapDates 
EXEC PIPING.ValidateStagingWeldingMapISORevision
EXEC PIPING.ValidateStagingJointTypeChanged
UPDATE PIPING.tblWeldingMap_TEMP SET ValidateStatus = 'Accepted'
UPDATE PIPING.tblWeldingMap_TEMP SET ValidateStatus = 'Rejected' WHERE ValidateError IS NOT NULL
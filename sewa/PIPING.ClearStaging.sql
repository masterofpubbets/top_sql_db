CREATE PROC PIPING.ClearStaging
AS
DELETE FROM PIPING.tblWeldingMap_TEMP WHERE ValidateStatus = 'Accepted'
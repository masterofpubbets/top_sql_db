CREATE PROC PIPING.ClearStagingError
@err NVARCHAR(255)
AS
UPDATE PIPING.tblWeldingMap_TEMP SET ValidateError = NULL WHERE ValidateError = @err

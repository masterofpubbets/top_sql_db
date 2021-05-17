ALTER FUNCTION HSE.permitCanExtended (
    @permitId INT
)
RETURNS INT
AS
BEGIN
DECLARE @extendedDays INT

    IF (SELECT workCompletionDate FROM HSE.tblLotoPermit WHERE lotoPermitId = @permitId) IS NOT NULL
        BEGIN
            SELECT @extendedDays = 0
        END
    ELSE
        BEGIN
            IF (SELECT isExtended FROM HSE.tblLotoPermit WHERE lotoPermitId = @permitId) = 1
                BEGIN
                    SELECT @extendedDays = -1
                END
            ELSE
                BEGIN
                    SELECT @extendedDays = 7 - foreseenDuration FROM HSE.tblLotoPermit WHERE lotoPermitId = @permitId
                END
        END
    RETURN @extendedDays
END
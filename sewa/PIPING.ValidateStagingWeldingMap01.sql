ALTER PROC PIPING.ValidateStagingWeldingMap01
AS

--Standarized Values
UPDATE [PIPING].[tblWeldingMap_TEMP] SET JoinName = NULL WHERE JoinName = 'N/A'
UPDATE [PIPING].[tblWeldingMap_TEMP] SET ISORevision = REPLACE(ISORevision, ' ', '')
UPDATE [PIPING].[tblWeldingMap_TEMP] SET ISORevision = '0' + ISORevision WHERE LEN(ISORevision) = 1
UPDATE [PIPING].[tblWeldingMap_TEMP] SET MapRevision = REPLACE(MapRevision, ' ', '')
UPDATE [PIPING].[tblWeldingMap_TEMP] SET MapRevision = '0' + MapRevision WHERE LEN(MapRevision) = 1

UPDATE [PIPING].[tblWeldingMap_TEMP] SET Schmm = REPLACE(Schmm, '', '')
UPDATE [PIPING].[tblWeldingMap_TEMP] SET Schmm = REPLACE(Schmm, 'mm', '')
UPDATE [PIPING].[tblWeldingMap_TEMP] SET Schmm = REPLACE(Schmm, '#', '')

UPDATE [PIPING].[tblWeldingMap_TEMP] SET Welder1 = REPLACE(Welder1, ' ', '')
UPDATE [PIPING].[tblWeldingMap_TEMP] SET Welder1 = NULL WHERE Welder1 IN ('-','')
UPDATE [PIPING].[tblWeldingMap_TEMP] SET Welder2 = REPLACE(Welder2, ' ', '')
UPDATE [PIPING].[tblWeldingMap_TEMP] SET Welder2 = NULL WHERE Welder2 IN ('-','')
UPDATE [PIPING].[tblWeldingMap_TEMP] SET Welder3 = REPLACE(Welder3, ' ', '')
UPDATE [PIPING].[tblWeldingMap_TEMP] SET Welder3 = NULL WHERE Welder3 IN ('-','')
UPDATE [PIPING].[tblWeldingMap_TEMP] SET Welder4 = REPLACE(Welder4, ' ', '')
UPDATE [PIPING].[tblWeldingMap_TEMP] SET Welder4 = NULL WHERE Welder4 IN ('-','')
UPDATE [PIPING].[tblWeldingMap_TEMP] SET Welder5 = REPLACE(Welder5, ' ', '')
UPDATE [PIPING].[tblWeldingMap_TEMP] SET Welder5 = NULL WHERE Welder5 IN ('-','')
UPDATE [PIPING].[tblWeldingMap_TEMP] SET Welder6 = REPLACE(Welder6, ' ', '')
UPDATE [PIPING].[tblWeldingMap_TEMP] SET Welder6 = NULL WHERE Welder6 IN ('-','')
--------------------------------------------------------------------------------

ALTER PROC PIPING.ValidateStagingWeldingMapDates
AS

UPDATE [PIPING].[tblWeldingMap_TEMP] SET PostheatingDate = NULL WHERE PostheatingDate IN ('N/A', 'NA', '-', '')
UPDATE [PIPING].[tblWeldingMap_TEMP] SET PWHT1Date = NULL WHERE PWHT1Date IN ('N/A', 'NA', '-', '')
UPDATE [PIPING].[tblWeldingMap_TEMP] SET HTDate = NULL WHERE HTDate IN ('N/A', 'NA', '-', '')
UPDATE [PIPING].[tblWeldingMap_TEMP] SET RT1UT1Date = NULL WHERE RT1UT1Date IN ('N/A', 'NA', '-', '')
UPDATE [PIPING].[tblWeldingMap_TEMP] SET RTUTReShoot1Date = NULL WHERE RTUTReShoot1Date IN ('N/A', 'NA', '-', '')
UPDATE [PIPING].[tblWeldingMap_TEMP] SET RTUTReShoot2Date = NULL WHERE RTUTReShoot2Date IN ('N/A', 'NA', '-', '')
UPDATE [PIPING].[tblWeldingMap_TEMP] SET PMIDate = NULL WHERE PMIDate IN ('N/A', 'NA', '-', '')
UPDATE [PIPING].[tblWeldingMap_TEMP] SET MTDate = NULL WHERE MTDate IN ('N/A', 'NA', '-', '')
UPDATE [PIPING].[tblWeldingMap_TEMP] SET PTDate = NULL WHERE PTDate IN ('N/A', 'NA', '-', '')

UPDATE [PIPING].[tblWeldingMap_TEMP] SET PostheatingDate = REPLACE(PostheatingDate,' ','')
UPDATE [PIPING].[tblWeldingMap_TEMP] SET PWHT1Date = REPLACE(PWHT1Date,' ','')
UPDATE [PIPING].[tblWeldingMap_TEMP] SET HTDate = REPLACE(HTDate,' ','')
UPDATE [PIPING].[tblWeldingMap_TEMP] SET RT1UT1Date = REPLACE(RT1UT1Date,' ','')
UPDATE [PIPING].[tblWeldingMap_TEMP] SET RTUTReShoot1Date = REPLACE(RTUTReShoot1Date,' ','')
UPDATE [PIPING].[tblWeldingMap_TEMP] SET RTUTReShoot2Date = REPLACE(RTUTReShoot2Date,' ','')
UPDATE [PIPING].[tblWeldingMap_TEMP] SET PMIDate = REPLACE(PMIDate,' ','')
UPDATE [PIPING].[tblWeldingMap_TEMP] SET MTDate = REPLACE(MTDate,' ','')
UPDATE [PIPING].[tblWeldingMap_TEMP] SET PTDate = REPLACE(PTDate,' ','')



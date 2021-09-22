ALTER PROC PIPING.GetWeldingMapStagingError
AS
SELECT
Id
,ValidateStatus AS [Validate Status]
,[ValidateError]
,[Plant] + [Unit] + [System] + [Subsystem] + [EquipmentCode] + [BranchNumber] + [Train] AS [ISO Number]
,[Plant] + [Unit] + [System] + [Subsystem] + [EquipmentCode] + [BranchNumber] + [Train] + [Spool] + [JointNumber] AS [Joint Number]
,[ISORevision],[MapRevision],[Subcontractor],[Plant],[Unit],[System],[Subsystem],[EquipmentCode],[BranchNumber],[Train],[Spool]
,[JointNumber],[JoinName],[PipingClass],[MaterialClass],[MaterialClass2],[JointLocation],[JointType]
,[JointSize],[Bore],[Sch],[Schmm],[JointStatus],[FitUpDate],[WeldDate],[WQT],[Welder1],[Welder2],[Welder3],[Welder4]
,[Welder5],[Welder6],[HN1],[HN2],[WPS],[HeatRod],[HeatE],[Category],[VisualInsp],[Temprature],[PostheatingNumberChartNumber]
,[PostheatingDate],[PWHT1Number],[PWHT1Date],[HTaNumber],[HTDate],[RT1UT1Number],[RT1UT1Date],[RTUTReShoot1Number],[RTUTReShoot1Date]
,[RTUTReShoot2Number],[RTUTReShoot2Date],[RTUTRemarks],[PMINumber],[PMIDate],[MTNumber],[MTDate]
,[PTTCNumber],[PTDate],[MTPTRemarks],[userFullName]
FROM PIPING.tblWeldingMap_TEMP WITH (NOLOCK)
WHERE ValidateError IS NOT NULL
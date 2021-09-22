ALTER PROC PIPING.ApproveWMStaging
AS

UPDATE v
SET ValidateStatus = [Status]
FROM (
    SELECT
    Origin.Id,ValidateStatus
    ,[ValidateError]
    ,Approved.Status
    FROM PIPING.tblWeldingMap_TEMP AS Origin WITH (NOLOCK)
    INNER JOIN [PIPING].[StagingWeldingMapApproval] AS Approved WITH (NOLOCK) ON Origin.Id = Approved.[tempId]
    WHERE Origin.ValidateError NOT IN 
    (
        'ISO Does Not Exist','Wrong Postheating Date','Wrong PWHT1 Date'
        ,'Wrong HT Date','Wrong RT1UT1 Date','Wrong RTUTRe Shoot1 Date'
        ,'Wrong RTUTRe Shoot2 Date','Wrong PMI Date','Wrong MT Date','Wrong PT Date','Duplicated Joint')
) AS v
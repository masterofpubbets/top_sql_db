ALTER PROC sp_getLotoPermit
AS
SELECT
HSE.tblLotoPermit.lotoPermitId AS ID

,CASE   
        WHEN closeoutDate IS NOT NULL THEN '07- Permit Close Out'
        WHEN workCompletionValidationDate IS NOT NULL THEN '06- Work Validated'
        WHEN workCompletionDate IS NOT NULL THEN '05- Work Completed'
        WHEN workPermitIssuedDate IS NOT NULL THEN '04- Work Permit Issued'
        WHEN lockoutAppliedDate IS NOT NULL THEN '03- Lockout Applied'
        WHEN workAuthorizedDate IS NOT NULL THEN '02- Work Authorized'
        WHEN workAuthorizedDate IS NULL THEN '01- New Permit' 

ELSE 'UNDEFINED'
END AS [Status]

,HSE.tblLotoPermit.permitNumber AS [Permit Number]
,dbo.tblUnits.unit_name AS [Unit]
,HSE.tblLotoPermit.permitDescription AS [Description]
,HSE.tblLotoPermit.permitForWork AS [For Work],HSE.tblLotoPermit.permitForTest AS [For Test]

,HSE.tblLotoPermit.workArea AS [Work Area]

,HSE.tblHSEMember.memberName AS [Requester Name],dbo.tblSubcontractor.subconName AS [Requester Company]
,HSE.tblLotoPermit.foreseenDuration AS [Foreseen Duration]
,HSE.tblLotoPermit.requestDate AS [Request Date]

,executionMembers.memberName AS [Execution Name],executionCompany.subconName AS [Execution Company]
,coactivityMembers.memberName AS [Coactivity Person],coactivityCompany.subconName AS [Coactivity Company]

,coactivityThirdMembers.memberName AS [Thirdparty Coactivity Person],coactivityThirdCompany.subconName AS [Thirdparty Coactivity Company]

,CASE WHEN HSE.tblLotoPermit.permitRequired = 1 THEN 'Yes' ELSE 'No' END AS [Loto Required]
,CASE WHEN HSE.tblLotoPermit.isExtended = 1 THEN 'Yes' ELSE 'No' END AS [Is Extended]
,HSE.tblLotoPermit.extendedDate AS [Extended Date]
,HSE.tblLotoPermit.extendedDays AS [Extended Days]
,HSE.tblLotoPermit.extendedDays + HSE.tblLotoPermit.foreseenDuration AS [Total Duration]
,closeoutDate AS [Close Out Date]


FROM HSE.tblLotoPermit

INNER JOIN dbo.tblUnits ON HSE.tblLotoPermit.unitId = dbo.tblUnits.unit_id

INNER JOIN HSE.tblHSEMember ON HSE.tblLotoPermit.requestId = HSE.tblHSEMember.memId
INNER JOIN dbo.tblSubcontractor ON HSE.tblHSEMember.subconId = dbo.tblSubcontractor.subconId

INNER JOIN HSE.tblHSEMember AS [executionMembers] ON HSE.tblLotoPermit.executionId = executionMembers.memId
INNER JOIN dbo.tblSubcontractor AS [executionCompany] ON executionMembers.subconId = executionCompany.subconId

INNER JOIN HSE.tblHSEMember AS [coactivityMembers] ON HSE.tblLotoPermit.coactivityMemberId = coactivityMembers.memId
INNER JOIN dbo.tblSubcontractor AS [coactivityCompany] ON coactivityMembers.subconId = coactivityCompany.subconId

LEFT JOIN HSE.tblHSEMember AS [coactivityThirdMembers] ON HSE.tblLotoPermit.coactivityThirdpartyMemberId = coactivityThirdMembers.memId
LEFT JOIN dbo.tblSubcontractor AS [coactivityThirdCompany] ON coactivityThirdMembers.subconId = coactivityThirdCompany.subconId
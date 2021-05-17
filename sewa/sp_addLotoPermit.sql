ALTER PROC sp_addLotoPermit
@requestName NVARCHAR(255),
@executionName NVARCHAR(255),
@coactivityName NVARCHAR(255),
@unit NVARCHAR(50),
@permitNumber INT,
@permitForWork BIT,
@permitForTest BIT,
@workArea NVARCHAR(255),
@foreseenDuration INT,
@description NVARCHAR(255),
@coactivityThirdpartyName NVARCHAR(255) = NULL

AS
DECLARE @requestId INT
DECLARE @executionId INT
DECLARE @coactivityMemberId INT
DECLARE @coactivityThirdpartyMemberId INT
DECLARE @unitId INT

SELECT @requestId = HSE.tblHSEMember.memId FROM HSE.tblHSEMember WHERE HSE.tblHSEMember.memberName = @requestName
SELECT @executionId = HSE.tblHSEMember.memId FROM HSE.tblHSEMember WHERE HSE.tblHSEMember.memberName = @executionName
SELECT @coactivityMemberId = HSE.tblHSEMember.memId FROM HSE.tblHSEMember WHERE HSE.tblHSEMember.memberName = @coactivityName
SELECT @coactivityThirdpartyMemberId = HSE.tblHSEMember.memId FROM HSE.tblHSEMember WHERE HSE.tblHSEMember.memberName = @coactivityThirdpartyName
SELECT @unitId = tblUnits.unit_id FROM tblUnits WHERE unit_name = @unit

INSERT INTO HSE.tblLotoPermit ([requestId],[executionId],[coactivityMemberId],[coactivityThirdpartyMemberId],[unitId]
,[permitNumber],[permitForWork],[permitForTest],[workArea]
,[foreseenDuration],[requestDate],permitDescription)
VALUES (@requestId,@executionId,@coactivityMemberId,@coactivityThirdpartyMemberId,@unitId,
        @permitNumber,@permitForWork,@permitForTest,@workArea,
        @foreseenDuration,GETDATE(),@description )

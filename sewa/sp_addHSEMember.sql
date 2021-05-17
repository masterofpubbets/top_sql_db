CREATE PROC sp_addHSEMember
@name NVARCHAR(255),
@company NVARCHAR(50)

AS
DECLARE @comId INT
SELECT @comId = tblSubcontractor.subconId FROM tblSubcontractor WHERE tblSubcontractor.subconName = @company
INSERT INTO HSE.tblHSEMember (memberName,subconID)
VALUES (@name,@comId)
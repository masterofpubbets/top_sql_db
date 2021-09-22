CREATE PROC QC.DeleteJointRule
@id INT
AS
DELETE FROM QC.tblJointRules WHERE RuleId = @id
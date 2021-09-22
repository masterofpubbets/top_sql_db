ALTER PROC QC.AddJointRule
@CatlogId INT,
@PropertyName NVARCHAR(100),
@Schedule NVARCHAR(255) = NULL,
@MaterialClass NVARCHAR(255) = NULL,
@ServiceFluid NVARCHAR(255) = NULL,
@Size NVARCHAR(255) = NULL,
@Temp NVARCHAR(255) = NULL,
@JointType NVARCHAR(255) = NULL,
@CheckValue FLOAT,
@RulaName NVARCHAR(255)

AS
DECLARE @propertyId INT
DECLARE @id INT --check if the rule already exists

SELECT @propertyId = ChkId FROM QC.tblCheckProprty WHERE PropertyName = @PropertyName

SELECT @id = RuleId FROM QC.tblJointRules 
    WHERE CatlogId = @CatlogId AND ChkProId = @propertyId AND Schedule = @Schedule
        AND MaterialClass = @MaterialClass AND ServiceFluid = @ServiceFluid
        AND [Size] = @Size AND Temp = @Temp
        AND JointType = @JointType
IF @id IS NULL
    BEGIN
        INSERT INTO QC.tblJointRules (CatlogId,ChkProId,Schedule,MaterialClass,ServiceFluid,[Size],Temp,ChkValue,RulesName,JointType)
        VALUES (@CatlogId,@propertyId,@Schedule,@MaterialClass,@ServiceFluid,@Size,@Temp,@CheckValue,@RulaName,@JointType)
    END
ELSE
    BEGIN
        UPDATE QC.tblJointRules
            SET ChkValue = @CheckValue
        WHERE RuleId = @id
    END



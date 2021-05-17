CREATE PROC sp_editCable
@tag NVARCHAR(100),
@description NVARCHAR(255),
@serviceLevel NVARCHAR(50),
@wiringDiagram NVARCHAR(100),
@wiringRev NVARCHAR(50),
@code NVARCHAR(50),
@revision NVARCHAR(50),
@fromEq NVARCHAR(100),
@fromDescription NVARCHAR(255),
@toEq NVARCHAR(100),
@toDescription NVARCHAR(255),
@engLength FLOAT,
@drum NVARCHAR(100),
@remarks NVARCHAR(255),
@unit NVARCHAR(100),
@top NVARCHAR(100),
@discipline NVARCHAR(100),
@cableType NVARCHAR(100),
@cableId INT,
@userName NVARCHAR(50)

AS
DECLARE @unitId INT
DECLARE @topId INT
DECLARE @drumId INT

SELECT @unitId = unit_id FROM tblUnits WHERE unit_name = @unit
SELECT @topId = top_id FROM tblTOP WHERE top_name = @top
SELECT @drumId = drumId FROM tblDrums WHERE tag = @drum

INSERT INTO tblCables (unit_id,top_id,tag,discipline,cable_type,[description],code,service_level,from_eq,from_decription,to_eq,to_description,wiring_diagram,wd_rev,design_length,drumId
                        ,remarks,revision,appCreatedDate,active)
VALUES (@unitId,@topId,@tag,@discipline,@cableType,@description,@code,@serviceLevel,@fromEq,@fromDescription,@toEq,@toDescription,@wiringDiagram,@wiringRev,
        @engLength,@drumId,@remarks,@revision,GETDATE(),1)

UPDATE tblCables
            SET unit_id = @unitId,
                top_id = @topId,
                discipline = @discipline,
                tag = @tag,
                cable_type = @cableType,
                [description] = @description,
                code = @code,
                service_level = @serviceLevel,
                from_eq = @fromEq,
                from_decription = @fromDescription,
                to_eq = @toEq,
                to_description = @toDescription,
                wiring_diagram = @wiringDiagram,
                wd_rev = @wiringRev,
                design_length = @engLength,
                drumId = @drumId,
                remarks = @remarks,
                revision = @revision,
                appCreatedDate = GETDATE(),
                engineeringBy = @userName
WHERE cable_id = @cableId










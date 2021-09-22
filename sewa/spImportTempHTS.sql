ALTER PROC [dbo].[spImportTempHTS]

AS

--'CLean Integration'
UPDATE tblHT_temp SET tested_date = NULL WHERE tested_date=''
UPDATE tblHT_temp SET reinstated_date = NULL WHERE reinstated_date=''
UPDATE tblHT_temp SET tested_date = CONVERT(DATE, tested_date)
UPDATE tblHT_temp SET reinstated_date = CONVERT(DATE, reinstated_date)
UPDATE tblHT_temp SET joints_qc_done = '0' WHERE ((joints_qc_done = '') OR (joints_qc_done IS NULL))
UPDATE tblHT_temp SET joints_welded = '0' WHERE ((joints_welded = '') OR (joints_welded IS NULL))
UPDATE tblHT_temp SET joints_scope = '0' WHERE ((joints_scope = '') OR (joints_scope IS NULL))
UPDATE tblHT_temp SET dia_complete = '0' WHERE ((dia_complete = '') OR (dia_complete IS NULL))
UPDATE tblHT_temp SET dia_scope = '0' WHERE ((dia_scope = '') OR (dia_scope IS NULL))
UPDATE tblHT_temp SET prio = '0' WHERE ((prio = '') OR (prio IS NULL))


DECLARE ht_cursor CURSOR FOR SELECT [top_name],[unit_name],[ht_name],[subcon],[test_type],[test_pressure]
,CONVERT(FLOAT,[prio]) AS prio,CONVERT(FLOAT,[dia_scope]) AS dia_scope,CONVERT(FLOAT,[dia_complete]) AS dia_complete
,CONVERT(FLOAT,[joints_scope]) AS joints_scope,CONVERT(FLOAT,[joints_welded]) AS joints_welded
,CONVERT(FLOAT,[joints_qc_done]) AS joints_qc_done,[a_punch],[tested_date],[reinstated_date] FROM [dbo].[tblHT_temp]; 

DECLARE @top_name nvarchar(100)
DECLARE @unit_name nvarchar(50)
DECLARE @ht_name nvarchar(100)
DECLARE @subcon nvarchar(50)
DECLARE @test_type nvarchar(50)
DECLARE @test_pressure float
DECLARE @prio int
DECLARE @dia_scope float
DECLARE @dia_complete float
DECLARE @joints_scope int
DECLARE @joints_welded int
DECLARE @joints_qc_done int
DECLARE @a_punch nvarchar(100)
DECLARE @tested_date date
DECLARE @reinstated_date date
DECLARE @id int
DECLARE @unitId int
DECLARE @topId int
DECLARE @tu nvarchar(50)
DECLARE @tt nvarchar(50)

OPEN ht_cursor;
FETCH NEXT FROM ht_cursor INTO @top_name, @unit_name, @ht_name,@subcon,@test_type,@test_pressure,@prio,@dia_scope,
@dia_complete,@joints_scope,@joints_welded,@joints_qc_done,@a_punch,@tested_date,@reinstated_date;
WHILE @@FETCH_STATUS = 0  
BEGIN  

		SELECT @id = null
		SELECT @unitId = null
		SELECT @topId = null
       SELECT @id = ht_id from [dbo].[tblHT] where ht_name = @ht_name
	   SELECT @unitId = unit_id from dbo.tblUnits where unit_name = @unit_name
	   SELECT @topId = top_id from dbo.tblTOP where top_name = @top_name

	   if @unitId is null
			BEGIN
				select @tu = 'Invalid Unit: ' + @unit_name
				select @tt = 'Add or Edit HT: ' + @ht_name
				EXEC sp_addLog @tu,@tt
			END
		ELSE
			BEGIN
				if @topId is null
					BEGIN
						select @tu = 'Invalid TOP: ' + @top_name
						select @tt = 'Add or Edit HT: ' + @ht_name
						EXEC sp_addLog @tu,@tt
					END
				ELSE
					BEGIN
						if @id is null
							BEGIN
								INSERT INTO [dbo].[tblHT] ([top_id],[unit_id],[ht_name],[subcon],[test_type],[test_pressure],[prio],[dia_scope],[dia_complete],[joints_scope],[joints_welded],[joints_qc_done],[a_punch],[tested_date],[reinstated_date])
								VALUES (@topId,@unitId,@ht_name,@subcon,@test_type,@test_pressure,@prio,@dia_scope,@dia_complete,@joints_scope,@joints_welded,@joints_qc_done,@a_punch,@tested_date,@reinstated_date)
							END
						ELSE
							BEGIN
								UPDATE [dbo].[tblHT]
								SET [top_id] = @topId,
									[unit_id] = @unitId,
									[subcon] = @subcon,
									[test_type] = @test_type,
									[test_pressure] = @test_pressure,
									[prio] = @prio,
									[dia_scope] = @dia_scope,
									[dia_complete] = @dia_complete,
									[joints_scope] = @joints_scope,
									[joints_welded] = @joints_welded,
									[joints_qc_done] = @joints_qc_done,
									[a_punch] = @a_punch,
									[tested_date] = @tested_date,
									[reinstated_date] = @reinstated_date
								WHERE ht_name = @ht_name
							END
					END
			END
			


       FETCH NEXT FROM ht_cursor INTO @top_name, @unit_name, @ht_name,@subcon,@test_type,@test_pressure,@prio,@dia_scope,@dia_complete
       ,@joints_scope,@joints_welded,@joints_qc_done,@a_punch,@tested_date,@reinstated_date;
END;
CLOSE ht_cursor;
DEALLOCATE ht_cursor;

GO

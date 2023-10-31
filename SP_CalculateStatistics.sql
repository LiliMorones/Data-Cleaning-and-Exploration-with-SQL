
-- Store Procedure - Calculate Statistics (for numeric columns)

ALTER PROCEDURE CalculateStatistics
    @ColumnName VARCHAR(55)  
AS
BEGIN
	DECLARE @Q1 FLOAT;
    DECLARE @Median FLOAT;
	DECLARE @Q3 FLOAT;
    DECLARE @Mode FLOAT;
    DECLARE @Query NVARCHAR(MAX);

	-- Calculate Q1 for the specified column
    SET @Query = N'SELECT @Q1 = PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY [' + @ColumnName + ']) OVER ()
                   FROM MedicalStudents
                   WHERE [' + @ColumnName + '] IS NOT NULL';

    -- Execute the query for Q1
	EXEC sp_executesql @Query, N'@Q1 FLOAT OUTPUT', @Q1 OUTPUT;


    -- Calculate the median for the specified column
    SET @Query = N'SELECT @Median = PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY [' + @ColumnName + ']) OVER ()
                   FROM MedicalStudents
                   WHERE [' + @ColumnName + '] IS NOT NULL';

    -- Execute the query for the median
	EXEC sp_executesql @Query, N'@Median FLOAT OUTPUT', @Median OUTPUT;

	-- Calculate Q3 for the specified column
    SET @Query = N'SELECT @Q3 = PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY [' + @ColumnName + ']) OVER ()
                   FROM MedicalStudents
                   WHERE [' + @ColumnName + '] IS NOT NULL';

    -- Execute the query for the median
	EXEC sp_executesql @Query, N'@Q3 FLOAT OUTPUT', @Q3 OUTPUT;

    -- Calculate mode for specified column
    SET @Query = N'
        SELECT TOP 1 @Mode = ' + @ColumnName + '
        FROM (
            SELECT ' + @ColumnName + ', COUNT(*) AS Count
            FROM MedicalStudents
            WHERE ' + @ColumnName + ' IS NOT NULL
            GROUP BY ' + @ColumnName + '
        ) t
        ORDER BY Count DESC
    ';

	-- Execute the query for the mode
    EXEC sp_executesql @Query, N'@Mode FLOAT OUTPUT', @Mode OUTPUT;

    -- Create a query to calculate average, minimum, and maximum
    SET @Query = N'
        SELECT 
            ROUND(AVG([' + @ColumnName + ']),2) AS AVG,
            MIN([' + @ColumnName + ']) AS MIN,
            MAX([' + @ColumnName + ']) AS MAX,
			@Q1 AS Q1,
            @Median AS Median,
			@Q3 AS Q3,
            @Mode AS Mode
        FROM MedicalStudents'

	-- Execute the query for other statistics
	EXEC sp_executesql @Query, N'@Q1 FLOAT, @Median FLOAT, @Q3 FLOAT, @Mode FLOAT', 
	@Q1, @Median, @Q3, @Mode;

END


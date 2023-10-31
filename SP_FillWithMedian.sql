
-- Store Procedure - Fill Missing Numeric Values With Median

ALTER PROCEDURE FillWithMedian
    @ColumnName VARCHAR(55)  
AS
BEGIN
    DECLARE @Query NVARCHAR(MAX);
    DECLARE @Median FLOAT;

    -- Calculate the median for the specified column
    SET @Query = N'SELECT @Median = PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY [' + @ColumnName + ']) OVER ()
                   FROM MedicalStudents
                   WHERE [' + @ColumnName + '] IS NOT NULL';

    EXEC sp_executesql @Query, N'@Median FLOAT OUTPUT', @Median OUTPUT;

    -- Update table with median values
    SET @Query = N'UPDATE MedicalStudents ' +
                 'SET [' + @ColumnName + '] = ISNULL([' + @ColumnName + '], @Median)';

    EXEC sp_executesql @Query, N'@Median FLOAT', @Median;
END


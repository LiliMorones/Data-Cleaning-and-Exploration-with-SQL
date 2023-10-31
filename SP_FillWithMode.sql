
-- Store Procedure - Fill Categorical Missing Values with Mode

ALTER PROCEDURE FillWithMode
  @ColumnName VARCHAR(55)  
AS
BEGIN
  DECLARE @Mode VARCHAR(55);
  DECLARE @Query NVARCHAR(MAX);

  SET @ColumnName = '[' + @ColumnName + ']';

  -- Calculate mode for specified column
  SET @Query = N'SELECT TOP 1 @Mode = ' + @ColumnName +
              ' FROM MedicalStudents t' +
              ' WHERE ' + @ColumnName + ' IS NOT NULL' +
              ' GROUP BY ' + @ColumnName +
              ' ORDER BY COUNT(*) DESC;';

  EXEC sp_executesql @Query, N'@Mode NVARCHAR(MAX) OUTPUT', @Mode OUTPUT;

  -- Update table with mode values
  SET @Query = N'UPDATE MedicalStudents' +
              ' SET ' + @ColumnName + ' = ISNULL(' + @ColumnName + ', @Mode);';

  EXEC sp_executesql @Query, N'@Mode NVARCHAR(MAX)', @Mode;
END

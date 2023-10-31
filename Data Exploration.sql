-------------------------------- DATA EXPLORATION FROM 'MEDICAL STUDENTS' DATABASE ---------------------------

-- Retrieve all records from the 'MedicalStudents' table
SELECT * 
FROM MedicalStudents

--------------------------------------------------------------------------------------------------------------
-- COUNTING

-- Count the total number of records in the 'MedicalStudents' table
SELECT COUNT(*) AS TotalRecords
FROM MedicalStudents


-- Count records by a specific column
DECLARE @Column VARCHAR(50);
DECLARE @Query NVARCHAR(MAX);

SET @Column = 'Diabetes';

SET @Query = N'
    SELECT ' + @Column + ', COUNT(' + @Column + ') AS Records
    FROM MedicalStudents
	GROUP BY ' + @Column

EXEC (@Query);


--------------------------------------------------------------------------------------------------------------
-- CONSULT STATISTICS FOR NUMERIC COLUMNS

EXEC CalculateStatistics 'Age2'
EXEC CalculateStatistics 'Height2'
EXEC CalculateStatistics 'Weight2'
EXEC CalculateStatistics 'BMI2'
EXEC CalculateStatistics 'Temperature2'
EXEC CalculateStatistics 'HeartRate2'
EXEC CalculateStatistics 'BloodPressure2'
EXEC CalculateStatistics 'Cholesterol2'
EXEC CalculateStatistics 'NumConditions'


--------------------------------------------------------------------------------------------------------------
-- ANALYSIS OF MEDICAL STUDENTS WITH DIABETES

-- Analyze medical students with diabetes by AgeRange and Gender

SELECT AgeRange, Gender, Diabetes, COUNT(Diabetes) AS Records
FROM MedicalStudents
WHERE Diabetes = 'Yes'
GROUP BY AgeRange, Gender, Diabetes
ORDER BY AgeRange, Gender


-- Proportion of Medical Students with Diabetes by Column

DECLARE @Column VARCHAR(50);
DECLARE @Query NVARCHAR(MAX);

SET @Column = 'AlarmCondition'; 

SET @Query = N'
    SELECT ' + @Column + ', 
	COUNT(*) AS TotalStudents,
	SUM(CASE WHEN Diabetes = ''Yes'' THEN 1 ELSE 0 END) AS StudentswDiabetes,
	CAST(SUM(CASE WHEN Diabetes = ''Yes'' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(10, 2)) AS Proportion
    FROM MedicalStudents
	GROUP BY ' + @Column

EXEC (@Query);


-- Calculate the average number of conditions for students with and without diabetes

SELECT Diabetes, ROUND(AVG(CAST(NumConditions AS FLOAT)),2) AS AVGConditions
FROM MedicalStudents
GROUP BY Diabetes


-- Calculate the average BMI for students with and without diabetes

SELECT Diabetes, ROUND(AVG(BMI2),2) AS AVGConditions
FROM MedicalStudents
GROUP BY Diabetes


--------------------------------------------------------------------------------------------------------------
-- ANALYSYS BETWEEN DIFFERENT VARIABLES

-- Presence of at least one alarm condition by age and gender

SELECT AgeRange, Gender, COUNT(*)
FROM MedicalStudents
WHERE AlarmCondition = 'Yes'
GROUP BY AgeRange, Gender
ORDER BY AgeRange, Gender


-- Presence of at least one alarm condition by blood type

SELECT [Blood Type], COUNT(*)
FROM MedicalStudents
WHERE AlarmCondition = 'Yes'
GROUP BY [Blood Type]

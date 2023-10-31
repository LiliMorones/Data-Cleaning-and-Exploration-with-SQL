--------------------------------- DATA CLEANING FROM 'MEDICAL STUDENTS' DATABASE -----------------------------

-- Retrieve all records from the 'medical_students' table

SELECT *
FROM medical_students


--------------------------------------------------------------------------------------------------------------
-- Create a copy of the table

SELECT *
INTO MedicalStudents
FROM medical_students


--------------------------------------------------------------------------------------------------------------
-- Change Column Data Types

ALTER TABLE MedicalStudents
ADD StudentID2 INT 

UPDATE MedicalStudents
SET StudentID2 = CAST(ROUND(CAST([Student ID] AS FLOAT), 0) AS INT)
WHERE ISNUMERIC([Student ID]) = 1

ALTER TABLE MedicalStudents
ADD Age2 INT

UPDATE MedicalStudents
SET Age2 = CAST(ROUND(CAST(Age AS FLOAT), 0) AS INT)
WHERE ISNUMERIC(Age) = 1

ALTER TABLE MedicalStudents
ADD Height2 FLOAT 

UPDATE MedicalStudents
SET Height2 = ROUND(CAST(Height AS FLOAT), 2)
WHERE ISNUMERIC(Height) = 1

ALTER TABLE MedicalStudents
ADD Weight2 FLOAT

UPDATE MedicalStudents
SET Weight2 = ROUND(CAST(Weight AS FLOAT), 2)
WHERE ISNUMERIC(Weight) = 1

ALTER TABLE MedicalStudents
ADD BMI2 FLOAT 

UPDATE MedicalStudents
SET BMI2 = ROUND(CAST(BMI AS FLOAT), 2)
WHERE ISNUMERIC(BMI) = 1

ALTER TABLE MedicalStudents
ADD Temperature2 FLOAT 

UPDATE MedicalStudents
SET Temperature2 = ROUND(CAST(Temperature AS FLOAT), 2)
WHERE ISNUMERIC(Temperature) = 1

ALTER TABLE MedicalStudents
ADD HeartRate2 INT

UPDATE MedicalStudents
SET HeartRate2 = CAST(ROUND(CAST([Heart Rate] AS FLOAT), 0) AS INT)
WHERE ISNUMERIC([Heart Rate]) = 1

ALTER TABLE MedicalStudents
ADD BloodPressure2 INT 

UPDATE MedicalStudents
SET BloodPressure2 = CAST(ROUND(CAST([Blood Pressure] AS FLOAT), 0) AS INT)
WHERE ISNUMERIC([Blood Pressure]) = 1

ALTER TABLE MedicalStudents
ADD Cholesterol2 INT 

UPDATE MedicalStudents
SET Cholesterol2 = CAST(ROUND(CAST(Cholesterol AS FLOAT), 0) AS INT)
WHERE ISNUMERIC(Cholesterol) = 1


--------------------------------------------------------------------------------------------------------------
-- Drop the specified columns that are no longer needed

ALTER TABLE MedicalStudents
DROP COLUMN [Student ID], Age, Height, Weight, BMI, Temperature, [Heart Rate], [Blood Pressure], Cholesterol


--------------------------------------------------------------------------------------------------------------
-- Clean and standardize data by replacing blank spaces with NULL values

DECLARE @Column VARCHAR(50)
DECLARE @Query NVARCHAR(MAX)

SET @Column = '[Blood Type]'

SET @Query = N'
    SELECT ' + @Column + ' AS ' + @Column + ',
        CASE
            WHEN TRIM(' + @Column + ') = '''' THEN NULL
            ELSE ' + @Column + '
        END AS ColumnNull
    FROM MedicalStudents;'

EXEC (@Query)


DECLARE @Column VARCHAR(50)
DECLARE @Query NVARCHAR(MAX)

SET @Column = 'Smoking'

SET @Query = '
    UPDATE MedicalStudents
    SET ' + @Column + ' = NULL
    WHERE TRIM(' + @Column + ') = '''';'

EXEC (@Query)


--------------------------------------------------------------------------------------------------------------
-- Remove duplicate records based on the 'StudentID2' column and keep only one

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY  StudentID2
	ORDER BY StudentId2) row_num
FROM MedicalStudents
WHERE StudentID2 is not null
)

--SELECT *
DELETE
FROM RowNumCTE
WHERE row_num > 1


--------------------------------------------------------------------------------------------------------------
-- Create a new 'StudentID' column without NULL values and generate identity values

ALTER TABLE MedicalStudents
ADD StudentID INT IDENTITY(1, 1)

ALTER TABLE MedicalStudents
DROP COLUMN StudentID2


--------------------------------------------------------------------------------------------------------------
-- Fill missing numeric values in specific columns with their respective medians

EXEC FillWithMedian 'Age2'
EXEC FillWithMedian 'Height2'
EXEC FillWithMedian 'Weight2'
EXEC FillWithMedian 'Temperature2'
EXEC FillWithMedian 'HeartRate2'
EXEC FillWithMedian 'BloodPressure2'
EXEC FillWithMedian 'Cholesterol2'


--------------------------------------------------------------------------------------------------------------
-- Calculate the BMI (Body Mass Index) using the updated 'Weight2' and 'Height2' columns

UPDATE MedicalStudents
SET BMI2 = ROUND(Weight2 / POWER(Height2 / 100, 2), 2)


--------------------------------------------------------------------------------------------------------------
-- Convert temperature values from Fahrenheit to Celsius in the 'Temperature2' column

UPDATE MedicalStudents
SET Temperature2 = ROUND((5.0/9)*(Temperature2 - 32),2)


--------------------------------------------------------------------------------------------------------------
-- Fill missing categorical values with mode

EXEC FillWithMode 'Gender'
EXEC FillWithMode 'Blood Type'
EXEC FillWithMode 'Diabetes'
EXEC FillWithMode 'Smoking'


--------------------------------------------------------------------------------------------------------------
-- Create a new column 'AgeRange' based on the values in the 'Age2' column

SELECT MIN(Age2), MAX(Age2)
FROM MedicalStudents

ALTER TABLE MedicalStudents
ADD AgeRange VARCHAR(10)

UPDATE MedicalStudents
SET AgeRange = 
	CASE
		WHEN Age2 < 20 THEN '< 20'
		WHEN Age2 BETWEEN 20 AND 24 THEN '20-24'
		WHEN Age2 BETWEEN 25 AND 29 THEN '25-29'
		ELSE '30+'
	END


--------------------------------------------------------------------------------------------------------------
-- Create a new column 'BMICategory' based on the values in the 'BMI2' column.

SELECT MIN(BMI2), MAX(BMI2)
FROM MedicalStudents

ALTER TABLE MedicalStudents
ADD BMICategory VARCHAR(55)

UPDATE MedicalStudents
SET BMICategory = 
	CASE
		WHEN BMI2 < 16 THEN 'Severely Underweight'
		WHEN BMI2 BETWEEN 16 AND 18.49 THEN 'Underweight'
		WHEN BMI2 BETWEEN 18.5 AND 24.99 THEN 'Normal'
		WHEN BMI2 BETWEEN 25 AND 29.99 THEN 'Overweight'
		WHEN BMI2 BETWEEN 30 AND 34.99 THEN 'Moderately Obese'
		WHEN BMI2 BETWEEN 35 AND 39.99 THEN 'Severely Obese'
		ELSE 'Morbidly Obese'
	END


--------------------------------------------------------------------------------------------------------------
-- Create a new column 'TempCategory' based on temperature values in the 'Temperature2' column

SELECT MIN(Temperature2), MAX(Temperature2)
FROM MedicalStudents

ALTER TABLE MedicalStudents
ADD TempCategory VARCHAR(55)

UPDATE MedicalStudents
SET TempCategory = 
	CASE
		WHEN Temperature2 < 36 THEN 'Lower than Average'
		WHEN Temperature2 BETWEEN 36 AND 37.2 THEN 'Normal'
		WHEN Temperature2 BETWEEN 37.21 AND 38 THEN 'Higher than Average'
		ELSE 'Fever'
	END


--------------------------------------------------------------------------------------------------------------
-- Create a new column 'HRCategory' based on the heart rate values in the 'HeartRate2' column

SELECT MIN(HeartRate2), MAX(HeartRate2)
FROM MedicalStudents

ALTER TABLE MedicalStudents
ADD HRCategory VARCHAR(55)

UPDATE MedicalStudents
SET HRCategory = 
	CASE
		WHEN HeartRate2 < 60 THEN 'Athlete'
		WHEN HeartRate2 BETWEEN 60 AND 64 THEN 'Excellent'
		WHEN HeartRate2 BETWEEN 65 AND 69 THEN 'Great'
		WHEN HeartRate2 BETWEEN 70 AND 73 THEN 'Good'
		WHEN HeartRate2 BETWEEN 74 AND 78 THEN 'Average'
		WHEN HeartRate2 BETWEEN 79 AND 84 THEN 'Bellow Average'
		ELSE 'Poor'
	END


--------------------------------------------------------------------------------------------------------------
-- Create a new column 'BPCategory' based on systolic blood pressure values in the 'BloodPressure2' column

SELECT MIN(BloodPressure2), MAX(BloodPressure2)
FROM MedicalStudents

ALTER TABLE MedicalStudents
ADD BPCategory VARCHAR(55);

UPDATE MedicalStudents
SET BPCategory = 
	CASE
		WHEN BloodPressure2 < 120 THEN 'Normal'
		WHEN BloodPressure2 BETWEEN 120 AND 129 THEN 'Elevated'
		WHEN BloodPressure2 BETWEEN 130 AND 139 THEN 'Hypertension I'
		ELSE 'Hypertension II'
	END


--------------------------------------------------------------------------------------------------------------
-- Create a new column 'CholesterolCat' based on cholesterol values in the 'Cholesterol2' column

SELECT MIN(Cholesterol2), MAX(Cholesterol2)
FROM MedicalStudents

ALTER TABLE MedicalStudents
ADD CholesterolCat VARCHAR(55)

UPDATE MedicalStudents
SET CholesterolCat = 
	CASE
		WHEN Cholesterol2 < 200 THEN 'Good'
		WHEN Cholesterol2 BETWEEN 200 AND 239 THEN 'Borderline'
		ELSE 'High'
	END


--------------------------------------------------------------------------------------------------------------
-- Create a new column 'NumConditions' based on the number of alarm conditions for each student

ALTER TABLE MedicalStudents
ADD NumConditions INT

UPDATE MedicalStudents
SET NumConditions = 
    CASE
        WHEN Smoking = 'Yes' THEN 1 ELSE 0
    END +
    CASE
        WHEN BMICategory LIKE '%Obese%' THEN 1 ELSE 0
    END +
    CASE
        WHEN TempCategory = 'Fever' THEN 1 ELSE 0
    END +
    CASE
        WHEN HRCategory = 'Poor' THEN 1 ELSE 0
    END +
    CASE
        WHEN BPCategory LIKE 'Hypertension%' THEN 1 ELSE 0
    END +
    CASE
        WHEN CholesterolCat = 'High' THEN 1 ELSE 0
    END


--------------------------------------------------------------------------------------------------------------
-- Create a new column 'AlarmCondition' based on the presence of alarm conditions

ALTER TABLE MedicalStudents
ADD AlarmCondition VARCHAR(3)

UPDATE MedicalStudents
SET AlarmCondition = 
    CASE
        WHEN NumConditions > 0 THEN 'Yes'
        ELSE 'No'
    END
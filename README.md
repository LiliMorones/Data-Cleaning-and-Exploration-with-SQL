
# Medical Students: Data Cleaning and Exploration with SQL

## Description

The primary objective of this project was to refine proficiency in SQL Server by applying data cleaning techniques to the 'Medical Students' synthetic dataset from Kaggle. The endeavor involved data preprocessing and subsequent exploration, with the overarching goal of uncovering potential associations between the provided variables and the presence or absence of diabetes.


## Results

Results:
The project achieved several significant outcomes. Firstly, it successfully addressed data quality issues by eliminating duplicate records, handling missing values, converting the data types of numerical columns, and introducing new categorical features derived from numerical data.

Regarding the data exploration, the dataset primarily comprises medical students with a median age of 26 years, where slightly over half of the records pertain to males. Notably, approximately 18% of the students reported being smokers, while 9% of them had diabetes.

The findings from data exploration indicate that certain factors pose a higher risk of diabetes. These risk factors include male gender, blood type 'B', smoking habits, age of 25 years or older, and obesity.
## Project Structure

Data Cleaning:

This is the SQL code for data cleaning and preprocessing. It utilizes two distinct stored procedures, SP_FillWithMedian and SP_FillWithMode, which were employed to handle missing values in numerical and categorical columns, respectively.

Data Exploration:

This is the SQL code for data exploration and analysis. It utilizes the stored procedure SP_CalculateStatistics to compute essential statistical values for numerical variables, such as mean, median, mode, first and third quartiles, as well as minimum and maximum values.
## Variable Descriptions

StudentID: A unique identification number for each student.

Age: The age of the student, ranging from 18 to 39 years.

Gender: The gender of the student, which can be male or female.

Height: The student's height, measured in centimeters (cm).

Weight: The student's weight, measured in kilograms (kg).

Blood Type: The blood type of the student, which can be A, B, AB, or O.

BMI (Body Mass Index): A measure of the student's body mass index.

Temperature: The student's body temperature, expressed in degrees Fahrenheit (°F).

Heart Rate: The student's heart rate, measured in beats per minute (bpm).

Blood Pressure: The student's systolic blood pressure, expressed in millimeters of mercury (mmHg).

Cholesterol: The student's blood cholesterol level.

Diabetes: Indicates whether the student has diabetes (yes or no).

Smoking: Indicates whether the student is a smoker (yes or no).
## Data Source

The dataset used in this project was obtained from Kaggle and was originally published by Salem S. The dataset is available at the following link: https://www.kaggle.com/datasets/slmsshk/medical-students-dataset.

This dataset has been modified to perform data cleaning and to create additional columns for analysis. It is made available under the Creative Commons Attribution 4.0 International License: https://creativecommons.org/licenses/by/4.0/.
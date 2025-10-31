/* =====================================================
   STEP 1 — CREATE DATABASE
===================================================== */
CREATE DATABASE HR_Employee_Attrition_DB;
GO
USE HR_Employee_Attrition_DB;
GO

/* =====================================================
   STEP 2 — (Already imported)
   The raw CSV table exists as [HR-Employee-Attrition]
===================================================== */
/* Example structure (if needed for reference)
CREATE TABLE [HR-Employee-Attrition] (
    Age INT,
    Attrition VARCHAR(10),
    BusinessTravel VARCHAR(50),
    DailyRate INT,
    Department VARCHAR(50),
    DistanceFromHome INT,
    Education INT,
    EducationField VARCHAR(50),
    EmployeeCount INT,
    EmployeeNumber INT,
    EnvironmentSatisfaction INT,
    Gender VARCHAR(10),
    HourlyRate INT,
    JobInvolvement INT,
    JobLevel INT,
    JobRole VARCHAR(50),
    JobSatisfaction INT,
    MaritalStatus VARCHAR(20),
    MonthlyIncome INT,
    MonthlyRate INT,
    NumCompaniesWorked INT,
    Over18 CHAR(1),
    OverTime VARCHAR(10),
    PercentSalaryHike INT,
    PerformanceRating INT,
    RelationshipSatisfaction INT,
    StandardHours INT,
    StockOptionLevel INT,
    TotalWorkingYears INT,
    TrainingTimesLastYear INT,
    WorkLifeBalance INT,
    YearsAtCompany INT,
    YearsInCurrentRole INT,
    YearsSinceLastPromotion INT,
    YearsWithCurrManager INT
);
GO
*/

/* =====================================================
   STEP 3 — CREATE DIMENSION TABLES
===================================================== */

CREATE TABLE DimDepartment (
    DepartmentKey INT IDENTITY(1,1) PRIMARY KEY,
    DepartmentName VARCHAR(100) UNIQUE
);

CREATE TABLE DimJobRole (
    JobRoleKey INT IDENTITY(1,1) PRIMARY KEY,
    JobRoleName VARCHAR(100) UNIQUE
);

CREATE TABLE DimEducationField (
    EducationFieldKey INT IDENTITY(1,1) PRIMARY KEY,
    EducationFieldName VARCHAR(100) UNIQUE
);

CREATE TABLE DimMaritalStatus (
    MaritalStatusKey INT IDENTITY(1,1) PRIMARY KEY,
    MaritalStatusName VARCHAR(50) UNIQUE
);

CREATE TABLE DimBusinessTravel (
    BusinessTravelKey INT IDENTITY(1,1) PRIMARY KEY,
    BusinessTravelType VARCHAR(100) UNIQUE
);

CREATE TABLE DimGender (
    GenderKey INT IDENTITY(1,1) PRIMARY KEY,
    GenderName VARCHAR(10) UNIQUE
);

CREATE TABLE DimOverTime (
    OverTimeKey INT IDENTITY(1,1) PRIMARY KEY,
    OverTimeStatus VARCHAR(10) UNIQUE
);

CREATE TABLE DimOver18 (
    Over18Key INT IDENTITY(1,1) PRIMARY KEY,
    Over18Flag CHAR(1) UNIQUE
);

/* =====================================================
   STEP 4 — POPULATE DIMENSIONS FROM [HR-Employee-Attrition]
===================================================== */

INSERT INTO DimDepartment (DepartmentName)
SELECT DISTINCT Department FROM [HR-Employee-Attrition];

INSERT INTO DimJobRole (JobRoleName)
SELECT DISTINCT JobRole FROM [HR-Employee-Attrition];

INSERT INTO DimEducationField (EducationFieldName)
SELECT DISTINCT EducationField FROM [HR-Employee-Attrition];

INSERT INTO DimMaritalStatus (MaritalStatusName)
SELECT DISTINCT MaritalStatus FROM [HR-Employee-Attrition];

INSERT INTO DimBusinessTravel (BusinessTravelType)
SELECT DISTINCT BusinessTravel FROM [HR-Employee-Attrition];

INSERT INTO DimGender (GenderName)
SELECT DISTINCT Gender FROM [HR-Employee-Attrition];

INSERT INTO DimOverTime (OverTimeStatus)
SELECT DISTINCT OverTime FROM [HR-Employee-Attrition];

INSERT INTO DimOver18 (Over18Flag)
SELECT DISTINCT Over18 FROM [HR-Employee-Attrition];
GO

/* =====================================================
   STEP 5 — CREATE FACT TABLE
===================================================== */

CREATE TABLE FactEmployee (
    EmployeeKey INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeNumber INT,
    Age INT,
    Attrition VARCHAR(10),
    DailyRate INT,
    DistanceFromHome INT,
    Education INT,
    EmployeeCount INT,
    EnvironmentSatisfaction INT,
    HourlyRate INT,
    JobInvolvement INT,
    JobLevel INT,
    JobSatisfaction INT,
    MonthlyIncome INT,
    MonthlyRate INT,
    NumCompaniesWorked INT,
    PercentSalaryHike INT,
    PerformanceRating INT,
    RelationshipSatisfaction INT,
    StandardHours INT,
    StockOptionLevel INT,
    TotalWorkingYears INT,
    TrainingTimesLastYear INT,
    WorkLifeBalance INT,
    YearsAtCompany INT,
    YearsInCurrentRole INT,
    YearsSinceLastPromotion INT,
    YearsWithCurrManager INT,

    DepartmentKey INT FOREIGN KEY REFERENCES DimDepartment(DepartmentKey),
    JobRoleKey INT FOREIGN KEY REFERENCES DimJobRole(JobRoleKey),
    EducationFieldKey INT FOREIGN KEY REFERENCES DimEducationField(EducationFieldKey),
    MaritalStatusKey INT FOREIGN KEY REFERENCES DimMaritalStatus(MaritalStatusKey),
    BusinessTravelKey INT FOREIGN KEY REFERENCES DimBusinessTravel(BusinessTravelKey),
    GenderKey INT FOREIGN KEY REFERENCES DimGender(GenderKey),
    OverTimeKey INT FOREIGN KEY REFERENCES DimOverTime(OverTimeKey),
    Over18Key INT FOREIGN KEY REFERENCES DimOver18(Over18Key)
);
GO

/* =====================================================
   STEP 6 — POPULATE FACT TABLE
===================================================== */

INSERT INTO FactEmployee (
    EmployeeNumber, Age, Attrition, DailyRate, DistanceFromHome, Education,
    EmployeeCount, EnvironmentSatisfaction, HourlyRate, JobInvolvement, JobLevel,
    JobSatisfaction, MonthlyIncome, MonthlyRate, NumCompaniesWorked, PercentSalaryHike,
    PerformanceRating, RelationshipSatisfaction, StandardHours, StockOptionLevel,
    TotalWorkingYears, TrainingTimesLastYear, WorkLifeBalance, YearsAtCompany,
    YearsInCurrentRole, YearsSinceLastPromotion, YearsWithCurrManager,
    DepartmentKey, JobRoleKey, EducationFieldKey, MaritalStatusKey, BusinessTravelKey,
    GenderKey, OverTimeKey, Over18Key
)
SELECT
    E.EmployeeNumber,
    E.Age,
    E.Attrition,
    E.DailyRate,
    E.DistanceFromHome,
    E.Education,
    E.EmployeeCount,
    E.EnvironmentSatisfaction,
    E.HourlyRate,
    E.JobInvolvement,
    E.JobLevel,
    E.JobSatisfaction,
    E.MonthlyIncome,
    E.MonthlyRate,
    E.NumCompaniesWorked,
    E.PercentSalaryHike,
    E.PerformanceRating,
    E.RelationshipSatisfaction,
    E.StandardHours,
    E.StockOptionLevel,
    E.TotalWorkingYears,
    E.TrainingTimesLastYear,
    E.WorkLifeBalance,
    E.YearsAtCompany,
    E.YearsInCurrentRole,
    E.YearsSinceLastPromotion,
    E.YearsWithCurrManager,

    D.DepartmentKey,
    J.JobRoleKey,
    EF.EducationFieldKey,
    M.MaritalStatusKey,
    BT.BusinessTravelKey,
    G.GenderKey,
    OT.OverTimeKey,
    O18.Over18Key

FROM [HR-Employee-Attrition] E
JOIN DimDepartment D ON E.Department = D.DepartmentName
JOIN DimJobRole J ON E.JobRole = J.JobRoleName
JOIN DimEducationField EF ON E.EducationField = EF.EducationFieldName
JOIN DimMaritalStatus M ON E.MaritalStatus = M.MaritalStatusName
JOIN DimBusinessTravel BT ON E.BusinessTravel = BT.BusinessTravelType
JOIN DimGender G ON E.Gender = G.GenderName
JOIN DimOverTime OT ON E.OverTime = OT.OverTimeStatus
JOIN DimOver18 O18 ON E.Over18 = O18.Over18Flag;
GO

/* =====================================================
   STEP 7 — VERIFY DATA
===================================================== */

SELECT COUNT(*) AS TotalEmployees FROM FactEmployee;
SELECT TOP 10 * FROM FactEmployee;
GO


select * from DimDepartment;
select * from DimJobRole;
select * from DimEducationField;
select * from DimBusinessTravel;
select * from DimMaritalStatus;
select * from DimGender;
select * from DimOverTime;
select * from DimOver18;
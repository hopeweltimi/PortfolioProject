SELECT *
FROM [dbo].[bi]

SELECT CONCAT([fNAME], ' ' ,[lNAME] ) AS Fullname
FROM   [dbo].[bi];

-- CREATE A NEW TABLE FOR FULLNMAE 

ALTER TABLE [dbo].[bi]
ADD Fullname NVARCHAR(100);

UPDATE [dbo].[bi]
SET Fullname = CONCAT([fNAME], ' ', [lNAME]);

SELECT [gender]
FROM [dbo].[bi]

-- CHANGING F TO FEMALE AND M TO MALE 

    UPDATE [dbo].[bi]
SET [gender] = CASE 
    WHEN LOWER(gender) IN ( 'f') THEN 'Female'
    WHEN LOWER(gender) IN ( 'm') THEN 'Male'
    ELSE gender
END;

SELECT [prevEducation]
FROM [dbo].[bi]

-- UPDATING SPELLINGS, AND LOWERCASE WORDS

UPDATE [dbo].[bi]
SET  [prevEducation]= CASE
    WHEN LOWER(prevEducation) LIKE 'high%school%' THEN 'High School'
    WHEN LOWER(prevEducation) LIKE 'Barrrchelors%' THEN 'Bachelors'
    WHEN LOWER(prevEducation) LIKE 'master%' THEN 'Masters'
    WHEN LOWER(prevEducation) LIKE 'diploma%' THEN 'Diploma'
    WHEN LOWER(prevEducation) = 'doctorate' THEN 'Doctorate'
    ELSE prevEducation
END;

 --SELCTING TOP 5 BEST STUDENT 

SELECT TOP 5 [Fullname],
[entryEXAM] AS TotalScore
FROM [dbo].[bi]
ORDER BY [entryEXAM] DESC

-- AVERAGE STUDENT SCORE AND COUNTRY THEY ARE FROM

SELECT 
    [country], 
    COUNT(*) AS StudentCount,
    ROUND(AVG(CAST([entryEXAM] AS FLOAT)), 2) AS AvgEntryExam
FROM [dbo].[bi]
GROUP BY country
-- HAVING COUNT(*) > 5
ORDER BY AvgEntryExam DESC;

-- CHANGING RSA TO SOUTH AFRICA
select distinct [country]
from[dbo].[bi]

 UPDATE [dbo].[bi]
SET [country] = 'South Africa'
WHERE [country] = 'Rsa';

-- AVG TOTAL SCORE AND STUDY RANGE OF STUDENT  
SELECT 
    CASE 
        WHEN [studyHOURS] < 120 THEN 'Low (<120)'
        WHEN  [studyHOURS]BETWEEN 120 AND 140 THEN 'Medium (120-140)'
        ELSE 'High (>140)'
    END AS StudyHourRange,
    COUNT(*) AS StudentCount,
    ROUND(AVG(CAST([entryEXAM] AS FLOAT)), 2) AS AvgTotalScore
FROM [dbo].[bi]
GROUP BY 
    CASE 
        WHEN [studyHOURS] < 120 THEN 'Low (<120)'
        WHEN [studyHOURS] BETWEEN 120 AND 140 THEN 'Medium (120-140)'
        ELSE 'High (>140)'
    END
ORDER BY AvgTotalScore DESC;


select [studyHOURS]
from [dbo].[bi]
order by [studyHOURS] 

-- CREATING A NEW TABLE FOR STUDENT WITH STUDY HOURS > 150 THAT PASSED/FAILED

ALTER TABLE [dbo].[bi]
ADD PassFail VARCHAR(10);

UPDATE [dbo].[bi]
SET PassFail = CASE WHEN [studyHOURS] > =  150 THEN 'Pass'
Else 'Fail'
END;

SELECT [PassFail]
FROM [dbo].[bi]


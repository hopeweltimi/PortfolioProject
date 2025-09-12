-- Data Cleaning 

-- Standardize Data Format 

SELECT [SaleDate], CONVERT (date,[SaleDate]) AS DATE
FROM [dbo].[NashvilleHousing];


UPDATE [dbo].[NashvilleHousing]
SET [SaleDate]  =  CONVERT (date,[SaleDate])


 SELECT *
 FROM [dbo].[NashvilleHousing]


 -- Populate Property Address Data 

 SELECT *
 FROM [dbo].[NashvilleHousing]
 -- WHERE [PropertyAddress] IS NOT NULL
 ORDER BY [ParcelID]

 -- Joining thesame table 


SELECT 
    a.[ParcelID],
    ISNULL(a.[PropertyAddress], b.[PropertyAddress]) AS PropertyAddress
FROM 
    [dbo].[NashvilleHousing] a
JOIN 
    [dbo].[NashvilleHousing] b
    ON a.[ParcelID] = b.[ParcelID]
    AND a.[UniqueID] <> b.[UniqueID]
WHERE 
    a.[PropertyAddress] IS NULL;


    UPDATE a
SET a.[PropertyAddress] = ISNULL(a.[PropertyAddress], b.[PropertyAddress])
FROM [dbo].[NashvilleHousing] a
JOIN [dbo].[NashvilleHousing] b
    ON a.[ParcelID] = b.[ParcelID]
    AND a.[UniqueID] <> b.[UniqueID]
WHERE a.[PropertyAddress] IS NULL;



--Breaking out address into individual column (address, city, state)

SELECT [PropertyAddress],[OwnerAddress]
FROM [dbo].[NashvilleHousing]
-- WHERE [PropertyAddress] IS NULL
-- ORDER BY [ParcelID]

IF NOT EXISTS (
    SELECT 1 
    FROM sys.columns
    WHERE object_id = OBJECT_ID('[dbo].[NashvilleHousing]') 
    AND name = 'PropertySplitAddress'
)
BEGIN
    ALTER TABLE [dbo].[NashvilleHousing]
    ADD PropertySplitAddress NVARCHAR(255);
END;


IF NOT EXISTS (
    SELECT 1 
    FROM sys.columns 
    WHERE object_id = OBJECT_ID('[dbo].[NashvilleHousing]') 
    AND name = 'PropertySplitCity'
)
BEGIN
    ALTER TABLE [dbo].[NashvilleHousing]
    ADD PropertySplitCity NVARCHAR(255);
END;

UPDATE [dbo].[NashvilleHousing]
SET 
    PropertySplitAddress = SUBSTRING([OwnerAddress], 1, CHARINDEX(',', [OwnerAddress]) - 1),
    PropertySplitCity = SUBSTRING([OwnerAddress], CHARINDEX(',', [OwnerAddress]) + 1, LEN([PropertyAddress]))
WHERE CHARINDEX(',', [OwnerAddress]) > 0;


SELECT 
    [OwnerAddress],
    SUBSTRING([OwnerAddress], 1, CHARINDEX(',', [OwnerAddress]) - 1) AS StreetAddress,
    SUBSTRING([OwnerAddress], CHARINDEX(',', [OwnerAddress]) + 1, LEN([PropertyAddress])) AS City,
    [PropertySplitAddress],
    [PropertySplitCity]
FROM [dbo].[NashvilleHousing]
WHERE CHARINDEX(',', [PropertyAddress]) > 0;


-- CHANGING Y AND N TO YES AND NO AND NO TO SOLD AS VACANT  

SELECT DISTINCT [SoldAsVacant]
FROM [dbo].[NashvilleHousing]
GROUP BY [SoldAsVacant] 
--ORDER BY 

SELECT  [SoldAsVacant],
CASE WHEN [SoldAsVacant] = 'Y' THEN 'YES'
     WHEN [SoldAsVacant] = 'N' THEN 'NO'
     WHEN [SoldAsVacant] = 'Yes' THEN 'YES'
        WHEN [SoldAsVacant] = 'No' THEN 'Sold as vacant'
     ELSE [SoldAsVacant]
     END
FROM [dbo].[NashvilleHousing]


UPDATE [dbo].[NashvilleHousing]
SET [SoldAsVacant]= CASE WHEN [SoldAsVacant] = 'Y' THEN 'YES'
     WHEN [SoldAsVacant] = 'N' THEN 'NO'
     WHEN [SoldAsVacant] = 'Yes' THEN 'YES'
        WHEN [SoldAsVacant] = 'No' THEN 'Sold as vacant'
     ELSE [SoldAsVacant]
     END

     SELECT *
     FROM [dbo].[NashvilleHousing]

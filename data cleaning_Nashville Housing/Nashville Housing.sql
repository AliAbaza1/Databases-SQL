/*

cleaning data in sql 

*/


select *
from [Nashville Housing].dbo.[Nashville Housing]


--Standarize date format


select SaleDateconverted,CONVERT(Date,SaleDate)
from [Nashville Housing].dbo.[Nashville Housing]


Update [Nashville Housing] 
SET SaleDate =CONVERT(Date,SaleDate)  -- convert this column to SaleDateconverted 


ALTER TABLE [Nashville Housing]
Add SaleDateconverted Date


Update [Nashville Housing] 
SET SaleDateconverted =CONVERT(Date,SaleDate) 


--Populate Property Address date 


select *
from [Nashville Housing].dbo.[Nashville Housing]
--where PropertyAddress is null 
order by ParcelID


--fill null by using a parcel id as reference point


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Nashville Housing].dbo.[Nashville Housing] a
join [Nashville Housing].dbo.[Nashville Housing] b
     on  a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null 


--Ubdate the column


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Nashville Housing].dbo.[Nashville Housing] a
join [Nashville Housing].dbo.[Nashville Housing] b
     on  a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
	 where a.PropertyAddress is null 


--Breakin out PropertyAddress into Individual columns (Address, city, State)


select PropertyAddress
from [Nashville Housing].dbo.[Nashville Housing]


select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) AS Address 
,SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) AS Address

from [Nashville Housing].dbo.[Nashville Housing]


ALTER TABLE [Nashville Housing]
Add PropertySplitAddress nvarchar(255)


Update [Nashville Housing] 
SET PropertySplitAddress =SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) 


ALTER TABLE [Nashville Housing]
Add PropertySplitACity nvarchar(255)


Update [Nashville Housing] 
SET PropertySplitACity = SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))


select *
from [Nashville Housing].dbo.[Nashville Housing]


--Breakin out OwnerAddress into Individual columns (Address, city, State)


select OwnerAddress
from [Nashville Housing].dbo.[Nashville Housing]


select 
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

from [Nashville Housing].dbo.[Nashville Housing]


ALTER TABLE [Nashville Housing]
Add OwnerSplitAddress nvarchar(255)


Update [Nashville Housing] 
SET OwnerSplitAddress =PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE [Nashville Housing]
Add OwnerSplitCity nvarchar(255)


Update [Nashville Housing] 
SET OwnerSplitCity =PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE [Nashville Housing]
Add OwnerSplitState nvarchar(255)


Update [Nashville Housing] 
SET OwnerSplitState =PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1) 


select *
from [Nashville Housing].dbo.[Nashville Housing]



--change Y and N to YES and NO in "Sold as Vacant" field


select distinct(SoldAsVacant), count(SoldAsVacant)
from [Nashville Housing].dbo.[Nashville Housing]
Group by SoldAsVacant


select SoldAsVacant
,CASE when SoldAsVacant = 'Y' THEN 'Yes'
 when SoldAsVacant = 'N' THEN 'No'
 else SoldAsVacant
 end
from [Nashville Housing].dbo.[Nashville Housing]

Update [Nashville Housing] 
SET SoldAsVacant =CASE when SoldAsVacant = 'Y' THEN 'Yes'
 when SoldAsVacant = 'N' THEN 'No'
 else SoldAsVacant
 end


 --Remove Duplicates 


 WITH RowNowCTE AS(
 select * ,
    ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY 
				    UniqueID)row_num

 from [Nashville Housing].dbo.[Nashville Housing]
 )
 select*
 from RowNowCTE
 where row_num > 1
 order by PropertyAddress


 

 


 














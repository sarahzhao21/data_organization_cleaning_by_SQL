select *
from nashville_housing_csv 

--convert the datatype of saledate varchar to date 
update nashville_housing_csv
set saledate = cast(saledate as date)

--convert the datetype of saledate to timestamp
select saledate::timestamp as sale_time
from nashville_housing_csv

--extract different time units from saledate
SELECT saledate,
       EXTRACT('year'   FROM saledate::timestamp) AS year,
       EXTRACT('month'  FROM saledate::timestamp) AS month,
       EXTRACT('day'    FROM saledate::timestamp) AS day,
       EXTRACT('hour'   FROM saledate::timestamp) AS hour,
       EXTRACT('minute' FROM saledate::timestamp) AS minute,
       EXTRACT('second' FROM saledate::timestamp) AS second,
       EXTRACT('decade' FROM saledate::timestamp) AS decade,
       EXTRACT('dow'    FROM saledate::timestamp) AS day_of_week
  FROM nashville_housing_csv

--round the saledate to different levels of precision
SELECT saledate,
       DATE_TRUNC('year'   , saledate::timestamp) AS year,
       DATE_TRUNC('month'  , saledate::timestamp) AS month,
       DATE_TRUNC('week'   , saledate::timestamp) AS week,
       DATE_TRUNC('day'    , saledate::timestamp) AS day,
       DATE_TRUNC('hour'   , saledate::timestamp) AS hour,
       DATE_TRUNC('minute' , saledate::timestamp) AS minute,
       DATE_TRUNC('second' , saledate::timestamp) AS second,
       DATE_TRUNC('decade' , saledate::timestamp) AS decade
  FROM nashville_housing_csv
  
--calculate time interval from CURRENT_DATE
alter table nashville_housing_csv
add current_date1 date default current_date

SELECT saledate, current_date1-saledate::date as time_interval_days, current_date1::timestamp-saledate::timestamp as time_interval
from nashville_housing_csv
  
--Polulaty Porperty Address Data clean
---check the occurence of null values
select count(propertyaddress)
from nashville_housing_csv 
where propertyaddress is null

---Repopulate the Porperty Address with null values 
select a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress, COALESCE(a.propertyaddress, b.propertyaddress) as propertyaddress_new
from nashville_housing_csv a
join nashville_housing_csv b
on a.parcelid = b.parcelid
and a."UniqueID " <> b."UniqueID " 
where a.propertyaddress is null 

--extract part of a string from owneraddress
select owneraddress, right(owneraddress, 2) as state
from nashville_housing_csv

--rebuilt the owners' names by case and concatenate. 
--- If the ownername represents a company (include 'LLC"), the ownername will be be changed
--- If the ownername include two first names with one last name, the ownername will be rebuilt to 1st first name + last name + & + 2nd first name + last name
--- If the ownername include one name, it will be rebuilt to first name + last name
--- I think I covered most of the cases but there might be some exceptions
select ownername
from nashville_housing_csv

select ownername,
case when ownername like '%LLC%' then ownername
when ownername ilike '%&%' then split_part(left(ownername, strpos(ownername, '&')-2),',',2)||' '||split_part(ownername,',',1)||' & '||right(ownername, length(ownername)-strpos(ownername, '&')-1)||' '||split_part(ownername,',',1)
else split_part(ownername,',',2)||' '||split_part(ownername,',',1)
end as ownername_new
from nashville_housing_csv

--splite the property address into two columns by ','
select propertyaddress, substr(propertyaddress, 1, strpos(propertyaddress, ',')-1) as property_address1,
substr(propertyaddress, strpos(propertyaddress, ',')+1, length(propertyaddress)-strpos(propertyaddress, ',')) as property_address2
from nashville_housing_csv 

-- add a new column to the table 
alter table nashville_housing_csv
add property_address_1 varchar(50)

alter table nashville_housing_csv
add property_address_2 varchar(50)

--update the new column
update nashville_housing_csv
set property_address_1 = substr(propertyaddress, 1, length(propertyaddress))
where propertyaddress is not null

-- OwnerAddress, split strings by delimiter
select owneraddress,
split_part(owneraddress, ',',1) as owner_street,
split_part(owneraddress, ',',2) as owner_city,
split_part(owneraddress, ',',3) as owner_state
from nashville_housing_csv

--use case to convert Y and N to Yes and Not in soldasvacant
select distinct(soldasvacant), count(soldasvacant)
from nashville_housing_csv
group by soldasvacant
order by 2

select soldasvacant,
case when soldasvacant = 'Y' then 'Yes'
     when soldasvacant = 'N' then 'No'
     else soldasvacant end as soldasvacant_new
from nashville_housing_csv


--check if there are duplicate rows by self-join
with rownumCTE as (
select *,
row_number() over(
partition by parcelid,
propertyaddress,
saleprice,
saledate,
legalreference
order by "UniqueID ") row_number 
from nashville_housing_csv
)
select *
from rownumCTE
where row_number >1

---or 
select * from (
select *,
row_number() over(
partition by parcelid,
propertyaddress,
saleprice,
saledate,
legalreference
order by "UniqueID ") row_number 
from nashville_housing_csv)sub
where sub.row_number >1

--delete duplicate rows, refer to(https://www.postgresqltutorial.com/how-to-delete-duplicate-rows-in-postgresql/)
delete from nashville_housing_csv
where "UniqueID " in (
select "UniqueID " from (
select *,
row_number() over(
partition by parcelid,
propertyaddress,
saleprice,
saledate,
legalreference
order by "UniqueID ") row_number 
from nashville_housing_csv)sub
where sub.row_number >1)


-- Delete useless columns
alter table nashville_housing_csv
drop column property_address1

alter table nashville_housing_csv
drop column property_address2

alter table nashville_housing_csv
drop column property_address_2

select * 
from nashville_housing_csv















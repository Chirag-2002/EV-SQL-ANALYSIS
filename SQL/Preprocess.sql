/* PROBLEM STATEMENT : 
AtliQ Motors is an automotive giant from the USA specializing in electric vehicles (EV). 
In the last 5 years, their market share rose to 25% in electric and hybrid vehicles segment in North America. 
As a part of their expansion plans, they wanted to launch their bestselling models in India where their market 
share is less than 2%. Bruce Haryali, the chief of AtliQ Motors India wanted to do a detailed market study of 
existing EV/Hybrid market in India before proceeding further. 
Bruce gave this task to the data analytics team of AtliQ motors and Peter Pandey is the data analyst working 
in this team.
*/
# -----------------------------------------------------------------------------------------------------

-- Creating Database 
CREATE Database automotive_company_data;
-- Selecting the database
USE automotive_company_data;
-- Checking whether all data is correctly load or not 
SELECT count(*) FROM dim_date;
SELECT count(*) FROM electric_vehicle_sales_by_makers;
SELECT count(*) FROM electric_vehicle_sales_by_state;

# -----------------------------------------------------------------------------------

-- Let's Start with the preprocess 
/* 1) Checking the type of each column 
2) Checking null values 
3) Checking for duplicates 
4) Checking for inconsistent Data
*/

# Let's start with first table i.e, dim_date
SELECT * FROM dim_date;
# 1) First we will change the name of the column ï»¿date to date
ALTER TABLE dim_date RENAME COLUMN `ï»¿date` To `date`;
SELECT * FROM dim_date;

# 2)  Now check the details about columns
DESCRIBE dim_date;
# changing the type if data from text to date 
ALTER TABLE dim_date MODIFY date DATE ; # Can't modify because date is 01-Apr-yy format but SQL understands yyyy-mm-dd
ALTER TABLE dim_date ADD column date_clean DATE; # Adding new column
SET SQL_SAFE_UPDATES = 0; # before updating always set safe updates to 0 
UPDATE dim_date 
SET date_clean = STR_TO_DATE(`date`,'%d-%b-%y'); # Changing the format 
SELECT * FROM dim_date;
# droping the old column
ALTER TABLE dim_date DROP column date;
DESCRIBE dim_date;

# 3) Now we will check the null values 
SELECT count(*) FROM dim_date
WHERE fiscal_year IS NOT NULL;
SELECT count(*) FROM dim_date
WHERE quarter IS NULL ;
SELECT count(*) FROM dim_date
WHERE date_clean IS NULL ;

# 4) Now check the inconsistent data
SELECT * FROM dim_date; # ALL clear 

# Now start with second table i.e, electric_vehicle_sales_by_makers
# 1) Checking the column names 
SELECT * FROM electric_vehicle_sales_by_makers;
ALTER TABLE electric_vehicle_sales_by_makers RENAME COLUMN `ï»¿date` To `date`;
SELECT * FROM electric_vehicle_sales_by_makers;

# 2) Now checking the types
DESCRIBE electric_vehicle_sales_by_makers;
UPDATE electric_vehicle_sales_by_makers
SET date = STR_TO_DATE(`date`, '%d-%b-%y');
ALTER TABLE electric_vehicle_sales_by_makers MODIFY date DATE;
DESCRIBE electric_vehicle_sales_by_makers;

# 3) Checking the null values 
# First Ways to check
SELECT count(*) FROM electric_vehicle_sales_by_makers
WHERE date IS NULL OR vehicle_category IS NULL OR maker IS NULL OR electric_vehicles_sold IS NULL; 
# Second ways to check
SELECT 
SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) AS date_null ,
SUM(CASE WHEN vehicle_category IS NULL THEN 1 ELSE 0 END) AS vehicle_cat_null,
SUM(CASE WHEN maker IS NULL THEN 1 ELSE 0 END) AS maker_null,
SUM(CASE WHEN electric_vehicles_sold IS NULL THEN 1 ELSE 0 END) AS electric_veh_sold_null
FROM electric_vehicle_sales_by_makers;

# 4) Checking inconsistent data
SELECT count(*) , maker
FROM electric_vehicle_sales_by_makers
GROUP BY maker;

# Let's with the last table i.e, electric_vehicle_sales_by_state
SELECT * FROM electric_vehicle_sales_by_state;

# 1) Checking the name of columns 
ALTER TABLE electric_vehicle_sales_by_state RENAME COLUMN `ï»¿date` TO `date`;
SELECT * FROM electric_vehicle_sales_by_state;

# 2) Checking the type of columns
DESCRIBE electric_vehicle_sales_by_state;
UPDATE electric_vehicle_sales_by_state
SET date = str_to_date(`date`,'%d-%b-%y');
ALTER TABLE electric_vehicle_sales_by_state MODIFY date DATE;
DESCRIBE electric_vehicle_sales_by_state;

# 3) Checking the null values 
SELECT 
SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) AS date_null,
SUM(CASE WHEN state IS NULL THEN 1 ELSE 0 END) AS state_null,
SUM(CASE WHEN vehicle_category IS NULL THEN 1 ELSE 0 END) AS vehicle_cat_null,
SUM(CASE WHEN electric_vehicles_sold IS NULL THEN 1 ELSE 0 END) AS electric_veh_sold_null , 
SUM(CASE WHEN total_vehicles_sold IS NULL THEN 1 ELSE 0 END) AS total_veh_sold_null
FROM electric_vehicle_sales_by_state;

# 4) Checking for inconsistent data
SELECT count(*) , vehicle_category FROM electric_vehicle_sales_by_state
GROUP BY vehicle_category;


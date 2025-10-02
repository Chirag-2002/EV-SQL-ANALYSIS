USE automotive_company_data;
SET SQL_SAFE_UPDATES = 0;
UPDATE electric_vehicle_sales_by_state
SET state = 'Andaman & Nicobar Island'
WHERE state IN ('Andaman & Nicobar', 'Andaman & Nicobar Islands');

# Preliminary Research
/* 1. List the top 3 and bottom 3 makers for the fiscal years 2023 and 2024 in terms of the number of 2-wheelers 
sold. */
# Bottom 3 makers
CREATE OR REPLACE VIEW bottom_3_makers AS 
SELECT m.maker , m.electric_vehicles_sold , d.fiscal_year FROM electric_vehicle_sales_by_makers as m 
JOIN dim_date as d ON m.date = d.date_clean
WHERE fiscal_year IN (2023 , 2024) AND vehicle_category = '2-Wheelers'
ORDER BY electric_vehicles_sold
LIMIT 3;

# TOP 3 makers
CREATE OR REPLACE VIEW top_3_makers AS 
SELECT m.maker , m.electric_vehicles_sold , d.fiscal_year FROM electric_vehicle_sales_by_makers as m 
JOIN dim_date as d ON m.date = d.date_clean
WHERE fiscal_year IN (2023 , 2024) AND vehicle_category = '2-Wheelers'
ORDER BY electric_vehicles_sold DESC
LIMIT 3 ;

#-----------------------------------------------------------------------------------
/* 2) Identify the top 5 states with the highest penetration rate in 2-wheeler and 4-wheelers EV sales in FY 2024 */
/* To begin with above analysis first calculate the penetration rate 
Penetration Rate =  (Electric Vehicles Sold / Total Vehicles Sold) * 100  */

CREATE OR REPLACE VIEW penetration_rate AS 
WITH penetration AS (SELECT s.state , s.vehicle_category , (SUM(s.electric_vehicles_sold)/SUM(s.total_vehicles_sold)*100) as penetration_rate 
FROM electric_vehicle_sales_by_state AS s
JOIN dim_date AS d ON d.date_clean = s.date
WHERE fiscal_year = 2024 AND vehicle_category IN ('2-Wheelers' , '4-Wheelers')
GROUP BY state , vehicle_category) 
,
ranked AS (SELECT * ,
ROW_NUMBER() OVER (PARTITION BY vehicle_category ORDER BY penetration_rate DESC) AS rnk
FROM penetration)

SELECT * FROM ranked 
WHERE rnk<=5;
# -----------------------------------------------------------------------------------
/* 3) List the states with negative penetration (decline) in EV sales from 2022 to 2024 ? */ 

CREATE OR REPLACE VIEW negative_penetration_rate AS 
WITH penetration AS (SELECT s.state , s.vehicle_category , d.fiscal_year , (SUM(electric_vehicles_sold)/SUM(total_vehicles_sold)*100)
AS penetration_rate FROM electric_vehicle_sales_by_state AS s
JOIN dim_date AS D 
ON d.date_clean = s.date 
WHERE fiscal_year BETWEEN 2022 AND 2024 
GROUP BY state , vehicle_category , fiscal_year) ,

Previous_Penetration AS ( SELECT * , 
LAG(penetration_rate) OVER ( PARTITION BY state , vehicle_category ORDER BY vehicle_category DESC , fiscal_year) AS prev_penetration
FROM penetration
ORDER BY vehicle_category , state , fiscal_year) ,

Percentage_Change AS (SELECT * , ((penetration_rate - prev_penetration)/prev_penetration) *100  as percentage_change 
FROM Previous_Penetration)

SELECT * FROM Percentage_Change
WHERE percentage_change<0;

# --------------------------------------------------------------------------------------------------------------
/* 4)What are the quarterly trends based on sales volume for the top 5 EV makers (4-wheelers) 
from 2022 to 2024? */

CREATE OR REPLACE VIEW quarterly_trend_top_5_maker AS 
WITH quarterly_sales AS (SELECT m.maker , SUM(m.electric_vehicles_sold) as Sales , d.quarter
, d.fiscal_year
FROM electric_vehicle_sales_by_makers AS m 
JOIN dim_date AS d ON d.date_clean = m.date 
WHERE fiscal_year BETWEEN 2022 AND 2024 AND vehicle_category = '4-Wheelers'
GROUP BY maker , quarter , fiscal_year) , 

ranked AS (SELECT * , 
ROW_NUMBER() OVER (PARTITION BY maker , quarter , fiscal_year) as rnk
FROM quarterly_sales
ORDER BY SALES DESC)

SELECT * FROM ranked
LIMIT 5;

# --------------------------------------------------------------------------------------------
/* 5) How do the EV sales and penetration rates in Delhi compare to Karnataka for 2024? */

CREATE OR REPLACE VIEW penetration_rate_Delhi_comp_karnataka AS 
SELECT state , SUM(electric_vehicles_sold) , (SUM(electric_vehicles_sold)/SUM(total_vehicles_sold)*100) AS
penetration_rate FROM electric_vehicle_sales_by_state
GROUP BY state 
HAVING state IN ( "Delhi" , "Karnataka");

#-------------------------------------------------------------------------------------------------------
/* 6. List down the compounded annual growth rate (CAGR) in 4-wheeler units for the top 5 makers from 2022 to 2024. */

CREATE OR REPLACE VIEW Top_5_maker_CAGR AS 
WITH firstvalue AS (SELECT m.maker , SUM(m.electric_vehicles_sold) as total_sales_2022 FROM electric_vehicle_sales_by_makers AS m
JOIN dim_date AS d ON d.date_clean = m.date 
WHERE fiscal_year = 2022 and vehicle_category = '4-Wheelers'
GROUP BY maker),

lastvalue AS (Select m.maker ,  SUM(m.electric_vehicles_sold) AS total_sales_2024 FROM electric_vehicle_sales_by_makers AS m 
JOIN dim_date AS d ON d.date_clean = m.date 
WHERE fiscal_year = 2024 AND vehicle_category = '4-Wheelers'
GROUP BY maker)

SELECT r22.maker , r22.total_sales_2022 , r24.total_sales_2024 , (POWER(r24.total_sales_2024/NULLIF(r22.total_sales_2022,0) , 1.0/2)-1)*100 AS CAGR
FROM firstvalue AS r22
 JOIN lastvalue AS r24 ON r22.maker = r24.maker
ORDER BY CAGR DESC
LIMIT 5;
#---------------------------------------------------------------------------------------------------------------
/* 7. List down the top 10 states that had the highest compounded annual growth rate (CAGR) 
from 2022 to 2024 in total vehicles sold. */

CREATE OR REPLACE VIEW TOP_10_states_CAGR AS 
WITH firstvalue AS (SELECT s.state , SUM(s.total_vehicles_sold) as total_sales_2022 FROM electric_vehicle_sales_by_state AS s
JOIN dim_date AS d ON d.date_clean = s.date 
WHERE fiscal_year = 2022 
GROUP BY state),

lastvalue AS (Select s.state ,  SUM(s.total_vehicles_sold) AS total_sales_2024 FROM electric_vehicle_sales_by_state AS s
JOIN dim_date AS d ON d.date_clean = s.date 
WHERE fiscal_year = 2024
GROUP BY state)

SELECT r22.state , r22.total_sales_2022 , r24.total_sales_2024 , (POWER(r24.total_sales_2024/NULLIF(r22.total_sales_2022,0) , 1.0/2)-1)*100 AS CAGR
FROM firstvalue AS r22
 JOIN lastvalue AS r24 ON r22.state = r24.state
ORDER BY CAGR DESC
LIMIT 10;




#----------------------------------------------------------------------------------------------------------------
/* 8. What are the peak and low season months for EV sales based on the data from 2022 to 2024? */

CREATE OR REPLACE VIEW peak_low_season AS 
SELECT MONTHNAME(m.date) as peak_month , SUM(m.electric_vehicles_sold) as EV_Sales FROM electric_vehicle_sales_by_makers as m 
JOIN dim_date as d ON m.date = d.date_clean WHERE fiscal_year BETWEEN 2022 AND 2024 
GROUP BY MONTH(m.date) , MONTHNAME(m.date)
ORDER BY EV_Sales DESC ;

#-------------------------------------------------------------------------------------------------------------------------
/* 10. Estimate the revenue growth rate of 4-wheeler and 2-wheelers EVs in India for 2022 vs 2024 and 2023 vs 2024, 
assuming an average unit price. 
# For Two wheelers 

CREATE OR REPLACE VIEW rev_growth_2w AS 
With revenvue_2_Wheelers AS (SELECT SUM(85000*m.electric_vehicles_sold) as revenvue_2022
FROM electric_vehicle_sales_by_state as m 
JOIN dim_date as d ON d.date_clean = m.date
WHERE fiscal_year = 2022 and vehicle_category = '2-Wheelers') ,

revenue_2_wheelers_2024 AS (SELECT SUM(85000*m.electric_vehicles_sold) as revenvue_2024 
FROM electric_vehicle_sales_by_state as m
JOIN dim_date as d ON d.date_clean = m.date
WHERE fiscal_year = 2024 and vehicle_category = '2-Wheelers'),

revenue_2_wheelers_2023 AS (SELECT SUM(85000*m.electric_vehicles_sold) as revenvue_2023
FROM electric_vehicle_sales_by_state as m
JOIN dim_date as d ON d.date_clean = m.date 
WHERE fiscal_year = 2023 AND vehicle_category = '2-Wheelers') ,

Select r23.revenvue_2023 , r24.revenvue_2024 , r22.revenvue_2022 ,
((r24.revenvue_2024 - r22.revenvue_2022)*1.0/r22.revenvue_2022)*100 AS growth_percent_22vs24,
((r24.revenvue_2024 - r23.revenvue_2023)*1.0/r23.revenvue_2023)*100 AS growth_percent_23vs_24 
FROM revenvue_2_Wheelers AS r22
CROSS JOIN revenue_2_wheelers_2023 AS r23
CROSS JOIN revenue_2_wheelers_2024 AS r24 ;

--- For 4 wheelers 

CREATE OR REPLACE VIEW rev_growth_4w
With revenue_4_wheelers_22 AS (SELECT SUM(1500000 * m.electric_vehicles_sold) AS rev_2022
FROM electric_vehicle_sales_by_state AS m
JOIN dim_date AS d ON d.date_clean = m.date
WHERE fiscal_year = 2022 AND vehicle_category = '4-Wheelers'),

revenue_4_wheelers_23 AS (SELECT SUM(1500000 * m.electric_vehicles_sold) AS rev_2023
FROM electric_vehicle_sales_by_state AS m
JOIN  dim_date AS d ON d.date_clean = m.date
WHERE fiscal_year = 2023 AND vehicle_category = '4-Wheelers'),

revenue_4_wheelers_24 AS (SELECT SUM(1500000 * m.electric_vehicles_sold) AS rev_2024
FROM electric_vehicle_sales_by_state AS m
JOIN dim_date AS d ON d.date_clean = m.date
WHERE fiscal_year = 2024 AND vehicle_category = '4-Wheelers')

SELECT r22.rev_2022 , r23.rev_2023 , r24.rev_2024 , 
((r24.rev_2024-r22.rev_2022)*1.0/r22.rev_2022)*100 AS rev_growth_22vs24 , 
((r24.rev_2024 - r23.rev_2023)*1.0/r23.rev_2023)*100 AS rev_growth_23vs24 
FROM revenue_4_wheelers_22 AS r22
CROSS JOIN revenue_4_wheelers_23 AS r23 
CROSS JOIN revenue_4_wheelers_24 AS r24;




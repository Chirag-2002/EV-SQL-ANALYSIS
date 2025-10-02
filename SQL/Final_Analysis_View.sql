USE automotive_company_data;
# Preliminary Research
/* 1. List the top 3 and bottom 3 makers for the fiscal years 2023 and 2024 in terms of the number of 2-wheelers 
sold. */

# Bottom 3 
SELECT * FROM bottom_3_makers;
# TOP 3 
SELECT * FROM top_3_makers;

/* 2) Identify the top 5 states with the highest penetration rate in 2-wheeler and 4-wheelers EV sales in FY 2024 */
/* To begin with above analysis first calculate the penetration rate 
Penetration Rate =  (Electric Vehicles Sold / Total Vehicles Sold) * 100  */

SELECT * FROM penetration_rate;

/* 3) List the states with negative penetration (decline) in EV sales from 2022 to 2024 ? */ 

SELECT * FROM negative_penetration_rate;

/* 4)What are the quarterly trends based on sales volume for the top 5 EV makers (4-wheelers) 
from 2022 to 2024? */

SELECT * FROM quarterly_trend_top_5_maker;

/* 5) How do the EV sales and penetration rates in Delhi compare to Karnataka for 2024? */

SELECT * FROM penetration_rate_Delhi_comp_karnataka ;

/* 6. List down the compounded annual growth rate (CAGR) in 4-wheeler units for the top 5 makers from 2022 to 2024. */

SELECT * FROM Top_5_maker_CAGR;

/* 7. List down the top 10 states that had the highest compounded annual growth rate (CAGR) 
from 2022 to 2024 in total vehicles sold. */

SELECT * FROM TOP_10_states_CAGR ;

/* 8. What are the peak and low season months for EV sales based on the data from 2022 to 2024? */

SELECT * FROM peak_low_season;

/* 10. Estimate the revenue growth rate of 4-wheeler and 2-wheelers EVs in India for 2022 vs 2024 and 2023 vs 2024, 
assuming an average unit price. */

# 2-Wheelers
SELECT * FROM rev_growth_2w;
# 4-Wheelers 
SELECT * FROM rev_growth_4w;
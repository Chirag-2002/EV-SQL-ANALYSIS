# 🚗 Electric Vehicle Sales Analysis (SQL Project)

## 📖 Overview
AtliQ Motors is an automotive giant from the USA specializing in electric vehicles (EV). 
In the last 5 years, their market share rose to 25% in electric and hybrid vehicles segment in North America. 
As a part of their expansion plans, they wanted to launch their bestselling models in India where their market 
share is less than 2%. Bruce Haryali, the chief of AtliQ Motors India wanted to do a detailed market study of 
existing EV/Hybrid market in India before proceeding further. 
Bruce gave this task to the data analytics team of AtliQ motors and Peter Pandey is the data analyst working 
in this team.

## 🛠️ Dataset
Tables used:

electric_vehicle_sales_by_makers → EV sales by manufacturer
electric_vehicle_sales_by_state → EV sales by state
dim_date → date dimension with fiscal year mapping

Time Period Covered: 2022–2024

# 🔍 Key Analysis Performed
1) Revenue Growth
Computed revenue growth for 2022 vs 2024 and 2023 vs 2024.
Used views to simplify repeated calculations.

2) CAGR (Compound Annual Growth Rate)
Calculated CAGR of EV sales between 2022 and 2024 at both:
Overall vehicle category level (2W & 4W)
Manufacturer (maker) level

3)Top & Bottom Makers
Identified top 5 EV makers (highest sales in 2024).
Identified bottom 3 EV makers (lowest sales in 2024).

4) Reusable SQL Views
Created views like revenue_growth_4w, bottom_3_makers, cagr_by_maker for quick queries

## 📈 Key Insights

##  1. List the top 3 and bottom 3 makers for the fiscal years 2023 and 2024 in terms of the number of 2-wheelers 
## sold. 

<img width="300" height="118" alt="image" src="https://github.com/user-attachments/assets/fb1684ca-547d-4feb-be00-f0936ef80895" />
----> Bottom 3 makers are BATTRE ELECTRIC , JITENDRA and KINETIC GREEN .
The below will be possible reason for being lowest 
1) Price are high
2) Giving poor mileage
3) Bad quality in terms of design , speed , not much feature , etc

<img width="281" height="141" alt="image" src="https://github.com/user-attachments/assets/52f207a9-e162-4471-b770-fb3208c4a5bd" />
----> Top 3 makers are OLA ELECTRIC , TVS , ATHER .
The below will be the possible reason for being highest
1) Price are low
2) Giving high mileage
3) Quality is good in terms of design , speed is good , etc

##  2) Identify the top 5 states with the highest penetration rate in 2-wheeler and 4-wheelers EV sales in FY 2024 */
## To begin with above analysis first calculate the penetration rate 
## Penetration Rate =  (Electric Vehicles Sold / Total Vehicles Sold) * 100  */
## Meaning of penetration rate : The penetration rate is a metric that shows how much a product, service, or category is adopted within a target market.

<img width="404" height="149" alt="image" src="https://github.com/user-attachments/assets/77ef6ebb-2f64-491f-9ba2-be0dd3569d57" />
----> The states which adopting 2-wheelers more is : Goa , Kerala , Karnataka , Maharashtra , Delhi. 
This above states are adopting EV in 2-wheelers more because of price.
----> The states which adopting 4-wheelers more is : Kerala , Chandigarh , Delhi , Karnataka , Goa 
This above states are adopting EV in 4-wheelers more because this state will be high-valued means people are likely to give more prices in 4-wheelers .

## 3) List the states with negative penetration (decline) in EV sales from 2022 to 2024 ? 

<img width="627" height="143" alt="image" src="https://github.com/user-attachments/assets/b9eed8e6-dcd4-4909-ac15-6df9a853ce7a" />
As you can see in the above images this are states which have negative penetration rate compare to previour fiscal year 
because of price are increase , less charging point cable , less efficient . 

##  4)What are the quarterly trends based on sales volume for the top 5 EV makers (4-wheelers) 
from 2022 to 2024? 
<img width="349" height="142" alt="image" src="https://github.com/user-attachments/assets/09d64b2d-f7b5-428b-ac88-d2daeebaf744" />
The above maker are performing well in very quarter from that TATA MOTORS is performing consistent from Q2 and rest of the makers are Mahindra & Mahindra which 
performed well is Q1 

##  5) How do the EV sales and penetration rates in Delhi compare to Karnataka for 2024? 

<img width="538" height="117" alt="image" src="https://github.com/user-attachments/assets/074625f3-cef1-4b0b-bbb8-25101ce7b6be" />

----> As compare to delhi , karnataka penetration rate is higher means karnataka states are promoting or adopting EV more because of 
they have to reduced pollution , make a state free from global warming , etc. 








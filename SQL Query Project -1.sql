
## DATA CLEANING

use project_1;
select * from retail_sales;
select * from retail_sales
where category is null;

select * from retail_sales
where transactions_id is null 
or 
sale_date is null
or sale_time is null
or customer_id is null 
or gender is null 
or age is null
or category is null
or quantiy is null
or price_per_unit is null 
or cogs is null 
or total_sale is null;



select * from retail_sales
where transactions_id =""
or sale_date=""
or sale_time =""
or customer_id =""
or gender =""
or age =""
or category = ""
or quantiy =""
or price_per_unit =""
or cogs =""
or total_sale="";

select * from retail_sales
order by age asc;

select * from retail_sales
order by total_sale desc;

select count(*) from retail_sales;


## DATA EXPLORATION

-- How many sales we have 

select * from retail_sales;
select count(transactions_id) as total_sale
from retail_sales;

-- How many customers  we have 

select count(customer_id) total_customer
from retail_sales;

-- How many unique customer we have 

select count(distinct(customer_id)) as total_customer 
from retail_sales;

-- How many categories we have 
select distinct(category) 
from retail_sales;


## Data analysis & Business key problems and Answers
-- Q.1  Write a sql query to retrieve all columns for sales made on '2022-11-05'.

select * 
from retail_sales
where sale_date = "2022-11-05";


-- Q.2  Write a sql query to retrieve all trnasactions where the category is clothing and the quantity 
--          sold is more than 10 in the month of Nov-22.

select * 
from retail_sales
where category = "Clothing";

select * 
from( 
select * 
from retail_sales
where sale_date = "2022-11-05") t
where category ="Clothing" and quantiy>=4;

select * 
from retail_sales 
where category="Clothing" 
and quantiy >=4
and date_format(sale_date,"%Y-%m") = "2022-11";

-- Q.3  Write a sql query to calculate the total sale(total_sales) for each category.

select category, sum(total_sale) as total_sale
from retail_sales
group by 1
;

-- Q.4  Write a query to find the average age of customers who purchased item from the Beauty Category.

select round(avg(age),2) as avg_age
from retail_sales
where category="Beauty";

-- Q.5  Write a sql query to find all transaction where the total_sale is greater than 1000.

select * 
from retail_sales
where total_sale>1000;

-- Q.6  Write a Sql query to find the total number of transactions (transaction_id) made by each gender in each category.

select category, gender, count(*) as total_trans
from retail_sales
group by 1,2
order by 1;

-- Q.7  Write a sql query to calculate the  average sale for each month. Find out best selling month in each year.

select *  
from (
select  year(sale_date) as year,
date_format(sale_date,"%M") month, 
round(avg(total_sale)) as avg_sale,
rank() over(partition by year(sale_date)order by round(avg(total_sale)) desc) as ranked
from retail_sales
group by 1,2
) t
where ranked=1;

-- Q.8  Write a sql query to find the top 5 customers based on the highest total sales.

Select customer_id, sum(total_sale) as total_sale 
from retail_sales
group by 1
order by 2 desc
limit 5 ;

-- Q.9  Write a sql query to find the number of unique customers who purchased the items for each category.

Select category,
		count(distinct customer_id) as count
from retail_sales
group by 1
order by 2 desc;

-- Q.10  Write a sql query to create each shift and number of orders ( example - Morning <=12, Afternoon between 12 ti 17, evening >17)

select 
case when hour(sale_time) < 12 then "Morning"
	 when hour(sale_time) between 12 and 19 then "After-noon"
     else "Evening"
    end as Shift_time ,
orders
    from (
Select sale_time,
count(*) as orders
from retail_sales
group by 1) t
group by 1;

Select sale_time,
count(transactions_id) as orders,
case when hour(sale_time) < 12 then "Morning"
	When hour(sale_time) between 12 and 19 then "After-noon"
    else "Evening" 
    end as Shift_time
from retail_sales
group by 1;



select shift_time, count(orders) as total_order from 
(Select sale_time,
count(transactions_id) as orders,
case when hour(sale_time) < 12 then "Morning"
	When hour(sale_time) between 12 and 19 then "After-noon"
    else "Evening" 
    end as Shift_time
from retail_sales
group by 1) t
group by 1;
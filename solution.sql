-- Data Cleaning

desc sales;
-- here the transaction_date and transaction_time is in text so we need to convert it to date format

update sales set transaction_date = str_to_date(transaction_date,'%d-%m-%Y');
alter table sales modify column transaction_date date;
select * from sales;
desc sales;

-- now we also need to convert transaction_time column data type
update sales set transaction_time = str_to_date(transaction_time,'%H-%m-%s');
alter table sales modify column transaction_time time;
desc sales;
select * from sales;

alter table sales rename column ï»¿transaction_id to transaction_id;

-- calculate the total sales for each respective month

select round(sum(transaction_qty * unit_price),2) as total_sales
from sales
where
month(transaction_date) = 3;

-- Determine the month-on-month increase or decrease in sales

-- current month = 5
-- past month = 4

select
month(transaction_date) as month,
round(sum(transaction_qty * unit_price),2) as total_sales,
((sum(unit_price * transaction_qty)) - lag(sum(unit_price * transaction_qty),1)
over(order by month(transaction_date))) / lag(sum(unit_price * transaction_qty),1)
over(order by month(transaction_date)) * 100 as Percentage_Increase
from sales
where 
	month(transaction_date) in (4,5)
group by
	month(transaction_date)
order by 
	month(transaction_date);

-- Calculate the difference in sales between the selected month and the previous month

select
month(transaction_date) as Month,
round(sum(transaction_qty * unit_price)) as Total_Sales,
(round(sum(transaction_qty * unit_price))) - lag(round(sum(transaction_qty * unit_price)), 1)
over(order by month(transaction_date)) as Difference_in_Sales
from sales
where month(transaction_date) in (1,2,3,4,5,6)
group by month(transaction_date)
order by month(transaction_date);

-- Calculate the total number of orders for each respective month.

select
month(transaction_date) as Month,
count(transaction_id) as Orders
from sales
group by month(transaction_date)
order by month(transaction_date);

-- Determine the month-on-month increase or decrease n the number of orders.
select * from sales;

select
month(transaction_date) as Month,
count(transaction_id) as Orders,
count(transaction_id) - lag(count(transaction_id),1)
over(order by month(transaction_date)) as MoM_increase_or_decrease
from sales
group by month(transaction_date)
order by month(transaction_date);


select
month(transaction_date),
count(transaction_id) as Orders,
(round(count(transaction_id)) - lag(round(count(transaction_id),1))
over(order by month(transaction_date))) / lag(round(count(transaction_id),1)) 
over(order by month(transaction_date)) * 100 as MoM_Percentage
from sales
group by month(transaction_date)
order by month(transaction_date);

-- Calculate the difference in the numbers of orders between the selected month and the previous month.


select
month(transaction_date) as Month,
count(transaction_id) as Orders,
count(transaction_id) - lag(count(transaction_id),1)
over(order by month(transaction_date)) as Inc_Dec_Orders
from sales
group by month(transaction_date)
order by month(transaction_date);

-- Calculate total quantity sold for each respective month.

select
month(transaction_date) as Month,
sum(transaction_qty) as Quantity_Sold
from sales
group by month(transaction_date)
order by sum(transaction_qty);

-- Determine the month on month increase or decrease in the total quantity sold.

select
month(transaction_date) as Month,
sum(transaction_qty) as Quantity_Sold,
((sum(transaction_qty)) - lag(sum(transaction_qty),1)
over(order by month(transaction_date))) / lag(sum(transaction_qty),1)
over(order by month(transaction_date)) * 100 as MoM_Percentage_Change
from sales
group by month(transaction_date)
order by month(transaction_date);

-- Calculate the difference in the total quantity sold between the selected month and the previous month.

select
month(transaction_date) as Month,
sum(transaction_qty) as Quantity_Sold,
sum(transaction_qty) - lag(sum(transaction_qty),1)
over(order by month(transaction_date)) as MoM_Number_Change
from sales
group by month(transaction_date);

-- Calculate total sales, orders, and quantity sold any particular date.alter
select * from sales;
select
concat(round(sum(transaction_qty * unit_price)/1000,1), 'K') as Total_Day_Sales,
concat(round(count(transaction_id)/1000,1),'K') as Order_of_Day,
concat(round(sum(transaction_qty)/1000,1),'K') as Quantity_Sold_Day
from sales
where
transaction_date = '2023-05-18';

-- Weekdays and Weekend sales analysis
select * from sales;
select
case when
dayofweek(transaction_date) in (1,7) then 'WeekEND'
else 'WeekDAYS'
end as Type_of_DAYS,
sum(transaction_qty * unit_price) as Total_Sales
from sales
where month(transaction_date) = 5
group by
case when
dayofweek(transaction_date) in (1,7) then 'WeekEND'
else 'WeekDAYS'
end
order by
sum(transaction_qty * unit_price);

-- Sales analysis based on Store Location

select
month(transaction_date) as Month,
count(store_location) as Sales_of_Each_Location
from sales
group by month(transaction_date);

select
store_location,
count(store_location) as Sales_of_Each_Location
from sales
group by store_location
order by count(store_location) desc;
select * from sales;

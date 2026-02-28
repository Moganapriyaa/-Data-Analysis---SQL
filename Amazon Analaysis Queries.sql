---Create schema Amazon_Brazil;

--Table Customers
/*Create Table Amazon_Brazil.customers(
Customer_Id Varchar(200) Primary Key,
Customer_Unique_Id Varchar(200),
Customer_Zipcode_Prefix Int);*/

--Select * from Amazon_Brazil.customers

--Table Orders
/*Create Table  Amazon_Brazil.Orders(
Order_id Varchar(200) Primary key,
Customer_id Varchar(200),
Order_status Varchar (200),
Order_Purchase_Timestamp Timestamp,
Order_approved_at Timestamp,
Order_delivered_carrier_date Timestamp,
Order_delivered_customer_date Timestamp,
Order_estimated_delivery_date Timestamp);*/

--Select * from Amazon_Brazil.orders

--Table Payments
/*Create Table Amazon_Brazil.Payments(
Order_Id Varchar(200),
Payment_Sequential Int,
Payment_Type Varchar(200),
Payment_Installments Int,
Payment_Value Int)*/

--ALTER TABLE Amazon_Brazil.Payments
--ALTER COLUMN Payment_Value TYPE Float



--Select * from Amazon_Brazil.Payments

--Table Sellers
/*Create Table Amazon_Brazil.Sellers(
Seller_Id Varchar(200) Primary Key,
Seller_Zipcode_Prefix Int
)*/

--Select * from Amazon_Brazil.Sellers

--Table Order_Items
/*Create Table Amazon_Brazil.Order_Items(
Order_Id Varchar(200),
Order_Item_ID Int,
Product_Id Varchar(200),
Seller_Id Varchar(200),
Shipping_Limit_Date Timestamp,
Price Int,
Freight_Value Int);*/

--Select * from Amazon_Brazil.Order_Items

--Table Products
/*Create Table Amazon_Brazil.Products(
Product_Id Varchar(200) Primary Key,
Product_Category_name varchar,
Product_name_length int,
Product_Description_Length int,
Product_Photos_qty int,
Product_weight_g Int,
Product_Length_cm Int,
Product_Height_cm Int,
Product_Width_cm Int)*/

--Select * from Amazon_Brazil.Products


--Analysis 1
--1.
/*Select Payment_Type, Round(Avg(Payment_value)) as rounded_avg_payment
from Amazon_Brazil.Payments group by Payment_Type
order by rounded_avg_payment*/

--2.
/*select payment_type,
round(count(order_id) * 100.0/(select count(*) from amazon_brazil.payments),1) 
as percentage_orders
from amazon_brazil.payments
where payment_type <> 'not_defined'
group by payment_type
order by percentage_orders desc;*/

--3.
/*Select O.product_id,Price,Product_category_name from Amazon_Brazil.order_items O
JOIN Amazon_Brazil.Products P on P.product_id = O.product_id
where price between 100 and 500 and Product_category_name like lower
('%smart%')
ORDER BY Price desc*/

--4.
/*select extract(month from o.order_purchase_timestamp) as month,
round(sum(i.price)) as total_sales
from amazon_brazil.orders o
join amazon_brazil.order_items i
on o.order_id = i.order_id
group by month
order by total_sales desc
limit 3*/

--5
/*Select P.product_category_name,Max(price) - Min(price)as Price_difference from Amazon_Brazil.products P
JOIN Amazon_Brazil.order_items i
on P.product_id = i.product_id
Group by P.product_category_name
having (MAX(price) - MIN(price)) > 500;*/

--6
/*SELECT payment_type,Round(STDDEV_SAMP(payment_value))
AS std_deviation
FROM Amazon_Brazil.payments
group by payment_type
order by std_deviation*/

--7
/*select product_id, product_category_name
from amazon_brazil.products
where product_category_name is null
or length(product_category_name) = 1;*/

--2.1
/*select
case
when payment_value > 1000 then 'high'
when payment_value between 200 and 1000 then 'medium'
when payment_value < 200 then 'low'
else 'NA'
end as order_value_segment, payment_type,
count(payment_type)
from amazon_brazil.payments
group by order_value_segment, payment_type
order by count desc;*/

--2.2
 
/*Select Product_Category_Name, Min(Price), Max(Price),Round(Avg(Price))
from Amazon_Brazil.Order_items I
Join Amazon_Brazil.Products P
on I.product_id = P.Product_id
Group by product_Category_Name
order by Avg(price) Desc*/

--2.3
/*Select customer_Unique_id, count(order_id) as Total_orders 
from Amazon_Brazil.Customers C
Join Amazon_Brazil.Orders O
ON C.Customer_id = O.Customer_id
Group by customer_unique_id
Having count(order_id) > 1*/


--2.4

/*create temporary table customer_categories as
select customer_id,
case
when count(order_id) = 1 then 'New'
when count(order_id) between 2 and 4 then 'Returning'
when count(order_id) > 4 then 'Loyal'
else 'NA'
end as customer_type
from amazon_brazil.orders
group by customer_id;
select c.customer_id, cc.customer_type
from amazon_brazil.customers c
join customer_categories cc 
on c.customer_id = cc.customer_id;*/

--2.5

/*select p.product_category_name, round(sum(o.price)) as total_revenue
from amazon_brazil.products p
join amazon_brazil.order_items o
on p.product_id = o.product_id
group by product_category_name
order by total_revenue desc
limit 5;*/


--3.1

/*select season, round(sum(oi.price)) as total_sales 
from
(
select o.order_id,
case
when extract(month from order_purchase_timestamp) in (3, 4, 5)  then 'Spring'
when extract(month from order_purchase_timestamp) in (6, 7, 8) then 'Summer'
when extract(month from order_purchase_timestamp) in (9, 10, 11) then 'Autumn'
else 'Winter'
end as season
from amazon_brazil.orders o
) as order_season
join amazon_brazil.order_items oi
on order_season.order_id = oi.order_id
group by season;*/


--3.2

/*select product_id, total_quantity_sold
from 
(
select product_id, count(distinct order_id) as total_quantity_sold
from amazon_brazil.order_items
group by product_id
) as product_totals
where total_quantity_sold > 
(select avg(total_quantity_sold)
from 
(select product_id, count(distinct order_id) as total_quantity_sold
from amazon_brazil.order_items
group by product_id
) as avg_totals
)
order by total_quantity_sold desc;*/

--3.3

/*select extract(month from order_purchase_timestamp) as month,
round(sum(oi.price)) as total_revenue
from amazon_brazil.orders o
join amazon_brazil.order_items oi
on o.order_id = oi.order_id
where extract(year from (order_purchase_timestamp)) = 2018
group by month;*/

--3.4
/*with customer_segmentation as 
(
select customer_id, count(order_id) as count,
case 
when count(order_id) > 5 then 'Loyal'
when count(order_id) between 3 and 5 then 'Regular'
when count(order_id) between 1 and 2 then 'Ocassional'
else 'NA'
end as customer_type
from amazon_brazil.orders 
group by customer_id
)
select customer_type, count(customer_type) as count from customer_segmentation
group by customer_type;*/

--3.5

/*select o.customer_id, avg(oi.price) as avg_order_value,
rank () over (order by avg(oi.price) desc) as customer_rank
from amazon_brazil.orders o
join amazon_brazil.order_items oi
on o.order_id = oi.order_id 
group by o.customer_id
order by avg_order_value desc
limit 20;*/

--3.6
/*with monthly_sales as
(
select oi.product_id, 
extract (month from o.order_purchase_timestamp) as sale_month,
sum(oi.price) as monthly_sale
from amazon_brazil.orders o
join amazon_brazil.order_items oi
on o.order_id = oi.order_id
group by product_id, sale_month
)*/















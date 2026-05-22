use RetailAnalysis;

load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customer_profiles_lyst1749925722389.csv'
into table customer_profiles 
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from customer_profiles;

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/product_inventory_lyst1749925727340.csv"
into table product_inventory
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from product_inventory;

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sales_transaction_lyst1749925731351.csv"
into table sales_transaction
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

select * from sales_transaction;


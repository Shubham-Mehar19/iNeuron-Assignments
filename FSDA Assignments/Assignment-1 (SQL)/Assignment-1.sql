create database tasks;

use tasks;

--                                                        /* TASK 1*/

--  Create table shopping_history 
create table if not exists shopping_history (
product varchar(50) not null,
quantity int not null,
unit_price int not null);

-- inserting records in table shopping_history
insert into shopping_history values('milk',3,10),('bread',7,3),('bread',5,2);

-- Retrieving table shopping_history
select * from shopping_history;

/* Write a query that for each "product", returns the total amount of money spent on it.Rows should be ordered in descending alphabetic 
order by "product'. */

select product, sum(quantity*unit_price) as total_price from shopping_history 
group by product
order by product desc;
-- ==================================================================================================================================================

--                                                          /* TASK 2 */

-- TASK 2.1
-- A telecommunication company decided to find which of their client talk atleast 10 minutes on the phone in total and offer them new contract.
-- You are given two tables, phones and calls

-- create table calls
create table if not exists calls(
id int not null,
caller int not null,
callee int not null,
duration int not null,
unique(id));

-- inserting records in table calls
insert into calls values(25,1234,7582,8),(7,9999,7582,1),(18,9999,3333,4),(2,7582,3333,3),(3,3333,1234,1),(21,3333,1234,1);

-- retrieving table calls
select * from calls;

-- Checking number of records
select count(*) from calls;


-- create table phones 
create table if not exists phones(
name varchar(10) not null,
phone_number int not null,
unique(phone_number));

-- inserting record in table phones
insert into phones values("Jack",1234),("Lena",3333),("Mark",9999),("Anna",7582);

-- retriving table phones
select * from phones;

-- Checking no. of records
select count(*) from phones;

/* Write an SQL query  that finds all clients who that talked atleat 10 minutes in total. The table 0f results should contain one column: the name 
of client(name). Rows should be sorted alphabetically. */

select p.name as name from phones p
left join calls c
on p.phone_number=c.caller
or
p.phone_number = c.callee
group by name
having sum(duration)>=10
order by name asc;

-- =================================================================================================================================================
-- TASK 2.2
/* create new table calls1 */

create table if not exists calls1(
id int not null,
caller int not null,
callee int not null,
duration int not null,
unique(id));

insert into calls1 values(65,8003,9831,7),(100,9831,8003,3),(145,4315,9831,18);

select * from calls1;


/* create new table phones1 */
create table if not exists phones1(
name varchar(10) not null,
phone_number int not null,
unique(phone_number));

insert into phones1 values("John",6356),("Addison",4315),
("Kate",8003),("Ginny",9831);

select * from phones1;

-- Write an SQL query  that finds all clients who haved called(caller) or recieved call(callee).
select distinct p.name from phones1 p
inner join calls1 c on p.phone_number =c.caller or p.phone_number = c.callee
order by name asc;

-- ==================================================================================================================================================
															/* Task 3 */

/* Bank Transaction record for year 2020 */

-- TASK 3.1

-- create table transactions
create table if not exists transactions(
amount int not null,
date date not null);

-- inserting records
insert into transactions values (1000,'2020-01-06'),(-10,'2020-01-14'),(-75,'2020-01-20'),
(-5,'2020-01-25'),(-4,'2020-01-29'),(2000,'2020-03-10'),
(-75,'2020-03-12'),(-20,'2020-03-15'),(40,'2020-03-15'),
(-50,'2020-03-17'),(200,'2020-10-10'),(-200,'2020-10-10');

-- retriving records from table 
select * from transactions;

-- Checkin total balance without applying credit card holding fee
select sum(amount) as total_balance from transactions;

-- There is fee for holding a credit card which is 5 rs/month.
-- However, if atleast 3 credit card payment for total cost 100 within that month no holding fee will apply for that month.
-- If amount value is negative it is a credit card transaction payment, else incoming transfer.
-- There are no transaction with an amount 0.

-- Task The balance should be 2746 by deducting the credit card holding fees according to given conditions above.
-- At beginning of the year , the balance of your account was 0.Your task to compute balance at the end of the year.

select sum(case when credit_transaction>=3 and total_transaction <=-100 then total_month_transaction + 5 else total_month_transaction end) 
- 12*5 as balance from(
select 
		count(case when amount <0 then amount end) as credit_transaction,
        sum(case when amount<= 0 then amount else 0 end) as total_transaction,
        sum(amount) as total_month_transaction, month(date)
        from transactions
        group by month(date)) as total;

-- ===================================================================================================================================================
-- TASK 3.2

-- create table transactions2
create table if not exists transactions2(
amount int not null,
date date not null);

-- inserting records
insert into transactions2 values (1,'2020-06-29'),(35,'2020-02-20'),(-50,'2020-02-03'),
(-1,'2020-02-26'),(-200,'2020-08-01'),(-44,'2020-02-07'),
(-5,'2020-02-25'),(1,'2020-06-29'),(1,'2020-06-29'),
(-100,'2020-12-29'),(-100,'2020-12-30'),(-100,'2020-12-31');

-- retriving records from table 
select * from transactions2;

-- Checkin total balance without applying credit card holding fee
select sum(amount) as total_balance from transactions2;

-- There is fee for holding a credit card which is 5 rs/month.
-- However, if atleast 3 credit card payment for total cost 100 within that month no holding fee will apply for that month.
-- If amount value is negative it is a credit card transaction payment, else incoming transfer.
-- There are no transaction with an amount 0.

-- Task The balance should be -612 by deducting the credit card holding fees according to given conditions above.
-- At beginning of the year , the balance of your account was 0.Your task to compute balance at the end of the year.

select sum(case when credit_transaction>=3 and total_transaction <=-100 then total_month_transaction + 5 else total_month_transaction end) 
- 12*5 as balance from(
select 
		count(case when amount <0 then amount end) as credit_transaction,
        sum(case when amount<= 0 then amount else 0 end) as total_transaction,
        sum(amount) as total_month_transaction, month(date)
        from transactions2
        group by month(date)) as total;

-- ===================================================================================================================================================

-- TASK 3.3

-- create table transactions3
create table if not exists transactions3(
amount int not null,
date date not null);

-- inserting records
insert into transactions3 values (6000,'2020-04-03'),(5000,'2020-04-02'),(4000,'2020-04-01'),
(3000,'2020-03-01'),(2000,'2020-02-01'),(1000,'2020-01-01')

-- retriving records from table 
select * from transactions3;

-- Checkin total balance without applying credit card holding fee
select sum(amount) as total_balance from transactions3;

-- There is fee for holding a credit card which is 5 rs/month.
-- However, if atleast 3 credit card payment for total cost 100 within that month no holding fee will apply for that month.
-- If amount value is negative it is a credit card transaction payment, else incoming transfer.
-- There are no transaction with an amount 0.

-- Task The balance should be 20940 by deducting the credit card holding fees according to given conditions above.
-- At beginning of the year , the balance of your account was 0.Your task to compute balance at the end of the year.

select sum(case when credit_transaction>=3 and total_transaction <=-100 then total_month_transaction + 5 else total_month_transaction end) 
- 12*5 as balance from(
select 
		count(case when amount <0 then amount end) as credit_transaction,
        sum(case when amount<= 0 then amount else 0 end) as total_transaction,
        sum(amount) as total_month_transaction, month(date)
        from transactions3
        group by month(date)) as total;

-- ===================================================================================================================================================
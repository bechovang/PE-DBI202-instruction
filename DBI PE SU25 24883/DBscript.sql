/********************************* CREATE DATABSE AND TABLE *************************/
USE [master]
GO

/*******************************************************************************
   Drop database if it exists
********************************************************************************/
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'SMS')
BEGIN
	ALTER DATABASE [SMS] SET OFFLINE WITH ROLLBACK IMMEDIATE;
	ALTER DATABASE [SMS] SET ONLINE;
	DROP DATABASE [SMS];
END

GO

CREATE DATABASE [SMS]
GO

USE [SMS]
GO

create table Customer
(
	customer_id int primary key identity(1,1),
	customer_name nvarchar(50) not null check(customer_name <> N'')
)

go

create table Employee
(
	employee_id int primary key identity(1,1),
	employee_name nvarchar(50) not null check(employee_name <> N''),
	salary float check(salary >= 0),

	supervisor_id int check(isNumeric(supervisor_id)=1)
)

go

create table Product
(
	product_id int primary key identity(1,1),
	product_name nvarchar(100) not null check(product_name <> N''),
	product_price float not null check(product_price > 0)
)

go

create table Orders
(
	order_id int primary key identity(1,1),
	order_date datetime not null check(isDate(order_date)=1),
	total float check(total >= 0),

	customer_id int not null check(isNumeric(customer_id)=1),
	employee_id int not null check(isNumeric(employee_id)=1),
	foreign key (customer_id) references Customer(customer_id),
	foreign key (employee_id) references Employee(employee_id)
)

go

create table LineItem
(
	quantity int not null,
	price float not null check(price >= 0),

	order_id int not null check(isNumeric(order_id)=1),
	product_id int not null check(isNumeric(product_id)=1),
	foreign key (order_id) references Orders(order_id),
	foreign key (product_id) references Product(product_id),
	

	primary key (order_id, product_id)
)
go

 /*************************** INSERT DATA ****************************/
insert into Customer(customer_name) values('John Kenedy')
insert into Customer(customer_name) values('Nguyen Xuan Truong Giang')
insert into Customer(customer_name) values('Jack Hammer')
insert into Customer(customer_name) values('Thomas')
insert into Customer(customer_name) values('Jenny')
insert into Customer(customer_name) values('Aladin')
insert into Customer(customer_name) values('Linda')
insert into Customer(customer_name) values('Lily')

GO

insert into Employee(employee_name, salary, supervisor_id) values('Eminem', 10000.0, 0)
insert into Employee(employee_name, salary, supervisor_id) values('Selena Gome', 2000.0, 1)
insert into Employee(employee_name, salary, supervisor_id) values('Nick', 10000000.0, 1)

GO

insert into Product(product_name, product_price) values('Mouse', 20.0)
insert into Product(product_name, product_price) values('Keyboard', 30.0)
insert into Product(product_name, product_price) values('Laptop', 50.0)
insert into Product(product_name, product_price) values('CPU', 10.0)

GO

insert into Orders(order_date, total, customer_id, employee_id) values('20200618 10:34:09 AM', 0, 1, 2),
							('20140618 10:34:09 AM', 0, 2, 2),
							('20150618 10:34:09 AM', 0, 1, 3),
							('20160618 10:34:09 AM', 0, 3, 3)

GO

insert into LineItem(quantity, price, order_id, product_id ) values(10, 3000.0, 1, 1)
USE [master]
GO

/*******************************************************************************
   Drop database if it exists
********************************************************************************/
IF EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'PE_DBI202_F2025')
BEGIN
	ALTER DATABASE [PE_DBI202_F2025] SET OFFLINE WITH ROLLBACK IMMEDIATE;
	ALTER DATABASE [PE_DBI202_F2025] SET ONLINE;
	DROP DATABASE [PE_DBI202_F2025];
END

GO

CREATE DATABASE [PE_DBI202_F2025]
GO

USE [PE_DBI202_F2025]
GO
/*******************************************************************************
	Drop tables if exists
*******************************************************************************/
DECLARE @sql nvarchar(MAX) 
SET @sql = N'' 

SELECT @sql = @sql + N'ALTER TABLE ' + QUOTENAME(KCU1.TABLE_SCHEMA) 
    + N'.' + QUOTENAME(KCU1.TABLE_NAME) 
    + N' DROP CONSTRAINT ' -- + QUOTENAME(rc.CONSTRAINT_SCHEMA)  + N'.'  -- not in MS-SQL
    + QUOTENAME(rc.CONSTRAINT_NAME) + N'; ' + CHAR(13) + CHAR(10) 
FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS AS RC 

INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS KCU1 
    ON KCU1.CONSTRAINT_CATALOG = RC.CONSTRAINT_CATALOG  
    AND KCU1.CONSTRAINT_SCHEMA = RC.CONSTRAINT_SCHEMA 
    AND KCU1.CONSTRAINT_NAME = RC.CONSTRAINT_NAME 

EXECUTE(@sql) 

GO
DECLARE @sql2 NVARCHAR(max)=''

SELECT @sql2 += ' Drop table ' + QUOTENAME(TABLE_SCHEMA) + '.'+ QUOTENAME(TABLE_NAME) + '; '
FROM   INFORMATION_SCHEMA.TABLES
WHERE  TABLE_TYPE = 'BASE TABLE'

Exec Sp_executesql @sql2 
GO 
CREATE TABLE [dbo].[stores](
	[store_id] [int] NOT NULL primary key,
	[store_name] [varchar](255) NOT NULL,
	[phone] [varchar](25) NULL,
	[email] [varchar](255) NULL UNIQUE,
	[street] [varchar](255) NULL,
	[city] [varchar](255) NULL,
	[state] [varchar](10) NULL,
	[zip_code] [varchar](5) NULL
	);
GO
CREATE TABLE [dbo].[staffs](
	[staff_id] [int] NOT NULL primary key,
	[first_name] [varchar](50) NOT NULL,
	[last_name] [varchar](50) NOT NULL,
	[email] [varchar](255) NOT NULL UNIQUE,
	[phone] [varchar](25) NULL,
	[active] [tinyint] NOT NULL,
	[store_id] [int] NOT NULL,
	[manager_id] [int] NULL,
	FOREIGN KEY([manager_id]) REFERENCES [dbo].[staffs] ([staff_id]),
	FOREIGN KEY([store_id]) REFERENCES [dbo].[stores] ([store_id])
	);
GO
CREATE TABLE [dbo].[customers](
	[customer_id] [int] NOT NULL primary key,
	[first_name] [varchar](255) NOT NULL,
	[last_name] [varchar](255) NOT NULL,
	[phone] [varchar](25) NULL,
	[email] [varchar](255) NOT NULL,
	[street] [varchar](255) NULL,
	[city] [varchar](50) NULL,
	[state] [varchar](25) NULL,
	[zip_code] [varchar](5) NULL
);               	
GO
CREATE TABLE [dbo].[products](
	[product_id] [int] NOT NULL primary key,
	[product_name] [varchar](255) NOT NULL,
	[model_year] [smallint] NOT NULL,
	[list_price] [decimal](10, 2) NOT NULL,
	[brand_name] [varchar](255) NULL,
	[category_name] [varchar](255) NULL
	);
GO
CREATE TABLE [dbo].[stocks](
	[store_id] [int] NOT NULL,
	[product_id] [int] NOT NULL,
	[quantity] [int] NULL,
	primary key(store_id,product_id),
	FOREIGN KEY([product_id]) REFERENCES [dbo].[products] ([product_id]),
	FOREIGN KEY([store_id]) REFERENCES [dbo].[stores] ([store_id])
);
GO
CREATE TABLE [dbo].[orders](
	[order_id] [int] NOT NULL primary key,
	[customer_id] [int] NULL,
	[order_status] [tinyint] NOT NULL,
	[order_date] [date] NOT NULL,
	[required_date] [date] NOT NULL,
	[shipped_date] [date] NULL,
	[store_id] [int] NOT NULL,
	[staff_id] [int] NOT NULL,
                FOREIGN KEY([customer_id]) REFERENCES [dbo].[customers] ([customer_id]),
	FOREIGN KEY([staff_id]) REFERENCES [dbo].[staffs] ([staff_id]),
	FOREIGN KEY([store_id]) REFERENCES [dbo].[stores] ([store_id])
);
GO
CREATE TABLE [dbo].[order_items](
	[order_id] [int] NOT NULL,
	[item_id] [int] NOT NULL,
	[product_id] [int] NOT NULL,
	[quantity] [int] NOT NULL,
	[list_price] [decimal](10, 2) NOT NULL,
	[discount] [decimal](4, 2) NOT NULL,
	primary key (order_id,item_id),
    FOREIGN KEY([order_id]) REFERENCES [dbo].[orders] ([order_id]),
	FOREIGN KEY([product_id]) REFERENCES [dbo].[products] ([product_id])
	);
GO

INSERT INTO stores (store_id, store_name, phone, email, street, city, state, zip_code) VALUES
(1,'Downtown Cycles','+1-212-555-0001','downtown1@store.example','12 Broadway','New York','NY','10004'),
(2,'Riverside Wheels','+1-312-555-0002','riverside2@store.example','45 Lake St','Chicago','IL','60601'),
(3,'Bay City Bikes','+1-415-555-0003','bay3@store.example','9 Market St','San Francisco','CA','94103'),
(4,'Desert Trail','+1-480-555-0004','desert4@store.example','88 Camelback Rd','Phoenix','AZ','85016'),
(5,'Capitol Ride','+1-202-555-0005','capitol5@store.example','101 Constitution Ave','Washington','DC','20001'),
(6,'Music City Pedals','+1-615-555-0006','music6@store.example','7 Broadway','Nashville','TN','37201'),
(7,'Seaside Spokes','+1-206-555-0007','seaside7@store.example','23 Pike Pl','Seattle','WA','98101'),
(8,'Harbor Gears','+1-401-555-0008','harbor8@store.example','16 Thames St','Newport','RI','02840'),
(9,'Lone Star Bikes','+1-214-555-0009','lonestar9@store.example','150 Elm St','Dallas','TX','75201'),
(10,'Liberty Pedals','+1-267-555-0010','liberty10@store.example','3 Walnut St','Philadelphia','PA','19106'),
(11,'Golden State Ride','+1-661-555-0011','golden11@store.example','55 Main St','Bakersfield','CA','93301'),
(12,'Great Lakes Cycles','+1-734-555-0012','lakes12@store.example','12 State St','Ann Arbor','MI','48104'),
(13,'Mile High Wheels','+1-303-555-0013','mile13@store.example','200 Colfax Ave','Denver','CO','80202'),
(14,'Prairie Path','+1-913-555-0014','prairie14@store.example','77 Metcalf Ave','Overland Park','KS','66210'),
(15,'Steel City Spin','+1-412-555-0015','steel15@store.example','66 Liberty Ave','Pittsburgh','PA','15222'),
(16,'Peachtree Pedals','+1-404-555-0016','peach16@store.example','18 Peachtree St','Atlanta','GA','30303'),
(17,'River Bend Wheels','+1-563-555-0017','river17@store.example','5 River Dr','Davenport','IA','52801');
GO
/* =========================
   STAFFS (20)
   ========================= */
INSERT INTO staffs (staff_id, first_name, last_name, email, phone, active, store_id, manager_id) VALUES
(1,'Anh','Tran','anh.tran@company.example','+84-90-000-0001',1,1,NULL),
(2,'Binh','Nguyen','binh.nguyen@company.example','+84-90-000-0002',1,2,NULL),
(3,'Chi','Le','chi.le@company.example','+84-90-000-0003',1,3,NULL),
(4,'Dung','Pham','dung.pham@company.example','+84-90-000-0004',1,4,NULL),
(5,'Em','Vo','em.vo@company.example','+84-90-000-0005',1,5,NULL),
(6,'Giang','Do','giang.do@company.example','+84-90-000-0006',1,6,1),
(7,'Ha','Phan','ha.phan@company.example','+84-90-000-0007',1,7,2),
(8,'Hieu','Tran','hieu.tran@company.example','+84-90-000-0008',1,8,3),
(9,'Khanh','Bui','khanh.bui@company.example','+84-90-000-0009',1,9,4),
(10,'Lan','Vu','lan.vu@company.example','+84-90-000-0010',1,10,5),
(11,'Minh','Dang','minh.dang@company.example','+84-90-000-0011',1,11,1),
(12,'Nhi','Ho','nhi.ho@company.example','+84-90-000-0012',1,12,2),
(13,'Oanh','Ly','oanh.ly@company.example','+84-90-000-0013',1,13,3),
(14,'Phuc','Nguyen','phuc.nguyen@company.example','+84-90-000-0014',1,14,4),
(15,'Quang','Tran','quang.tran@company.example','+84-90-000-0015',1,15,5),
(16,'Son','Phan','son.phan@company.example','+84-90-000-0016',1,16,1),
(17,'Trang','Dao','trang.dao@company.example','+84-90-000-0017',1,17,2);
GO
INSERT INTO customers (customer_id, first_name, last_name, phone, email, street, city, state, zip_code) VALUES
(1,'Liam','Johnson','+1-646-555-2001','liam.johnson@cust.example','101 Maple St','New York','NY','10011'),
(2,'Emma','Smith','+1-312-555-2002','emma.smith@cust.example','22 Oak Ave','New York','IL','60610'),
(3,'Noah','Williams','+1-415-555-2003','noah.williams@cust.example','9 Pine Rd','San Francisco','CA','94107'),
(4,'Olivia','Brown','+1-480-555-2004','olivia.brown@cust.example','5 River Ln','Phoenix','AZ','85018'),
(5,'Ava','Jones','+1-202-555-2005','ava.jones@cust.example','7 Union Sq','Washington','DC','20002'),
(6,'Elijah','Garcia','+1-615-555-2006','elijah.garcia@cust.example','88 Cedar Dr','Nashville','TN','37203'),
(7,'Sophia','Martinez','+1-206-555-2007','sophia.martinez@cust.example','66 Pine St','Seattle','WA','98104'),
(8,'James','Davis','+1-401-555-2008','james.davis@cust.example','33 Harbor Rd','Newport','RI','02840'),
(9,'Isabella','Rodriguez','+1-214-555-2009','isabella.rodriguez@cust.example','12 Elm St','Dallas','TX','75202'),
(10,'Mia','Wilson','+1-267-555-2010','mia.wilson@cust.example','1 Market Sq','Philadelphia','PA','19107'),
(11,'Lucas','Anderson','+1-661-555-2011','lucas.anderson@cust.example','17 Sunset Blvd','Bakersfield','CA','93304'),
(12,'Charlotte','Thomas','+1-734-555-2012','charlotte.thomas@cust.example','99 State St','Ann Arbor','MI','48108'),
(13,'Amelia','Taylor','+1-303-555-2013','amelia.taylor@cust.example','75 Lakeview Dr','Denver','CO','80203'),
(14,'Harper','Moore','+1-913-555-2014','harper.moore@cust.example','40 Prairie Rd','Overland Park','KS','66212'),
(15,'Evelyn','Jackson','+1-412-555-2015','evelyn.jackson@cust.example','24 Grant St','Pittsburgh','PA','15219'),
(16,'Henry','White','+1-404-555-2016','henry.white@cust.example','5 Peachtree Ct','Atlanta','GA','30308'),
(17,'Scarlett','Harris','+1-563-555-2017','scarlett.harris@cust.example','6 Riverbank Ave','Davenport','IA','52802');
GO
/* =========================
   PRODUCTS (20)
   ========================= */
INSERT INTO products (product_id, product_name, model_year, list_price, brand_name, category_name) VALUES
(1,'Roadster 100',2023,299.00,'Swift','Road'),
(2,'Roadster 200',2024,449.00,'Swift','Road'),
(3,'Roadster 300',2025,699.00,'Swift','Road'),
(4,'Mountain X1',2023,559.00,'Peak','Mountain'),
(5,'Mountain X2',2024,799.00,'Peak','Mountain'),
(6,'City Lite',2022,259.00,'Urban','City'),
(7,'City Pro',2024,399.00,'Urban','City'),
(8,'Gravel GX',2025,999.00,'Terra','Gravel'),
(9,'Folding Go',2023,379.00,'Compact','Folding'),
(10,'Kids Fun 14',2022,149.00,'HappyRide','Kids'),
(11,'E-City 250',2024,1299.00,'Volt','E-Bike'),
(12,'E-Mountain 500',2025,2199.00,'Volt','E-Bike'),
(13,'BMX Spark',2023,149.00,'Flip','BMX'),
(14,'Touring T1',2024,899.00,'Voyage','Touring'),
(15,'Fixie Basic',2022,219.00,'Street','Fixie'),
(16,'Hybrid H2',2023,499.00,'Blend','Hybrid'),
(17,'Hybrid H3',2024,649.00,'Blend','Hybrid');
/* =========================
   STOCKS (20)  -- (store_id, product_id) pairs
   ========================= */
INSERT INTO stocks (store_id, product_id, quantity) VALUES
(1,1,12),(1,6,5),
(2,2,10),(2,7,6),
(3,3,8),(3,11,3),
(4,4,9),(4,16,4),
(5,5,7),(5,12,2),
(6,8,5),(6,9,6),
(7,10,10),(7,14,3);
GO
/* =========================
   ORDERS (20)
   ========================= */ 
INSERT INTO orders (order_id, customer_id, order_status, order_date, required_date, shipped_date, store_id, staff_id) VALUES
(1,1,4,'2025-08-01','2025-08-03','2025-08-03',1,1),
(2,2,4,'2025-08-02','2025-08-04','2025-08-04',2,2),
(3,3,4,'2025-08-03','2025-08-05','2025-08-05',3,3),
(4,4,4,'2025-08-04','2025-08-06','2025-08-06',4,4),
(5,5,4,'2025-08-05','2025-08-07','2025-08-07',5,5),
(6,6,4,'2025-08-06','2025-08-08','2025-08-08',6,6),
(7,7,4,'2025-08-07','2025-08-09','2025-08-09',7,7),
(8,8,4,'2025-08-08','2025-08-10','2025-08-10',8,8),
(9,9,4,'2025-08-09','2025-08-11','2025-08-11',9,9),
(10,10,3,'2025-08-10','2025-08-12','2025-08-12',10,10),
(11,11,4,'2025-08-11','2025-08-13','2025-08-13',11,11),
(12,12,3,'2025-08-12','2025-08-14','2025-08-14',12,12),
(13,13,3,'2025-08-13','2025-08-15','2025-08-15',13,13),
(14,14,3,'2025-08-14','2025-08-16','2025-08-16',14,14),
(15,15,4,'2025-08-15','2025-08-17','2025-08-17',15,15),
(16,16,3,'2025-08-16','2025-08-18','2025-08-18',16,16),
(17,17,4,'2025-08-17','2025-08-19','2025-08-19',17,17);
GO
/* =========================
   ORDER_ITEMS (20)  -- one line per order
   ========================= */
INSERT INTO order_items (order_id, item_id, product_id, quantity, list_price, discount) VALUES
(1,1,1,1,299.00,0.00),
(2,1,2,1,449.00,0.05),
(3,1,3,1,699.00,0.00),
(4,1,4,1,559.00,0.00),
(5,1,5,1,799.00,0.10),
(6,1,6,2,259.00,0.00),
(7,1,7,1,399.00,0.00),
(8,1,8,1,999.00,0.05),
(9,1,9,1,379.00,0.00),
(10,1,10,1,149.00,0.00),
(11,1,11,1,1299.00,0.07),
(12,1,12,1,2199.00,0.00),
(13,1,13,2,329.00,0.00),
(14,1,14,1,899.00,0.10),
(15,1,15,1,219.00,0.00),
(16,1,16,1,499.00,0.00),
(17,1,17,1,649.00,0.05);
GO

--q1

CREATE TABLE Customer ( -- thứ tự Customer trước Address
    customer_id INT PRIMARY KEY ,
    first_name NVARCHAR(20),
    last_name NVARCHAR(30),
    phone VARCHAR(15)
)

CREATE TABLE Address (
    customer_id INT PRIMARY KEY , -- khai PK kiểu như này
    street_address NVARCHAR(50),
    city NVARCHAR(30),
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
)



CREATE TABLE Book (
    book_id INT PRIMARY KEY,
    title NVARCHAR(100),
    author NVARCHAR(50)
)

CREATE TABLE Checkout (
    customer_id INT,
    book_id INT,
    checkout_date DATETIME,
    return_date DATETIME,
    PRIMARY KEY (customer_id, book_id, checkout_date, return_date), -- thêm cái checkout_date, return_date
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (book_id) REFERENCES Book(book_id)
)
--membuat database
CREATE DATABASE RetailStoreDB;
GO

--memakai database
USE RetailStoreDB;
GO

/*Schema adalah wadah atau folder khusus di
dalam sebuah database yang digunakan untuk 
mengelompokkan tabel, view, function, dan 
objek-objek lainnya*/

--membuat skema Production
CREATE SCHEMA Production;
GO

--membuat skema Sales
CREATE SCHEMA Sales;
GO

--membuat skema HumanResources
CREATE SCHEMA HumanResources;
GO

--membuat tabel 
CREATE TABLE Production.Product (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    ProductNumber NVARCHAR(50) NOT NULL,
    Color NVARCHAR(20) NULL,
    Size NVARCHAR(10) NULL,
    ListPrice DECIMAL(10,2) NOT NULL DEFAULT 0
);

--membuat tabel Sales.SalesOrderDetail
CREATE TABLE Sales.SalesOrderDetail (
    SalesOrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
    SalesOrderID INT NOT NULL,
    ProductID INT NOT NULL,
    OrderQty INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    LineTotal AS (OrderQty * UnitPrice) PERSISTED,
    SpecialOfferID INT NULL,
    FOREIGN KEY (ProductID) REFERENCES Production.Product(ProductID)
);

--membuat tabel HumanResources.Employee
CREATE TABLE HumanResources.Employee (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    JobTitle NVARCHAR(100) NOT NULL
);

--memasukkan data ke tabel Production.Product
INSERT INTO Production.Product (Name, ProductNumber, Color, Size, ListPrice)
VALUES
('Road Bike Pro', 'RB-001', 'Red', 'L', 3500),
('Road Bike Entry', 'RB-101', 'Red', 'M', 1200),
('Mountain Bike XL', 'MB-500', 'Blue', 'XL', 2100),
('City Bike Small', 'CB-020', 'Black', 'S', 900),
('Helmet Pro', 'HL-001', 'Red', NULL, 150),
('Helmet Basic', 'HL-050', 'Black', NULL, 80),
('Gloves Sport', 'GL-020', 'Blue', NULL, 50),
('Tire Road 700C', 'TR-700', NULL, NULL, 45),
('Water Bottle', 'WB-100', NULL, NULL, 20),
('Cycling Jersey', 'CJ-200', 'Red', 'M', 300),
('Cycling Jersey', 'CJ-300', 'Black', 'L', 320);

--memasukkan data ke tabel Sales.SalesOrderDetail 
INSERT INTO Sales.SalesOrderDetail (SalesOrderID, ProductID, OrderQty, UnitPrice, SpecialOfferID)
VALUES
(1, 1, 3, 3500, 1),
(1, 2, 1, 1200, 1),
(2, 1, 2, 3500, 2),
(3, 3, 4, 2100, 1),
(3, 4, 10, 900, 1),
(4, 5, 2, 150, 3),
(4, 6, 5, 80, 3),
(5, 7, 3, 50, 2),
(6, 8, 20, 45, 1),
(7, 9, 1, 20, 2),
(8, 10, 6, 300, 2),
(8, 11, 7, 320, 1),
(9, 1, 5, 3500, 1),   
(10, 3, 2, 2100, 1);  

-- memasukkan data ke tabel HumanResources.Employee
INSERT INTO HumanResources.Employee (JobTitle)
VALUES
('Sales Representative'),
('Sales Manager'),
('Technician'),
('Technician'),
('Senior Engineer'),
('Engineer');

SELECT * 
FROM HumanResources.Employee;




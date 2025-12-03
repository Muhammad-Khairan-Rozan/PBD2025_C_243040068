USE RetailStoreDB;

SELECT * FROM Production.Product;

SELECT Name, ProductNumber, ListPrice
FROM Production.Product;

SELECT Name AS [Nama Barang], ListPrice AS 'Harga Jual'
FROM Production.Product;

SELECT Name, ListPrice, (ListPrice * 1.1) AS HargaBaru 
FROM Production.Product; 

SELECT Name + ' (' + ProductNumber + ')' AS ProdukLengkap 
FROM Production.Product;

SELECT Name, Color, ListPrice 
FROM Production.Product 
WHERE Color = 'Red';

SELECT Name, ListPrice
FROM Production.Product 
WHERE ListPrice > 1000;

SELECT Name, Color, ListPrice
FROM Production.Product 
WHERE Color = 'Black' AND ListPrice > 500;

SELECT Name, Color
FROM Production.Product 
WHERE Color IN ('Red', 'Blue', 'Black')
ORDER BY Color ASC;

SELECT Name, ProductNumber 
FROM Production.Product 
WHERE Name LIKE '%Road%'; 


SELECT COUNT(*) AS TotalProduk 
FROM Production.Product; 

SELECT Color, COUNT(*) AS JumlahProduk 
FROM Production.Product 
GROUP BY Color; 

SELECT ProductID, SUM(OrderQty) AS TotalTerjual, AVG(UnitPrice) AS 
RataRataHarga 
FROM Sales.SalesOrderDetail 
GROUP BY ProductID;



SELECT Color, COUNT(*) AS JumlahTotal
FROM Production.Product
GROUP BY Color 
HAVING COUNT(*) > 1;

SELECT Color, COUNT(*) AS TotalJumlah
FROM Production.Product
WHERE ListPrice > 500
GROUP BY Color 
HAVING COUNT(*) > 1;

SELECT ProductID, SUM(OrderQty) AS TotalQty 
FROM Sales.SalesOrderDetail 
GROUP BY ProductID 
HAVING SUM(OrderQty) > 10;

SELECT SpecialOfferID, AVG(OrderQty) AS RataRataBeli 
FROM Sales.SalesOrderDetail 
GROUP BY SpecialOfferID 
HAVING AVG(OrderQty) < 10;

SELECT Color  
FROM Production.Product 
GROUP BY Color 
HAVING MAX(ListPrice) > 3000;

SELECT * FROM HumanResources.Employee;

SELECT DISTINCT JobTitle 
FROM HumanResources.Employee;

SELECT Name, ListPrice 
FROM Production.Product 
ORDER BY ListPrice DESC; 

SELECT TOP 5 Name, ListPrice 
FROM Production.Product
ORDER BY ListPrice DESC;

SELECT Name, ListPrice
FROM Production.Product
ORDER BY ListPrice DESC
OFFSET 5 ROWS
FETCH NEXT 4 ROWS ONLY;
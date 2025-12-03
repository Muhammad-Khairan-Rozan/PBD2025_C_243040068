USE RetailStoreDB;

SELECT TOP 10 ProductID, SUM(LineTotal) AS TotalPendapatan
FROM Sales.SalesOrderDetail
WHERE OrderQty >= 2
GROUP BY ProductID
HAVING SUM(LineTotal) > 10000
ORDER BY TotalPendapatan DESC;


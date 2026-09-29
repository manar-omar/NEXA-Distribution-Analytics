-- Invalid Products

SELECT o.*
FROM Fact_Orders o
LEFT JOIN Dim_Product p
ON o.Product_ID = p.Product_ID
WHERE p.Product_ID IS NULL;


-- Invalid Regions

SELECT *
FROM Fact_Orders
WHERE Recovered_Region_ID NOT IN (
      SELECT Region_ID
      FROM Dim_Region
   );
   
   
   
-- Duplicate Orders ID   
   
SELECT Order_ID, COUNT(*) AS Duplicate_Count
FROM Fact_Orders
GROUP BY Order_ID
HAVING COUNT(*) > 1;



-- Delivery Shortfall

SELECT *
FROM V_Order_Reconciliation
WHERE Reconciliation_Status = 'Delivery Shortfall';


-- Delivered But Not Yet Invoiced

SELECT *
FROM V_Order_Reconciliation
WHERE Reconciliation_Status = 'Delivered - Not Yet Invoiced';


-- Outstanding Collections

SELECT *
FROM V_Order_Reconciliation
WHERE Reconciliation_Status = 'Invoiced - Payment Outstanding';


-- Partially Paid Invoices

SELECT *
FROM V_Order_Reconciliation
WHERE Reconciliation_Status = 'Partially Paid';


-- Overpaid Cases

SELECT *
FROM V_Order_Reconciliation
WHERE Reconciliation_Status = 'Overpaid - Review';


-- Open Orders

SELECT *
FROM V_Order_Reconciliation
WHERE Reconciliation_Status = 'Not Yet Delivered';
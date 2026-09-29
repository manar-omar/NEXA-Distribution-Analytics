SELECT COUNT(*) AS Deliveries_Without_Valid_Order
FROM V_Fact_Deliveries AS d
WHERE d.Order_ID IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM V_Fact_Orders AS o
      WHERE o.Order_ID = d.Order_ID
  );


SELECT COUNT(*) AS Deliveries_Without_Valid_Trip
FROM V_Fact_Deliveries AS d
WHERE d.Trip_ID IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM V_Fact_Trips AS t
      WHERE t.Trip_ID = d.Trip_ID
  );
  
  
  SELECT COUNT(*) AS Invoices_Without_Valid_Order
FROM V_Fact_Invoices AS i
WHERE i.Order_ID IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM V_Fact_Orders AS o
      WHERE o.Order_ID = i.Order_ID
  );
  
  
  SELECT COUNT(*) AS Payments_Without_Valid_Invoic
FROM V_Fact_Payments AS p
WHERE p.Invoice_ID IS NOT NULL
  AND NOT EXISTS (
      SELECT 1
      FROM V_Fact_Invoices AS i
      WHERE i.Invoice_ID = p.Invoice_ID
  );
  
-- Missing keys in deliveries
SELECT
    SUM(Order_ID IS NULL OR TRIM(Order_ID) = '') AS Missing_Order_ID,
    SUM(Trip_ID IS NULL OR TRIM(Trip_ID) = '') AS Missing_Trip_ID
FROM V_Fact_Deliveries;


-- Missing Order_ID in invoices
SELECT
    SUM(Order_ID IS NULL OR TRIM(Order_ID) = '') AS Missing_Order_ID
FROM V_Fact_Invoices;


-- Missing Invoice_ID in payments
SELECT
    SUM(Invoice_ID IS NULL OR TRIM(Invoice_ID) = '') AS Missing_Invoice_ID
FROM V_Fact_Payments;

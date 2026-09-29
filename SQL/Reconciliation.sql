WITH Delivery_Summary AS (
    SELECT 
        Order_ID,
        SUM(Final_Delivered_Qty) AS Total_Delivered_Qty
    FROM V_Fact_Deliveries
    GROUP BY Order_ID
),
Invoice_Summary AS (
    SELECT 
        Order_ID,
        SUM(Final_Invoiced_Qty) AS Total_Invoiced_Qty,
        SUM(Invoice_Amount_EGP) AS Total_Invoiced_Amount
    FROM V_Fact_Invoices
    GROUP BY Order_ID
),
Payment_Summary AS (
    SELECT 
        i.Order_ID,
        SUM(p.Final_Paid_Amount_EGP) AS Total_Paid_Amount
    FROM V_Fact_Payments p
    JOIN V_Fact_Invoices i ON p.Invoice_ID = i.Invoice_ID
    GROUP BY i.Order_ID
)
SELECT
    o.Order_ID,
    o.Final_Quantity AS Ordered_Qty,
    d.Total_Delivered_Qty,
    inv.Total_Invoiced_Qty,
    inv.Total_Invoiced_Amount,
    o.Sales_Value_EGP AS Order_Value,
    pay.Total_Paid_Amount,
    CASE
        WHEN d.Total_Delivered_Qty IS NULL THEN 'Not Yet Delivered'
        WHEN d.Total_Delivered_Qty < o.Final_Quantity THEN 'Delivery Shortfall'
        WHEN inv.Total_Invoiced_Qty IS NULL THEN 'Delivered - Not Yet Invoiced'
        WHEN pay.Total_Paid_Amount IS NULL THEN 'Invoiced - Payment Outstanding'
        WHEN pay.Total_Paid_Amount < inv.Total_Invoiced_Amount THEN 'Partially Paid'
        WHEN pay.Total_Paid_Amount > inv.Total_Invoiced_Amount THEN 'Overpaid - Review'
        ELSE 'Fully Reconciled'
    END AS Reconciliation_Status
FROM V_Fact_Orders o
LEFT JOIN Delivery_Summary d ON o.Order_ID = d.Order_ID
LEFT JOIN Invoice_Summary inv ON o.Order_ID = inv.Order_ID
LEFT JOIN Payment_Summary pay ON o.Order_ID = pay.Order_ID;


    
      


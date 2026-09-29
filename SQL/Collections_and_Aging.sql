/* Invoice Collection Status */

SELECT
    Final_Payment_Status,
    COUNT(*) AS Invoice_Count,
    ROUND(SUM(Final_Paid_Amount_EGP),2) AS Paid_Amount
FROM Fact_Payments
GROUP BY Final_Payment_Status;


/* Invoiced vs Paid Amounts */

SELECT
    (SELECT ROUND(SUM(Invoice_Amount_EGP),2)
     FROM Fact_Invoices) AS Total_Invoiced,

    (SELECT ROUND(SUM(Final_Paid_Amount_EGP),2)
     FROM Fact_Payments) AS Total_Paid;
     
     
	
/* Outstanding Balance */

SELECT
    ROUND(SUM(i.Invoice_Amount_EGP) - SUM(COALESCE(p.Final_Paid_Amount_EGP,0)),2) AS Outstanding_Amount
FROM Fact_Invoices i
LEFT JOIN Fact_Payments p
       ON i.Invoice_ID = p.Invoice_ID;
       

/* Unpaid Invoices */

SELECT
    i.Invoice_ID,
    i.Invoice_Amount_EGP,
    i.Due_Date
FROM Fact_Invoices i
LEFT JOIN Fact_Payments p
       ON i.Invoice_ID = p.Invoice_ID
WHERE p.Invoice_ID IS NULL;


/* Late Payments */

SELECT
    p.Payment_ID,
    p.Invoice_ID,
    i.Due_Date,
    p.Payment_Date_Clean
FROM Fact_Payments p
JOIN Fact_Invoices i
     ON p.Invoice_ID = i.Invoice_ID
WHERE p.Payment_Date_Clean > i.Due_Date;


/* Average Collection Period */

SELECT
    CASE
        WHEN DATEDIFF(
                 STR_TO_DATE(p.Payment_Date_Clean, '%Y-%m-%d'),
                 i.Due_Date
             ) <= 30
        THEN '0-30 Days'

        WHEN DATEDIFF(
                 STR_TO_DATE(p.Payment_Date_Clean, '%Y-%m-%d'),
                 i.Due_Date
             ) <= 60
        THEN '31-60 Days'

        WHEN DATEDIFF(
                 STR_TO_DATE(p.Payment_Date_Clean, '%Y-%m-%d'),
                 i.Due_Date
             ) <= 90
        THEN '61-90 Days'

        ELSE '90+ Days'
    END AS Payment_Delay_Bucket,

    COUNT(*) AS Payment_Count,

    ROUND(
        SUM(p.Final_Paid_Amount_EGP),
        2
    ) AS Total_Paid_Amount

FROM Fact_Payments p
JOIN Fact_Invoices i
    ON p.Invoice_ID = i.Invoice_ID

GROUP BY Payment_Delay_Bucket
ORDER BY Payment_Count DESC;
     
     
/* Aging Buckets */

SELECT
    CASE
        WHEN DATEDIFF(CURDATE(), Due_Date) <= 30
            THEN '0-30 Days'

        WHEN DATEDIFF(CURDATE(), Due_Date) <= 60
            THEN '31-60 Days'

        WHEN DATEDIFF(CURDATE(), Due_Date) <= 90
            THEN '61-90 Days'

        ELSE '90+ Days'
    END AS Aging_Bucket,

    COUNT(*) AS Invoice_Count,

    SUM(Invoice_Amount_EGP) AS Invoice_Value

FROM Fact_Invoices
GROUP BY Aging_Bucket
ORDER BY Invoice_Count DESC;


/* Customer Payment Delay Distribution */
SELECT
    ROUND(
        AVG(
            DATEDIFF(
                STR_TO_DATE(p.Payment_Date_Clean,'%Y-%m-%d'),
                i.Due_Date
            )
        ),
        2
    ) AS Avg_Payment_Delay_Days
FROM Fact_Payments p
JOIN Fact_Invoices i
ON p.Invoice_ID = i.Invoice_ID;


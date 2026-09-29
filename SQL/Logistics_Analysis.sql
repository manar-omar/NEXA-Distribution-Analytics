
/* Transportation & Logistics Analysis*/

-- Logistics Overview
SELECT
    COUNT(*) AS Total_Trips,
    SUM(Trip_Cost_EGP) AS Total_Transportation_Cost,
    SUM(Loaded_Weight_KG) AS Total_Loaded_Weight
FROM Fact_Trips;


-- Monthly Logistics Trend
SElECT
    MONTH(Trip_Date) AS Month_no,
    COUNT(*) AS Trips,
    SUM(Trip_Cost_EGP) AS Total_Cost,
    SUM(Loaded_Weight_KG) AS Total_Weight
FROM Fact_Trips
GROUP BY MONTH(Trip_Date)
ORDER BY Month_No;


-- Region Performance
SELECT
    r.Region_Name,
    COUNT(*) AS Trip_Count,
    SUM(t.Trip_Cost_EGP) AS Total_Cost,
    SUM(t.Loaded_Weight_KG) AS Total_Weight,
    ROUND(
        SUM(t.Trip_Cost_EGP) /
        NULLIF(SUM(t.Loaded_Weight_KG),0),
        2
    ) AS Cost_Per_KG
FROM Fact_Trips t
JOIN Dim_Region r
    ON t.Region_ID = r.Region_ID
GROUP BY r.Region_Name
ORDER BY Cost_Per_KG DESC;


-- Vehicle Utilization
SELECT
    v.Vehicle_Type,
    AVG(t.Final_Utilization_Rate) AS Avg_Utilization
FROM Fact_Trips t
JOIN Dim_VehicleType v
    ON t.Vehicle_Type_ID = v.Vehicle_Type_ID
GROUP BY v.Vehicle_Type
ORDER BY Avg_Utilization DESC;


-- Transporter Comparison
SELECT
    tr.Transporter_Name,
    COUNT(*) AS Total_Trips,
    AVG(t.Trip_Cost_EGP) AS Avg_Trip_Cost,
    AVG(t.Final_Utilization_Rate) AS Avg_Utilization
FROM Fact_Trips t
JOIN Dim_Transporter tr
    ON t.Transporter_ID = tr.Transporter_ID
GROUP BY tr.Transporter_Name
ORDER BY Avg_Utilization DESC;


-- Top 10 Most Expensive Trips
SELECT
    Trip_ID,
    Trip_Date_Clean,
    Trip_Cost_EGP,
    Loaded_Weight_KG,
    Distance_KM,
    Final_Region_Name
FROM Fact_Trips
ORDER BY Trip_Cost_EGP DESC
LIMIT 10;


-- Lowest Utilization Trips
SELECT
    Trip_ID,
    Final_Utilization_Rate,
    Trip_Cost_EGP,
    Loaded_Weight_KG
FROM Fact_Trips
ORDER BY Final_Utilization_Rate ASC
LIMIT 20;


/* =========================================
   Transportation Cost Growth vs Shipment Volume Analysis
   Objective:
   Determine whether transportation cost growth
   is justified by shipment volume growth.
========================================= */

SELECT
    MONTH(Trip_Date) AS Month_No,
    SUM(Trip_Cost_EGP) AS Total_Cost,
    SUM(Loaded_Weight_KG) AS Total_Weight,
    ROUND(
        SUM(Trip_Cost_EGP) /
        NULLIF(SUM(Loaded_Weight_KG),0),
        2
    ) AS Cost_Per_KG
FROM Fact_Trips
GROUP BY MONTH(Trip_Date)
ORDER BY Month_No;


-- Region Analysis

SELECT
    Final_Region_Name,
    ROUND(
        SUM(Trip_Cost_EGP) /
        NULLIF(SUM(Loaded_Weight_KG),0),
        2
    ) AS Cost_Per_KG
FROM Fact_Trips
GROUP BY Final_Region_Name
ORDER BY Cost_Per_KG DESC;


-- Transporter Analysis

SELECT
    Transporter_Name_Raw,
    ROUND(AVG(Final_Utilization_Rate),2) AS Avg_Utilization
FROM Fact_Trips
GROUP BY Transporter_Name_Raw
ORDER BY Avg_Utilization DESC;


-- Vehicle Analysis

SELECT
    Vehicle_Type,
    ROUND(AVG(Final_Utilization_Rate),2) AS Avg_Utilization
FROM Fact_Trips t
LEFT JOIN dim_vehicletype v
ON t.Final_Vehicle_Type_ID = v.Vehicle_Type_ID
GROUP BY Vehicle_Type
ORDER BY Avg_Utilization DESC;
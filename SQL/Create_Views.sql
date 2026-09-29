-- fact_orders view
CREATE VIEW V_Fact_Orders AS
SELECT
  ROW_NUMBER() OVER (ORDER BY Order_Surrogate_Key ) AS Order_Fact_Key, 
  Order_Surrogate_Key,
  Order_ID,
  Final_Region_ID,
  Product_ID,
  Final_Quantity,
  Sales_Value_EGP,
  Order_Date_Clean,
  Total_Weight_KG,
  Promised_Date,
  Order_Status
FROM fact_orders;

-- fact_deliveries view
CREATE VIEW V_Fact_Deliveries AS
SELECT 
  ROW_NUMBER() OVER (ORDER BY Deliveries_Surrogate_Key) AS Delivery_Fact_Key,
  Deliveries_Surrogate_Key,
  Delivery_ID,
  Order_ID,
  Trip_ID,
  Delivery_Date_Clean,
  Final_Delivered_Qty,
  Delivery_Status,
  Trip_ID_Status,
  Delivered_Qty_Status,
  Delivery_Date_Status,
  Deliveries_ID_Status
FROM fact_deliveries;

-- fact_trips view
CREATE VIEW V_fact_trips AS
SELECT 
  ROW_NUMBER() OVER (ORDER BY Trip_Surrogate_Key) AS Trip_Fact_Key,
  Trip_Surrogate_Key,
  Trip_ID,
  Region_ID,
  Final_Region_Name,
  Final_Vehicle_Type_ID,
  Transporter_ID,
  Number_Of_Vehicles,
  Loaded_Weight_KG,
  Capacity_KG,
  Final_Utilization_Rate,
  Trip_Cost_EGP,
  Distance_KM,
  Urgent_Order_Share,
  Trip_Status,
  Trip_Date_Clean,
  Vehicle_Type_Recovery_Status,
  Trip_Cost_Status,
  Transporter_ID_Status,
  Trip_Date_Status,
  Trip_ID_Status
FROM fact_trips;



-- fact_invoices view
CREATE VIEW V_fact_invoices AS
SELECT 
  ROW_NUMBER() OVER (ORDER BY Invoice_Surrogate_Key) AS Invoice_Fact_Key,
  Invoice_Surrogate_Key,
  Invoice_ID,
  Order_ID,
  Final_Invoiced_Qty,
  Invoice_Amount_EGP,
  Due_Date,
  Invoice_Status,
  Invoice_Date_Clean,
  Invoice_ID_Status,
  Invoiced_Qty_Status,
  Order_Link_Status
FROM fact_invoices;


-- fact_payments view
CREATE VIEW V_fact_payments AS
SELECT 
  ROW_NUMBER() OVER (ORDER BY Payment_Surrogate_Key) AS Payment_Fact_Key,
  Payment_Surrogate_Key,
  Payment_ID,
  Invoice_ID,
  Final_Paid_Amount_EGP,
  Payment_Method,
  Final_Payment_Status,
  Payment_Date_Clean,
  Payment_ID_Status,
  Paid_Amount_Status
FROM fact_payments;



-- dim_customer view
CREATE VIEW V_dim_customer AS
SELECT
  ROW_NUMBER() OVER (ORDER BY Customer_ID ) AS Customer_Dim_Key,
  Customer_ID,
  Customer_Code,
  Customer_Name,
  Region_ID,
  Customer_Type,
  Customer_Segment
FROM dim_customer;




-- dim_date view
CREATE VIEW V_dim_date AS
SELECT
  Date_Key AS Date_Dim_Key,
  Date,
  Day,
  Day_Name,
  Week_No,
  Month_No,
  Month_Name,
  Quarter,
  Year,
  Is_Weekend
FROM dim_date;



-- dim_product view
CREATE VIEW V_dim_product AS
SELECT
  ROW_NUMBER() OVER (ORDER BY Product_ID ) AS Product_Dim_Key,
  Product_ID,
  Product_Code,
  Product_Name,
  Category,
  Temperature_Class,
  Unit_Weight_KG,
  Standard_Unit_Price_EGP
FROM dim_product;



-- dim_region view
CREATE VIEW V_dim_region AS
SELECT
  ROW_NUMBER() OVER (ORDER BY Region_ID ) AS Region_Dim_Key,
 Region_ID,
 Region_Name,
 Governorate,
 Distance_Band,
 Distance_From_DC_KM,
 Base_Cost_Multiplier
FROM dim_region;




-- dim_transporter view
CREATE VIEW V_dim_transporter AS
SELECT
  ROW_NUMBER() OVER (ORDER BY Transporter_ID ) AS Transporter_Dim_Key,
 Transporter_ID,
 Transporter_Name,
 Rate_Factor,
 Service_Score
FROM dim_transporter;




-- dim_vehicletype view
CREATE VIEW V_dim_vehicletype AS
SELECT
  ROW_NUMBER() OVER (ORDER BY Vehicle_Type_ID ) AS Vehicletype_Dim_Key,
 Vehicle_Type_ID,
 Vehicle_Type,
 Capacity_KG,
 Cost_Factor,
 Base_Fixed_Cost_Factor
FROM dim_vehicletype;
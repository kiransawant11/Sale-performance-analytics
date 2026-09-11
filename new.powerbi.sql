/* =====================================================
   SALES ANALYTICS PROJECT
   ===================================================== */
CREATE DATABASE sales_analytics;

USE sales_analytics;

CREATE TABLE sales_data (
    Order_ID VARCHAR(30) NOT NULL,
    Order_Date DATE NOT NULL,
    Customer_ID VARCHAR(30),
    Customer_Name VARCHAR(150),
    Country VARCHAR(100),
    Region VARCHAR(100),
    State VARCHAR(100),
    City VARCHAR(100),
    Category VARCHAR(100),
    Sub_Category VARCHAR(100),
    Product VARCHAR(255),
    Quantity INT,
    Unit_Price DECIMAL(14 , 2 ),
    Discount DECIMAL(6 , 4 ),
    Sales DECIMAL(14 , 2 ),
    Cost DECIMAL(14 , 2 ),
    Profit DECIMAL(14 , 2 ),
    Payment_Mode VARCHAR(50),
    Expected_Sales DECIMAL(14 , 2 ),
    Sales_Check VARCHAR(20),
    Expected_Profit DECIMAL(14 , 2 ),
    Profit_Check VARCHAR(20),
    Order_Year YEAR,
    Order_Month_Number TINYINT,
    Order_Month VARCHAR(3),
    Order_Period CHAR(7),
    PRIMARY KEY (Order_ID),
    CONSTRAINT chk_quantity_positive CHECK (Quantity > 0),
    CONSTRAINT chk_unit_price_nonnegative CHECK (Unit_Price >= 0),
    CONSTRAINT chk_discount_range CHECK (Discount BETWEEN 0 AND 1),
    CONSTRAINT chk_sales_nonnegative CHECK (Sales >= 0),
    CONSTRAINT chk_cost_nonnegative CHECK (Cost >= 0)
);
SELECT 
    *
FROM
    sales_data;

USE sales_analytics;

UPDATE sales_data 
SET 
    Expected_Sales = ROUND(Quantity * Unit_Price * (1 - Discount),
            2),
    Sales_Check = CASE
        WHEN
            Sales IS NULL OR Quantity IS NULL
                OR Unit_Price IS NULL
                OR Discount IS NULL
        THEN
            'MISSING DATA'
        WHEN ABS(Sales - (Quantity * Unit_Price * (1 - Discount))) < 0.01 THEN 'OK'
        ELSE 'CHECK'
    END,
    Expected_Profit = ROUND(Sales - Cost, 2),
    Profit_Check = CASE
        WHEN
            Profit IS NULL OR Sales IS NULL
                OR Cost IS NULL
        THEN
            'MISSING DATA'
        WHEN ABS(Profit - (Sales - Cost)) < 0.01 THEN 'OK'
        ELSE 'CHECK'
    END,
    Order_Year = YEAR(Order_Date),
    Order_Month_Number = MONTH(Order_Date),
    Order_Month = DATE_FORMAT(Order_Date, '%b'),
    Order_Period = DATE_FORMAT(Order_Date, '%Y-%m');

SELECT 
    *
FROM
    sales_data;
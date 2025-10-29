create database yardi ;
use yardi ;

CREATE TABLE Property_Management (
    Property_ID INT PRIMARY KEY,
    Property_Type VARCHAR(20),
    Address VARCHAR(100),
    Units INT,
    Occupancy_Rate VARCHAR(10),
    Manager_Name VARCHAR(50),
    Investor_ID INT,
    Investment_Value DECIMAL(15,2),
    Investment_Date DATE,
    Debt_Oversight VARCHAR(5),
    Tenant_ID INT,
    Lease_Start DATE,
    Lease_End DATE,
    Rent_Monthly DECIMAL(10,2),
    Payment_Status VARCHAR(20),
    Maintenance_Ticket_ID INT,
    Maintenance_Issue VARCHAR(80),
    Maintenance_Status VARCHAR(20),
    Procurement_ID INT,
    Item_Description VARCHAR(60),
    Purchase_Date DATE,
    Purchase_Amount DECIMAL(10,2),
    Payment_Method VARCHAR(20),
    Energy_Solution_Enabled VARCHAR(5),
    Monthly_Energy_Cost DECIMAL(10,2),
    Sustainability_Score TINYINT,
    AI_Feature_Use VARCHAR(15),
    Last_AI_Analysis VARCHAR(20),
    Portfolio_Notes VARCHAR(120),
    Compliance_Flag CHAR(1)
);

select * from Property_Management ;

#1 Flag properties where compliance status has not been updated for over 90 days.
SELECT Property_ID, Address, Compliance_Flag, Last_AI_Analysis
FROM Property_Management
WHERE Compliance_Flag = 'N'
  AND (
    Last_AI_Analysis = 'NA'
    OR (DATEDIFF(CURDATE(), Last_AI_Analysis) > 90)
  );

#2 Find properties that use AI features but have compliance issues. 
SELECT Property_ID, Address, AI_Feature_Use, Compliance_Flag
FROM Property_Management
WHERE AI_Feature_Use IS NOT NULL AND Compliance_Flag = 'N';

#3 Which property has the highest occupancy rate?
SELECT Property_ID, Address, Occupancy_Rate
FROM Property_Management
ORDER BY CAST(REPLACE(Occupancy_Rate, '%', '') AS DECIMAL) DESC
LIMIT 1;

#4 Find the average occupancy rate by property type.
SELECT Property_Type,
       AVG(CAST(REPLACE(Occupancy_Rate, '%', '') AS DECIMAL)) AS Avg_Occupancy
FROM Property_Management
GROUP BY Property_Type;


#5 Calculate total investment and average rent per property type.
SELECT Property_Type,
       SUM(Investment_Value) AS Total_Investment,
       AVG(Rent_Monthly) AS Avg_Rent
FROM Property_Management
GROUP BY Property_Type;

#6 Find properties with energy costs above the average.
SELECT Property_ID, Address, Monthly_Energy_Cost
FROM Property_Management
WHERE Monthly_Energy_Cost > (
    SELECT AVG(Monthly_Energy_Cost) FROM Property_Management
);

#7 Count how many maintenance tickets are still open.
SELECT COUNT(*) AS Open_Tickets
FROM Property_Management
WHERE Maintenance_Status <> 'Resolved';

#8 Top 3 most frequent maintenance issues.
SELECT Maintenance_Issue, COUNT(*) AS Issue_Count
FROM Property_Management
GROUP BY Maintenance_Issue
ORDER BY Issue_Count DESC
LIMIT 3;

#9 Compare average sustainability score by energy solution status.
SELECT Energy_Solution_Enabled,
       AVG(Sustainability_Score) AS Avg_Score
FROM Property_Management
GROUP BY Energy_Solution_Enabled;

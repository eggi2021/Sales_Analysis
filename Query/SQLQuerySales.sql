
-- 1. Problem = Extracting Information From Historical Data Penjualan To Improve Business Profit

-- Menggunakan Database Sales Project
USE SalesProject

-- 2. Data Acqusition = Downloaded From GitHub Keith Galli

-- Melihat Data Penjualan
SELECT *
FROM SalesProject..Worksheet$

-- 3. Data Preparation = Prepare Data For Exploration Information

-- Melihat Data Penjualan Dengan Nilai Null
SELECT *
FROM SalesProject..Worksheet$
WHERE [Order ID] IS NULL

-- Data Cleaning For Null Value
DELETE
FROM SalesProject..Worksheet$
WHERE [Order ID] IS NULL

-- 4. Data Exploration = There Will Be 5 Question
-- Question 1 What was the Best Month for Sales ? How Much Earned That Month ?
-- Question 2 What City Sold the Most Product ?
-- Question 3 What Time Should We Display Advertisment to Maximize the Likelihood of Customer's Buying Product
-- Question 4 What Product are Most Often Sold Together
-- Question 5 What Product Sold the Most? Why Do You Think its Sold the Most ?

-- Answer ( 1 ) -> Terjawab

SELECT MONTH([Order Date]) AS Month, CONVERT(DECIMAL(10,2), SUM([Quantity Ordered]*[Price Each])) AS Hasil_Penjualan
FROM SalesProject..Worksheet$
GROUP BY MONTH([Order Date])
ORDER BY Month

-- Answer ( 2 ) -> Terjawab
SELECT DISTINCT
	 REVERSE(PARSENAME(REPLACE(REVERSE([Purchase Address]), ',', '.'), 2)) AS [City]
   , REVERSE(PARSENAME(REPLACE(REVERSE([Purchase Address]), ',', '.'), 3)) AS [Postal Code]
   , SUM([Quantity Ordered]) AS Product_Terjual
FROM SalesProject..Worksheet$
GROUP BY REVERSE(PARSENAME(REPLACE(REVERSE([Purchase Address]), ',', '.'), 2)), REVERSE(PARSENAME(REPLACE(REVERSE([Purchase Address]), ',', '.'), 3))
ORDER BY City

-- Answer ( 3 ) -> Terjawab
SELECT FORMAT ([Order Date], 'HH') as Jam_Beli, SUM([Quantity Ordered]) AS Jumlah_Beli
FROM SalesProject..Worksheet$
GROUP BY FORMAT ([Order Date], 'HH')
ORDER BY Jam_Beli

-- Answer ( 4 ) -> Belum Terjawab
SELECT [Order ID], STRING_AGG(Product,', ') AS Product
FROM SalesProject..Worksheet$
WHERE [Order ID] IN (
    SELECT [Order ID]
    FROM SalesProject..Worksheet$
    GROUP BY [Order ID]
    HAVING COUNT(*) > 1)
GROUP BY [Order ID]

-- Answer ( 5 ) -> Terjawab
SELECT Product, [Price Each], SUM([Quantity Ordered]) AS Total_Terjual
FROM SalesProject..Worksheet$
GROUP BY Product, [Price Each]
ORDER BY Total_Terjual DESC
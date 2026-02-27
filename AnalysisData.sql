-- Display all data from the analysis table
SELECT *
FROM `rakamin-kf-analytics-487308.kimia_farma.analysis_table`;

-- Compare net sales by year
SELECT 
    EXTRACT(YEAR FROM date) AS Year,
    SUM(net_sales) AS NetSales
FROM `rakamin-kf-analytics-487308.kimia_farma.analysis_table`
GROUP BY Year
ORDER BY Year;

-- Compare net profit by year
SELECT 
    EXTRACT(YEAR FROM date) AS Year,
    SUM(net_profit) AS NetProfit
FROM `rakamin-kf-analytics-487308.kimia_farma.analysis_table`
GROUP BY Year
ORDER BY Year;

-- Top 10 provinces based on total net sales
SELECT 
    provinsi AS Province,
    SUM(net_sales) AS NetSales
FROM `rakamin-kf-analytics-487308.kimia_farma.analysis_table`
GROUP BY provinsi
ORDER BY NetSales DESC
LIMIT 10;

-- Top 10 provinces based on transaction volume
SELECT 
    provinsi AS Province,
    COUNT(transaction_id) AS TotalTransactions
FROM `rakamin-kf-analytics-487308.kimia_farma.analysis_table`
GROUP BY provinsi
ORDER BY TotalTransactions DESC
LIMIT 10;

-- Count total distinct products and branches
SELECT 
    COUNT(DISTINCT product_id) AS TotalProducts,
    COUNT(DISTINCT branch_id) AS TotalBranches
FROM `rakamin-kf-analytics-487308.kimia_farma.analysis_table`;

-- Top 5 branches with highest branch rating but lowest transaction rating
SELECT 
    kota AS City,
    AVG(rating_cabang) AS AvgBranchRating,
    AVG(rating_transaksi) AS AvgTransactionRating
FROM `rakamin-kf-analytics-487308.kimia_farma.analysis_table`
GROUP BY kota
ORDER BY AvgBranchRating DESC, AvgTransactionRating ASC
LIMIT 5;

-- Top 5 most sold products by transaction volume
WITH ProductCTE AS (
    SELECT 
        product_name,
        COUNT(transaction_id) AS TotalTransactions
    FROM `rakamin-kf-analytics-487308.kimia_farma.analysis_table`
    GROUP BY product_name
)

SELECT 
    product_name,
    TotalTransactions,
    ROUND(100 * TotalTransactions / SUM(TotalTransactions) OVER(), 2) AS Percentage
FROM ProductCTE
ORDER BY TotalTransactions DESC
LIMIT 5;

-- Total number of transactions
SELECT 
    COUNT(DISTINCT transaction_id) AS TotalTransactions
FROM `rakamin-kf-analytics-487308.kimia_farma.analysis_table`;

-- Total net sales across all years
SELECT 
    SUM(net_sales) AS TotalNetSales
FROM `rakamin-kf-analytics-487308.kimia_farma.analysis_table`;

-- Total Net Sales per Year
SELECT 
    EXTRACT(YEAR FROM date) AS Year,
    SUM(net_sales) AS TotalNetSales
FROM `rakamin-kf-analytics-487308.kimia_farma.analysis_table`
GROUP BY Year
ORDER BY Year ASC;

-- Profit margin per year
SELECT 
    EXTRACT(YEAR FROM date) AS Year,
    ROUND(SUM(net_profit) / SUM(net_sales) * 100, 2) AS ProfitMarginPercentage
FROM `rakamin-kf-analytics-487308.kimia_farma.analysis_table`
GROUP BY Year
ORDER BY Year;

-- Average transaction value per province
WITH ProvinceCTE AS (
    SELECT 
        provinsi,
        SUM(net_sales) AS TotalNetSales,
        COUNT(DISTINCT transaction_id) AS TransactionVolume
    FROM `rakamin-kf-analytics-487308.kimia_farma.analysis_table`
    GROUP BY provinsi
)

SELECT 
    provinsi AS Province,
    ROUND(TotalNetSales / TransactionVolume, 2) AS AvgTransactionValue
FROM ProvinceCTE
ORDER BY AvgTransactionValue DESC
LIMIT 10;

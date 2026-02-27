-- Display the relevant attributes that will be used later in data analysis
SELECT
    t.transaction_id,
    t.date,
    t.branch_id,
    kc.branch_name,
    kc.kota,
    kc.provinsi,
    kc.rating AS rating_cabang,
    t.customer_name,
    t.product_id,
    p.product_name,
    t.price AS actual_price,
    t.discount_percentage,

    -- Gross profit percentage based on price range
    CASE
        WHEN t.price <= 50000 THEN 0.10
        WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
        WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
        WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
        ELSE 0.30
    END AS gross_profit_percentage,

    -- Net sales (price after discount)
    t.price * (1 - t.discount_percentage) AS net_sales,

    -- Net profit
    t.price * (1 - t.discount_percentage) *
    CASE
        WHEN t.price <= 50000 THEN 0.10
        WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
        WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
        WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
        ELSE 0.30
    END AS net_profit,

    t.rating AS rating_transaksi

FROM `rakamin-kf-analytics-487308.kimia_farma.kf_final_transaction` t
LEFT JOIN `rakamin-kf-analytics-487308.kimia_farma.kf_product` p
    ON t.product_id = p.product_id
LEFT JOIN `rakamin-kf-analytics-487308.kimia_farma.kf_kantor_cabang` kc
    ON t.branch_id = kc.branch_id;

-- Create a new table to store all of the relevant attributes
CREATE OR REPLACE TABLE 
`rakamin-kf-analytics-487308.kimia_farma.analysis_table` AS
SELECT
    t.transaction_id,
    t.date,
    t.branch_id,
    kc.branch_name,
    kc.kota,
    kc.provinsi,
    kc.rating AS rating_cabang,
    t.customer_name,
    t.product_id,
    p.product_name,
    t.price AS actual_price,
    t.discount_percentage,

    CASE
        WHEN t.price <= 50000 THEN 0.10
        WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
        WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
        WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
        ELSE 0.30
    END AS gross_profit_percentage,

    t.price * (1 - t.discount_percentage) AS net_sales,

    t.price * (1 - t.discount_percentage) *
    CASE
        WHEN t.price <= 50000 THEN 0.10
        WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
        WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
        WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
        ELSE 0.30
    END AS net_profit,

    t.rating AS rating_transaksi

FROM `rakamin-kf-analytics-487308.kimia_farma.kf_final_transaction` t
LEFT JOIN `rakamin-kf-analytics-487308.kimia_farma.kf_product` p
    ON t.product_id = p.product_id
LEFT JOIN `rakamin-kf-analytics-487308.kimia_farma.kf_kantor_cabang` kc
    ON t.branch_id = kc.branch_id;


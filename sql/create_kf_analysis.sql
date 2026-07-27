CREATE OR REPLACE TABLE
  `rakamin-kf-analytics-503414.kimia_farma.kf_analysis` AS

WITH joined_data AS (
  SELECT
    t.transaction_id,
    t.date,
    t.branch_id,
    c.branch_name,
    c.kota,
    c.provinsi,
    c.rating AS rating_cabang,
    t.customer_name,
    t.product_id,
    p.product_name,
    t.price AS actual_price,
    t.discount_percentage,

    CASE
      WHEN t.price <= 50000 THEN 0.10
      WHEN t.price <= 100000 THEN 0.15
      WHEN t.price <= 300000 THEN 0.20
      WHEN t.price <= 500000 THEN 0.25
      ELSE 0.30
    END AS persentase_gross_laba,

    t.rating AS rating_transaksi

  FROM
    `rakamin-kf-analytics-503414.kimia_farma.kf_final_transaction` AS t

  LEFT JOIN
    `rakamin-kf-analytics-503414.kimia_farma.kf_kantor_cabang` AS c
    ON t.branch_id = c.branch_id

  LEFT JOIN
    `rakamin-kf-analytics-503414.kimia_farma.kf_product` AS p
    ON t.product_id = p.product_id
)

SELECT
  transaction_id,
  date,
  branch_id,
  branch_name,
  kota,
  provinsi,
  rating_cabang,
  customer_name,
  product_id,
  product_name,
  actual_price,
  discount_percentage,
  persentase_gross_laba,

  ROUND(
    actual_price * (1 - discount_percentage),
    2
  ) AS nett_sales,

  ROUND(
    actual_price
    * (1 - discount_percentage)
    * persentase_gross_laba,
    2
  ) AS nett_profit, 
  
  rating_transaksi

FROM joined_data;

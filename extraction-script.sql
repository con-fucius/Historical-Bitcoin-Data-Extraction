WITH recent_transactions AS (
  SELECT
    block_time,
    output_value AS price,
    CARDINALITY(output) AS transaction_count,
    _u.value AS amount,
    _u.script_pub_key.address AS wallet_address
  FROM bitcoin.transactions
  CROSS JOIN UNNEST(output) AS _u(index, script_pub_key, value)
  WHERE
    block_time > CURRENT_DATE - INTERVAL '3' MONTH
), wallet_transaction_counts AS (
  SELECT
    wallet_address,
    COUNT(*) AS transaction_count
  FROM recent_transactions
  GROUP BY
    wallet_address
  HAVING
    COUNT(*) BETWEEN 5 AND 30
)
SELECT
  rt.block_time AS transaction_datetime,
  rt.price,
  rt.amount,
  wtc.wallet_address,
  wtc.transaction_count
FROM wallet_transaction_counts AS wtc
JOIN recent_transactions AS rt
  ON wtc.wallet_address = rt.wallet_address

# Bitcoin Transaction Analysis Query

This SQL script is designed to analyze recent Bitcoin transactions and identify wallets with moderate activity levels. The query focuses on extracting and filtering transaction data from the last three months.

## Overview

The query accomplishes the following:

1. **Extracts Recent Transactions**:
   - Filters Bitcoin transactions occurring in the past three months.
   - Unnests transaction outputs to include individual output values, amounts, and associated wallet addresses.
   
2. **Identifies Wallets with Moderate Activity**:
   - Groups wallets by their transaction count.
   - Selects wallets with transaction counts between 5 and 30 (inclusive).

3. **Combines Data**:
   - Joins the recent transactions data with the filtered wallets to provide detailed information about their transactions.

## Query Breakdown

### Step 1: `recent_transactions` CTE
- **Purpose**: Extracts individual transaction outputs from the Bitcoin transactions table for the last three months.
- **Columns Extracted**:
  - `block_time`: Timestamp of the transaction.
  - `price`: Output value of the transaction.
  - `transaction_count`: Total number of outputs in the transaction.
  - `amount`: Value associated with a specific output.
  - `wallet_address`: Wallet address associated with the output's script public key.
- **Filter**: Includes only transactions that occurred after the date `CURRENT_DATE - INTERVAL '3' MONTH`.

### Step 2: `wallet_transaction_counts` CTE
- **Purpose**: Aggregates the number of transactions for each wallet and filters wallets with transaction counts between 5 and 30 (inclusive).
- **Columns Extracted**:
  - `wallet_address`: The address of the wallet.
  - `transaction_count`: The total number of transactions associated with the wallet.

### Step 3: Final Query
- **Purpose**: Joins the `recent_transactions` CTE with the `wallet_transaction_counts` CTE to retrieve transaction details for wallets with moderate activity levels.
- **Columns Selected**:
  - `transaction_datetime`: Timestamp of the transaction.
  - `price`: Output value of the transaction.
  - `amount`: Specific output value for the transaction.
  - `wallet_address`: Wallet address associated with the transaction.
  - `transaction_count`: Total number of transactions for the wallet.

## Use Case

This query is useful for:
- **Behavioral Analysis**: Identifying wallets with moderate activity for further study or monitoring.
- **Fraud Detection**: Detecting unusual patterns in wallet activity.
- **Research**: Studying transaction trends for specific wallet activity levels.

## Prerequisites

- Access to a database containing the `bitcoin.transactions` table with the following structure:
  - `block_time` (timestamp): The time of the transaction.
  - `output` (array): An array of transaction outputs, each containing:
    - `value`: The value of the output.
    - `script_pub_key.address`: The wallet address for the output.
  
## Customization

- **Adjust Time Period**: Modify `CURRENT_DATE - INTERVAL '3' MONTH` to change the time range of the analysis.
- **Activity Threshold**: Update `HAVING COUNT(*) BETWEEN 5 AND 30` to analyze wallets with different levels of activity.

## Example Output

| Transaction Datetime   | Price  | Amount | Wallet Address   | Transaction Count |
|-------------------------|--------|--------|------------------|-------------------|
| 2024-01-01 12:00:00    | 0.0023 | 0.0012 | 1A1zP1eP5QGefi2  | 10                |
| 2024-01-02 15:30:00    | 0.0035 | 0.0015 | 3J98t1WpEZ73CNm  | 7                 |

## License

This query is provided under the MIT License. Feel free to use and adapt it for your projects.

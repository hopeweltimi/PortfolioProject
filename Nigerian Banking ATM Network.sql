SELECT * 
FROM [dbo].[atm_network_full_sample]

-- Total transactions & total volume

SELECT COUNT(*) AS total_txns, SUM(amount_ngn) AS total_volume_ngn
FROM [dbo].[atm_network_full_sample]


--  Total volume & biggest withdrawal ever

SELECT 
    COUNT(*) AS total_txns,
    SUM(amount_ngn) AS total_volume_ngn,
    MAX(amount_ngn) AS biggest_withdrawal
FROM [dbo].[atm_network_full_sample];

-- Result: ₦200,000 single withdrawal!

-- Top 10 cash withdrawals

SELECT TOP 10 
   [transaction_id],[timestamp] , [card_issuer],[amount_ngn] ,[atm_state]
FROM [dbo].[atm_network_full_sample]
WHERE transaction_type = 'withdrawal'
ORDER BY amount_ngn DESC;

-- Failed vs Success rate by bank
SELECT 
    card_issuer,
    dispense_status,
    COUNT(*) AS cnt,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (PARTITION BY card_issuer), 2) AS pct
FROM [dbo].[atm_network_full_sample]
GROUP BY card_issuer, dispense_status
ORDER BY card_issuer, cnt DESC;

--  Partial dispense victims (bank owes them money!)

SELECT *
FROM [dbo].[atm_network_full_sample]
WHERE dispense_status = 'partial' AND amount_ngn > 0;

-- Fraud score 0-100

SELECT 
    transaction_id,
    amount_ngn,
    [timestamp],
    (CASE WHEN amount_ngn > 150000 THEN 30 ELSE 0 END +
     CASE WHEN DATEPART(HOUR, [timestamp]) BETWEEN 0 AND 5 THEN 25 ELSE 0 END +
     CASE WHEN card_issuer <> atm_owner THEN 20 ELSE 0 END +
     CASE WHEN dispense_status = 'partial' THEN 20 ELSE 0 END +
     CASE WHEN response_code <> '00' THEN 15 ELSE 0 END) AS fraud_risk_score
FROM [dbo].[atm_network_full_sample]
ORDER BY fraud_risk_score DESC;


--  Top 5 riskiest ATMs

SELECT TOP 5
    terminal_id,
    atm_owner,
    COUNT(*) AS txns,
    AVG(CASE WHEN fraud_risk_score > 70 THEN 1.0 ELSE 0 END) * 100 AS high_risk_pct
FROM (
    SELECT *, 
        (CASE WHEN amount_ngn > 150000 THEN 30 ELSE 0 END +
         CASE WHEN DATEPART(HOUR, [timestamp]) BETWEEN 0 AND 5 THEN 25 ELSE 0 END +
         CASE WHEN card_issuer <> atm_owner THEN 20 ELSE 0 END +
         CASE WHEN dispense_status = 'partial' THEN 20 ELSE 0 END) AS fraud_risk_score
    FROM [dbo].[atm_network_full_sample]
) t
GROUP BY terminal_id, atm_owner
ORDER BY high_risk_pct DESC;



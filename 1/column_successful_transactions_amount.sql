SELECT p."project_id", SUM(p."amount") AS "successful_transactions_amount"
FROM "payments" as p
WHERE p."status" = 3 AND p."test_transaction" = 0
GROUP BY p."project_id";
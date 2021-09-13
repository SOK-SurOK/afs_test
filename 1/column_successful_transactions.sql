SELECT p."project_id", COUNT(p."status") AS "successful_transactions"
FROM "payments" as p
WHERE p."status" = 3 AND p."test_transaction" = 0
GROUP BY p."project_id";
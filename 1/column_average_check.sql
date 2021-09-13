SELECT p."project_id", AVG(p."amount") AS "average_check"
FROM "payments" as p
WHERE p."status" = 3 AND p."test_transaction" = 0
GROUP BY p."project_id";
SELECT p."project_id", MAX(p."amount") AS "max_amount_for_1_user"
FROM "payments" as p
WHERE (p."status" = 3 AND p."test_transaction" = 0)
	AND (STRFTIME('%s',p."payment_date") BETWEEN STRFTIME('%s','2020-10-01 00:00:00') AND STRFTIME('%s','now'))
GROUP BY p."project_id";
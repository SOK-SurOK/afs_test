SELECT p."nick", ROUND(STRFTIME('%s',p."payment_date") * 0.1) as "round_date", SUM(p."amount") AS "sum_amount_round_date_for_user"
FROM "payments" as p
WHERE (p."status" = 3 AND p."test_transaction" = 0)
GROUP BY p."nick", "round_date";
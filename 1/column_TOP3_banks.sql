WITH
"top_banks" AS (
	SELECT b1."p_id", b1."card_bank", b1."bank_use",
		ROW_NUMBER() OVER (PARTITION BY b1."p_id" ORDER BY b1."bank_use" DESC) AS "place"
	FROM (
		SELECT p."project_id" AS "p_id", c."card_bank", COUNT(p."status") AS "bank_use"
		FROM "payments" as p
			INNER JOIN "card_payments" AS c
			ON p."id" = c."payment_id"
		WHERE p."status" = 3 AND p."test_transaction" = 0
		GROUP BY p."project_id", c."card_bank"
	) AS b1
),
"top3_banks" AS (
	SELECT bb1."p_id", bb1."card_bank" || ", " || IFNULL(bb2."card_bank", '-') || ", " || IFNULL(bb3."card_bank", '-') as "TOP3_banks" 
	FROM (SELECT * FROM "top_banks" WHERE "place" = 1) AS bb1
		LEFT JOIN 
		(SELECT * FROM "top_banks" WHERE "place" = 2) AS bb2
		ON bb1."p_id" = bb2."p_id"
		LEFT JOIN
		(SELECT * FROM "top_banks" WHERE "place" = 3) AS bb3
		ON bb1."p_id" = bb3."p_id"
)
SELECT * FROM "top3_banks"
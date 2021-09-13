WITH
"part0" AS (
	SELECT g."game_id", g."game_id" || "." || g."game_name" AS "project"
	FROM "games" AS g
),
"part1" AS (
	SELECT p."project_id", COUNT(p."status") AS "successful_transactions",
		SUM(p."amount") AS "successful_transactions_amount",
		AVG(p."amount") AS "average_check"
	FROM "payments" as p
	WHERE p."status" = 3 AND p."test_transaction" = 0
	GROUP BY p."project_id"
),
"part2" AS (
	SELECT p."project_id", MAX(p."amount") AS "max_amount_for_1_user"
	FROM "payments" as p
	WHERE (p."status" = 3 AND p."test_transaction" = 0)
		AND (STRFTIME('%s',p."payment_date") BETWEEN STRFTIME('%s','2020-10-01 00:00:00') AND STRFTIME('%s','now'))
	GROUP BY p."project_id"
),
"top_systems" AS (
	SELECT s1."p_id", s1."p_system", s1."system_use",
		ROW_NUMBER() OVER (PARTITION BY s1."p_id" ORDER BY s1."system_use" DESC) AS "place"
	FROM (
		SELECT p."project_id" AS "p_id", p."payment_system" AS "p_system", COUNT(p."status") AS "system_use"
		FROM "payments" as p
		WHERE p."status" = 3 AND p."test_transaction" = 0
		GROUP BY p."project_id", p."payment_system"
	) AS s1
),
"top3_systems" AS (
SELECT ss1."p_id", ss1."p_system" || ", " || IFNULL(ss2."p_system", '-') || ", " || IFNULL(ss3."p_system", '-') as "TOP3_most_popular_ps" 
FROM (SELECT * FROM "top_systems" WHERE "place" = 1) AS ss1
	LEFT JOIN 
	(SELECT * FROM "top_systems" WHERE "place" = 2) AS ss2
	ON ss1."p_id" = ss2."p_id"
	LEFT JOIN
	(SELECT * FROM "top_systems" WHERE "place" = 3) AS ss3
	ON ss1."p_id" = ss3."p_id"
),
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
SELECT p0."project", p1."successful_transactions", p1."successful_transactions_amount", p1."average_check",
	p2."max_amount_for_1_user", ts."TOP3_most_popular_ps", tb."TOP3_banks"
FROM "part0" AS p0
	INNER JOIN "part1" AS p1 ON p0."game_id" = p1."project_id"
	INNER JOIN "part2" AS p2 ON p0."game_id" = p2."project_id"
	INNER JOIN "top3_systems" AS ts ON p0."game_id" = ts."p_id"
	INNER JOIN "top3_banks" AS tb ON p0."game_id" = tb."p_id"
;
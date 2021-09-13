WITH 
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
	)
SELECT * FROM "top3_systems"
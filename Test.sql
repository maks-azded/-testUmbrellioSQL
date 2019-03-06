--TABLE-------------------------------------------------------
CREATE temp TABLE users(id BIGSERIAL, group_id BIGINT);
INSERT INTO users(group_id) VALUES (1), (1), (1), (2), (1), (3);
--SQL1--------------------------------------------------------
SELECT u.id min_id, u.group_id, lead(u.id, 1, u.id + 1) over (
ORDER BY u.id) - u.id COUNT
FROM users u
LEFT JOIN users u2 ON u2.id = u.id - 1
WHERE u2.id IS NULL OR u2.group_id != u.group_id;
--SQL2--------------------------------------------------------
SELECT id min_id, group_id, lead(id, 1, id + 1) over (
ORDER BY id) - id COUNT
FROM (
SELECT id, group_id, CASE WHEN group_id <> lead(group_id, -1, group_id - 1) over (
ORDER BY id) THEN 'X' END ok
FROM users
) AS f
WHERE ok IS NOT NULL
ORDER BY id
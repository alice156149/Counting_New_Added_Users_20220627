/* CREATED BY: HIEN DO
   CREATED ON: 2022-06-27
   DESCRIPTION: Create a report that show the numbers of new users were added
   everday from the webiste after substract the deleted and merged users.
*/
SELECT
    new.day,
    new.new_added_users,
    COALESCE(deleted.deleted_users,0) AS deleted_users,
    COALESCE(merged.merged_users,0) AS merged_users,
    (new.new_added_users - COALESCE(deleted.deleted_users,0) - COALESCE(merged.merged_users,0)) AS net_users_added
FROM
  (SELECT
	  date(created_at) AS day,
          COUNT(*)         AS new_added_users
  FROM 
	  dsv1069.users
  GROUP BY
	  date(created_at)
          ) new
LEFT OUTER JOIN    
  (SELECT
	date(deleted_at) AS day,
        COUNT(*)   AS deleted_users
  FROM 
	dsv1069.users
  WHERE
	deleted_at IS NOT NULL
  GROUP BY 
	date(deleted_at)
        ) AS deleted
ON deleted.day = new.day
LEFT JOIN 
  (SELECT
	date(merged_at) AS day,
        COUNT(*)        AS merged_users
  FROM 
	dsv1069.users
  WHERE
	id <> parent_user_id
	AND 
	parent_user_id IS NOT NULL
  GROUP BY 
	date(merged_at)
        ) AS merged
ON merged.day = new.day
ORDER BY
	new.day DESC



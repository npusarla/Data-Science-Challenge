/* Assumptions for this Question: 

1) For this question, I am assuming that there is a one to one relationship between OAuth_Id and Ads_User_Id. I make this assumption, because I am also assuming that the OAuth_id in the OAuth_Id_Service table is its primary key and therefore, must be unique. 


Logic for this question: 
Because we want to see content only by active users, we must determine the active users, which we can do by using our previous query that counted the number of active users for the latest full week. For us to determine which content was viewed only by active users, we must only keep the rows of the ad service interaction data that was viewed by those users in the timeframe. After figuring out which rows of the ads_service_interaction_data to keep, we also should make another table at the same time that shows the popularity of each content page, similar to question 1. Now, when we join these two tables, we will have a massive table that contains the content id, type, number of times its been visited, ads_user_id (to make sure this table only includes content that was accessed by active users in the latest full week). From this, we can extrapolate the top five pieces of content from each type by partitioning by type, and ordering by page impressions.  

*/

SELECT overall_table.* 
FROM (
	SELECT content_count.*, row_number() AS rn
	over (PARTITION BY content_count.content_type
			ORDER BY content_count.impressions DESC)
	FROM (
		SELECT c.*, p.impressions, p.Ads_user_id
		FROM Content_Metadata c 
		JOIN ( 
			SELECT content_id, COUNT(content_id) AS impressions, Ads_user_id
			FROM Page_Impression
			GROUP BY content_id
			) AS p 
		ON c.content_id = p.content_id ) AS content_count
	JOIN (
		SELECT a.Ads_User_Id
		FROM OAuth_id_service u 
		JOIN Ads_Service_interaction_Data a 
		ON u.ads_user_id = a.ads_user_id
		WHERE a.Timestamp Between DATEADD(dd, DATEPART(DW, GETDATE())*-1-5, GETDATE()) AND <= DATEADD(dd, DATEPART(DW, GETDATE())*-1+1, GETDATE())
		AND SUM(a.dwell_time) > 60  
		GROUP BY u.OAuth_id
		) AS au
	ON content_count.Ads_User_id = au.Ads_User_id ) AS overall_table
WHERE overall_table.rn <= 5

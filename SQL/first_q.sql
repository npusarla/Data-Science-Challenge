/* Assumptions for this question: 

1) The popularity for a piece is represented by the number of its page impressions for that week.

2) We want to return the most popular pieces and all the information on these pieces, so we return all the columns from the Content_Metadata table. 

3) 'This week' represents the last 7 days starting from the current date, so when we find the top 5 pieces and currently it's a Thursday, we will be finding the most looked at pages from last Thursday to today.  

Logic of my Query: 
From above, the way I decided popularity was based on the number of page impressions. Therefore, I wanted to find a way to get the count of content_id in the Page Impression table. Instead of using a computationally costly JOIN to join the page_impression and content_metadata table, which would crossover millions of rows, I created a separate table using the page_impression table that grouped the contentID and kept track of its count within the given time frame of the past week. Now, I joined this table, which now only has the same number of rows as the content_metadata table, with content_metadata to sort the overall table by its content_id count in descending order and return the top 5. 

*/

SELECT c*
FROM Content_Metadata c  
JOIN
	(
	SELECT content_id, COUNT(content_id) AS impressions 
	FROM Page_Impression 
	WHERE Timestamp between date_sub(now(), INTERVAL 1 WEEK) and now()
	GROUP BY content_id 
	) AS id_count
ON c.content_id = id_count.content_id
ORDER BY id_count.impressions DESC
LIMIT 5; 



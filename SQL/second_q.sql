/* Assumptions for this question: 

1) I am assuming that Timestamp in the OAuth_id_service table is when the user registered, and the Timestamp in the Ad_Service_interaction_data table is when the user interacted with the ad, meaning they were on the content page that the ad was on and had a dwell time associated with it. 

Logic of my Query: 
Because there is one registered user to one auth_id service, I joined the OAuth_Id_Service table to the Ad_Service_Interaction_Data table on ads_user_id, this way we can see which user accessed which ads for a specific dwell time and at which date. Therefore, we choose the users that have accessed the ads between a certain time frame, and sum up their dwell time to determine if they are considered an active user or not. We only keep the users that have a dwell time in the given week of greater than 60, and return the count of these users. 

*/ 


SELECT COUNT(OAuth_id) AS weekly_active_users
FROM Ads_Service_Interaction_Data a
JOIN OAuth_id_Service o
ON a.Ads_user_id = o.Ads_user_id
WHERE a.Timestamp Between DATEADD(dd, DATEPART(DW, GETDATE())*-1-5, GETDATE()) AND <= DATEADD(dd, DATEPART(DW, GETDATE())*-1+1, GETDATE())
AND SUM(a.dwell_time) > 60  
GROUP BY o.OAuth_id; 


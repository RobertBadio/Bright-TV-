SELECT 
  UserID,
  Gender,
  Race,
  Age,
  CASE 
    WHEN Age BETWEEN 0 AND 17 THEN '00-17 (Youth)'
    WHEN Age BETWEEN 18 AND 24 THEN '18-24 (Young Adult)'
    WHEN Age BETWEEN 25 AND 34 THEN '25-34 (Adult)'
    WHEN Age BETWEEN 35 AND 44 THEN '35-44 (Middle Age)'
    WHEN Age BETWEEN 45 AND 54 THEN '45-54 (Mature)'
    WHEN Age >= 55 THEN '55+ (Senior)'
    ELSE 'Unknown'
  END as Age_Group,
  Province,
  Name,
  Surname,
  Email,
  Social_Media_Handle,
  Channel2 as Channel,
  CASE 
    WHEN Channel2 IN ('Supersport Live Events', 'ICC Cricket World Cup 2011', 'SuperSport Blitz', 'DStv Events 1', 'Wimbledon') 
      THEN 'Sports'
    WHEN Channel2 IN ('Channel O', 'Trace TV', 'MTV Base') 
      THEN 'Music'
    WHEN Channel2 IN ('Africa Magic', 'M-Net', 'Vuzu', 'kykNET', 'MK') 
      THEN 'Entertainment'
    WHEN Channel2 IN ('Cartoon Network', 'Boomerang') 
      THEN 'Kids'
    WHEN Channel2 IN ('E! Entertainment') 
      THEN 'Lifestyle'
    WHEN Channel2 IN ('CNN') 
      THEN 'News'
    WHEN Channel2 IN ('SawSee', 'Sawsee') 
      THEN 'Religious'
    ELSE 'Other'
  END as Channel_Category,
  RecordDate_SA as View_DateTime,
  RecordDate_SA_Date as View_Date,
  RecordTime_SA as View_Time,
  YEAR(RecordDate_SA) as Year,
  MONTH(RecordDate_SA) as Month,
  date_format(RecordDate_SA, 'MMMM') as Month_Name,
  DAY(RecordDate_SA) as Day,
  date_format(RecordDate_SA, 'EEEE') as Day_of_Week,
  WEEKOFYEAR(RecordDate_SA) as Week_Number,
  DAYOFWEEK(RecordDate_SA) as Day_of_Week_Number,

  HOUR(RecordDate_SA) as Hour_of_Day,
  CASE 
    WHEN HOUR(RecordDate_SA) BETWEEN 0 AND 5 THEN '1. Late Night (00-05)'
    WHEN HOUR(RecordDate_SA) BETWEEN 6 AND 11 THEN '2. Morning (06-11)'
    WHEN HOUR(RecordDate_SA) BETWEEN 12 AND 17 THEN '3. Afternoon (12-17)'
    WHEN HOUR(RecordDate_SA) BETWEEN 18 AND 23 THEN '4. Prime Time (18-23)'
  END as Time_of_Day,
  
  CASE 
    WHEN HOUR(RecordDate_SA) BETWEEN 6 AND 17 THEN 'Daytime (06-17)'
    WHEN HOUR(RecordDate_SA) BETWEEN 18 AND 23 THEN 'Evening (18-23)'
    ELSE 'Night (00-05)'
  END as Day_Part,
  
  Duration_Formatted,
  CAST(SPLIT(Duration_Formatted, ':')[0] AS INT) * 3600 + 
  CAST(SPLIT(Duration_Formatted, ':')[1] AS INT) * 60 + 
  CAST(SPLIT(Duration_Formatted, ':')[2] AS INT) as Duration_Seconds,
  
  ROUND((CAST(SPLIT(Duration_Formatted, ':')[0] AS INT) * 3600 + 
         CAST(SPLIT(Duration_Formatted, ':')[1] AS INT) * 60 + 
         CAST(SPLIT(Duration_Formatted, ':')[2] AS INT)) / 60.0, 2) as Duration_Minutes,
  
  CASE 
    WHEN (CAST(SPLIT(Duration_Formatted, ':')[0] AS INT) * 3600 + 
          CAST(SPLIT(Duration_Formatted, ':')[1] AS INT) * 60 + 
          CAST(SPLIT(Duration_Formatted, ':')[2] AS INT)) = 0 THEN 'No Duration'
    WHEN (CAST(SPLIT(Duration_Formatted, ':')[0] AS INT) * 3600 + 
          CAST(SPLIT(Duration_Formatted, ':')[1] AS INT) * 60 + 
          CAST(SPLIT(Duration_Formatted, ':')[2] AS INT)) < 60 THEN '< 1 min'
    WHEN (CAST(SPLIT(Duration_Formatted, ':')[0] AS INT) * 3600 + 
          CAST(SPLIT(Duration_Formatted, ':')[1] AS INT) * 60 + 
          CAST(SPLIT(Duration_Formatted, ':')[2] AS INT)) < 300 THEN '1-5 mins'
    WHEN (CAST(SPLIT(Duration_Formatted, ':')[0] AS INT) * 3600 + 
          CAST(SPLIT(Duration_Formatted, ':')[1] AS INT) * 60 + 
          CAST(SPLIT(Duration_Formatted, ':')[2] AS INT)) < 900 THEN '5-15 mins'
    WHEN (CAST(SPLIT(Duration_Formatted, ':')[0] AS INT) * 3600 + 
          CAST(SPLIT(Duration_Formatted, ':')[1] AS INT) * 60 + 
          CAST(SPLIT(Duration_Formatted, ':')[2] AS INT)) < 1800 THEN '15-30 mins'
    ELSE '30+ mins'
  END as Duration_Bucket,

  RecordDate_UTC,
  Duration_UTC,
  
  CASE WHEN Province = 'Unknown' THEN 1 ELSE 0 END as Has_Unknown_Province,
  CASE WHEN Gender = 'Unknown' THEN 1 ELSE 0 END as Has_Unknown_Gender,
  CASE WHEN Race = 'Unknown' THEN 1 ELSE 0 END as Has_Unknown_Race,
  CASE WHEN Age = 0 THEN 1 ELSE 0 END as Has_Unknown_Age,
  
  CASE 
    WHEN date_format(RecordDate_SA, 'EEEE') IN ('Saturday', 'Sunday') THEN 'Weekend'
    ELSE 'Weekday'
  END as Weekend_Flag,
  1 as View_Count
  
FROM workspace.default.bright_tv_cleaned
ORDER BY RecordDate_SA DESC;

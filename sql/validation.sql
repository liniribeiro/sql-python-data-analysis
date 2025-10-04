-- select sample of data for manual inspection
SELECT * FROM user_session ORDER BY RANDOM() LIMIT 10;

-- Count total rows
SELECT COUNT(*) FROM user_session;

-- Check for nulls in critical columns
SELECT COUNT(*) FROM user_session WHERE user_id IS NULL;


-- Check for duplicate sessions
SELECT user_id, timestamp, COUNT(*)
FROM user_session
GROUP BY user_id, timestamp
HAVING COUNT(*) > 1;

-- Check for future timestamps
SELECT * FROM user_session WHERE timestamp > CURRENT_TIMESTAMP;

-- Check for valid event_types types
SELECT DISTINCT event_type FROM user_session;

-- Check for valid event_types types against a predefined list
SELECT event_type
FROM user_session
WHERE event_type NOT IN ('click', 'view', 'purchase', 'login', 'logout')
GROUP BY event_type;

-- Count session per user
SELECT user_id, COUNT(*) AS session_count
FROM user_session
GROUP BY user_id
ORDER BY session_count DESC;

-- count events per type
SELECT event_type, COUNT(*) AS event_count
FROM user_session
GROUP BY event_type
ORDER BY event_count DESC;

-- Daily active users
SELECT DATE(timestamp) AS activity_date, COUNT(DISTINCT user_id) AS daily_active_users
FROM user_session
GROUP BY activity_date
ORDER BY activity_date DESC;

-- Peak activity hours
SELECT STRFTIME('%Y-%m-%d %H:00:00', timestamp) AS activity_hour, COUNT(*) AS event_count
FROM user_session
GROUP BY activity_hour
ORDER BY event_count DESC
LIMIT 10;

-- Sessions revenue by user
SELECT user_id, SUM(revenue) AS total_revenue
FROM user_session
WHERE revenue > 0
GROUP BY user_id
ORDER BY total_revenue DESC;


-- sessions per campaign
SELECT campaign, COUNT(*) AS session_count
FROM user_session
WHERE campaign IS NOT NULL
GROUP BY campaign
ORDER BY session_count DESC;


-- Revenue per country/device
SELECT geo_country, device_type, SUM(revenue) AS total_revenue
FROM user_session
WHERE revenue > 0
GROUP BY geo_country, device_type
ORDER BY total_revenue DESC;

-- Average revenue per user (ARPU).
SELECT AVG(user_revenue) AS arpu
FROM (
    SELECT user_id, SUM(revenue) AS user_revenue
    FROM user_session
    WHERE revenue > 0
    GROUP BY user_id
) AS user_revenues;

-- Conversion rate by campaign
SELECT campaign,
       COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) * 1.0 / COUNT(DISTINCT user_id) AS conversion_rate
FROM user_session
WHERE campaign IS NOT NULL
GROUP BY campaign
ORDER BY conversion_rate DESC;


-- Funnel drop-off (views → clicks → purchases).
WITH funnel AS (
    SELECT user_id,
           MAX(CASE WHEN event_type = 'view' THEN 1 ELSE 0 END) AS viewed,
           MAX(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) AS clicked,
           MAX(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS purchased
    FROM user_session
    GROUP BY user_id
)
SELECT
    SUM(viewed) AS total_views,
    SUM(clicked) AS total_clicks,
    SUM(purchased) AS total_purchases,
    SUM(clicked) * 1.0 / NULLIF(SUM(viewed), 0) AS click_through_rate,
    SUM(purchased) * 1.0 / NULLIF(SUM(clicked), 0) AS purchase_rate
FROM funnel;


-- Bounce rate (single-page sessions)
WITH session_counts AS (
    SELECT user_id, COUNT(*) AS event_count
    FROM user_session
    GROUP BY user_id
)
SELECT
    COUNT(*) AS total_sessions,
    SUM(CASE WHEN event_count = 1 THEN 1 ELSE 0 END) AS single_page_sessions,
    SUM(CASE WHEN event_count = 1 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS bounce_rate
FROM session_counts;

-- Repeat visitor rate
WITH user_sessions AS (
    SELECT user_id, COUNT(DISTINCT DATE(timestamp)) AS active_days
    FROM user_session
    GROUP BY user_id
)
SELECT
    COUNT(*) AS total_users,
    SUM(CASE WHEN active_days > 1 THEN 1 ELSE 0 END) AS repeat_visitors,
    SUM(CASE WHEN active_days > 1 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) AS repeat_visitor_rate
FROM user_sessions;

-- Top products by views and purchases
SELECT product_id,
       COUNT(CASE WHEN event_type = 'view' THEN 1 END) AS view_count,
       COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) AS purchase_count
FROM user_session
WHERE product_id IS NOT NULL
GROUP BY product_id
ORDER BY purchase_count DESC, view_count DESC
LIMIT 10;


-- views without purchases
SELECT count(*) AS sessions_with_views_no_purchases
FROM user_session
WHERE event_type IN ('view', 'purchase')
GROUP BY session_id
HAVING SUM(CASE WHEN event_type = 'view' THEN 1 ELSE 0 END) > 0
   AND SUM(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) = 0;
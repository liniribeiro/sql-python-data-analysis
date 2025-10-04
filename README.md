# sql-python-data-analysis
Data analysis project combining SQL and Python to explore and visualize datasets, demonstrating data cleaning, aggregation, and reporting techniques


Dataset: [Synthetic User Sessions](https://huggingface.co/datasets/liniribeiro/synthetic-user-sessions)


Things to understand about the user tracking:

- Who is the user?
- What session are they in?
- What actions are they taking?
- On what device, location, and time?
- What page, product, or content are they interacting with?
- Did they generate revenue? 


Important fields for session tracking:

| Column             | Why it’s important                                                |
| ------------------ | ----------------------------------------------------------------- |
| **user_id**        | Unique identifier for the user (can be anonymized).               |
| **session_id**     | Groups all events of a session (navigation, clicks, etc.).        |
| **timestamp**      | Time of event (used for ordering, session length, trends).        |
| **event_type**     | Type of interaction (view, click, scroll, add_to_cart, purchase). |
| **page_name**      | The page the user is on (e.g., `/home`, `/product/123`).          |
| **product_id**     | If event relates to a product.                                    |
| **device_type**    | Mobile, desktop, tablet.                                          |
| **browser**        | Chrome, Safari, Firefox… useful for debugging/tracking.           |
| **os**             | Operating system.                                                 |
| **geo_country**    | Where the user is located (from IP or GPS).                       |
| **geo_city**       | More granular location.                                           |
| **traffic_source** | Where they came from (google, facebook, direct, email).           |
| **campaign**       | Marketing campaign name (`summer_sale`, `retargeting`).           |
| **referrer_url**   | Previous page or site (helps with attribution).                   |
| **revenue**        | Amount generated (only for purchase events).                      |



Important metrics to calculate:
- Conversion rate per campaign
- Revenue per country/device
- Average revenue per user (ARPU)
- Funnel drop-off (views → clicks → purchases)
  - percentage of users who drop off at each stage of the funnel.
- Bounce rate (single-page sessions)
  - bounce rate = (single-page sessions / total sessions) * 100,
  - it is a measure of the percentage of visitors who navigate away from the site after viewing only one page.
- Repeat visitor rate:
  - percentage of users who return to the site within a specific time frame.
- Top products by views and purchases
- User retention over time (cohort analysis)
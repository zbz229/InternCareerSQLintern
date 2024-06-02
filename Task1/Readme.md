# Task 1: Spotify Dataset Analysis

---

Submitted To: [`InternCareer](https://www.linkedin.com/company/interncareers/posts/?feedView=all)`  

Submitted By: [`Muhammad Zuraiz Zia`](https://www.linkedin.com/in/zuraizzia/) 

# **Task Description and Submission Information**

## Description

**To perform data analysis using SQL queries** on the provided dataset, focusing on extracting meaningful insights and patterns.

## Submission Information

- Name: **Muhammad Zuraiz Zia**

- Task Completion Date: June 2nd

- Designation: SQL Developer Intern

- GitHub Repo Link: ‣

- Internship Start Date: May 14th, 2024

- Internship End Date: June 14th, 2024

---

# **Introduction**

## **Objective**

The primary objective of this project is to perform data analysis on a Spotify dataset using SQL queries. The goal is to extract meaningful insights and patterns from the data.

## **Dataset**

The dataset used for this project is [Spotify-data.csv](https://drive.google.com/drive/folders/1HWk0yOEE7yWC_mw1Ec7jxvyLtC-orqnZ?usp=drive_link). It contains various attributes of songs including their names, artists, duration, release dates, and various musical features.

---

# **Approach: Task and Problems:**

## 1. DATA EXPLORATION

### View the schema of the table:

```sql
PRAGMA table_info('spotify-data');
```

### Check for missing values in each field:

```sql
SELECT
    SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS id_missing,
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_missing,
    SUM(CASE WHEN artists IS NULL THEN 1 ELSE 0 END) AS artists_missing,
    SUM(CASE WHEN duration_ms IS NULL THEN 1 ELSE 0 END) AS duration_ms_missing,
    SUM(CASE WHEN release_date IS NULL THEN 1 ELSE 0 END) AS release_date_missing,
    SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS year_missing,
    SUM(CASE WHEN acousticness IS NULL THEN 1 ELSE 0 END) AS acousticness_missing,
    SUM(CASE WHEN danceability IS NULL THEN 1 ELSE 0 END) AS danceability_missing,
    SUM(CASE WHEN energy IS NULL THEN 1 ELSE 0 END) AS energy_missing,
    SUM(CASE WHEN instrumentalness IS NULL THEN 1 ELSE 0 END) AS instrumentalness_missing,
    SUM(CASE WHEN liveness IS NULL THEN 1 ELSE 0 END) AS liveness_missing,
    SUM(CASE WHEN loudness IS NULL THEN 1 ELSE 0 END) AS loudness_missing,
    SUM(CASE WHEN speechiness IS NULL THEN 1 ELSE 0 END) AS speechiness_missing,
    SUM(CASE WHEN tempo IS NULL THEN 1 ELSE 0 END) AS tempo_missing,
    SUM(CASE WHEN valence IS NULL THEN 1 ELSE 0 END) AS valence_missing,
    SUM(CASE WHEN mode IS NULL THEN 1 ELSE 0 END) AS mode_missing,
    SUM(CASE WHEN key IS NULL THEN 1 ELSE 0 END) AS key_missing,
    SUM(CASE WHEN popularity IS NULL THEN 1 ELSE 0 END) AS popularity_missing,
    SUM(CASE WHEN explicit IS NULL THEN 1 ELSE 0 END) AS explicit_missing
FROM "spotify-data";

```

### Check for Duplicate rows based on all fields:

```sql
SELECT
    id, name, artists, duration_ms, release_date, year, acousticness, danceability,
    energy, instrumentalness, liveness, loudness, speechiness, tempo, valence, mode, 
    key, popularity, explicit, COUNT(*) AS count
FROM "spotify-data"
GROUP BY
    id, name, artists, duration_ms, release_date, year, acousticness, danceability,
    energy, instrumentalness, liveness, loudness, speechiness, tempo, valence, mode, 
    key, popularity, explicit
HAVING COUNT(*) > 1;
```

Check for Anomalies in numeric fields, such as negative durations:

```sql
SELECT * FROM "spotify-data"
WHERE duration_ms < 0 OR loudness < 0 OR tempo < 0;
```

## 2. Basic Queries

### Select all tracks by a specific artist:

```sql
SELECT name, artists, duration_ms
FROM "spotify-data"
WHERE artists LIKE '%Artist Name%';
```

### Get the average duration of tracks released in a specific year:

```sql
SELECT year, AVG(duration_ms) AS avg_duration_ms
FROM "spotify-data"
WHERE year = 2020
GROUP BY year;
```

## 3. Join Operations

Note: **Since there is only one table in given dataset, I cannot us join operations on single table, let me assume…**

### **Example with `artist_details` Table:**

**Schema of `artist_details` Table (Assumption):**

- artist_id
- artist_name
- artist_genre

```sql
SELECT a.name AS track_name, b.artist_name, b.artist_genre
FROM "spotify-data" a
INNER JOIN artist_details b ON a.artists = b.artist_id;
```

### **Example with `album_details` Table:**

**Schema of `album_details` Table (Assumption):**

- album_id
- album_name
- release_year

```sql
SELECT a.name AS track_name, b.album_name, b.release_year
FROM "spotify-data" a
LEFT JOIN album_details b ON a.release_date = b.album_id;
```

## 4. Data Transformation

### Convert duration_ms to seconds (as a float):

```sql
SELECT name, duration_ms / 1000.0 AS duration_seconds
FROM "spotify-data";
```

### Replace NULL values in popularity with 0:

```sql
SELECT name, COALESCE(popularity, 0) AS popularity
FROM "spotify-data";
```

### **Extract the year from the release_date:**

```sql
SELECT name, SUBSTR(release_date, -4) AS release_year
FROM "spotify-data";
```

### Count the number of explicit tracks:

```sql
SELECT COUNT(*) AS explicit_tracks
FROM "spotify-data"
WHERE explicit = 1;
```

## 5. COMPLEX QUERIES AND ANALYSIS

### Subqueries to Find the most popular track for each year:

```sql
SELECT name, artists, year, popularity
FROM "spotify-data" a
WHERE popularity = (SELECT MAX(b.popularity)
                    FROM "spotify-data" b
                    WHERE a.year = b.year);
```

### Trend Analysis: Average popularity trend over the years:

```sql
SELECT year, AVG(popularity) AS avg_popularity
FROM "spotify-data"
GROUP BY year
ORDER BY year;
```

### Outliers: Find tracks with a duration of more than 2 standard deviations from the mean…

```sql
WITH stats AS (
    SELECT AVG(duration_ms) AS mean_duration, 
           STDEV(duration_ms) AS stddev_duration
    FROM "spotify-data"
)
SELECT a.*
FROM "spotify-data" a, stats s
WHERE a.duration_ms > s.mean_duration + 2 * s.stddev_duration
   OR a.duration_ms < s.mean_duration - 2 * s.stddev_duration;
```

### Calculating Metrics:

- Total number of tracks…
    
    ```sql
    SELECT COUNT(*) AS total_tracks
    FROM "spotify-data";
    ```
    
- The average duration of tracks in milliseconds…
    
    ```sql
    SELECT AVG(duration_ms) AS avg_duration_ms
    FROM "spotify-data";
    ```
    
- The total duration of tracks released each year…
    
    ```sql
    SELECT year, SUM(duration_ms) AS total_duration_ms
    FROM "spotify-data"
    GROUP BY year
    ORDER BY year;
    ```
    
- Find the most common musical key in tracks…
    
    ```sql
    SELECT key, COUNT(*) AS count
    FROM "spotify-data"
    GROUP BY key
    ORDER BY count DESC
    LIMIT 1;
    ```
    

---

# **Results and Insights**

## **Key Findings**

- **Most Popular Tracks**: Identified the most popular tracks for each year.
- **Average Popularity Trend**: Analyzed the trend of average track popularity over the years, showing a general increase/decrease.
- **Outliers**: Detected tracks with significantly different durations, highlighting potential anomalies or unique songs.

## **Visualizations**

Included visual representations of the key findings using charts or graphs. A line graph showing the trend of average popularity over the years. These visualizations were measured with DB browser for SQL.

---

# **Conclusion**

## **Summary**

In this task, I successfully explored, transformed, and analyzed the Spotify dataset to uncover meaningful patterns and insights. The use of SQL queries enabled efficient data manipulation and extraction of key statistics.

## **Future Work**

- **Data Cleaning**: Further cleansing of the dataset to handle any remaining anomalies.
- **Advanced Analysis**: Incorporate machine learning techniques for predictive analysis.
- **Visualization**: Enhanced visualizations using tools like Tableau or Power BI.

---

# **References**

- **Dataset**: [Spotify-data.csv](https://drive.google.com/drive/folders/1HWk0yOEE7yWC_mw1Ec7jxvyLtC-orqnZ?usp=drive_link)
- **GitHub Repository**: [Spotify Data Analysis](https://github.com/zbz229/InternCareerSQLintern.git)
- **Tools**: DB browser for SQL, VScode and Microsoft Excel.

<aside>
©️ **2024 Muhammad Zuraiz Zia | All Rights Reserved | Document Made with Notion**

</aside>

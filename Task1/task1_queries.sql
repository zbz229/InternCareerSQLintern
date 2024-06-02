--Name: Muhammad Zuraiz Zia
--Designation: SQL Developer Internsong_
--Batch: May 2024
--Start Date: May 14, 2024
--Deadline: June 14, 2024

-- Task 1: SQL Data Analysis
-- Description: Perform data analysis using SQL queries on provided dataset, focusing on extracting meaningful insights and patterns.

-- Note: These queries run well on db browser for sqlite


---------------------------------------------------------------------------
-- #1. DATA EXPLORATION#

-- View the schema of the table
PRAGMA table_info('spotify-data');

-- Check for missing values in each field
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
    SUM(CASE WHEN track_key IS NULL THEN 1 ELSE 0 END) AS track_key_missing,
    SUM(CASE WHEN popularity IS NULL THEN 1 ELSE 0 END) AS popularity_missing,
    SUM(CASE WHEN explicit IS NULL THEN 1 ELSE 0 END) AS explicit_missing
FROM "spotify-data";


-- Check for Duplicate rows based on all fields
SELECT
    id, name, artists, duration_ms, release_date, year, acousticness, danceability,
    energy, instrumentalness, liveness, loudness, speechiness, tempo, valence, mode, 
    track_key, popularity, explicit, COUNT(*) AS count
FROM "spotify-data"
GROUP BY
    id, name, artists, duration_ms, release_date, year, acousticness, danceability,
    energy, instrumentalness, liveness, loudness, speechiness, tempo, valence, mode, 
    track_key, popularity, explicit
HAVING COUNT(*) > 1;



-- Check for Anomalies in numeric fields, such as negative durations
SELECT * FROM "spotify-data"
WHERE duration_ms < 0 OR loudness < 0 OR tempo < 0;



---------------------------------------------------------------------------
-- #BASIC QUERIES#

-- Select all tracks by a specific artist
SELECT name, artists, duration_ms
FROM "spotify-data"
WHERE artists LIKE '%Artist Name%';


-- Get the average duration of tracks released in a specific year
SELECT year, AVG(duration_ms) AS avg_duration_ms
FROM "spotify-data"
WHERE year = 2020
GROUP BY year;




---------------------------------------------------------------------------
-- #JOIN OPERATIONS#

--Note: Since there is only one table in your schema, we cannot demonstrate join operations directly...

-- Example assuming there is another table 'artist_details'
SELECT a.name AS track_name, b.artist_name, b.artist_genre
FROM "spotify-data" a
INNER JOIN artist_details b ON a.artists = b.artist_id;



-- Example assuming there is another table 'album_details'
SELECT a.name AS track_name, b.album_name, b.release_year
FROM "spotify-data" a
LEFT JOIN album_details b ON a.release_date = b.album_id;




---------------------------------------------------------------------------
-- #DATA TRANSFORMATION#

-- Convert duration_ms to seconds (as a float)
SELECT name, duration_ms / 1000.0 AS duration_seconds
FROM "spotify-data";



-- Replace NULL values in popularity with 0
SELECT name, COALESCE(popularity, 0) AS popularity
FROM "spotify-data";



-- Extract year from the release_date
SELECT name, SUBSTR(release_date, -4) AS release_year
FROM "spotify-data";



-- Count the number of explicit tracks
SELECT COUNT(*) AS explicit_tracks
FROM "spotify-data"
WHERE explicit = 1;




---------------------------------------------------------------------------
-- #COMPLEX QUERIES AND ANALYSIS#

-- Subqueries to Find the most popular track for each year
SELECT name, artists, year, popularity
FROM "spotify-data" a
WHERE popularity = (SELECT MAX(b.popularity)
                    FROM "spotify-data" b
                    WHERE a.year = b.year);



-- Trend Analysis: Average popularity trend over the years
SELECT year, AVG(popularity) AS avg_popularity
FROM "spotify-data"
GROUP BY year
ORDER BY year;



-- Outliers: Find tracks with duration more than 2 standard deviations from the mean
WITH stats AS (
    SELECT AVG(duration_ms) AS mean_duration, 
           STDEV(duration_ms) AS stddev_duration
    FROM "spotify-data"
)
SELECT a.*
FROM "spotify-data" a, stats s
WHERE a.duration_ms > s.mean_duration + 2 * s.stddev_duration
   OR a.duration_ms < s.mean_duration - 2 * s.stddev_duration;



-- Calculating Metrics:

-- Total number of tracks
SELECT COUNT(*) AS total_tracks
FROM "spotify-data";


-- Average duration of tracks in milliseconds
SELECT AVG(duration_ms) AS avg_duration_ms
FROM "spotify-data";


-- Total duration of tracks released each year
SELECT year, SUM(duration_ms) AS total_duration_ms
FROM "spotify-data"
GROUP BY year
ORDER BY year;


-- Find the most common musical track_key in tracks
SELECT track_key, COUNT(*) AS count
FROM "spotify-data"
GROUP BY track_key
ORDER BY count DESC
LIMIT 1;
SELECT * FROM top_songs LIMIT 5;


-- Song Popularity by Duration

WITH duration_to_minutes AS(
    SELECT
        ROUND(duration::NUMERIC/60, 2) AS duration_mins
    FROM
        top_songs
), duration_range AS(
    SELECT
        duration_mins,
        CASE
            WHEN duration_mins < 1 THEN '1.below 1 minute'
            WHEN duration_mins >= 1 AND duration_mins < 2 THEN '2.1–2 minutes'
            WHEN duration_mins >= 2 AND duration_mins < 3 THEN '3.2–3 minutes'
            WHEN duration_mins >= 3 AND duration_mins < 4 THEN '4.3–4 minutes'
            WHEN duration_mins >= 4 AND duration_mins < 5 THEN '5.4–5 minutes'
            WHEN duration_mins >= 5 AND duration_mins < 6 THEN '6.5–6 minutes'
            ELSE '7.6+ minutes'
        END AS duration_scope
    FROM
        duration_to_minutes
)
SELECT
    SUBSTRING(duration_scope FROM 3) AS duration_range,
    COUNT(duration_mins) AS number_of_songs
FROM
    duration_range
GROUP BY
    duration_scope
ORDER BY
    duration_scope;


-- Get the most Popular Songs by a Chosen Artist

CREATE OR REPLACE FUNCTION get_songs_by_artist(p_artist TEXT) -- function creation
RETURNS TABLE(song_name TEXT, plays INTEGER) -- RETURNS SETOF top_songs - dla całej struktury tabeli 
AS $$
    SELECT 
        name::TEXT,
        playcount::INTEGER
    FROM 
        top_songs
    WHERE 
        artist = p_artist AND duration != 0
    ORDER BY
        playcount DESC;
$$ LANGUAGE sql; -- 2 opcja to plpgsql bardziej zaawansowana

-- get the most popular songs by a chosen artist
SELECT 
    * 
FROM 
    get_songs_by_artist('Metallica');


-- WORDS ANALYSIS

-- Which Words Are Used the Most In a Song Title? 
WITH words AS(
SELECT
    UNNEST(                  
        STRING_TO_ARRAY
        (
            UPPER(name),
            ' '              
        )
    ) AS word
FROM
    top_songs
)
SELECT
    word,
    COUNT(*) AS number_of_words
FROM
    words
WHERE
    word NOT IN ('THE', '-', 'A', 'OF', 'REMASTER', 'REMASTERED', 'AND', '(FEAT.', '(WITH', 'VERSION)', '&')
GROUP BY
    word
ORDER BY
    number_of_words DESC,
    word;


-- Does Words Used in Title Impact on Playcount of the Song?
WITH words AS (
    SELECT
        playcount,
        REGEXP_REPLACE( -- regex z czatu
            UNNEST(STRING_TO_ARRAY(UPPER(name), ' ')), 
            '[^A-Z0-9]', '', 'g' 
        ) AS word
    FROM
        top_songs
)
SELECT
    word,
    COUNT(*) AS occurrence,          
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY playcount) AS median_plays, 
    ROUND(100.0 * SUM(playcount) / SUM(SUM(playcount)) OVER (), 2) || '%' AS playcount_share
FROM
    words
WHERE
    word != '' AND word NOT IN ('THE', 'A', 'OF', 'REMASTER', 'REMASTERED', 'AND', 'FEAT', 'WITH', 'VERSION')
GROUP BY
    word
HAVING
    COUNT(*) > 5 -- only words used more than 5 times
ORDER BY
    median_plays DESC,
    occurrence,
    playcount_share DESC;    


-- The Most Popular Words Used in Song Titlte by Every Artist

WITH words AS (
    SELECT
        artist,
        REGEXP_REPLACE( -- regex z czatu
            UNNEST(STRING_TO_ARRAY(UPPER(name), ' ')), 
            '[^A-Z0-9]', '', 'g' 
        ) AS word
    FROM
        top_songs
)
SELECT
    artist,
    word,
    COUNT(word) AS occurrence
FROM
    words
WHERE
    word != '' AND word NOT IN ('THE', 'A', 'OF', 'REMASTER', 'REMASTERED', 'AND', 'FEAT', 'WITH', 'VERSION')
GROUP BY
    artist,
    word
HAVING
    COUNT(*) > 1 -- only words used more than once
ORDER BY
    artist,
    occurrence DESC;
    

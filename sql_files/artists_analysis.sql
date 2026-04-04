SELECT * FROM top_artists LIMIT 5;


-- Artist Listeners to Playcount Comparison (ordered by highest to lowest %)

SELECT
    name,
    listeners,
    playcount,
    (listeners::NUMERIC / playcount) * 100 AS ratio
FROM
    top_artists
WHERE
    listeners > 2000000 -- for more than 2000000 overall listeners
ORDER BY
    ratio DESC;


-- Listener Distribution (Market Share) by Artist Listener Quartile

WITH listeners_range AS( -- quartiles
    SELECT 
            listeners,
            NTILE(4) OVER (ORDER BY listeners) AS quartile
        FROM 
            top_artists
)
SELECT
    CASE 
        WHEN quartile = 1 THEN 'Bottom 25% (Low)'
        WHEN quartile = 2 THEN '25%-50% (Average)'
        WHEN quartile = 3 THEN '50%-75% (High)'
        ELSE 'Top 25% (Very High)'
    END AS artist_num_of_listeners,
    SUM(listeners) AS total_listeners_in_group, 
    ROUND(100.0 * SUM(listeners) / SUM(SUM(listeners)) OVER (), 2) || '%' AS market_share -- sum of the group divided by sum of everything (% distribution)
FROM
    listeners_range
GROUP BY
    quartile
ORDER BY 
    quartile;


-- Song Popularity Distribution by Artist

SELECT
    s.artist,
    s.name,
    ROUND(a.listeners::NUMERIC/ s.listeners, 2) AS song_distribution -- song listeners divided by artist listeners 
FROM
    top_songs AS s
JOIN
    top_artists AS a ON s.artist = a.name
ORDER BY
    s.artist,
    song_distribution DESC;
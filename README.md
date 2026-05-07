# 🎵 End-to-End Music Data Pipeline & Analysis Project (API → SQL → Power BI)

## 🔎 Introduction

This project consists of four key steps:

![schema](images/project_schema.png)

- **Step 1:** Fetching music data from the [Last.fm](https://www.last.fm/) API using a Python script - [api_request.py](python_files/api_request.py).

- **Step 2:** Loading the extracted data into a Pandas DataFrame (Python library). [This](python_files/data_overview_&_load_to_sql_db.ipynb) file also includes data overview and cleaning. The notebook then connects to a PostgreSQL server and loads the DataFrame into the database.

- **Step 3:** Data analysis using the SQL database created in the previous step.

- **Step 4:** Visualizing the data using Power BI.


**Note:** I used the import feature (from a PostgreSQL server) to load data into Power BI to showcase Power BI skills (especially Power Query), although a faster approach would be to export SQL results to CSV before importing.

## ⚙️ How to Run

1. Install PostgreSQL and Python locally. 
2. Create a database named music_db in PostgreSQL.
3. Clone the repository or download the project files.
4. Follow the instructions in the [data_overview_&_load_to_sql_db.ipynb](python_files/data_overview_&_load_to_sql_db.ipynb) notebook and execute all cells using Jupyter Notebook or Visual Studio Code.
5. You can now execute the SQL files ([artists_analysis.sql](sql_files/artists_analysis.sql) and [songs_analysis.sql](sql_files/songs_analysis.sql)).


## 📊 Visualization

![Dashboard](images/dashboard.gif)

This dashboard provides detailed insights into the most popular artists and songs, song duration distribution, the most common words used in titles, and more. You can filter the dashboard by a selected artist or song (in the top-left corner).

You can download the dashboard [here](Dashboard.pbix)

## 💡 Key Insights

- Top 5 most popular artists: Coldplay, Rihanna, Radiohead, Kanye West, Eminem
- Top 5 most popular songs: Don't Say You Love Me, Who, Haegeum, Like Crazy, Dynamite
- Top 5 most common words used in song titles: You, Me, Love, My, For
- Most songs are between 3 and 4 minutes long
- Songs shorter than 3 minutes tend to be less popular
- Top 2500 artists share 67% of total listeners

## 💪 Skills Used

### 👨‍💻 Python

- Defining functions
- Loops
- Conditional statements
- Error handling
- Python objects (list, dictionary)
- Working with API
- Importing modules

### 🐼 Pandas

- Data import and export
- Data overview: head(), describe(), info() methods
- Data cleaning: removing duplicates, handling null values

### 🛢️ SQL

- Creating keys and indexes
- String functions (SUBSTRING)
- Window functions
- Common Table Expressions (CTEs)
- Joins
- Creating a new custom function 
- UNNEST() function (expanding an array into a set of rows)
- Using REGEXP_REPLACE() function  
- Aggregation
- CASE expressions

### 📊 Power BI
   
- Power Query:
    - Filtering
    - Data type normalization
    - Value replacement
    - Adding conditional and custom columns
- Charts 
- Cards 
- Slicers
- Editing Interactions

## 🖥️ Technical Details

- **DBMS:** PostgreSQL
- **Environment:** Visual Studio Code
- **Visualization:** Power BI
- **Data source:** [Last.fm](https://www.last.fm/) 
    - API link: http://ws.audioscrobbler.com/2.0/
    - API documentation: https://www.last.fm/api/scrobbling 

## ✒️ Author

- **Author:** Mateusz Bochenek
- **Mail:** matbochenek42@gmail.com
- **GitHub link:** https://github.com/matbochenek42
- **LeetCode link:** https://leetcode.com/u/SmO7BWmsiz/

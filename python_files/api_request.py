# this file extract music data using api
# API Documentation: https://www.last.fm/api/scrobbling

import requests
import pandas as pd
import time

from requests.exceptions import ConnectionError, Timeout, TooManyRedirects
from pprint import PrettyPrinter

# API elements (key and link)
API_KEY = "098b2b402eb4ad43e56e9b40fee3f1e9"
url = "http://ws.audioscrobbler.com/2.0/"


def get_all_top_artists():
    """
    Artists Dataset
    function that loads the data from api
    """
    all_artists = []
    page = 1
    
    while True:
        params = {
            "method": "chart.gettopartists", # endpoint
            "api_key": API_KEY,
            "format": "json",
            "limit": 1000, # max number of rows
            "page": page
        }
        try:
            response = requests.get(url, params=params)
            data = response.json()
        
            # get all data for each page (if true)
            if "artists" in data:
                if "artist" in data["artists"]:
                    artists = data["artists"]["artist"]
                else:
                    artists = []
            else:
                artists = []
            
            if not artists:
                print("🔴 No more pages")
                time.sleep(2)
                break # if there are no more pages
            
            # saving data to a list and then to pandas dataframe
            for artist in artists:
                all_artists.append({
                    "name": artist["name"],
                    "listeners": int(artist["listeners"]),
                    "playcount": int(artist["playcount"])
                })
            
            print(f"Page number: {page}, Number of rows: {len(artists)}")
            
            page += 1 # go to the next page in the loop
            time.sleep(0.25)  # time sleep to avoid api request limit
        
        except (ConnectionError, Timeout, TooManyRedirects) as e:
            print(e) # in case of api error
            break
    
    print("✅ Artits dataset was loaded")
    return pd.DataFrame(all_artists) # return df


def get_all_top_songs():
    """
    Songs Dataset
    function that loads the data from api
    """
    all_songs = []
    page = 1
    
    while True:
        params = {
            "method": "chart.gettoptracks", # endpoint
            "api_key": API_KEY,
            "format": "json",
            "limit": 1000, # max number of rows
            "page": page
        }
        try:
            response = requests.get(url, params=params)
            data = response.json()
        
            # get all data for each page (if true)
            if "tracks" in data:
                if "track" in data["tracks"]:
                    songs = data["tracks"]["track"]
                else:
                    songs = []
            else:
                songs = []
            
            if not songs:
                print("🔴 No more pages")
                time.sleep(2)
                break # if there are no more pages
            
            # saving data to a list and then to pandas dataframe
            for song in songs:
                all_songs.append({
                    "artist": song["artist"]["name"],
                    "duration": int(song["duration"]) if song["duration"] else 0,
                    "listeners": int(song["listeners"]),
                    "playcount": int(song["playcount"]),
                    "name": song["name"]
                })

            print(f"Page number: {page}, Number of rows: {len(songs)}")
            
            page += 1 # go to the next page in the loop
            time.sleep(0.25)  # time sleep to avoid api request limit
        
        except (ConnectionError, Timeout, TooManyRedirects) as e:
            print(e) # in case of api error
            break
    
    print("✅ Songs dataset was loaded")
    return pd.DataFrame(all_songs) # return df

def print_data():
    """
    see api's output in a nice format (additional function)
    """
    from pprint import PrettyPrinter

    params = {
        "method": "chart.gettopartists", # endpoint
        "api_key": API_KEY,
        "format": "json",
        "limit": 5 # number of rows
    }

    try:
        response = requests.get(url, params=params)
        data = response.json()

    except (ConnectionError, Timeout, TooManyRedirects) as e:
        print(e)

    printer = PrettyPrinter()
    return printer.pprint(data) 


# remove comment below to see function output

#print_data()
get_all_top_songs()
get_all_top_artists()
#!/usr/bin/env python
# coding: utf-8

import pandas as pd

file_path = "2019_kbo_for_kaggle_v2.csv"
data = pd.read_csv(file_path)

print("1) 2015 - 2018")
for year in range(2015, 2019):
    year_data = data[data['year'] == year]
    
    top_hits = year_data.nlargest(10, 'H')
    print(f"Top 10 players in hits for {year}:")
    print(top_hits[['batter_name', 'H']])
    
    top_avg = year_data.nlargest(10, 'avg')
    print(f"\nTop 10 players in batting average for {year}:")
    print(top_avg[['batter_name', 'avg']])
    
    top_hr = year_data.nlargest(10, 'HR')
    print(f"\nTop 10 players in homerun for {year}:")
    print(top_hr[['batter_name', 'HR']])
    
    top_obp = year_data.nlargest(10, 'OBP')
    print(f"\nTop 10 players in on-base percentage for {year}:")
    print(top_obp[['batter_name', 'OBP']])
    print("\n")

year_2018 = data[data['year'] == 2018]
highest_war_by_position = year_2018.loc[year_2018.groupby('cp')['war'].idxmax()]
print("2) Player with the highest WAR by position in 2018:")
print(highest_war_by_position[['batter_name', 'cp', 'war']])

correlations = data[['R', 'H', 'HR', 'RBI', 'SB', 'war', 'avg', 'OBP', 'SLG', 'salary']].corr()['salary'].sort_values(ascending=False)
highest_correlation = correlations.index[1]
print(f"\n3) The attribute with the highest correlation with salary is: {highest_correlation} (Correlation value: {correlations[1]:.2f})")
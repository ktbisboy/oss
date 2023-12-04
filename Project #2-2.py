#!/usr/bin/env python
# coding: utf-8

import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeRegressor
from sklearn.ensemble import RandomForestRegressor
from sklearn.svm import SVR
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import mean_squared_error
from math import sqrt

def sort_dataset(dataset_df):
    return dataset_df.sort_values(by='year')

def split_dataset(dataset_df):
    dataset_df['salary'] *= 0.001
    train_data = dataset_df.iloc[:1718]
    test_data = dataset_df.iloc[1718:]
    X_train = train_data.drop(columns=['salary'])
    Y_train = train_data['salary']
    X_test = test_data.drop(columns=['salary'])
    Y_test = test_data['salary']
    return X_train, X_test, Y_train, Y_test

def extract_numerical_cols(dataset_df):
    numerical_cols = ['age', 'G', 'PA', 'AB', 'R', 'H', '2B', '3B', 'HR', 'RBI', 'SB', 'CS', 'BB', 'HBP', 'SO', 'GDP', 'fly', 'war']
    return dataset_df[numerical_cols]

def train_predict_decision_tree(X_train, Y_train, X_test):
    dt_regressor = DecisionTreeRegressor()
    dt_regressor.fit(X_train, Y_train)
    return dt_regressor.predict(X_test)

def train_predict_random_forest(X_train, Y_train, X_test):
    rf_regressor = RandomForestRegressor()
    rf_regressor.fit(X_train, Y_train)
    return rf_regressor.predict(X_test)

def train_predict_svm(X_train, Y_train, X_test):
    scaler = StandardScaler()
    X_train_scaled = scaler.fit_transform(X_train)
    X_test_scaled = scaler.transform(X_test)

    svm_regressor = SVR()
    svm_regressor.fit(X_train_scaled, Y_train)
    return svm_regressor.predict(X_test_scaled)

def calculate_RMSE(labels, predictions):
    return sqrt(mean_squared_error(labels, predictions))

if __name__ == '__main__':
    data_df = pd.read_csv('2019_kbo_for_kaggle_v2.csv')

    sorted_df = sort_dataset(data_df)
    X_train, X_test, Y_train, Y_test = split_dataset(sorted_df)

    X_train = extract_numerical_cols(X_train)
    X_test = extract_numerical_cols(X_test)

    dt_predictions = train_predict_decision_tree(X_train, Y_train, X_test)
    rf_predictions = train_predict_random_forest(X_train, Y_train, X_test)
    svm_predictions = train_predict_svm(X_train, Y_train, X_test)

    print("Decision Tree Test RMSE:", calculate_RMSE(Y_test, dt_predictions))
    print("Random Forest Test RMSE:", calculate_RMSE(Y_test, rf_predictions))
    print("SVM Test RMSE:", calculate_RMSE(Y_test, svm_predictions))
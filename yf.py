import yfinance as yf
import pandas as pd
from datetime import datetime, timedelta
import os

## Define the list of tickers
tickers = ['NEE', 'AMGN', 'JNJ', 'AMZN', 'AAPL', 'REET', 'SPY', 'MCD', 'GLD', 'KO']

## Set the end and start dates
start_date = "2022-02-01"
end_date = "2026-02-01"

## Create an empty DataFrame to store the close prices
close_df = pd.DataFrame()

## Download the close prices for each ticker
for ticker in tickers:
    data = yf.download(ticker, start=start_date, end=end_date, interval="1mo")
    if not data.empty:
        close_df[ticker] = data['Close']

close_df = close_df.dropna()


print(close_df)

## Set the output folder path
output_folder = r"D:\university\виробнича практика"

## Export the DataFrame to Excel
output_file = os.path.join(output_folder, 'asset_prices.xlsx')
close_df.to_csv(output_file)


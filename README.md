# data_organization_cleaning_by_SQL
a project about data cleaning
Although some of the Python packages(pandas, numpy) is very powerful for data cleaning, SQL is also very useful and convinient for data cleaning. In this project, I will use postgreSQL to do the data organization, management and cleaning.   

## Data Resource
The raw data is downloaded from [Nashville Housing Data](https://github.com/AlexTheAnalyst/PortfolioProjects/blob/c5e3ef749de46802a5ac89a0e22daeb60cfc0481/Nashville%20Housing%20Data%20for%20Data%20Cleaning.xlsx). The csv file converted from the raw data is [here](https://github.com/sarahzhao21/data_organization_cleaning_by_SQL/blob/8e1af8c9b763044624293e6f8162621e3d4833dc/Nashville%20Housing.csv)
Because this project is more like an excercise, any data that includes date, time and strings datatypes would be good for this analysis.   

## Content
The processes of data cleaning that have been used in this project include:  
1.Add new columns to a table and update those columns.   
2.Delete useless columns from a table.   
3.Extract different elements from timestamp or date records.     
4.Extract different elements from strings and rebuilt strings.   
5.Check if there are null values in a columns and repopulate the null values based on other columns or rows.   
6.Check if there are duplicate rows in the table and remove the duplicate rows.   
7.Change some kind of values to different values in a column.   
[The codes and explaitions are recorded in this file](https://github.com/sarahzhao21/data_organization_cleaning_by_SQL/blob/8e1af8c9b763044624293e6f8162621e3d4833dc/SQL_data_clean.sql)

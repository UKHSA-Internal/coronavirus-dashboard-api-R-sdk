# Coronavirus (COVID-19) in the UK - API Service

## Software Development Kit (SDK)


<!-- badges: start -->
<!-- badges: end -->

# Coronavirus (COVID-19) in the UK - API Service

## Software Development Kit (SDK)


This is an R SDK for the COVID-19 API, as published by Public Health England
on [Coronavirus (COVID-19) in the UK](https://api.coronavirus.data.gov.uk/). 
The source code of this library is housed on [GitHub](https://github.com/publichealthengland/coronavirus-dashboard-api-r-sdk).

The API supplies the latest data for the COVID-19 outbreak in the United Kingdom. 


The endpoint for the data provided using this SDK is:

    https://api.coronavirus.data.gov.uk/v1/data


## Installation

You can install the released version of `ukcovid19` from [CRAN](https://CRAN.R-project.org) with:

``` r
install.packages("ukcovid19")
```

### Pagination

Using this SDK will bypass the pagination process. You will always download the entire
dataset unless the `latest_by` argument is defined.


### 

To use the library, run:

``` r
library(ukcovid19)
```

or simply prepend the function names with `ukcovid19`; for instance:

``` r
ukcovid19::get_options
```

### Examples

We would like to extract the number of new cases, cumulative cases, new deaths and
cumulative deaths for England using the API.

We start off by constructing the value of the `filters` parameter:

``` r
query_filters <- c(
    'areaType=nation',
    'areaName=England'
)
```

Next step is to construct the value of the `structure` parameter. To do so, we need to
find out the name of the metric in which we are interested. You can find this information
in the Developer's Guide on the Coronavirus Dashboard website.

In the case of this example, the metrics are as follows:

- `newCasesByPublishDate`: New cases (by publish date)
- `cumCasesByPublishDate`: Cumulative cases (by publish date)
- `newDeathsByDeathDate`: New deaths (by death date)
- `cumDeathsByDeathDate`: Cumulative deaths (by death date)

In its simplest form, we construct the structure as follows:

``` r 
cases_and_deaths = list(
    date = "date",
    areaName = "areaName",
    areaCode = "areaCode",
    newCasesByPublishDate = "newCasesByPublishDate",
    cumCasesByPublishDate = "cumCasesByPublishDate",
    newDeathsByDeathDate = "newDeathsByDeathDate",
    cumDeathsByDeathDate = "cumDeathsByDeathDate"
)
```

Now, we can use `filters` and `structure` to get the data from the API:

``` r
data <- get_data(
    filters = query_filters, 
    structure = cases_and_deaths
)

# Showing the head:
print(head(data))
```

            date areaName  areaCode newCasesByPublishDate cumCasesByPublishDate  newDeathsByDeathDate cumDeathsByDeathDate
    1 2020-08-02  England E92000001                   676                262746                    NA                   NA
    2 2020-08-01  England E92000001                   722                262070                     2                41589
    3 2020-07-31  England E92000001                   814                261348                    21                41587
    4 2020-07-30  England E92000001                   812                260534                    26                41566
    5 2020-07-29  England E92000001                   700                259722                    40                41540
    6 2020-07-28  England E92000001                   547                259022                    36                41500


To see the timestamp for the last update, run:

``` r
timestamp <- last_update(
    filters = query_filters, 
    structure = cases_and_deaths
)

print(timestamp)
```

    [1] "2020-08-02 14:50:59 GMT"


To get the latest data by a specific metric, use the \code{latest_by} argument as follows:

``` r
all_nations = c(
    "areaType=nation"
)

data <- get_data(
    filters = all_nations, 
    structure = cases_and_deaths,
    latest_by = "newCasesByPublishDate"
)

print(data)
```

            date areaName  areaCode newCasesByPublishDate cumCasesByPublishDate  newDeathsByDeathDate cumDeathsByDeathDate
    1 2020-08-02  England E92000001                   676                262746                    NA                   NA
    2 2020-08-02 Scotland S92000003                    31                 18676                    NA                   NA
    3 2020-08-02    Wales W92000004                    37                 17315                    NA                   NA


-----------

Developed and maintained by [Public Health England](http://coronavirus.data.gov.uk/).

Copyright (c) 2020, Public Health England.

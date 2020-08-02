library(testthat)
library(ukcovid19)


test_filters <- c(
    'areaType=ltla',
    'areaName=adur'
)

test_structure <- list(
    name = "areaName",
    date = "date",
    newCases = "newCasesBySpecimenDate"
)


# get_data
# --------
data <- get_data(filters = test_filters, structure = test_structure)

test_that(
    "Test get_data", 
    expect_equal(typeof(data), "list")
)

test_that(
    "Test getData: length",
    expect_equal(length(data) == 3, TRUE)
)

test_that(
    "Test getData: length",
    expect_equal(length(data$date) > 10, TRUE)
)

for ( key in names(test_structure) ) {
    test_that(
        sprintf("Test data keys [%s]", key),
        expect_equal(key %in% names(data), TRUE)
    )
}


# get_head
# --------
location = paste(
    '/v1/data?',
    'filters=areaType=ltla;areaName=adur&',
    'structure={"name":"areaName","date":"date","newCases":"newCasesBySpecimenDate"}',
    sep = ""
)

head <- get_head(filters = test_filters, structure = test_structure)

test_that(
    "Test get_head", 
    expect_equal(typeof(head), "list")
)

test_that(
    "Test header value (location)", 
    expect_equal(URLdecode(head$`content-location`), location)
)


# last_update
# -----------
timestmap <- last_update(filters = test_filters, structure = test_structure)

test_that(
    "Test last_update", 
    expect_equal(typeof(timestamp), "closure")
)


#  latest_by
# ----------
data <- get_data(
    filters = test_filters, 
    structure = test_structure, 
    latest_by = 'newCasesBySpecimenDate'
)

test_that(
    "Test get_data", 
    expect_equal(typeof(data), "list")
)

test_that(
    "Test getData: length",
    expect_equal(length(data) == 3, TRUE)
)

test_that(
    "Test getData: length",
    expect_equal(length(data$date), 1)
)

for ( key in names(test_structure) ) {
    test_that(
        sprintf("Test data keys [%s]", key),
        expect_equal(key %in% names(data), TRUE)
    )
}

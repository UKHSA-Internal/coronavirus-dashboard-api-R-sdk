API_ENDPOINT <- "https://api.coronavirus.data.gov.uk/v1/data"


#' Get Request
#' 
#' Generic get request. Prepares queries, retrieves the 
#' data and parses the results.
#' 
#' @param filters    API filters. 
#'                   
#' @param structure  Structure parameter.
#' 
#' @param ...        Either the pagination parameter (\code{page}) or 
#'                   the metric for \code{latestBy}.
#' 
#' @return list      Data for the given queries or \code{NULL}.
get_request <- function (filters, structure, ...) {

    # Automatically encodes the URL and its parameters.
    httr::VERB(
        "GET",

        # Concatenate the filters vector using a semicolon.
        url = API_ENDPOINT,
        
        # Convert the structure to JSON (ensure 
        # that "auto_unbox" is set to TRUE).
        query = list(
            filters = paste(filters, collapse = ";"),
            structure = jsonlite::toJSON(
                structure, 
                auto_unbox = TRUE,
                pretty = FALSE
            ),
            ...
        ),
        
        # The API server will automatically reject any
        # requests that take longer than 10 seconds to 
        # process.
        httr::timeout(10)
    ) -> response

    # Handle errors:
    if ( response$status_code >= 400 ) {

        err_msg = httr::http_status(response)
        stop(err_msg)

    } else if ( response$status_code == 204 ) {

        response <- NULL

    } else {

        # Convert response from binary to JSON:
        json_text <- httr::content(response, "text")
        response <- jsonlite::fromJSON(json_text)

    }

    return(response)

}  # get_request


#' Get Paginated Data
#' 
#' Iteratively runs the query to download all pages.
#' 
#' @param filters    API filters. 
#'                   
#' @param structure  Structure parameter. 
#' 
#' @return list      Data for the given \code{filters} and \code{structure}.
get_paginated_data <- function (filters, structure) {

    results <- list()
    current_page <- 1
    
    repeat {

        response <- get_request(filters, structure, page = current_page)
        
        # Must be after `get_request` is called.
        if ( is.null(response) ) break;

        results <- rbind(results, response$data)
        
        # Must be after results are added.
        if ( is.null(response$pagination$`next`) ) break;
        
        current_page <- current_page + 1;

    }
    
    return(results)

}  # get_paginated_data


#' Get Data
#' 
#' Extracts paginated data by requesting all of the pages
#' and combining the results.
#' 
#' For additional information and up-to-date details on arguments 
#' and what they represent, please visit 
#' the \href{API documentations}{https://coronavirus.data.gov.uk/developers-guide}.
#'
#' @param filters    API filters.
#'                   
#' @param structure  Structure parameter.
#' 
#' @param latest_by  Retrieves the latest value for a specific metric.
#'                   Must be set to a value that is defined in the 
#'                   structure. (Default: \code{NULL})
#'                   
#' @return list      Data for the given \code{filters} and \code{structure}.
#' 
#' @export
#' 
#' @examples 
#' # We would like to download all cases data at `region` level. 
#' # We start off by defining our `filters` argument:
#' query_filters <- c(
#'    "areaType=region"
#' )
#' 
#' # Next, we define the structure:
#' query_structure <- list(
#'     date = "date", 
#'     name = "areaName", 
#'     code = "areaCode", 
#'     daily = "newCasesBySpecimenDate",
#'     cumulative = "cumCasesBySpecimenDate"
#' )
#' 
#' # We then pass these arguments to the `get_data` function:
#' data <- get_data(filters = query_filters, structure = query_structure)
get_data <- function (filters, structure, latest_by = NULL) {

    response <- NULL

    if ( is.null(latest_by) ) {

        response <- get_paginated_data(filters, structure)

    } else {
        data <- get_request(filters, structure, latestBy = latest_by)
        response <- data$data

    } 
    
    return(response)
    
}  # get_data


#' Get Options
#' 
#' Provides the options by calling the \code{OPTIONS} method of the API.
#'
#' @return character  API options as prettified JSON.
#' 
#' @export
#' 
#' @examples 
#' opts <- get_options()
get_options <- function () {
    
    httr::VERB(
        "OPTIONS",

        # Concatenate the filters vector using a semicolon.
        url = API_ENDPOINT,
        
        # The API server will automatically reject any
        # requests that take longer than 10 seconds to 
        # process.
        httr::timeout(10)
    ) -> response
    
    # Handle errors:
    if ( response$status_code >= 400 ) {
        err_msg = httr::http_status(response)
        stop(err_msg)
    }
    
    # Convert response from binary to JSON:
    json_text <- httr::content(response, "text")
    results <- jsonlite::prettify(json_text, indent = 4)

    return(results)
    
}  # get_options


#' Get Head
#' 
#' Request header for the given input arguments (\code{filters}, 
#' \code{structure}, and \code{lastest_by}).
#'
#' @param filters    API filters. See the API documentations for 
#'                   additional information.
#'                   
#' @param structure  Structure parameter. See the API documentations 
#'                   for additional information.
#'                   
#' @return list      Request headers.
#' 
#' @export
#' 
#' @examples 
#' query_filters <- c(
#'    "areaType=region"
#' )
#' 
#' query_structure <- list(
#'     date = "date", 
#'     name = "areaName", 
#'     code = "areaCode", 
#'     daily = "newCasesBySpecimenDate",
#'     cumulative = "cumCasesBySpecimenDate"
#' )
#' 
#' headers <- get_head(filters = query_filters, structure = query_structure)
#' 
#' # We can now access header parameters. For instance, to get the 
#' # timestamp for the latest update, we do as follows:
#' print(headers$`last-modified`)
get_head <- function (filters, structure) {
    
    httr::VERB(
        "HEAD",

        # Concatenate the filters vector using a semicolon.
        url = API_ENDPOINT,
        
        # Convert the structure to JSON (ensure 
        # that "auto_unbox" is set to TRUE).
        query = list(
            filters = paste(filters, collapse = ";"),
            structure = jsonlite::toJSON(
                structure, 
                auto_unbox = TRUE,
                pretty = FALSE
            )
        ),
            
        # The API server will automatically reject any
        # requests that take longer than 10 seconds to 
        # process.
        httr::timeout(10)
    ) -> response
    
    # Handle errors:
    if ( response$status_code >= 400 ) {
        err_msg = httr::http_status(response)
        stop(err_msg)
    }

    return(response$head)
    
}  # get_head


#' Last Update Timestamp
#' 
#' Produces the timestamp for the last update in GMT.
#' 
#' @param filters    API filters. See the API documentations for 
#'                   additional information.
#'                   
#' @param structure  Structure parameter. See the API documentations 
#'                   for additional information.
#'                   
#' @return closure   Timestamp of the last update.
#' 
#' @export
#' 
#' @examples 
#' query_filters <- c(
#'    "areaType=region"
#' )
#' 
#' query_structure <- list(
#'     date = "date", 
#'     name = "areaName", 
#'     code = "areaCode", 
#'     daily = "newCasesBySpecimenDate",
#'     cumulative = "cumCasesBySpecimenDate"
#' )
#' 
#' timestamp <- last_update(filters = query_filters, structure = query_structure)
last_update <- function (filters, structure) {
    
    response <- get_head(filters, structure)
    
    timestamp <- strptime(
        response$`last-modified`,
        format = '%a, %d %b %Y %H:%M:%S',
        tz = 'GMT'
    )

    return(timestamp)
    
}  # last_update

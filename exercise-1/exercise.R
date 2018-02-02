# Exercise 1: reading and querying a web API

# Load the httr and jsonlite libraries for accessing data
# You can also load `dplyr` if you wish to use it
# install.packages("httr")
# install.packages("jsonlite")
# install.packages("dplyr")
library("httr")
library("jsonlite")
library("dplyr")


# Create a variable for the API's base URI (https://api.github.com)
base.uri <- "https://api.github.com"

# Under the "Repositories" category, find the endpoint that will list repos in 
# an organization
# Create a variable `resource` that represents the endpoint for the course
# organization (you can use `paste0()` to construct this, or enter it manually)
org <- "info201"
resource <- paste0("/orgs/", org, "/repos")

# Send a GET request to this endpoint (the base.uri followed by the resource) 
# and extract the response body
responsebody <- GET(paste0(base.uri, resource))

# Convert the body from JSON into a data frame
body <- content(responsebody, "text")
JSONbody <- fromJSON(body)

# How many (public) repositories does the organization have?
nrow(JSONbody)


# Use a "Search" endpoint to search for repositories about "visualization" whose
# language includes "R"
# Reassign the `resource` variable to refer to the appropriate resource.
resource <- "/search/repositories"

# You will need to specify some query parameters. Create a `query.params` list 
# variable that specifies an appropriate key and value for the search term and
# the language
query.params <- list(q = "visualization", type = "R")


# Send a GET request to this endpoint--including your params list as the `query`.
# Extract the response body and convert it from JSON.
response <- GET(paste0(base.uri, resource), query = query.params)
body <- content(response, "text")
vizsearch <- fromJSON(body)

# How many search repos did your search find? (Hint: check the list names)
vizsearch$total_count

# What are the full names of the top 5?
vizdata <- vizsearch$items
vizdata.names <- select(vizdata, full_name)
print(vizdata.names[1:5, ])


# Use the API to determine the number of people following Hadly Wickham 
# (`hadley`, the author of dplyr, ggplot2, and other libraries we'll be using). 
resource <- "/users/hadley/followers"
hadleyfollowerdata <- GET(paste0(base.uri, resource))
body <- content(hadleyfollowerdata, "text")
hadleyfollowers <- fromJSON(body)
nrow(hadleyfollowers)

# Find an appropriate endpoint to query for statistics about a particular repo, 
# and use it to get a list of contributors to the `tidyverse/dplyr` repository.
# Who were the top 10 contributor in terms of number of total commits?
# NOTE: This will be a really big response with lots of data!
dplyrinfo <- GET(paste0(base.uri, "/repos/tidyverse/dplyr/contributors"))
dplyrbody <- content(dplyrinfo, "text")
dplyrjson <- fromJSON(dplyrbody)
dplyrjson <- arrange(dplyrjson, -contributions)
print(dplyrjson[1:10, 'login'])

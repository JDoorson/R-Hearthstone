# Required libraries
#install.packages("httr", "jsonlite")

# Load 'em
library("httr")
library("jsonlite")

# Define API vars
url <- "https://omgvamp-hearthstone-v1.p.mashape.com"
endpoint <- "cards"

# Load config
source("D:/R/Hearthstone/config.R")

# Make the request
raw.result <- GET(url = url, path = endpoint, add_headers("X-Mashape-Key" = mashape.api.key.testing))

# Parse it
char.content <- rawToChar(raw.result$content)   # Retrieve the Unicode result and parse it to chars
content <- fromJSON(char.content)               # Parse the JSON into a list

# We just want the regularly playable card sets
# TODO: Surely there's a way to do this in one go?
content <- content[1:16]
content <- content[-3]

# Get a subset of all data frames in the list, containing just the cardId and the card text
text.data.list <- lapply(content, subset, select=c("cardId", "text"))
card.texts <- do.call(rbind, text.data.list)
# In this scenario, it makes more sense to replace all NA text values with empty strings
card.texts$text[is.na(card.texts$text)] <- ""

# TODO: Filter the HTML and other 'invalid' characters from the text

# Order the data
ordered <- card.texts[order(nchar(card.texts$text), decreasing = TRUE), ]
ordered[1:10, ]
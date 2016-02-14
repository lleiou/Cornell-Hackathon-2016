library(RCurl)
library(RJSONIO)
library(plyr)

url <- function(address, return.call = "json", sensor = "false") {
    root <- "http://maps.google.com/maps/api/geocode/"
    u <- paste(root, return.call, "?address=", address, "&sensor=", sensor, sep = "")
    return(URLencode(u))
}

geoCode <- function(address,verbose=FALSE) {
    if(verbose) cat(address,"\n")
    u <- url(address)
    doc <- getURL(u)
    x <- fromJSON(doc,simplify = FALSE)
    if(x$status=="OK") {
        lat <- x$results[[1]]$geometry$location$lat
        lng <- x$results[[1]]$geometry$location$lng
        location_type <- x$results[[1]]$geometry$location_type
        formatted_address <- x$results[[1]]$formatted_address
        return(c(lat, lng, location_type, formatted_address))
    } else {
        return(c(NA,NA,NA, NA))
    }
}

address <- geoCode("Albany Medical center hospital, Albany, NY")
address <- c("The White House, Washington, DC","The Capitol, Washington, DC")
locations <- ldply(address, function(x) geoCode(x))
names(locations) <- c("lat","lon","location_type", "forAddress")
head(locations)
address

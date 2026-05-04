# Leaflet testing
# Simon Petersen
# 26 April 2026

install.packages(c("leaflet", "readr", "readxl", "tidyverse"))
library(leaflet)
library(readr)   # for CSV files
library(readxl)  # for Excel files
library(tidyverse)
library(here)

# Navigate to the Excel sheet
proj_path <- here()
proj_path <- paste0(proj_path, "/data/Pace Data Project Invasives Strike Force Records.xlsx")

# Read in sheet 2 of the Excel spreadsheet (populations)
lhprism_data <- read_excel(path = proj_path, sheet = 2)

# Remove NA values
lhprism_data <- lhprism_data %>%
  filter(!is.na(LONG))

# Isolate latitude and longitude columns
locations_lat <- lhprism_data$LAT
locations_lng <- lhprism_data$LONG
locations_names <- lhprism_data$PROPERTY_NAME

# Fixed data point that in the ocean due to incorrect data entry.
# Latitude of 40.0975937 changed to 40.975937 (Rye Nature Center)
locations_lat[234] <- 40.975937

# Build data frame with latitude and longitude values
df <- data.frame(name = locations_names,
                 lat = locations_lat,
                 lng = locations_lng)
m <- leaflet()
m %>%
  addTiles() %>%
  addMarkers(data = df, popup = locations_names)


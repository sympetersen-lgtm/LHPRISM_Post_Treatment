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

# Isolate Latitude, Longitude, Population status and Property name
location_name <- lhprism_data$PROPERTY_NAME
location_lat <- lhprism_data$LAT
location_lng <- lhprism_data$LONG

# Fixed data point that in the ocean due to incorrect data entry.
# Latitude of 40.0975937 changed to 40.975937 (Rye Nature Center)
location_lat[234] <- 40.975937

# Build data frame with latitude and longitude values
df1 <- data.frame(name = location_name,
                 lat = location_lat,
                 lng = location_lng)
# Create leaflet map object
m1 <- leaflet()

# Generate points for each population's coordinates
# Click on each point to see the Property Name
m1 %>%
  addTiles() %>%
  addMarkers(data = df1, popup = location_name)


# Fix status text: ""1-Partially Treated" instead of "1- Partially Treated""
lhprism_data$POP_STATUS[3] <- "1- Partially Treated"
lhprism_data$POP_STATUS[7] <- "1- Partially Treated"
lhprism_data$POP_STATUS[10] <- "1- Partially Treated"
lhprism_data$POP_STATUS[15] <- "1- Partially Treated"

# Fix status text: ""2-Completely Treated" instead of "2- Completely Treated""
lhprism_data$POP_STATUS[1] <- "2- Completely Treated"
lhprism_data$POP_STATUS[4] <- "2- Completely Treated"
lhprism_data$POP_STATUS[5] <- "2- Completely Treated"
lhprism_data$POP_STATUS[6] <- "2- Completely Treated"

# Build new data frames for each status category
stat_0 <- filter(lhprism_data, POP_STATUS == "0- Untreated")
stat_1 <- filter(lhprism_data, POP_STATUS == "1- Partially Treated")
stat_2 <- filter(lhprism_data, POP_STATUS == "2- Completely Treated")
stat_3 <- filter(lhprism_data, POP_STATUS == "3- No Plants 1 Yr")
stat_4 <- filter(lhprism_data, POP_STATUS == "4- No Plants 2 Yrs")
stat_5 <- filter(lhprism_data, POP_STATUS == "5- Eradicated")

# Fixing the same incorrectly entered latitude value (Rye Nature Center)
stat_1$LAT[37] <- 40.975937

# Generate points colored by visit status
m2 <- leaflet()

m2 %>%
  addTiles() %>%
  addCircleMarkers(data = stat_0,
                        lng=~stat_0$LONG,
                        lat=~stat_0$LAT,
                        popup=~paste0("Site Name: ",stat_0$PROPERTY_NAME,"<br>",
                                 "Status: ",stat_0$POP_STATUS),
                        color="red",
                        radius = 2,
                        group= "0- Untreated"
  ) %>% 
  addCircleMarkers(data = stat_1,
                         lng=~stat_1$LONG,
                         lat=~stat_1$LAT,
                         popup=~paste0("Site Name: ",stat_1$PROPERTY_NAME,"<br>",
                                       "Status: ",stat_1$POP_STATUS),
                         color="orange",
                         radius = 2,
                         group= "1- Partially Treated"
  ) %>% 
  addCircleMarkers(data = stat_2,
                         lng=~stat_2$LONG,
                         lat=~stat_2$LAT,
                         popup=~paste0("Site Name: ",stat_2$PROPERTY_NAME,"<br>",
                                       "Status: ",stat_2$POP_STATUS),
                         color="yellow",
                         radius = 2,
                         group= "2- Completely Treated"
  ) %>% 
  addCircleMarkers(data = stat_3,
                         lng=~stat_3$LONG,
                         lat=~stat_3$LAT,
                         popup=~paste0("Site Name: ",stat_3$PROPERTY_NAME,"<br>",
                                       "Status: ",stat_3$POP_STATUS),
                         color="green",
                         radius = 2,
                         group= "3- No Plants 1 Yr"
  ) %>% 
  addCircleMarkers(data = stat_4,
                        lng=~stat_4$LONG,
                        lat=~stat_4$LAT,
                        popup=~paste0("Site Name: ",stat_4$PROPERTY_NAME,"<br>",
                                 "Status: ",stat_4$POP_STATUS),
                        color="blue",
                        radius = 2,
                        group= "4- No Plants 2 Yr"
  ) %>% 
  addCircleMarkers(data = stat_5,
                        lng=~stat_5$LONG,
                        lat=~stat_5$LAT,
                        popup=~paste0("Site Name: ",stat_5$PROPERTY_NAME,"<br>",
                                 "Status: ",stat_5$POP_STATUS),
                        color="purple",
                        radius = 2,
                        group= "5- Eradicated"
  )

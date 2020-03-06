# Maps for Brooklyn Walksheets 2020
# Purpose: Create maps for each ED in Brooklyn and add them to correct walksheets folder.
# Authors: Sara Hodges & Jonna Heldrich

# Files needed to run the script
## List of AD/EDs in Brooklyn (ad_ed_list.csv)
## Election district shapefile from NYC Open Data (eds_nyc_20191215.shp)
## downloaded on 12/15/2019 from https://data.cityofnewyork.us/City-Government/Election-Districts/h2n3-98hq)


#### Load required packages
require(sf)
require(mapview)
require(tmap)
require(tmaptools)
require(leaflet)

### import list of all eds in brooklyn (this was created in creating_walksheets.R)
ad_ed_list <- read.csv("ad_ed_list.csv")

### importing the new york city election district shapefiles
ed_shp <- st_read("nyc_election_districts_201912.shp")

bk_ed_shp <- ed_shp %>% 
  right_join(ad_ed_list, by = c("elect_dist" = "ad_ed"))

#############################
#### tester with ad56_27 ###
#############################
ad56_27 <- bk_ed_shp %>% 
  mutate(elect_dist = as.character(elect_dist)) %>% 
  filter(elect_dist == "56027") 

temp_2_map <- tm_basemap("CartoDB.Voyager") +
  tm_shape(ad56_27) +
  tm_borders(lwd=3, col = "red", alpha = 1) +
  tm_layout(main.title = "AD 56, ED 27",
    frame = FALSE) ## remove black border frame

lf <- tmap_leaflet(temp_2_map) %>% 
  addControl("test", position = "topright") ### adds title

### writes out an image of the leaflet map above
mapshot(lf, file = "test6.png")

#############################
######## END TESTING #######
#############################

#### ad_ed_list is the dataframe to loop through 
#### use this first if you want to create new maps for a few districts to test the loop
# aded_list <- ad_ed_list %>%
#   filter(ad_ed == "56044" | ad_ed == "51082" |
#            ad_ed == "45003")

### turns ad ed list into list to loop thorugh
ad_ed <- as.list(pull(ad_ed_list, ad_ed))

for (ed in ad_ed){
  shape <- bk_ed_shp %>% 
    filter(elect_dist == ed)  ### filters the appropriate election district
  
  ed_title <- paste0("AD ", substr(ed, 0, 2), " ED ", substr(ed, 3, 5))  ### creates title
  
  temp_2_map <- tm_basemap("CartoDB.Voyager") +
    tm_shape(shape) +
    tm_borders(lwd=3, col = "red", alpha = 1) +
    tm_layout(frame = FALSE) ## remove black border frame

  lf <- tmap_leaflet(temp_2_map) %>%
    addControl(ed_title, position = "topright") ### adds title
  i <- as.numeric(substr(ed,1,nchar(ed)-3))
  j <- as.numeric(substr(ed,nchar(ed)-2, nchar(ed)))
  ### writes out an image of the leaflet map above
  filename_aded <- paste0("walksheets/AD_",i,"/", "ad_", i, "_ed_", j,"/","ad_", i, "_ed_", j,"_map.png")
  mapshot(lf, file = filename_aded)
}


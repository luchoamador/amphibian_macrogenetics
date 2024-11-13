###Caudata macrogenetics###
###Get species geographic ranges and areas
##Luis Amador
##2024


# Install rasterSp from Github
if(!"rasterSp" %in% installed.packages()[,"Package"]) remotes::install_github("RS-eco/rasterSp", build_vignettes = T)
library(rasterSp)

#Download IUCN range maps for a given taxa or group
#You will need the e-mail address and password you used to login at the IUCN Website
getIUCN(taxa = "Amphibians", group = "", user = "myuser@gmail.com", password = "mypassword", path = "/Path/to/download/location/")


#Rasterize shapefile of multiple polygons to individual global rasters with a specific resolution

setwd("/path/to/New_IUCN_ranges/")

rasterizeRange(
  dsn = paste0(getwd(), "/Caudata_shp/data_0.shp"),
  id = "SCI_NAME",
  resolution = 0.5,
  save = TRUE,
  touches = TRUE,
  extent = c(-180, 180, -90, 90),
  split = NA,
  name_split = c(1, 2),
  seasonal = NA,
  origin = 1,
  presence = NA,
  getCover = F,
  df = T,
  crs = "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0",
  path = "/path/to/New_IUCN_ranges/"
)


################################################################################
################################################################################

#Calculating Minimum convex polygons based on occurrences associated with sequences and range size area

###########################
##Minimum convex polygons##
###########################

# Load necessary libraries
library(sp)
library(adehabitatHR)
library(raster)
library(tidyverse)

# Get a list of file paths for each species
species_files <- list.files("~/My/species/coordinates/", pattern = "*.csv", full.names = TRUE)

# List to store MCP polygons for each species
mcp_polygons <- list()

# Iterate through each csv file
for (coords_sp in species_files) {
  
  # Load coords
  coords <- read_csv(coords_sp)
  
  #Create a spatial points object from the coordinates
  
  coords_all <- data.frame(Lon=coords$Lon, Lat=coords$Lat)
  coordinates(coords_all) <- c("Lon", "Lat")
  proj4string(coords_all) <- CRS( "+proj=longlat +datum=WGS84 +no_defs")
  
  mcp_all <- mcp(coords_all, percent = 100)
  
  #Extract species names
  species_name <- basename(coords_sp)
  species_name <- tools::file_path_sans_ext(species_name)
  
  # save each MCP as a shapefile
  shapefile_name <- paste0(species_name, "_MCP.shp")
  shapefile(mcp_all, filename = shapefile_name)
  
  # Store MCP result
  mcp_polygons[[species_name]] <- mcp_all
  
}

#############################
##Calculate range size area##
#############################

input_path <- "~/path/to/my/shapefiles/"
files <- list.files(input_path, pattern = "*.shp", full.names=T)

for(f in files){
  
  #Read shapefiles
  shp <- shapefile(f)
  
  #calculate area
  areas <- areaPolygon(shp) / 1000000
  
  #get name
  sp <- basename(f)
  sp <- tools::file_path_sans_ext(sp)
  
  #save mean land covers
  write.table(data.frame(sp, areas), file = "Areas_Caudata.csv", quote = FALSE, row.names = FALSE, col.names = !file.exists("Areas_Caudata.csv"), append = TRUE, sep = ";")
  
}

###Extracting data from WordlClim###
###Caudata macrogenetics Project###
##Luis Amador 2024##

# Import required library
library(raster)
library(sp)
library(geodata)
library(tools)

#Set a path
getwd()
path <- "/my_path/"


#################################################################
#Get temp and prec for each species#
#################################################################

################################################################################################

#Resolution
bcRes <- 2.5

#Extract worldclim data - bioclimatic variables
b <- worldclim_global(var = 'bio', bcRes, path)

setwd("~/My/WorldClim/downloaded/data")

f <- list.files(pattern = "tif$")
x <- lapply(f, brick)
s <- stack(x)


setwd("~/My_coordinates/")
#list of file paths with coordinates
myocurr <- list.files(pattern = "_coords.csv", full.names = TRUE, recursive = TRUE)

#Automate retrieving Worldclim data per species

for (coord in myocurr) {
  
  #read coordinates
  coords <- read.csv(file = coord)
  
  coords_ll <- data.frame(Lon=coords$Lon, Lat=coords$Lat)
  
  points <- SpatialPoints(coords_ll, proj4string = s@crs)
  
  values <- raster::extract(s, points)
  
  df <- cbind.data.frame(coords$value, coordinates(points), values)
  
  #get name
  sp <- basename(coord)
  sp <- tools::file_path_sans_ext(sp)
  
  # Save the worldclim data associated to each species/coordinates to a file
  output_filename <- paste0(tools::file_path_sans_ext(coord), "_worldclim.csv")
  write.csv(df, file = output_filename)
  
}


################################################################################

##worldclimclimatic variables##
#worldclim1 = Annual Mean Temperature 'bio01'
#worldclim2 = Mean Diurnal Range (Mean of monthly (max temp - min temp))
#worldclim3 = Isothermality (worldclim2/worldclim7) (×100)
#worldclim4 = Temperature Seasonality (standard deviation ×100)
#worldclim5 = Max Temperature of Warmest Month
#worldclim6 = Min Temperature of Coldest Month
#worldclim7 = Temperature Annual Range (worldclim5-worldclim6)
#worldclim8 = Mean Temperature of Wettest Quarter
#worldclim9 = Mean Temperature of Driest Quarter
#worldclim10 = Mean Temperature of Warmest Quarter
#worldclim11 = Mean Temperature of Coldest Quarter
#worldclim12 = Annual Precipitation
#worldclim13 = Precipitation of Wettest Month
#worldclim14 = Precipitation of Driest Month
#worldclim15 = Precipitation Seasonality (Coefficient of Variation)
#worldclim16 = Precipitation of Wettest Quarter
#worldclim17 = Precipitation of Driest Quarter
#worldclim18 = Precipitation of Warmest Quarter
#worldclim19 = Precipitation of Coldest Quarter

####NOTE:Please note that the temperature data are in °C * 10. This means that a value of 231 represents 23.1 °C. The unit used for the precipitation data is mm (millimeter).

###Working with sequence data###
#Luis Amador
#Global Caudata Macrogenetics Project

#####################################################################################
#Build a table to write the coordinates associated to DNA sequences

#Read and extract header of sequence from fasta file
library(phylotools)
names <- get.fasta.name("~/Dropbox/Gen_diversity_amphians_NSF/Global_caudata/Cadata_all_fastas/Triturus_cristatus_CytB.fasta", clean_name = FALSE)
class(names)

#change the object to a table or data frame
library(tidyverse)
names <- as_tibble(names)

#create latitude column
names <- names %>%
  add_column(Lat = NA)
#create longitude column
names <- names %>%
  add_column(Lon = NA)
#create Error_km column
names <- names %>%
  add_column(Error_km = NA)
#create method column
names <- names %>%
  add_column(Method = NA)
#create Museum_Field_Number column
names <- names %>%
  add_column(Voucher = NA)
#create Notes column
names <- names %>%
  add_column(Notes = NA)
#create Reference column
names <- names %>%
  add_column(Reference = NA)

#or

names <- names %>%
  add_column(Lat = NA, Lon = NA,  Error_km = NA, Method = NA, Museum_Field_Number = NA, Notes = NA, Reference = NA)

setwd("~/Dropbox/Gen_diversity_amphians_NSF/Global_caudata/Fastas_heroes")
#save data frame as a csv file
write_csv(names, file = "Triturus_cristatus_coords.csv")


###############################################################################
###############################################################################
#Change format of coordinates from dms to decimal degrees

library(measurements)
library(tidyverse)
library(reshape2)

#Values must be entered as a string with one space between subunits (e.g. 70° 33’ 11” = "70 33 11").
#Example:

lat <- conv_unit('29 57 26.9', from = "deg_min_sec", to = "dec_deg")
long <- conv_unit('-90 08 34.2', from = "deg_min_sec", to = "dec_deg")

print(c(lat, long))
#> [1] "21.1900888888889" "104.6408"


################################################
################################################
##Automate with multiple coordinates at the time

latlon <- read_csv(file = "Lat_Lon_B_major.csv")

for (ll in latlon) {
  
  #Create objects with Latitude and Longitude per sequence
  LA <- latlon$Latitude
  LO <- latlon$Longitude
  
  #Convert coordinates
  lat <- conv_unit(LA, from = "deg_min_sec", to = "dec_deg")
  lon <- conv_unit(LO , from = "deg_min_sec", to = "dec_deg")
  
  #Explore characters
  print(lat)
  print(lon)
  class(lat)
  
  #Combine characters lat and lon
  ll <- paste(lat, lon)
  
  #Create a data frame
  ll <- as.matrix(ll)
  ll <- as.data.frame(ll)
  df_ll <- ll %>%
    separate(V1, c("Lat", "Lon"), " ")
  
  #Save the data frame
  write_csv(df_ll, file = "B_major_dec_deg.csv")
  
}

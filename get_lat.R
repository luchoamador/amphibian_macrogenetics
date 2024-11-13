###Get Latitude data###
###Caudata Macrogenetics###
###Luis Amador
###2024

#############################################################
# Load required libraries #
library(dplyr)
library(stringr)

# Sample data with geographic coordinates

#automate this process for all species in our dataset
csv_folder <- "/home/myuser/mydirectory/My_species_coordinates/"
# Get a list of names
csv_names <- list.files(csv_folder, pattern = "\\.csv$")

# Iterate through each csv file
for (csv_name in csv_names) {
  
  # Load coords
  coordinates <- read_csv(csv_name)
  Latitudes <- coordinates$y
  
  # Convert coordinates to numeric
  coordinates_numeric <- as.numeric(Latitudes)
  
  # Calculate mean, maximum, and minimum latitude
  mean_latitude <- mean(coordinates_numeric)
  max_latitude <- max(coordinates_numeric)
  min_latitude <- min(coordinates_numeric)
  
  # Format latitude to have more than two decimals
  mean_latitude_formatted <- str_pad(mean_latitude, width = 5, side = "right", pad = "0")
  max_latitude_formatted <- str_pad(max_latitude, width = 5, side = "right", pad = "0")
  min_latitude_formatted <- str_pad(min_latitude, width = 5, side = "right", pad = "0")
  
  # Print results
  cat("Mean Latitude:", mean_latitude_formatted, "\n")
  cat("Max Latitude:", max_latitude_formatted, "\n")
  cat("Min Latitude:", min_latitude_formatted, "\n")
  
  #get name
  sp <- basename(csv_name)
  sp <- tools::file_path_sans_ext(sp)
  
  # Save min and max elevation
  write.table(data.frame(sp, mean_latitude_formatted, max_latitude_formatted, min_latitude_formatted), file = "Latitude_Caudata.csv", quote = FALSE, row.names = FALSE, col.names = !file.exists("Latitude_Caudata.csv"), append = TRUE, sep = ",")
  
}

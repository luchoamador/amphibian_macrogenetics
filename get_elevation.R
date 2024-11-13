#Get elevation data#
###Caudata Macrogenetics###
###Luis Amador
###2024

library(elevatr)

#automate the process for all species in our dataset
csv_folder <-  "/home/myuser/mydirectory/My_species_coordinates/"
# Get a list of names
csv_names <- list.files(csv_folder, pattern = "\\.csv$")

ll_prj <- "EPSG:4326"

# Iterate through each csv file
for (csv_name in csv_names) {
  
  # Load coords
  coords <- read.csv(csv_name)
  
  # Get Elevation
  elev <- get_elev_point(coords, prj = ll_prj, src = 'aws')
  elev_max <- max(elev$elevation)
  elev_min <- min(elev$elevation)
  elev_mean <- mean(elev$elevation)
  
  #get names
  sp <- basename(csv_name)
  sp <- tools::file_path_sans_ext(sp)
  
  # Save species name, mean, min and max elevation
  write.table(data.frame(sp, elev_min, elev_max, elev_mean), file = "Elevation_Caudata.csv", quote = FALSE, row.names = FALSE, col.names = !file.exists("Elevation_Caudata.csv"), append = TRUE, sep = ",")
  
}

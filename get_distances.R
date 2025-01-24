###Calculating genetic, geographic and environmental distances###
###Caudata macrogenetics project###
##Luis Amador 2024##

## Genetic distances ##

# Load required library
library(ape)


# Set working directory to where alignment files are located
setwd("~/Dropbox/Gen_diversity_amphians_NSF/Global_caudata/Cadata_all_fastas/Caudata_fastas/")

# Get a list of all fasta files in the directory
alignment_files <- list.files(pattern = "\\.fasta$")

# Create a directory to save distance tables
dir.create("distance_tables", showWarnings = FALSE)

# Iterate through each file
for (file in alignment_files) {
  # Read the alignment
  alignment <- read.dna(file = file, format = "fasta")
  
  # Calculate genetic distances using the p-distance method
  distances <- dist.dna(alignment, model = "raw")
  
  # Convert distance object to a matrix
  distance_matrix <- as.matrix(distances)
  
  # Define the output file name
  output_file <- paste0("distance_tables/", gsub("\\.fasta", "_gendistances.txt", file))
  
  # Save the distance matrix as a table
  write.table(distance_matrix, file = output_file, row.names = FALSE, col.names = FALSE)
}

##########################
## Geographic distances ##

# Load required library
library(tidyverse)

# Setting working directory where coordinate files are located
setwd("~/Dropbox/Gen_diversity_amphians_NSF/Global_caudata/Caudata_seqs_coords/")
# Get a list of all fasta files in the directory
coords_files <- list.files(pattern = "\\.csv$")
# Create a directory to save distance tables
dir.create("geodist_tables", showWarnings = FALSE)

# Iterate through each file
for (file in coords_files) {
  # Read coords
  my.occurrences <- read_csv(file = file)
  my.coords <- cbind(my.occurrences$Lat, my.occurrences$Lon)
  
  # Calculate geographic distances using the Euclidean
  distances <- dist(my.coords)
  
  # Convert distance object to a matrix
  geodist_matrix <- as.matrix(distances)
  
  # Define the output file name
  output_file <- paste0("geodist_tables/", gsub("\\.csv", "_geodistances.txt", file))
  
  # Save the distance matrix as a table
  write.table(geodist_matrix, file = output_file, row.names = FALSE, col.names = FALSE)
}

#############################
## Environmental distances ##

#Load libraries
library(tidyverse)
library(vegan)

#Setting working directory
setwd("/home/luis/Dropbox/Gen_diversity_amphians_NSF/Global_caudata/Caudata_seqs_coords/Caudata_coordinates/")
csv_folder <- "/home/luis/Dropbox/Gen_diversity_amphians_NSF/Global_caudata/Caudata_seqs_coords/Caudata_coordinates/"

#WorldClim data
csv_files <- list.files(csv_folder, pattern = "\\_coords_OK_worldclim.csv$", full.names = TRUE, recursive = TRUE)

# Iterate through each file
for (csv in csv_files) {
  
  #Load csv files with worldclim data
  #csv_file_name <- gsub("\\.shp$", ".csv", txt)
  csv_bio <- read_csv(csv, na = c("", "NA")) #data frame with 19 worldclim variables
  names(csv_bio)[names(csv_bio) == "coords$value"] <- "species_name" #Change the name of the ID
  #names(txt_bio)[names(txt_bio) == "...1"] <- "ID" #Change the name of the ID
  
  #remove lat, lon and species name
  csv_bio <- csv_bio %>% 
    dplyr::select(-Lon, -Lat, -species_name) # %>%
  #left_join(land_cover_extracted, by = "ID") #combining data frames land cover and worldclim
  #  txt_bio <- txt_bio %>%
  #    dplyr::select(-ID, -species_name)
  
  #omit NA
  #csv_bio <- csv_bio %>% 
  # scale()
  
  csv_bio_normalized <- scale(csv_bio)
  
  #do PCA on env variables to get one number per gps point
  #csv_pca <- prcomp(csv_bio)
  
  #get PC1 values for each individual
  #csv_scores <- as.data.frame(csv_pca$x)
  #pc1_3 <- csv_scores[,1:3]
  
  csv_envdist <- vegdist(csv_bio_normalized, method="euclidean", na.rm = TRUE)
  csv_envdist <- as.matrix(csv_envdist)
  
  # Save the environmental distance matrix to a file
  output_filename <- paste0(tools::file_path_sans_ext(csv), "_envdistances.txt")
  write.table(csv_envdist, file = output_filename, row.names = FALSE, col.names = FALSE)
  
}

##Editing phylogenetic tree to match species in the dataset##
#Caudata macrogenetics#
#Luis Amador, Lisa Barrow#

library(ape)
library(geiger)
library(evobiR)

#setwd("~/Dropbox/Gen_diversity_amphians_NSF/Global_caudata/")

# Load tree
phy <- read.tree("subset_Caudata.tree")

# Load data
caudata <- read.csv("Caudata_matrices/Caudata_matrix.csv")

# Check that species names match
name.check(phy, caudata)

#Edit names in tree.
phy$tip.label[138] <- "Speleomantes_ambrosii"
phy$tip.label[139] <- "Speleomantes_italicus"
phy$tip.label[137] <- "Speleomantes_strinatii"
phy$tip.label[141] <- "Speleomantes_flavus"
phy$tip.label[142] <- "Speleomantes_supramontis"
phy$tip.label[143] <- "Speleomantes_imperialis"
phy$tip.label[140] <- "Speleomantes_genei"
phy$tip.label[177] <- "Isthmura_bellii"
phy$tip.label[57] <- "Hypselotriton_cyanurus"
phy$tip.label[58] <- "Hypselotriton_orientalis" 
phy$tip.label[55] <- "Hypselotriton_orphicus" 
phy$tip.label[72] <- "Paramesotriton_guangxiensis"

# drop species from data frame to match tree
caudata <- subset(caudata, Species!="Tylototriton_himalayanus")
caudata <- subset(caudata, Species!="Pachytriton_wuguanfui")
caudata <- subset(caudata, Species!="Pachytriton_xanthospilos")
caudata <- subset(caudata, Species!="Paramesotriton_aurantius")
caudata <- subset(caudata, Species!="Onychodactylus_fuscus")
caudata <- subset(caudata, Species!="Onychodactylus_intermedius")
caudata <- subset(caudata, Species!="Onychodactylus_pyrrhonotus")
caudata <- subset(caudata, Species!="Ommatotriton_nesterovi")
caudata <- subset(caudata, Species!="Hynobius_nagatoensis")
caudata <- subset(caudata, Species!="Hynobius_oni")
caudata <- subset(caudata, Species!="Hynobius_setoi")
caudata <- subset(caudata, Species!="Hynobius_setouchi")
caudata <- subset(caudata, Species!="Hynobius_utsunomiyaorum")
caudata <- subset(caudata, Species!="Hynobius_vandenburghi")
caudata <- subset(caudata, Species!="Hydromantes_samweli")
caudata <- subset(caudata, Species!="Hynobius_akiensis")
caudata <- subset(caudata, Species!= "Hynobius_bakan")
caudata <- subset(caudata, Species!="Hynobius_fossigenus")
caudata <- subset(caudata, Species!="Hynobius_geiyoensis")
caudata <- subset(caudata, Species!="Hynobius_iwami")
caudata <- subset(caudata, Species!="Hynobius_kunibiki")
caudata <- subset(caudata, Species!="Eurycea_hillisi")
caudata <- subset(caudata, Species!="Eurycea_melanopleura"  )
caudata <- subset(caudata, Species!="Eurycea_nerea")
caudata <- subset(caudata, Species!="Eurycea_paludicola")
caudata <- subset(caudata, Species!="Eurycea_subfluvicola")
caudata <- subset(caudata, Species!="Eurycea_braggi")
caudata <- subset(caudata, Species!="Bolitoglossa_yariguiensis")
caudata <- subset(caudata, Species!="Desmognathus_amphileucus")
caudata <- subset(caudata, Species!="Batrachuperus_daochengensis" )
caudata <- subset(caudata, Species!="Batrachuperus_taibaiensis")
caudata <- subset(caudata, Species!="Bolitoglossa_copinhorum")
caudata <- subset(caudata, Species!="Andrias_cheni")
caudata <- subset(caudata, Species!="Andrias_sligoi")
caudata <- subset(caudata, Species!="Hynobius_sumidai")
caudata <- subset(caudata, Species!="Aneides_niger")
caudata <- subset(caudata, Species!="Aneides_caryaensis")
caudata <- subset(caudata, Species!="Desmognathus_intermedius")
caudata <- subset(caudata, Species!="Desmognathus_aureatus")
caudata <- subset(caudata, Species!="Aneides_klamathensis")

#Check species names
chk <- name.check(phy, caudata)
summary(chk)
chk

phy$tip.label %in% caudata$Species #TRUE
phy$tip.label
caudata$Species

length(phy$tip.label)
length(unique(caudata[,4]))

setdiff(phy$tip.label, caudata[,4])
setdiff(caudata[,1], phy$tip.label)

#Reorder species names to match species order in both tree and dataset
caudata <- ReorderData(phy, caudata, taxa.names = 4)
phy$tip.label
caudata$Species
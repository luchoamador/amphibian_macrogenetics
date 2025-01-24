###Caudata phylogeny###
#using Jetz & Pyron 2018 tree#
##Caudata macrogenetics project##
##Luis Amador 2023##

#Load package
library(ape)

#Reading Amphibia tree
amph.tree <- read.tree(file = "~/Documents/luis_trabajo/Amphibia/amph_shl_new_Consensus_7238.tre")
class(amph.tree) #phylo
plot(amph.tree)
plot.phylo(amph.tree, type = "radial")
amph.tree$tip.label

#### EXTRACT PORTION OF TREE FOR Caudata
mrca(amph.tree)["Thorius_narisovalis", "Batrachuperus_karlschmidti"] #Find Most Recent Common Ancestors Between Pairs
caudata.tree <- extract.clade(amph.tree, 7419)
plot(caudata.tree,cex=0.3)
plot.phylo(caudata.tree, cex = 0.1)
caudata.tree$tip.label
class(caudata.tree)
write.tree(caudata.tree, file = "Global_Caudata.tree")

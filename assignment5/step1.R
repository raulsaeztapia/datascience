# Set working directory and import datafiles
setwd(".")
seaflow <- read.csv("seaflow_21min.csv")

# Examine structure of dataframe
str(seaflow)

# summary pop field for know how many synecho values
summary(seaflow$pop)

# summary 3rd Quantile of fsc_small field
summary(seaflow$fsc_small)

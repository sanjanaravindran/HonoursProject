# Install/Load libraries
if (!require("pacman")) install.packages("pacman")
pacman::p_load(here, usethis, ggplot2, reshape, dplyr, magrittr, cowplot, gdata, tidyr)

# Load the data 
tl_para_lambs2011 <- read.csv(here("RTL_Parasites_Lambs2011.csv"))

# Explore the data 
ggplot(tl_para_lambs2011, aes(x=RTL)) +
  geom_density()
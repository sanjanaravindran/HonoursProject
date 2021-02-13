# Installing and loading libraries (In order to conduct the analysis, 
# we will be using functions developed by others that are stored in 
# different 'packages'. But first, we need to install these packages in 
# our local computer and and then load them into our working environment)
if (!require("pacman")) install.packages("pacman")
pacman::p_load(here, usethis, ggplot2, reshape, dplyr, magrittr, cowplot, gdata, tidyr)

# Load the data (you can choose any name for the dataset but try to 
# use a file name that is concise and descriptive; separating words 
# with an underscore helps with readability. For instance, I use 
# the name 'tl_par_lambs2011' to indicate what this dataset contains - TL 
# and parasite data of lambs in the year 2011)
tl_par_lambs2011 <- read.csv(here("RTL_Parasites_Lambs2011.csv"))

# We are first going to explore what the data looks like 
# We will do so using ggplot2, a package that lets us plot and visualize
# data. 
ggplot(tl_para_lambs2011, aes(x=RTL)) +
  geom_point() +
  geom_density()

# I have added a new line
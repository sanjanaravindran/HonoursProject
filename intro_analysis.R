# Installing and loading libraries (In order to conduct the analysis, 
# we will be using functions developed by others that are stored in 
# different 'packages'. But first, we need to install these packages in 
# our local computer and and then load them into our working environment)
if (!require("pacman")) install.packages("pacman")
pacman::p_load(here, usethis, ggplot2, dplyr, magrittr, car)

# Load the data (you can choose any name for the dataset but try to 
# use a file name that is concise and descriptive; separating words 
# with an underscore helps with readability. For instance, I use 
# the name 'lambs2011' to indicate what this dataset contains - TL 
# and parasite data of lambs in the year 2011)
lambs2011 <- read.csv(here("lambs2011.csv"))

# Let's study the structure of this dataset. 
str(lambs2011)

# You can now see what is in this dataset. We have 74 observations (rows)
#  and 13 variables (columns). You can also click on 'Environment' and 
# click on the dataset to scroll through the dataset. The different column
# names describe what the data are (e.g. ID = Unique identity number for
# every individual, Sex = whether the lamb was male or female etc..). 

# We are first going to explore what the data looks like. We will do so 
# using ggplot2, a package that lets us plot and visualize data. 

# Let's look at the telomere data first. We first tell ggplot 
#  where to look for the data. We then tell it to plot the TL data
# on x axis and to plot a histogram 
ggplot(lambs2011, aes(x=RTL)) +
  geom_histogram()

# How do you think the distribution of this data looks like 
# Is this a normal distribution?
ggplot(lambs2011, aes(x=RTL)) +
  geom_density()

# Let's look at the strongyle data next. How does this look?
# Can you guess the distribution this most closely resembles?
ggplot(lambs2011, aes(x=Strongyles)) +
  geom_histogram()

ggplot(lambs2011, aes(x=Strongyles)) +
  geom_density()

# As a simple exercise, let's try to find which lamb was found to have 
# the least number of strongyles? 
lambs2011 %>%
  filter(Strongyles == min(Strongyles))

# Above, we first tell R where to look for the data by calling our 
# dataset. We then use the pipe function (%>%) which allows us to tell R
# to do the following steps in order one after the other. We tell it to 
# filter the dataset for that value of Strongyles which is equal to the 
# minimum value in the entire Strongyles column. In this way, we find that
# lamb with ID number 8258 had 0 strongyles. Do you think that is normal?

# If you feel curious, feel free to explore other parts of the dataset
#  in a similar manner. For instance, can you find out which lamb weighs
# the heaviest in the dataset?

# Since we are interested in the relationship between TL and Strongyles,
# let us try to explore how both of them look together in a single plot
ggplot(lambs2011, aes(y=RTL, x=Strongyles)) +
  geom_point() +
  geom_line()

# How does this appear to you? Do you think individuals with shorter TL
# have more strongyles found in their faeces? It's hard to say, right?
# You can see some individuals with longer TL having low number of 
# strongyles and also, other individuals with shorter TL having low number 
# of strongyles. What if I told you that using statistics/ linear regression, 
# we can actually get a quantitative feel for what the 
# association between TL and strongyles is? That's pretty neat! 
# Let's try to do that! But first, how about you make a guess - do you 
# think lambs with more strongyles have shorter TL after looking at the
# data just now? By how much - do lambs that have a 2 unit increase in strongyles
# also experience a 2 unit decrease in TL or do you think they experience a 
# 1 unit decrease in TL? Can you tell from just looking? Well, using statistics,
# we can actually understand this. Let's go!

# We will first try to fit a simple linear model (I'm calling it model1).
# Since we are interested in knowing whether we observe a cost of infection
# that manifests as a decrease in telomere length, we can think of the 
# relationship between TL and Strongyles as Strongyle infection leading to 
# shorter TL (although be aware that since this is an observational study,
# we cannot establish true causality.) So we are interested in testing
# whether an infection with strongyles in the lambs can predict shorter TL?
# In this case, our response/dependent variable (y) will be TL and 
# the predictor/independent variable (x) will be Strongyles. Let's first 
# fit this model. Here, we are essentially trying to find a line/linear
# equation that fits the data in the best way. 

model1 <- lm(RTL ~ Strongyles, lambs2011)

summary(model1)

# Can you tell me what the model summary tells us? For every unit change in
# strongyles, how much does TL increase/decrease by?
# Do we find a positive or negative relationship between strongyles and TL?


# Let's try to visualize this line
ggplot(lambs2011, aes(y=RTL, x=Strongyles)) +
  geom_point() +
  geom_smooth(method="lm", se=F)

# What does looking at the figure tell you, how does the line appear? Also,
# How well does the line predicted by the model actually fit our data?
# Let's check by calculating the R-squared value
summary(model1)$r.squared

# Do you think the model fits the data well? 

# But wait! We seem to have left out some information in our model. A previous 
# study in this system found that older males had shorter telomeres (Watson et al). 
# And broadly speaking, sex differences in TL have been
# reported across different species (although see a recent meta-analysis
# Remot et al). Let us try to visualize the data again by colouring the
# datapoints that correspond to males and females in different colours
ggplot(lambs2011, aes(x=RTL, colour=factor(Sex), fill=factor(Sex))) +
  geom_histogram() 

# It seems that there may be some differences between male and female lambs
# that we need to control for. By doing this, we will be able to get at a 'truer 
# effect' of strongyles on TL by accounting for the variance associated with sex. 
# Let's try to do that by including Sex as another predictor in the 
# model. Since we would like 'Sex' to be a categoricalvariable with 2 categories,
# 'Male' and 'Female', we first need to convert it into a 'factor' type instead 
# of a 'character'(chr) type that it currently is.
lambs2011$Sex <- as.factor(lambs2011$Sex)
str(lambs2011$Sex)

# Let's run a multiple regression model by including Sex as another predictor to 
# account for differences between the 2 sexes.
model2 <- lm(RTL ~ Strongyles + Sex, lambs2011)

summary(model2)

# How do you interpret the model summary here? What does the r-squared value of this model look like? 
summary(model2)$r.squared

# We can also test for whether there are sex differences in the relationship
# between TL and strongyles by including an 'interaction' between Strongyles and 
# Sex. This will tell us whether the relationship between strongyles and TL is
# sex-dependent. Do males (or females) have shorter TL with increase in strongyles?
# Based on your reading, are you expecting to see sex-specific effects?
# Let's visualize the relationship first. 

ggplot(lambs2011, aes(y=RTL, x=Strongyles, colour=factor(Sex))) +
  geom_point() +
  geom_smooth(method = "lm", se=F)

# Let's run a multiple regression model to quantify the sex-specific relationship.

model3 <- lm(RTL ~ Strongyles * Sex, lambs2011)

summary(model3)

# How do you interpret the model summary here? 
summary(model3)$r.squared

# Is the r-squared value better or worse than previous models? What does that mean?

# We also need to test the assumptions of the models we've explored
# Let's do that - 

# Checking homogeneity of variance 
# (Do you see any specific patterns? You dont want to!)
plot(resid(model1) ~ fitted(model1), pch = 16)
plot(resid(model2) ~ fitted(model2), pch = 16)
plot(resid(model3) ~ fitted(model3), pch = 16)

# Checking residuals are normally distributed
qqnorm(resid(model1))
qqline(resid(model1))

qqnorm(resid(model2))
qqline(resid(model2))

qqnorm(resid(model3))
qqline(resid(model3))

# What do you think? Are the assumptions of our models being met? 

# Do you think a straight line is the best fit for explaining the relationship 
# between TL and strongyles? Do you think a curve would be better?  

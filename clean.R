setwd("~/Repos/titanic-machine-learning-for-disaster/")
source("./load.R")



# GetCleanData should clean the original Data and leave it in a tidy format.
GetCleanData <- function(){
  data <- LoadTrain()
  names(data) <- tolower(names(data))
    
  # Pclass should be Factors
  data$pclass <- as.factor(data$pclass)
  data$survived <- as.logical(data$survived)
  
  # Set missing ages equals to the median of each Social Class (Pclass)
  # TODO: Refactor this in a method
#   summary(subset(data, pclass == 1)) # Pclass 1 median = 37
#   summary(subset(data, pclass == 2)) # Pclass 1 median = 29
#   summary(subset(data, pclass == 3)) # Pclass 1 median = 24
#   
#   indexs.pclass1 <- which(data$pclass == 1 & is.na(data$age))
#   data$age[indexs.pclass1] <- 37
#   indexs.pclass2 <- which(data$pclass == 2 & is.na(data$age))
#   data$age[indexs.pclass2] <- 29
#   indexs.pclass3 <- which(data$pclass == 3 & is.na(data$age))
#   data$age[indexs.pclass3] <- 24
#  
  # Add the column child if less than 14 (Remember this are the 1920's)
  data$child <- FALSE
  data$child[data$age < 14] <- TRUE
  
  
  data
}

GetCleanTest <- function(){
  data <- LoadTest()
  names(data) <- tolower(names(data))
  
  # Pclass should be Factors
  data$pclass <- as.factor(data$pclass)
    
  data
}

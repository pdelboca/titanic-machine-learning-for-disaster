source("./clean.R")
source("./load.R")
library(rpart)
library(rattle)
library(rpart.plot)
library(RColorBrewer)


MyFirstDesitionTree <- function(){
  train <- GetCleanData()
  test  <- GetCleanTest()
  
  fit <- rpart(survived ~ pclass + sex + age + sibsp + parch + fare + embarked, 
               data=train, 
               method="class")

  fancyRpartPlot(fit)
  
  prediction <- predict(fit, test, type = "class")
  # Change factors to Numerical Values to meet Kaggle's format
  prediction <- as.numeric(prediction)
  prediction[prediction == 1] <- 0
  prediction[prediction == 2] <- 1
  submit <- data.frame(PassengerId = test$passengerid, Survived = prediction)
  write.csv(submit, file = "./models/csv/MyFirstDesitionTree.csv", row.names = FALSE)

}

MyFirstDesitionTree()

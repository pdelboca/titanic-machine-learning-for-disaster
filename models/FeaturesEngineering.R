source("./clean.R")
source("./load.R")
library(rpart)
library(rattle)
library(rpart.plot)
library(RColorBrewer)

# Based on: 
# http://trevorstephens.com/post/73461351896/titanic-getting-started-with-r-part-4-feature
FeaturesEngineering <- function(){
  
  test <- LoadTest()
  train <- LoadTrain()

  test$Survived <- NA
  
  combi <- rbind(train, test)
  combi$Name <- as.character(combi$Name)
  
  combi$Title <- sapply(combi$Name, 
                        FUN=function(x) {strsplit(x, split='[,.]')[[1]][2]})
  combi$Title <- sub(' ', '', combi$Title)
  table(combi$Title)
  combi$Title[combi$Title %in% c('Mme', 'Mlle')] <- 'Mlle'
  combi$Title[combi$Title %in% c('Capt', 'Don', 'Major', 'Sir')] <- 'Sir'
  combi$Title[combi$Title %in% c('Dona', 'Lady', 'the Countess', 'Jonkheer')] <- 'Lady'
    combi$Title <- factor(combi$Title)
  
  combi$FamilySize <- combi$SibSp + combi$Parch + 1
  combi$Surname <- sapply(combi$Name, 
                          FUN=function(x) {strsplit(x, split='[,.]')[[1]][1]})  
  
  combi$FamilyID <- paste(as.character(combi$FamilySize), combi$Surname, sep="")
  combi$FamilyID[combi$FamilySize <= 2] <- 'Small'
  
  famIDs <- data.frame(table(combi$FamilyID))
  famIDs <- famIDs[famIDs$Freq <= 2,]
  combi$FamilyID[combi$FamilyID %in% famIDs$Var1] <- 'Small'
  combi$FamilyID <- factor(combi$FamilyID)  

  train <- combi[1:891,]
  test <- combi[892:1309,]
  
  fit <- rpart(Survived ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked + Title + FamilySize + FamilyID,
               data=train, method="class")
  fancyRpartPlot(fit)
  
  
  prediction <- predict(fit, test, type = "class")
  # Change factors to Numerical Values to meet Kaggle's format
  prediction <- as.numeric(prediction)
  prediction[prediction == 1] <- 0
  prediction[prediction == 2] <- 1
  submit <- data.frame(PassengerId = test$PassengerId, Survived = prediction)
  write.csv(submit, file = "./models/featuresengineering.csv", row.names = FALSE)
}
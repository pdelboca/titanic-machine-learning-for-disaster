source("./clean.R")
source("./load.R")
library(rpart)
library(rattle)
library(rpart.plot)
library(RColorBrewer)

# Based on: 
# http://trevorstephens.com/post/73461351896/titanic-getting-started-with-r-part-4-feature
MyPersonalFeaturesEngineering <- function(){
  
  ########### BEGIN OF TUTORIAL  ###############
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
  
  famIDs <- combi.frame(table(combi$FamilyID))
  famIDs <- famIDs[famIDs$Freq <= 2,]
  combi$FamilyID[combi$FamilyID %in% famIDs$Var1] <- 'Small'
  combi$FamilyID <- factor(combi$FamilyID)  
  ############ END OF TUTORIAL  #################
  
  ############ BEGIN PERSONAL FEATURES  #################
  # Set missing Ages equals to the Mean of each Social Class (Pclass)
  summary(subset(combi, Pclass == 1 & Sex == "male")) #  41
  summary(subset(combi, Pclass == 1 & Sex == "female")) # 37
  summary(subset(combi, Pclass == 2 & Sex == "male")) #  30.82
  summary(subset(combi, Pclass == 2 & Sex == "female")) # 27.5
  summary(subset(combi, Pclass == 3 & Sex == "male")) #  25
  summary(subset(combi, Pclass == 3 & Sex == "female")) # 22
 
  indexs.MalePclass1 <- which(combi$Pclass == 1 & combi$Sex == "male" & is.na(combi$Age))
  combi$Age[indexs.MalePclass1] <- 41
  indexs.MalePclass1 <- which(combi$Pclass == 1 & combi$Sex == "female" & is.na(combi$Age))
  combi$Age[indexs.MalePclass1] <- 37
  indexs.MalePclass1 <- which(combi$Pclass == 2 & combi$Sex == "male" & is.na(combi$Age))
  combi$Age[indexs.MalePclass1] <- 30.82
  indexs.MalePclass1 <- which(combi$Pclass == 2 & combi$Sex == "female" & is.na(combi$Age))
  combi$Age[indexs.MalePclass1] <- 27.5
  indexs.MalePclass1 <- which(combi$Pclass == 3 & combi$Sex == "male" & is.na(combi$Age))
  combi$Age[indexs.MalePclass1] <- 25
  indexs.MalePclass1 <- which(combi$Pclass == 3 & combi$Sex == "female" & is.na(combi$Age))
  combi$Age[indexs.MalePclass1] <- 22
  
  summary(combi$Age)
  
  # Add the column child if less than 14 (Remember this are the 1920's)
  combi$Child <- FALSE
  combi$Child[combi$Age < 14] <- TRUE
  
  
  
  ############  END  PERSONAL  FEATURES  #################
  # Split the combi Sets
  train <- combi[1:891,]
  test <- combi[892:1309,]
  
  fit <- rpart(Survived ~ Pclass + Sex + Age + Child + SibSp + Parch + Fare + Embarked + Title + FamilySize + FamilyID,
               data=train, method="class")
  fancyRpartPlot(fit)
  
  
  prediction <- predict(fit, test, type = "class")
  # Change factors to Numerical Values to meet Kaggle's format
  prediction <- as.numeric(prediction)
  prediction[prediction == 1] <- 0
  prediction[prediction == 2] <- 1
  submit <- data.frame(PassengerId = test$PassengerId, Survived = prediction)
  write.csv(submit, file = "./models/csv/MyPersonalFeaturesEngineering.csv", row.names = FALSE)
}
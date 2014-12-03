source("load.R")

SexPclassFare()<-function(){
  test <- LoadTest()
    
  test$Survived <- 0
  test$Survived[test$Sex == 'female'] <- 1
  test$Survived[test$Sex == 'female' & test$Pclass == 3 & test$Fare >= 20] <- 0

  submit <- data.frame(PassengerId = test$PassengerId, Survived = test$Survived)
  write.csv(submit, file = "./models/sexpclassfare.csv", row.names = FALSE)

}
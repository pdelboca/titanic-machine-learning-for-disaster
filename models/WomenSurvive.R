source("load.R")

WomenSurvive <- function(){
  test <- LoadTest()
  test$Survived <- 0
  test$Survived[test$Sex == 'female'] <- 1
  
  submit <- data.frame(PassengerId = test$PassengerId, Survived = test$Survived)
  write.csv(submit, file = "./models/csv/WomenSurvived.csv", row.names = FALSE)
}
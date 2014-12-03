source("load.R")

TheyAllPerish <- function(){
  test <- LoadTest()
  test$Survived <- rep(0, 418)
  submit <- data.frame(PassengerId = test$PassengerId, Survived = test$Survived)
  write.csv(submit, file = "./models/theyallperish.csv", row.names = FALSE)
}
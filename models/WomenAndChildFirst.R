source("load.R")

WomenAndChildFirst <- function(){
  test <- LoadTest()
  test$Survived <- 0
    
  test$child <- FALSE
  test$child[train$Age < 14] <- TRUE
  
  test$Survived[test$Sex == 'female'] <- 1
  test$Survived[test$child == TRUE] <- 1
  
  submit <- data.frame(PassengerId = test$PassengerId, Survived = test$Survived)
  write.csv(submit, file = "./models/csv/WomenAndChildFirst.csv", row.names = FALSE)
  
}

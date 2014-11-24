setwd("~/Repos/titanic-machine-learning-for-disaster/")
source("./clean.R")
library("ggplot2")

data <- get_clean_data()
str(data)

p <- ggplot(data) + theme_minimal()

# Number of passengers who survived
sum(data$survived) # 342

# Survived by Sex
p + geom_bar(aes(sex,survived),stat="identity") +
    labs(title = "Survived by Gender")

# Social Class vs Sex
p + geom_bar(aes(pclass, fill=sex), stat = "bin")

# Age Histogram
p + geom_histogram(aes(age)) + geom_vline(aes(xintercept=mean(age, na.rm=T)),
                                          color="red")

# Age Histogram by Pclass
p + geom_histogram(aes(x = age, fill = pclass))

# Survived by Social Class and Sex
class_vs_gender <- with(data, 
                        aggregate(survived,by=list(sex,pclass), FUN = sum))
names(class_vs_gender) <- c("sex", "pclass", "survived")plot
ggplot(class_vs_gender) + geom_bar(aes(x=pclass,y=survived, fill=sex), 
                                   stat = "identity")

# Basic Plot of Sex vs Pclass vs Survived
# Conclusion: Almost all females from 1st Class survived
table <- table(data$sex,data$pclass,data$survived)
plot(table, main = "Sex, Pclass, Survived")

# Proportion of People who Live by Sex and Class
prop.table(ftable(data$sex,data$pclass,data$survived),1) * 100
survival_proportions <- as.data.frame(prop.table(ftable(data$sex,data$pclass,data$survived),1) * 100)
names(survival_proportions) <- c("sex","pclass","survived","freq")
survival_proportions$survived <- gsub(0,"Died",survival_proportions$survived)
survival_proportions$survived <- gsub(1,"Lived",survival_proportions$survived)

ggplot(survival_proportions) + geom_bar(aes(x=sex,y=freq,fill=survived),stat="identity") + 
    facet_grid(~pclass) + 
    labs(title = "Proportion of People who lived by Sex and Class")

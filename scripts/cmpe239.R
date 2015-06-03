library(arules)
library(arulesViz)
library(datasets)
library(rmongodb)
library(rjson)
data(Groceries)
rules <- apriori(Groceries, parameter = list(supp = 0.008, conf = 0.5))
rulesdf <- as(rules , "data.frame")
rulesdf$lhs <- lapply(strsplit(as.character(rulesdf$rules), "\\=>"), "[", 1)
rulesdf$rhs <- lapply(strsplit(as.character(rulesdf$rules), "\\=>"), "[", 2)
rulesdf$lift <- NULL
rulesdf$rules <- NULL
rulesdf$lhs <- gsub("\\{", "", rulesdf$lhs)
rulesdf$lhs <- gsub("\\}", "", rulesdf$lhs)
rulesdf$rhs <- gsub("\\{", "", rulesdf$rhs)
rulesdf$rhs <- gsub("\\}", "", rulesdf$rhs)
jsonrules <- apply(rulesdf, 1, toJSON)
mongo <- mongo.create(host="ds037571.mongolab.com:37571", name="",username="sumitgerela",password="sumit1313",db="cmpe239project")
testns<-paste("cmpe239project","rules12",sep=".")
mongo.drop(mongo, testns)
for (i in 1:30 ) {
  bsonrules <- mongo.bson.from.JSON(jsonrules[i])
  ok<-mongo.insert(mongo,testns,bsonrules) 
}
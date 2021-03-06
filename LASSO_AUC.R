

#参考https://cloud.tencent.com/developer/article/1621581
rm(list=ls())
getwd()
setwd("/home/LYX/drafts/Lasso")
#安装包
#install.packages("MASS")
library(MASS)
library(glmnet)
library(pROC)
library(ROC)
library("xlsx")
#查看数据集
gene<-read.xlsx(file = "/home/LYX/drafts/Lasso/forR0421.xlsx",sheetName = "121sample")
data<-na.omit(gene)


#读入数据，核查数据
summary(data)
dim(data)

# # 分割数据
# set.seed(123)
# ind <- sample(2, nrow(data), replace = TRUE, prob = c(0.7, 0.3))
# 
# # 训练集
# train <- data[ind==1, ] #the training data set
# # 测试集
# test <- data[ind==2, ] #the test data set
data$cancer<-ifelse(data$cancer==0,"healthy","unhealthy")
data$cancer<-as.factor(data$cancer)
# Convert data to generate input matrices and labels:
# x相当于临床信息
x <- as.matrix(data[, 3:8])
# y是临床结局
y <- data$cancer
print(y)
# 5-fold交叉验证，找出最佳lambda值
fitCV <- cv.glmnet(x, y, family = "binomial",
                   type.measure = "deviance")
plot(fitCV)

# check the coef
fit <- glmnet(x, y, family = "binomial", alpha = 1) # make sure alpha = 1
plot(fit, xvar="lambda",label = TRUE)
#abline(v = log(fitCV$lambda[54],10), lty = 3,lwd = 2,col = "black")
abline(v = log(fitCV$lambda.min,10), lty = 3,lwd = 2,col = "black")
abline(v = log(fitCV$lambda.1se,10), lty = 3,lwd = 2,col = "black")
a<-fitCV$lambda.min
b<-fitCV$lambda.1se
# get the coef

coef.fit = coef(fitCV, s = fitCV$lambda.min) 
coef.fit

coef.fit= coef(fitCV, s = fitCV$lambda.1se)
coef.fit
# 开始进行模型检验
#首先是训练集

#最适模型fitCV$lambda.min
# > coef.fit = coef(fitCV, s = fitCV$lambda.min) 
# > coef.fit
# 7 x 1 sparse Matrix of class "dgCMatrix"
# 1
# (Intercept) -5.28440
# ΔSDC2       0.06249
# ΔTFPI2      3.78357
# ΔNDRG4      .      
# ΔWIF1       1.26367
# ΔALX4       .      
# ΔKCNQ5      1.78465
# predCV.train <- predict(fitCV, newx = as.matrix(data[,3:8]),
#                         s = fitCV$lambda.min,type = "response")
# actuals.train <- ifelse(data$cancer == "unhealthy", 1, 0)

#最简模型
# > coef.fit= coef(fitCV, s = fitCV$lambda.1se)
# > coef.fit
# 7 x 1 sparse Matrix of class "dgCMatrix"
# 1
# (Intercept) -2.2707
# ΔSDC2       0.8836
# ΔTFPI2      1.2074
# ΔNDRG4      .     
# ΔWIF1       .     
# ΔALX4       .     
# ΔKCNQ5      0.4645
predCV.train <- predict(fitCV, newx = as.matrix(data[,3:8]),
                        s = fitCV$lambda.1se,type = "response")
actuals.train <- ifelse(data$cancer == "unhealthy", 1, 0)



re.train=cbind(actuals.train ,predCV.train)
head(re.train)
# #其次是测试集
# predCV.test  <- predict(fitCV, newx = as.matrix(test[,3:7]),
#                         s = fitCV$lambda.min,type = "response")
# actuals.test <- ifelse(test$cancer == 1, 1, 0)
# re.test=cbind(actuals.test ,predCV.test)
# head(re.test)

re.train=as.data.frame(re.train)
colnames(re.train)=c('cancer','prob_min')
head(re.train)
re.train$cancer=as.factor(re.train$cancer)
library(ggplot2)
library(ggpubr) 
# p1 = ggboxplot(re.train, x = "cancer", y = "prob_min",
#                color = "cancer", palette = "jco",
#                add = "jitter")+ stat_compare_means()
# p1
# 


## plot ROC 
# x1<-plot.roc(actuals.train,predCV.train,smooth=F,lwd=2,
#              ylim=c(0,1),xlim=c(1,0),legacy.axes=T,main="",
#              col="red",print.thres.pattern=T)

x1<-roc(actuals.train,predCV.train,plot = T, print.thres=T, print.auc=T,col="red",main="SDC2+NDRG4+WIFI")
# x2<-plot.roc(actuals.test,predCV.test,smooth=F,add=T,lwd=2,
#              ylim=c(0,1),xlim=c(1,0),legacy.axes=T,
#              main="",col="seagreen3")
# check ROC
# plot(x1, print.auc=TRUE, auc.polygon=TRUE, grid=c(0.1, 0.1),
#      grid.col=c("#4292C6", "#4292C6"), max.auc.polygon=TRUE,
#      auc.polygon.col="#EFF3FF", print.thres=TRUE, main="SDC2+TFP1+KCNQ5")
#dev.off()

#x1[]
# library("RColorBrewer")
# display.brewer.all()
# display.brewer.pal(n = 8, name = 'Blues')
# 
# mypalette<-brewer.pal(7,"Blues")
# mypalette

x1[["auc"]]
#x1[]
# x2[["auc"]]

# add figure legend

legend.name <- c(paste("AUC",sprintf("%.3f",x1[["auc"]])))
legend("bottomright", legend=legend.name,lwd = 2,
       col = c("red","seagreen3"),bty="n")




#多个roc曲线图合并在一起
install.packages("pROC")
library(pROC)
library(xlsx)
library(ggplot2)
intg<-read.xlsx("F:/apexbio/cfDNA integraty for pancreatic cancer/图/integrity.xlsx",sheetName="New")
#View(aSAH)
R<-roc(intg$group,intg$dpcrintegrity,plot = T, print.thres=T, print.auc=T,levels = c("cancer","normal"))

#integrity and ALU400 & Cancer and normal
library(ggplot2)
roc1<-roc(intg$group,intg$dpcrintegrity,plot = T, 
          print.thres=T, print.auc=T,levels = c("cancer","normal"))
roc2<-roc(intg$group,intg$X400bpML,plot = T, 
          print.thres=T, print.auc=T,levels = c("cancer","normal"))

g2<-ggroc(list(Integrity=roc1,ALU400 = roc2),aes = legacy.axes = TRUE,size=2)
g3<-g2+theme_minimal() + 
  geom_segment(aes(x = 0, xend = 1, y = 0, yend = 1),
               color="darkgrey", linetype="dashed")+
  theme_classic()
g3

#integrity and ALU400 & Cancer and infla
roc3<-roc(intg$group,intg$dpcrintegrity,plot = T, 
          print.thres=T, print.auc=T,levels = c("cancer","infla"))
roc4<-roc(intg$group,intg$X400bpML,plot = T, 
          print.thres=T, print.auc=T,levels = c("cancer","infla"))

g4<-ggroc(list(Integrity=roc3,ALU400 = roc4),legacy.axes = TRUE,size=2)
g5<-g4+theme_minimal() + 
  geom_segment(aes(x = 0, xend = 1, y = 0, yend = 1),
               color="darkgrey", linetype="dashed")+
  theme_classic()
g5

#integrity and ALU400 & normal and infla
roc5<-roc(intg$group,intg$dpcrintegrity,plot = T, 
          print.thres=T, print.auc=T,levels = c("normal","infla"))
roc6<-roc(intg$group,intg$X400bpML,plot = T, 
          print.thres=T, print.auc=T,levels = c("normal","infla"))

g6<-ggroc(list(Integrity=roc5,ALU400 = roc6),legacy.axes = TRUE,size=2)
g7<-g6+theme_minimal() + 
  geom_segment(aes(x = 0, xend = 1, y = 0, yend = 1),
               color="darkgrey", linetype="dashed")+
  theme_classic()
g7





library('Cairo')
png(filename="F:/apexbio/cfDNA integraty for pancreatic cancer/图/cfdnaROCCI.png",
    type="cairo",
    units="in", 
    width=7, 
    height=4, 
    pointsize=12, 
    res=300)
print(g5)
dev.off()

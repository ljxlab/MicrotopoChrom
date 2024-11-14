rm(list=ls())
library(dplyr)
library(networkD3)
library(htmlwidgets)
library(webshot)
library(preprocessCore)

pc1_merged <- read.table("merge_100kb_norSmallest_KRcorrected_pca1.flipped.bedgraph", header = F, sep = "\t")
colnames(pc1_merged) <- c("Chr", "Start", "End", "Control", "Aligned", "Random")
quantile_norm <- normalize.quantiles(as.matrix(pc1_merged[,4:6]))
pc1_merged_quantile_norm <- cbind(pc1_merged[,1:3], quantile_norm)
colnames(pc1_merged_quantile_norm) <- c("Chr","Start","End","Control", "Aligned", "Random")

pc1_merged_quantile_norm$CvA_pc1 <- pc1_merged_quantile_norm$Control - pc1_merged_quantile_norm$Aligned
pc1_merged_quantile_norm$CvR_pc1 <- pc1_merged_quantile_norm$Control - pc1_merged_quantile_norm$Random
pc1_merged_quantile_norm$AvR_pc1 <- pc1_merged_quantile_norm$Aligned - pc1_merged_quantile_norm$Random

pc1_merged_quantile_norm$C_status <- rep("A", nrow(pc1_merged_quantile_norm))
pc1_merged_quantile_norm$C_status[which(pc1_merged_quantile_norm$Control < 0)] <-"B" 
pc1_merged_quantile_norm$C_v_A <- pc1_merged_quantile_norm$C_status
pc1_merged_quantile_norm$C_v_A[which(pc1_merged_quantile_norm$CvA_pc1 > quantile(pc1_merged_quantile_norm$Control,probs = c(0,1,0.975)))] <- "AtoB"
pc1_merged_quantile_norm$C_v_A[which(pc1_merged_quantile_norm$CvA_pc1 < quantile(pc1_merged_quantile_norm$Control,probs = c(0,1,0.025)))] <- "BtoA"
table(pc1_merged_quantile_norm$C_v_A)
CvA_links <- data.frame(
  source=c("C_A","C_A", "C_B","C_B"),
  target=c("A_A","A_B", "A_B", "A_A"), 
  value=as.numeric(table(pc1_merged_quantile_norm$C_v_A)))
CvA_nodes <- data.frame(name=c(as.character(CvA_links$source), as.character(CvA_links$target)) %>% unique())
CvA_links$IDsource <- match(CvA_links$source, CvA_nodes$name)-1 
CvA_links$IDtarget <- match(CvA_links$target, CvA_nodes$name)-1
CvA_links$group <- as.factor(c("AtoA","AtoB","BtoA","BtoB"))
CvA_nodes$group <- as.factor(c("C_A","C_B","A_A","A_B"))
my_color <- 'd3.scaleOrdinal() .domain(["AtoA","AtoB","BtoA","BtoB","C_A","C_B","A_A","A_B"]) .range(["#CCCCCC","#D2EED7","#CCCCCC","#FBDDD0","#E52E1B", "#1961B4" , "#E52E1B", "#1961B4"])'
CvA_sankey_plot <- sankeyNetwork(Links = CvA_links, Nodes = CvA_nodes,
                                 Source = "IDsource", Target = "IDtarget",
                                 Value = "value", NodeID = "name", nodeWidth = 20,
                                 colourScale=my_color, LinkGroup="group", NodeGroup="group")
saveWidget(CvA_sankey_plot, file="CvA_sankey_plot.html")
webshot("CvA_sankey_plot.html", "CvA_sankey_plot.pdf",vwidth = 200, vheight = 400)
CvA_percent <- as.numeric(table(pc1_merged_quantile_norm$C_v_A))/nrow(pc1_merged_quantile_norm)*100
names(CvA_percent) <- c("A","AtoB","B","BtoA")
write.table(CvA_percent,"CvA_percent.txt",quote = F,col.names = F)

pc1_merged_quantile_norm$C_v_R <- pc1_merged_quantile_norm$C_status
pc1_merged_quantile_norm$C_v_R[which(pc1_merged_quantile_norm$CvR_pc1 > 0.0297)] <- "AtoB"
pc1_merged_quantile_norm$C_v_R[which(pc1_merged_quantile_norm$CvR_pc1 < -0.0583)] <- "BtoA"
table(pc1_merged_quantile_norm$C_v_R)
CvR_links <- data.frame(
  source=c("C_A","C_A", "C_B","C_B"),
  target=c("R_A","R_B", "R_B", "R_A"), 
  value=as.numeric(table(pc1_merged_quantile_norm$C_v_R)))
CvR_nodes <- data.frame(name=c(as.character(CvR_links$source), as.character(CvR_links$target)) %>% unique())
CvR_links$IDsource <- match(CvR_links$source, CvR_nodes$name)-1 
CvR_links$IDtarget <- match(CvR_links$target, CvR_nodes$name)-1
CvR_links$group <- as.factor(c("AtoA","AtoB","BtoA","BtoB"))
CvR_nodes$group <- as.factor(c("C_A","C_B","R_A","R_B"))
my_color <- 'd3.scaleOrdinal() .domain(["AtoA","AtoB","BtoA","BtoB","C_A","C_B","R_A","R_B"]) .range(["#CCCCCC","#D2EED7","#CCCCCC","#FBDDD0","#E52E1B", "#1961B4" , "#E52E1B", "#1961B4"])'
CvR_sankey_plot <- sankeyNetwork(Links = CvR_links, Nodes = CvR_nodes,
                                 Source = "IDsource", Target = "IDtarget",
                                 Value = "value", NodeID = "name", nodeWidth = 20,
                                 colourScale=my_color, LinkGroup="group", NodeGroup="group")
saveWidget(CvR_sankey_plot, file="CvR_sankey_plot.html")
webshot("CvR_sankey_plot.html", "CvR_sankey_plot.pdf",vwidth = 200, vheight = 400)
CvR_percent <- as.numeric(table(pc1_merged_quantile_norm$C_v_R))/nrow(pc1_merged_quantile_norm)*100
names(CvR_percent) <- c("A","AtoB","B","BtoA")
write.table(CvR_percent,"CvR_percent.txt",quote = F,col.names = F)

pc1_merged_quantile_norm$A_status <- rep("A", nrow(pc1_merged_quantile_norm))
pc1_merged_quantile_norm$A_status[which(pc1_merged_quantile_norm$Aligned < 0)] <-"B" 
pc1_merged_quantile_norm$A_v_R <- pc1_merged_quantile_norm$A_status
pc1_merged_quantile_norm$A_v_R[which(pc1_merged_quantile_norm$AvR_pc1 > 0.0297)] <- "AtoB"
pc1_merged_quantile_norm$A_v_R[which(pc1_merged_quantile_norm$AvR_pc1 < -0.0583)] <- "BtoA"
table(pc1_merged_quantile_norm$A_v_R)
AvR_links <- data.frame(
  source=c("A_A","A_A", "A_B","A_B"),
  target=c("R_A","R_B", "R_B", "R_A"), 
  value=as.numeric(table(pc1_merged_quantile_norm$A_v_R)))
AvR_nodes <- data.frame(name=c(as.character(AvR_links$source), as.character(AvR_links$target)) %>% unique())
AvR_links$IDsource <- match(AvR_links$source, AvR_nodes$name)-1 
AvR_links$IDtarget <- match(AvR_links$target, AvR_nodes$name)-1
AvR_links$group <- as.factor(c("AtoA","AtoB","BtoA","BtoB"))
AvR_nodes$group <- as.factor(c("A_A","A_B","R_A","R_B"))
my_color <- 'd3.scaleOrdinal() .domain(["AtoA","AtoB","BtoA","BtoB","A_A","A_B","R_A","R_B"]) .range(["#CCCCCC","#D2EED7","#CCCCCC","#FBDDD0","#E52E1B", "#1961B4" , "#E52E1B", "#1961B4"])'
AvR_sankey_plot <- sankeyNetwork(Links = AvR_links, Nodes = AvR_nodes,
                                 Source = "IDsource", Target = "IDtarget",
                                 Value = "value", NodeID = "name", nodeWidth = 20,
                                 colourScale=my_color, LinkGroup="group", NodeGroup="group")
saveWidget(AvR_sankey_plot, file="AvR_sankey_plot.html")
webshot("AvR_sankey_plot.html", "AvR_sankey_plot.pdf",vwidth = 200, vheight = 400)
AvR_percent <- as.numeric(table(pc1_merged_quantile_norm$A_v_R))/nrow(pc1_merged_quantile_norm)*100
names(AvR_percent) <- c("A","AtoB","B","BtoA")
write.table(AvR_percent,"AvR_percent.txt",quote = F,col.names = F)
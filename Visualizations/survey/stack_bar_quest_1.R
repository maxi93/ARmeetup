
# packages ----------------------------------------------------------------
library(ggplot2)
library(plyr)
library(reshape2)
library(tibble)
library(dplyr)
library(tidyr)
library(ggthemes) # <-- guardati i temi che ci sono qui che magari ne trovi che ti piacciono
#library(plotly)


# import data -------------------------------------------------------------
#iz 1
df <- read.table('https://raw.githubusercontent.com/DBertazioli/ARmeetup/master/Visualizations/survey/Questionario%20psicometrico%20(VIZ_1).txt', header = TRUE, sep = ",")

#viz 2
df2 <- read.table('https://raw.githubusercontent.com/DBertazioli/ARmeetup/master/Visualizations/survey/Questionario%20psicometrico%20(VIZ_2).txt',
                 header = TRUE, sep = ",")


df_stack <- df[,c(-1,-8)]
df_stack = ifelse(df_stack <= 3, 0, 1)

df_stack_2 <- df2[,c(-1,-8)]
df_stack_2 = ifelse(df_stack_2 <= 3, 0, 1)

# reshaping viz1 ---------------------------------------------------------------
df_stack <- as.data.frame(df_stack) # converto in dataframe

new_data <- cbind(table(df_stack$Utile), #credo tabella di contingenza
      table(df_stack$Intuitiva),
      table(df_stack$Chiara),
      table(df_stack$Informativa),
      table(df_stack$Bella),
      table(df_stack$Valore.complessivo))

row.names(new_data) <- c("1-3", "4-6")
colnames(new_data) <- c("Utile", "Intuitiva", "Chiara", "Informativa", "Bella", "Valore.complessivo")

new_data <- as.data.frame(new_data)
n <- nrow(df_stack) 

new_data <- new_data/n # frequenze relative

reshaped <- gather(new_data, "question", "answer") # reshape con pacchetto tidyr
reshaped$value.answer <- c("1-3","4-6","1-3","4-6","1-3","4-6","1-3","4-6","1-3","4-6","1-3","4-6")
# reshaped$answer + (1.96*sqrt((1-reshaped$answer)/n))

reshaped$up <- reshaped$answer + 1.96*(sqrt((reshaped$answer*(1-reshaped$answer))/n)) # definisco conf int
reshaped$low <- reshaped$answer - 1.96*(sqrt((reshaped$answer*(1-reshaped$answer))/n))
reshaped_error <- reshaped[c(2,4,6,8,10,12),] # prendo solo valori per p non per 1-p

# plot viz 1 -------------------------------------------------------------------
png("stacked_bar_viz1.png", width = 15, height = 8, units = 'in', res = 300)
ggplot(reshaped,
       aes(fill = value.answer,
           y = answer,
           x = question)) + 
  geom_bar(stat = "identity",
           position = "fill",
           width = 0.95,
           alpha = 0.65,
           colour = 'white') +
  geom_errorbar(data = reshaped_error,
                aes(x = question,
                    ymax = up,
                    ymin = low,
                    alpha = 0.65),
                show.legend = F,
                width = .15) +
  
  geom_hline(yintercept = 0.50, linetype = "dashed", color = "white", size = 0.5) +
  scale_x_discrete(limits = c('Valore.complessivo', 'Bella', 'Informativa', 'Chiara', 'Intuitiva', 'Utile')) +
  scale_y_continuous(labels = c('0 %', '25 %', '50 %', '75 %','100 %'),
                     sec.axis = sec_axis(~.*1,
                                         labels = c('100 %', '75 %',
                                                    '50 %', '25 %',
                                                    '0 %'))) +
  coord_flip() +
  scale_fill_manual(values = c("#80ccff","#ffad33")) +
  geom_text(aes(label = paste0(format(round(reshaped$answer*100, 1)), ' %'),
                fontface = 'bold', vjust = 1.75), position = position_stack(vjust = 0.2),
            size = 4, color = 'white') +
  theme_classic(base_size = 12, base_family = "Helvetica") + # versione base, poi puoi arricchirlo come ti piace
  theme(axis.text.x.bottom=element_text(size=10, color = '#ffad33', face = 'bold')) +
  theme(axis.text.x.top=element_text(size=10, color = '#80ccff', face = 'bold')) +
  theme(axis.title.y=element_text(size=14, face="bold", vjust=1)) +
  theme(axis.title.x=element_text(size=14, face="bold", vjust=1)) +
  theme(axis.text.y=element_text(size=10)) +
  theme(legend.title = element_blank()) +
  theme(legend.text=element_text(size=14))
  # theme(legend.position="right", legend.box = TRUE)
#ggplotly(p)
dev.off()


# reshaping viz2 ----------------------------------------------------------
df_stack_2 <- as.data.frame(df_stack_2) # converto in dataframe

new_data <- cbind(table(df_stack_2$Utile), #credo tabella di contingenza
                  table(df_stack_2$Intuitiva),
                  table(df_stack_2$Chiara),
                  table(df_stack_2$Informativa),
                  table(df_stack_2$Bella),
                  table(df_stack_2$Valore.complessivo))

row.names(new_data) <- c("1-3", "4-6")
colnames(new_data) <- c("Utile", "Intuitiva", "Chiara", "Informativa", "Bella", "Valore.complessivo")

new_data <- as.data.frame(new_data)
n <- nrow(df_stack_2) 

new_data <- new_data/n # frequenze relative

reshaped <- gather(new_data, "question", "answer") # reshape con pacchetto tidyr
reshaped$value.answer <- c("1-3","4-6","1-3","4-6","1-3","4-6","1-3","4-6","1-3","4-6","1-3","4-6")
# reshaped$answer + (1.96*sqrt((1-reshaped$answer)/n))

reshaped$up <- reshaped$answer + 1.96*(sqrt((reshaped$answer*(1-reshaped$answer))/n)) # definisco conf int
reshaped$low <- reshaped$answer - 1.96*(sqrt((reshaped$answer*(1-reshaped$answer))/n))
reshaped_error <- reshaped[c(2,4,6,8,10,12),] 
reshaped_error$up <- ifelse(reshaped_error$up > 1, 1, reshaped_error$up)
# viz 2 -------------------------------------------------------------------



png("stacked_bar_viz2.png", width = 15, height = 8, units = 'in', res = 300)
ggplot(reshaped,
       aes(fill = value.answer,
           y = answer,
           x = question)) + 
  geom_bar(stat = "identity",
           position = "fill",
           width = 0.95,
           alpha = 0.65,
           colour = 'white') +
  geom_errorbar(data = reshaped_error,
                aes(x = question,
                    ymax = up,
                    ymin = low,
                    alpha = 0.65),
                show.legend = F,
                width = .15) +
  
  geom_hline(yintercept = 0.50, linetype = "dashed", color = "white", size = 0.5) +
  scale_x_discrete(limits = c('Valore.complessivo', 'Bella', 'Informativa', 'Chiara', 'Intuitiva', 'Utile')) +
  scale_y_continuous(labels = c('0 %', '25 %', '50 %', '75 %','100 %'),
                     sec.axis = sec_axis(~.*1,
                                         labels = c('100 %', '75 %',
                                                    '50 %', '25 %',
                                                    '0 %'))) +
  coord_flip() +
  scale_fill_manual(values = c("#80ccff","#ffad33")) +
  geom_text(aes(label = paste0(format(round(reshaped$answer*100, 1)), ' %'),
                fontface = 'bold', vjust = 1.75), position = position_stack(vjust = 0.48),
            size = 4, color = 'white') +
  theme_classic(base_size = 12, base_family = "Helvetica") + # versione base, poi puoi arricchirlo come ti piace
  theme(axis.text.x.bottom=element_text(size=10, color = '#ffad33', face = 'bold')) +
  theme(axis.text.x.top=element_text(size=10, color = '#80ccff', face = 'bold')) +
  theme(axis.title.y=element_text(size=14, face="bold", vjust=1)) +
  theme(axis.title.x=element_text(size=14, face="bold", vjust=1)) +
  theme(axis.text.y=element_text(size=10)) +
  theme(legend.title = element_blank()) +
  theme(legend.text=element_text(size=14))
# theme(legend.position="right", legend.box = TRUE)
#ggplotly(p)
dev.off()

# old script ----------------------------------------------
# df_stack <- t(df_stack)
# df_stack
# 
# df_stack <- as.data.frame(df_stack)
# df_stack
# 
# # df_stack$Group <- row.names(df_stack)
# # rownames(df_stack) = 1:6
# 
# negativo <- rowSums(df_stack[1:6,] == 0)
# positivo <- rowSums(df_stack[1:6,] == 1)
# df_fin <- as.data.frame(cbind(negativo, positivo))
# df_fin$Group <- row.names(df_fin)
# rownames(df_fin) = 1:6
# 
# library(ggplot2)
# library(plyr)
# library(reshape2)
# library(tibble)
# 
# melted <- melt(df_fin, id.vars='Group')
# # means <- ddply(melted, c('variable','Group'), summarise,
# #                mean=mean(value))
# melted
# ggplot(data=melted, aes(x=Group, y=value, fill=variable)) + 
#   geom_bar(stat="identity",
#            width = 0.5) +                           
#   xlab(" ") + ylab("number of response") + 
#   theme_classic(base_size = 14, base_family = "Helvetica") + 
#   theme(axis.text.y=element_text(size=9)) + 
#   theme(axis.title.y=element_text(size=12, face="bold", vjust=1)) + 
#   theme(axis.text.x=element_text(angle=45,hjust=1,vjust=1, size=11)) +
#   theme(legend.position="right")
# 
# # Calc SEM  
# means.sem <- ddply(melted, c("variable", "Group"), summarise,
#                    mean=mean(value), sem=sd(value)/sqrt(length(value)))
# means.sem <- transform(means.sem, lower=mean-sem, upper=mean+sem)
# means.sem[means.sem$variable=='Labeled',5:6] <- means.sem[means.sem$variable=='Labeled',3] + means.sem[means.sem$variable=='Unlabeled',5:6]
# 
# # Add SEM & change appearance of barplot
# plotSEM <- plot + geom_errorbar(data=means.sem, aes(ymax=upper,  ymin=lower), 
#                                 width=0.15)
# 

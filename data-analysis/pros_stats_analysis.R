setwd("C:/Users/zhuzi/Downloads/ProsExp")
data = read.csv("x19_NA_whword_vowel_f0_duration_data.csv", header = TRUE)
View(data)

library(report)
library(parameters)
library(dplyr)
library(ggplot2)
library(lsr)
library(lme4)
library(afex)
library(multcomp)
library(emmeans)
library(cowplot)
library(ggpubr)
library(lmerTest)

EQ_PQ = data %>% filter(q_type %in% c("EQ", "PQ"))


#t.test(wh_delta_pitch ~ q_type, data = EQ_PQ, var.equal = TRUE)
#t.test(vowel_delta_pitch ~ q_type, data = EQ_PQ, var.equal = TRUE)
#t.test(wh_duration ~ q_type, data = EQ_PQ, var.equal = TRUE)
#t.test(vowel_duration ~ q_type, data = EQ_PQ, var.equal = TRUE)
idqmeans = EQ_PQ %>%
  group_by(participant_ID, q_type) %>%
  summarize(mean(wh_duration), mean(vowel_duration))

contextqmeans = EQ_PQ %>%
  group_by(q_type, context_.) %>%
  summarize(mean(wh_duration), mean(vowel_duration))


EQ_PQ %>%
  group_by(q_type) %>%
  summarize(mean(wh_delta_pitch), mean(vowel_delta_pitch), mean(wh_duration), mean(vowel_duration))

EQ_PQ %>%
  group_by(q_type) %>%
  summarize(sd(wh_delta_pitch), sd(vowel_delta_pitch), sd(wh_duration), sd(vowel_duration))

EQ_PQ %>%
  group_by(wh_position) %>%
  summarize(mean(wh_delta_pitch), mean(vowel_delta_pitch), mean(wh_duration), mean(vowel_duration))

EQ_PQ %>%
  group_by(wh_position) %>%
  summarize(sd(wh_delta_pitch), sd(vowel_delta_pitch), sd(wh_duration), sd(vowel_duration))

EQ_PQ %>%
  group_by(wh_position, q_type) %>%
  summarize(mean(wh_delta_pitch), mean(vowel_delta_pitch), mean(wh_duration), mean(vowel_duration))

EQ_PQ %>%
  group_by(wh_position, q_type) %>%
  summarize(sd(wh_delta_pitch), sd(vowel_delta_pitch), sd(wh_duration), sd(vowel_duration))

EQ_PQ %>%
  summarize(mean(wh_delta_pitch), mean(vowel_delta_pitch), mean(wh_duration), mean(vowel_duration))

EQ_PQ %>%
  summarize(sd(wh_delta_pitch), sd(vowel_delta_pitch), sd(wh_duration), sd(vowel_duration))


#### wh pitch mixed
wh_pitch_inter_mixed =lmer(wh_delta_pitch ~ q_type*wh_position + 
                             (1|participant_ID) + (1|stimuli_.), data = EQ_PQ)
ranova(wh_pitch_inter_mixed)
summary(wh_pitch_inter_mixed)
anova(wh_pitch_inter_mixed)
as.report_table(report(wh_pitch_inter_mixed))
model_parameters(wh_pitch_inter_mixed, standardize = "refit")


#### wh pitch anova
wh_pitch_inter = aov(wh_delta_pitch ~ q_type*wh_position, data = EQ_PQ)
summary(wh_pitch_inter)
etaSquared(wh_pitch_inter)


#### vowel pitch mixed
vowel_pitch_inter_mixed =lmer(vowel_delta_pitch ~ q_type*wh_position 
                              + (1|participant_ID) + (1|stimuli_.), data = EQ_PQ)
ranova(vowel_pitch_inter_mixed)
summary(vowel_pitch_inter_mixed)
model_parameters(vowel_pitch_inter_mixed, standardize = "refit")
as.report_table(report(vowel_pitch_inter_mixed))


#### vowel pitch anova
vowel_pitch_inter = aov(vowel_delta_pitch ~ q_type*wh_position, data = EQ_PQ)
summary(vowel_pitch_inter)
etaSquared(vowel_pitch_inter)

#### wh duration mixed
wh_duration_inter_mixed =lmer(wh_duration ~ q_type*wh_position 
                              + (1|participant_ID) + (1|stimuli_.),data = EQ_PQ)
ranova(wh_duration_inter_mixed)
summary(wh_duration_inter_mixed)
model_parameters(wh_duration_inter_mixed, standardize = "refit")
as.report_table(report(wh_duration_inter_mixed))

#### wh duration anova
wh_duration_inter = aov(wh_duration ~ q_type*wh_position, data = EQ_PQ)
summary(wh_duration_inter)
etaSquared(wh_duration_inter)

#### vowel duration mixed
vowel_duration_inter_mixed =lmer(vowel_duration ~ q_type*wh_position 
                                 + (1|participant_ID)+(1|stimuli_.), data = EQ_PQ)
ranova(vowel_duration_inter_mixed)
summary(vowel_duration_inter_mixed)
model_parameters(vowel_duration_inter_mixed, standardize = "refit")
as.report_table(report(vowel_duration_inter_mixed))

#### vowel duration anova
vowel_duration_inter = aov(vowel_duration ~ q_type*wh_position, data = EQ_PQ)
summary(vowel_duration_inter)
etaSquared(vowel_duration_inter)


#### Making all the plots
# plot wh pitch EQ/PQ vs mid/end
EQ_PQ$wh_position = factor(EQ_PQ$wh_position, levels = c("mid", "end"))

wh_pitch_inter_graph = 
  ggplot(data = EQ_PQ, mapping = aes(x = wh_position, y = wh_delta_pitch, 
                                     group = q_type, shape = q_type, color = q_type)) +
  geom_point(stat = "summary", fun = mean, position = "dodge")+
  geom_line(stat='summary', fun='mean', aes(linetype = q_type)) +
  ylab(expression(Delta~F0~(Hz))) +
  xlab(expression("wh-word position"))+
  labs(color = "Type", linetype = "Type", shape = "Type") +
  geom_errorbar(stat = "summary", fun.data = mean_se, width = .1, 
                aes(group = q_type)) +
  ggtitle(expression(paste("wh-word pitch")))+
  theme(plot.title = element_text(hjust = 0.5))
  #theme(text = element_text(size = 10))
        #plot.background = element_rect(color = "black"))

vowel_pitch_inter_graph = 
  ggplot(data = EQ_PQ, mapping = aes(x = wh_position, y = vowel_delta_pitch, 
                                   group = q_type, color = q_type, shape = q_type)) +
  geom_point(stat = "summary", fun = mean, position = "dodge")+
  geom_line(stat='summary', fun='mean', aes(linetype = q_type)) +
  ylab(expression(Delta~F0~(Hz))) +
  xlab(expression(paste("wh-word position")))+
  labs(color = "Type", shape = "Type", linetype="Type") +
  geom_errorbar(stat = "summary", fun.data = mean_se, width = .1, 
                aes(group = q_type)) +
  ggtitle(expression(paste("vowel pitch")))+
  theme(plot.title = element_text(hjust = 0.5))
  #theme(text = element_text(size = 10))
        #plot.background = element_rect(color = "black"))

wh_duration_inter_graph = 
  ggplot(data = EQ_PQ, mapping = aes(x = wh_position, y = wh_duration, 
                                   group = q_type, color = q_type, shape = q_type)) +
  geom_point(stat = "summary", fun = mean, position = "dodge")+
  geom_line(stat='summary', fun='mean', aes(linetype = q_type)) +
  ylab(expression(Duration~(s))) +
  xlab(expression(paste("wh-word position")))+
  labs(color = "Type", shape = "Type", linetype = "Type") +
  geom_errorbar(stat = "summary", fun.data = mean_se, width = .1, 
                aes(group = q_type)) +
  ggtitle(expression(paste("wh-word duration")))+
  theme(plot.title = element_text(hjust = 0.5))
  #theme(text = element_text(size = 10))
        #plot.background = element_rect(color = "black"))

vowel_duration_inter_graph = 
  ggplot(data = EQ_PQ, mapping = aes(x = wh_position, y = vowel_duration, 
                                   group = q_type, color = q_type, shape = q_type)) +
  geom_point(stat = "summary", fun = mean, position = "dodge")+
  geom_line(stat='summary', fun='mean', aes(linetype = q_type)) +
  ylab(expression(Duration~(s))) +
  xlab(expression(paste("wh-word position")))+
  labs(color = "Type",shape = "Type", linetype = "Type") +
  geom_errorbar(stat = "summary", fun.data = mean_se, width = .1, 
                aes(group = q_type)) +
  ggtitle(expression(paste("vowel duration")))+
  theme(plot.title = element_text(hjust = 0.5))
  #theme(text = element_text(size = 10))
        #plot.background = element_rect(color = "black"))


# inter_graph= plot_grid(wh_pitch_inter_graph, vowel_pitch_inter_graph, wh_duration_inter_graph,
#           vowel_duration_inter_graph, align = "hv",nrow = 2)

inter_graph = ggarrange(wh_pitch_inter_graph, vowel_pitch_inter_graph, wh_duration_inter_graph, 
          vowel_duration_inter_graph, ncol=2, nrow=2, common.legend = TRUE,
          legend = "right")

ggsave("inter_graph_2x2.png", plot = inter_graph, device = "png", scale = 5)


####################### Comparing 3 Q-types ####################
Q3 = (data %>% filter(q_type != "filler"))
View(Q3)

Q3 %>%
  group_by(q_type) %>%
  summarize(mean(wh_delta_pitch), mean(vowel_delta_pitch), mean(wh_duration), mean(vowel_duration))

Q3 %>%
  group_by(q_type) %>%
  summarize(sd(wh_delta_pitch), sd(vowel_delta_pitch), sd(wh_duration), sd(vowel_duration))

#### wh pitch mixed
wh_pitch_qtype_mixed = lmer(wh_delta_pitch ~ q_type + (1|participant_ID) + (1|stimuli_.), data = Q3)
ranova(wh_pitch_qtype_mixed)
summary(wh_pitch_qtype_mixed)
model_parameters(wh_pitch_qtype_mixed, standardize = "refit")
as.report_table(report(wh_pitch_qtype_mixed))
anova(wh_pitch_qtype_mixed)
emmeans(wh_pitch_qtype_mixed, pairwise~q_type)
post.hoc.wh_pitch_qtype_mixed <- glht(wh_pitch_qtype_mixed, linfct = mcp(q_type = 'Tukey'))
summary(post.hoc.wh_pitch_qtype_mixed)


#### wh type anova
# wh_pitch_qtype = aov(wh_delta_pitch ~ q_type, data = Q3)
# summary(wh_pitch_qtype)
# etaSquared(wh_pitch_qtype)
# #pairwise.t.test(x = Q3$wh_delta_pitch,
# #                g = Q3$q_type,
# #                p.adj = "bonferroni")
# 
# TukeyHSD(wh_pitch_qtype)
# 
# pairwise.t.test(x = Q3$vowel_duration,
#                 g = Q3$q_type,
#                 p.adj = "bonferroni")


#### vowel pitch mixed 
vowel_pitch_qtype_mixed = lmer(vowel_delta_pitch ~ q_type + (1|participant_ID) + (1|stimuli_.), data = Q3)
ranova(vowel_pitch_qtype_mixed)
summary(vowel_pitch_qtype_mixed)
anova(vowel_pitch_qtype_mixed)
emmeans(vowel_pitch_qtype_mixed, pairwise~q_type)
post.hoc.vowel_pitch_qtype_mixed <- glht(vowel_pitch_qtype_mixed, linfct = mcp(q_type = 'Tukey'))
summary(post.hoc.vowel_pitch_qtype_mixed)



#### vowel pitch anova
# vowel_pitch_qtype = aov(vowel_delta_pitch ~ q_type, data = Q3)
# summary(vowel_pitch_qtype)
# TukeyHSD(vowel_pitch_qtype)
# etaSquared(vowel_pitch_qtype)



#### wh duration mixed
wh_duration_qtype_mixed = lmer(wh_duration ~ q_type + (1|participant_ID) + (1|stimuli_.), data = Q3)
ranova(wh_duration_qtype_mixed)
summary(wh_duration_qtype_mixed)
anova(wh_duration_qtype_mixed)
emmeans(wh_duration_qtype_mixed, pairwise~q_type)
post.hoc.wh_duration_qtype_mixed <- glht(wh_duration_qtype_mixed, linfct = mcp(q_type = 'Tukey'))
summary(post.hoc.wh_duration_qtype_mixed)
em = emmeans(wh_duration_qtype_mixed, "q_type")
contrast(em)


#### wh duration anova
# wh_duration_qtype = aov(wh_duration ~ q_type, data = Q3)
# summary(wh_duration_qtype)
# TukeyHSD(wh_duration_qtype)
# etaSquared(wh_duration_qtype)



#### vowel duration mixed
vowel_duration_qtype_mixed = lmer(vowel_duration ~ q_type + (1|participant_ID) + (1|stimuli_.), data = Q3)
ranova(vowel_duration_qtype_mixed)
summary(vowel_duration_qtype_mixed)
anova(vowel_duration_qtype_mixed)
emmeans(vowel_duration_qtype_mixed, pairwise~q_type)
post.hoc.vowel_duration_qtype_mixed <- glht(vowel_duration_qtype_mixed, linfct = mcp(q_type = 'Tukey'))
summary(post.hoc.vowel_duration_qtype_mixed)


# em = emmeans(vowel_duration_qtype_mixed, "q_type")
# contrast(em, method = "pairwise")
# 
# source("C:/Users/zhuzi/Downloads/ProsExp/data_analysis/ggplot_the_model.R")
# m1_emm = emmeans(vowel_duration_qtype_mixed, specs = c("q_type"))
# m1_simple <- contrast(m1_emm,
#                       method = "revpairwise",
#                       simple = "each",
#                       combine = TRUE,
#                       adjust = "none") %>%
#   summary(infer = TRUE)
# m1_simple
# m1_response_plot <- ggplot_the_response(
#   fit = vowel_duration_qtype_mixed,
#   fit_emm = m1_emm,
#   fit_pairs = m1_simple,
#   palette = pal_okabe_ito_blue,
#   y_label = expression(paste("mmol ", l^-1, " min")),
#   g_label = "none"
# )
# m1_response_plot

#### vowel duration anova
# vowel_duration_qtype = aov(vowel_duration ~ q_type, data = Q3)
# summary(vowel_duration_qtype)
# TukeyHSD(vowel_duration_qtype)
# etaSquared(vowel_duration_qtype)


#### Making the plots
# wh_pitch_qtype_graph = 
#   ggplot(data = Q3, mapping = aes(x = q_type, y = wh_delta_pitch, group = q_type)) +
#     geom_boxplot(stat = "summary", fun = mean, aes(fill=q_type), position=position_dodge(1))+
#     ylab(expression(Delta~F0~(Hz))) +
#     xlab("Type")+
#     labs(fill = "Type",shape = "Type") +
#     ggtitle("wh-word pitch")+
#     theme(plot.title = element_text(hjust = 0.5)) +
#     stat_compare_means(comparisons = list(c("EQ","PQ"), c("EQ","FQ"),
#                                           c("EQ", "filler"), c("PQ", "filler"),
#                                           c("FQ", "filler")),
#                        hide.ns = TRUE, label = "p.signif")  

wh_pitch_qtype_graph = 
  ggplot(data = Q3, mapping = aes(x = q_type, y = wh_delta_pitch, group = q_type)) +
    geom_bar(stat = "summary", fun = mean, aes(fill=q_type), position=position_dodge(1))+
    geom_errorbar(stat = "summary", fun.data = mean_se, width = .25, 
                  aes(group = q_type), position = position_dodge(width = .9))+
    ylab(expression(Delta~F0~(Hz))) +
    xlab("Type")+
    labs(fill = "Type",shape = "Type") +
    ggtitle("wh-word pitch")+
    theme(plot.title = element_text(hjust = 0.5)) +
    scale_fill_grey(start = 0, end = .8)
    #theme(text = element_text(size = 10))


# vowel_pitch_qtype_graph = 
#   ggplot(data = Q3, mapping = aes(x = q_type, y = vowel_delta_pitch, group = q_type)) +
#     geom_boxplot(aes(fill=q_type), position=position_dodge(1))+
#     ylab(expression(Delta~F0~(Hz))) +
#     xlab("Type")+
#     labs(fill = "Type",shape = "Type") +
#     ggtitle(expression(paste("vowel pitch")))+
#     theme(plot.title = element_text(hjust = 0.5))+
#     stat_compare_means(comparisons = list(c("EQ","PQ"), c("EQ","FQ"), c("PQ", "FQ")),
#                        hide.ns = TRUE, label = "p.signif")

vowel_pitch_qtype_graph = 
  ggplot(data = Q3, mapping = aes(x = q_type, y = vowel_delta_pitch, group = q_type)) +
  geom_bar(stat = "summary", fun = mean, aes(fill=q_type), position=position_dodge(1))+
  geom_errorbar(stat = "summary", fun.data = mean_se, width = .25, 
                aes(group = q_type), position = position_dodge(width = .9))+
  ylab(expression(Delta~F0~(Hz))) +
  xlab("Type")+
  labs(fill = "Type",shape = "Type") +
  ggtitle("vowel pitch")+
  theme(plot.title = element_text(hjust = 0.5))+
  scale_fill_grey(start = 0, end = .8)
  #theme(text = element_text(size = 10))


# wh_duration_qtype_graph = 
#   ggplot(data = Q3, mapping = aes(x = q_type, y = wh_duration, group = q_type)) +
#     geom_boxplot(aes(fill=q_type), position=position_dodge(1))+
#     ylab("Duration (s)") +    
#     xlab("Type")+
#     labs(fill = "Type",shape = "Type") +    
#     ggtitle(expression(paste(italic("wh"), "-word duration")))+
#     theme(plot.title = element_text(hjust = 0.5))+
#     stat_compare_means(comparisons = list(c("EQ","PQ"), c("EQ","FQ"), c("PQ", "FQ")),
#                         hide.ns = TRUE, label = "p.signif")+
#     coord_cartesian(clip = "off")
    
wh_duration_qtype_graph = 
  ggplot(data = Q3, mapping = aes(x = q_type, y = wh_duration, group = q_type)) +
  geom_bar(stat = "summary", fun = mean, aes(fill=q_type), position=position_dodge(1))+
  geom_errorbar(stat = "summary", fun.data = mean_se, width = .25, 
                aes(group = q_type), position = position_dodge(width = .9))+
  ylab("Duration (s)") +
  xlab("Type")+
  labs(fill = "Type",shape = "Type") +
  ggtitle("wh-word duration")+
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_fill_grey(start = 0, end = .8)
  #theme(text = element_text(size = 10))

# vowel_duration_qtype_graph = 
#   ggplot(data = Q3, mapping = aes(x = q_type, y = vowel_duration, group = q_type)) +
#     geom_boxplot(aes(fill=q_type), position=position_dodge(1))+
#     ylab("Duration (s)") +    
#     xlab("Type")+
#     labs(fill = "Type",shape = "Type") +    
#     ggtitle("vowel duration")+
#     theme(plot.title = element_text(hjust = 0.5))+
#     stat_compare_means(comparisons = list(c("EQ","PQ"), c("EQ","FQ"), c("PQ", "FQ")),
#                        hide.ns = TRUE, label = "p.signif")+
#     coord_cartesian(clip = "off")
  
vowel_duration_qtype_graph = 
  ggplot(data = Q3, mapping = aes(x = q_type, y = vowel_duration, group = q_type)) +
  geom_bar(stat = "summary", fun = mean, aes(fill=q_type), position=position_dodge(1))+
  geom_errorbar(stat = "summary", fun.data = mean_se, width = .25, 
                aes(group = q_type), position = position_dodge(width = .9))+
  ylab("Duration (s)") +
  xlab("Type")+
  labs(fill = "Type",shape = "Type") +
  ggtitle("vowel duration")+
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_fill_grey(start = 0, end = .8)
  #theme(text = element_text(size = 10))

# qtype_graph= 
#   plot_grid(wh_pitch_qtype_graph, vowel_pitch_qtype_graph, wh_duration_qtype_graph,
#                        vowel_duration_qtype_graph, align = "hv",nrow = 2, vjust = -0.8)

qtype_graph = ggarrange(wh_pitch_qtype_graph, vowel_pitch_qtype_graph, wh_duration_qtype_graph,
          vowel_duration_qtype_graph, ncol = 2, nrow = 2, common.legend = TRUE,
          legend = "right")
ggsave("qtype_graph_2x2.png", plot = qtype_graph, device = "png", scale = 5)


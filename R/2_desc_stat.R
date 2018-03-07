source('R/1_data_import.R')

dta.melt <- melt(dta, id = 'DTM')

stat <- dta.melt[, .(prumer = mean(value, na.rm = TRUE),
                     min = min(value, na.rm = TRUE),
                     q_05 = quantile(value, .05, na.rm = TRUE),
                     q_25 = quantile(value, .25, na.rm = TRUE),
                     median = median(value, na.rm = TRUE),
                     q_75 = quantile(value, .75, na.rm = TRUE),
                     q_95 = quantile(value, .95, na.rm = TRUE),
                     max = max(value, na.rm = TRUE),
                     sm_odchylka = sd(value, na.rm = TRUE),
                     koef_variace = sd(value, na.rm = TRUE)/mean(value, na.rm = TRUE),
                     iqr = IQR(value, na.rm = TRUE)),
                 by = 'variable']

stat <- setNames(as.data.frame(t(stat[, !'variable', with = F])), as.character(stat[,variable]))
# View(stat)

ggplot(dta.melt) +
  geom_line(aes(x = DTM, y = value, group = variable, color = variable), show.legend = F) +
  scale_color_manual(values = c('royalblue', 'orange', 'steelblue', 'firebrick4', 'firebrick1', 'firebrick')) +
  facet_wrap(~variable, scales = 'free', nrow = 2) +
  theme_bw() +
  labs(x = 'Datum', y = 'Hodnota', title = 'Zakladni zobrazeni velicin')

ggplot(dta.melt) +
  geom_boxplot(aes(x = variable, y = value, group = variable, fill = variable), show.legend = F, outlier.fill = NA, outlier.shape = 21, outlier.size = .75) +
  scale_fill_manual(values = c('royalblue', 'orange', 'steelblue', 'firebrick4', 'firebrick1', 'firebrick')) +
  facet_wrap(~variable, scales = 'free', nrow = 1) +
  theme_bw() +
  labs(x = '', y = 'Hodnota', title = 'Boxplot') + 
  theme(axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank())

ggplot(dta.melt) +
  geom_histogram(aes(x = value, group = variable, fill = variable), bins = 35, colour = 'black', show.legend = F) +
  scale_fill_manual(values = c('royalblue', 'orange', 'steelblue', 'firebrick4', 'firebrick1', 'firebrick')) +
  facet_wrap(~variable, scales = 'free', nrow = 2) +
  theme_bw() +
  labs(x = 'Hodnota', y = 'Četnost', title = 'Histogram')

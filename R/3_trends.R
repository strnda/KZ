source('R/2_desc_stat.R')

dta[, DEC := signif(year(DTM), 3)]

DT <- dta[, mean(T), by = DEC]
meaT <- dta[, mean(T)]
DT[, V1 - meaT, by = DEC]

DP <- dta[, mean(P), by = DEC]
meaP <- dta[, mean(P)]
DP[, V1 / meaP, by = DEC]

DR <- dta[, mean(R), by = DEC]
meaR <- dta[, mean(R)]
DR[, V1 / meaR, by = DEC]

ma <- 365
ggplot(data = dta.melt, aes(x = DTM, y = value, group = variable, color = variable)) +
  scale_color_manual(values = c('royalblue', 'orange', 'steelblue', 'firebrick4', 'firebrick1', 'firebrick')) +
  geom_line() +
  geom_line(aes(x = DTM, y = filter(value, rep(1/ma, ma)), group = variable), color = 'grey25', lwd = .25) +
  facet_wrap(~variable, scales = 'free') +
  theme_bw() +
  theme(legend.position = 'none') +
  ggtitle('Rocni klouzavy prumer')

ggplot(data = dta.melt, aes(x = DTM, y = value, group = variable, color = variable)) +
  scale_color_manual(values = c('royalblue', 'orange', 'steelblue', 'firebrick4', 'firebrick1', 'firebrick')) +
  geom_line() +
  stat_smooth(method = 'lm', se = FALSE , color = 'limegreen') +
  stat_smooth(method = 'lm', se = FALSE , formula = y ~ x + I(x^2), color = 'darkgreen') +
  facet_wrap(~variable, scales = 'free') +
  theme_bw() +
  theme(legend.position = 'none') +
  ggtitle('Linearni a kvadraticky trend')

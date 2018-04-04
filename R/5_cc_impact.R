source('R/4_BILAN.R')

sce.dta <- dta[, .(DTM, P = P * 1.2, R, T = T + 1)]
bil.set.values(bil, sce.dta)
bil.pet(bil)
scen.1 <- bil.run(bil)

ggplot(data = model) +
  geom_line(aes(x = DTM, y = R, colour = factor(1))) +
  geom_line(aes(x = DTM, y = RM, colour = factor(2))) +
  geom_line(data = scen.1, aes(x = DTM, y = RM, colour = factor(3))) +
  scale_color_manual(values = c('steelblue', 'red4', 'orange'),
                     labels = c('pozorovani', 'model', 'scenar'),
                     name = 'Legenda') +
  theme_bw()

mean(scen.1$RM)/mean(model$RM)
mean(scen.1$BF)/mean(model$BF)
(mean(scen.1$BF)/mean(scen.1$RM))/(mean(model$BF)/mean(model$RM))

temp <- seq(0, 4, length.out = 5)
prec <- seq(.9, 1.2, length.out = 5)

d.RM <- d.BF <- d.BFI <- array(NA, dim = c(length(prec), length(temp)), dimnames = list(dP = prec, dT = temp))

for (i in 1:length(prec)){
  for (j in 1:length(temp)){
    
    sce.dta = dta[, .(DTM, P = P * prec[i], R, T = T + temp[j])]
    bil.set.values(bil, sce.dta)
    bil.pet(bil)
    scen = bil.run(bil)
    
    d.RM[i, j] = mean(scen$RM)/mean(model$RM)
    d.BF[i, j] = mean(scen$BF)/mean(model$BF)
    d.BFI[i, j] = (mean(scen$BF)/mean(scen$RM))/(mean(model$BF)/mean(model$RM))
  }
}

dta.heat <- data.table(rbind(melt(d.RM),melt(d.BF),melt(d.BFI)))
dta.heat <- dta.heat[, id := rep(c('d.RM', 'd.BF', 'd.BFI'), each = (dim(dta.heat)[1])/3)]

ggplot(data = dta.heat) + 
  geom_tile(aes(x = dP, y = dT, fill = value)) +
  stat_contour(aes(x = dP, y = dT, z = value), colour = 'grey75') +
  facet_wrap(~id, nrow = 1) +
  theme_bw() +
  coord_fixed(.05)

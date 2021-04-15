lop <- c('data.table', 'ggplot2', 'ggpmisc', 'hydroGOF', 'Rcpp')

to.instal <- lop[which(!lop %in% installed.packages()[,'Package'])]

if(length(to.instal) != 0) install.packages(to.instal)

temp <- lapply(lop, library, character.only = T)
rm(temp)



## data dostupna z https://owncloud.cesnet.cz/index.php/s/zMUkK2EYnrKlmtW

dta <- fread(input = "../../../ownCloud/Active Docs/vyuka/klima/data skola/4215-skola.dat",
             col.names = c("rem1", "P", "R", "T", "H", "rem2"))
dta[, `:=`(rem1 = NULL, 
           rem2 = NULL,
           DTM = seq(from = as.Date(x = "1962-11-1", 
                                    format = "%Y-%m-%d"),
                     by = "month",
                     length.out = .N))]

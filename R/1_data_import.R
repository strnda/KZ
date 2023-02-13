if (as.numeric(x = R.Version()$minor) < 2.2) {
  
  if (!require(installr)) {
    
    install.packages("installr")
  }
  
  installr::install.R(silent = TRUE)
  
  q()
}
#####
lop <- c("data.table", "ggplot2", "ggpmisc", "hydroGOF", "Rcpp")

to_instal <- lop[which(x = !(lop %in% installed.packages()[,"Package"]))]

if(length(to_instal) != 0) {
  
  install.packages(to_instal)
}

temp <- lapply(X = lop, 
               FUN = library, 
               character.only = T)
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

lop <- c('data.table', 'ggplot2')

to.instal <- lop[which(!lop %in% installed.packages()[,'Package'])]

if(length(to.instal) != 0) install.packages(to.instal)

lapply(lop, library, character.only = T)

id <- '01048000'
year <- 1988

dta <- as.data.table(read.fwf(sprintf('ftp://hydrology.nws.noaa.gov/pub/gcip/mopex/US_Data/Us_438_Daily/%s.dly', id), widths = c(8,10,10,10,10,10)))
names(dta) <- c('DTM', 'P', 'E', 'R', 'Tmax', 'Tmin')
dta <- dta[, `:=`(DTM = as.Date(gsub(' ','0', DTM), format = '%Y%m%d'), 
                  T = rowMeans(.SD)),
           .SDcols = c('Tmax', 'Tmin')]

dta <- dta[R >= 0,]
dta <- dta[DTM %between% c(as.Date(paste(year, '11-1', sep = '-')), as.Date(paste(year + 3, '10-31', sep = '-')))]
library(data.table)
fp <- readRDS("../BabyNames/dataScripts/famousPeople/famousPeople.Rdata")

fp$personFame <- unlist( fp$personFame )

fp.sum <- fp[,
             sum(personFame,na.rm=TRUE),
             by=.(name,sex)
             ]

setnames( fp.sum, "V1", "fam" )

load("Rdata/demographicsRaw.Rdata")
demographics[, (setdiff(names(fp),c("sex","name"))) := NULL ]

demographics <- merge( demographics, fp.sum, by=c("name","sex") )

for( my.sex in c("Boy","Girl") ) {
  ecdf.fam <- ecdf( demographics[ sex==my.sex, fam ] )
  demographics[, pfam := 100*ecdf.fam(fam) ]
}

save( demographics, file="Rdata/demographics.Rdata" )
famousPeople <- fp
save( famousPeople, file="Rdata/famousPeople.Rdata" )

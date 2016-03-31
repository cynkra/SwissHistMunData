source("data-raw/00-common.R")
logging::logdebug(unzip.dir.name)

file.list <- unzip(zip.file.name, list=T)
unzip(zip.file.name, exdir=unzip.dir.name)

source("data-raw/00-common.R")
logging::logdebug(zip.file.name)
download.file(RECORD_HIST_URL, zip.file.name)

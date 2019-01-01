swcReadData <- function() {
  RECORD_HIST_URL <- 'https://www.bfs.admin.ch/bfsstatic/dam/assets/4924501/master'
  zip.file.name <- tempfile(fileext='.zip')
  logging::logdebug(zip.file.name)
  on.exit(unlink(zip.file.name), add=TRUE)

  download.file(RECORD_HIST_URL, zip.file.name, quiet = TRUE)

  unzip.dir.name <- tempfile()
  logging::logdebug(unzip.dir.name)
  on.exit(unlink(unzip.dir.name, recursive=T), add=TRUE)

  file.list <- unzip(zip.file.name, list=T)
  unzip(zip.file.name, exdir=unzip.dir.name)

  # Reading using unz() and recoding "on the fly"
  # didn't work for some reason
  ft <- list(
    canton=list(n='KT', colnames=c(
      'cId',
      'cAbbreviation',
      'cLongName',
      'cDateOfChange')),
    district=list(n='BEZ', colnames=c(
      'dHistId',
      'cId',
      'dId',
      'dLongName',
      'dShortName',
      'dEntryMode',
      'dAdmissionNumber',
      'dAdmissionMode',
      'dAdmissionDate',
      'dAbolitionNumber',
      'dAbolitionMode',
      'dAbolitionDate',
      'dDateOfChange')),
    municipality=list(n='GDE', colnames=c(
      'mHistId',
      'dHistId',
      'cAbbreviation',
      'mId',
      'mLongName',
      'mShortName',
      'mEntryMode',
      'mStatus',
      'mAdmissionNumber',
      'mAdmissionMode',
      'mAdmissionDate',
      'mAbolitionNumber',
      'mAbolitionMode',
      'mAbolitionDate',
      'mDateOfChange'))
  )
  codes <- c(`11`='Municipality',
             `12`='Area not allocated to mun.',
             `13`='Cantonal part of lake',
             `15`='District',
             `16`='Canton',
             `17`='Area not allocated to distr.',
             `20`='First-time registration',
             `21`='Creation',
             `22`='Change of name (d)',
             `23`='Change of name (m)',
             `24`='Reassignment to other d/c',
             `26`='Change of area',
             `27`='Formal renumbering',
             `29`='Abolition',
             `30`='Mutation canceled')

  l <- lapply(X=ft, FUN=function(t) {
    logging::logdebug('Parsing data set: %s', t$n)

    fname <- grep(paste0('_', t$n, '(?:_.*)?[.]txt'), file.list$Name, value=T)
    fpath <- file.path(unzip.dir.name, fname)
    dat <- read.table(fpath, sep='\t', quote='', col.names=t$colnames, fileEncoding='ISO8859-15', stringsAsFactors=F)

    date.names <- grep('Date', names(dat), value=T)
    logging::logdebug('Date names: %s', date.names)
    for (n in date.names) dat[, n] <- as.Date(dat[, n], format='%d.%m.%Y')

    mode.names <- grep('Mode', names(dat), value=T)
    logging::logdebug('Mode names: %s', mode.names)
    for (n in mode.names) dat[, n] <- factor(dat[, n], levels=names(codes), labels=codes)

    integer.names <- grep('Id|Number', names(dat), value=T)
    logging::logdebug('Integer names: %s', integer.names)
    for (n in integer.names) dat[, n] <- as.integer(dat[, n])

    character.names <- names(dat)[vapply(dat, is.character, logical(1))]
    for (n in character.names) Encoding(dat[, n]) <- "UTF-8"

    # Last column is compulsory
    stopifnot(!is.na(dat[, tail(t$colnames, 1)]))

    tibble::as_tibble(dat)
  })

  l
}

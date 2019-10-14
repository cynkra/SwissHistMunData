pkgload::load_all()

if (check_data()) {
  if (check_past_changes()) {
    if (interactive()) {
      warning("Past data changed, please double-check carefully!")
    } else {
      stop("Past data changed, please double-check manually and run data-raw/update-data.R")
    }
  }

  overwrite_data()
  desc::desc_bump_version('dev')
}


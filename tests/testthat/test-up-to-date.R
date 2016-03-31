context("up-to-date")

test_that("data is up-to-date", {
  pkg_path <- system.file(package = .packageName)
  data_path <- file.path(pkg_path, "data")
  if (all(Sys.time() - file.info(dir(data_path, full.names = TRUE))$mtime <
          as.difftime(1, units = "days")))
    skip("checked today")

  data <- swcReadData()

  expect_error({
    expect_identical(cantons, data$canton)
    expect_identical(district_mutations, data$district)
    expect_identical(municipality_mutations, data$municipality)
  }, NA)

  cantons <- data$canton
  district_mutations <- data$district
  municipality_mutations <- data$municipality

  devtools::use_data(pkg = pkg_path, cantons, district_mutations,
                     municipality_mutations, overwrite = TRUE)
})

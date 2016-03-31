context("up-to-date")

test_that("data is up-to-date", {
  data <- swcReadData()

  expect_error({
    expect_identical(cantons, data$canton)
    expect_identical(district_mutations, data$district)
    expect_identical(municipality_mutations, data$municipality)
  }, NA)

  cantons <- data$canton
  district_mutations <- data$district
  municipality_mutations <- data$municipality

  pkg_path <- system.file(package = .packageName)
  data_path <- file.path(pkg_path, "data")
  devtools::use_data(pkg = pkg_path, cantons, district_mutations,
                     municipality_mutations, overwrite = TRUE)
})

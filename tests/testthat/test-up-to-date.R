context("up-to-date")

test_that("data is up-to-date", {
  data <- swcReadData()

  expect_identical(canton, data$canton)
  expect_identical(district, data$district)
  expect_identical(municipality, data$municipality)

  canton <- data$canton
  district <- data$district
  municipality <- data$municipality

  pkg_path <- system.file(package = .packageName)
  data_path <- file.path(pkg_path, "data")
  devtools::use_data(pkg = pkg_path, canton, district, municipality, overwrite = TRUE)
})

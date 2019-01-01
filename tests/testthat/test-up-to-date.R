context("up-to-date")

test_that("data is up-to-date", {
  pkg_path <- system.file(package = .packageName)
  data_path <- file.path(pkg_path, "data")

  data <- swcReadData()

  expect_identical(cantons, data$canton)
  expect_identical(district_mutations, data$district)
  expect_identical(municipality_mutations, data$municipality)

  cantons <- data$canton
  district_mutations <- data$district
  municipality_mutations <- data$municipality

  usethis::with_project(
    pkg_path,
    usethis::use_data(
      cantons, district_mutations, municipality_mutations,
      overwrite = TRUE
    )
  )
})

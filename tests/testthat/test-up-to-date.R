context("up-to-date")

test_that("data is up-to-date", {
  data <- swcReadData()

  canton <- data$canton
  district <- data$district
  municipality <- data$municipality

  before <- tools::md5sum(dir("../../data", full.names = TRUE))
  devtools::use_data(canton, district, municipality, overwrite = TRUE)
  after <- tools::md5sum(dir("../../data", full.names = TRUE))
  expect_identical(before, after)
})

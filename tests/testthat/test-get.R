context("get")

test_that("swcGetData loads data as advertised", {
  expect_is(municipality_mutations$mHistId, "integer")
  expect_is(municipality_mutations$dHistId, "integer")
  expect_is(municipality_mutations$mId, "integer")
  expect_is(municipality_mutations$mAdmissionNumber, "integer")
  expect_is(municipality_mutations$mAbolitionNumber, "integer")
})

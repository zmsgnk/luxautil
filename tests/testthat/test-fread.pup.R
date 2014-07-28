context("fread.pup(): fread() for output of PupSQLite.")

test_that("fread.pup() can remove multibyte string from header", {
  
  data <- fread.pup("test.csv")
  firstColName <- colnames(data)[1]
  
  expect_that(firstColName, is_identical_to("deal_id"))
})

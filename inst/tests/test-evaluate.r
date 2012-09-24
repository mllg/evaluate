context("Evaluation")

test_that("file with only comments runs", {
  ev <- evaluate(file("comment.r"))
  expect_that(length(ev), equals(2))

  classes <- sapply(ev, class)
  expect_that(classes, equals(c("source", "source")))
})

test_that("data sets loaded", {
  ev <- evaluate(file("data.r"))
  expect_that(length(ev), equals(3))
})

# # Don't know how to implement this
# test_that("newlines escaped correctly", {
#   ev <- evaluate("cat('foo\n')")
#   expect_that(ev[[1]]$src, equals("cat('foo\\n'))"))
# })

test_that("terminal newline not needed", {
  ev <- evaluate("cat('foo')")
  expect_that(length(ev), equals(2))
  expect_that(ev[[2]], equals("foo"))
})

test_that("S4 methods are displayed with show, not print", {
  setClass("A", contains = "function")
  setMethod("show", "A", function(object) cat("B"))
  a <- new('A', function() b)

  ev <- evaluate("a")
  expect_equal(ev[[2]], "B")
})

test_that("all code run, even after error", {
  ev <- evaluate(file("error.r"))
  expect_that(length(ev), equals(4))
})

test_that("code aborts on error if stop_on_error == TRUE", {
  ev <- evaluate(file("error.r"), stop_on_error = TRUE)
  expect_that(length(ev), equals(2))
})

test_that("output and plots interleaved correctly", {
  ev <- evaluate(file("interleave-1.r"))
  expect_equal(out_classes(ev),
    c("source", "character", "recordedplot", "character", "recordedplot"))

  ev <- evaluate(file("interleave-2.r"))
  expect_equal(out_classes(ev),
    c("source", "recordedplot", "character", "recordedplot", "character"))
})

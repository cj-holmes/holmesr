#' Print all rows of a dataframe to the console
#'
#' Risky! Use with caution
#'
#' @param x A dataframe
#' @param n Number of rows to print (default = \code{nrow(x)})
#'
#' @export
print_all <- function(x, n=nrow(x)){
  print(x, n = n)
}


#' Remove outliers from a vector of numbers
#'
#' @param x A vector of numbers
#' @param na_fill Replace outliers with NA, keeping the length of x consistent (default = TRUE)
#' @param ... Further arguments passed to \code{grDevices::boxplot.stats()}
#'
#' @export
remove_outliers <- function(x, na_fill=TRUE, ...){

  # Use boxplot stats to compute outliers
  outliers <- grDevices::boxplot.stats(x, ...)$out

  # Return reduced length vector if na_fill = FALSE
  if(!na_fill) return(x[!x %in% outliers])

  # Replace outliers with NA and return x
  x[x %in% outliers] <- NA
  x
}

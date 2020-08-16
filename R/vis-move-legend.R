#' Move (or remove) a ggplot2 legend
#'
#' A convenience wrapper to move a \code{ggplot2} legend
#'
#' @param where One of "none", "left", "right", "bottom", "top", or two-element numeric vector
#' (default = "none")
#'
#' @return
#' @export
#'
#' @examples
#' mtcars %>%
#' ggplot(aes(wt, disp))+
#'   geom_point(aes(col = mpg))+
#'   move_legend("left")
move_legend <- function(where = "none"){
  list(
    ggplot2::theme(legend.position = where))
}

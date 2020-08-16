#' Add vertical and horizontal lines through the origin
#'
#' @param ... Arguments passed to \code{ggplot2::geom_segment()}
#'
#' @export
#'
#' @examples
#' mtcars %>%
#' ggplot(aes(wt, disp))+
#'   geom_point(aes(col = mpg))+
#'   geom_origin()

geom_origin <- function(...){

  d <- tibble::tibble(x = c(-Inf, 0),
                      xend = c(Inf, 0),
                      y = c(0, -Inf),
                      yend = c(0, Inf))

  list(
    ggplot2::geom_segment(data = d,
                          aes(x=x, xend=xend,
                              y=y, yend=yend),
                          inherit.aes = FALSE,
                          ...))
}

#' Rotate ggplot2 x axis text
#'
#' A convenience function to quickly rotate x-axis labels
#'
#' @param angle Angle of text rotation (default = 90)
#' @param hjust Horizontal text justification (default = 1)
#' @param vjust Vertical text justification (default = 0.5)
#' @param ... Further arguments passed to \code{ggplot2::element_text()}
#'
#' @export
#'
#' @examples
#' mtcars %>%
#' ggplot(aes(wt, disp))+
#' geom_point()+
#' rotate_x_labs()

rotate_x_labs <- function(angle = 90, hjust=1, vjust = 0.5, ...){
  list(
    ggplot2::theme(axis.text.x = ggplot2::element_text(angle=angle, vjust = vjust, hjust=hjust, ...))
  )
}

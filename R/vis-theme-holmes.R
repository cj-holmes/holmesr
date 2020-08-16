#' My ggplot2 plotting theme
#'
#' Some small tweaks to \code{ggplot2::theme_bw()}
#'
#' @param base_size base font size given in pts
#' @param base_family base font family
#' @param base_line_size base size for line elements
#' @param base_rect_size base size for rect elements
#'
#' @importFrom ggplot2 %+replace%
#' @export

theme_holmes <- function(base_size = 11,
                         base_family = "",
                         base_line_size = base_size/22,
                         base_rect_size = base_size/22){

  ggplot2::theme_grey(base_size = base_size,
                      base_family = base_family,
                      base_line_size = base_line_size,
                      base_rect_size = base_rect_size) %+replace%
    ggplot2::theme(panel.background = ggplot2::element_rect(fill = "white", colour = NA),
                   panel.border = ggplot2::element_rect(fill = NA, colour = "black"),
                   panel.grid = ggplot2::element_line(colour = "grey92"),
                   panel.grid.minor = ggplot2::element_blank(),
                   strip.background = ggplot2::element_blank(),
                   legend.key = ggplot2::element_rect(fill = "white", colour = NA),
                   complete = TRUE)
}

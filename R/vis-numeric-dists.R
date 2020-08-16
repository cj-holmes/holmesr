#' Visualise distributions of numeric columns in a dataframe
#'
#' Returns a facetted plot of the density estimate (scaled to 1) including an
#' overlay of the ECDF and horizontal box plot
#'
#' @param x dataframe containing numeric columns
#' @param cols Tidyselect columns to use (default = \code{dplyr::everything()})
#' @param remove_outliers Rremove outliers before visualisation (default = FALSE)
#' @param bp_thickness Boxplot thickness (in units of y)
#' @param bp_center Boxplot centre height (in units of y)
#' @param density_colour Density estimate fill colour
#' @param bp_colour Boxplot colour
#' @param ecdf_colour ECDF colour
#'
#' @export
#'
#' @examples
#' numeric_dists(diamonds[1:3000, ])
numeric_dists <- function(x,
                          cols = dplyr::everything(),
                          remove_outliers = FALSE,
                          bp_thickness = 0.12,
                          bp_center = 0,
                          density_colour = "grey",
                          bp_colour = "blue",
                          ecdf_colour = "red") {

  my_cols <- rlang::enquos(cols)

  # Select all columns specified, then only select the numeric ones of those
  # and convert dataframe to long format
  d <-
    x %>%
    dplyr::select(!!!my_cols) %>%
    dplyr::select_if(is.numeric) %>%
    tidyr::pivot_longer(dplyr::everything(), names_to="variable")

  # Remove outliers if specified (compute boxplot whisker ends per variable and filter to data between them)
  if(remove_outliers){
    d <-
      d %>%
      dplyr::group_by(variable) %>%
      tidyr::nest() %>%
      dplyr::mutate(bp_stats = purrr::map(data, ~grDevices::boxplot.stats(.x$value))) %>%
      dplyr::mutate(lower = purrr::map_dbl(bp_stats, ~.x$stats[1]),
                    upper = purrr::map_dbl(bp_stats, ~.x$stats[5])) %>%
      dplyr::select(variable, data, lower, upper) %>%
      tidyr::unnest(data) %>%
      dplyr::filter(dplyr::between(value, lower, upper)) %>%
      dplyr::select(variable, value)
    }


  # Compute boxplot stats on each variable
  bp_d <-
    d %>%
    dplyr::group_by(variable) %>%
    tidyr::nest() %>%
    dplyr::mutate(bp_stats =
                    purrr::map(data, ~dplyr::bind_rows(setNames(grDevices::boxplot.stats(.x$value)$stats,
                                                       c("lower", "bottom_edge", "median", "upper_edge", "upper"))))) %>%
    dplyr::select(variable, bp_stats) %>%
    tidyr::unnest(bp_stats)

  # Return plot
  d %>%
    ggplot2::ggplot()+
    ggplot2::geom_density(ggplot2::aes(x=value, y=ggplot2::after_stat(scaled)), fill=density_colour)+
    ggplot2::stat_ecdf(ggplot2::aes(x=value), geom="step", col=ecdf_colour)+
    ggplot2::geom_errorbarh(data = bp_d, ggplot2::aes(xmin=lower, xmax=upper, y=bp_center),
                            height=bp_thickness, col=bp_colour)+
    ggplot2::geom_rect(data = bp_d,
                       ggplot2::aes(xmin=bottom_edge,
                                    xmax=upper_edge,
                                    ymin=bp_center-bp_thickness/2,
                                    ymax=bp_center+bp_thickness/2),
                       fill=bp_colour, alpha=1/2)+
    ggplot2::geom_segment(data = bp_d,
                          ggplot2::aes(x=median,
                                       xend=median,
                                       y=bp_center+bp_thickness/2,
                                       yend=bp_center-bp_thickness/2),
                          col=bp_colour, size=1)+
    ggplot2::facet_wrap(~variable, scales = "free_x")+
    ggplot2::labs(x = "Variable value",
                  y = "Denstity estimate (scaled to 1)")
}

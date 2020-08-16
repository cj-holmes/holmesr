#' Visualise distributions of numeric and categorical columns in a dataframe
#'
#' @param x a dataframe
#' @param cols Tidyselect columns to use (default = \code{dplyr::everything()})
#' @param remove_outliers Remove outliers from numeric columns before visualisation (default = FALSE)
#' @param bp_thickness Boxplot thickness (in units of y)
#' @param bp_center Boxplot centre height (in units of y)
#' @param density_colour Density estimate fill colour
#' @param bp_colour Boxplot colour
#' @param ecdf_colour ECDF colour
#' @param top_n The top n levels to show - all other values will be lumped into 'Other'
#' @param na_colour Colour for NA bars
#' @param other_colour Colour for lumped 'Other' bars
#' @param ... Further arguments passed to \code{patchwork::wrap_plots()}
#'
#' @export
dists <- function(x,
                  cols = dplyr::everything(),
                  remove_outliers = FALSE,
                  top_n = 5,
                  bp_thickness = 0.12,
                  bp_center = 0,
                  density_colour = "grey",
                  bp_colour = "blue",
                  ecdf_colour = "red",
                  na_colour = "blue",
                  other_colour = "grey50",
                  ...
                  ){

  my_cols <- rlang::enquos(cols)
  df <- x %>% dplyr::select(!!!my_cols)

  # Count number of numeric and categoric columns
  n_numeric <- df %>% dplyr::select_if(is.numeric) %>% ncol()
  n_cat <- df %>% dplyr::mutate_if(is.factor, as.character) %>% dplyr::select_if(is.character) %>% ncol()

  # If no columns return an error
  if(n_numeric == 0 & n_cat == 0){stop("No columns")}

  # If only numeric columns return the numeric plot
  # If only categorical columns return categorical plot
  # If both, us epatchwork to plot both
  if(n_cat == 0 & n_numeric != 0){
    # Run numeric dists
    holmesr::numeric_dists(x = df,
                           cols = dplyr::everything(),
                           remove_outliers = remove_outliers,
                           bp_thickness = bp_thickness,
                           bp_center = bp_center,
                           density_colour = density_colour,
                           bp_colour = bp_colour,
                           ecdf_colour = ecdf_colour) +
      ggplot2::labs(title = "Numeric columns",
                    subtitle = dplyr::if_else(remove_outliers,
                                              "Outliers removed prior to density estimate",
                                              "All observations"))
  } else if (n_cat != 0 & n_numeric == 0){
    # Rnu categorical dists
    holmesr::categoric_dists(x = df,
                             cols = dplyr::everything(),
                             top_n=top_n,
                             na_colour = na_colour,
                             other_colour = other_colour) +
      ggplot2::labs(title="Categorical columns",
                    subtitle = paste0("Top ", top_n, " categories per variable"),
                    caption = paste0("Categories outside of the top ", top_n, " are grouped into 'Other'")
      )
  } else {
    # Use patchwork to plot both dists
    patchwork::wrap_plots(

    # Run numeric dists
    holmesr::numeric_dists(x = df,
                           cols = dplyr::everything(),
                           remove_outliers = remove_outliers,
                           bp_thickness = bp_thickness,
                           bp_center = bp_center,
                           density_colour = density_colour,
                           bp_colour = bp_colour,
                           ecdf_colour = ecdf_colour) +
      ggplot2::labs(title = "Numeric columns",
                    subtitle = dplyr::if_else(remove_outliers,
                                              "Outliers removed prior to density estimate",
                                              "All observations")),

    # Run categorical dists
    holmesr::categoric_dists(x = df,
                             cols = dplyr::everything(),
                             top_n=top_n,
                             na_colour = na_colour,
                             other_colour = other_colour) +
      ggplot2::labs(title="Categorical columns",
                    subtitle = paste0("Top ", top_n, " categories per variable"),
                    caption = paste0("Categories outside of the top ", top_n, " are grouped into 'Other'")
                    ),
    ...
    )
  }
  }



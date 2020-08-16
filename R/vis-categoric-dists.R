#' Visualise distributions of categorical columns in a dataframe
#'
#' Returns a facetted plot of the count and percent of the top levels in each categorical column
#' of a dataframe
#'
#' @param x A dataframe containing character columns
#' @param cols Tidyselect columns to use (default = \code{dplyr::everything()})
#' @param top_n The top n levels to show - all other values will be lumped into 'Other'
#' @param na_colour Colour for NA bars
#' @param other_colour Colour for lumped 'Other' bars
#'
#' @export
categoric_dists <- function(x,
                            cols = dplyr::everything(),
                            top_n=5,
                            na_colour = "blue",
                            other_colour = "grey50"){

  my_cols <- rlang::enquos(cols)

  d <-
    x %>%
    # Select specified columns
    dplyr::select(!!!my_cols) %>%
    # Convert factor (or odered factor) columns to character first
    dplyr::mutate_if(is.factor, as.character) %>%
    # Select the character columns
    dplyr::select_if(is.character) %>%
    # Pivot long and lump categoricals
    tidyr::pivot_longer(tidyselect::everything()) %>%
    dplyr::group_by(name) %>%
    dplyr::mutate(value_lumped =
                    forcats::fct_lump(value, n = top_n) %>%
                    forcats::fct_explicit_na(na_level = "NA")) %>%
    # Count
    dplyr::count(name, value_lumped) %>%
    # Create unique label by pasteing the facet var and categorical value together
    # Also create an ordereding variable that puts "Other" and "NA" last
    dplyr::group_by(name) %>%
    dplyr::mutate(group_min = min(n)) %>%
    dplyr::mutate(temp_x_var = paste0(name, "__", value_lumped),
                  temp_order_var = dplyr::case_when(value_lumped == "Other" ~ as.integer(group_min - 1),
                                                    value_lumped == "NA" ~ as.integer(group_min - 2),
                                                    TRUE ~ n)) %>%
    dplyr::mutate(fill_column = dplyr::case_when(value_lumped == "NA" ~ na_colour,
                                                 value_lumped == "Other" ~ other_colour,
                                                 TRUE ~ "grey"))

  d %>%
    ggplot2::ggplot(ggplot2::aes(reorder(temp_x_var, temp_order_var), n))+
    ggplot2::geom_col(ggplot2::aes(fill = fill_column))+
    ggplot2::facet_wrap(~name, scales = "free", strip.position = "top")+
    ggplot2::coord_flip()+
    ggplot2::scale_x_discrete(labels = function(x) stringr::str_remove(x, "[A-z]+__"))+
    ggplot2::scale_y_continuous(sec.axis = ggplot2::sec_axis(~./nrow(x)*100,
                                                             # name = "Percent",
                                                             breaks = scales::pretty_breaks(3),
                                                             labels = function(x) paste0(x, "%")))+
    ggplot2::scale_fill_identity()+
    ggplot2::labs(x = "Category value", y = "Count")
  }

% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/vis-dists.R
\name{dists}
\alias{dists}
\title{Visualise distributions of numeric and categorical columns in a dataframe}
\usage{
dists(
  x,
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
)
}
\arguments{
\item{x}{a dataframe}

\item{cols}{Tidyselect columns to use (default = \code{dplyr::everything()})}

\item{remove_outliers}{Remove outliers from numeric columns before visualisation (default = FALSE)}

\item{top_n}{The top n levels to show - all other values will be lumped into 'Other'}

\item{bp_thickness}{Boxplot thickness (in units of y)}

\item{bp_center}{Boxplot centre height (in units of y)}

\item{density_colour}{Density estimate fill colour}

\item{bp_colour}{Boxplot colour}

\item{ecdf_colour}{ECDF colour}

\item{na_colour}{Colour for NA bars}

\item{other_colour}{Colour for lumped 'Other' bars}

\item{...}{Further arguments passed to \code{patchwork::wrap_plots()}}
}
\description{
Visualise distributions of numeric and categorical columns in a dataframe
}

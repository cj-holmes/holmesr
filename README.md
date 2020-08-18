
# holmesr <img src="data-raw/hex-logo/hex-logo.png" align="right" height="139"/>

The goal of `holmesr` is to collate (and make portable) a miscellany of
my personal R functions.

Some of the more useful functions

  - Visualisation
      - `dists()`
      - `numeric_dists()`
      - `categoric_dists()`
      - `rotate_x_labs()`
      - `geom_origin()`
      - `move_legend()`
      - `theme_holmes()`
  - Data wrangling
      - `remove_otliers()`
      - `print_all()`

Install package, add it to the search path and set the plotting theme

``` r
library(holmesr)

# Set the homesr plotting theme
ggplot2::theme_set(theme_holmes())
```

### Visualising dataframe distributions

Probably the most useful function is `dists()` which returns a plot of
the distributions of numeric and categorical columns in a dataframe.

``` r
dists(ggplot2::diamonds)
```

![](man/figures/README-unnamed-chunk-3-1.png)<!-- -->

Ther are several arguments for customisation, including
`remove_outliers` to remove outliers before numerical distirutions are
computed, and `cols` for selecting the columns to include/not include
with tidyselect semantics. For instance, when a categorical column
contains unique values for every row (the `dplyr::starwars` `name`
column) it is useful to not plot its distribution (below)…

``` r
dists(dplyr::starwars, remove_outliers = TRUE, cols=c(-name, -sex))
```

![](man/figures/README-unnamed-chunk-4-1.png)<!-- -->

Arguments passed to `...` are passed on to `patchwork::wrap_plots` and
control the layout of the visualisation (`ncol`, `nrow`, `widths`,
`heights`, etc…)

\name{strikeFX}
\alias{strikeFX}
\title{Visualize PITCHf/x strikezones}
\usage{
  strikeFX(data, geom = "point", point.size = 3,
    point.alpha = 1/3, color = "pitch_types",
    density1 = list(), density2 = list(), contour = FALSE,
    adjust = TRUE, layer = list(),
    limitz = c(-2.5, 2.5, 0, 5), parent = FALSE, ...)
}
\arguments{
  \item{data}{PITCHf/x data to be visualized.}

  \item{geom}{plotting geometry. Multiple geometries can be
  plotted at once, but only considers: "point", "hex",
  "bin" and "contour".}

  \item{point.size}{Size of points}

  \item{point.alpha}{ggplot2 alpha parameter}

  \item{color}{variable used to control coloring scheme.}

  \item{density1}{List defines a density estimate.}

  \item{density2}{List defines a density estimate. If
  \code{density1 != density2}, the density estimates are
  automatically differenced.}

  \item{contour}{logical. Should contour lines be
  included?}

  \item{adjust}{logical. Should vertical locations be
  adjusted according to batter height?}

  \item{layer}{list of other ggplot2 (layered)
  modifications.}

  \item{limitz}{limits for horizontal and vertical axes.}

  \item{parent}{is the function being called from a
  higher-level function? (experimental)}

  \item{...}{extra options passed onto geom commands}
}
\value{
  Returns a ggplot2 object.
}
\description{
  Pitch locations as they crossed home plate.
}
\details{
  Various bivariate plots with "px" on the horizontal axis
  and "pz" on the vertical axis.
}
\examples{
data(pitches)
strikeFX(pitches, geom="tile", layer=facet_grid(.~stand))
\dontrun{strikeFX(pitches, geom="hex", density1=list(des="Called Strike"), density2=list(des="Ball"), layer=facet_grid(.~stand))}
}


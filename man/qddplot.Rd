\name{qddplot}
\alias{qddplot}
\title{
Quantile Difference Diagram
}
\description{
Creates quantile difference diagrams.
It takes two numerical datasets, sorts them, calculates differences on the same quantiles (i.e. lowest with the lowest, median with the median, 90\% with 90\% etc.) and displays these differences.
It is appropriate for visual illustration of Wilcoxon rank test and F-test of equality of variances.
}
\usage{
qddplot(x, y, 
	remove.ratio = 0.1, differences.range = NA, differences.rangemin = 10, 
	differences.drawzero = TRUE, quantiles.drawhalf = TRUE, 
	quantiles.showaxis = TRUE, line.lwd = 5, xlab = "Quantile", 
	ylab = "Difference", main = "Quantile Differences", ...)
}
\arguments{
  \item{x, y}{
		vectors of numeric values to be compared. It is not necessary to have the same length.
  }
  \item{remove.ratio}{
		a real number in range [0.0, 0.5). Indicates how much leading and tailing data should not be displayed in order to avoid a bias on the diagram caused by outliers.
  }
  \item{differences.range}{
		numeric, indicating the value range (i.e. the y axis) to be shown. The default value is NA, indicating the maximum absolute value is considered. This can be overridden with an explicit value.
  }
  \item{differences.rangemin}{
		numeric, indicating the minimum value of the value range. Used in combination with \code{differences.range=NA} (the default), else ignored.
  }
  \item{differences.drawzero}{
		logical, indicating if the y=0 helper line should be displayed.
  }
  \item{quantiles.drawhalf}{
		logical, indicating if the x=0.5 helper line should be displayed.
  }
  \item{quantiles.showaxis}{
		logical, indicating if the custom values on the x axis should be displayed.
  }
  \item{line.lwd}{
		width of the main line.
  }
  \item{xlab}{
		title for the x axis, see \code{\link{plot}}.
  }
  \item{ylab}{
		title for the y axis, see \code{\link{plot}}.
  }
  \item{main}{
		plot title, see \code{\link{plot}}.
  }
  \item{\dots}{
		standard graphic parameters. See \code{\link{par}} for details.
  }
}

\details{
The quantile difference diagrams can be used to visualize the results of Wilcoxon rank tests (\code{\link{wilcox.test}}).
Wilcoxon rank test basically checks if the values found in one dataset are different (more specifically: higher or lower) than those in the other.
If the values in subset x are higher than values in subset y at all quantiles, then the result would look like a line completely on the same part of y coordinate (either completely on the positive or on the negative part).

In most of the cases the diagram resembles on a more or less straight line.
The slope indicates the difference between variances (see also \code{\link{var.test}}).
The position of the line indicates if the values in one dataset is higher than those in another; being close to 0 at 50\%, if they are similar.
}

\author{
	Csaba Farago <farago@inf.u-szeged.hu>
}

\examples{
# Using default settings with random data.
qddplot(rnorm(100, 30, 50), rnorm(200, 10, 10));

# remove.ratio = 0.0 means the outliers are not removed.
qddplot(rnorm(100, 30, 50), rnorm(200, 10, 10), remove.ratio=0.0);

# remove.ratio = 0.25 means only the middle half is displayed, the upper and lower quantile are not.
qddplot(rnorm(100, 30, 50), rnorm(200, 10, 10), remove.ratio=0.25);

# Illustrating similar and different medians and variances on 4 quantile difference diagrams.
# This is also an illustration for setting custom main title and subtitle.
dataSetA <- seq(-20, 20) + rnorm(41);
dataSetB <- seq(-15, 25) + rnorm(41);
dataSetC <- seq(-40, 40) + rnorm(81);
dataSetD <- seq(-20, 20) + rnorm(41);
op <- par(mfrow=c(2,2));
qddplot(
	dataSetA, 
	dataSetD, 
	main = "Similar median, similar variance",
	sub = "-20...20 vs. -20...20");
qddplot(
	dataSetA, 
	dataSetB, 
	main = "Different median, similar variance",
	sub = "-20...20 vs. -15...25");
qddplot(
	dataSetA, 
	dataSetC, 
	main = "Similar median, different variance",
	sub = "-20...20 vs. -40...40");
qddplot(
	dataSetB, 
	dataSetC, 
	main = "Different median, different variance",
	sub = "-15...25 vs. -40...40"); 
par(op);

# Change plot style: thicker line in red color.
qddplot(rnorm(100, 30, 50), rnorm(200, 10, 10), line.lwd=10, col="red");

# Hide axes, helper lines and captions.
qddplot(rnorm(100, 30, 50), rnorm(200, 10, 10), differences.drawzero=FALSE, 
	quantiles.drawhalf=FALSE, quantiles.showaxis=FALSE, line.lwd=1, yaxt='n', 
	main="", sub="", xlab="", ylab="");

# Do not consider minimal range.
qddplot(rnorm(100, 1, 1), rnorm(100, 2, 1), differences.rangemin=NA);

# Set an explicit range.
qddplot(rnorm(100, 0, 200), rnorm(100, 0, 200), differences.range=40);
}
\keyword{ dplot }

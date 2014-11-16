\name{ccdplot}
\alias{ccdplot}
\title{
Cumulative Characteristic Diagram
}
\description{
The parameter array (or list of arrays) is sorted non-ascending.
Then cumulative values are calculated for every value.
E.g. the fifth element of the resulting array will be the sum of the first 5 elements in the sorted array.
The resulting array is illustrated visually, taking the vector indices as x coordinate, the calculated cumulative values as y coordinate, and the points are connected with lines..

The function can handle an array or list of arrays.
In the latter case all the values are drawn on the same diagram, along with the union of them (if not stated otherwise).
The diagram works with numeric data of any distribution; however, the most spectacular results are expected in case of data of normal distribution with mean of 0.
}
\usage{
ccdplot(x, remove.absolute = NA, remove.ratio = NA, 
	drawcomposite = TRUE, jump = NA, 
	xlab = "Observations", ylab = "Cumulatives", ...)
}
\arguments{
  \item{x}{
		the array or list of arrays to be illustrated.
  }
  \item{remove.absolute}{
		if provided, the values greater than this one in absolute are not considered in drawing the diagram. Useful if the dataset contains outliers, as this diagram is sensitive on them.
  }
  \item{remove.ratio}{
		if provided, the upper and lower ratio is removed before drawing the diagram. E.g. if this value is 0.05, then the lower and upper 5\% is omitted. If the parameter \code{x} is list of arrays, then this is performed globally (i.e. not one by one on each element).
  }
  \item{drawcomposite}{
		this logical parameter indicates if the union of the provided data should be drawn. The default value is true. This feature is especially useful if the values within arrays are disjoint: it provides an overview how the individual parts fit to the whole.
  }
  \item{jump}{
		in case of composite cumulative characteristic diagrams (i.e. if the x is a list), the diagram looks better if small gaps between characteristic lines are drawn. The size if this gap is automatically calculated; however, that can be overwritten with this parameter.
  }
  \item{xlab}{
		title for the x axis, see \code{\link{plot}}.
  }
  \item{ylab}{
		title for the y axis, see \code{\link{plot}}.
  }
  \item{\dots}{
		standard graphic parameters. See \code{\link{par}} for details.
  }
}

\details{
A typical cumulative characteristic diagram is an upside-down U shape.
If it is not, then the input is not a normal distributed data with mean of 0.

If the right end of the diagram is above the left end, it means the sum of positive values are greater than the absolute value of the sum of negative values, meaning the average is above 0.
A long horizontal part in the middle indicates high number of 0 values.

In case of comparing two or more characteristic, if one of them turns to be relatively "taller" than the others (i.e. their heights are more or less the same, but their width significantly differ; in this case considering the narrowest), this means the variance of that subset is greater than variance in the other cases.
}

\author{
	Csaba Farago <farago@inf.u-szeged.hu>
}

\examples{
# Create cumulative characteristic diagram using 100 random values 
# of standard normal distribution.
ccdplot(rnorm(100));

# Create cumulative characteristic diagram using 95 random values 
# of standard normal distribution and 5 outliers.
ccdplot(c(rnorm(95), 11:15)); 

# Neutralize the bias caused by the outliers, 
# removing the values greater than 10 in absolute.
ccdplot(c(rnorm(95), 11:15), remove.absolute=10);

# Neutralize the bias caused by the outliers, 
# removing the upper and lower 10\%.
ccdplot(c(rnorm(95), 11:15), remove.ratio=0.1); 

# Create composite cumulative characteristic diagram of 4 arrays 
# (normal distribution, different element numbers, all the mean are 0, 
# the standard deviations are different).
ccdplot(list(rnorm(50, 0, 5), rnorm(100), rnorm(150), rnorm(200, 0, 0.2))) 

# Set some standard graphich parameters.
ccdplot(rnorm(100), main="Cumulative Characteristic Diagram", 
sub="100 random values of standard normal distribution", 
ylab="Summed random values", xlab="Sorted occurrences", col="red");
}

\keyword{ dplot }

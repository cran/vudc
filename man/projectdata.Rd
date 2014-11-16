\name{projectdata}
\alias{projectdata}
\docType{data}
\title{
Commit and Maintainability Data
}
\description{
This dataset contains commit and maintainability data about every available revision of 4 different projects.
}
\usage{data("projectdata")}
\format{
The outermost structure of the data is a list; each element of the list contains information about one Java project.

Each element of the list is a data frame of same structure. One row of data frame contains information about one commit.
There are the following columns for each commit:

\itemize{
	\item \code{A} (integer): number of Java files added
	\item \code{U} (integer): number of Java files updated 
	\item \code{D} (integer): number of Java files deleted
	\item \code{MaintainabilityDiff} (real): number indicating how the maintainability was changes upon that commit
}

Currently there are 4 elements in the main list (number of commits in bracket): \code{Ant} (6102), \code{Gremon} (1158), \code{Struts2} (1749) and \code{Tomcat} (1292).
}
\details{
The Java projects this data structure contains information of are the following:
\itemize{
	\item Ant: a command line tool for building Java applications (\url{http://ant.apache.org})
	\item Gremon: a greenhouse work-flow monitoring system (\url{http://www.gremonsystems.com})
	\item Struts2: a framework for creating enterprise-ready Java web applications (\url{http://struts.apache.org/2.x})
	\item Tomcat: an implementation of the Java Servlet and Java Server Pages technologies (\url{http://tomcat.apache.org})
}

In the data frame all the commits are included in which at least one Java file was affected, and the order of the elements reflects the original order in the SVN source control.

The maintainability change values were determined based on the maintainability values, calculated by the Columbus Quality Model for every revision. 
If this value is positive, it means the maintainability of the source code was increased, and if it is negative, then it decreased.
The absolute value indicates the magnitude of the change. For details how these values were calculated are described in the referenced articles.

The source code and version control information for Ant, Struts 2 and Tomcat are publicly available.
The Gremon was implemented by a local company; neither the source code nor the version control information are public.
}
\references{
T. Bakota, P. Hegedus, P. Kortvelyesi, R. Ferenc, and T. Gyimothy: \emph{A probabilistic software quality model}, 27th IEEE International Conference on Software Maintenance (ICSM 2011), pp. 243-252.

Cs. Farago, P. Hegedus, and R. Ferenc: \emph{The impact of version control operations on the quality change of the source code}, Computational Science and Its Applications (ICCSA 2014) pp. 353-369.
}
\examples{
# display data on composite cumulative characteristic diagrams
data(projectdata);
op <- par(mfrow=c(2,2));
for (projectName in c("Gremon","Ant","Struts2","Tomcat")) {
	actualProjectData <- projectdata[[projectName]];
	maintainabilityDiffs <- list(
		actualProjectData[actualProjectData$D > 0, "MaintainabilityDiff"],
		actualProjectData[actualProjectData$D == 0 
			& actualProjectData$A > 0, "MaintainabilityDiff"], 
		actualProjectData[actualProjectData$D == 0 & actualProjectData$A == 0 
			& actualProjectData$U >= 2, "MaintainabilityDiff"], 
		actualProjectData[actualProjectData$D == 0 & actualProjectData$A == 0 
			& actualProjectData$U == 1, "MaintainabilityDiff"]
	);
	ccdplot(
		maintainabilityDiffs, 
		remove.absolute=1000.0, 
		main=paste(projectName, "unbiased", sep=" - "), 
		sub="(overall, delete, add, update+, update 1)", 
		xlab="Revisions", 
		ylab="Accumulated maintainability change", 
		cex.main=1.5, 
		cex.axis=1.2);
}
par(op)
}
\keyword{datasets}

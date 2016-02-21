\name{projectdata}
\alias{projectdata}
\docType{data}
\title{
Commit and Maintainability Data
}
\description{
This dataset contains commit and maintainability data about every available revision of four software projects.
}
\usage{data("projectdata")}
\format{
The outermost structure of the data is a list; each element of the list contains commit-related information about one Java project (number of commits in bracket): \code{Ant} (6102), \code{Gremon} (1158), \code{Struts2} (1749) and \code{Tomcat} (1292).

Each element of the list is a data frame of same structure.
One row of data frame contains information about one commit.
There are the following columns for each commit:

\itemize{
	\item \code{Revision} (integer): revision number
	\item \code{MaintainabilityDiff} (double): number indicating how the maintainability was changed on the effect of that commit
	\item \code{A} (integer): number of Java files added
	\item \code{U} (integer): number of Java files updated 
	\item \code{D} (integer): number of Java files deleted
	\item \code{Churn} (double): code churn value of the commit
	\item \code{Ownership} (double): ownership value of the commit
}
}
\details{
The Java projects are the following:
\itemize{
	\item Ant: a command line tool for building Java applications (\url{http://ant.apache.org})
	\item Gremon: a greenhouse work-flow monitoring system (\url{http://www.gremonsystems.com})
	\item Struts2: a framework for creating enterprise-ready Java web applications (\url{http://struts.apache.org/})
	\item Tomcat: an implementation of the Java Servlet and Java Server Pages technologies (\url{http://tomcat.apache.org})
}

The data frame contains information about all the available commits from the master branch, which affects at least one Java file.

We determined the maintainability using the Columbus Quality Model.
Positive value means that the actual commit increased the maintainability of the overall source code, and negative value indicates the opposite.
The absolute value indicates the magnitude of the change.
For details how we calculated these values are described in the referred papers.

The source code and version control information for Ant, Struts 2 and Tomcat are publicly available.
The Gremon is an industrial software; neither the source code nor the version control information are public.
}

\author{
	Csaba Farago <farago@inf.u-szeged.hu>
}

\references{
Tibor Bakota, Peter Hegedus, Peter Kortvelyesi, Rudolf Ferenc, and Tibor Gyimothy. A probabilistic software quality model. In \emph{Proceedings of the 27th International Conference on Software Maintenance (ICSM)}, pages 243-252. IEEE Computer Society, 2011.

Csaba Farago, Peter Hegedus, Adam Zoltan Vegh, and Rudolf Ferenc. Connection Between Version Control Operations and Quality Change of the Source Code. \emph{Acta Cybernetica}, volume 21(4), pages 585-607, 2014.

Csaba Farago, Peter Hegedus, and Rudolf Ferenc. The Impact of Version Control Operations on the Quality Change of the Source Code. In \emph{Proceedings of the 14th International Conference on Computational Science and Its Applications (ICCSA)}, volume 8583 Lecture Notes in Computer Science (LNCS), pages 353-369. Springer International Publishing, 2014.

Csaba Farago. Variance of Source Code Quality Change Caused by Version Control Operations. \emph{Acta Cybernetica}, volume 22(1), pages 35-56, 2015.

Csaba Farago, Peter Hegedus, and Rudolf Ferenc. Code Ownership: Impact on Maintainability. In \emph{Proceedings of the 15th International Conference on Computational Science and Its Applications (ICCSA)}, volume 9159 Lecture Notes in Computer Science (LNCS), pages 3-19. Springer International Publishing, 2015.

Csaba Farago, Peter Hegedus, and Rudolf Ferenc. Cumulative Code Churn: Impact on Maintainability. In \emph{Proceedings of the 15th International Working Conference on Source Code Analysis and Manipulation (SCAM)}, pages 141-150. IEEE Computer Society, 2015.
}

\examples{
# Initialization.
library(vudc)
data(projectdata)

#
# Helper functions.
# These are necessary for the drawing and test execution functions.
#

# Frame for drawing four diagrams.
drawFourDiagrams <- function(diagram) {
	op <- par(mfrow = c(2,2))
	performOperationAllProjects(diagram)
	par(op)
}

# Frame for executing an operation on all the available project data.
performOperationAllProjects <- function(operation) {
	for (projectName in c("Ant", "Gremon", "Struts2", "Tomcat")) {
		operation(projectName)
	}
}

# Helper functions for getFourDivisions and categorizeProjectData.

commitCategoryD <- function(actualProjectData) {
	actualProjectData$D > 0
}

commitCategoryA <- function(actualProjectData) {
	actualProjectData$D == 0 & actualProjectData$A > 0
}

commitCategoryUplus <- function(actualProjectData) {
	actualProjectData$D == 0 & actualProjectData$A == 0 & actualProjectData$U >= 2
}

commitCategoryU1 <- function(actualProjectData) {
	actualProjectData$D == 0 & actualProjectData$A == 0 & actualProjectData$U == 1
}


# Divides the maintainability difference values into four, based on the related operations.
getFourDivisions <- function(actualProjectData) {
	return (list(
		actualProjectData$MaintainabilityDiff[commitCategoryD(actualProjectData)],
		actualProjectData$MaintainabilityDiff[commitCategoryA(actualProjectData)], 
		actualProjectData$MaintainabilityDiff[commitCategoryUplus(actualProjectData)], 
		actualProjectData$MaintainabilityDiff[commitCategoryU1(actualProjectData)]
	))
}

# Extend project data with  operation category (opcat) 
# and maintainability change category (changecat).
categorizeProjectData <- function(projectName) {
	actualProjectData <- projectdata[[projectName]]
	
	actualProjectData$opcat[commitCategoryD(actualProjectData)] <- 'D';
	actualProjectData$opcat[commitCategoryA(actualProjectData)] <- 'A';
	actualProjectData$opcat[commitCategoryUplus(actualProjectData)] <- 'U+';
	actualProjectData$opcat[commitCategoryU1(actualProjectData)] <- 'U1';
	
	actualProjectData$changecat[actualProjectData$MaintainabilityDiff > 0] <- '+';
	actualProjectData$changecat[actualProjectData$MaintainabilityDiff == 0] <- '0';
	actualProjectData$changecat[actualProjectData$MaintainabilityDiff < 0] <- '-';
	
	actualProjectData
}

# Removed outliers from project data.
projectDataWithoutOutliers <- function(projectName) {
	projectdata[[projectName]][abs(projectdata[[projectName]]$MaintainabilityDiff) < 1000,]
}

# Maintainability change values of commits containing file addition.
maintainabilityDiffsContainingAdd <- function(actualProjectData) {
	actualProjectData$MaintainabilityDiff[actualProjectData$A > 0]
}

# Maintainability change values of commits not containing file addition.
maintainabilityDiffsWithoutAdd <- function(actualProjectData) {
	actualProjectData$MaintainabilityDiff[actualProjectData$A == 0]
}



#
# Diagram drawing and test execution functions.
# These can be executed independent from each other.
#

# Box plots illustrating maintainability change values.
# This is the motivating example for creating ccdplot.
drawFourDiagrams(
	function(projectName) {
		boxplot(
			getFourDivisions(projectdata[[projectName]]),
			main = projectName,
			names = c("D", "A", "U+", "U1")
		)
	}
)

# Box plots illustrating maintainability change values, without outliers.
drawFourDiagrams(
	function(projectName) {
		boxplot(
			getFourDivisions(projectDataWithoutOutliers(projectName)),
			main = projectName,
			names = c("D", "A", "U+", "U1")
		)
	}
)

# Composite cumulative characteristic diagrams illustrating maintainability change values,
# including outliers.
drawFourDiagrams(
	function(projectName) {
		ccdplot(
			getFourDivisions(projectdata[[projectName]]), 
			main = projectName,
			sub = "D, A, U+, U1", 
			xlab = "Revisions", 
			ylab = "Accumulated maintainability change"
		)
	}
)

# Composite cumulative characteristic diagrams illustrating maintainability change values,
# without outliers.
drawFourDiagrams(
	function(projectName) {
		ccdplot(
			getFourDivisions(projectDataWithoutOutliers(projectName)), 
			main = projectName,
			sub = "D, A, U+, U1", 
			xlab = "Revisions", 
			ylab = "Accumulated maintainability change"
		)
	}
)

# Perform Contingency Chi Squared Test on the input data.
performOperationAllProjects (
	function(projectName) {
		projectDataCategorized <- categorizeProjectData(projectName)
		print(paste(projectName, "contingency test", sep = " - "))
		chisq.test.result <- chisq.test(table(
			projectDataCategorized$opcat, 
			projectDataCategorized$changecat)
		)
		print(chisq.test.result)
		print(paste("Exact p-value:", chisq.test.result$p.value))
	}
)

# Cumulative characteristic diagrams illustrating the maintainability change values 
# between commits containing and not containing file additions.
drawFourDiagrams(
	function(projectName) {
		actualProjectData <- projectdata[[projectName]]
		maintainabilityDiffs <- list(
			maintainabilityDiffsContainingAdd(actualProjectData),
			maintainabilityDiffsWithoutAdd(actualProjectData)
		)
		ccdplot(
			maintainabilityDiffs, 
			remove.absolute = 1000.0, 
			main = paste(projectName, "Add", sep = " - "), 
			sub = "Containing vs. not containing Add", 
			xlab = "Revisions", 
			ylab = "Accumulated maintainability change"
		)
	}
)

# Quantile difference diagrams illustrating the difference of the maintainability change values 
# between commits containing and not containing file additions.
drawFourDiagrams(
	function(projectName) {
		actualProjectData <- projectdata[[projectName]]
		qddplot(
			maintainabilityDiffsContainingAdd(actualProjectData),
			maintainabilityDiffsWithoutAdd(actualProjectData),
			main=paste(projectName, "Add", sep = " - "), 
			sub="Containing vs. not containing Add"
		)
	}
)

# Testing the difference of the maintainability change values between commits containing 
# and not containing file additions, using Wilcoxon-test.
performOperationAllProjects (
	function(projectName) {
		actualProjectData <- projectdata[[projectName]]
		print(paste(projectName, "impact of file addition", sep = " - "))
		print(wilcox.test(
			maintainabilityDiffsContainingAdd(actualProjectData),
			maintainabilityDiffsWithoutAdd(actualProjectData),
			alternative = "greater"
		))
	}
)

# Testing the ratio of the maintainability change variance between commits containing 
# and not containing file additions.
performOperationAllProjects (
	function(projectName) {
		actualProjectData <- projectDataWithoutOutliers(projectName)
		print(paste(projectName, "variance of file addition", sep = " - "))
		var.test.result <- var.test(
			maintainabilityDiffsContainingAdd(actualProjectData),
			maintainabilityDiffsWithoutAdd(actualProjectData)
		)
		print(var.test.result)
		print(paste("Exact p-value:", var.test.result$p.value))
	}
)

# Quantile difference diagrams illustrating the difference of cumulative code churn values 
# between commits of positive vs. negative maintainability change, along with related Wilcox-test.
drawFourDiagrams(
	function(projectName) {
		actualProjectData <- projectdata[[projectName]]
		churnX <- actualProjectData$Churn[actualProjectData$MaintainabilityDiff > 0]
		churnY <- actualProjectData$Churn[actualProjectData$MaintainabilityDiff < 0]
		print(paste(projectName, "cumulative code churn", sep = " - "))
		print(wilcox.test(churnX, churnY, alternative = "less"))
		qddplot(
			churnX, 
			churnY,
			main=paste(projectName, "Churn", sep = " - ")
		)
	}
)

# Quantile difference diagrams illustrating the difference of number of contributors 
# between commits of positive vs. negative maintainability change, along with related Wilcox-test.
drawFourDiagrams(
	function(projectName) {
		actualProjectData <- projectdata[[projectName]]
		ownershipX <- actualProjectData$Ownership[actualProjectData$MaintainabilityDiff > 0]
		ownershipY <- actualProjectData$Ownership[actualProjectData$MaintainabilityDiff < 0]
		print(paste(projectName, "code ownership", sep = " - "))
		print(wilcox.test(ownershipX, ownershipY, alternative = "less"))
		qddplot(
			ownershipX, 
			ownershipY,
			differences.rangemin = 0,
			main=paste(projectName, "Ownership", sep = " - ")
		)
	}
)

}
\keyword{datasets}

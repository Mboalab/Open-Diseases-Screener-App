#install.packages("RoughSets") #This line should be deleted after the first run
rm( list = ls( envir = globalenv() ), envir = globalenv() ) #Delete objects
library(RoughSets)
source("supportingfunctions.R") #Functions
source("load_supervised_data_classification.R") #Load data set
# Delete variables with zero variance
Var0Variable = variables_zerovariance(X)
source("delete_variables_for_supervisedmethod.R")

# 1. Discretize explanatory variable (X) and objective variable (Y)
Xy = as.data.frame(cbind(X,y))
DecisionTableXy = SF.asDecisionTable(Xy, decision.attr = ncol(Xy), indx.nominal = ncol(Xy))
CutValues = D.discretization.RST(DecisionTableXy, type.method = "global.discernibility")
DecisionTableXyDiscretization = SF.applyDecTable(DecisionTableXy, CutValues)

# 2. Run RST
# Preparation of decision table
# Preparation of discernibility matrix
# Calculation of reduct
RSTResultsReducts = FS.feature.subset.computation(DecisionTableXyDiscretization, method="quickreduct.rst")
# Selection of reduct
# Preparation of decision table made with selected reduct
# Preparation of discernibility matrix made with selected reduct
RSTResultsSelectedVariables = SF.applyDecTable(DecisionTableXyDiscretization, RSTResultsReducts)
# Deviation of rules
RSTResultsRules = RI.indiscernibilityBasedRules.RST(DecisionTableXyDiscretization, RSTResultsReducts)

# Show result
print(RSTResultsRules, length(RSTResultsRules))


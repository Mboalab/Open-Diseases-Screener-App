#Find variables with zero variance
variables_zerovariance = function(X){
  Var0Variable <- which(apply(X,2,var) == 0)
  if (length(Var0Variable) == 0) {
    print("No variables with zero vairance")
  } else {
    sprintf("%d variable(s) with zero variance", length(Var0Variable))
    print( "Variable number:" )
    print( Var0Variable )
    print( "The variable(s) is(are) deleted." )
  }
  return(Var0Variable)
}


#Calculate r^2
calc_r2 = function( ActualY, EstimatedY ){
  return( 1 - sum( (ActualY-EstimatedY )^2 ) / sum((ActualY-mean(ActualY))^2) )
}

#Calculate RMSE
calc_RMSE = function( ActualY, EstimatedY ){
  return( sqrt( sum( (ActualY-EstimatedY )^2 ) / nrow(ActualY)) )
}

#Make YYplot
make_yyplot = function( ActualY, EstimatedY, YMax, YMin, EstimatedYName ){
  par(pty = "s")
  plot( ActualY, EstimatedY, 
        xlim=c(YMin-0.05*(YMax-YMin),YMax+0.05*(YMax-YMin)), 
        ylim=c(YMin-0.05*(YMax-YMin),YMax+0.05*(YMax-YMin)), 
        col = "blue", xlab = "Actual Y", ylab = EstimatedYName)
  abline(0,1)
  par(pty = "m")
}


#Make tt plots for PCA with clustering result
make_ttplot_withclustering = function( PcaResult, ClusterNum ){
  pairs(PcaResult$x[,1:3], col = ClusterNum)
  plot( PcaResult$x[,1], pca_result$x[,2], col = ClusterNum, xlab = "First principal component", ylab = "Second  principal component")
  text( PcaResult$x[,1], pca_result$x[,2], labels = rownames(X), pos=3, offset = 0.1)
}

#Make Threshold for T^2 and SPE
make_threshold_t2spe = function( Index, NumOfIndexThreshold ){
  SortedIndex = sort(Index)
  return( SortedIndex[NumOfIndexThreshold] )
}
#Save vector
savevectorcsv = function( X, ColName, FileName ){
  ClusterNum <- as.matrix( X, col = length(X), row = 1 )
  colnames(X) <- c(ColName)
  write.table(X, FileName, quote=FALSE, sep = ",", col.names=NA)
}

#Optimize gamma to maximize variance of Gaussian gram matrix
optimize_gamma_grammatrix = function(X, CandidatesOfGamma){
  # Calculate gram matrix of Gaussian kernel and its variance for each gamma candidate
  VarianceOfKernelMatrix <- NULL
  DistanceMatrics <- dist(X, diag = TRUE, upper = TRUE)^2
  for (CandidateOfGamma in CandidatesOfGamma) {
    KernelMatrix <- exp(-CandidateOfGamma*DistanceMatrics)
    VarianceOfKernelMatrix <- c(VarianceOfKernelMatrix,var(c(as.vector(KernelMatrix),as.vector(KernelMatrix),rep(1,nrow(X)))))
  } 
  # Decide the optimal gamma with the maximum variance value
  OptimalGamma = CandidatesOfGamma[which(VarianceOfKernelMatrix == max(VarianceOfKernelMatrix))]
  return( OptimalGamma[1] )

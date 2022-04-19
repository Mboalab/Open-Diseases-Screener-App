# Delete variables whose numbers are 'Var0Variable' from X, X_prediction1 and X_prediction2
if (length(Var0Variable) != 0) {
  X = X[,-Var0Variable]
  X_prediction11 = X_prediction11[,-Var0Variable]
  X_prediction12 = X_prediction12[,-Var0Variable]
}

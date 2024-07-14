# rm(list = ls())
# install.packages("caret")
# library(caret)
# install.apcakges("randomForest")
# library(randomForest)
# install.apcakges("glmnet")
# library(glmnet)


train.sample.ratio <- 0.6
fitted.loss.v <- c()
for (p in 1:20) {
  
  
  y <- response[(22 + p):82]
  X <- array(0, c(length(y), p))
  for (j in 1:p) {
    X[, j] <- response[(22 + p -j):(82 - j)]
  }
  
  
  n_train.sample <- round(length(y) * train.sample.ratio)
  
  # Random sample splitting
  ind.train.sample <- sample(length(y), n_train.sample)
  ind.validation.sample <- setdiff(1:length(y), ind.train.sample)
  train.sample.y <- y[ind.train.sample]
  train.sample.X <- X[ind.train.sample, ]
  validation.sample.y <- y[ind.validation.sample]
  validation.sample.X <- X[ind.validation.sample, ]
  
  # in-sample fitted loss 
  # fitted.loss.v <- c(fitted.loss.v, var(lm.model$residuals))
  
  knn.model <- knnreg(
    as.data.frame(train.sample.X),
    train.sample.y,
    k = 2
  )
  predicted.values <- predict(knn.model, validation.sample.X)
  
  # linear regression :
  # lm.model <- lm(train.sample.y ~ train.sample.X)
  # predicted.values <- cbind(1, validation.sample.X) %*% lm.model$coefficients
  # 
  
  fitted.loss.v <- c(fitted.loss.v, var(predicted.values - validation.sample.y))
}
# 觀察out-of-sample fitted loss如何依參數變化。
# 以上至此，設計統計預測模型時評比效能都靠這段代碼了。
plot(fitted.loss.v)



train_validation <- function(model.fitter, X, y) {
  train.sample.ratio <- 0.6
  
  n_train.sample <- round(length(y) * train.sample.ratio)
  
  # Random sample splitting
  ind.train.sample <- sample(length(y), n_train.sample)
  ind.validation.sample <- setdiff(1:length(y), ind.train.sample)
  train.sample.y <- y[ind.train.sample]
  train.sample.X <- X[ind.train.sample, ]
  validation.sample.y <- y[ind.validation.sample]
  validation.sample.X <- X[ind.validation.sample, ]
  
  predictor <- model.fitter(train.sample.X, train.sample.y)
  
  predicted.values <- predictor(validation.sample.X)
  
  r.square <- 1 - 
    mean((validation.sample.y - predicted.values)^2) / var(validation.sample.y)
  return (r.square)
  
}



###

lm.model.fitter <- function(X, y) {
  lm.model <- lm(y ~ X)
  predictor <- function(X.test) { cbind(1, X.test) %*% lm.model$coefficients }
  return (predictor)
}

pca.model.fitter <- function(X, y) {
  # how many principle components we want to use?
  n_pc <- 2
  n <- length(y)
  
  svd.X <- svd(X)
  
  train.pca.X <- array(0, c(n, n_pc))
  for (j in 1:n_pc) {
    train.pca.X[, j] <- X %*% svd.X$v[, j]
  }
  
  # Least square
  pca.model <- lm(y ~ train.pca.X)
  
  
  return (function(U) { 
    new.pca.X <- array(0, c(DIM(U)[1], n_pc))
    for (j in 1:n_pc) {
      new.pca.X[, j] <- U %*% svd.X$v[, j]
    }
    
    return(cbind(1, new.pca.X) %*% pca.model$coefficients)
  })
}






train_validation(lm.model.fitter, X, y)
train_validation(pca.model.fitter, X, y)

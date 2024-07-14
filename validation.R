# rm(list = ls())



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
####
# An example for how to use `train_validation` based on lm.model
lm.model.fitter <- function(X, y) {
  lm.model <- lm(y ~ X)
  predictor <- function(X.test) { cbind(1, X.test) %*% lm.model$coefficients }
  return (predictor)
}


# simulated data
n <- 100
p <- 10
error.sd <- 1
s_star <- 10
beta <- rep(0, p)
beta[s_star] <- 1

X <- array(rnorm(n * p), c(n, p))
y <- X %*% beta + error.sd * rnorm(n)


# the test sample R^2
train_validation(lm.model.fitter, X, y)

###
####
# Your task:
# Implement a model fitter for knn
# simulated data

# Hint: knn predictor 可以在 knn_fittedloss.R 找到唷

knn.model.fitter <- function(X, y) {
  "working here!"
  predictor <- function (X.test) { "working here!" }
  return (predictor)
}

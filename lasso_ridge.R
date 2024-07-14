# rm(list = ls())
# install.packages("caret")
# library(caret)
# install.apcakges("randomForest")
# library(randomForest)
# install.apcakges("glmnet")
# library(glmnet)


# simulated data
n <- 100
p <- 50
error.rate <- 0.3
beta.temp  <- rep(1, p)
beta <- beta.temp / norm_vec(beta.temp, 1) # standardized


# training sample
X <- array(rnorm(n), c(n, p)) + error.rate * array(rnorm(n * p), c(n, p))
y <- X %*% beta + rnorm(n)


# test sample
X.test <- array(rnorm(n), c(n, p)) + error.rate * array(rnorm(n * p), c(n, p))
y.test <- X.test %*% beta

# Train the Lasso and ridge models
cv.ridge.model <- cv.glmnet(X, y, alpha = 0)
cv.lasso.model <- cv.glmnet(X, y, alpha = 1)


predicted.values <- cbind(1, X.test) %*% coef(cv.ridge.model, s = "lambda.min")
var(as.numeric(y.test - predicted.values))


predicted.values <- cbind(1, X.test) %*% coef(cv.lasso.model, s = "lambda.min")
var(as.numeric(y.test - predicted.values))
var(y.test)



## 
cv.lasso.model <- cv.glmnet(X, y, alpha = 1)

cvfit$lambda.min
coef(cvfit, s = "lambda.min")

cv.ridge.model <- cv.glmnet(X, y, alpha = 0)


lasso.model <- glmnet(X, y, alpha = 1)
lasso.model$beta





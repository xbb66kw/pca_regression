# rm(list = ls())
# install.packages("glmnet")
# library(glmnet)


# rm(list = ls())
###
####
# auxiliary function
norm_vec <- function(x, a) (sum(x^a))^(1/a)

DIM <- function(x) {
  if( is.null( dim(x) ) )
    return( length(x) )
  dim(x)
}

###
####
# simulated data: An example
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


###
####
# linear regression
lm.model <- lm(y ~ X)
predicted.values <- cbind(1, X.test) %*% lm.model$coefficients
mean((y.test - predicted.values)^2)



###
####
# pca regression 
svd.X <- svd(X)

# check that we can recover X
mean((X - svd.X$u %*% diag(svd.X$d) %*% t(svd.X$v))^2)

# how many principle components we want to use?
n_pc <- 3

train.pca.X <- array(0, c(n, n_pc))
for (j in 1:n_pc) {
  train.pca.X[, j] <- X %*% svd.X$v[, j]
}

# Least square
# pca.model <- lm(y ~ train.pca.X)

# The fitted coefficients
# pca.model$coefficients
# cf <- pca.model$coefficients

# Train the Lasso model
cv.lasso.model <- cv.glmnet(train.pca.X, y, alpha = 1)
cf <- coef(cv.lasso.model, s = "lambda.min")

fitted.coef <- array(0, DIM(X)[2])
for (j in 1:n_pc) {
  fitted.coef <- fitted.coef + cf[1 + j] * svd.X$v[, j]
}
# Include the intercept
fitted.coef <- c(cf[1], fitted.coef)








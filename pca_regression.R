# rm(list = ls())
###
####
# auxiliary function
norm_vec <- function(x, a) (sum(x^a))^(1/a)

###
####
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



###
####
# pca regression 
svd.X <- svd(X)

# check that we can recover X
mean((X - svd.X$u %*% diag(svd.X$d) %*% t(svd.X$v))^2)

# how many principle components we want to use?
n_pc <- 4

train.pca.X <- array(0, c(n, n_pc))
for (j in 1:n_pc) {
  train.pca.X[, j] <- X %*% svd.X$v[, j]
}

# Least square
pca.model <- lm(y ~ train.pca.X)

# to see the fitted coefficients
pca.model$coefficients


###
####
# to use the pca model, we need to prepare the proper 
# covariate matrix (in the test sample)
# USING THE TEST SAMPLE NOW
new.pca.X <- array(0, c(n, n_pc))
for (j in 1:n_pc) {
  new.pca.X[, j] <- X.test %*% svd.X$v[, j]
}

# Get the predicted values based on the pca regression
predicted.values <- cbind(1, new.pca.X) %*% pca.model$coefficients

# Evaluation on the test sample
mean((y.test - predicted.values)^2)




###
####
# As a comparison
lm.model <- lm(y ~ X)
predicted.values <- cbind(1, X.test) %*% lm.model$coefficients
mean((y.test - predicted.values)^2)


###
####
# QUESTION:
# What if there are two or more factors in our covariate matrix?


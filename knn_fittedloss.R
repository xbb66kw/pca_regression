# rm(list = ls())
# install.packages("caret") # for knn model
# library(caret)


n <- 100
p <- 50
error.sd <- 1
s_star <- 10
beta <- rep(0, p)
beta[s_star] <- 1

# simulated data
X <- array(rnorm(n * p), c(n, p))
y <- X %*% beta + error.sd * rnorm(n)


train.sample.ratio <- 0.6
fitted.r.squares <- c()
for (q in 1:p) {

  X.temp <- array(X[, 1:q], c(n, q))
  n_train.sample <- round(length(y) * train.sample.ratio)
  
  # Random sample splitting
  ind.train.sample <- sample(length(y), n_train.sample)
  ind.validation.sample <- setdiff(1:length(y), ind.train.sample)
  train.sample.y <- y[ind.train.sample]
  train.sample.X <- X.temp[ind.train.sample, ]
  validation.sample.y <- y[ind.validation.sample]
  validation.sample.X <- X.temp[ind.validation.sample, ]
  
  
  # linear regression :
  lm.model <- lm(train.sample.y ~ train.sample.X)
  predicted.values <- cbind(1, validation.sample.X) %*% lm.model$coefficients
  # 
  r.square <- 1 - 
    mean((validation.sample.y - predicted.values)^2) / var(validation.sample.y)
  fitted.r.squares <- c(fitted.r.squares, r.square)
}
# 觀察 validation sample fitted loss (R^2) 如何依參數變化。
plot(fitted.r.squares, ylim = c(-1, 1), pch = 19, cex = 0.5)
# 以上至此，今天設計統計預測模型時評比效能都靠這段代碼了。




###
####
# Your task:
# do the same thing for knn
# you may adjust the parameters p, error.sd, and s_star
# to get the U-shaped trade-off
# comment on the results

# simulated data
X <- array(rnorm(n * p), c(n, p))
y <- X %*% beta + 3 * rnorm(n)

# knn model
knn.model <- knnreg( 
  as.data.frame(X),
  y,
  k = 2
)

# In-sample predicted values of y
predicted.values <- predict(knn.model, X)

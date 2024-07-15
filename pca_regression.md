輔助函數
```
norm_vec <- function(x, a) (sum(x^a))^(1/a)
```

模擬資料參數
```
###
####
# simulated data: An example
n <- 100  
p <- 50
error.rate <- 0.3
beta.temp  <- rep(1, p)
beta <- beta.temp / norm_vec(beta.temp, 1) # standardized
```

regression model 適用的模擬資料
```
# training sample
X <- array(rnorm(n), c(n, p)) + error.rate * array(rnorm(n * p), c(n, p))
y <- X %*% beta + rnorm(n)
```

factor model 適用的模擬資料
```
# test sample
X.test <- array(rnorm(n), c(n, p)) + error.rate * array(rnorm(n * p), c(n, p))
y.test <- X.test %*% beta

```

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

這是為什麼呢？

如果
`X_{j} = X + e_{j}, j = 1, ..., p`, 我們要如何找回 `X`？

注意，如果 `e_{j}, j = 1,..., p`是 i.i.d., 那麼 `\sum_{j=1}^{p} 1/sqrt{p} * X_{j}` 可以估計 `X`，而且 `(1/sqrt{p}, ..., 1/sqrt{p})` 是單位長度權重向量。

這種情況，R 的 `svd` 函數提供一個可能性。

```
svd.X <- svd(X)
svd.X$u %*% diag(svd.X$d) %*% t(svd.X$v) # 還原 X


svd.X$v[, 1] # 估計單位權重向量 (1 / sqrt(p), ..., 1 / sqrt(p))
```

為什麼不直接平均呢？

如果 `X_{j} = X + e_{j}, j = 1, p / 2` 而且 `X_{j} = Z + e_{j}, j = 1 + p / 2, ..., p` 就不能用平均，只能用 `svd`

```
n <- 100
p <- 200 # 得大一點才有那個效果 (為什麼呢？)
X <- array(0, c(n, p))
X[, 1:(p / 2)] <- array(rnorm(n), c(n, (p / 2))) + error.rate * array(rnorm(n * (p / 2)), c(n, (p / 2)))
X[, (1 + p / 2):p] <- array(rnorm(n), c(n, (p / 2))) + error.rate * array(rnorm(n * (p / 2)), c(n, (p / 2)))

svd.X <- svd(X)
svd.X$v[, 1] # 估計單位權重向量 (sqrt(2) / sqrt(p), ..., sqrt(2) / sqrt(p), 0, ..., 0)
svd.X$v[, 2] # 估計單位權重向量 (0, ..., 0, sqrt(2) / sqrt(p), ..., sqrt(2) / sqrt(p))

```

> [!NOTE]
> `svd` 使用範圍非常廣，可以處理 common factors 的性組合。有興趣可以自己去查找資料唷！



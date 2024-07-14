# pca_regression


# Factor models v.s regression models

E.g., Housing price indices 有分成美東, 美西, 美中, 等等.

我們如果要預測全美 housing proce index (HOUST), 

  - 一個想法是 regression
  - 一個想法是 factor model

> [!IMPORTANT]
> 試著評估 factor model 是不是更適合用來處理我們手上的資料.

# Train / Validation Samples

初步評估統計方法的好工具

## knn_fittedloss.R

 - 簡單的模擬資料：
```
n <- 100
p <- 50
error.sd <- 1
s_star <- 10
beta <- rep(0, p)
beta[s_star] <- 1

# simulated data
X <- array(rnorm(n * p), c(n, p))
y <- X %*% beta + error.sd * rnorm(n)
```
- train sample and validation sample 用於評估適當的參數數目使用
- 以 knn 為例，看看結果有什麼不同？


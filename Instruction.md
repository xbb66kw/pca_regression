# Factor models v.s regression models

E.g., Housing price indices 有分成美東, 美西, 美中, 等等.

我們如果要預測全美 housing price index (HOUST), 

  - 一個想法是 regression model
  - 一個想法是 factor model

> [!NOTE]
> 今天目標：試著評估 factor model 是不是更適合用來處理我們手上的資料.

> 會使用一個簡單的統計評估工具

> 還有介紹一個基於 factor model assumption 的 regression method: pca regression

# R codes introduction:


## knn_fittedloss.R

> 初步評估統計方法的好工具

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
> [!IMPORTANT]
>  以 knn 為例，看看結果有什麼不同？


## validation.R
-  實作了 train_validation, input 為 model fitter, 可以生成 predictor 函數
-  實作了 lm.model 的 model fitter
> [!IMPORTANT]
>  以 knn 實作 model fitter

## pca_regression.R
### 實作一個可以利用 factor model 的統計模型
- 模擬資料 : 適合 factor model / 適合 regression model
  
  ```
  n <- 100  
  p <- 50
  error.rate <- 0.3
  beta.temp  <- rep(1, p)
  beta <- beta.temp / norm_vec(beta.temp, 1) # standardized

  # training sample
  X <- array(rnorm(n), c(n, p)) + error.rate * array(rnorm(n * p), c(n, p))
  y <- X %*% beta + rnorm(n)
  ```
  
- 評估 lm.model 是否適合該底模擬資料
- 介紹 pca regression (大家辛苦了~)
- Model fitter of pca.model
> [!NOTE]
> 如果有超過一個 latent factors 在 covariate matrix 裡呢？

## HOUST.R
- source("/.../data_process.r")
> [!NOTE]
> 記得換路徑唷
- FRED-MD 資料檢查
- "HOUST" 的好朋友們："HOUST", "HOUSTNE", "HOUSTMW", "HOUSTS", "HOUSTW"
- 準備 AR(2) 的 covariance matrix
- 估一個 AR(2) 模型
- 估一個 pca AR(2) 模型 pca.ar.model (大家又辛苦了~)
- Model fitter for pca.ar.model 

> [!IMPORTANT]
> 評估 pca AR(1) - pca AR(4) 誰最適用。


> [!IMPORTANT]
> 評估 factor model 適不適用於以下序列： "HOUST", "UNRATE", "S.P.500", "TB3SMFFM", "CPIAUCSL"

可使用此函式查找變數行 (column) 索引值
```
which(names(categories)  %in% c("HOUST", "UNRATE", "S.P.500", "TB3SMFFM", "CPIAUCSL"))
```

> 你可能還會需要 FRED-MD_updated_appendix.pdf 幫助尋找相關變數名稱

> 保持簡潔扼要。重點是說服你的聽眾

> [!IMPORTANT]
> 預測以下序列在 5/1/2024 的值: "HOUST", "UNRATE", "S.P.500", "TB3SMFFM", "CPIAUCSL"。
> 評測標準：
```sum_{j=1}^{5} ( (\hat{v}_{j} - v_{j}) \times (sd_{j})^{-1}  )^2```。其中，
> sd_{HOUST} =  0.6554, sd_{UNRATE} = 0.3790, sd_{S.P.500} = 0.0384, sd_{TB3SMFFM} = 0.2599, sd_{CPIAUCSL} = 0.3056.

> 黑魔法允許


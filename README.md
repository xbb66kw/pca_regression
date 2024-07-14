# pca_regression


# Factor models v.s regression models

E.g., Housing price indices 有分成美東, 美西, 美中, 等等.

我們如果要預測全美 housing proce index (HOUST), 

  - 一個想法是 regression
  - 一個想法是 factor model

> [!IMPORTANT]
> 今天目標：試著評估 factor model 是不是更適合用來處理我們手上的資料.

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
- 評估 lm.model 是否適合該底模擬資料
- 介紹 pca regression (大家辛苦了~)
- Model fitter of pca.model
> [!NOTE]
> 如果有超過一個 latent factors 在 covariate matrix 裡呢？

## HOUST.R
- source("/.../data_process.r")
> [!NOTE]
> 記得換路徑唷
-

> [!IMPORTANT]
> 評估 factor model 是不適用於以下序列： "HOUST", "UNRATE", "S.P.500", "TB3SMFFM", "CPIAUCSL"

> 你可能會需要 FRED-MD_updated_appendix.pdf 幫助尋找變數名稱

> 保持簡潔扼要。重點是說服你的聽眾

> [!IMPORTANT]
> 預測以下序列在 6/1/2024 的值: "HOUST", "UNRATE", "S.P.500", "TB3SMFFM", "CPIAUCSL"

> 黑魔法允許

# .rds
從 1/1/1999 至 4/1/2024 的北美總體經濟月資料。

可使用 data_processs.r 讀取:
```
source("/你的路徑/data_process.r")
```
資聊主要存在 `data_organized` 變數。
> 包含302個月觀察值與126個經濟變數。
變數 `date` 儲存時間點
> date # 3/1/1999 - 4/1/2024
變數 `categories` 儲存經濟變數名稱與其相對應變數處理碼 (FRED-MD code)
> 我們不需使用 FRED-MD code
可用 `names(categories)` 觀察變數名稱陣列

# .pdf

`which(names(categories)  %in% "S.P.500")`


#

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
- 準備 AR(2) 的 covariance matrix
- 估一個 AR(2) 模型
- 估一個 pca AR(2) 模型 pca.ar.model (大家又辛苦了~)
- Model fitter for pca.ar.model 

> [!IMPORTANT]
> 評估 factor model 是不適用於以下序列： "HOUST", "UNRATE", "S.P.500", "TB3SMFFM", "CPIAUCSL"

> 你可能會需要 FRED-MD_updated_appendix.pdf 幫助尋找變數名稱

> 保持簡潔扼要。重點是說服你的聽眾

> [!IMPORTANT]
> 預測以下序列在 6/1/2024 的值: "HOUST", "UNRATE", "S.P.500", "TB3SMFFM", "CPIAUCSL"

> 黑魔法允許

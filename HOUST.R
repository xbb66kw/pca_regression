# rm(list = ls())

# source("/Users/xbb/Desktop/7_18/data_process.r")

# index finder
index_finder <- function(x) { which(names(categories)  %in% x) }


###
####
# data check
# 302 x 126 matrix
str(data_organized)
date # 3/1/1999 - 4/1/2024
categories
names(categories)



# Check if these FRED-MD series are included in our dataset
"UEMP15T26" %in% names(categories)
"EXCAUSx" %in% names(categories)
"S&P 500" %in% names(categories) # they may have different name
"S.P.500" %in% names(categories) 
"HOUST" %in% names(categories) 
"UNRATE" %in% names(categories) 


 
 
HOUST.ind <- index_finder("HOUST") # 48
HOUST.friend.ind <- index_finder(c("HOUST", "HOUSTNE", "HOUSTMW", "HOUSTS", "HOUSTW"))


###
####
# Build an AR(2) model for "HOUST"
response <- data_organized[, HOUST.ind]
response <- response[3:length(response)]

covaraince.matrix <- data_organized[, HOUST.friend.ind]


# construct the design
X <- array(0, c(length(response), DIM(covaraince.matrix)[2] * 2))
for (t in 1:2) {
  X[, ((t-1) * DIM(covaraince.matrix)[2] + 1):(DIM(covaraince.matrix)[2] * t)] <- 
    covaraince.matrix[(3-t):(DIM(covaraince.matrix)[1] - t), ]
}


# record the dates of responses (HOUST); from 5/1/1999 to 4/1/2024
date_temp <- date[3:length(date)]

# check for the two AR lags
response
X[, 1]
X[, 6]



###
####
# AR(2)
lm.predictor <- lm.model.fitter(X, response)
# in-sample predicted values of y

###
####
# AR(2) PCA regression
# X[, 1:5] are the first lags of "HOUST", "HOUSTNE", "HOUSTMW", "HOUSTS", "HOUSTW"
# X[, 6:10] are the second lags of them
# pca regression coefficient getter
pca.regression.coef <- function(X, y, n_pc, ind_set = NULL) {
  if (is.null(ind_set)) {ind_set <- list(1:DIM(X)[2])}
  n <- length(y)
  
  svd.list <- list()
  train.pca.X <- array(0, c(n, n_pc * length(ind_set)))
  i <- 1
  for (design in ind_set) {
    
    X.temp <- X[, design]
    svd.X.temp <- svd(X.temp)
    svd.list[[i]] <- svd.X.temp
    for (j in 1:n_pc) {
      train.pca.X[, n_pc * (i - 1) + j] <- X.temp %*% svd.X.temp$v[, j]
    }
    
    
    i <- i + 1
  }
  
  # Least square
  pca.model <- lm(y ~ train.pca.X)
  
  ceof_output <- array(0, DIM(X)[2])
  i <- 1
  for (design in ind_set) {
    for (j in 1:n_pc) {
      coef <- pca.model$coefficients[1 + n_pc * (i - 1) + j] 
      svd.X.temp <- svd.list[[i]]
      ceof_output[design] <- ceof_output[design] + coef * svd.X.temp$v[, j]
    }
    i <- i + 1
  }
  return (c(pca.model$coefficients[1], ceof_output))
  
}



###
####
#### Model fitter for pca.ar.model
pca.ar.model.fitter <- function(X, y) {
  n_pc <- 4
  coef <- pca.regression.coef(X, y, n_pc, ind_set = list(1:5, 6:10))
  predictor <- function(X.test) { cbind(1, X.test) %*% coef }
  return (predictor)
}



predictor <- pca.ar.model.fitter(X, response)
# predicted values of response
predictor(X)

# validation fitted loss
train_validation(pca.ar.model.fitter, X, response)
# comparison with lm,.model
train_validation(lm.model.fitter, X, response)



###
####
# Your task:
# pca AR(1), pca AR(2), pca AR(3), pca AR(4), 哪個好？ 
# n_pc 多少比較好？
# 如何造 AR(q) response 和 covaraince matrix?

# Build an AR(q) model for "HOUST"
response <- data_organized[, HOUST.ind]
response <- response[(q + 1):length(response)]
covaraince.matrix <- data_organized[, HOUST.friend.ind]
# construct the design
q <- 3
X <- array(0, c(length(response), DIM(covaraince.matrix)[2] * q))
for (t in 1:q) {
  X[, ((t - 1) * DIM(covaraince.matrix)[2] + 1):(t * DIM(covaraince.matrix)[2])] <- 
    covaraince.matrix[(q + 1 - t):(DIM(covaraince.matrix)[1] - t), ]
}








###
####
# Your final task!
# 觀測資料的時間 (不一定要 1999 - 2024 全用), 變數選擇, lags數目選擇都會影響 factor model 的品質。
# 對 regression model 亦是如此。
# 要如何對兩種方法有一個公平的比較？

# 平時習慣的統計工具都可以嘗試
# 測試成果要能說服別人。
# 可以互相解釋給成員聽，看看有沒有明顯不合理需要加強的步驟？

# 歡迎提問，但最後還得靠自己呢！


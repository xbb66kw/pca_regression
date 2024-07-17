# rm(list = ls())

DIM <- function(x) {
  if( is.null( dim(x) ) )
    return( length(x) )
  dim(x)
}



# Remember to change the file path
file_name = '/Users/xbb/Desktop/7_18/training.rds'




data_ <- readRDS(file = file_name)


# The first row is the category index.
# record the categories of each column
categories <- data_[1,-1]

# traning sample from 1/1/1999 - 4/1/2024
data_ <- data_[482:DIM(data_)[1], ]  # 1/1/1999

# The first column is the date column
date <- data_[, 1]



# Compare this to the FRED-MD appendix file
names(categories)

# Prepare the data for our tasks.
# Delete the date column.
data_ <- data_[, -1]



# fill up the missing values (NAs)
# Each NA is assigned the same value as the value from the last month.
# it is known that there are no NAs in 2015:1
for (t in 2:DIM(data_)[1]) {
  if (length(which(is.na(data_[t,])))) {
    data_[t, which(is.na(data_[t,]))] <- data_[t-1, which(is.na(data_[t,]))]
  }
}

# which(is.na(data_)) # no NAs
# DIM(data_) # (785, 126)
# length(categories) # 126


cpi.index <- which(colnames(data_) == 'CPIAUCSL') # CPIAUCSL is the CPI for all items
# data_[, cpi.index]
# cpi.index # 105


# data_organized[784, index_finder(c("HOUST", "UNRATE", "S.P.500", "TB3SMFFM", "CPIAUCSL"))]


# ---- data transformation ----
data_organized <- array(0, c(dim(data_)[1] - 2, dim(data_)[2]))

for (j in 1:length(categories)) {
  if (j == cpi.index) {
    # perchange changes of CPI: ((x_{t} - x_{t-1}) / x_{t-1}) * 100
    
    x <- data_[, j]
    x <- ((x[2:length(x)] / x[1:(length(x) - 1)]) - 1) * 100
    data_organized[, j] <- x[-1]
    
  } else {
    if (categories[j] == 7) {
      x <- data_[, j]
      x <- (x[2:length(x)] / x[1:(length(x) - 1)]) - 1
      x <- x[2:length(x)] - x[1:(length(x) - 1)]
      data_organized[, j] <- x
    }
    if (categories[j] == 6) {
      x <- log(data_[, j])
      x <- x[2:length(x)] - x[1:(length(x) - 1)]
      x <- x[2:length(x)] - x[1:(length(x) - 1)]
      data_organized[, j] <- x
    }
    if (categories[j] == 2) {
      x <- data_[, j]
      x <- x[2:length(x)]
      x <- x[2:length(x)] - x[1:(length(x) - 1)]
      data_organized[, j] <- x
    }
    if (categories[j] == 3) {
      x <- data_[, j]
      x <- x[2:length(x)] - x[1:(length(x) - 1)]
      x <- x[2:length(x)] - x[1:(length(x) - 1)]
      data_organized[, j] <- x
    }
    if (categories[j] == 4) {
      x <- log(data_[, j])
      data_organized[, j] <- x[c(-1, -2)]
    }
    if (categories[j] == 5) {
      x <- log(data_[, j])
      x <- x[2:length(x)] - x[1:(length(x) - 1)]
      data_organized[, j] <- x[-1]
    }
    if (categories[j] == 1) {
      x <- data_[, j]
      data_organized[, j] <- x[3:length(x)]
    }
  }
}



# record the dates of responses; from 3/1/1999 to 4/1/2024
# removing two period of data due to difference operation in preprocessing the time series
date <- date[c(-1, -2)]



# output 
data_organized
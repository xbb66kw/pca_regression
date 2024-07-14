# rm(list = ls())
# data downloaded from https://research.stlouisfed.org/econ/mccracken/fred-databases/

DIM <- function(x) {
  if( is.null( dim(x) ) )
    return( length(x) )
  dim(x)
}


file <- '/Users/xbb/Desktop/7_18/2024-06.csv'

data_ <- read.csv(file)
# DIM(data_)
# the first row is the category index.
data_[, 1]


# record the categories of each column
categories <- data_[1,-1]

# use data from 2013:1 to 2023:1
# in the meantime the first row, which records the cotegories, is not included
# data_[650, 1] # 1/1/2013
# data_[757, 1]  # 12/1/2021
# data_[482, 1]  # 1/1/1999
test.sample <- data_[DIM(data_)[1],] # test sample
test.sample[1]
# training.sample <- data_[1:(DIM(data_)[1] - 1),] # training sample

#  training.sample[,1]

# saveRDS(training.sample, file = "/Users/xbb/Desktop/7_18/training.rds")





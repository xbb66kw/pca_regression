# training.rds
從 1/1/1999 至 4/1/2024 的北美總體經濟月資料。

可使用 data_processs.r 讀取:
```
source("/你的路徑/data_process.r")
```
資料主要存在 `data_organized` 變數。
> 包含302個月觀察值與126個經濟變數。

變數 `date` 儲存時間點
> date # 3/1/1999 - 4/1/2024

變數 `categories` 儲存經濟變數名稱與其相對應變數處理碼 (FRED-MD code)
> 我們不需使用 FRED-MD code

可用 `names(categories)` 觀察變數名稱陣列

# FRED-MD_updated_appendix.pdf

在 `data_organized` 裡面變數的一些細節。文件包含變數名稱以供查找。
可用以下函數找變數 "S.P.500" 行 (column) 索引值
```
which(names(categories)  %in% "S.P.500")
```
> [!NOTE]
> 文檔內變數名稱符號可能會與程式碼內不同。譬如文檔內寫 "S&P 500"，程式碼內不能有 "&" 符號，所以登記名稱為 "S.P.500"。大家要注意這點。


> [!NOTE]
> 建議每組輪調一位成員負責理解與調閱資料細節。包含使用視覺圖表觀察資料有無怪異表現與線上查找 1999~2024 內重大經濟事件等等。好的觀察能減少白工。

 


# knn_fittedloss.R & validation.R

介紹一個初步評估統計方法的好工具


# pca_regression.R
實作一個可以利用 factor model assumption 的統計模型

# HOUST.R

FRED-MD 資料檢查 / 準備 AR(2) 的 covariance matrix / 估一個 pca AR(2) 模型 pca.ar.model

# additional_material
一些補充資訊。

> [!NOTE]
> 在 Instruction.md 內，需要做的工作會以 [!IMPORTANT] 方式提醒。

> [!WARNING]
> 程式碼未經完整測試。本次實作允許所有人出包。

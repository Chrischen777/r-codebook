# R Codebook · STAT 2102

用于复习 R 的交互式代码手册。Base R 保留 147 个可复制示例、实际运行输出、17 页图形，以及 5 道附有折叠解析的收藏题。独立的 Tidyverse 模块新增 71 个知识点、113 个实际运行示例和 63 页图形。

## 使用

打开网站后可搜索中文题型或 R 函数。收藏页显示原题和中文题意，点击「查看解析」展开思路、代码与结果。收藏保存在当前浏览器中，不会跨设备同步。

顶部可在 **Base R / Tidyverse** 之间切换。两个页面分别是 `index.html`、`tidyverse.html`，各自内嵌样式、脚本和输出图像，无需安装依赖或运行构建。下载后也可离线打开。两模块使用独立的收藏存储键。

Tidyverse 覆盖 Lecture 10–14 的 dplyr、tidyr 和 ggplot2，包含模块搜索、章节导航、Quick Reference、10组易混淆函数对比和9类考试模板。课堂案例、补充案例、课外扩展都有标签。

在 RStudio 运行航班案例前，下载 `data/nyc_flights.csv.gz`，保持这个相对路径并把工作目录设为网站文件夹。R 可直接读取 gzip CSV，不必解压。`tidyverse-examples.R` 提供全部113个独立示例；首次使用先安装 tidyverse。网页浏览本身不需要 R 或 CSV。

## GitHub Pages 设置

在仓库 Settings → Pages 中选择 **Deploy from a branch**，发布分支选择 `main`，目录选择 `/(root)`，保存即可。

更新时保留两个 HTML、`tidyverse-examples.R`、`TIDYVERSE-NOTES.md` 和 `data/nyc_flights.csv.gz` 的相对位置，GitHub Pages 会重新发布。`.nojekyll` 用于直接发布静态文件。

- Base R: https://chrischen777.github.io/r-codebook/
- Tidyverse: https://chrischen777.github.io/r-codebook/tidyverse.html

## 数据与来源

课程和题目来源在网页的「资料范围与验证说明」中列出。原始课件、Word 文档和调查数据不随网站上传。员工调查及 Carseats 示例使用明确标注的演示数据，不能代替原始数据的数值答案。输出使用 WebR / R 4.6.0 预先生成，网页本身不执行 R。

Tidyverse 航班案例使用本次上传的完整 CSV（336,776行、19列），压缩后数据内容不变。Lecture 12 使用 tidyr 包内 table1–5、relig_income、who、billboard；Lecture 13 使用 ggplot2::mpg。版本与完整覆盖记录见 `TIDYVERSE-NOTES.md`。

Lecture 14 使用 `data/lung_capacity.txt`（725行、6列）。该原始数据不公开上传；运行相关代码时，请将自己课程资料中的文件放入同一RStudio项目的data目录。网页中的讲解、输出和图形可直接查看。边缘图与多图拼接另需 `ggExtra` 和 `patchwork` 包。Lecture14新增20个实际运行案例与41页图形。

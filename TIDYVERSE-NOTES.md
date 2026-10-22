# Tidyverse 模块 · 覆盖与验证记录

更新：2026-10-21。现有 GitHub Pages 项目中增加独立页面；Base R 只追加模块切换导航及其样式，不改写原内容。

## 文件

- 修改 `index.html`：新增 Base R / Tidyverse 入口。
- 修改 `README.md`：两个模块、下载和部署说明。
- 新增 `tidyverse.html`：独立静态页面，内嵌 CSS、JavaScript、代码、实际输出和图像。
- 新增 `data/nyc_flights.csv.gz`：用户上传 CSV 的无损 gzip 压缩，33,743,073 → 8,383,544 bytes。
- 新增 `tidyverse-examples.R`：全部113个完整案例。
- 新增 `data/lung_capacity.txt`：Lecture14所需课堂数据，725行6列，来自本地已有文件。
- 新增本说明文件；本地 `tools/` 中保存内容源、生成器与验证材料，网页不依赖它们。

## 目录与讲义覆盖

1. 入门、安装、tibble、真实 CSV 结构
2. filter、逻辑条件、slice、slice_head、slice_tail、slice_sample、arrange、desc
3. select、starts_with、ends_with、contains、matches、everything、last_col、rename、relocate、mutate、transmute
4. %>% 管道、嵌套等价、多步中间结果、先slice还是先arrange
5. group_by、ungroup、summarise/summarize、n、n_distinct、first/last/nth、any/all、统计量、across、where、函数列表与.names
6. inner/left/right/full joins；同名、复合、异名键、keep、重复键膨胀；semi/anti joins；intersect/union/setdiff
7. tidy data；table1–4b布局；pivot_longer、pivot_wider、双表拉长后连接
8. separate（分隔符、正负位置、convert）、unite；complete、fill上下方向、replace_na、drop_na；隐式与显式缺失
9. relig_income、WHO、Billboard全流程；str_replace、values_drop_na、names_prefix、names_transform
10. ggplot、aes、geom_point、固定与映射、color/shape/size/alpha、scale_colour_manual、labs、xlim/ylim、coord_cartesian、scale_x/y_continuous、七种theme、theme/element_text、facet_wrap/grid
11. Lecture14：geom_bar/geom_text、after_stat、scale_x_discrete、scale_fill_manual、position_stack/dodge/fill、geom_hline/coord_flip、geom_boxplot/dotplot/stat_summary、ggExtra::ggMarginal、geom_histogram/density/vline、patchwork与plot_layout
12. 十组 Common Confusions，同一份学生数据的代码与输出对照
13. 九类 Exam Templates，覆盖条件变量、多条件筛选选列排序、组均值中位数计数、组内top-k、员工表连接、宽长转换后统计、数据管道接分面图

Quick Reference 提供 Function / What it does / Basic syntax / Common exam use 四列索引。

来源：
- https://ap4347.github.io/2102/lecture-10.html
- https://ap4347.github.io/2102/lecture-11.html
- https://ap4347.github.io/2102/lecture-12.html
- https://ap4347.github.io/2102/lecture-13.html
- https://ap4347.github.io/2102/lecture-14.html

按讲义顺序迁移主要内容；按新增Lecture14补齐柱状图、箱线图、直方图和多图拼接；未将未讲的forcats或purrr函数声称为课堂教学。

## 数据字段

真实 CSV 的全部19列均在导入检查中验证：

year, month, day, dep_time, sched_dep_time, dep_delay, arr_time, sched_arr_time, arr_delay, carrier, flight, tailnum, origin, dest, air_time, distance, hour, minute, time_hour。

read.csv + as_tibble 路径下，carrier/tailnum/origin/dest/time_hour为character，其余为integer。读入后没有伪造字段。

筛选、排序和统计主要使用 month/day、dep_delay/arr_delay、origin/carrier、distance/air_time；选择助手也演示 sched_dep_time/sched_arr_time 等。time_hour 仍为字符；HHMM时间不能直接相减当持续分钟。

缺失值：dep_time=8255，dep_delay=8255，arr_time=8713，arr_delay=9430，air_time=9430，tailnum=2512，其余列0。统计用完整文件；页面表格通常预览前8行，并标明全表尺寸。

## 示例来源与新增教学

共71张知识点卡、113个完整代码示例。每例标明来源：

- **Lecture Example**：讲义数据与操作，调整相对路径、打印范围或随机seed时有说明。
- **Additional Example**：学生成绩/学时、门店月销售、唯一键学生课程连接、按门店填充、选择列集合、真实航班抽样散点图、员工工资对照解法、综合考试模板等。
- **Advanced / Extension**：if_else/case_when、count、geom_col。原生 `|>` 仅在解释中作R4.1+的扩展提示，主代码使用课堂 `%>%`。

全部完整案例包含所需包加载和数据准备。语法结构框是占位语法，不标作可独立运行案例。每个R代码框都有独立复制按钮。

## 实际 R 验证

运行环境：WebR 0.6.0 / R 4.6.0；dplyr 1.2.1、tibble 3.3.1、tidyr 1.3.2、ggplot2 4.0.3、stringr 1.6.0、ggExtra 0.11.0、patchwork 1.3.2。

课件展示 dplyr 1.1.4、tidyr 1.3.1、ggplot2 3.5.1。沿用兼容课堂写法，不声称使用完全相同版本；控制台列宽与警告文字可能不同。

113个示例逐个在新环境中执行并捕获控制台、表格、警告和PDF图形；以代码SHA256绑定输出。图形共63页，由实际R绘图转成PNG并内嵌网页。

21项独立语义断言验证真实CSV尺寸/缺失/元旦842条/11–12月55,403条/最大延误1301/35个机场×航司组，另核对Lung Capacity的725行6列、无缺失、413条HEALTHY、367条MALE；以及重复键join、semi/anti不膨胀、分组mutate与summarise的行数、宽长转换、mpg行数。

预期警告明确保留：四种连接的多对多关系；七类shape超出默认六种形状，删除62行；离散alpha建议；xlim/ylim删除170条范围外记录。Lecture14离散轴仅保留两类时排除269行的警告也明确解释。所有113个完整案例均无执行错误。

## Base R 保留

通过生成前后逐字比较，去除唯一新增的导航和专属样式后，`index.html` 与原版完全相同：147条内容、代码JSON、搜索脚本、原收藏存储键、五题原文与按键展开解析均未改写。

Tidyverse 使用独立 `r-codebook-tidyverse-saved-v1`，不读取或覆盖原收藏。

## 网页测试

185个复制按钮均经实际UI点击，再Ctrl+V到验证文本框，逐字比对通过（textarea规范化CRLF为LF，代码内容、缩进与运算符保持一致）。另运行740项处理路径测试，覆盖Clipboard API成功、拒绝后fallback、非安全上下文fallback、完全失败时不显示Copied。

中文/英文搜索、无匹配提示、Lecture10–14筛选、考试筛选、收藏刷新持久化、全部内部锚点和相对链接、Base R/Tidyverse来回切换、原五题按键展开均通过。检查了窄屏移动导航与横向溢出，无JS错误。

限制：浏览器安全策略禁止file://协议，未实测直接双击HTML；已检查两页无外部运行依赖、图像内嵌和相对路径齐全。HTTP预览和实际复制已验证，手机布局在工具提供的实际窄视口核验。发布状态以最终交付中的已验证URL为准。

## Lecture14 数据与兼容性

六列为LungCap、Age、Height、Smoke、Sex、Status；没有缺失。Status为HEALTHY=413、STAGE_1=190、STAGE_2=79、STAGE_3=43。新增15张卡、20个案例、41页图形。`..count..`/`..density..`改写为`after_stat(count)`/`after_stat(density)`，线条`size`改为`linewidth`；纠正hjust水平方向、vjust垂直方向；说明alpha不自动把堆叠直方图变成重叠图。课件旧写法仍在解释中说明。

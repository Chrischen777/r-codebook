# STAT 2102 — Tidyverse Lecture 10–14
# Each numbered example is independent. External data: data/nyc_flights.csv.gz and data/lung_capacity.txt.
# The raw lung_capacity.txt is not published; use your own course copy.
# Install tidyverse once before running. See the website for logic and outputs.


# ==================== intro-1: 创建并检查 tibble ====================
# Additional Example
library(dplyr)
before <- data.frame(name=c("Amy","Ben"), score=c(85,62))
result <- tibble::as_tibble(before)
print(result)
print(class(result))
str(result)


# ==================== csv-1: 真实 CSV · 行列数、字段和缺失 ====================
# Lecture Example
library(dplyr)
# 工作目录设为下载的网站文件夹；data 内放压缩 CSV，无需解压。
flights <- tibble::as_tibble(read.csv("data/nyc_flights.csv.gz",
                                     stringsAsFactors = FALSE))
before <- slice_head(flights, n=6)
result <- tibble(field=names(flights),
                 type=vapply(flights, function(x) class(x)[1], character(1)),
                 missing=vapply(flights, function(x) sum(is.na(x)), integer(1)))
print(dim(flights))
print(result, n=19)


# ==================== filter-1: 基础 · 同时满足与缺失保留 ====================
# Additional Example
library(dplyr)
before <- tibble(
  name = c("Amy", "Ben", "Cai", "Dan", "Eve"),
  team = c("A", "B", "A", "B", "A"),
  score = c(85, 62, 92, NA, 70), hours = c(5, 2, 6, 4, 3)
)
result <- before %>% filter(score >= 70 & hours <= 5)
print(result)


# ==================== filter-2: 课堂 · 元旦、11月或12月 ====================
# Lecture Example
library(dplyr)
# 工作目录设为下载的网站文件夹；data 内放压缩 CSV，无需解压。
flights <- tibble::as_tibble(read.csv("data/nyc_flights.csv.gz",
                                     stringsAsFactors = FALSE))
before <- slice_head(flights, n=6)
jan1 <- filter(flights, month == 1, day == 1)
late_year <- filter(flights, month == 11 | month == 12)
stopifnot(identical(late_year, filter(flights, month %in% c(11,12))))
result <- tibble(sample=c("January 1", "Nov or Dec"), rows=c(nrow(jan1),nrow(late_year)))
print(result)


# ==================== filter-3: 补充 · 保留缺考记录 ====================
# Additional Example
library(dplyr)
before <- tibble(
  name = c("Amy", "Ben", "Cai", "Dan", "Eve"),
  team = c("A", "B", "A", "B", "A"),
  score = c(85, 62, 92, NA, 70), hours = c(5, 2, 6, 4, 3)
)
result <- before %>% filter(score >= 85 | is.na(score))
print(result)


# ==================== slice-1: 基础 · 位置、删除与首尾 ====================
# Additional Example
library(dplyr)
before <- tibble(
  name = c("Amy", "Ben", "Cai", "Dan", "Eve"),
  team = c("A", "B", "A", "B", "A"),
  score = c(85, 62, 92, NA, 70), hours = c(5, 2, 6, 4, 3)
)
result <- slice(before, c(2,2,5))
print(result)
print(slice(before, -(1:2)))
print(slice_head(before,n=2))
print(slice_tail(before,n=2))


# ==================== slice-2: 课堂 · 航班第5至10行 ====================
# Lecture Example
library(dplyr)
# 工作目录设为下载的网站文件夹；data 内放压缩 CSV，无需解压。
flights <- tibble::as_tibble(read.csv("data/nyc_flights.csv.gz",
                                     stringsAsFactors = FALSE))
before <- slice_head(flights,n=10)
result <- slice(flights,5:10)
print(select(result,year:day,dep_time,dep_delay))
print(nrow(slice(flights,-(1:4))))
print(select(slice_tail(flights,n=3),year:day,dep_time))


# ==================== sample-1: 基础 · 固定随机种子 ====================
# Additional Example
library(dplyr)
before <- tibble(
  name = c("Amy", "Ben", "Cai", "Dan", "Eve"),
  team = c("A", "B", "A", "B", "A"),
  score = c(85, 62, 92, NA, 70), hours = c(5, 2, 6, 4, 3)
)
set.seed(2102)
result <- slice_sample(before,n=3)
print(result)
set.seed(2102)
print(slice_sample(before,prop=0.5))
print(slice_sample(before,n=8,replace=TRUE))


# ==================== sample-2: 课堂 · 10条与0.1%的航班 ====================
# Lecture Example
library(dplyr)
# 工作目录设为下载的网站文件夹；data 内放压缩 CSV，无需解压。
flights <- tibble::as_tibble(read.csv("data/nyc_flights.csv.gz",
                                     stringsAsFactors = FALSE))
before <- slice_head(flights,n=6)
set.seed(2102)
result <- slice_sample(flights,n=10)
print(select(result,month,day,dep_time,carrier))
print(nrow(slice_sample(flights,prop=0.001)))


# ==================== arrange-1: 基础 · 分组字母升序、分数降序 ====================
# Additional Example
library(dplyr)
before <- tibble(
  name = c("Amy", "Ben", "Cai", "Dan", "Eve"),
  team = c("A", "B", "A", "B", "A"),
  score = c(85, 62, 92, NA, 70), hours = c(5, 2, 6, 4, 3)
)
result <- before %>% arrange(team,desc(score))
print(result)


# ==================== arrange-2: 课堂 · 出发延误最严重的航班 ====================
# Lecture Example
library(dplyr)
# 工作目录设为下载的网站文件夹；data 内放压缩 CSV，无需解压。
flights <- tibble::as_tibble(read.csv("data/nyc_flights.csv.gz",
                                     stringsAsFactors = FALSE))
before <- select(slice_head(flights,n=5),month,day,dep_delay)
result <- flights %>% arrange(desc(dep_delay)) %>% select(year:day,dep_time,dep_delay) %>% slice_head(n=5)
print(result)
print(select(slice_head(arrange(flights,year,month,day),n=3),year:day))


# ==================== select-1: 基础 · 只看姓名和成绩 ====================
# Additional Example
library(dplyr)
before <- tibble(
  name = c("Amy", "Ben", "Cai", "Dan", "Eve"),
  team = c("A", "B", "A", "B", "A"),
  score = c(85, 62, 92, NA, 70), hours = c(5, 2, 6, 4, 3)
)
result <- select(before,name,score)
print(result)


# ==================== select-2: 课堂 · 五种选择方式 ====================
# Lecture Example
library(dplyr)
# 工作目录设为下载的网站文件夹；data 内放压缩 CSV，无需解压。
flights <- tibble::as_tibble(read.csv("data/nyc_flights.csv.gz",
                                     stringsAsFactors = FALSE))
before <- slice_head(flights,n=3)
result <- select(before,year:day)
print(result)
print(names(select(flights,-(year:day))))
print(names(select(flights,!(year:day))))
print(select(before,c(1,5,8)))


# ==================== helpers-1: 课堂 · 前缀、后缀、包含与交集 ====================
# Lecture Example
library(dplyr)
# 工作目录设为下载的网站文件夹；data 内放压缩 CSV，无需解压。
flights <- tibble::as_tibble(read.csv("data/nyc_flights.csv.gz",
                                     stringsAsFactors = FALSE))
before <- slice_head(flights,n=3)
result <- select(before,starts_with("sched") & ends_with("time"))
print(result)
print(names(select(flights,ends_with("time"))))
print(names(select(flights,contains("ar"))))
print(names(select(flights,matches("^(dep|arr)_delay$"))))
print(names(select(flights,carrier,everything())))


# ==================== helpers-2: 补充 · 学期列名的交并集 ====================
# Additional Example
library(dplyr)
before <- tibble(id=1:2,math_mid=c(70,80),math_final=c(85,90),english_final=c(88,75))
result <- before %>% select(starts_with("math") | ends_with("final"))
print(result)
print(before %>% select(starts_with("math") & ends_with("final")))


# ==================== rename-1: 基础 · 改名并移到姓名后 ====================
# Additional Example
library(dplyr)
before <- tibble(
  name = c("Amy", "Ben", "Cai", "Dan", "Eve"),
  team = c("A", "B", "A", "B", "A"),
  score = c(85, 62, 92, NA, 70), hours = c(5, 2, 6, 4, 3)
)
result <- before %>% rename(Score=score) %>% relocate(Score,.after=name)
print(result)


# ==================== rename-2: 课堂 · .before / .after / last_col / everything ====================
# Lecture Example
library(dplyr)
# 工作目录设为下载的网站文件夹；data 内放压缩 CSV，无需解压。
flights <- tibble::as_tibble(read.csv("data/nyc_flights.csv.gz",
                                     stringsAsFactors = FALSE))
before <- slice_head(select(flights,year:dep_delay),n=3)
result <- before %>% rename(YEAR=year,MONTH=month)
print(result)
print(names(relocate(flights,year,.after=month)))
print(names(relocate(flights,c(year,month),.before=dep_delay)))
print(names(relocate(flights,c(year,month),.after=last_col())))
print(names(relocate(flights,dep_delay,.before=everything())))


# ==================== mutate-1: 基础 · 学生每小时得分 ====================
# Additional Example
library(dplyr)
before <- tibble(
  name = c("Amy", "Ben", "Cai", "Dan", "Eve"),
  team = c("A", "B", "A", "B", "A"),
  score = c(85, 62, 92, NA, 70), hours = c(5, 2, 6, 4, 3)
)
result <- before %>% mutate(per_hour=score/hours, adjusted=score+5)
print(result)


# ==================== mutate-2: 课堂 · gain、speed 与连续新变量 ====================
# Lecture Example
library(dplyr)
# 工作目录设为下载的网站文件夹；data 内放压缩 CSV，无需解压。
flights <- tibble::as_tibble(read.csv("data/nyc_flights.csv.gz",
                                     stringsAsFactors = FALSE))
before <- flights %>% select(month,ends_with("delay"),distance,air_time) %>% slice_head(n=6)
result <- before %>% mutate(gain=dep_delay-arr_delay,
                            speed=distance/air_time*60,
                            hours=air_time/60, gain_per_hour=gain/hours)
print(result,width=110)


# ==================== transmute-1: 课堂 · 只输出三个派生变量 ====================
# Lecture Example
library(dplyr)
# 工作目录设为下载的网站文件夹；data 内放压缩 CSV，无需解压。
flights <- tibble::as_tibble(read.csv("data/nyc_flights.csv.gz",
                                     stringsAsFactors = FALSE))
before <- flights %>% select(dep_delay,arr_delay,air_time) %>% slice_head(n=6)
result <- before %>% transmute(gain=dep_delay-arr_delay, hours=air_time/60, gain_per_hour=gain/hours)
print(result)


# ==================== transmute-2: 补充 · 只交付姓名与效率 ====================
# Additional Example
library(dplyr)
before <- tibble(
  name = c("Amy", "Ben", "Cai", "Dan", "Eve"),
  team = c("A", "B", "A", "B", "A"),
  score = c(85, 62, 92, NA, 70), hours = c(5, 2, 6, 4, 3)
)
result <- before %>% transmute(name,points_per_hour=score/hours)
print(result)


# ==================== pipe-1: 基础 · 每一步都看得见 ====================
# Additional Example
library(dplyr)
before <- tibble(
  name = c("Amy", "Ben", "Cai", "Dan", "Eve"),
  team = c("A", "B", "A", "B", "A"),
  score = c(85, 62, 92, NA, 70), hours = c(5, 2, 6, 4, 3)
)
step1 <- before %>% filter(score >= 70)
step2 <- step1 %>% select(name,score)
result <- step2 %>% arrange(desc(score))
print(step1)
print(step2)
print(result)


# ==================== pipe-2: 课堂 · 先取30行，再在这30行中排序 ====================
# Lecture Example
library(dplyr)
# 工作目录设为下载的网站文件夹；data 内放压缩 CSV，无需解压。
flights <- tibble::as_tibble(read.csv("data/nyc_flights.csv.gz",
                                     stringsAsFactors = FALSE))
before <- slice_head(flights,n=6)
step1 <- flights %>% filter(month %in% c(10,11,12), arr_delay < 10)
step2 <- step1 %>% slice(1:30)
step3 <- step2 %>% arrange(desc(arr_delay))
result <- step3 %>% select(-c(1,4))
print(c(filtered=nrow(step1), selected=nrow(step2), columns=ncol(result)))
print(select(result,month,day,arr_delay,carrier),n=10)


# ==================== pipe-3: 课堂 · 管道与嵌套等价 ====================
# Lecture Example
library(dplyr)
# 工作目录设为下载的网站文件夹；data 内放压缩 CSV，无需解压。
flights <- tibble::as_tibble(read.csv("data/nyc_flights.csv.gz",
                                     stringsAsFactors = FALSE))
before <- slice_head(flights,n=6)
result <- flights %>% filter(month==11 | month==12) %>%
  select(starts_with("sched") & ends_with("time"))
nested <- select(filter(flights,month==11 | month==12),
                 starts_with("sched") & ends_with("time"))
print(identical(result,nested))
print(head(result,3))


# ==================== group-1: 基础 · 组内平均仍保留每个学生 ====================
# Additional Example
library(dplyr)
before <- tibble(
  name = c("Amy", "Ben", "Cai", "Dan", "Eve"),
  team = c("A", "B", "A", "B", "A"),
  score = c(85, 62, 92, NA, 70), hours = c(5, 2, 6, 4, 3)
)
step1 <- before %>% group_by(team)
result <- step1 %>% mutate(team_mean=mean(score,na.rm=TRUE)) %>% ungroup()
print(group_vars(step1))
print(result)
print(group_vars(result))


# ==================== group-2: 课堂 · 单键、多键和取消分组 ====================
# Lecture Example
library(dplyr)
# 工作目录设为下载的网站文件夹；data 内放压缩 CSV，无需解压。
flights <- tibble::as_tibble(read.csv("data/nyc_flights.csv.gz",
                                     stringsAsFactors = FALSE))
before <- slice_head(flights,n=6)
by_origin <- flights %>% group_by(origin)
by_origin_carrier <- flights %>% group_by(origin,carrier)
print(c(origin_groups=n_groups(by_origin), origin_carrier_groups=n_groups(by_origin_carrier)))
result <- by_origin_carrier %>% ungroup() %>% summarise(flights=n())
print(result)


# ==================== summary-1: 基础 · 均值、中位数、总数和有效数 ====================
# Additional Example
library(dplyr)
before <- tibble(
  name = c("Amy", "Ben", "Cai", "Dan", "Eve"),
  team = c("A", "B", "A", "B", "A"),
  score = c(85, 62, 92, NA, 70), hours = c(5, 2, 6, 4, 3)
)
result <- before %>% group_by(team) %>%
  summarise(mean=mean(score,na.rm=TRUE), median=median(score,na.rm=TRUE),
            n=n(), valid=sum(!is.na(score)), .groups="drop")
print(result)


# ==================== summary-2: 课堂 · 每个机场的到达延误 ====================
# Lecture Example
library(dplyr)
# 工作目录设为下载的网站文件夹；data 内放压缩 CSV，无需解压。
flights <- tibble::as_tibble(read.csv("data/nyc_flights.csv.gz",
                                     stringsAsFactors = FALSE))
before <- slice_head(flights,n=6)
result <- flights %>% group_by(origin) %>%
  summarise(Mean=mean(arr_delay,na.rm=TRUE), Median=median(arr_delay,na.rm=TRUE),
            Count=n(), Valid=sum(!is.na(arr_delay)), .groups="drop")
print(result)


# ==================== summary-3: 课堂 · 汇总后再筛选、排序 ====================
# Lecture Example
library(dplyr)
# 工作目录设为下载的网站文件夹；data 内放压缩 CSV，无需解压。
flights <- tibble::as_tibble(read.csv("data/nyc_flights.csv.gz",
                                     stringsAsFactors = FALSE))
before <- slice_head(flights,n=6)
result <- flights %>% group_by(carrier) %>%
  summarise(Count=n(), Distance_sd=sd(distance), .groups="drop") %>%
  filter(Count < 10000) %>% arrange(desc(Distance_sd))
print(result)


# ==================== stats-1: 基础 · 统计量与逻辑条件 ====================
# Additional Example
library(dplyr)
before <- tibble(
  name = c("Amy", "Ben", "Cai", "Dan", "Eve"),
  team = c("A", "B", "A", "B", "A"),
  score = c(85, 62, 92, NA, 70), hours = c(5, 2, 6, 4, 3)
)
result <- before %>% group_by(team) %>% summarise(
  first_name=first(name), last_name=last(name), second=nth(name,2),
  distinct=n_distinct(score,na.rm=TRUE), sd=sd(score,na.rm=TRUE),
  IQR=IQR(score,na.rm=TRUE), variance=var(score,na.rm=TRUE),
  minimum=min(score,na.rm=TRUE), maximum=max(score,na.rm=TRUE),
  q75=quantile(score,0.75,na.rm=TRUE),
  any_high=any(score>=90,na.rm=TRUE), all_pass=all(score>=60,na.rm=TRUE),
  .groups="drop")
print(result)


# ==================== across-1: 基础 · 两列同时求均值 ====================
# Additional Example
library(dplyr)
before <- tibble(
  name = c("Amy", "Ben", "Cai", "Dan", "Eve"),
  team = c("A", "B", "A", "B", "A"),
  score = c(85, 62, 92, NA, 70), hours = c(5, 2, 6, 4, 3)
)
result <- before %>% group_by(team) %>%
  summarise(across(c(score,hours), ~mean(.x,na.rm=TRUE)), .groups="drop")
print(result)


# ==================== across-2: 课堂 · 机场×公司、多列均值 ====================
# Lecture Example
library(dplyr)
# 工作目录设为下载的网站文件夹；data 内放压缩 CSV，无需解压。
flights <- tibble::as_tibble(read.csv("data/nyc_flights.csv.gz",
                                     stringsAsFactors = FALSE))
before <- slice_head(flights,n=6)
result <- flights %>% group_by(origin,carrier) %>%
  summarise(across(c(dep_delay,arr_delay,air_time),~mean(.x,na.rm=TRUE)), .groups="drop")
print(result,n=10)
print(flights %>% summarise(across(where(is.factor),n_distinct)))


# ==================== across-3: 课堂 · 数值列 min/max 与命名 ====================
# Lecture Example
library(dplyr)
# 工作目录设为下载的网站文件夹；data 内放压缩 CSV，无需解压。
flights <- tibble::as_tibble(read.csv("data/nyc_flights.csv.gz",
                                     stringsAsFactors = FALSE))
before <- slice_head(flights,n=6)
min_max <- list(min=~min(.x,na.rm=TRUE), max=~max(.x,na.rm=TRUE))
result <- flights %>% group_by(origin) %>%
  summarise(across(where(is.numeric),min_max,.names="{.fn}.{.col}"), .groups="drop")
print(result,width=100)
print(names(result))


# ==================== across-4: 补充 · 数值列统一计算 ====================
# Additional Example
library(dplyr)
before <- tibble(
  name = c("Amy", "Ben", "Cai", "Dan", "Eve"),
  team = c("A", "B", "A", "B", "A"),
  score = c(85, 62, 92, NA, 70), hours = c(5, 2, 6, 4, 3)
)
result <- before %>% summarise(across(where(is.numeric), ~mean(.x,na.rm=TRUE)))
print(result)


# ==================== inner_join-1: 课堂 · 重复键 a 与复合键 a+b ====================
# Lecture Example
library(dplyr)
before <- data.frame(a = c(1, 2, 3, 2, 4),
                     b = c(10, 20, 30, 35, 40),
                     c = c(100, 200, 300, 350, 400))
lookup <- data.frame(a = c(1, 2, 5, 4, 6, 2),
                     b = c(10, 40, 50, 40, 60, 50),
                     x = c(15, 25, 35, 45, 55, 65),
                     z = c(150, 200, 350, 400, 550, 270))
result <- inner_join(before,lookup,by="a")
print(result)
print(inner_join(before,lookup,by=c("a","b")))


# ==================== inner_join-2: 课堂 · 异名键与 keep ====================
# Lecture Example
library(dplyr)
before <- data.frame(a = c(1, 2, 3, 2, 4),
                     b = c(10, 20, 30, 35, 40),
                     c = c(100, 200, 300, 350, 400))
lookup <- data.frame(a = c(1, 2, 5, 4, 6, 2),
                     b = c(10, 40, 50, 40, 60, 50),
                     x = c(15, 25, 35, 45, 55, 65),
                     z = c(150, 200, 350, 400, 550, 270))
result <- inner_join(before,lookup,by=c("c"="z"),keep=TRUE)
print(result)


# ==================== inner_join-3: 补充 · 学生与报名记录 ====================
# Additional Example
library(dplyr)
before <- tibble(id=c(1,2,3),name=c("Amy","Ben","Cai"))
lookup <- tibble(id=c(2,3,4),course=c("R","Stats","R"))
result <- inner_join(before,lookup,by="id")
print(result)


# ==================== left_join-1: 课堂 · 重复键 a 与复合键 a+b ====================
# Lecture Example
library(dplyr)
before <- data.frame(a = c(1, 2, 3, 2, 4),
                     b = c(10, 20, 30, 35, 40),
                     c = c(100, 200, 300, 350, 400))
lookup <- data.frame(a = c(1, 2, 5, 4, 6, 2),
                     b = c(10, 40, 50, 40, 60, 50),
                     x = c(15, 25, 35, 45, 55, 65),
                     z = c(150, 200, 350, 400, 550, 270))
result <- left_join(before,lookup,by="a")
print(result)
print(left_join(before,lookup,by=c("a","b")))


# ==================== left_join-2: 课堂 · 异名键与 keep ====================
# Lecture Example
library(dplyr)
before <- data.frame(a = c(1, 2, 3, 2, 4),
                     b = c(10, 20, 30, 35, 40),
                     c = c(100, 200, 300, 350, 400))
lookup <- data.frame(a = c(1, 2, 5, 4, 6, 2),
                     b = c(10, 40, 50, 40, 60, 50),
                     x = c(15, 25, 35, 45, 55, 65),
                     z = c(150, 200, 350, 400, 550, 270))
result <- left_join(before,lookup,by=c("c"="z"),keep=TRUE)
print(result)


# ==================== left_join-3: 补充 · 学生与报名记录 ====================
# Additional Example
library(dplyr)
before <- tibble(id=c(1,2,3),name=c("Amy","Ben","Cai"))
lookup <- tibble(id=c(2,3,4),course=c("R","Stats","R"))
result <- left_join(before,lookup,by="id")
print(result)


# ==================== right_join-1: 课堂 · 重复键 a 与复合键 a+b ====================
# Lecture Example
library(dplyr)
before <- data.frame(a = c(1, 2, 3, 2, 4),
                     b = c(10, 20, 30, 35, 40),
                     c = c(100, 200, 300, 350, 400))
lookup <- data.frame(a = c(1, 2, 5, 4, 6, 2),
                     b = c(10, 40, 50, 40, 60, 50),
                     x = c(15, 25, 35, 45, 55, 65),
                     z = c(150, 200, 350, 400, 550, 270))
result <- right_join(before,lookup,by="a")
print(result)
print(right_join(before,lookup,by=c("a","b")))


# ==================== right_join-2: 课堂 · 异名键与 keep ====================
# Lecture Example
library(dplyr)
before <- data.frame(a = c(1, 2, 3, 2, 4),
                     b = c(10, 20, 30, 35, 40),
                     c = c(100, 200, 300, 350, 400))
lookup <- data.frame(a = c(1, 2, 5, 4, 6, 2),
                     b = c(10, 40, 50, 40, 60, 50),
                     x = c(15, 25, 35, 45, 55, 65),
                     z = c(150, 200, 350, 400, 550, 270))
result <- right_join(before,lookup,by=c("c"="z"),keep=TRUE)
print(result)


# ==================== right_join-3: 补充 · 学生与报名记录 ====================
# Additional Example
library(dplyr)
before <- tibble(id=c(1,2,3),name=c("Amy","Ben","Cai"))
lookup <- tibble(id=c(2,3,4),course=c("R","Stats","R"))
result <- right_join(before,lookup,by="id")
print(result)


# ==================== full_join-1: 课堂 · 重复键 a 与复合键 a+b ====================
# Lecture Example
library(dplyr)
before <- data.frame(a = c(1, 2, 3, 2, 4),
                     b = c(10, 20, 30, 35, 40),
                     c = c(100, 200, 300, 350, 400))
lookup <- data.frame(a = c(1, 2, 5, 4, 6, 2),
                     b = c(10, 40, 50, 40, 60, 50),
                     x = c(15, 25, 35, 45, 55, 65),
                     z = c(150, 200, 350, 400, 550, 270))
result <- full_join(before,lookup,by="a")
print(result)
print(full_join(before,lookup,by=c("a","b")))


# ==================== full_join-2: 课堂 · 异名键与 keep ====================
# Lecture Example
library(dplyr)
before <- data.frame(a = c(1, 2, 3, 2, 4),
                     b = c(10, 20, 30, 35, 40),
                     c = c(100, 200, 300, 350, 400))
lookup <- data.frame(a = c(1, 2, 5, 4, 6, 2),
                     b = c(10, 40, 50, 40, 60, 50),
                     x = c(15, 25, 35, 45, 55, 65),
                     z = c(150, 200, 350, 400, 550, 270))
result <- full_join(before,lookup,by=c("c"="z"),keep=TRUE)
print(result)


# ==================== full_join-3: 补充 · 学生与报名记录 ====================
# Additional Example
library(dplyr)
before <- tibble(id=c(1,2,3),name=c("Amy","Ben","Cai"))
lookup <- tibble(id=c(2,3,4),course=c("R","Stats","R"))
result <- full_join(before,lookup,by="id")
print(result)


# ==================== filter-joins-1: 课堂 · 单键和复合键 ====================
# Lecture Example
library(dplyr)
before <- data.frame(a = c(1, 2, 3, 2, 4),
                     b = c(10, 20, 30, 35, 40),
                     c = c(100, 200, 300, 350, 400))
lookup <- data.frame(a = c(1, 2, 5, 4, 6, 2),
                     b = c(10, 40, 50, 40, 60, 50),
                     x = c(15, 25, 35, 45, 55, 65),
                     z = c(150, 200, 350, 400, 550, 270))
result <- semi_join(before,lookup,by="a")
print(result)
print(anti_join(before,lookup,by="a"))
print(semi_join(before,lookup,by=c("a","b")))
print(anti_join(before,lookup,by=c("a","b")))


# ==================== sets-1: 课堂 · 完整记录的交、并、差 ====================
# Lecture Example
library(dplyr)
before <- data.frame(a=1:5,b=c(10,20,30,40,50))
lookup <- data.frame(a=1:5,b=c(10,15,30,45,65))
result <- dplyr::intersect(before,lookup)
print(result)
print(dplyr::union(before,lookup))
print(dplyr::setdiff(before,lookup))
print(dplyr::setdiff(lookup,before))


# ==================== tidy-1: 课堂 · 同样事实的五种布局 ====================
# Lecture Example
library(dplyr)
library(tidyr)
before <- table4a
result <- table1
print(result)
print(table2)
print(table3)
print(table4a)
print(table4b)


# ==================== longer-1: 课堂 · cases 和 population 分别拉长再连接 ====================
# Lecture Example
library(dplyr)
library(tidyr)
before <- table4a
step1 <- table4a %>% pivot_longer(c(`1999`,`2000`),names_to="year",values_to="cases")
step2 <- table4b %>% pivot_longer(c(`1999`,`2000`),names_to="year",values_to="population")
result <- left_join(step1,step2,by=c("country","year"))
print(result)


# ==================== longer-2: 补充 · 门店月份销售 ====================
# Additional Example
library(dplyr)
library(tidyr)
before <- tibble(store=c("East","West"),Jan=c(10,20),Feb=c(14,NA))
result <- before %>% pivot_longer(-store,names_to="month",values_to="sales")
print(result)


# ==================== wider-1: 课堂 · type 和 count 展开 ====================
# Lecture Example
library(dplyr)
library(tidyr)
before <- table2
result <- before %>% pivot_wider(names_from=type,values_from=count)
print(result)


# ==================== wider-2: 补充 · 门店长表回到宽表 ====================
# Additional Example
library(dplyr)
library(tidyr)
before <- tibble(store=c("East","East","West","West"),month=c("Jan","Feb","Jan","Feb"),sales=c(10,14,20,NA))
result <- before %>% pivot_wider(names_from=month,values_from=sales)
print(result)


# ==================== separate-1: 课堂 · rate 拆成病例与人口 ====================
# Lecture Example
library(dplyr)
library(tidyr)
before <- table3
result <- before %>% separate(rate,into=c("cases","population"),sep="/",convert=TRUE)
print(result)
print(before %>% separate(year,into=c("century","year"),sep=2))
print(before %>% separate(year,into=c("century","year"),sep=3))
print(before %>% separate(year,into=c("century","year"),sep=-3))


# ==================== separate-2: 补充 · 拆开门店和部门代码 ====================
# Additional Example
library(dplyr)
library(tidyr)
before <- tibble(code=c("East_Sales","West_Support"),staff=c(5,8))
result <- before %>% separate(code,into=c("store","department"),sep="_")
print(result)


# ==================== unite-1: 课堂 · 世纪与年份拼接 ====================
# Lecture Example
library(dplyr)
library(tidyr)
before <- table5
result <- before %>% unite(new,century,year,sep="")
print(result)
print(before %>% unite(new,century,year))


# ==================== unite-2: 补充 · 保留原列再生成标签 ====================
# Additional Example
library(dplyr)
library(tidyr)
before <- tibble(store=c("East","West"),department=c("Sales","Support"))
result <- before %>% unite(label,store,department,sep=" / ",remove=FALSE)
print(result)


# ==================== complete-1: 课堂 · 补出2016年第1季度 ====================
# Lecture Example
library(dplyr)
library(tidyr)
before <- tibble(year = c(2015,2015,2015,2015,2016,2016,2016),
                 qtr = c(1,2,3,4,2,3,4),
                 return = c(1.88,0.59,0.35,NA,0.92,0.17,2.66))
result <- before %>% complete(year,qtr)
print(result)
print(before %>% pivot_wider(names_from=year,values_from=return))


# ==================== complete-2: 补充 · 明确要求每店都有三个⽉ ====================
# Additional Example
library(dplyr)
library(tidyr)
before <- tibble(store=c("East","East","West"),month=c(1,3,1),sales=c(10,18,20))
result <- before %>% complete(store,month=1:3)
print(result)


# ==================== fill-1: 课堂 · down 与 up ====================
# Lecture Example
library(dplyr)
library(tidyr)
before <- tibble(year = c(2015,2015,2015,2015,2016,2016,2016),
                 qtr = c(1,2,3,4,2,3,4),
                 return = c(1.88,0.59,0.35,NA,0.92,0.17,2.66))
step1 <- before %>% complete(year,qtr)
result <- step1 %>% fill(return)
print(result)
print(step1 %>% fill(return,.direction="up"))


# ==================== fill-2: 补充 · 不跨门店传播数值 ====================
# Additional Example
library(dplyr)
library(tidyr)
before <- tibble(store=c("East","East","West","West"),month=c(1,2,1,2),target=c(10,NA,NA,20))
result <- before %>% arrange(store,month) %>% group_by(store) %>% fill(target) %>% ungroup()
print(result)


# ==================== na-1: 课堂 · 常数替换与删除 ====================
# Lecture Example
library(dplyr)
library(tidyr)
before <- tibble(year = c(2015,2015,2015,2015,2016,2016,2016),
                 qtr = c(1,2,3,4,2,3,4),
                 return = c(1.88,0.59,0.35,NA,0.92,0.17,2.66))
step1 <- before %>% complete(year,qtr)
result <- step1 %>% replace_na(list(return=0))
print(result)
print(step1 %>% drop_na())


# ==================== na-2: 补充 · 只根据指定列删除缺失 ====================
# Additional Example
library(dplyr)
library(tidyr)
before <- tibble(id=1:3,score=c(85,NA,70),note=c(NA,"absent","ok"))
result <- before %>% drop_na(score)
print(result)
print(before %>% drop_na())


# ==================== religion-1: 课堂 · 宗教×收入频数表 ====================
# Lecture Example
library(dplyr)
library(tidyr)
before <- tidyr::relig_income
result <- before %>% pivot_longer(-religion,names_to="income",values_to="frequency")
print(dim(result))
print(result,n=12)


# ==================== who-1: 课堂 · WHO完整管道 ====================
# Lecture Example
library(dplyr)
library(tidyr)
before <- tidyr::who
step1 <- before %>% pivot_longer(new_sp_m014:newrel_f65,names_to="key",values_to="cases",values_drop_na=TRUE)
step2 <- step1 %>% mutate(key=stringr::str_replace(key,"newrel","new_rel"))
step3 <- step2 %>% separate(key,c("new","type","sexage"),sep="_")
result <- step3 %>% separate(sexage,c("sex","age"),sep=1)
print(dim(result))
print(result,n=6,width=110)


# ==================== billboard-1: 课堂 · 从宽周表到排序后的上榜记录 ====================
# Lecture Example
library(dplyr)
library(tidyr)
before <- tidyr::billboard
step1 <- before %>% pivot_longer(starts_with("wk"),names_to="week",values_to="rank",values_drop_na=TRUE)
step2 <- before %>% pivot_longer(starts_with("wk"),names_to="week",names_prefix="wk",names_transform=as.integer,values_to="rank",values_drop_na=TRUE)
result <- step2 %>% arrange(artist,track,week)
print(dim(result))
print(result,n=10)


# ==================== ggplot-1: 课堂 · 空画布与散点图 ====================
# Lecture Example
library(ggplot2)
before <- ggplot2::mpg
before$cyl <- as.factor(before$cyl)
print(ggplot(data=before))
p <- ggplot(data=before) + geom_point(aes(x=displ,y=hwy))
print(p)


# ==================== ggplot-2: 补充 · 真实航班距离与飞行时间 ====================
# Additional Example
library(dplyr)
# 工作目录设为下载的网站文件夹；data 内放压缩 CSV，无需解压。
flights <- tibble::as_tibble(read.csv("data/nyc_flights.csv.gz",
                                     stringsAsFactors = FALSE))
library(ggplot2)
set.seed(2102)
plot_data <- flights %>% filter(!is.na(air_time),air_time>0) %>% slice_sample(n=500)
p <- ggplot(plot_data,aes(distance,air_time,color=origin)) + geom_point(alpha=0.5) +
  theme_minimal() + labs(title="500 sampled NYC flights",x="Distance (miles)",y="Air time (minutes)",color="Origin")
print(p)


# ==================== aesthetics-1: 课堂 · 固定颜色、大小和形状 ====================
# Lecture Example
library(ggplot2)
before <- ggplot2::mpg
before$cyl <- as.factor(before$cyl)
p <- ggplot(before) + geom_point(aes(displ,hwy),color="steelblue",size=3,shape=24)
print(p)


# ==================== aesthetics-2: 课堂 · 类别颜色、shape 与 alpha ====================
# Lecture Example
library(ggplot2)
before <- ggplot2::mpg
before$cyl <- as.factor(before$cyl)
p <- ggplot(before) + geom_point(aes(displ,hwy,color=cyl,shape=class),size=3)
print(p)
p2 <- ggplot(before) + geom_point(aes(displ,hwy,alpha=cyl),size=3)
print(p2)


# ==================== aesthetics-3: 补充 · 只用3类驱动形式映射形状 ====================
# Additional Example
library(ggplot2)
before <- ggplot2::mpg
before$cyl <- as.factor(before$cyl)
p <- ggplot(before) + geom_point(aes(displ,hwy,color=cyl,shape=drv),size=2,alpha=0.7)
print(p)


# ==================== labs-1: 课堂 · 指定四色并完整标注 ====================
# Lecture Example
library(ggplot2)
before <- ggplot2::mpg
before$cyl <- as.factor(before$cyl)
p <- ggplot(before) + geom_point(aes(displ,hwy,color=cyl),size=3) +
  scale_colour_manual(values=c(`4`="red",`5`="blue",`6`="orange",`8`="yellow")) +
  labs(color="Number of Cylinders",title="Highway Miles per Gallon vs Engine Displacement",
       subtitle="From mpg dataset",x="Engine Displacement",y="Highway Miles per Gallon")
print(p)


# ==================== limits-1: 课堂 · 同一张图两种范围控制 ====================
# Lecture Example
library(ggplot2)
before <- ggplot2::mpg
before$cyl <- as.factor(before$cyl)
p <- ggplot(before) + geom_point(aes(displ,hwy,color=cyl),size=3)
print(p + xlim(c(0,4)) + ylim(c(0,25)))
print(p + coord_cartesian(xlim=c(0,4),ylim=c(0,25)))


# ==================== themes-1: 课堂 · 刻度与文字细节 ====================
# Lecture Example
library(ggplot2)
before <- ggplot2::mpg
before$cyl <- as.factor(before$cyl)
p <- ggplot(before) + geom_point(aes(displ,hwy,color=cyl),size=3) +
  labs(title="Fuel economy",x="Engine Displacement",y="Highway MPG",color="Cylinders") +
  scale_x_continuous(breaks=seq(0,8,0.5)) + scale_y_continuous(breaks=seq(15,50,10)) +
  theme_bw() + theme(plot.title=element_text(size=15,face="bold",color="red"),
    axis.text.x=element_text(size=10,angle=45),axis.text.y=element_text(size=10,angle=45),
    axis.title.x=element_text(size=12,color="blue"),axis.title.y=element_text(size=12,color="blue"),
    legend.position="top")
print(p)


# ==================== themes-2: 课堂 · 七种主题对照 ====================
# Lecture Example
library(ggplot2)
before <- ggplot2::mpg
before$cyl <- as.factor(before$cyl)
p <- ggplot(before,aes(displ,hwy)) + geom_point()
print(p + theme_bw() + labs(title="theme_bw"))
print(p + theme_classic() + labs(title="theme_classic"))
print(p + theme_dark() + labs(title="theme_dark"))
print(p + theme_light() + labs(title="theme_light"))
print(p + theme_linedraw() + labs(title="theme_linedraw"))
print(p + theme_minimal() + labs(title="theme_minimal"))
print(p + theme_void() + labs(title="theme_void"))


# ==================== facets-1: 课堂 · 单变量与双变量分面 ====================
# Lecture Example
library(ggplot2)
before <- ggplot2::mpg
before$cyl <- as.factor(before$cyl)
p <- ggplot(before) + geom_point(aes(displ,hwy))
print(p + facet_wrap(~class))
print(p + facet_wrap(~class,nrow=2))
print(p + facet_grid(drv~class))


# ==================== compare-select-filter-1: 同数据实验 · select() vs filter() ====================
# Additional Example
library(dplyr)
before <- tibble(
  name = c("Amy", "Ben", "Cai", "Dan", "Eve"),
  team = c("A", "B", "A", "B", "A"),
  score = c(85, 62, 92, NA, 70), hours = c(5, 2, 6, 4, 3)
)
a <- select(before,name,score)
result <- filter(before,score>=80)
print(a)
print(result)


# ==================== compare-slice-arrange-1: 同数据实验 · slice() vs arrange() ====================
# Additional Example
library(dplyr)
before <- tibble(
  name = c("Amy", "Ben", "Cai", "Dan", "Eve"),
  team = c("A", "B", "A", "B", "A"),
  score = c(85, 62, 92, NA, 70), hours = c(5, 2, 6, 4, 3)
)
a <- slice(before,1:2)
result <- arrange(before,desc(score))
print(a)
print(result)


# ==================== compare-mutate-summary-1: 同数据实验 · mutate() vs summarise() ====================
# Additional Example
library(dplyr)
before <- tibble(
  name = c("Amy", "Ben", "Cai", "Dan", "Eve"),
  team = c("A", "B", "A", "B", "A"),
  score = c(85, 62, 92, NA, 70), hours = c(5, 2, 6, 4, 3)
)
a <- mutate(before,avg=mean(score,na.rm=TRUE))
result <- summarise(before,avg=mean(score,na.rm=TRUE))
print(a)
print(result)


# ==================== compare-group-summary-1: 同数据实验 · group_by() vs summarise() ====================
# Additional Example
library(dplyr)
before <- tibble(
  name = c("Amy", "Ben", "Cai", "Dan", "Eve"),
  team = c("A", "B", "A", "B", "A"),
  score = c(85, 62, 92, NA, 70), hours = c(5, 2, 6, 4, 3)
)
a <- group_by(before,team)
result <- a %>% summarise(avg=mean(score,na.rm=TRUE),.groups="drop")
print(a)
print(result)


# ==================== compare-slice-sample-1: 同数据实验 · slice() vs slice_sample() ====================
# Additional Example
library(dplyr)
before <- tibble(
  name = c("Amy", "Ben", "Cai", "Dan", "Eve"),
  team = c("A", "B", "A", "B", "A"),
  score = c(85, 62, 92, NA, 70), hours = c(5, 2, 6, 4, 3)
)
set.seed(2102)
a <- slice(before,1:2)
result <- slice_sample(before,n=2)
print(a)
print(result)


# ==================== compare-desc-arrange-1: 同数据实验 · desc() vs arrange() ====================
# Additional Example
library(dplyr)
before <- tibble(
  name = c("Amy", "Ben", "Cai", "Dan", "Eve"),
  team = c("A", "B", "A", "B", "A"),
  score = c(85, 62, 92, NA, 70), hours = c(5, 2, 6, 4, 3)
)
print(desc(before$score))
result <- arrange(before,desc(score))
print(result)


# ==================== compare-n-nrow-1: 同数据实验 · n() vs nrow() ====================
# Additional Example
library(dplyr)
before <- tibble(
  name = c("Amy", "Ben", "Cai", "Dan", "Eve"),
  team = c("A", "B", "A", "B", "A"),
  score = c(85, 62, 92, NA, 70), hours = c(5, 2, 6, 4, 3)
)
result <- before %>% group_by(team) %>% summarise(group_n=n(),whole_n=nrow(before),.groups="drop")
print(result)


# ==================== compare-pipe-nested-1: 同数据实验 · %>% vs 嵌套 ====================
# Additional Example
library(dplyr)
before <- tibble(
  name = c("Amy", "Ben", "Cai", "Dan", "Eve"),
  team = c("A", "B", "A", "B", "A"),
  score = c(85, 62, 92, NA, 70), hours = c(5, 2, 6, 4, 3)
)
a <- before %>% filter(score>=70) %>% select(name,score)
result <- select(filter(before,score>=70),name,score)
print(identical(a,result))
print(result)


# ==================== compare-tibble-frame-1: 同数据实验 · tibble vs data.frame ====================
# Additional Example
library(dplyr)
before <- tibble(
  name = c("Amy", "Ben", "Cai", "Dan", "Eve"),
  team = c("A", "B", "A", "B", "A"),
  score = c(85, 62, 92, NA, 70), hours = c(5, 2, 6, 4, 3)
)
a <- as.data.frame(before)
print(class(a[,"score"]))
print(class(before[,"score"]))
print(class(before[["score"]]))
result <- before[,"score"]
print(result)


# ==================== conditional-1: 补充 · 分类边界与缺失 ====================
# Advanced / Extension
library(dplyr)
before <- tibble(
  name = c("Amy", "Ben", "Cai", "Dan", "Eve"),
  team = c("A", "B", "A", "B", "A"),
  score = c(85, 62, 92, NA, 70), hours = c(5, 2, 6, 4, 3)
)
result <- before %>% mutate(
  pass=if_else(score>=60,"Pass","Fail",missing="Unknown"),
  band=case_when(is.na(score)~"Missing", score>=85~"High",
                 score>=70~"Medium", .default="Low"))
print(result)


# ==================== exam-flights-1: 可改写模板 · 冬季航班 ====================
# Additional Example
library(dplyr)
# 工作目录设为下载的网站文件夹；data 内放压缩 CSV，无需解压。
flights <- tibble::as_tibble(read.csv("data/nyc_flights.csv.gz",
                                     stringsAsFactors = FALSE))
before <- slice_head(flights,n=6)
result <- flights %>% filter(month %in% c(12,1,2),dep_delay>=60,arr_delay<=30) %>%
  select(year,month,day,carrier,origin,dest,dep_delay,arr_delay) %>%
  arrange(desc(dep_delay),arr_delay)
print(nrow(result))
print(result,n=10)


# ==================== exam-group-1: 可改写模板 · 每个机场的延误统计 ====================
# Additional Example
library(dplyr)
# 工作目录设为下载的网站文件夹；data 内放压缩 CSV，无需解压。
flights <- tibble::as_tibble(read.csv("data/nyc_flights.csv.gz",
                                     stringsAsFactors = FALSE))
before <- slice_head(flights,n=6)
result <- flights %>% group_by(origin) %>%
  summarise(mean_delay=mean(arr_delay,na.rm=TRUE),median_delay=median(arr_delay,na.rm=TRUE),
            total=n(),valid=sum(!is.na(arr_delay)),.groups="drop") %>% arrange(desc(mean_delay))
print(result)


# ==================== exam-top-1: 补充 · 每队最高两人的平均学时 ====================
# Additional Example
library(dplyr)
before <- tibble(
  name = c("Amy", "Ben", "Cai", "Dan", "Eve"),
  team = c("A", "B", "A", "B", "A"),
  score = c(85, 62, 92, NA, 70), hours = c(5, 2, 6, 4, 3)
)
step1 <- before %>% filter(!is.na(score)) %>% group_by(team) %>%
  arrange(desc(score),.by_group=TRUE) %>% slice_head(n=2)
result <- step1 %>% summarise(selected=n(),mean_hours=mean(hours),.groups="drop")
print(step1)
print(result)


# ==================== exam-count-1: 补充 · 小组人数 ====================
# Advanced / Extension
library(dplyr)
before <- tibble(
  name = c("Amy", "Ben", "Cai", "Dan", "Eve"),
  team = c("A", "B", "A", "B", "A"),
  score = c(85, 62, 92, NA, 70), hours = c(5, 2, 6, 4, 3)
)
result <- count(before,team,sort=TRUE,name="students")
print(result)


# ==================== exam-employees-1: 课堂练习数据 · 补充解法 ====================
# Additional Example
library(dplyr)
before <- data.frame(
 Name=c("James","Linda","Jim","Margo","Nick","Stacy","Mary","Tom","Anna","Bob","Jeniffer","Lucas","Amy"),
 Age=c(22,56,34,48,19,25,31,68,72,42,39,52,39),
 State=c("California","New York","New York","California","Michigan","Texas","Ohio","Arizona","Texas","Florida","Nebraska","Indiana","Florida"),
 state_abr=c("CA","NY","NY","CA","MI","TX","OH","AZ","TX","FL","NE","IN","FL"),
 City=c("Los Angeles","New York","Buffalo","San Diego","Detroit","Austin","Cleveland","Phoenix","Houston","Tampa","Lincoln","Indianapolis","Miami"),
 Salary=c(30000,96500,72000,59000,54300,25000,61000,64000,74700,40000,83000,92400,82000))
lookup <- data.frame(
 State=c("Washington","Florida","Nebraska","Indiana","Florida","California","New York","New York","California","Michigan","Texas","Ohio","Arizona","Utah"),
 state_abbriviation=c("WA","FL","NE","IN","FL","CA","NY","NY","CA","MI","TX","OH","AZ","UT"),
 City=c("Seatle","Tampa","Lincoln","Indianapolis","Miami","Los Angeles","New York","Ithaca","San Francisco","Detroit","Dallas","Cleveland","Phoenix","Salt Lake City"),
 Average_salary=c(63500,53900,59900,59800,57900,79000,80000,75000,85000,54000,63800,57000,61000,58600))
result <- before %>% left_join(lookup,by=c("State","City")) %>%
 mutate(salary_gap=Salary-Average_salary) %>% select(Name,City,Salary,Average_salary,salary_gap)
print(result)


# ==================== exam-pivot-1: 补充 · 门店月销售 ====================
# Additional Example
library(dplyr)
library(tidyr)
before <- tibble(store=c("East","West"),m1=c(10,20),m2=c(14,NA),m3=c(18,30))
step1 <- before %>% pivot_longer(starts_with("m"),names_to="month",names_prefix="m",
                                names_transform=list(month=as.integer),values_to="sales")
result <- step1 %>% group_by(store) %>% summarise(mean_sales=mean(sales,na.rm=TRUE),
                                               observed=sum(!is.na(sales)),.groups="drop")
print(step1)
print(result)


# ==================== exam-plot-1: 补充 · 小排量汽车分面 ====================
# Additional Example
library(dplyr)
library(ggplot2)
before <- ggplot2::mpg
before$cyl <- as.factor(before$cyl)
p <- before %>% filter(displ<=4) %>% ggplot(aes(displ,hwy,color=cyl)) +
  geom_point(alpha=0.7) + facet_wrap(~drv) + theme_minimal() +
  labs(title="Engine displacement <= 4 L",x="Displacement (L)",y="Highway MPG",color="Cylinders")
print(p)


# ==================== lung-1: 课堂数据 · 字段、类别和缺失核对 ====================
# Lecture Example
library(ggplot2)
library(dplyr)
# 工作目录设为网站文件夹，data 内放课堂数据。
before <- read.table("data/lung_capacity.txt",header=TRUE,stringsAsFactors=FALSE)
result <- tibble(field=names(before),type=vapply(before,function(x)class(x)[1],character(1)),
                 missing=vapply(before,function(x)sum(is.na(x)),integer(1)))
print(dim(before))
print(result)
print(count(before,Status))
print(count(before,Sex))


# ==================== bar-1: 课堂 · 基础柱图、宽度与边框 ====================
# Lecture Example
library(ggplot2)
library(dplyr)
# 工作目录设为网站文件夹，data 内放课堂数据。
before <- read.table("data/lung_capacity.txt",header=TRUE,stringsAsFactors=FALSE)
p <- ggplot(before,aes(x=Status))
print(p + geom_bar())
print(p + geom_bar(fill="orange",width=0.9))
print(p + geom_bar(fill="pink",width=1.1))
print(p + geom_bar(fill="pink",color="blue"))


# ==================== bar-2: 补充 · 学生课程人数 ====================
# Additional Example
library(ggplot2)
before <- data.frame(course=c("R","R","Stats","R","Stats"))
p <- ggplot(before,aes(course,fill=course)) + geom_bar(width=0.7)
print(p)


# ==================== discrete-1: 课堂 · 选择两类与重排四类 ====================
# Lecture Example
library(ggplot2)
library(dplyr)
# 工作目录设为网站文件夹，data 内放课堂数据。
before <- read.table("data/lung_capacity.txt",header=TRUE,stringsAsFactors=FALSE)
p <- ggplot(before,aes(Status,fill=Status)) + geom_bar(width=0.9)
print(p + scale_x_discrete(limits=c("HEALTHY","STAGE_3")))
print(p + scale_x_discrete(limits=c("STAGE_1","STAGE_2","STAGE_3","HEALTHY")))


# ==================== bar-label-1: 课堂 · 柱外与柱内标签 ====================
# Lecture Example
library(ggplot2)
library(dplyr)
# 工作目录设为网站文件夹，data 内放课堂数据。
before <- read.table("data/lung_capacity.txt",header=TRUE,stringsAsFactors=FALSE)
p <- ggplot(before,aes(Status)) + geom_bar(fill="orange")
print(p + geom_text(aes(label=after_stat(count)),stat="count",vjust=-0.5,color="black"))
print(p + geom_text(aes(label=after_stat(count)),stat="count",vjust=1.5,size=6,color="black"))


# ==================== bar-label-2: 课堂 · 标题、副标题与caption对齐 ====================
# Lecture Example
library(ggplot2)
library(dplyr)
# 工作目录设为网站文件夹，data 内放课堂数据。
before <- read.table("data/lung_capacity.txt",header=TRUE,stringsAsFactors=FALSE)
p <- ggplot(before,aes(Status,fill=Status)) + geom_bar() +
  labs(title="Disease Status",subtitle="From Lung Capacity Dataset",
       x="STATUS",y="COUNT",caption="STAT2102: Lecture 14") +
  theme_classic() + theme(plot.title=element_text(hjust=0.5),
                         plot.subtitle=element_text(hjust=1),plot.caption=element_text(hjust=0))
print(p)


# ==================== bar-positions-1: 课堂 · 同一数据三种柱形布局 ====================
# Lecture Example
library(ggplot2)
library(dplyr)
# 工作目录设为网站文件夹，data 内放课堂数据。
before <- read.table("data/lung_capacity.txt",header=TRUE,stringsAsFactors=FALSE)
p <- ggplot(before,aes(Status,fill=Sex))
colours <- scale_fill_manual(values=c(FEMALE="tomato",MALE="steelblue"))
print(p + geom_bar() + colours)
print(p + geom_bar(position="fill") + colours + labs(y="Proportion within Status"))
print(p + geom_bar(position=position_dodge()) + colours)
print(count(before,Status,Sex))


# ==================== bar-positions-2: 课堂 · 堆叠与并排标签的位置必须匹配 ====================
# Lecture Example
library(ggplot2)
library(dplyr)
# 工作目录设为网站文件夹，data 内放课堂数据。
before <- read.table("data/lung_capacity.txt",header=TRUE,stringsAsFactors=FALSE)
p <- ggplot(before,aes(Status,fill=Sex,group=Sex))
colours <- scale_fill_manual(values=c(FEMALE="tomato",MALE="steelblue"))
print(p + geom_bar() + colours +
  geom_text(aes(label=after_stat(count)),stat="count",position=position_stack(vjust=0.5),size=4))
print(p + geom_bar(position=position_dodge(width=0.9)) + colours +
  geom_text(aes(label=after_stat(count)),stat="count",position=position_dodge(width=0.9),vjust=1.5,size=4))


# ==================== reference-lines-1: 课堂 · 100人参考线与翻转坐标 ====================
# Lecture Example
library(ggplot2)
library(dplyr)
# 工作目录设为网站文件夹，data 内放课堂数据。
before <- read.table("data/lung_capacity.txt",header=TRUE,stringsAsFactors=FALSE)
p <- ggplot(before,aes(Status,fill=Sex)) + geom_bar(position=position_dodge()) +
  scale_fill_manual(values=c(FEMALE="tomato",MALE="steelblue"))
print(p + geom_hline(yintercept=100,linetype="dashed",linewidth=1))
print(p + coord_flip())


# ==================== boxplot-1: 课堂 · 单箱、notch、按阶段及按性别分组 ====================
# Lecture Example
library(ggplot2)
library(dplyr)
# 工作目录设为网站文件夹，data 内放课堂数据。
before <- read.table("data/lung_capacity.txt",header=TRUE,stringsAsFactors=FALSE)
print(ggplot(before) + geom_boxplot(aes(y=Age)))
print(ggplot(before) + geom_boxplot(aes(y=Age),fill="orange",notch=TRUE))
print(ggplot(before) + geom_boxplot(aes(Status,Age)))
print(ggplot(before) + geom_boxplot(aes(Status,Age,fill=Status)))
print(ggplot(before) + geom_boxplot(aes(Status,Age,fill=Sex),
  outlier.colour="red",outlier.shape=8,outlier.size=4))


# ==================== boxplot-2: 补充 · 两门课程的成绩分布 ====================
# Additional Example
library(ggplot2)
before <- data.frame(course=rep(c("R","Stats"),each=6),score=c(60,70,75,80,85,95,55,65,67,70,72,90))
p <- ggplot(before,aes(course,score,fill=course)) + geom_boxplot()
print(p)


# ==================== box-points-1: 课堂 · 箱线图叠点与均值 ====================
# Lecture Example
library(ggplot2)
library(dplyr)
# 工作目录设为网站文件夹，data 内放课堂数据。
before <- read.table("data/lung_capacity.txt",header=TRUE,stringsAsFactors=FALSE)
print(ggplot(before,aes(Status,Age)) + geom_boxplot() +
  geom_dotplot(binaxis="y",stackdir="center",dotsize=0.3))
print(ggplot(before,aes(Status,Age,fill=Status)) + geom_boxplot() +
  stat_summary(fun="mean",geom="point",color="black"))
print(before %>% group_by(Status) %>% summarise(mean_age=mean(Age),median_age=median(Age),.groups="drop"))


# ==================== marginal-1: 课堂 · Age×LungCap与边缘箱线图 ====================
# Lecture Example
library(ggplot2)
library(dplyr)
# 工作目录设为网站文件夹，data 内放课堂数据。
before <- read.table("data/lung_capacity.txt",header=TRUE,stringsAsFactors=FALSE)
library(ggExtra)
p <- ggplot(before) + geom_point(aes(Age,LungCap,color=Sex))
marginal <- ggMarginal(p,type="boxplot")
print(marginal)


# ==================== histogram-1: 课堂 · 默认30箱与0.9箱宽 ====================
# Lecture Example
library(ggplot2)
library(dplyr)
# 工作目录设为网站文件夹，data 内放课堂数据。
before <- read.table("data/lung_capacity.txt",header=TRUE,stringsAsFactors=FALSE)
print(ggplot(before) + geom_histogram(aes(LungCap)))
print(ggplot(before) + geom_histogram(aes(LungCap),fill="tomato",color="black",
  alpha=0.3,binwidth=0.9,linetype="dashed"))


# ==================== density-1: 课堂 · 密度直方图叠核密度曲线 ====================
# Lecture Example
library(ggplot2)
library(dplyr)
# 工作目录设为网站文件夹，data 内放课堂数据。
before <- read.table("data/lung_capacity.txt",header=TRUE,stringsAsFactors=FALSE)
p <- ggplot(before) +
  geom_histogram(aes(LungCap,y=after_stat(density)),fill="white",color="black") +
  geom_density(aes(LungCap),alpha=0.3,fill="tomato")
print(p)


# ==================== hist-groups-1: 课堂 · 全体均值及性别分组均值 ====================
# Lecture Example
library(ggplot2)
library(dplyr)
# 工作目录设为网站文件夹，data 内放课堂数据。
before <- read.table("data/lung_capacity.txt",header=TRUE,stringsAsFactors=FALSE)
p <- ggplot(before) + geom_histogram(aes(LungCap),fill="tomato",alpha=0.3,color="black")
print(p + geom_vline(xintercept=mean(before$LungCap),color="blue",linewidth=1))
result <- before %>% group_by(Sex) %>% summarise(grp.mean=mean(LungCap),.groups="drop")
print(result)
print(ggplot(before) + geom_histogram(aes(LungCap,fill=Sex,color=Sex),alpha=0.5) +
  geom_vline(data=result,aes(xintercept=grp.mean,color=Sex),linetype="dashed",linewidth=1))


# ==================== hist-groups-2: 补充 · 显式重叠的分组直方图 ====================
# Additional Example
library(ggplot2)
library(dplyr)
# 工作目录设为网站文件夹，data 内放课堂数据。
before <- read.table("data/lung_capacity.txt",header=TRUE,stringsAsFactors=FALSE)
p <- ggplot(before,aes(LungCap,fill=Sex,color=Sex)) +
  geom_histogram(position="identity",alpha=0.35,binwidth=1,boundary=0) + theme_minimal()
print(p)


# ==================== patchwork-1: 课堂 · 自动布局、指定列数与嵌套 ====================
# Lecture Example
library(ggplot2)
library(dplyr)
# 工作目录设为网站文件夹，data 内放课堂数据。
before <- read.table("data/lung_capacity.txt",header=TRUE,stringsAsFactors=FALSE)
library(patchwork)
g1 <- ggplot(before) + geom_bar(aes(Status,fill=Status),width=0.9) +
  scale_x_discrete(limits=c("STAGE_1","STAGE_2","STAGE_3","HEALTHY"))
g2 <- ggplot(before) + geom_boxplot(aes(Status,Age,fill=Sex))
g3 <- ggplot(before) + geom_histogram(aes(LungCap,fill=Sex,color=Sex),alpha=0.5)
g1 <- g1 + theme(axis.text.x=element_text(angle=45,hjust=1))
g2 <- g2 + theme(axis.text.x=element_text(angle=45,hjust=1))
print(g1 + g2)
print(g1 + g2 + g3)
print(g1 + g2 + g3 + plot_layout(ncol=2))
print(g1 / g2)
print(g1 | g2)
print(g1 | (g2 / g3))


# ==================== compare-bar-hist-1: 补充 · 原始表和汇总表画出相同柱高 ====================
# Advanced / Extension
library(ggplot2)
library(dplyr)
before <- tibble(course=c("R","R","Stats","R","Stats"))
result <- count(before,course,name="total")
print(result)
print(ggplot(before,aes(course)) + geom_bar())
print(ggplot(result,aes(course,total)) + geom_col())


# ==================== exam-distribution-1: 可改写模板 · 分面直方图与每组均值 ====================
# Additional Example
library(ggplot2)
library(dplyr)
# 工作目录设为网站文件夹，data 内放课堂数据。
before <- read.table("data/lung_capacity.txt",header=TRUE,stringsAsFactors=FALSE)
clean <- before %>% filter(!is.na(LungCap),!is.na(Sex))
result <- clean %>% group_by(Sex) %>% summarise(grp.mean=mean(LungCap),.groups="drop")
p <- ggplot(clean,aes(LungCap,fill=Sex)) +
  geom_histogram(binwidth=1,boundary=0,color="white") +
  geom_vline(data=result,aes(xintercept=grp.mean),linetype="dashed",linewidth=1) +
  facet_wrap(~Sex) + theme_minimal() + labs(x="Lung Capacity",y="Count")
print(result)
print(p)


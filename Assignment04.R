library(data.table)
library(ggplot2)

setwd("C:/Users/simca/Documents/czu/expDataAn/assignments")

runoff_summary     <- readRDS('data/runoff_summary.rds')
runoff_summary_key <- readRDS('data/runoff_summary_key.rds')
runoff_stats       <- readRDS('data/runoff_stats.rds')
runoff_month_key   <- readRDS('data/runoff_month_key.rds')
runoff_summer_key  <- readRDS('data/runoff_summer_key.rds')
runoff_winter_key  <- readRDS('data/runoff_winter_key.rds')
runoff_year_key    <- readRDS('data/runoff_year_key.rds')
runoff_summer      <- readRDS('data/runoff_summer.rds')
runoff_winter      <- readRDS('data/runoff_winter.rds')
runoff_day         <- readRDS('data/runoff_day.rds')

colset_4 <- c("#D35C37", "#BF9A77", "#D6C6B9", "#97B8C2")
theme_set(theme_bw())

year_thres <- 2000

### PART 1 ###

#boxplot comparison for annual data
runoff_year_key[year < year_thres, period := factor('pre_2000')]
runoff_year_key[year >= year_thres, period := factor('aft_2000')]

ggplot(runoff_year_key, aes(x = factor('annual'), y = value, fill = period)) +
  geom_boxplot() +
  facet_wrap(~sname, scales = 'free_y') +
  scale_fill_manual(values = colset_4[c(4, 1)]) +
  xlab(label = "Period") +
  ylab(label = "Runoff (m3/s)") +
  ggtitle('Annual runoff: pre vs post 2000') +
  theme_bw()

#boxplot comparison for monthly data
runoff_month_key[year < year_thres, period := factor('pre_2000')]
runoff_month_key[year >= year_thres, period := factor('aft_2000')]

ggplot(runoff_month_key, aes(x = factor(month), y = value, fill = period)) +
  geom_boxplot() +
  facet_wrap(~sname, scales = 'free_y') +
  scale_fill_manual(values = colset_4[c(4, 1)]) +
  xlab(label = "Month") +
  ylab(label = "Runoff (m3/s)") +
  ggtitle('Monthly runoff: pre vs post 2000') +
  theme_bw()
#the monthly plot shows seasonal patterns in more detail than the summer/winter plot
#snowmelt - peak in upstream stations

#the annulat plot smooth everything into one box

### PART 2 ###

#compute quantile thresholds
runoff_day[, q90 := quantile(value, 0.9, na.rm = TRUE), by = sname]
runoff_day[, q10 := quantile(value, 0.1, na.rm = TRUE), by = sname]

#subset high and low runoff days
runoff_high <- runoff_day[value > q90]
runoff_low  <- runoff_day[value < q10]

#mean high/low runoff per station
mean_high <- runoff_high[, .(mean_high = mean(value, na.rm = TRUE)), by = sname]
mean_low  <- runoff_low[,  .(mean_low  = mean(value, na.rm = TRUE)), by = sname]

#number of days above 0.9 and below 0.1 per station
n_high <- runoff_high[, .N, by = sname]
n_low  <- runoff_low[,  .N, by = sname]
setnames(n_high, 'N', 'n_days_high')
setnames(n_low,  'N', 'n_days_low')

#merge into one summary table
runoff_extremes <- mean_high[mean_low, on = 'sname']
runoff_extremes <- runoff_extremes[n_high, on = 'sname']
runoff_extremes <- runoff_extremes[n_low,  on = 'sname']
print(runoff_extremes)

#plot number of high/low days per station
to_plot_n <- rbind(
  cbind(n_high[, .(sname, n_days = n_days_high)], type = factor('high (>Q90)')),
  cbind(n_low[,  .(sname, n_days = n_days_low)],  type = factor('low (<Q10)'))
)

ggplot(to_plot_n, aes(x = sname, y = n_days, fill = type)) +
  geom_bar(stat = 'identity', position = 'dodge') +
  scale_fill_manual(values = colset_4[c(1, 4)]) +
  xlab(label = "Station") +
  ylab(label = "Number of days") +
  ggtitle('Days above Q90 and below Q10 per station') +
  theme_bw()

#mean high runoff per station per period
mean_high_period <- runoff_high[, .(mean_high = mean(value, na.rm = TRUE)), 
                                by = .(sname, period)]

ggplot(mean_high_period, aes(x = reorder(sname, mean_high), y = mean_high, fill = period)) +
  geom_bar(stat = 'identity', position = 'dodge') +
  scale_fill_manual(values = colset_4[c(4, 1)]) +
  xlab(label = "Station") +
  ylab(label = "Mean high runoff (m3/s)") +
  ggtitle('Mean high runoff (>Q90) pre vs post 2000') +
  theme(axis.text.x = element_text(angle = 90)) +
  theme_bw()

mean_low_period <- runoff_low[, .(mean_low = mean(value, na.rm = TRUE)), 
                              by = .(sname, period)]

ggplot(mean_low_period, aes(x = reorder(sname, mean_low), y = mean_low, fill = period)) +
  geom_bar(stat = 'identity', position = 'dodge') +
  scale_fill_manual(values = colset_4[c(4, 1)]) +
  xlab(label = "Station") +
  ylab(label = "Mean low runoff (m3/s)") +
  ggtitle('Mean low runoff (<Q10) pre vs post 2000') +
  theme(axis.text.x = element_text(angle = 90)) +
  theme_bw()
#The data only partially agrees with Middelkoop 
#high runoff is slightly weaker post-2000 
#low flows have increased - against the expectation of more extreme low flows
#but the differences are very small - likely not statistically significant

### PART 3 ###

#summer: data till 2010
ggplot(runoff_summer_key[year <= 2010], aes(x = year, y = value)) +
  geom_line(col = colset_4[3])+
  geom_point(col = colset_4[3])+
  facet_wrap(~sname, scales = 'free') +
  geom_smooth(method = 'lm', formula = y~x, se = 0, col = colset_4[1]) +
  geom_smooth(method = 'loess', formula = y~x, se = 0, col = colset_4[4]) +
  scale_color_manual(values = colset_4[c(1, 2, 4)]) +
  xlab(label = "Year") +
  ylab(label = "Runoff (m3/s)") +
  ggtitle("summer runoff") +
  theme_bw()

#winter: data till 2010
ggplot(runoff_winter_key[year <=2010], aes(x = year, y = value)) +
  geom_line(col = colset_4[3])+
  geom_point(col = colset_4[3])+
  facet_wrap(~sname, scales = 'free') +
  geom_smooth(method = 'lm', formula = y~x, se = 0, col = colset_4[1]) +
  geom_smooth(method = 'loess', formula = y~x, se = 0, col = colset_4[4]) +
  scale_color_manual(values = colset_4[c(1, 2, 4)]) +
  xlab(label = "Year") +
  ylab(label = "Runoff (m3/s)") +
  ggtitle("winter runoff") +
  theme_bw()
#slopes change
#still has the same direction but different endpoint

#lm instead of loess
runoff_winter[, value_norm := scale(value), sname]
runoff_summer[, value_norm := scale(value), sname]
n_stations <- nrow(runoff_summary)

ggplot(runoff_winter[year > 1950 & year <= 2010], aes(x = year, y = value_norm, col = sname)) +
  geom_smooth(method = 'lm', formula = y~x, se = 0) + 
  scale_color_manual(values = colorRampPalette(colset_4)(n_stations)) +
  ggtitle('Winter runoff') +
  xlab(label = "Year") +
  ylab(label = "Runoff (m3/s)") +
  theme_bw()

ggplot(runoff_summer[year > 1950 & year <= 2010], aes(x = year, y = value_norm, col = sname)) +
  geom_smooth(method = 'lm', formula = y~x, se = 0) + 
  scale_color_manual(values = colorRampPalette(colset_4)(n_stations)) +
  ggtitle('Winter runoff') +
  xlab(label = "Year") +
  ylab(label = "Runoff (m3/s)") +
  theme_bw()
#lacks information and is potentionally missleading
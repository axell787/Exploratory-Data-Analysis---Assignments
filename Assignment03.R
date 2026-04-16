library(data.table)
library(ggplot2)
library(reshape2)
setwd("C:/Users/simca/Documents/czu/expDataAn/assignments")

runoff_stats <- readRDS("../data/runoff_stats.rds")
runoff_day <- readRDS("../data/runoff_day.rds")
runoff_monthly <- readRDS("../data/runoff_month.rds")
runoff_stations <- readRDS("../data/runoff_stations.rds")
runoff_summary <- readRDS("../data/runoff_summary.rds")

### PART 1 ###

#runoff_stats in tidy format
runoff_tidy <- melt(runoff_stats, id.vars = "sname")
#scatter plot for each station - mean, sd, min, max
ggplot(runoff_tidy, aes(x = sname, y = value, color = variable, shape = variable)) +
  geom_point(size = 3) +
  theme_minimal() +
  labs(title = "Runoff Statistics by Station", x = "Station", y = "Runoff")

### PART 2 ###

library(moments)
setDT(runoff_stats)
names(runoff_stats)
#skewness and coefficient of variation
#new dt
stats_summary <- runoff_day[, .(
  skew = moments::skewness(value, na.rm = TRUE), 
  cv   = sd(value, na.rm = TRUE) / mean(value, na.rm = TRUE)
), by = sname]
#new column in runoff_stats
runoff_stats[stats_summary, on = "sname", `:=`(skew = i.skew, cv = i.cv)]

### PART 3 ###

head(runoff_stats)
#values for runoff classes
runoff_monthly[, quantile(value)]

#assign runoff classes based on quantiles
runoff_monthly[, runoff_class := "low"]
runoff_monthly[value >= 600 & value < 2000, runoff_class := "medium"]
runoff_monthly[value >= 2000, runoff_class := "high"]

#factor format
runoff_monthly[, runoff_class := factor(runoff_class, levels = c("low", "medium", "high"))]

#monthly runoff with color according to runoff class
ggplot(runoff_monthly, aes(x = factor(month), y = value, fill = runoff_class)) +
  geom_boxplot() +
  facet_wrap(~sname, scales = 'free') + 
  theme_bw()

# Plotting daily runoff per station
ggplot(runoff_day, aes(x = sname, y = value, fill = sname)) +
  geom_boxplot(outlier.color = "red", outlier.size = 0.5) +
  scale_y_log10()
  theme_bw() +
  labs(
    title = "Daily Runoff Distribution by Station",
    x = "Station Name",
    y = "Daily Runoff (Log Scale)",
    caption = "Red dots indicate statistical outliers"
  ) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.position = "none")

#upstream stations has lower outliers then downstream
#skewness - the top outliers are more frequent then the lower outliers

### PART 4 ###

#classes for area  
runoff_stations[, quantile(area)]
runoff_stations[, area_class := factor('small')]
runoff_stations[area >= 34000 & area < 140000, area_class := factor('medium')]
runoff_stations[area >= 140000, area_class := factor('large')]

#classes for altitude
runoff_stations[, quantile(altitude)]
runoff_stations[, alt_class := factor('low')]
runoff_stations[altitude >= 50 & altitude < 350, alt_class := factor('medium')]
runoff_stations[altitude >= 350, alt_class := factor('high')]

#combine classes in dt
dt_area <- runoff_stations[, .(sname, area_class, alt_class, area)]
#merge with runoff_stats to plot
area_plot <- runoff_stats[dt_area, on = 'sname']

n_stations <- nrow(runoff_summary)
ggplot(area_plot, aes(x = mean_day, y = area, color = area_class, size = alt_class)) +
  geom_point(alpha = 0.7) +
  #color palette similar to the image
  scale_color_manual(values = c("small" = "#D35C37", "medium" = "#cbb291", "large" = "#97B8C2")) +
  scale_size_manual(values = c("low" = 2, "medium" = 5, "high" = 8)) +
  theme_bw() +
  labs(
    x = "mean_day", 
    y = "area",
    color = "Area Class",
    size = "Altitude Class"
  )

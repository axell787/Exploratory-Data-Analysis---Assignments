library(data.table)
#part1
temperatures_c  <- c(3, 6, 10, 14)
scaling_weights <- c(1, 0.8, 1.2, 1)

calculate_weighted_temp <- function(temp, weight) {
  return(temp * weight)
}

weighted_results <- calculate_weighted_temp(temperatures_c, scaling_weights)

print(weighted_results)

#part2
runoff_dt <- readRDS("../data/dt_example.rds")

monthly_summary <- runoff_dt[month(time) %in% 1:3, 
                             .(mean_runoff = mean(value)), 
                             by = .(month = month(time))]

setorder(monthly_summary, month)

monthly_summary[, percentage_change := (mean_runoff - shift(mean_runoff)) / shift(mean_runoff) * 100]

print(monthly_summary)

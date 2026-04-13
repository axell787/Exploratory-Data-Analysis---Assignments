library(data.table)
library(reshape2)
library(ggplot2)

runoff_stations <- readRDS("../data/runoff_stations.rds")
subset <- runoff_stations[, .(sname, area, altitude)]

tidy <- reshape2::melt(subset, id.vars = "sname")

ggplot(runoff_stations, aes(x = area, y = altitude, color = area,)) +
  geom_point() +
  geom_text(aes(label = sname), vjust = -1) +
  scale_color_gradient(low = "darkblue", high = "lightblue") +
  theme_light() +
  labs(color = "size")

ggplot(runoff_stations, aes(x = lon, y = lat, color = altitude)) +
  geom_point() +
  geom_text(aes(label = sname), vjust = 1.5) +
  scale_color_gradient(low = "darkgreen", high = "brown") +
  theme_bw() +
  labs(x = "lon", y = "lat")

ggplot(runoff_stations, aes(y = sname)) +
  geom_linerange(aes(xmin = start, xmax = end), 
                 color = "steelblue", size = 2) +
  theme_minimal() +
  labs(title = "Data Availability Period per Station",
       x = "Year", 
       y = "Station Name")

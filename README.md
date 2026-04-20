# Exploratory-Data-Analysis---Assignments

In this `README` file can be found all the `Explorer's questions` from the assignments

## Assignment 01
1. Rhine catchment is approximately 185 000km<sup>2<sup/>
2. ```
    catchment_area_km2 <- 185000
    catchment_area_m2  <- catchment_area_km2 * 1e6

    rainfall_mm_hr     <- 0.5
    duration_hr        <- 24
    rainfall_m         <- (rainfall_mm_hr * duration_hr) / 1000

    total_volume_m3    <- rainfall_m * catchment_area_m2
    duration_sec       <- duration_hr * 3600

    runoff_increase_m3s <- total_volume_m3 / duration_sec

    cat("Total precipitation volume:", total_volume_m3, "m³\n")
    cat("Increase in average runoff:", round(runoff_increase_m3s, 1), "m³/s\n")
    ```
   `Total precipitation volume: 2.22e+09 m³`
   `Increase in average runoff: 25694.4 m³/s`
3. optional
4. a)
   - a shift in the timing of peak flows (earlier spring floods due to earlier snowmelt)
   - Increased flood frequency and magnitude in winter
   - Greater inter-annual variability in discharge
   - changes in sediment transport patterns linked to altered flow regimes
  
   b)
   - the climate model projections (temperature and precipitation) are reliabl representation of future conditions
   - The hydrological model accurately translates climate inputs into river discharge - i.e. catchment processes are well-represented
   - Land use and catchment characteristics remain constant over the projection period (no changes in vegetation, urbanisatsion etc.)
  
   c) Rhine is one of Europre's most economically critical rivers. By late 1990s, climate models were predicting significant regional warming and precipitation. The study was needed to create concrete hydrological impacts and what would need to adapt

   d) Yes
   - Te Linde et al. (2010) - future flood risks in the Rhine under climate change
   - Arnell (1999) - global-scale study on climate change impacts on river flows
   - Dankers & Feyen (2008) - flood hazard in Europe under climate change (including Rhine)
   - Similar work also exists for other regions (Danbe, Colorado, Nile...)

   e) Yes
   - 2003 - Severe summer drought caused by historically low Rhine levels
   - 2011 and 2018 - Extreme low-water events
   - 2021 - Record floding in the Ahr Valley
   - 2022-2023 - Continued low-flow summers linked to drought patterns


## Assignment 02
1. Area: square kilometers
   Runoff: cubim meters per second
2. ```
   runoff_stations <- readRDS('./data/runoff_stations.rds')
    runoff_day      <- readRDS('./data/runoff_day.rds')

    avg_area <- runoff_stations[, mean(area)]
    cat("Average catchment area:", round(avg_area, 0), "km2\n")

    avg_runoff <- runoff_day[, mean(value)]
    cat("Average runoff:", round(avg_runoff, 1), "m3/s\n")
    ```
   `Average catchment area: 74490 km2` `Average runoff: 1372.8 m3/s`
3. ```
   runoff_day      <- readRDS('./data/runoff_day.rds')
    runoff_stations <- readRDS('./data/runoff_stations.rds')

    avg_runoff_station <- runoff_day[, .(mean_runoff = mean(value)), by = sname]

    avg_runoff_station <- runoff_stations[avg_runoff_station, on = 'sname']

    avg_runoff_station[, sname := reorder(sname, mean_runoff)]

    ggplot(avg_runoff_station, aes(x = sname, y = mean_runoff)) +
      geom_bar(stat = 'identity', fill = 'steelblue') +
      coord_flip() +
      labs(title = 'Average Daily Runoff per Station',
       x = 'Station', y = 'Mean Runoff (m³/s)') +
      theme_bw()
    ```
   <img width="1773" height="1285" alt="image" src="https://github.com/user-attachments/assets/6eabac3c-5f83-4d44-addb-dd668a48f304" />
4. Yes, there is strong negative correlation
   <img width="1401" height="971" alt="image" src="https://github.com/user-attachments/assets/855ad7c0-cc28-43c2-a1e1-1e12621c88ca" />

## Assignment 03
1. No difference
2. Because the runoff distribution is right skewed
3. They are really close together, similar catchment areas and runoff. There is just border between them
4. ```
   colset_4 <- c("#D35C37", "#BF9A77", "#D6C6B9", "#97B8C2")

    runoff_month  <- readRDS('./data/runoff_month.rds')
    runoff_year   <- readRDS('./data/runoff_year.rds')
    runoff_day    <- readRDS('./data/runoff_day.rds')
    runoff_summer <- readRDS('./data/runoff_summer.rds')
    runoff_winter <- readRDS('./data/runoff_winter.rds')
    
    # Highest/lowest MONTH
    monthly_clim <- runoff_month[, .(mean_runoff = mean(value)), by = .(sname, month)]
    peak_month   <- monthly_clim[, .SD[which.max(mean_runoff)], by = sname]
    low_month    <- monthly_clim[, .SD[which.min(mean_runoff)], by = sname]
    
    # Highest/lowest YEAR
    peak_year <- runoff_year[, .SD[which.max(value)], by = sname]
    low_year  <- runoff_year[, .SD[which.min(value)], by = sname]
    
    # Highest/lowest SEASON
    runoff_season <- runoff_day[!is.na(season), 
                                .(value = mean(value)), 
                                by = .(sname, season)]
    peak_season <- runoff_season[, .SD[which.max(value)], by = sname]
    low_season  <- runoff_season[, .SD[which.min(value)], by = sname]
    
    # Monthly runoff (heatmap style)
    ggplot(monthly_clim, aes(x = factor(month), y = sname, fill = mean_runoff)) +
      geom_tile(color = 'white') +
      scale_fill_gradient(low = colset_4[3], high = colset_4[1],
                          name = "Mean runoff\n(m³/s)") +
      labs(title = "Mean Runoff by Month and Station",
           x = "Month", y = "Station") +
      theme_bw()
    
    # Year of peak and lowest runoff per station
    peak_year[, type := 'Peak']    
    low_year[,  type := 'Low']    
    extremes_year <- rbind(peak_year, low_year)    
    
    ggplot(extremes_year, aes(x = year, y = sname, col = type, shape = type)) +
      geom_point(size = 4) +
      scale_color_manual(values = c('Peak' = colset_4[1], 'Low' = colset_4[4])) +
      labs(title = "Year of Peak and Lowest Annual Runoff per Station",
           x = "Year", y = "Station") +
      theme_bw()

    # Seasonal runoff per station
    ggplot(runoff_season, aes(x = season, y = sname, fill = value)) +
      geom_tile(color = 'white') +
      scale_fill_gradient(low = colset_4[3], high = colset_4[1],
                          name = "Mean runoff\n(m³/s)") +
      labs(title = "Mean Runoff by Season and Station",
           x = "Season", y = "Station") +
      theme_bw()
    ```
   <img width="1393" height="904" alt="image" src="https://github.com/user-attachments/assets/eed27ab9-ca12-42b8-a183-ed78665406d6" />
    <img width="1395" height="904" alt="image" src="https://github.com/user-attachments/assets/c8b7cde7-1009-4a46-8b65-5479b45494de" />
    <img width="1389" height="903" alt="image" src="https://github.com/user-attachments/assets/4654d3cd-8a7d-4e84-8729-80a461539c11" />
5. optional

## Assignment 04
1. No, DOMA is upstream

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
2.

# Exploratory-Data-Analysis---Assignments

In this `README` file can be found all the `Explorer's questions` from the assignments

## Explorer's questions - Assignment01
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

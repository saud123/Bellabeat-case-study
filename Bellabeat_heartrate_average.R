library(readr)


heart_rate <- read_csv("mturkfitbit_export_3.12.16-4.11.16/Fitabase Data 3.12.16-4.11.16/heartrate_seconds_merged.csv",show_col_types = FALSE)
View(heart_rate)


heart_rate$timestamp <- mdy_hms(heart_rate$Time)
names(heart_rate) <- tolower(names(heart_rate))



View(heart_rate)





hourly_pattern  <-heart_rate %>%
  mutate(hour = hour(timestamp)) %>%         # Extract hour (0–23)
  group_by(hour) %>%
  summarise(AverageValue = mean(value, na.rm = TRUE))  # Calculate average per hour

# Step 2: Print the result
print(hourly_pattern)




ggplot(hourly_pattern, aes(x = hour, y = AverageValue)) +
  geom_line(color = "steelblue", linewidth = 1) +  # Trend line
  geom_point(aes(color = AverageValue), size = 3) +  # Points colored by value
  scale_color_gradient(low = "lightblue", high = "darkblue") +  # Color gradient
  labs(
    title = "Daily Heart Rate Rhythm",
    subtitle = "Activity vs. Rest Cycles",
    x = "Hour of Day (0–23)",
    y = "Average Heart Rate (BPM)",
    caption = "Note: Data averaged per hour across multiple days on 33 users"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5),
    plot.caption = element_text(hjust = 0.5),
    panel.grid.major = element_line(color = "grey90")
  ) +
  scale_x_continuous(breaks = seq(0, 23, by = 2))  # Cleaner x-axis labels


# Get the rows with the min and max AverageValue
max_value <- hourly_pattern %>% filter(AverageValue == max(AverageValue)) %>% pull(AverageValue)
min_value <- hourly_pattern %>% filter(AverageValue == min(AverageValue)) %>% pull(AverageValue)


# Concatenate the result
result <- paste("The Minimum Value is", round(min_value,2), "\nThe Maximum Value is", round(max_value,3))

# Print the result
cat(result)





ggplot(hourly_pattern, aes(x = hour, y = AverageValue)) +
  # Trend line and points
  geom_line(color = "#2A5C8A", linewidth = 1.2) +  
  geom_point(aes(color = AverageValue, size = ifelse(AverageValue == max(AverageValue), 5, 3)), 
             alpha = 0.8) +  
  scale_size_identity() +  # Use exact size values
  
  # Highlight max value with annotation
  geom_label(
    data = ~filter(.x, AverageValue == max(AverageValue)),
    aes(label = paste0("Max: ", round(AverageValue), " BPM")),
    nudge_y = 5,  # Position above the point
    color = "#CC3311",
    fill = "white",
    label.size = 0.2,
    size = 3.5
  ) +
  
  # Color gradient
  scale_color_gradient(
    low = "#88CCEE", 
    high = "#CC3311",
    name = "Heart Rate (BPM)"
  ) +
  
  # Labels and theme
  labs(
    title = "Daily Heart Rate Rhythm",
    subtitle = "Peaks correlate with activity periods",
    x = "Hour of Day (0-23)", 
    y = "Average BPM",
    caption = "Data: 33 users (hourly averages)\nCircle size highlights maximum value"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5),
    plot.caption = element_text(hjust = 0.5),
    panel.grid.major = element_line(color = "grey90")
  ) +
  scale_x_continuous(breaks = seq(0, 23, by = 2))  # Cleaner x-axis labels

  scale_x_continuous(breaks = seq(0, 23, by = 3))


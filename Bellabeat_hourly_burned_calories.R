library(readr)
library(dplyr)
library(lubridate)

#Hourly Calories
hourly_calories <- read_csv("mturkfitbit_export_3.12.16-4.11.16/Fitabase Data 3.12.16-4.11.16/hourlyCalories_merged.csv",show_col_types = FALSE)
names(hourly_calories) <- tolower(names(hourly_calories))
View(hourly_calories)


#---------------Convert Datetime-------------
hourly_calories$time <- mdy_hms(hourly_calories$activityhour)



hourly_pattern <- hourly_calories %>%
  mutate(hour = hour(time)) %>%         # Extract hour (0–23)
  group_by(hour) %>%
  summarise(AverageCalories = mean(calories, na.rm = TRUE))  # Calculate average per hour

# Step 2: Print the result
print(hourly_pattern)

# Step 3: Optional Visualization
ggplot(hourly_pattern, aes(x = hour, y = AverageCalories)) +
  geom_point(aes(color = AverageCalories), size = 3) +
  geom_line(color = "pink") +
  scale_color_gradient(low = "seagreen", high = "seagreen") +
  labs(
    title = "Hourly Average Calories Burned",
    subtitle = "Aggregated Across All Days",
    x = "Hour of Day (0–23)",
    y = "Average Calories Burned",
    caption = "Note: Data averaged per hour across multiple days"
  ) +
  theme_minimal() +
  theme(plot.caption = element_text(hjust = 0.5))  +
  theme(plot.subtitle = element_text(hjust = 0.5)) +  
  theme(plot.title = element_text(hjust = 0.5))   





max_hour <- hourly_pattern %>% filter(AverageCalories == max(AverageCalories))
min_hour <- hourly_pattern %>% filter(AverageCalories == min(AverageCalories))

print(min_hour)
print(max_hour)


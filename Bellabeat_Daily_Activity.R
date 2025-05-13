install.packages("lubridate")
install.packages("skimr")
install.packages("tidyverse")
install.packages("psych")

library(dplyr)
library(scales)
library(psych)
library(lubridate)
library(tidyverse)
library(readr)
library(ggplot2)

data <- read_csv("mturkfitbit_export_3.12.16-4.11.16/Fitabase Data 3.12.16-4.11.16/dailyActivity_merged.csv")

# Inspect Data
View(data)
glimpse(data)

#Convert ActivityDate (String) into Date Format
data$ActivityDate <- mdy(data$ActivityDate)
class(data$ActivityDate)

#Convert All Variables into lowercase
names(data) <- tolower(names(data))


# Check & Count Number of duplicate rows
duplicates <- data[duplicated(data), ]
num_duplicates <- sum(duplicated(data))
cat("Number of duplicate rows:", num_duplicates, "\n")

# Print the number of missing values in each column
missing_values <- colSums(is.na(data))
view(missing_values)

summary(data)


# Here We will anaylse total steps per wekkday

daily_activity <-data %>% mutate( Weekday = weekdays(as.Date(activitydate, "%m/%d/%Y")))

View(daily_activity)


steps_taken_by_days <- daily_activity %>%
  group_by(Weekday)  %>%
  summarise(totalsteps = sum(totalsteps, na.rm = TRUE))


View(steps_taken_by_days)


# Create the visualization
bar_chart <- ggplot(steps_taken_by_days, aes(x = Weekday, y = totalsteps, fill = Weekday)) +
  geom_bar(stat = "identity") +
  labs(title = "Total Steps Taken Each Day of the Week",
       x = "Day of the Week",
       y = "Total Steps") +
  scale_fill_brewer(palette = "Set3") +
  theme_minimal()

bar_chart + theme(legend.position = "none")


# Average daily step count
mean_steps <- mean(daily_activity$totalsteps, na.rm = TRUE)
mean_steps

# Average minutes in each activity level
colMeans(daily_activity[, c("veryactiveminutes", 
                           "fairlyactiveminutes", 
                           "lightlyactiveminutes")], na.rm = TRUE)



# Correlation between steps and very active minutes
cor(daily_activity$totalsteps, daily_activity$veryactiveminutes, use = "complete.obs")

cor_value <- round(cor(daily_activity$totalsteps, daily_activity$veryactiveminutes), 2)

# Create ScatterPlot
steps_plot <- ggplot(daily_activity, aes(x = totalsteps, y = veryactiveminutes)) +
  geom_point(color = "seagreen") +
  geom_smooth(method = "lm", color = "black", se = FALSE) +
  annotate("text", x = 21000, y = 95, label = paste("Correlation:", cor_value),
           color = "black", fontface = "bold", size = 4, angle = 17) +
  ggtitle("Total Steps Vs Active Minutes",
          subtitle = "Analyzing relations") +
  labs(x = "Total Steps",
       y = "Very Active Minutes",
       caption = "Data sourced from Bellabeat’s Fitbit user activity logs (March–May 2016)") +
  theme_minimal() +
  theme(plot.caption = element_text(hjust = 0.5)) +
  theme(plot.subtitle = element_text(hjust = 0.5))  +  theme(plot.title = element_text(hjust = 0.5))   
 

# Display plot
print(steps_plot)
  

# Finding Relation between Distance and Calories


cor_value_dis_cal <- round(cor(daily_activity$calories,daily_activity$totaldistance), 2)
cor_value_dis_cal

dis_cal <- ggplot(daily_activity, aes(x = calories, y =totaldistance )) +
  geom_point(color = "seagreen") +
  geom_smooth(method = "lm", color = "black", se = FALSE) +
  annotate("text", x = 420, y = 20, label = paste("Correlation:", cor_value_dis_cal),
           color = "black", fontface = "bold", size = 4, angle = 17) +
  ggtitle("Relationship Between Calories Burned and Total Distance",
          subtitle = "Positive Correlation Found") +
  labs(x = "Total Distance",
       y = "Calories",
       caption = "Higher calories burned are associated with longer distances") +
  theme_minimal() +
  theme(plot.caption = element_text(hjust = 0.5)) +
  theme(plot.subtitle = element_text(hjust = 0.5))  +  theme(plot.title = element_text(hjust = 0.5))   

print(dis_cal)



# Relationship between Distance, Calories


facet_graph <- ggplot(daily_activity, aes(x = calories, y = totaldistance, color = totalsteps)) +
  geom_point() +
  geom_smooth(method = "lm", color = "black", se = FALSE) +
  ggtitle("Exploring the Link Between Calories Burned and Total Distance",
          subtitle = "Positive Correlation with Total Steps as a Key Factor") +
  labs(x = "Calories",
       y = "Total Distance",
       caption = "Higher calories burned are associated with longer distances & More steps") +
  theme_minimal() +
  theme(plot.caption = element_text(hjust = 0.5)) +
  theme(plot.subtitle = element_text(hjust = 0.5)) +  
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_color_gradient(low = "darkolivegreen3", high = "seagreen4")  # Adjust colors for total steps


facet_graph


# Avg steps per day

over <- daily_activity %>%
  ggplot(aes(x = activitydate, y = totalsteps)) +
  geom_col() +
  labs(title = "Total Steps Over Time", x = "Date", y = "Total Steps")

over


# Total Distance, steps and Active Minutes of week

# Prepare the dataset, ensuring Weekday is a factor
daily_activity <- daily_activity %>%
  mutate(Weekday = factor(Weekday, levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")))

# Select the columns for activity metrics
activity_data <- daily_activity %>%
  select(Weekday, totalsteps, totaldistance, calories)

# Reshape the data into long format for faceting
activity_long <- activity_data %>%
  pivot_longer(cols = c(totalsteps, totaldistance, calories),
               names_to = "activity_metric",
               values_to = "value")

# Create the facet_wrap plot for Total Steps, Total Distance, and Calories
ggplot(activity_long, aes(x = Weekday, y = value, fill = activity_metric)) +
  geom_bar(stat = "identity", position = "dodge") +
  facet_wrap(~ activity_metric, scales = "free_y") +  # Facet by activity metric
  labs(title = "Activity Metrics Across the Week", 
       subtitle = "Comparing Total Steps, Distance, and Calories by Day of the Week",
       x = "Weekday", 
       y = "Value",
       caption = "Data visualized by Activity Metrics") +
  scale_fill_brewer(palette = "Set2") +  # Professional color palette
  theme_minimal() +
  theme(legend.position = "none", 
        plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5),
        plot.caption = element_text(hjust = 0.5),
        axis.text.x = element_text(angle = 45, hjust = 1))  # Rotate x-axis labels by 45 degrees














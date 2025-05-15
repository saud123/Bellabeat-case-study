# Bellabeat Case Study – Google Data Analytics Capstone Project

<p align="center">
  <img src="https://raw.githubusercontent.com/saud123/Bellabeat-case-study/f08d6b120f3c45735106924778fac82a7c3f1d3c/image_2025-05-15_140227414.png" width="700" />
</p>


## 🧠 About the Project
This case study is part of the Google Data Analytics Professional Certificate on Coursera. The project focuses on analyzing smart device usage data to derive insights that Bellabeat, a high-tech wellness company for women, can use to enhance its marketing strategy and user engagement.

## 💬 Ask Phase
Primary Stakeholders:

Urška Sršen (Co-founder & COO of Bellabeat)

Sando Mur (Bellabeat Marketing Team)

## Business Task:
Urška Sršen has requested the marketing analytics team to analyze smart fitness device usage, specifically using Fitbit data, to uncover user activity trends. The ultimate goal is to develop actionable recommendations that inform and strengthen Bellabeat’s marketing strategy.

## 📥 Prepare Phase
### 📁 Data Source:
The dataset is publicly available on Kaggle. It was downloaded in CSV format.

### 📊 Data Structure:

The data is organized in a long format.

Includes 18 CSV files with daily and minute-level data from 30 Fitbit users.

### 🔎 ROCCC Evaluation:

Reliable & Original: Collected from consenting users via Amazon Mechanical Turk.

Comprehensive: Contains heart rate, physical activity, sleep, and weight data.

Current: Data collected between March and May 2016 (note: may be outdated).

Cited: Hosted on Kaggle, but original citation source is not clearly defined.

### 🔐 Privacy, Licensing, and Accessibility:

Licensing: For educational/research use; no specific open license.

Privacy: Anonymized data; users gave consent.

Security: Data should be handled responsibly; no personally identifiable information included.

Accessibility: Available to download in CSV format from Kaggle.

### ⚠️ Limitations:

Small sample size (30 users).

No demographic information (e.g., gender, age).

Potential sampling bias – users may be more fitness-inclined than the general population.

Data is from 2016 and may not reflect current trends.

---

## ⚙️ 3. Process Phase

**Tools & Libraries**  
- R (RStudio)  
- Libraries: `tidyverse`, `lubridate`, `ggplot2`, `psych`, `skimr`

### Prepare & Clean Data

```r
# Load and prepare data
data <- read_csv("dailyActivity_merged.csv")
data$ActivityDate <- mdy(data$ActivityDate)
names(data) <- tolower(names(data))
daily_activity <- data %>% mutate(Weekday = weekdays(activitydate))
```

### Tracking Steps By days

```r
bar_chart <- ggplot(steps_taken_by_days, aes(x = Weekday, y = totalsteps, fill = Weekday)) +
  geom_bar(stat = "identity") +
  labs(title = "Total Steps Taken Each Day of the Week",
       x = "Day of the Week",
       y = "Total Steps") +
  scale_fill_brewer(palette = "Set3") +
  theme_minimal()

bar_chart + theme(legend.position = "none")
```


### Tracking Steps By days

![image alt](https://raw.githubusercontent.com/saud123/Bellabeat-case-study/main/Steps%20per%20week.png)


Activity is highest mid-week (Tuesday to Thursday), reflecting the structure of workdays, while it drops on Sundays due to the unstructured weekend. A slight decline on Fridays may result from transitioning to weekend routines, with a rebound in steps on Mondays as users return to structured schedules.


### Calories Burned vs Total Distance


```r
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
```

![Calories vs Distance](https://raw.githubusercontent.com/saud123/Bellabeat-case-study/main/Calories%20%26%20dsitance_1.png)

A moderate-to-strong positive correlation (r = 0.61) between total distance covered and calories burned confirms that increased physical movement directly contributes to higher energy expenditure, though other factors like intensity, metabolism, and body composition also play a role. This link is further supported by the correlation between steps, distance, and calories.


### Steps Over time 

```r
total_steps <- daily_activity %>%
  ggplot(aes(x = activitydate, y = totalsteps)) +
  geom_col() +
  labs(title = "Total Steps Over Time", x = "Date", y = "Total Steps")
total_steps
```


![Steps Over Time](https://raw.githubusercontent.com/saud123/Bellabeat-case-study/main/stpe%20over%20time.png)

Between March 2 and March 20, step counts were notably low, possibly due to external disruptions such as harsh weather (e.g., March 2016 storms like “Snowzilla”), holidays (International Women’s Day, St. Patrick’s Day), and major global events (e.g., Brussels attacks on March 16). Additionally, users may have temporarily stopped wearing their tracking devices. After March 20, a steady rise in activity suggests a return to routine or improved conditions. This trend highlights the need for Bellabeat to implement adaptive reminders and contextual nudges during periods of inactivity to maintain consistent engagement.



### Steps Over time 

```r
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

```

![Total Steps, Distance & Calories](https://raw.githubusercontent.com/saud123/Bellabeat-case-study/main/total%20steps%2C%20distance%20%26%20calories.png)

#Heart Rate Activity

```r

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
```

![Heart Rate Analysis](https://raw.githubusercontent.com/saud123/Bellabeat-case-study/0adfc79983c6f31121e18d68da4ff81c0139f42d/heart.png)


The heart rate data reveals distinct daily patterns. A morning surge between 6–10 AM, peaking around 91 BPM, likely reflects workouts, commuting, or natural hormonal changes. A secondary rise between 5–8 PM suggests post-work physical activity. Rest periods are evident, with the lowest heart rates (~60 BPM) between 12–3 AM, aligning with deep sleep, and a slight dip from 2–4 PM, possibly due to a post-lunch slump or sedentary work routines. Notably, a spike at midnight may indicate data noise—potentially from users removing their trackers—rather than actual physiological activity.




### 📌 Key Insights (Summarized):

- User Activity Peaks Midweek: Physical activity (steps, calories, distance) is highest between Tuesday and Thursday, with noticeable drops on weekends.

- Strong Link Between Activity & Calorie Burn: There’s a clear positive correlation between total steps, active minutes, and calories burned, confirming physical movement drives energy expenditure.

- Distinct Daily Heart Rate Patterns: Heart rate peaks during morning (6–10 AM) and evening hours (5–8 PM), with noticeable dips during sleep and afternoon hours, indicating consistent physiological routines.


## ✅ Recommendations for the Act Stage

### Optimize Push Notifications Around Peak Activity Windows
- Deliver motivational messages, workout suggestions, or reminders during **6–10 AM** and **5–8 PM** to align with natural user energy cycles.
- Avoid sending prompts late at night or during early morning rest hours (**12–3 AM**) to prevent disturbance.

### Launch a Midweek Challenge Campaign
- Introduce initiatives like **"Wellness Wednesdays"** to leverage midweek activity spikes and incentivize consistent user engagement.
- Offer rewards or badges for consistent activity from **Tuesday to Thursday** to help build healthy habits.

### Create Smart Nudges During Inactive Periods
- Send gentle reminders on weekends and Friday evenings when user activity typically drops, encouraging light workouts or mindfulness sessions.
- Use inactivity tracking to trigger personalized nudges, such as step goals or hydration breaks.

### Personalize Goals Based on Heart Rate & Step Trends
- Recommend rest days or lower-intensity activities when low heart rate and steps are detected (e.g., Sunday slumps).
- Encourage users to sync heart rate data to monitor recovery and adapt their routines accordingly.

### Seasonal & Event-Aware Engagement
- Utilize historical trends (e.g., low activity around holidays or weather disruptions) to prepare campaigns offering indoor fitness tips, stretching routines, or guided meditation content during such periods.


## 📊 Tableau Dashboard

Explore the interactive dashboard visualizing user activity, heart rate patterns, and engagement trends to support data-driven decision-making:



[View Bellabeat Tableau Dashboard](https://public.tableau.com/app/profile/saud.ijaz/viz/GooglesDataAnalyticsBellabeat-PortoflioCaseStudy/Dashboard1)




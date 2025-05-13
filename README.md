# Bellabeat Case Study – Google Data Analytics Capstone Project
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

[weekly_steps_chart.png](https://github.com/saud123/Bellabeat-case-study/blob/main/Steps%20per%20week.png)

Activity is highest mid-week (Tuesday to Thursday), reflecting the structure of workdays, while it drops on Sundays due to the unstructured weekend. A slight decline on Fridays may result from transitioning to weekend routines, with a rebound in steps on Mondays as users return to structured schedules.






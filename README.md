# Kickstarter Campaign Analysis for Predictive Success

## 📌 Project Overview
This repository contains a comprehensive exploratory data analysis (EDA) and predictive modeling pipeline focused on historical Kickstarter campaigns. The goal of this project is to reverse-engineer crowdfunding success by identifying the statistical drivers that separate funded projects from failed ones. 

Rather than a theoretical exercise, this analysis was conducted to establish a concrete, data-driven framework to guide the financial structuring, media strategy, and timeline planning for my own future Kickstarter projects.

## 🎯 Objectives
*   **Identify categorical drivers:** Determine the impact of pitch videos and staff picks using Chi-Square testing.
*   **Analyze financial constraints:** Compare the mean standardized goals (USD) of successful vs. failed campaigns using Welch's Two-Sample T-tests.
*   **Predictive modeling:** Train a Random Forest classifier to predict campaign outcomes using only pre-launch data, avoiding data leakage.

## 🛠️ Tech Stack & Tools
*   **Language:** R
*   **Environment:** RStudio
*   **Data Manipulation:** `dplyr`, `tidyverse`
*   **Visualization:** `ggplot2`, `scales`
*   **Machine Learning:** `randomForest`, `caret`

## 📊 Dataset & Pre-processing
The dataset was sourced from a third-party web scraping repository. Significant data cleaning and feature engineering were required before analysis:
1.  **Handling String Anomalies:** Literal `"null"` strings in JSON-derived columns were converted to proper `NA` values and logical types.
2.  **Currency Standardization:** Financial goals were standardized into USD using historical exchange rates (`goal * fx_rate`) and log-transformed to handle severe right-skewness.
3.  **Temporal Engineering:** UNIX timestamps (`created_at`, `launched_at`, `deadline`) were converted into continuous lifecycle metrics (`prep_days`, `campaign_days`).
4.  **Data Leakage Prevention:** Post-launch metrics (e.g., `backers_count`, `pledged`, `percent_funded`) were strictly excluded from hypothesis testing and machine learning models.

## 📈 Key Findings
*   **Financial Reality:** Failed campaigns requested significantly higher standardized goals (mean $\approx$ $6,456) compared to successful campaigns (mean $\approx$ $2,570) ($p < 2.2e-16$).
*   **Media Impact:** The presence of a pitch video is overwhelmingly associated with a higher likelihood of funding.
*   **Predictive Power:** The Random Forest model achieved an 80.4% overall accuracy. However, a lower sensitivity for detecting failures (48.6%) highlighted that subjective variables uncaptured by the data—such as product quality and off-platform marketing—heavily influence false positives.

## 🚀 How to Run
1. Clone this repository.
2. Ensure you have the required R packages installed: `install.packages(c("dplyr", "ggplot2", "randomForest", "caret", "scales"))`
3. Load the dataset (script expects `expanded_cleanup` dataframe).
4. Run the EDA and modeling scripts sequentially.

## 📝 Author
**Omid Karimi**
Computer Science Undergraduate | Gisma University of Applied Sciences, Berlin

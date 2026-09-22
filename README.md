# Social Media Advertising Analytics


## Data Quality & Validation — `ad_events_stg`

The following validation checks were performed:

- Checked column names and data types using `INFORMATION_SCHEMA.COLUMNS`.
- Compared total rows with the number of unique `event_id` values to identify duplicates.
- Checked key columns for `NULL` values.
- Analyzed the distribution of `event_type`.
  ![Img1](images/Img1.png)

- Validated `day_of_week` against the date calculated from `timestamp`.
- Identified users with unusually high numbers of events.
- Analyzed the distribution of `event_type`.
  ![IMG2](images/IMG2.png)

- Validated the format of `user_id` using regular expressions.
- Checked the minimum and maximum event dates.
- Verified the number of distinct months represented in the dataset.

## Data Cleaning

A cleaned analytical table, `cln_ad_events`, was created from the staging table.

### Cleaning Steps

- Removed records with invalid `user_id` values.
- Converted `timestamp` into separate `event_timestamp` and `event_date` fields.
- Retained only records with a valid hexadecimal `user_id` format.
- Rechecked the cleaned dataset for `NULL` values and duplicate `event_id` records.
- Revalidated the distribution of `event_type` after cleaning.

## Results

- **Initial dataset:** approximately 40,000 rows.
- **NULL values:** no `NULL` values were detected in the validated key columns.
- **Invalid `user_id` records:** 9,603 records were identified as invalid.
- **Cleaning action:** all 9,603 invalid records were removed.
- **Valid records remaining:** approximately 30,397 records.
- **User ID validation:** valid `user_id` values were retained based on the hexadecimal format `^[0-9a-fA-F]+$`.
- **Final table:** `cln_ad_events` contains the cleaned data prepared for further analytical work.
  
  ![Img3](images/Img3.png)


## Data Quality & Validation — `ads_stg`

### Validation Checks

The following validation checks were performed:

- Checked for `NULL` values in key columns, including `ad_id` and `campaign_id`.
- Validated `ad_id` and `campaign_id` formats using `SAFE_CAST`.
- Checked for duplicate `ad_id` values.
- Checked for missing or empty values in key text fields.
- Validated categorical fields against the expected domain values for `ad_platform`, `ad_type`, `target_gender`, and `target_age_group`.
- Checked `target_interests` for formatting inconsistencies, including duplicate commas and excessive whitespace.

## Data Cleaning

### Cleaned Analytical Table

A cleaned analytical table, `cln_ads`, was created from the staging table `ads_stg`.

The cleaning process included:

- Validating key identifiers and text fields.
- Checking categorical fields against expected domain values.
- Checking text fields for formatting inconsistencies.
- Creating the `cln_ads` table for further analytical processing.

## Results

### Validation Results

The validation process confirmed that the main data quality checks were performed before analytical processing:

- **NULL values:** checked in key columns.
- **ID formats:** validated using `SAFE_CAST`.
- **Duplicates:** checked for duplicate `ad_id` values.
- **Categorical fields:** validated against expected domain values.
- **Text formatting:** checked for inconsistencies in `target_interests`.
- **Final table:** `cln_ads` was created as the cleaned analytical table for further analysis.

## Data Quality & Validation — `calendar_table_stg`

### Validation Checks

The following validation checks were performed:

- Checked for `NULL` values in all columns, including `Date`, `Day Name`, `Day Number`, `Month`, `Month Number`, `Week Day`, `Year`, and `Quarter`.
- Checked for duplicate `Date` values, since `Date` serves as the primary key of the calendar table.

## Data Cleaning

### Cleaned Analytical Table

A cleaned analytical table, `cln_calendar`, was created from the staging table `Calendar_Table_stg`.

The cleaning process included:

- Validating the `Date` column and all derived date attributes for missing values.
- Checking `Date` for duplicate entries.
- Creating the `cln_calendar` table for further analytical processing.

## Results

### Validation Results

The validation process confirmed that the main data quality checks were performed before analytical processing:

- **NULL values:** checked in all columns — no missing values found.
- **Duplicates:** checked for duplicate `Date` values — no duplicates found.
- **Final table:** `cln_calendar` was created as the cleaned analytical table for further analysis.

> **Note:** The dataset is synthetic, so additional checks such as referential integrity, value anomalies, and date sequence continuity were not performed, as the data was generated without real-world source errors.


# Data Quality & Validation — `campaigns_stg`

## Validation Checks
The following validation checks were performed on the `campaigns_stg` table:

* **Missing Values Validation:** Checked for `NULL` values across key columns including `campaign_id`, `name`, `start_date`, `end_date`, `duration_days`, and `total_budget`.
* **Primary Key Uniqueness Check:** Verified that `campaign_id` contains zero duplicates to ensure a valid 1:Many relationship in Power BI.
* **Date Logical Consistency:** Screened for logical errors where `end_date` mistakenly precedes `start_date`.
* **Duration Calculation Verification:** Validated that the pre-calculated `duration_days` perfectly matches the actual difference between `end_date` and `start_date`.
* **Budget Accuracy Check:** Flagged rows with anomalous, negative, or zero budgets (`total_budget <= 0`).

## Data Cleaning
### Cleaned Analytical Table
A cleaned analytical table, `cln_campaigns`, was created from the staging table `campaigns_stg`.

The cleaning process included:
* Validating all key attributes and campaign metrics for missing values.
* Ensuring complete logical consistency for dates and tracking metrics.
* Checking the primary key for duplicate entries.
* Materializing the verified data into the `cln_campaigns` table for seamless Power BI consumption.

## Results
### Validation Results
The validation process confirmed that all critical data quality checks were successfully performed before analytical processing:

* **NULL values:** Checked across all columns — no missing values found.
* **Duplicates:** Checked for duplicate `campaign_id` entries — primary key uniqueness is maintained.
* **Logical & Business Rules:** Dates, durations, and financial values passed all consistency checks.
* **Final table:** `cln_campaigns` was successfully created as the clean analytical source for BI reporting.

# Data Quality & Validation — users_stg

## Validation Checks
The following validation checks were performed on the users_stg table:

* **Missing Values Validation:** Checked for NULL values and empty strings across key columns including user_id, user_gender, user_age, age_group, country, location, and interests.

* **Primary Key Uniqueness Check:** Verified user_id values to identify duplicate user records and ensure each user can be uniquely identified.

* **Full Duplicate Check:** Compared all user attributes to identify completely duplicated records in the staging table.

* **User ID Format Validation:** Checked that user_id contains only alphanumeric characters (A–Z, a–z, 0–9).

* **Age Format Validation:** Verified that user_age contains only numeric values.

* **Age Range Validation:** Checked that user_age falls within the valid range of 0–120 years.

* **Country Format Validation:** Checked country values to ensure they contain valid alphabetical characters and allowed separators such as spaces, dots, hyphens, and apostrophes.

* **Country Value Distribution:** Reviewed unique country values and their frequencies to identify potential inconsistencies in the source data.

## Data Cleaning
### Cleaned Analytical Table
A cleaned analytical table, cln_users, was created from the staging table users_stg.

The cleaning process included:
* Filtering records with invalid user_id formats.
* Validating that user_age contains numeric values.
* Ensuring that user_age is within the 0–120 range.
* Validating the format of the country field.
* Removing records that do not satisfy the defined data quality rules.

## Results
### Validation Results
The validation process ensured that the critical data quality rules were checked before analytical processing:
* **NULL / Empty Values:** Checked across all key columns to identify missing or blank values.
* **Duplicates:** Checked for duplicate user_id values and fully duplicated user records.
* **User ID Format:**  Validated that user IDs contain only alphanumeric characters.
* **Age Validation:** Confirmed that user ages are numeric and fall within the 0–120 range.
* **Country Validation:** Checked country values against the defined format rules.
* **Final Table:** cln_users was successfully created as the cleaned analytical source for further data transformation and BI reporting.

## Data Quality & Validation — ad_events / users referential integrity

### Validation Checks
The following validation checks were performed to confirm referential integrity
between `cln_ad_events` and `cln_users` before loading into Power BI:

- **Referential Integrity Check (ad_events → users):** Verified that every
  `user_id` referenced in `cln_ad_events` has a matching `user_id` in
  `cln_users`, using a LEFT JOIN and checking for NULL matches.
- **Orphan Record Count:** Counted the number of distinct `user_id` values
  present in `cln_ad_events` but missing from `cln_users` (initial result: 99
  orphan users, affecting thousands of event rows).
- **Source Verification:** Confirmed the same orphan `user_id` values existed
  in the raw BigQuery source tables, ruling out an export/cleaning artifact.

### Data Remediation
Rather than dropping the affected rows, a placeholder record was introduced
to preserve all event data:

- Added a single `'unknown'` placeholder row to `cln_users`, with all
  descriptive fields set to `'Unknown'`.
- Rebuilt `cln_ad_events`, remapping any `user_id` not found in `cln_users`
  to `'unknown'`.
- Rebuilt both tables using `CREATE OR REPLACE` to ensure the changes were
  materialized (not just previewed via `SELECT`).

### Results
- **Orphan users:** 0 (down from 99) — every `user_id` in `cln_ad_events`
  now resolves to a record in `cln_users`.
- **Placeholder integrity:** Exactly one `'unknown'` row exists in
  `cln_users`, confirming no accidental duplication from repeated table
  rebuilds.
- **Row counts:** Verified total row counts in both `cln_ad_events` and
  `cln_users` after rebuild to confirm no unintended row duplication or loss.
- **Additional relationship checks:** The same LEFT JOIN pattern was applied
  to confirm referential integrity for `ad_events → ads`, `ads → campaigns`,
  and `ad_events → calendar_table`, all returning 0 orphan records.
- **Final state:** `cln_ad_events`, `cln_ads`, `cln_campaigns`, `cln_users`,
  and `cln_calendar_table` are fully linked with no orphan keys and are
  ready to be loaded into Power BI as a star schema.

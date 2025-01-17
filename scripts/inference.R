# setup -------------------------------------------------------------------
# library(tableone)
# library(gt)
library(gtsummary)

# setup gtsummary theme
# theme_gtsummary_language(language = "pt") # traduzir
theme_gtsummary_mean_sd() # mean/sd

# tables ------------------------------------------------------------------

# trick to add Cohen's d to table from https://stackoverflow.com/questions/68721020/

inf_base <- analytical %>%
  # select variables for table
  select(let, sex, age, bmi, graft_diameter, fu_months, medial_meniscus, lateral_meniscus, cartilage, mtps) %>%
  # draw table
  tbl_summary(
    by = let,
    # fix graft_diameter as continuous (defaults to categorical, too few values)
    type = list(graft_diameter ~ "continuous")
  ) %>%
  # formatting options
  bold_labels() %>%
  # modify_table_styling(columns = "label", align = "c") %>%
  # include study N
  add_overall()

inf_diff <- inf_base %>%
  add_difference(test = all_continuous() ~ "cohens_d") %>%
  modify_header(estimate ~ '**d**')

inf_p <- inf_base %>%
  # comparisons
  add_p(
    # use Fisher test (defaults to chi-square)
    test = all_categorical() ~ "fisher.test",
    # use 3 digits in pvalue
    pvalue_fun = function(x) style_pvalue(x, digits = 3)
  ) %>%
  modify_column_hide(all_stat_cols())

inf_baseline <- tbl_merge(list(inf_diff, inf_p)) %>%
  modify_spanning_header(everything() ~ NA)

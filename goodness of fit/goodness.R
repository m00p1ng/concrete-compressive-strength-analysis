df <- read.csv('concrete.csv')

INTERVAL <- 10


generate_interval <- function(field, interval) {
  field_range_data <- range(field)
  field_range <- field_range_data[2] - field_range_data[1]
  
  avg_field_range <- field_range/interval
  
  min_range <- -Inf
  max_range <- field_range_data[1]
  min_interval <- c(-Inf)
  max_interval <- c(max_range)

  for (i in 3:interval) {
    min_range <- max_range
    max_range <- max_range + avg_field_range
    min_interval <- c(min_interval, min_range)
    max_interval <- c(max_interval, max_range)
  }
  min_interval <- c(min_interval, max_range)
  max_interval <- c(max_interval, Inf)
  return(cbind(min_interval, max_interval))
}


count_interval <- function(field, interval_range, interval) {
  count <- c()
  for(i in 1:interval) {
    count <- c(count, sum(field >= interval_range[i,1] & field < interval_range[i,2]))
  }
  return(count)
}


norm_expected_number <- function(field, interval_range, interval) {
  avg <- mean(field)
  std <- sd(field)
  total <- length(field)

  expected <- c()
  for(i in 1:interval) {
    exp <- total*(pnorm(interval_range[i, 2], avg, std) - pnorm(interval_range[i, 1], avg, std))
    expected <- c(expected, as.numeric(exp))
  }

  return(expected)
}


goodness_norm <- function(field, interval, sig) {
  interval_range <- generate_interval(field, interval)

  observed <- count_interval(field, interval_range, interval)
  expected <- norm_expected_number(field, interval_range, interval)
  testStat <- (observed-expected)^2/expected

  chisq.test(testStat)
}

goodness_norm(df$water, INTERVAL, 0.05)


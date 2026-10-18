// STA 172 (Statistical Computing I) - hand-set R questions, one idea per question.
const L = require('../sta/lib');
const { add, out } = L;
const T_B = 'R Basics and Vectors', T_I = 'Indexing and Vector Functions', T_M = 'Matrices in R', T_D = 'Data Frames and Data Structures', T_P = 'R Programming: Functions and Control Flow', T_S = 'Statistics with R', T_G = 'Graphics in R', T_R = 'Random Numbers and Distributions in R';

// ---- vectors and basic functions
add('In R, after `x <- c(4, 8, 15, 16, 23, 42)`, the value of `mean(x)` is:', 18, [15.5, 108, 16], 'The sum is 108 and there are 6 values, so the mean is 18.', T_S);
add('In R, the value of `median(c(7, 1, 9, 3, 5, 11))` is:', 6, [5, 7, 6.5], 'Sorted: 1, 3, 5, 7, 9, 11. With six values the median is (5 + 7)/2 = 6.', T_S);
add('In R, `round(sd(c(2, 4, 4, 4, 5, 5, 7, 9)), 2)` returns:', 2.14, [2, 4.57, 2.27], 'sd() uses the sample formula: √(32/7) = 2.138, which rounds to 2.14. (The population value would be 2.)', T_S);
add('In R, `var(c(1, 2, 3, 4, 5))` returns:', 2.5, [2, 1.58, 3], 'The sample variance is Σ(x − x̄)²/(n − 1) = 10/4 = 2.5.', T_S);
add('In R, `range(c(3, 9, 1, 7))` returns:', '1 9', ['8', '9 1', '3 7'], 'range() returns the minimum and the maximum, not their difference.', T_S);
add('In R, `sum(c(1, NA, 3), na.rm = TRUE)` returns:', 4, ['NA', 3, 1], 'na.rm = TRUE removes the missing value before summing, so the result is 1 + 3 = 4.', T_S);
add('In R, `sum(1:100)` returns:', 5050, [5000, 5051, 4950], 'The sum of the integers from 1 to 100 is 100 × 101/2 = 5050.', T_B);
add('In R, `seq(10, 50, length.out = 5)` returns:', '10 20 30 40 50', ['10 15 20 25 30', '10 50', '10 12 14 16 18'], 'length.out = 5 requests five equally spaced values from 10 to 50, so the step is 10.', T_B);
add('In R, `rev(1:5) * 2` returns:', '10 8 6 4 2', ['2 4 6 8 10', '5 4 3 2 1', '1 2 3 4 5'], 'rev() reverses 1:5 to 5 4 3 2 1 and each value is then doubled.', T_B);
add('In R, `cumsum(c(5, 3, 8, 1))` returns:', '5 8 16 17', ['5 3 8 1', '17', '5 15 23 24'], 'cumsum() gives running totals: 5, 5 + 3, 5 + 3 + 8, 5 + 3 + 8 + 1.', T_I);
add('In R, `rep(c("a", "b"), times = c(2, 3))` returns:', '"a" "a" "b" "b" "b"', ['"a" "b" "a" "b" "a"', '"a" "a" "b" "b"', '"b" "b" "a" "a" "a"'], 'times = c(2, 3) repeats the first element twice and the second three times.', T_B);
add('In R, `length(seq(0, 1, by = 0.25))` is:', 5, [4, 3, 6], 'The sequence is 0, 0.25, 0.5, 0.75, 1, which has 5 values.', T_B);
add('In R, `unique(c(1, 2, 2, 3, 3, 3))` returns:', '1 2 3', ['1 2 2 3 3 3', '3', '2 3'], 'unique() removes repeated values and keeps the first occurrence of each.', T_I);
add('In R, `which(c(5, 9, 2, 9) == 9)` returns:', '2 4', ['9 9', 'TRUE TRUE', '1 3'], 'which() returns the positions where the condition is TRUE: the 2nd and 4th elements.', T_I);
add('In R, after `x <- 1:10`, the value of `x[x %% 2 == 0]` is:', '2 4 6 8 10', ['1 3 5 7 9', '0 0 0 0 0', '2 4 6 8'], 'x %% 2 == 0 is TRUE for the even numbers, and logical indexing keeps those elements.', T_I);
add('In R, `5 %in% c(1, 5, 9)` returns:', 'TRUE', ['FALSE', '2', '5'], '%in% tests whether the left value is an element of the right-hand vector.', T_I);
add('In R, `ifelse(c(3, 8, 5) > 4, "high", "low")` returns:', '"low" "high" "high"', ['"high" "low" "low"', '"low" "high"', 'TRUE FALSE TRUE'], 'ifelse() tests each element: 3 > 4 is FALSE, 8 > 4 and 5 > 4 are TRUE.', T_P);

// ---- character data, types
add('In R, `paste("STA", 172)` returns:', '"STA 172"', ['"STA172"', '"STA-172"', '"172 STA"'], 'paste() joins its arguments with a single space as the default separator.', T_B);
add('In R, `paste0("Q", 1:3)` returns:', '"Q1" "Q2" "Q3"', ['"Q 1" "Q 2" "Q 3"', '"Q123"', '"Q" "1" "2" "3"'], 'paste0() joins with no separator and is vectorised over 1:3.', T_B);
add('In R, `nchar("Nsukka")` returns:', 6, [7, 5, 1], 'nchar() counts the characters: N, s, u, k, k, a.', T_B);
add('In R, `class(5L)` returns:', '"integer"', ['"numeric"', '"character"', '"logical"'], 'The suffix L makes the value an integer; 5 without it would be "numeric".', T_B);
add('In R, `as.numeric("3.5") + 1` returns:', 4.5, ['"3.51"', 'NA', 3.5], 'as.numeric() converts the text to the number 3.5, to which 1 is added.', T_B);
add('In R, `levels(factor(c("lo", "hi", "lo")))` returns:', '"hi" "lo"', ['"lo" "hi"', '"lo" "hi" "lo"', '2'], 'The levels of a factor are its distinct values in alphabetical order.', T_D);

// ---- matrices
add('In R, `m <- matrix(1:6, nrow = 2, byrow = TRUE)` creates a matrix. The value of `m[2, 1]` is:', 4, [2, 3, 5], 'byrow = TRUE fills the rows first: row 1 is 1 2 3 and row 2 is 4 5 6, so m[2, 1] = 4.', T_M);
add('In R, `dim(t(matrix(1:6, nrow = 2)))` returns:', '3 2', ['2 3', '6 1', '1 6'], 'The original matrix is 2 × 3; its transpose is 3 × 2.', T_M);
add('In R, `A <- matrix(1:4, nrow = 2)` and `A %*% c(1, 1)` returns:', '4 6', ['3 7', '10', '1 4'], 'A has rows (1, 3) and (2, 4). Multiplying by (1, 1) gives 1 + 3 = 4 and 2 + 4 = 6.', T_M);
add('In R, `apply(matrix(1:6, nrow = 2), 1, sum)` returns:', '9 12', ['3 7 11', '21', '6 15'], 'MARGIN = 1 works across rows. Row 1 is 1, 3, 5 (sum 9) and row 2 is 2, 4, 6 (sum 12).', T_M);
add('In R, `colMeans(matrix(1:6, nrow = 2))` returns:', '1.5 3.5 5.5', ['3.5', '2 4 6', '1.5 2.5 3.5'], 'The columns are (1, 2), (3, 4), (5, 6) with means 1.5, 3.5 and 5.5.', T_M);
add('In R, `diag(2)` returns:', 'The 2 × 2 identity matrix', ['A 2 × 2 matrix of zeros', 'A 2 × 2 matrix of ones', 'The number 2'], 'diag(n) with a single whole number creates the n × n identity matrix.', T_M);

// ---- data frames and functions
add('In R, `df <- data.frame(x = 1:4, y = c(2, 4, 6, 8))`. The value of `mean(df$y)` is:', 5, [2.5, 20, 4], 'df$y selects the column y, whose values 2, 4, 6, 8 have mean 5.', T_D);
add('In R, with `df <- data.frame(x = 1:4, y = c(2, 4, 6, 8))`, the expression `df[df$x > 2, "y"]` returns:', '6 8', ['3 4', '2 4', '3 4 6 8'], 'Rows where x > 2 are the 3rd and 4th, and the column y holds 6 and 8 there.', T_D);
add('In R, `head(df, 3)` returns:', 'The first three rows of the data frame df', ['The last three rows of df', 'The first three columns of df', 'A random sample of three rows'], 'head() shows the beginning of an object; tail() shows the end.', T_D);
add('In R, which function gives a compact summary of the structure of a data frame, including the type of each column?', 'str(df)', ['dim(df)', 'names(df)', 'length(df)'], 'str() lists the number of observations and variables and the type of each variable.', T_D);
add('In R, `table(c("a", "b", "a", "c", "a"))` shows that the value "a" occurs:', 3, [1, 2, 5], 'table() counts occurrences: "a" appears three times.', T_D);
add('In R, `sq <- function(n) n^2` is defined. The value of `sq(7)` is:', 49, [14, 77, 9], 'The function squares its argument: 7² = 49.', T_P);
add('In R, `f <- function(x, p = 2) x^p` is defined. The values of `f(3)` and `f(3, 3)` are respectively:', '9 and 27', ['6 and 9', '9 and 9', '27 and 27'], 'The default p = 2 gives 3² = 9; supplying p = 3 gives 3³ = 27.', T_P);
add('In R, `s <- 0; for (i in 1:5) if (i %% 2 == 0) s <- s + i` leaves `s` equal to:', 6, [15, 9, 3], 'Only the even values 2 and 4 are added: 2 + 4 = 6.', T_P);
add('In R, `sapply(c(1, 2, 3), function(v) v * 10)` returns:', '10 20 30', ['60', '1 2 3', '10 10 10'], 'sapply() applies the function to each element and simplifies the result to a vector.', T_P);

// ---- distributions and random numbers
add('In R, `round(pnorm(1.96), 3)` returns:', 0.975, [0.95, 0.025, 1.96], 'pnorm() is the cumulative standard normal probability: P(Z ≤ 1.96) = 0.975.', T_R);
add('In R, `dbinom(0, size = 3, prob = 0.5)` returns:', 0.125, [0.5, 0.375, 0.25], 'P(X = 0) = (0.5)³ = 0.125.', T_R);
add('In R, `round(ppois(0, 2), 4)` returns:', 0.1353, [0.2707, 0.8647, 0.3679], 'ppois(0, 2) = P(X ≤ 0) = e⁻² = 0.1353.', T_R);
add('In R, `qnorm(0.5)` returns:', 0, [0.5, 1, -1], 'qnorm() gives the quantile; the median of the standard normal distribution is 0.', T_R);
add('In R, `x <- rnorm(10000)` is run. The value of `mean(x)` will be:', 'Close to 0', ['Exactly 0', 'Close to 1', 'Close to 10000'], 'The sample mean of many standard normal values is close to, but not exactly, the true mean 0.', T_R);
add('In R, `sample(1:6, 1)` can return:', 'Any whole number from 1 to 6', ['Only the number 6', 'A decimal between 1 and 6', 'The vector 1 2 3 4 5 6'], 'sample() draws a random element; with size 1 it returns one of the integers 1 to 6.', T_R);
add('In R, running `set.seed(2026)` before `rnorm(3)` ensures that:', 'The same three numbers are produced each time the code is run', ['The numbers are all positive', 'The numbers have mean exactly 0', 'The numbers are different every time'], 'The seed fixes the state of the random number generator, so results are reproducible.', T_R);

// ---- correlation and regression
add('In R, `cor(1:5, c(2, 4, 6, 8, 10))` returns:', 1, [0.5, 0, 2], 'The second vector is an exact increasing linear function of the first, so the correlation is 1.', T_S);
add('In R, `cor(1:5, 5:1)` returns:', -1, [0, 1, -5], 'The two variables are exactly reversed, which gives a perfect negative correlation.', T_S);
add('In R, `coef(lm(y ~ x))` is run with `x <- 1:4` and `y <- c(3, 5, 7, 9)`. The intercept and slope are respectively:', '1 and 2', ['2 and 1', '3 and 2', '1 and 3'], 'The points lie exactly on y = 1 + 2x, so lm() returns intercept 1 and slope 2.', T_S);
add('In R, `quantile(1:9, 0.5)` returns:', 5, [4.5, 9, 0.5], 'The 0.5 quantile is the median of 1 to 9, which is 5.', T_S);

// ---- graphics, files and help
add('In R, which function draws a histogram of a numeric vector x?', 'hist(x)', ['barplot(x)', 'plot(x, type = "h")', 'boxplot(x)'], 'hist() groups the values into classes and plots their frequencies.', T_G);
add('In R, which command adds the fitted regression line of `lm(y ~ x)` to an existing scatter plot?', 'abline(lm(y ~ x))', ['line(lm(y ~ x))', 'plot(lm(y ~ x))', 'fit(lm(y ~ x))'], 'abline() adds a straight line to the current plot and accepts a fitted lm object.', T_G);
add('In R, `par(mfrow = c(1, 2))` is used to:', 'Place two plots side by side in the same window', ['Draw a plot with two rows of points', 'Save two plots to a file', 'Set the colour of the plot to two shades'], 'mfrow = c(1, 2) arranges plots in 1 row and 2 columns.', T_G);
add('In R, which argument of `plot()` labels the horizontal axis?', 'xlab', ['xlim', 'main', 'col'], 'xlab sets the x-axis label; xlim sets its range and main sets the title.', T_G);
add('In R, which function reads a comma-separated file called "scores.csv" into a data frame?', 'read.csv("scores.csv")', ['load.csv("scores.csv")', 'open("scores.csv")', 'data.read("scores.csv")'], 'read.csv() reads CSV files into a data frame.', T_D);
add('In R, which function shows the folder in which R is currently working?', 'getwd()', ['setwd()', 'dir.show()', 'path()'], 'getwd() returns the working directory; setwd() changes it.', T_B);

module.exports = out;

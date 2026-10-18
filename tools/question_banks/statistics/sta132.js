// STA 132 (Inference II) - hand-set questions, one idea per question, no repeated templates.
const L = require('../sta/lib');
const { f, add, out } = L;
const T_SIG = 'Tests of Significance', T_REG = 'Simple Linear Regression', T_COR = 'Correlation', T_ANOVA = 'One-Way ANOVA', T_DES = 'Experimental Designs', T_CI = 'Confidence Intervals', T_TS = 'Time Series Analysis';

// ---- analysis of variance
add('In a one-way ANOVA with 4 treatment groups and 24 observations, SSB = 120 and SSW = 270. The F statistic is approximately:', '2.96', ['0.44', '1.50', '8.89'], 'MSB = 120/(4 − 1) = 40; MSW = 270/(24 − 4) = 13.5; F = 40/13.5 = 2.96.', T_ANOVA);
add('A one-way ANOVA on 30 observations from 3 groups has total sum of squares 500 and between-groups sum of squares 200. The mean square error is approximately:', '11.11', ['10.00', '100.00', '15.00'], 'SSW = 500 − 200 = 300 with 30 − 3 = 27 degrees of freedom: MSW = 300/27 = 11.11.', T_ANOVA);
add('In a one-way ANOVA with 3 groups and 15 observations altogether, the degrees of freedom of the F statistic are:', '2 and 12', ['3 and 15', '2 and 14', '12 and 2'], 'Numerator df = k − 1 = 2; denominator df = N − k = 12.', T_ANOVA);
add('The null hypothesis tested in a one-way ANOVA is that:', 'All the population means are equal', ['All the sample means are equal', 'All the population variances are different', 'At least two population means are equal'], 'H₀: μ₁ = μ₂ = … = μₖ against the alternative that at least one mean differs.', T_ANOVA);
add('An ANOVA F test gives a p-value of 0.01. At the 5% level the correct conclusion is that:', 'At least one population mean differs from the others', ['All the population means are equal', 'All the sample means are different', 'The variances are unequal'], 'Since p < 0.05, H₀ of equal means is rejected.', T_ANOVA);
add('After a significant one-way ANOVA, which procedure is used to find which pairs of means differ?', 'A multiple comparison test such as Tukey\'s HSD or the LSD test', ['A chi-square test of independence', 'A paired t test on all the data', 'A test of the correlation coefficient'], 'ANOVA only shows that some difference exists; multiple comparison tests locate it.', T_ANOVA);
add('Why is a one-way ANOVA used instead of several separate t tests when comparing more than two means?', 'Repeated t tests inflate the overall probability of a Type I error', ['t tests cannot be used with equal sample sizes', 'ANOVA gives a smaller p-value', 'ANOVA does not need any assumptions'], 'Each extra test adds a chance of a false rejection; ANOVA controls the overall error rate.', T_ANOVA);
add('Which of the following is an assumption of the one-way ANOVA F test?', 'The populations have equal variances', ['The sample sizes must all be different', 'The data must be perfectly symmetric', 'The population means must be equal'], 'The usual assumptions are independence, normality and homogeneity of variance.', T_ANOVA);
add('The total sum of squares in an ANOVA equals:', 'The sum of the between-groups and within-groups sums of squares', ['The between-groups sum of squares minus the within-groups sum of squares', 'The product of the two sums of squares', 'The sum of the two mean squares'], 'SST = SSB + SSW.', T_ANOVA);

// ---- designs
add('In a completely randomised design with 5 treatments and 4 replicates of each, the error degrees of freedom are:', 15, [19, 16, 4], 'Total df = 20 − 1 = 19; treatment df = 4; error df = 19 − 4 = 15.', T_DES);
add('In a randomised complete block design with 4 treatments and 5 blocks, the error degrees of freedom are:', 12, [19, 15, 20], 'Error df = (t − 1)(b − 1) = 3 × 4 = 12.', T_DES);
add('In a 4 × 4 Latin square design, the error degrees of freedom are:', 6, [9, 15, 3], 'Error df = (t − 1)(t − 2) = 3 × 2 = 6.', T_DES);
add('The main purpose of blocking in a randomised complete block design is to:', 'Remove variation due to a known nuisance factor from the experimental error', ['Increase the number of treatments', 'Make the treatment means equal', 'Avoid the use of randomisation'], 'Blocks group similar units so that between-block variation is separated from error.', T_DES);
add('Randomisation in an experiment is carried out mainly to:', 'Avoid systematic bias in the allocation of treatments to units', ['Make all treatment means equal', 'Reduce the number of replicates needed', 'Guarantee a significant result'], 'Random allocation protects the comparison from unknown sources of bias.', T_DES);

// ---- regression and correlation
add('For the data points (1, 3), (2, 5), (3, 4), (4, 8), (5, 10), the least-squares slope of the regression line of y on x is:', '1.7', ['0.9', '2.0', '1.0'], 'x̄ = 3 and ȳ = 6. Sxy = 17 and Sxx = 10, so b = 17/10 = 1.7.', T_REG);
add('For the data points (1, 3), (2, 5), (3, 4), (4, 8), (5, 10), the least-squares line is ŷ = a + bx with b = 1.7. The intercept a is:', '0.9', ['6.0', '1.7', '5.1'], 'a = ȳ − b x̄ = 6 − 1.7(3) = 0.9.', T_REG);
add('For the regression line ŷ = 0.9 + 1.7x, the predicted value of y when x = 6 is:', '11.1', ['10.2', '12.0', '1.7'], 'ŷ = 0.9 + 1.7(6) = 11.1.', T_REG);
add('For the data points (1, 3), (2, 5), (3, 4), (4, 8), (5, 10), the correlation coefficient is approximately:', '0.92', ['0.85', '1.70', '0.50'], 'Sxy = 17, Sxx = 10 and Syy = 34, so r = 17/√(10 × 34) = 0.92.', T_COR);
add('If the correlation coefficient between two variables is r = −0.8, the coefficient of determination is:', '0.64', ['−0.64', '0.80', '0.20'], 'R² = r² = (−0.8)² = 0.64.', T_COR);
add('A regression analysis gives SSR = 64 and SST = 100. The coefficient of determination is:', '0.64', ['0.36', '1.56', '0.80'], 'R² = SSR/SST = 64/100 = 0.64: 64% of the variation in y is explained by x.', T_REG);
add('In a regression of y on x, an observed value is 25 while the fitted value is 22. The residual is:', 3, [-3, 47, 22], 'Residual = observed − fitted = 25 − 22 = 3.', T_REG);
add('In a simple linear regression based on 12 observations, the slope has estimate 2.4 and standard error 0.8. The t statistic for H₀: β = 0 and its degrees of freedom are:', 't = 3.0 with 10 degrees of freedom', ['t = 3.0 with 12 degrees of freedom', 't = 0.33 with 10 degrees of freedom', 't = 1.92 with 11 degrees of freedom'], 't = 2.4/0.8 = 3.0, with n − 2 = 10 degrees of freedom.', T_REG);
add('The Spearman rank correlation between two sets of five ranks gives Σd² = 4. The value of the coefficient is:', '0.8', ['0.2', '0.96', '0.5'], 'r_s = 1 − 6Σd²/[n(n² − 1)] = 1 − 24/120 = 0.8.', T_COR);
add('If 5 is added to every value of x and the values of y are unchanged, the correlation coefficient between x and y:', 'Remains unchanged', ['Increases by 5', 'Becomes zero', 'Changes sign'], 'The correlation coefficient is unaffected by shifting the origin of either variable.', T_COR);
add('Using a fitted regression line to predict y for a value of x far outside the range of the observed data is called:', 'Extrapolation, which may be unreliable', ['Interpolation, which is always safe', 'Residual analysis', 'Blocking'], 'The linear relationship may not hold outside the observed range.', T_REG);
add('The least-squares regression line is chosen so that it:', 'Minimises the sum of the squared vertical deviations of the points from the line', ['Passes through the first and last points', 'Minimises the sum of the horizontal deviations', 'Has a slope of 1'], 'This is the least-squares criterion Σ(y − ŷ)² minimum.', T_REG);

// ---- chi-square and other tests
add('A die is rolled 60 times and the faces 1 to 6 appear 8, 12, 9, 11, 10 and 10 times. For a test that the die is fair, the chi-square statistic is:', '1.0', ['0.5', '2.0', '10.0'], 'The expected count for each face is 10. χ² = (4 + 4 + 1 + 1 + 0 + 0)/10 = 1.0, with 5 degrees of freedom.', T_SIG);
add('In a 2 × 2 table the observed counts are 30 and 20 in the first row and 20 and 30 in the second row. The chi-square statistic for independence is:', '4.0', ['2.0', '1.0', '8.0'], 'Every expected count is 25. χ² = 4 × (5²/25) = 4.0 with 1 degree of freedom, which exceeds the 5% critical value 3.84.', T_SIG);
add('In a contingency table the first row total is 70, the first column total is 40 and the grand total is 200. The expected count of the first cell is:', 14, [28, 35, 20], 'E = (70 × 40)/200 = 14.', T_SIG);
add('For the chi-square test of independence on a table with 3 rows and 4 columns, the degrees of freedom are:', 6, [12, 11, 7], 'df = (3 − 1)(4 − 1) = 6.', T_SIG);
add('A chi-square test is considered reliable only if:', 'Every expected frequency is at least about 5', ['Every observed frequency is below 5', 'The sample size is exactly 30', 'The row totals are equal'], 'Small expected counts make the chi-square approximation poor.', T_SIG);
add('Two large independent samples give x̄₁ = 78 (n₁ = 40, σ₁ = 10) and x̄₂ = 72 (n₂ = 50, σ₂ = 12). The z statistic for H₀: μ₁ = μ₂ is approximately:', '2.59', ['0.50', '6.00', '1.29'], 'SE = √(100/40 + 144/50) = √5.38 = 2.32; z = 6/2.32 = 2.59.', T_SIG);
add('Two independent samples have n₁ = 10, s₁² = 16 and n₂ = 15, s₂² = 25. The pooled variance is approximately:', '21.48', ['20.50', '41.00', '4.63'], 'sp² = [9(16) + 14(25)]/(10 + 15 − 2) = 494/23 = 21.48.', T_SIG);
add('To test equality of two variances, s₁² = 36 (from 11 observations) is compared with s₂² = 9 (from 9 observations). The F statistic and its degrees of freedom are:', 'F = 4 with (10, 8) degrees of freedom', ['F = 4 with (11, 9) degrees of freedom', 'F = 0.25 with (8, 10) degrees of freedom', 'F = 27 with (10, 8) degrees of freedom'], 'F = 36/9 = 4, with n₁ − 1 = 10 and n₂ − 1 = 8 degrees of freedom.', T_SIG);
add('The difference between two sample means is 5 and its standard error is 2. The 95% confidence interval for the difference between the population means is approximately:', '(1.08, 8.92)', ['(3.00, 7.00)', '(−1.08, 11.08)', '(2.50, 7.50)'], '5 ± 1.96 × 2 = 5 ± 3.92.', T_CI);
add('Before-and-after weights of the same 20 people are analysed with a paired t test. The degrees of freedom are:', 19, [38, 20, 18], 'The test uses the 20 differences, so df = n − 1 = 19.', T_SIG);

// ---- time series
add('A time series has the values 12, 15, 18, 21, 24. The first three-point moving average is:', 15, [12, 18, 45], '(12 + 15 + 18)/3 = 15.', T_TS);
add('The trend equation of a series is ŷ = 50 + 4t. The forecast for t = 10 is:', 90, [54, 40, 104], 'ŷ = 50 + 4(10) = 90.', T_TS);
add('In the additive model of a time series, an observation is expressed as:', 'Y = T + S + C + I', ['Y = T × S × C × I', 'Y = T + S × C × I', 'Y = (T + S)/(C + I)'], 'The additive model sums the trend, seasonal, cyclical and irregular components.', T_TS);

module.exports = out;

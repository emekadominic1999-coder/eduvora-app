-- Probability and distribution theory questions (UNN Statistics)
-- =============================================================================
-- 63 original questions on set theory and counting, probability and Bayes theorem,
-- random variables and expectation, discrete and continuous distributions, moment generating
-- functions, limit theorems and Markov chains, following the topic order of the department's
-- probability and distribution theory textbook. Every answer was computed and checked.
-- Added to the existing STA 112 (Introductory Probability) paper if there is one. ADDS ONLY,
-- repeats are skipped.
-- =============================================================================
with src (question, options, correct_index, explanation, topic) as (
values
  ('If $n(A) = 25$, $n(B) = 18$ and $n(A\cap B) = 7$, then $n(A\cup B)$ is:', '["$36$","$43$","$50$","$25$"]'::jsonb, 0, '$n(A\cup B) = n(A) + n(B) - n(A\cap B) = 25 + 18 - 7 = 36$.', 'Set Theory and Counting'),
  ('If $A = \{1,2,3,4\}$ and $B = \{3,4,5\}$, the number of elements in the Cartesian product $A\times B$ is:', '["$7$","$12$","$5$","$9$"]'::jsonb, 1, '$n(A\times B) = n(A)\,n(B) = 4\times3 = 12$.', 'Set Theory and Counting'),
  ('How many subsets does a set with $6$ elements have?', '["$36$","$12$","$64$","$32$"]'::jsonb, 2, 'A set of $n$ elements has $2^{n}$ subsets, so $2^{6} = 64$.', 'Set Theory and Counting'),
  ('The complement of $A\cup B$ equals, by De Morgan''s law:', '["$A''\\cup B''$","$A\\cap B$","$(A\\cap B)''\\cup A$","$A''\\cap B''$"]'::jsonb, 3, 'De Morgan: $(A\cup B)'' = A''\cap B''$.', 'Set Theory and Counting'),
  ('In how many ways can a chairman, a secretary and a treasurer be chosen from $7$ members, if no member holds two posts?', '["$210$","$35$","$343$","$21$"]'::jsonb, 0, 'Order matters: $^{7}P_{3} = 7\times6\times5 = 210$.', 'Set Theory and Counting'),
  ('In how many ways can a committee of $4$ be selected from $10$ people?', '["$5040$","$210$","$40$","$10\\,000$"]'::jsonb, 1, 'Order does not matter: $^{10}C_{4} = 10!/(4!\,6!) = 210$.', 'Set Theory and Counting'),
  ('How many different arrangements of the letters of the word STATISTICS are there?', '["$3\\,628\\,800$","$151\\,200$","$50\\,400$","$10\\,080$"]'::jsonb, 2, 'The word has $10$ letters with S three times, T three times, I twice. $10!/(3!\,3!\,2!) = 3\,628\,800/72 = 50\,400$.', 'Set Theory and Counting'),
  ('Evaluate $\binom{8}{3}$.', '["$336$","$24$","$28$","$56$"]'::jsonb, 3, '$\binom{8}{3} = \dfrac{8\cdot7\cdot6}{3\cdot2\cdot1} = 56$.', 'Set Theory and Counting'),
  ('The binomial coefficients satisfy $\binom{n}{r} = \binom{n}{n-r}$. Hence $\binom{12}{9}$ equals:', '["$220$","$1320$","$84$","$55$"]'::jsonb, 0, '$\binom{12}{9} = \binom{12}{3} = \dfrac{12\cdot11\cdot10}{6} = 220$.', 'Set Theory and Counting'),
  ('In how many ways can $6$ people be seated around a circular table?', '["$720$","$120$","$60$","$24$"]'::jsonb, 1, 'Circular arrangements of $n$ objects number $(n-1)! = 5! = 120$.', 'Set Theory and Counting'),
  ('A coin is tossed three times. How many outcomes are in the sample space?', '["$6$","$9$","$8$","$3$"]'::jsonb, 2, 'Each toss has $2$ outcomes, so $2^{3} = 8$ by the multiplication principle.', 'Set Theory and Counting'),
  ('Two fair dice are thrown. The probability that the sum is $9$ is:', '["$1/6$","$5/36$","$1/12$","$1/9$"]'::jsonb, 3, 'The sum $9$ occurs in $4$ ways, namely $(3,6), (4,5), (5,4), (6,3)$ out of $36$. So $P = 4/36 = 1/9$.', 'Probability and Bayes Theorem'),
  ('A card is drawn from a well-shuffled pack of $52$. The probability that it is a king or a heart is:', '["$4/13$","$17/52$","$1/2$","$5/13$"]'::jsonb, 0, '$P(K\cup H) = 4/52 + 13/52 - 1/52 = 16/52 = 4/13$.', 'Probability and Bayes Theorem'),
  ('If $P(A) = 0.5$, $P(B) = 0.4$ and $P(A\cap B) = 0.2$, then $P(A\cup B)$ is:', '["$0.9$","$0.7$","$0.8$","$0.6$"]'::jsonb, 1, '$P(A\cup B) = 0.5 + 0.4 - 0.2 = 0.7$.', 'Probability and Bayes Theorem'),
  ('If $A$ and $B$ are independent with $P(A) = 0.3$ and $P(B) = 0.6$, then $P(A\cap B)$ is:', '["$0.9$","$0.36$","$0.18$","$0.30$"]'::jsonb, 2, 'For independent events $P(A\cap B) = P(A)P(B) = 0.3\times0.6 = 0.18$.', 'Probability and Bayes Theorem'),
  ('If $P(A) = 0.6$, $P(B) = 0.5$ and $P(A\cap B) = 0.3$, then $P(A\mid B)$ is:', '["$0.5$","$0.3$","$0.18$","$0.6$"]'::jsonb, 3, '$P(A\mid B) = P(A\cap B)/P(B) = 0.3/0.5 = 0.6$. Since this equals $P(A)$, the events are independent.', 'Probability and Bayes Theorem'),
  ('A box has $4$ red and $6$ blue balls. Two balls are drawn without replacement. The probability that at least one is red is:', '["$2/3$","$2/5$","$4/15$","$1/3$"]'::jsonb, 0, '$P(\text{no red}) = (6/10)(5/9) = 1/3$. So $P(\text{at least one red}) = 1 - 1/3 = 2/3$.', 'Probability and Bayes Theorem'),
  ('Machine A makes $60\%$ of items with $2\%$ defective, and machine B makes $40\%$ with $5\%$ defective. An item is found defective. The probability that it came from machine A is:', '["$0.6$","$0.375$","$0.02$","$0.625$"]'::jsonb, 1, 'Bayes: $P(A\mid D) = \dfrac{(0.02)(0.6)}{(0.02)(0.6) + (0.05)(0.4)} = \dfrac{0.012}{0.032} = 0.375$.', 'Probability and Bayes Theorem'),
  ('A disease affects $1\%$ of a population. A test is positive for $95\%$ of sick people and for $4\%$ of healthy people. If a person tests positive, the probability of being sick is about:', '["$0.95$","$0.50$","$0.19$","$0.04$"]'::jsonb, 2, '$P(S\mid +) = \dfrac{(0.95)(0.01)}{(0.95)(0.01) + (0.04)(0.99)} = \dfrac{0.0095}{0.0491} \approx 0.19$.', 'Probability and Bayes Theorem'),
  ('Two events are mutually exclusive with $P(A) = 0.3$ and $P(B) = 0.45$. Then $P(A\cup B)$ is:', '["$0.135$","$0.15$","$0.65$","$0.75$"]'::jsonb, 3, 'For mutually exclusive events $P(A\cup B) = P(A) + P(B) = 0.75$.', 'Probability and Bayes Theorem'),
  ('Which statement is true of two events $A$ and $B$ with positive probabilities that are mutually exclusive?', '["They cannot be independent","They are always independent","They are independent only if $P(A) = P(B)$","Their union has probability $1$"]'::jsonb, 0, 'If they are mutually exclusive, $P(A\cap B) = 0\neq P(A)P(B) > 0$, so they cannot be independent.', 'Probability and Bayes Theorem'),
  ('A fair die is thrown $4$ times. The probability of getting at least one six is about:', '["$0.667$","$0.518$","$0.482$","$0.167$"]'::jsonb, 1, '$P = 1 - (5/6)^{4} = 1 - 0.4823 = 0.518$.', 'Probability and Bayes Theorem'),
  ('A random variable $X$ takes values $1, 2, 3, 4$ with probabilities $0.1, 0.3, 0.4, 0.2$. Its expected value is:', '["$2.5$","$3.0$","$2.7$","$2.4$"]'::jsonb, 2, '$E(X) = 1(0.1) + 2(0.3) + 3(0.4) + 4(0.2) = 0.1 + 0.6 + 1.2 + 0.8 = 2.7$.', 'Random Variables and Expectation'),
  ('For the same distribution ($1, 2, 3, 4$ with probabilities $0.1, 0.3, 0.4, 0.2$) the variance of $X$ is:', '["$8.1$","$0.90$","$7.29$","$0.81$"]'::jsonb, 3, '$E(X^{2}) = 0.1 + 1.2 + 3.6 + 3.2 = 8.1$. $\text{Var}(X) = 8.1 - 2.7^{2} = 0.81$.', 'Random Variables and Expectation'),
  ('If $E(X) = 5$ and $\text{Var}(X) = 4$, then $E(3X + 2)$ and $\text{Var}(3X + 2)$ are:', '["$17\\text{ and }36$","$17\\text{ and }12$","$15\\text{ and }36$","$17\\text{ and }38$"]'::jsonb, 0, '$E(aX + b) = aE(X) + b = 17$. $\text{Var}(aX + b) = a^{2}\text{Var}(X) = 9\times4 = 36$.', 'Random Variables and Expectation'),
  ('The function $f(x) = kx$ for $0\le x\le 2$ (and zero elsewhere) is a probability density function when $k$ equals:', '["$1$","$1/2$","$2$","$1/4$"]'::jsonb, 1, '$\int_{0}^{2}kx\,dx = 2k = 1$, so $k = 1/2$.', 'Random Variables and Expectation'),
  ('A random variable has density $f(x) = x/2$ for $0\le x\le 2$. Its mean is:', '["$1$","$2/3$","$4/3$","$3/2$"]'::jsonb, 2, '$E(X) = \int_{0}^{2}x\cdot\dfrac{x}{2}\,dx = \dfrac{1}{2}\cdot\dfrac{8}{3} = \dfrac{4}{3}$.', 'Random Variables and Expectation'),
  ('For any random variable $X$ with finite variance, $\text{Var}(X)$ equals:', '["$E(X^{2}) + [E(X)]^{2}$","$[E(X)]^{2} - E(X^{2})$","$E[(X)^{2}]\\,E(X)$","$E(X^{2}) - [E(X)]^{2}$"]'::jsonb, 3, 'From $E[(X-\mu)^{2}] = E(X^{2}) - 2\mu E(X) + \mu^{2} = E(X^{2}) - \mu^{2}$.', 'Random Variables and Expectation'),
  ('If $X$ and $Y$ are independent with $\text{Var}(X) = 3$ and $\text{Var}(Y) = 5$, then $\text{Var}(2X - Y)$ is:', '["$17$","$1$","$7$","$11$"]'::jsonb, 0, '$\text{Var}(2X - Y) = 4\text{Var}(X) + \text{Var}(Y) = 12 + 5 = 17$ (the sign of $Y$ does not matter).', 'Random Variables and Expectation'),
  ('A fair coin is tossed $10$ times. The probability of exactly $3$ heads is:', '["$0.3000$","$0.1172$","$0.2051$","$0.0439$"]'::jsonb, 1, '$P(X = 3) = \binom{10}{3}(0.5)^{10} = 120/1024 = 0.1172$.', 'Discrete Distributions'),
  ('For a binomial distribution with $n = 20$ and $p = 0.3$, the mean and variance are:', '["$6\\text{ and }6$","$4.2\\text{ and }6$","$6\\text{ and }4.2$","$14\\text{ and }4.2$"]'::jsonb, 2, '$\mu = np = 6$ and $\sigma^{2} = npq = 20(0.3)(0.7) = 4.2$.', 'Discrete Distributions'),
  ('A machine produces $10\%$ defective items. In a sample of $5$ items, the probability that at least $2$ are defective is about:', '["$0.328$","$0.591$","$0.410$","$0.082$"]'::jsonb, 3, '$1 - P(0) - P(1) = 1 - 0.9^{5} - 5(0.1)(0.9)^{4} = 1 - 0.5905 - 0.3281 = 0.0815$.', 'Discrete Distributions'),
  ('A shooter hits a target with probability $0.2$ on each independent shot. The probability that the first hit occurs on the fourth shot is:', '["$0.1024$","$0.0016$","$0.4096$","$0.2$"]'::jsonb, 0, 'Geometric: $P(X = 4) = (0.8)^{3}(0.2) = 0.512\times0.2 = 0.1024$.', 'Discrete Distributions'),
  ('For a geometric distribution with success probability $p$ (counting trials up to and including the first success), the mean is:', '["$p$","$1/p$","$(1-p)/p^{2}$","$1/(1-p)$"]'::jsonb, 1, '$E(X) = \sum k(1-p)^{k-1}p = 1/p$.', 'Discrete Distributions'),
  ('Calls arrive at a switchboard as a Poisson process with mean $3$ per minute. The probability of exactly $2$ calls in a minute is:', '["$0.149$","$0.050$","$0.224$","$0.423$"]'::jsonb, 2, '$P(X = 2) = e^{-3}3^{2}/2! = 0.0498\times4.5 = 0.224$.', 'Discrete Distributions'),
  ('For a Poisson random variable with mean $2$, $P(X\ge 2)$ is about:', '["$0.406$","$0.271$","$0.135$","$0.594$"]'::jsonb, 3, '$P(X\ge2) = 1 - e^{-2}(1 + 2) = 1 - 0.4060 = 0.594$.', 'Discrete Distributions'),
  ('For a Poisson distribution, the mean and the variance are:', '["equal","the variance is the square of the mean","the mean is the square of the variance","always $1$ and $\\lambda$"]'::jsonb, 0, 'If $X\sim\text{Poisson}(\lambda)$ then $E(X) = \text{Var}(X) = \lambda$.', 'Discrete Distributions'),
  ('A box has $4$ red and $6$ blue balls. Three are drawn without replacement. The probability of exactly $2$ red is:', '["$0.288$","$0.3$","$0.4$","$0.2$"]'::jsonb, 1, 'Hypergeometric: $\dbinom{4}{2}\dbinom{6}{1}/\dbinom{10}{3} = 36/120 = 0.3$.', 'Discrete Distributions'),
  ('A fair coin is tossed until the third head appears. The probability that this happens on the sixth toss is:', '["$0.3125$","$0.0625$","$0.15625$","$0.20$"]'::jsonb, 2, 'Negative binomial: $\binom{5}{2}(0.5)^{3}(0.5)^{3} = 10/64 = 0.15625$.', 'Discrete Distributions'),
  ('The probability mass function of a discrete uniform distribution on $\{1, 2, \ldots, n\}$ has mean:', '["$n/2$","$n(n+1)/2$","$(n-1)/2$","$(n+1)/2$"]'::jsonb, 3, '$E(X) = \dfrac{1}{n}\sum_{k=1}^{n}k = \dfrac{n+1}{2}$.', 'Discrete Distributions'),
  ('A Bernoulli random variable with success probability $p$ has variance:', '["$p(1-p)$","$p$","$p^{2}$","$1-p^{2}$"]'::jsonb, 0, '$E(X) = p$ and $E(X^{2}) = p$, so $\text{Var}(X) = p - p^{2} = p(1-p)$.', 'Discrete Distributions'),
  ('For a standard normal variable $Z$, $P(-1 < Z < 1)$ is about:', '["$0.954$","$0.683$","$0.500$","$0.841$"]'::jsonb, 1, 'About $68.3\%$ of the area lies within one standard deviation of the mean.', 'Continuous Distributions'),
  ('Test scores are normal with mean $50$ and standard deviation $10$. The probability that a score exceeds $65$ is about:', '["$0.933$","$0.159$","$0.067$","$0.500$"]'::jsonb, 2, '$z = (65 - 50)/10 = 1.5$. $P(Z > 1.5) = 1 - 0.9332 = 0.0668$.', 'Continuous Distributions'),
  ('If $X\sim N(50, 10^{2})$, then $P(45 < X < 60)$ is about:', '["$0.341$","$0.691$","$0.841$","$0.533$"]'::jsonb, 3, '$z$ runs from $-0.5$ to $1$. $P = 0.8413 - 0.3085 = 0.5328$.', 'Continuous Distributions'),
  ('If $X\sim N(\mu, \sigma^{2})$, then $Z = (X - \mu)/\sigma$ has:', '["a standard normal distribution with mean $0$ and variance $1$","a normal distribution with mean $\\mu$","a chi-square distribution","a uniform distribution"]'::jsonb, 0, 'Standardising shifts the mean to $0$ and scales the standard deviation to $1$.', 'Continuous Distributions'),
  ('The lifetime of a component is exponential with mean $2$ years. The probability that it lasts more than $4$ years is:', '["$0.865$","$0.135$","$0.368$","$0.5$"]'::jsonb, 1, 'With rate $\lambda = 1/2$, $P(X > 4) = e^{-\lambda t} = e^{-2} = 0.135$.', 'Continuous Distributions'),
  ('The exponential distribution has the memoryless property:', '["$P(X > s + t) = P(X > s) + P(X > t)$","$P(X > s + t\\mid X > s) = P(X > s)$","$P(X > s + t\\mid X > s) = P(X > t)$","$P(X > t\\mid X > s) = 1$"]'::jsonb, 2, 'Given survival to time $s$, the remaining lifetime has the same exponential distribution.', 'Continuous Distributions'),
  ('A continuous uniform random variable on $[a, b]$ has variance:', '["$(b-a)^{2}/2$","$(b-a)/12$","$(a+b)^{2}/12$","$(b-a)^{2}/12$"]'::jsonb, 3, '$\text{Var}(X) = \dfrac{(b-a)^{2}}{12}$.', 'Continuous Distributions'),
  ('$X$ is uniformly distributed on $[2, 10]$. The probability that $3 < X < 7$ is:', '["$1/2$","$1/4$","$3/4$","$2/3$"]'::jsonb, 0, '$P = (7 - 3)/(10 - 2) = 4/8 = 1/2$.', 'Continuous Distributions'),
  ('A gamma distribution with shape $\alpha$ and rate $\beta$ has mean:', '["$\\alpha\\beta^{2}$","$\\alpha/\\beta$","$\\beta/\\alpha$","$\\alpha/\\beta^{2}$"]'::jsonb, 1, 'For $\text{Gamma}(\alpha,\beta)$, $E(X) = \alpha/\beta$ and $\text{Var}(X) = \alpha/\beta^{2}$.', 'Continuous Distributions'),
  ('A chi-square distribution with $k$ degrees of freedom has mean and variance:', '["$2k\\text{ and }k$","$k\\text{ and }k$","$k\\text{ and }2k$","$k/2\\text{ and }k$"]'::jsonb, 2, 'The chi-square is $\text{Gamma}(k/2, 1/2)$, giving $E = k$ and $\text{Var} = 2k$.', 'Continuous Distributions'),
  ('The sum of the squares of $5$ independent standard normal variables has:', '["a normal distribution with variance $5$","a t-distribution with $5$ degrees of freedom","an F-distribution with $(5, 1)$ degrees of freedom","a chi-square distribution with $5$ degrees of freedom"]'::jsonb, 3, 'By definition $\chi^{2}_{k} = Z_{1}^{2} + \cdots + Z_{k}^{2}$.', 'Continuous Distributions'),
  ('The Student t-distribution with $\nu$ degrees of freedom approaches which distribution as $\nu\to\infty$?', '["the standard normal distribution","the chi-square distribution","the uniform distribution","the exponential distribution"]'::jsonb, 0, 'For large $\nu$ the heavy tails vanish and the t-density converges to $N(0,1)$.', 'Continuous Distributions'),
  ('The moment generating function of a random variable $X$ is defined as:', '["$M_{X}(t) = E(tX)$","$M_{X}(t) = E(e^{tX})$","$M_{X}(t) = e^{tE(X)}$","$M_{X}(t) = E(X^{t})$"]'::jsonb, 1, 'The m.g.f. is $E(e^{tX})$ and the $r$-th moment is $M_{X}^{(r)}(0)$.', 'Moment Generating Functions and Limit Theorems'),
  ('If $M_{X}(t) = (0.3 + 0.7e^{t})^{10}$ then $X$ has which distribution and mean?', '["binomial with $n = 10$ and $p = 0.3$, mean $3$","Poisson with mean $10$","binomial with $n = 10$ and $p = 0.7$, mean $7$","geometric with $p = 0.7$"]'::jsonb, 2, 'The binomial m.g.f. is $(q + pe^{t})^{n}$, so $n = 10$, $p = 0.7$ and $\mu = np = 7$.', 'Moment Generating Functions and Limit Theorems'),
  ('If $X$ is Poisson with mean $\lambda$, its moment generating function is:', '["$e^{\\lambda t}$","$(1-\\lambda t)^{-1}$","$\\lambda e^{t}$","$e^{\\lambda(e^{t}-1)}$"]'::jsonb, 3, '$M(t) = \sum e^{tk}e^{-\lambda}\lambda^{k}/k! = e^{-\lambda}e^{\lambda e^{t}}$.', 'Moment Generating Functions and Limit Theorems'),
  ('The moment generating function of $N(\mu, \sigma^{2})$ is:', '["$e^{\\mu t + \\sigma^{2}t^{2}/2}$","$e^{\\mu t - \\sigma^{2}t^{2}/2}$","$e^{\\mu t + \\sigma t}$","$e^{\\mu t^{2} + \\sigma^{2}t/2}$"]'::jsonb, 0, 'Standard result: $M_{X}(t) = \exp(\mu t + \sigma^{2}t^{2}/2)$.', 'Moment Generating Functions and Limit Theorems'),
  ('A random variable has mean $50$ and standard deviation $4$. By Chebyshev''s inequality, a lower bound for $P(38 < X < 62)$ is:', '["$3/4$","$8/9$","$1/9$","$15/16$"]'::jsonb, 1, '$38$ and $62$ are $3$ standard deviations from the mean, so $P\ge 1 - 1/3^{2} = 8/9$.', 'Moment Generating Functions and Limit Theorems'),
  ('The Central Limit Theorem states that for independent identically distributed variables with mean $\mu$ and variance $\sigma^{2}$, the sample mean $\bar{X}$ for large $n$ is approximately:', '["$N(\\mu, \\sigma^{2})$","$N(\\mu/n, \\sigma^{2}/n)$","$N(\\mu, \\sigma^{2}/n)$","$N(n\\mu, \\sigma^{2})$"]'::jsonb, 2, 'The distribution of $\bar{X}$ is approximately normal with mean $\mu$ and variance $\sigma^{2}/n$.', 'Moment Generating Functions and Limit Theorems'),
  ('A population has standard deviation $12$. The standard error of the mean of a sample of size $36$ is:', '["$0.33$","$6$","$12$","$2$"]'::jsonb, 3, '$\sigma/\sqrt{n} = 12/6 = 2$.', 'Moment Generating Functions and Limit Theorems'),
  ('The Weak Law of Large Numbers says that as $n\to\infty$ the sample mean:', '["converges in probability to the population mean","converges to zero","becomes exactly equal to the median","has variance that grows with $n$"]'::jsonb, 0, 'For any $\varepsilon > 0$, $P(|\bar{X}_{n} - \mu| > \varepsilon)\to0$.', 'Moment Generating Functions and Limit Theorems'),
  ('A two-state Markov chain has transition matrix rows $(0.7, 0.3)$ and $(0.4, 0.6)$. If the chain starts in state $1$ with probability $0.5$ and state $2$ with probability $0.5$, the probability of being in state $1$ after one step is:', '["$0.70$","$0.55$","$0.45$","$0.40$"]'::jsonb, 1, '$P = 0.5(0.7) + 0.5(0.4) = 0.35 + 0.20 = 0.55$.', 'Moment Generating Functions and Limit Theorems'),
  ('For the Markov chain with rows $(0.7, 0.3)$ and $(0.4, 0.6)$, the stationary probability of state $1$ is:', '["$1/2$","$3/7$","$4/7$","$7/10$"]'::jsonb, 2, 'Solve $\pi_{1} = 0.7\pi_{1} + 0.4\pi_{2}$ with $\pi_{1} + \pi_{2} = 1$. Then $0.3\pi_{1} = 0.4\pi_{2}$, so $\pi_{1} = 4/7$.', 'Moment Generating Functions and Limit Theorems')
),
tgt as (
  select subject_id, subject_name, faculty, department, level, semester, units
    from public.cbt_questions
   where (subject_name ilike 'STA 112%' or subject_id like 'sta-112%')
     and subject_id not like '%coming-soon'
   limit 1
)
insert into public.cbt_questions
  (subject_id, subject_name, institution, faculty, department, level,
   question, options, correct_index, explanation, topic, is_general, semester, units)
select coalesce(t.subject_id, 'sta-112-introductory-probability'),
       coalesce(t.subject_name, 'STA 112: Introductory Probability'),
       'University of Nigeria, Nsukka',
       coalesce(t.faculty, 'Faculty of Physical Sciences'),
       coalesce(t.department, 'Statistics'),
       coalesce(t.level, '100 Level'),
       s.question, s.options, s.correct_index, s.explanation, s.topic, false,
       coalesce(t.semester, 'first'),
       coalesce(t.units, 2)
  from src s
  left join tgt t on true
 where not exists (
   select 1 from public.cbt_questions c
    where c.subject_id = coalesce(t.subject_id, 'sta-112-introductory-probability') and c.question = s.question);

select subject_id, subject_name, count(*) as questions
  from public.cbt_questions
 where subject_name ilike 'STA 112%' or subject_id like 'sta-112%'
 group by 1, 2;

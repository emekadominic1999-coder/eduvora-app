// STA 111 (Probability I) - hand-set questions, one idea per question, no repeated templates.
const L = require('../sta/lib');
const { f, frac, nCr, nPr, fact, add, out } = L;
const T_SET = 'Elementary Set Theory', T_CNT = 'Techniques of Counting', T_SS = 'Sample Space and Events', T_PR = 'Probability: Axioms and Laws', T_CP = 'Conditional Probability and Independence';
const d = (v, k = 4) => f(v, k);

// ---------------- sets
add('In a class of 60 students, 35 passed Mathematics, 28 passed Physics and 12 passed both subjects. How many students passed at least one of the two subjects?', 51, [63, 9, 41], 'n(M ∪ P) = 35 + 28 − 12 = 51.', T_SET);
add('In the same class of 60 students, 35 passed Mathematics, 28 passed Physics and 12 passed both. How many passed Physics only?', 16, [28, 12, 23], 'Physics only = n(P) − n(M ∩ P) = 28 − 12 = 16.', T_SET);
add('In a survey of 100 traders, 62 sell yam, 48 sell rice and 15 sell neither. How many sell both yam and rice?', 25, [10, 35, 37], 'Traders selling at least one = 100 − 15 = 85. Both = 62 + 48 − 85 = 25.', T_SET);
add('How many subsets of the set {a, b, c, d, e} contain the element a?', 16, [32, 8, 31], 'Each subset containing a is formed by choosing any subset of the other four elements: 2⁴ = 16.', T_SET);
add('Which of the following is always true for any two sets A and B?', 'A − B = A ∩ B′', ['A − B = A ∪ B′', 'A − B = B − A', 'A − B = A′ ∩ B'], 'The elements of A that are not in B are exactly those in A and in the complement of B.', T_SET);
add('If A and B are disjoint sets with n(A) = 14 and n(B) = 9, then n(A ∪ B) is:', 23, [5, 126, 14], 'For disjoint sets there is no overlap, so n(A ∪ B) = n(A) + n(B) = 23.', T_SET);
add('The set of all subsets of {1, 2, 3} is called the power set. The number of its elements is:', 8, [6, 9, 3], 'A set of n elements has 2ⁿ subsets, so 2³ = 8.', T_SET);

// ---------------- counting
add('A password consists of three different letters chosen from A, B, C, D, E followed by two digits, where digits may be repeated. How many passwords are possible?', 6000, [12500, 5400, 600], 'Letters: 5 × 4 × 3 = 60. Digits: 10 × 10 = 100. Total = 60 × 100 = 6000.', T_CNT);
add('In how many ways can a president, a secretary and a treasurer be chosen from 8 aspirants if nobody may hold two offices?', 336, [56, 512, 24], 'Order matters: ⁸P₃ = 8 × 7 × 6 = 336.', T_CNT);
add('A committee of 3 is to be chosen from 5 lecturers and 4 students and must contain at least one student. The number of possible committees is:', nCr(9, 3) - nCr(5, 3), [nCr(9, 3), nCr(5, 3), nCr(4, 1) * nCr(5, 2) * 2], 'All committees C(9, 3) = 84; those with no student C(5, 3) = 10. So 84 − 10 = 74.', T_CNT);
add('The number of distinct arrangements of the letters of the word LECTURE is:', 2520, [5040, 1260, 840], 'LECTURE has 7 letters in which only E is repeated (twice), so the number of arrangements is 7!/2! = 2520.', T_CNT);
add('Six different books are to be arranged on a shelf so that two particular books are always together. The number of arrangements is:', 240, [720, 120, 480], 'Treat the two books as one block: 5! arrangements × 2 orders inside the block = 240.', T_CNT);
add('How many even four-digit numbers can be formed from the digits 1, 2, 3, 4, 5, 6, 7 if no digit is repeated?', 360, [840, 420, 240], 'The last digit must be 2, 4 or 6 (3 choices). The first three places then use 6 × 5 × 4 = 120 arrangements. Total = 3 × 120 = 360.', T_CNT);
add('A test contains 10 true-or-false questions and every question must be answered. The number of different ways of completing the test is:', 1024, [100, 20, 512], 'Each question has 2 possible answers, so 2¹⁰ = 1024.', T_CNT);
add('Five people A, B, C, D and E join a queue. In how many arrangements does A stand somewhere ahead of B?', 60, [120, 24, 48], 'By symmetry exactly half of the 5! = 120 arrangements have A ahead of B: 60.', T_CNT);
add('The value of C(10, 3) + C(10, 4) is equal to:', 'C(11, 4)', ['C(11, 3)', 'C(10, 7)', 'C(20, 7)'], 'By Pascal\'s rule C(n, r − 1) + C(n, r) = C(n + 1, r), so C(10, 3) + C(10, 4) = C(11, 4) = 330.', T_CNT);

// ---------------- probability
add('A card is drawn at random from a standard pack of 52 cards. The probability that it is red or a king is:', '7/13', ['15/26', '1/2', '4/13'], 'Red cards 26, kings 4, red kings 2. P = (26 + 4 − 2)/52 = 28/52 = 7/13.', T_PR);
add('Two fair dice are thrown. The probability that the sum of the scores is greater than 9 is:', '1/6', ['1/9', '5/36', '1/12'], 'Sums 10, 11 and 12 can occur in 3, 2 and 1 ways: 6 of 36 outcomes, so 1/6.', T_PR);
add('A fair coin is tossed four times. The probability of at least one head is:', '15/16', ['1/16', '1/2', '7/8'], 'P(at least one head) = 1 − P(no head) = 1 − (1/2)⁴ = 15/16.', T_PR);
add('A fair coin is tossed three times. The probability of exactly two heads is:', '3/8', ['1/4', '1/2', '1/8'], 'There are C(3, 2) = 3 favourable outcomes out of 2³ = 8.', T_PR);
add('A committee of 3 is chosen at random from 4 men and 3 women. The probability that it consists of women only is:', '1/35', ['1/7', '4/35', '3/35'], 'Only one committee has all three women: C(3, 3)/C(7, 3) = 1/35.', T_PR);
add('A box holds 20 items of which 5 are defective. Two items are drawn without replacement. The probability that both are defective is:', '1/19', ['1/16', '1/4', '2/19'], '(5/20)(4/19) = 20/380 = 1/19.', T_PR);
add('Three cards are dealt from a standard pack. The probability that all three are kings is:', '1/5525', ['1/2197', '1/1326', '1/17576'], 'C(4, 3)/C(52, 3) = 4/22100 = 1/5525.', T_PR);
add('Three independent events each have probability 0.2. The probability that at least one of them occurs is:', d(1 - 0.8 ** 3, 3), ['0.600', '0.008', '0.512'], 'P(at least one) = 1 − (0.8)³ = 1 − 0.512 = 0.488.', T_PR);
add('Given P(A) = 0.5, P(B) = 0.4, P(C) = 0.3, P(A ∩ B) = 0.2, P(A ∩ C) = 0.1, P(B ∩ C) = 0.1 and P(A ∩ B ∩ C) = 0.05, the probability P(A ∪ B ∪ C) is:', '0.85', ['0.80', '0.75', '0.95'], 'P = 1.2 − 0.4 + 0.05 = 0.85, by the inclusion–exclusion principle.', T_PR);
add('If P(A) = 0.6, P(B) = 0.3 and A and B are mutually exclusive, then P(A ∪ B) is:', '0.9', ['0.18', '0.3', '0.72'], 'For mutually exclusive events P(A ∪ B) = P(A) + P(B) = 0.9.', T_PR);
add('A coin is tossed and a die is thrown together. The probability of a head together with a prime number is:', '1/4', ['1/2', '1/6', '1/3'], 'Head: 1/2. Primes on a die are 2, 3, 5: 3/6 = 1/2. Product = 1/4.', T_SS);
add('Which of the following numbers cannot be the probability of an event?', '1.2', ['0', '0.35', '1'], 'Probabilities lie between 0 and 1 inclusive, so 1.2 is impossible.', T_PR);
add('If A ⊂ B, which statement about probabilities is correct?', 'P(A) ≤ P(B)', ['P(A) ≥ P(B)', 'P(A) = P(B)', 'P(A ∩ B) = P(B)'], 'Every outcome of A is an outcome of B, so A cannot be more likely than B.', T_PR);

// ---------------- conditional probability, independence, Bayes
add('A fair die is thrown. Given that the score is even, the probability that it is greater than 3 is:', '2/3', ['1/2', '1/3', '1/6'], 'Even scores: 2, 4, 6. Of these 4 and 6 exceed 3, so the probability is 2/3.', T_CP);
add('Given P(A) = 0.4, P(B) = 0.5 and P(A ∪ B) = 0.7, which statement is correct?', 'A and B are independent', ['A and B are mutually exclusive', 'P(A | B) = 0.8', 'P(A ∩ B) = 0.9'], 'P(A ∩ B) = 0.4 + 0.5 − 0.7 = 0.2 = P(A)P(B), so the events are independent.', T_CP);
add('Given P(A) = 0.5, P(B) = 0.4 and P(A | B) = 0.5, the probability P(A ∩ B) is:', '0.2', ['0.25', '0.9', '0.1'], 'P(A ∩ B) = P(A | B)P(B) = 0.5 × 0.4 = 0.2.', T_CP);
add('If P(A | B) = P(A) and P(B) > 0, then:', 'A and B are independent', ['A and B are mutually exclusive', 'A ⊂ B', 'P(A ∪ B) = P(A) + P(B)'], 'Knowing B has occurred does not change the probability of A, which is the definition of independence.', T_CP);
add('A box contains 4 white and 6 black balls; a second box contains 7 white and 3 black balls. A box is chosen at random and one ball is drawn from it. The probability that the ball is white is:', '0.55', ['0.50', '0.28', '0.40'], 'P(W) = ½(0.4) + ½(0.7) = 0.55.', T_CP);
add('A student passes the first test with probability 0.7. If she passes the first, the probability of passing the second is 0.8; if she fails the first, it is 0.4. The probability that she passes the second test is:', '0.68', ['0.56', '0.60', '0.80'], 'P = 0.7(0.8) + 0.3(0.4) = 0.56 + 0.12 = 0.68.', T_CP);
add('In a university 60% of students are in Science and 40% in Arts. Thirty per cent of Science students and 10% of Arts students own laptops. A student chosen at random owns a laptop. The probability that the student is in Science is:', '0.818', ['0.600', '0.300', '0.180'], 'P(S | L) = 0.6(0.3) / [0.6(0.3) + 0.4(0.1)] = 0.18/0.22 = 0.818.', T_CP);
add('A test detects a disease in 98% of infected people but also gives a positive result for 5% of healthy people. If 1% of the population is infected, the probability that a person with a positive result is actually infected is closest to:', '0.17', ['0.98', '0.50', '0.05'], 'P = 0.98(0.01) / [0.98(0.01) + 0.05(0.99)] = 0.0098/0.0593 ≈ 0.17.', T_CP);
add('Which of the following describes the law of total probability?', 'P(B) = Σ P(B | Aᵢ)P(Aᵢ) over a partition A₁, …, Aₙ', ['P(B) = Σ P(Aᵢ | B)', 'P(B) = P(A₁) + P(A₂) + … + P(Aₙ)', 'P(B) = P(B | A) / P(A)'], 'B is split over a partition of the sample space and each part is weighted by the probability of its cell.', T_CP);
add('Two events with positive probabilities are mutually exclusive. Which statement about them is true?', 'They are dependent', ['They are independent', 'Their union is the sample space', 'Their intersection has positive probability'], 'If one occurs the other cannot, so P(A ∩ B) = 0 ≠ P(A)P(B).', T_CP);
add('A bag has 5 red and 3 green balls. Two balls are drawn in succession without replacement. The probability that the second is green given that the first is red is:', '3/7', ['3/8', '5/8', '2/7'], 'After removing a red ball, 3 green remain among 7 balls: 3/7.', T_CP);

module.exports = out;

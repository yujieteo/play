UNDERSTOOD

Indirection: keep the name, change the object. Example, website name, IP address, keep the website name, change the address. Indirection lets you choose the reference to be invariant, not the object. Better definition: indirection is the contravariant functor to covariant naming. Name network addresses with human readable addresses. INDIRECTION from human readable addresses to network addresses. Indirection is left adjoint to naming which is right adjoint.

Bernoulli source, hamming distortion: probability from 0 to 1/2, Hamming loss is H(p) - H(D) for prescribed distortion less than the probability (so there is loss), and zero if the prescribed distortion is larger than the distortion. This is proven by (1) considering that the rate distortion function is the minimum of the mutual information between the input X and output X^, then simply calculate the joint pmt of the two that satisfies where H(X + X^) = H(D).

Prescribed distortion: D as the upper bound for the limit supremum of the expectation of Hamming indicator loss between input X^n and output X^n. 

Reliability function: probability of error decays exponentially with the code length, the minimal error exponent

Achievable rate: sequence of (2^nR, n) code such that probability of error tends to zero as the code is large. NOTE: it is insufficient to define it as argmin_R of the average of probability of error.

Binary symmetric channel, crossover: channel capacity using Shannon theorem gives max I(X;Y) = max H(Y) - H(X + Z|X), Z is Bernoulli p noise. This is max H(Y) - H(Z) = 1 - H(p), where p is probability of noise.

Binary symmetric channel, erasure probability p: this is just H(X) - p(H(X)) = 1 - p. Entropy is 1.

Probability of error: sum of conditional probability of error averaged over upper bound of throughput ceil(nR), n is length, R is rate. For an individual symbol: this is lambda(C) = P(M^ != m | M = m). It just means the probability the message is not realised given the alphabet. Average probability of error is just take the average over 2^ceil(nR)

Memoryless channel: ergodicity property over length n, with message M, input X^n, time i in [1:n], p(y_i | x_i) = p(y_i | x^I, y^I-1, m). Basically, x^I is input at the same time, y^i-1 was the output at the previous time, and m is the message. Memoryless channel, in El. Gamal in its most relaxed form, means that the conditional properly is dependent only on the message, input on time, output at previous time.

Discrete stationary memoryless channel: finite input set X, finite output set Y, conditional probability mass functions p(y|x) on Y. Instant transmission. Classical example is binary channel.

Discrete stationary memoryless SOURCE: alphabet X, probability mass function p(x).

Optimal lossless compression: infimum of all achievable rate. For a discrete stationary memoryless source, this is the entropy. Achievability uses typical sequences and encoding. Converse uses Fano’s.

Hamming distortion: indicator function for error.

Max. differential entropy under average power constraint: achieved when X is normally distributed. The maximum of differential entropy h(X) when E(X^2). Is less than or equal to P is given by 0.5 log (2 pi e P), where P is power and is sigma squared. Therefore, for any X following pdf f(x) we have h(X) = h(X - E(X)) is less than or equal to 0.5 log (2 pi e Var(X)).

Power constraint of Gaussian channel: block length n then expected sum of square of random variables E(sum Xi^2) / n is less than or equal to P. Note that this is very similar to a kinetic energy term, dividing by n gives some sort of power since alphabet n is index of sequence, alphabet, or support. Hence the name, power constraint for a Gaussian channel. This is 0.5 log (2 pi e sigma^2), start with KL-divergence differential entropy D(f || phi) definition, get -h(X) and expectation of log(1/phi X), where phi X = e^{-X^2/2}/root(2 pi). This will give -h(X) + 0.5 log 2 pi + 0.5 log E(X^2) <= 0 for no KL divergence giving the constraint.

Capacity of Gaussian channel under power constraint: by power constraint of differential entropy, we have 0.5 log (2 pi e(P + sigma^2))- 0.5 log (2 pi e sigma^2)) as the mutual information from h(Xg + Z) - h(Z) where Z is H(Y|X) for channel Y output Yi = Xi + Zi for input X, Zi independent of X. The subtraction of log simplifies to a quotient 0.5 log(1 + P^2/sigma^2).

Turing machine: finite control and single tape and pointer with symbols 0,1,B, B for blank

Bayesian reasoning: P(D|H) P(H) = P(H|D) P(D) or posterior * marginal = likelihood * prior. This is Wittgenstein ruler form. One can replace P(H) with sum of P(Xi) P(H | Xi) or sum of marginals, and still derive multivariate Bayes’ rule

Minimum description length from Bayesian reasoning: consider argmax P(D|H) P(H), take bit log and argmin of negative so argmin E(D|H) + E(H). Gives the minimum description length principle.

Chaitin constant: probability that computer halts when input p is a binary string drawn according to Bernoulli(1/2) process. Or sum of reciprocals of alphabet size of any program p that halts. Not computable, since no finite mechanical way to solve halting problem.

Slepian-Wolf code: correlated sources X, Y can be described at rates RX, RY, recovered with arbitrarily low probability if RX more than or equal to conditional entropy X given Y, RY more than or equal to conditional entropy Y given X and RX + RY more than or equal to joint entropy H(X, Y) 

Chaitin constant philosopher’s stone: list all programs in binary, supposed you have n bit of Chaitin constant, difference between full Chaitin’s and truncated Chaitin’s is less than probability of cardinality n (reciprocal of alphabet of n characters). Contributions in reciprocal of program length size is also less than that of reciprocal of alphabet of n characters. So, no program of length n that has yet to halt will half. Run increasingly longer lists of programs to keep track which one halts, find proofs to any yes/no theorems in less than n bits with 2^n characters of Chaitin’s constant. Example: program that halts with counter-example to Fermat’s last theorem. Program has finite bits N, so with 2^N bits of Chaitin’s constant, can determining Fermat’s last theorem. WARNING: Godel incompleteness still not bypassed since one cannot find effective procedures.

Kraft’s inequality: instantaneous codes iff sum of alphabet length raised to the string length for each strength is less than or equal to 1.

McMillan inequality: uniquely decodable codes iff sum of alphabet length raised to the string length for each strength is less than or equal to 1.

Effective alphabet size: 2^{nH(X)}, X discrete.

Effective support set size: 2^{nh(X)}, X continuous.

Effective channel capacity alphabet size: 2^{C}

Nats: replace 2 with e, same laws hold.

Rate distortion theory: relax constraint on lower bound of entropy for compression, find channel capacity to receive signal with acceptable distortion

Channel capacity: maximum mutual information between input and output given a probability transition matrix p(x) gives number of distinguishable inputs (not definition, but is Shannon’s channel coding theorem). Alternatively, supremum of all achievable rates of a discrete memoryless channel. Examples: binary symmetric channel has capacity 1 - entropy. Note, one can set a constraint where the sum of the codebook is less than nB.

Channel coding theorem proof: random coding, joint typicality decoding. Weak converse requires Fano’s inequality.

Jointly typical sequences: tuples of x y with joint distribution p(x,y) such that the difference between the entropy definition as negative expectation of logarithm for p(x), p(y) and p(x,y) are arbitrarily small (converges in probability).

Feedback capacity: feedback does not increase capacity for discrete memoryless channels.

Source-channel theorem: stochastic process with entropy rate H cannot be sent reliably over discreteness memoryless channel of entropy H more than channel capacity C.

Channel coding theorem: all rates below channel capacity are achievable, using random codes (2^(nR), n) codes, with rate R, n cardinality.

Mutual information: expected value of logarithm of covariate probability ratio p(x,y) / p(x) p(y).

Entropy: negative expectation of the logarithm of a probability distribution. This is concave. This is the average distribution length or the expectation of the ideal word length.

Ideal word length: negative of logarithm of probability distribution.

Estimated probability distribution of average distribution length: sum of entropy of distribution and the joint entropy / KL divergence of the probability distribution and its estimator.

Average redundancy: difference between expected actual word length and entropy.

Joint entropy (KL divergence): negative expectation of logarithm of a joint probability distribution. Different from Shannon’s definition. This is convex.

AEP for ergodic sequence: 2^(nH) typical sequence, with probability 2^(-nH) uniform.

Entropy chain rule: the joint entropy is the sum of the unconditional entropy of X and the entropy of Y conditioned on X.

AEP for large deviations: probability of set is 2^(nD), D relative entropy between closest element and true distribution.

AEP: the logarithm of jointly independent and identically distributed random variables divided by sequence cardinality converges to the entropy in probability for sequence that is stationary ergodic.

Typical set: sequences that are between the probability of a set 2^(- card(X) H(X)) up to probability error 2^(- card(X) epsilon). This definitions lets you get high probability for cardinality large of set.

Markov chain thermodynamics: relative entropy to stationary distribution decreases with time. Entropy increases IF stationary distribution is uniform. Conditional entropy H(Xn | X1) increases with time of stationary Markov chain. Conditional entropy of initial condition H(X0 | Xn) increases for any Markov chain.

Entropy rate of joints for alphabet: limit of joint distribution of random variables divided by cardinality as cardinality of Markov chain approaches infinity.

Entropy rate of conditionals for alphabet: limit of conditional distribution of Markov chain terminal random variable against adjacent random variables as the cardinality of the Markov chain approaches infinity.

Stationary stochastic process: entropy rate of joints and conditionals are equal.

Conditioning: condition entropy is less than or equal to unconditional entropy

Log sum inequality: Jensen’s using finite summations, only for non-negative inequality.

Relative entropy: sum of product between probability and log of prob. distribution ratio. Also, the expectation of the log of distribution ratio with respect to p(x)

Jensen’s inequality: for convex f, expectation of payoff is more than payoff of expected frequency. Payoff space is better than probability space. Trick: use - concave to get convex. Proof sketch: draw slant line passing through y = x^2.

Information inequality: joint entropy (KL divergence) is nonnegative. Similarly, mutual information is nonnegative.

Zero joint entropy: occurs when distributions are the same.

Zero mutual information: occurs when distributions are independent.

Data processing inequality: if X to Y to Z is Markov chain, then mutual information I(X,Y) is more than or equal to I(X,Z). Proof I(X, Z|Y) is zero by definition of Markov chain. 

Sufficient statistic: consider n -> X -> T(X) Markov chain, T(X) statistic, X random variable, n is indexing. Data processing inequality gives mutual information between indices and random variable - mutual information of indices and statistic to be nonnegative. Definition: this difference is equal to zero if T is a sufficient statistic. Example: number of tails is sufficient statistic to recover Bernoulli variable. Example: max and min values is sufficient statistic for uniform distribution. 

Minimal sufficient statistic: if it forms “contravariant” Markov chain n -> T(X) -> U(X) -> X for any other sufficient statistic U. Alternatively, it has the same Kolmogorov complexity as the indices n, or it maximally compresses the indices n.

Fano’s inequality: consider Markov chain of input X to output Y to correlated reconstruction X*, then let the error probability be probability that X*(Y) is not equal to X. Then Fano’s inequality states that the sum of entropy of the error probability and the error probability times the logarithm of the (alphabet/support- 1) is more than or equal to the conditional entropy X given Y. Intuitively, entropy of error probability is uncertainty with correct predictions, the logarithm of the (alphabet/support -1) refers to the entropy of uniform distribution of all incorrect choice. Therefore, H(X|Y) is less than or equal to Hb(e) + Pe(X) log(card(X)-1), Hb(e) is binary entropy of Pe(X != X*)

Independent and identically distributed inequality, if X and Y are independent and identically distribution, the probability that they are equal is more than 2^{-H(X)}.

Markov chain: X, Y, Z forms Markov chain if X and Z are conditionally independent given Y or I(X, Z|Y) = 0 or Z depends only on Y, conditionally independent of X.

Hypothesis testing distance: relative entropy between hypothesis is exponent in error probability of hypothesis test.

Randomly generated code: Shannon used it to have achievable rate with arbitrarily low probability of error.

Prefix complexity K(x): use conditional Kolmogorov complexity, but programs and data must be self-delimiting. This is called K(x) since not having self-delimitation is annoying and disables some inequalities. 

Kolmogorov complexity C(x): not to be confused with prefix complexity K(x); fixing an additively optimal partial computable function phi, it is the conditional Kolmogorov complexity C(x | epsilon). Epsilon is natural number on auxiliary tape.

Conditional Kolmogorov complexity C(x|y): minimum cardinality min(l(p)) such that an additively optimal partial computable function phi(<y, p>) for natural y and program p gives data x. If the program does not exist, then this is infinite. If the program is self-delimiting, then this is K(x|y). WARNING: the definition is subtle, since the program must halts without reading the next symbol after p, it does not need to calculate since it is conditioned on y. See Example 3.1.2. page 206 of Li and Vitanyi.

Computability theory: needed rigour to get quantitative bounds on Kolmogorov complexity. Motivates universal semicomputable semimeasures and stuff

Additive optimality: goal is to have unique minimal element (avoid nonsense with axiom of choice), defined by ensuring existence of functions with greater Kolmogorov complexity up to constant for any Kolmogorov complexity of function i.e. Cg(x) + c_f,g >= Cf(x)

Turing’s thesis: effective procedure defined by Turing machine

Church’s thesis: objective notion of effective procedure or computability independent of choice of Turing machine.

Partially computable functions: functions that can be computed numerically and algorithmically. Church’s thesis guarantees the existence of this definition or equivalence of categories.

Laplace’s MDL argument: chance of generating x literarily is 2^{-card(x)), chance of computer program generating x is 2^{-K(x)} (also works as definition of Kolmogorov complexity), probability of program comparison to random process is 2^{-K(x) -(-n)}.

Universal lower semicomputable continuous semimeasure complexity (KM): the logarithm of the reciprocal of the universal lower semicomputable continuous semimeasure M.

Universal lower semicomputable continuous semimeasure: the goal of this is to have a measure that gives an a priori probability

Universal: a lower semicomputable function is universal if enumeration exists.

Universal distribution: the idea is to instead of finding some sort of algorithm that maximises ignorance, you pick some sort of distribution that maximises ignorance.

Kolmogorov structure function / ML estimator: the minimal of maximal data-to-model code length log card(S) for model S. 

Simplicity of model: Kolmogorov complexity of model K(S)

Exception MDL: minimise sum of description length K(H) and exception list K(E|H), E is error from between data D and data DH from hypothesis classification, compare this to the data processing inequality K(D|H) + K(H) >= K(D)

Max. Entropy: knowledge of constraints gives bounds that maximise entropy. 

Maximum likelihood: pick hypothesis maximising probability of data conditioned on hypothesis. Special case of minimum description length

Probably approximately correct learning: the sum of probabilities of cases where concept in binary exemplified concept class is not equal to halted output concept can be made arbitrarily small by an algorithm. This is also the definition of an Occam algorithm.

Pac-learning and compression relationship?

** Asymmetric complexity (minimum description length): minimum sum of encoding and encoded data. Random string: zero encoding, compressibility = data.  Or min K(H) + K(D|H)

Symmetric complexity or Wittgenstein ruler: K(D,H) = K(H) + K(D) + K(K(H), D|H) + K(K(D), H|D). Need double dual to work correctly. 

c-incompressibility: the Kolmogorov complexity of a c-incompressible string is at least the length of the string minus c character. 

c-compressible: the Kolmogorov complexity of a c-compressible string is at most the length of the string -c characters. 

Kolmogorov complexity alternate definition: the complexity K such that the string is both K compressible and K incompressible.

Incompressibility lemma: since there are sum from index 0 to log[card(A)]- c -1 programs is 2^(log [card(A)] - c - 1)so there are at least  card(A) 2^(-c-1) c-incompressible

Disjunctive normal forms (“DNF”): OR of ANDs

Concepts: measurable functions in set {0, 1}, concept class, functions on examples giving binary exemplar.

Occam algorithm: poly time, where complexity of hypothesis is at most complexity smallest concept ^ payoff exponent * number of examples ^ probability exponent. Pac-learnable if Occam algorithm exists. Number of hypothesis r is such that at most log r of Occam hypothesis complexity.

Landauer bound: 1 bit erases dissipates 10^-12 heat.

Simple Kolmogorov difference: work to transform strings most efficiently.

Instance complexity: minimal length asserting membership of instance. Describes complexity of individual.

Age of string x: minimum of product of random string 2^l(p) by steps t, where universal monotonic machine U on program p U(p) = x. Expected time for constant size probabilistic program to generate string by coin flips.

Levin Kt complexity: log of age. Or, the sum of program length and log of steps taken till x is printed.

Borel-Cantenelli: sum of probabilities Pk of Bernoulli trial Ak converges, only finitely events (with finitely many trials) occur certainly; also for mutually independent Ak, then if sum of probabilities Pk diverges, infinitely Ak certainly.

Logical depth of string x, least steps d for universal monotonic machine U computes x using b-incompressible program p at most d steps and halts.
### A Pluto.jl notebook ###
# v0.12.4

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 138a0a50-f431-11ea-053a-8f430d193cb1
begin
	using Pkg
	Pkg.add("Distributions")
	Pkg.add("PlutoUI")
	Pkg.add("Plots")
	using Distributions, PlutoUI, Plots, StatsBase
end

# ╔═╡ c222f5a0-f430-11ea-288f-d394ab49704d
md"# Probability & statistical inference"

# ╔═╡ 9202b92c-1862-11eb-04b6-7109223f0f59
md"""
**Probability**
1. Sets / Set theory
2. Probability on sets (Kolmogorov's axioms)
    - Probability as a function 
    - P(Ω) = 1
    - P(A1 ∪ A2) = P(Ω)
    - P(A1 ∩ A2) = ∅ 
    - Law of total probability
3. Derivatives of Kolmogorovs axioms (optional)
4. Expectations
5. Special distributions (discrete)
    - Bernoulli
    - Binomial 
    - Poisson
6. Special distribution (continuous)
    - Normal
    - T
    - χ²

6. Interpretations 

7. CLT

**Inference**
1.  Estimators
    - Notation
    - Properties

2. estimation error and confidence intervals
    - in the normal model (known variance, unknown variance cases)
    - of a bernoulli/binomial proportion
    - poisson λ
"""

# ╔═╡ 678f0350-186a-11eb-026b-2b830bf9ebbc
md"## Introduction to Probability"

# ╔═╡ 24b48fe0-fc14-11ea-26c6-2b2dcabd228e
md"### Set theory"

# ╔═╡ 0a8470ee-1920-11eb-2db7-0d83c4f23c58
md"""
Before learning about probability and distributions we have to consider set theory, which serves as a basis for probability theory. A *set* is simply just a collection of (arbitrary) elements.

For example if consider the simple example of a coin toss, the two possible outcomes are *heads* or *tails*. Thus the set $A$ of possible outcomes for a coin toss is 

$A = \lbrace \mathrm{Heads}, \mathrm{Tails} \rbrace.$

Another classical example are dice, which can take the possible values of 1 through 6. The corresponding set $B$ contains all possible outcomes 1-6,

$B = \lbrace 1, 2, 3, 4, 5, 6 \rbrace.$

If we roll a die and get the value 3, the set of the outcome is $B_1 = \lbrace 3 \rbrace$. Since the set $B_1$ is included in the set of all possible outcomes (the **space**), we call $B_1$ a *subset* of $B$ and write $B_1 \subset B$.   


Sets do not always have to be *discrete* as in the examples above, but can also be *continuous*. Height measurements of persons can only take positive values and can be described by a *subset of the real numbers*. As such set $C$ for heights could be written as 

$C = \lbrace x \in \mathbb{R} ~|~  x > 0 \rbrace.$

We can read this as: *The set C of heights contains all values of the real numbers, where the value is greater than zero*.

Again, if we observe height measurements $C_1 = \lbrace 168.4, 184.1, 199.7\rbrace$, we can say that $C_1$ is a subset of $C$ ($C_1 \subset C$). 

There are some special sets, most notable the *empty set*, $\emptyset$. The empty set does not contain any values or elements, $\emptyset = \lbrace \rbrace$.


##### Set operations
We are provided with mathematical operations that can be applied to sets: the *complement*, the *union* and the *set intersection*.

###### Complement
The **complement** of a set is defined by *all elements not contained in the set*. Returning to the example of dice rolls $B$, we initially considered the set $B_1 = \lbrace 3 \rbrace$ when we observed the outcome 3. The complement of the set $B_1$ in this example are all dice outcomes *not observed*, $\overline{B_1} = \lbrace 1, 2, 4, 5, 6 \rbrace$.

Visually, the set complemenet can be represented like this

**[Insert figure here]**

Note that the complement of the empty set is the entire space and the complement of the space is the empty set. For our dice example this means that if we do not observe anything, $B_2 = \emptyset = \lbrace \rbrace$, the complement $\overline{B_2} = B = \lbrace 1, 2, 3, 4, 5, 6 \rbrace$. 

###### Union
Sets can added together by an operation called the *set union*. The union of two sets are *all elements that are included in either one of the two sets*. Continuing our dice roll example, we can potentially divide the space $B$ into several sets with specific properties. Let us create sets for lower and higher numbers as well as for odd and even numbers,  

$B_3 = \lbrace 1, 2, 3 \rbrace,$ 
$B_4 = \lbrace 4, 5, 6\rbrace,$
$B_5 = \lbrace 1, 3, 5\rbrace,$
$B_6 = \lbrace 2, 4, 6\rbrace.$

If we want to know the set of die faces that are lower than 4 or odd, we can calculate the set union $B_3 \cup B_5 = \lbrace 1, 2, 3 \rbrace \cup \lbrace 1, 3, 5 \rbrace = \lbrace 1, 2, 3, 5 \rbrace$. Note that all elements are contained in the set union that are included in the set $B_3$, $B_5$ or both.

Similarly, the set union of all lower and higher die rolls are all possible die rolls, 

$B_3 \cup B_4 = \lbrace 1, 2, 3 \rbrace \cup \lbrace 4, 5, 6 \rbrace = \lbrace 1, 2, 3, 4, 5, 6 \rbrace$

The set union in a venn diagram looks like this, 

**[Insert figure here]**


###### Intersection
The last set operator we discuss here is the set intersection. A set intersection can be described as the elements which two sets have in common or *all elements that are contained in both sets*.

For our dice roll example the set intersection between the lower and upper numbers is, 

$B_3 \cap B_4 = \lbrace 1, 2, 3 \rbrace \cap \lbrace 4, 5, 6 \rbrace = \emptyset$

since there are no values contained in both sets. On the other hand, the possible die rolls which are even and in the upper numbers are, 

$B_6 \cap B_4 = \lbrace 2, 4, 6 \rbrace \cap \lbrace 4, 5, 6 \rbrace = \lbrace 4, 6 \rbrace$

as both 4 and 6 are larger *and* even numbers.

**[Insert figure here]**


"""

# ╔═╡ 8b6fb1fe-fc14-11ea-33d4-f9a3e18de71b
md"### Probabilities"

# ╔═╡ 01f52f1e-19c9-11eb-39d1-39278ad7c75b
md"""
From a mathematical standpoint probabilities are not particularly interesting. A probability is just the *assignment of a value to a set* in a specific manner. Accordingly, a **probability distribution** is the *assignment of values to a space*. 

Probabilities map values between 0 and 1 to sets. If we were to assign probabilities to the coin toss example $A$, we would assign probabilities of 0.5 to either outcome (assuming the coin is *fair*). 

$P(\text{Heads}) = 0.5, \quad P(\text{Tails}) = 0.5$

This means that the event $\text{Heads}$ is *equally likely* as the event $\text{Tails}$. This examples also shows other properties of probabilties: The total amount of probability of all possible outcomes cannot excede 1, 

$P(A) = 1.$

For any *disjoint sets* (sets which do not share common elements, or formally $X_1 \cap X_2 = \emptyset$) the probabilities can be added to calculate the probability of the union, $P(X_1 \cup X_2) = P(X_1) + P(X_2)$.[^1] In the coin toss example we have two disjoint events, $\text{Heads} \cap \text{Tails} = \emptyset$, so we can sum their probabilities to arrive at the probability for $\text{Heads}$ *or* $\text{Tails}$,

$P(\text{Heads} \cup \text{Tails}) = P(\text{Heads}) + P(\text{Tails}) = 0.5 + 0.5 = 1.$


These three properties are called *Kolmogorov axioms* (named after [Andrey Kolmogorov](https://en.wikipedia.org/wiki/Andrey_Kolmogorov)) and serve as the basis for all further rules of probability theory. The axioms can be summed up by 

1. The probability of an event is a non-negative real number, $P(E) > 0$,
2. The probability that at least one of the events occurs is $P(Ω) = 1$,
3. The probability of mutually exclusive events is the sum of probabilities for the single events.

Some important rules in probability theory include the calculation of the *converse* or *complementary probability*, 

$P(\overline{A}) = 1 - P(A)$

**Proof.**
We can split the set of all possible outcomes $\Omega$ into a subset $A$ and its complement $\overline{A}$. By definition the union of the two sets covers the whole space, 

$\Omega = A \cup \overline{A}$

and accordingly, 

$P(\Omega) = P(A \cup \overline{A})$

From axiom 2 we know that $P(\Omega) = 1$. 

$1 = P(A \cup \overline{A})$


Since $A$ and $\overline{A}$ are disjoint sets, we can apply axiom 3 to get

$1 = P(A) + P(\overline{A}).$

Final rearrangement of the expression gives the result, 

$P(\overline{A}) = 1 - P(A).$

Similarly one can derive the following properties (without proof), 

- The probability of the empty set is 0, $P(\emptyset) = 0$,
- The addition law of probability (sum rule) for arbitrary events $A$ and $B$, 

$P(A \cup B) = P(A) + P(B) - P(A \cap B), \text{and}$
$P(A \cap B) = P(A) + P(B) - P(A \cup B)$
"""

# ╔═╡ 7faaca96-186a-11eb-0ab9-5f2c89947700
md"### Expectations"

# ╔═╡ ed9f8626-1b4f-11eb-1b0b-cbf89694e89a
md"""


"""

# ╔═╡ 3995e89e-1aa4-11eb-32a6-dd1d24a8f8a3
@bind lln_t Clock(1/40, false, false)

# ╔═╡ 4dcbe96a-1aa4-11eb-1a20-b12e72eb6956
@bind lln_new_seq Button("New sequence")

# ╔═╡ a1930630-1aa4-11eb-15be-590e56e680b4
begin
	lln_new_seq
	lln_trials = rand(1:6, 1000)
	lln_means = [mean(lln_trials[1:i]) for i = 1:length(lln_trials)]
end

# ╔═╡ 72b9b3a2-1c79-11eb-2319-6f30c2c89771
md"### Probability distributions"

# ╔═╡ de8d47cc-1c7b-11eb-1ce7-cb9effafad10
md"#### Discrete probability distributions"

# ╔═╡ af26871a-1c7a-11eb-2137-65cc9d310dac
md"x = $(@bind binom_x Slider(0:.01:10, default = 5, show_value = true))"

# ╔═╡ ebd5221c-1c7b-11eb-0aee-534b1710b9ef
md"#### Continuous probability distributions"

# ╔═╡ e0cbbda4-1c79-11eb-1cec-0720fb2cde93
md"x = $(@bind norm_x Slider(-3:.01:3, default = 0, show_value = true))"

# ╔═╡ 89e5ad32-186a-11eb-21c2-0dfbecfc0876
md"### Special probability distributions"

# ╔═╡ 91436542-186a-11eb-2814-a930d8607030
md"#### Discrete probability distributions"

# ╔═╡ 2b754580-fc15-11ea-38b3-a35d7aa65cc5
md"""##### Bernoulli distribution"""

# ╔═╡ fdd4168c-1b50-11eb-302d-7d4af0b76c74
md"""
The first special probability distribution we are going to discuss is the *Bernoulli distribution*. This discrete probability distribution describes how a random variable with two possible outcomes -success (1) and failure (0) can be modelled by a single parameter: the *probability of success (p)*. The most common example for a Bernoulli distributed random variable is that of a coin toss. If we encode the events $\text{Heads}$ as a success and $\text{Tails}$ as a failure, the probability of success $p$ is the probability for the coin to turn up $\text{Heads}$. For a fair coin this probability will be $p = 0.5$. 

The probability mass function of the Bernoulli distribution is given by, 

$f(X = x ~|~ p) = \begin{cases}
	p, & \text{if}\ x = 1 \\
	1 - p, & \text{if}\ x = 0
\end{cases}$

which leads to $f(X = 1 ~|~ p) = p$ for a success, and $f(X = 0 ~|~ p) = 1 - p$ for a failure.

The expected value of the Bernoulli distribution is just the parameter $p$ itself, 

$\mu = p$

and the corresponding variance can be calculated by 

$\sigma^2 = p(1 - p).$

"""

# ╔═╡ 3b9674b6-1b53-11eb-3ef1-0198f2d103cd
md"If the distribution of a random variable $X$ is the Bernoulli distribution with success probability $p$ we sometimes also write $X \sim \text{Bernoulli}(p)$."

# ╔═╡ 8cac4b60-192e-11eb-13b1-d7d6da5b571c
md"p = $(@bind bernoulli_p Slider(0:.01:1, default = 0.5, show_value = true))"

# ╔═╡ 37626710-fc15-11ea-3fe6-6d0a49881fb0
md"""##### Binomial distribution"""

# ╔═╡ c907fbce-1a94-11eb-0b43-f53768283d08
md"""
n = $(@bind binomial_n Slider(1:100, default = 50, show_value = true))

p = $(@bind binomial_p Slider(0:.01:1, default = 0.5, show_value = true))
"""

# ╔═╡ c883ff10-f431-11ea-3534-d7d48b4e2cf8
md"##### Poisson distribution"

# ╔═╡ 4940ebe0-1b58-11eb-18d7-978f209ae214
md"If a random variable follows a Poisson distribution we write $X \sim \text{Pois}(\lambda)$."

# ╔═╡ ce405980-f431-11ea-2f2d-1931d9d12580
md" λ = $(@bind λ Slider(1:0.1:50, default = 12, show_value = true))"

# ╔═╡ 82707320-1b58-11eb-3459-3998f215951f
md"""
###### Relationship between binomial and Poisson distribution
Many probability distributions have some sort of relationship to amog each other. The same holds true for the binomial distribution and the Poisson distribution. Specifically, the binomial distribution can be *approximated by the Poisson distribution* und certain circumstances. If a random variable has a binomial distribution, 

$X \sim \text{B}(n, p)$

and the number of trials $n$ is large with small success probability $p$ then we can approximate this distribution by,

$X \sim \text{Pois}(n\cdot p).$

This property is sometimes referred to as the **law of rare events** or **Poisson limit theorem**.

But, why would we want to do this? A reason to do this is as the number of trials increases, the binomial coefficient $\binom{n}{k}$ gets very hard or even impossible to compute. Instead the calculation of the poisson distribution does not suffer from these computational restrictions and can be easily calculated irrespective of the number of trials.
"""

# ╔═╡ 80696f1c-1b5f-11eb-0517-a33548797627
md"n = $(@bind pois_comp_n Slider(10:200, default = 100, show_value = true))"

# ╔═╡ 9d826ad6-1b5f-11eb-3292-038f89937626
md"p = $(@bind pois_comp_p Slider(0:.001:1, default = 0.05, show_value = true))"

# ╔═╡ a4ad3202-186a-11eb-240e-99cbe7aa0846
md"#### Continuous probability distributions"

# ╔═╡ cf4cc778-186a-11eb-2844-25256f858c1c
md"##### Normal distribution"

# ╔═╡ 390a9d06-1a99-11eb-2c3a-13e027732e54
md"""
where the parameter $\mu$ is the expected value and the parameter $\sigma$ is the standard deviation of the distribution. The two parameters are **independent** meaning that as we change $\mu$, $\sigma$ stays the same and vice versa. Note that this is *not* the case for many distributions we discussed so far. 

Typically we write a normally distributed random variable as $X \sim \text{N}(\mu, \sigma)$.

From the following plot it can be seen that the normal distribution is **symmetric** around the expected value $\mu$. This means that the density is equal at the same distance from the mean or formally $f(x - \mu ~|~ \mu, \sigma) = f(x + \mu ~|~ \mu, \sigma)$.
"""

# ╔═╡ 61b63f50-f431-11ea-0864-637e5c1234db
md"μ = $(@bind μ Slider(-1:0.01:1, default = 0, show_value = true))"

# ╔═╡ 7231265e-f431-11ea-3939-03cf49e56891
md"σ = $(@bind σ Slider(1:0.01:3, default = 1, show_value = true))"

# ╔═╡ 2e8eaa0a-1c21-11eb-14bd-1353f04e31a4
md"""
##### The standard normal distribution
An important special case of the normal distribution is the *standard normal distribution*. The standard normal distribution is just a normal distribution with expected value μ = 0 and standard deviation σ = 1. This distribution is especially important, because it is commonly used for statistical tests and historically the values of the cumulative distribution function were tabulated for the standard normal distribution only. 

> Nowadays, the probabilities for the normal distribution can be easily calculated in (statistical) software.

It is only necessary to tabulate the values for this distribution because we can convert any normally distributed variable $X$ to a standard normal distribution by a process called **standardization**. If, 

$X \sim \text{N}(\mu, \sigma)$

then a random variable with standard normal distribution, 

$Y \sim \text{N}(0, 1)$

can be achieved by 

$Y = \frac{X - \mu}{\sigma}.$
"""

# ╔═╡ e17bd2b2-1c23-11eb-3afd-abd076c8f74c
md"""
##### Working with the cumulative distribution function
For many statistical tests as well as statistical inference it is necessary to calculate probabilities for the (standard) normal distribution. A straight forward application is calculating probabilities of the form

$P(X \leq x ~|~ \mu, \sigma)$

which is just the value of the cumulative distribution function at the value $x$. At other times one might need the complementary probability, 

$P(X \geq x ~|~ \mu, \sigma).$

Since the normal distribution is bound to the rules of probability theory this probability is easily calculated by 1 minus the cumulative distribution function at $x$, 

$P(X \geq x ~|~ \mu, \sigma) = 1 - P(X \leq x ~|~ \mu, \sigma).$

Sometimes we need to calculate the probability of an interval with a lower and upper bound, 

$P(a \leq X \leq b ~|~ \mu, \sigma).$

To accomplish this we first calculate $P(X \leq b ~|~ \mu, \sigma)$ (the cumulative distribution function at $b$), then $P(X \leq a ~|~ \mu, \sigma)$ (the cumulative distribution function at $a$) and substract them, 

$P(a \leq X \leq b ~|~ \mu, \sigma) = P(X \leq b ~|~ \mu, \sigma) - P(X \leq a ~|~ \mu, \sigma).$

The complementary probability, the so called **tail area probability**, is again 

$P(X \leq a \cup X \geq b ~|~ \mu, \sigma) = 1 - P(a \leq X \leq b ~|~ \mu, \sigma).$
"""

# ╔═╡ 1027a0bc-1c26-11eb-330b-a36bf3405b2b
md"lower bound: $(@bind norm_cdf_lwr Slider(-5:.01:5, default = -5, show_value = true))"

# ╔═╡ 3c175454-1c26-11eb-2b16-4b771331e1d2
md"upper bound: $(@bind norm_cdf_upr Slider(-5:.01:5, default = 0, show_value = true))"

# ╔═╡ d13544e4-1c2b-11eb-2a55-fd7d9287034a
md"""
Modern statistical software can calculate the values for the cumulative distribution function of the normal distribution (and other distributions) so tabulated values are no longer needed. 

- In SPSS: -
- In R: The `pnorm(q, mean, sd)` function calculates P(X ≤ q) for a normal distribution with expected value `mean` and standard deviation `sd`.  
- In Julia: The function `cdf(d, x)` can be used to calculate P(X ≤ x) for an arbitrary distribution `d`
- In Excel: `NORM.DIST(x, mean, standard_dev, TRUE)` can calculate P(X ≤ x) of a normal distribution with expected value `mean` and standard deviation `standard_dev`. 

"""

# ╔═╡ e77ccf9a-1c28-11eb-2988-29d7d760d63a
md"""
##### Quantiles of the normal distribution
Under certain circumstances, e.g. the calculation of confidence intervals (see below), we have the inverse questions: *What is the quantile (x axis value) of the normal distribution for which the probability is a certain value?* Formally this is finding the value $x$ that satisfies,

$P(X \leq x ~|~ \mu, \sigma) = \alpha$

Where $\alpha$ is known and specified by the researcher. The **quantile function** gives us the answer to this question:

α = $(@bind norm_quant_α Slider(0.01:.01:.99, default = .5, show_value = true))

μ = $(@bind norm_quant_μ Slider(-3:.01:3, default = 0, show_value = true))

σ =$(@bind norm_quant_σ Slider(0.5:.01:3, default = 1, show_value = true))

"""

# ╔═╡ c07c4106-1c2a-11eb-2330-11c505f4ba81
md"P(X ≤ x | μ = $(norm_quant_μ), σ = $(norm_quant_σ)) = $(norm_quant_α) → x = $(quantile(Normal(norm_quant_μ, norm_quant_σ), norm_quant_α))"

# ╔═╡ 0c5a169c-1c29-11eb-3675-c1ba396f2d1d
md"""
Note that the values depend not only on the chosen probability value $\alpha$ but also on the parameters of the distribution $(\mu, \sigma)$. For the standard normal distribution the values of the quantile function are called **z-values**. For z-values we also sometimes write

$P(X \leq x ~|~ \mu = 0, \sigma = 1) = \alpha \rightarrow z_\alpha.$

In statistical software you can calculate the quantiles of a normal distribution in the following way: 

- In SPSS: -
- In R: `qnorm(p, mean, sd)` calculates value x of a normal distribution with expected value `mean` and standard deviation `sd` for which P(X ≤ x) = `p`.  
- In Julia: The `quantile(d, x)` function allows you to calculate quantiles of arbitrary distributions `d` for probability `x`. 
- In Excel: The function `NORM.INV(probability, mean, standard_dev)` gives you the value x of a normal distribution with expected value `mean` and standard deviation `standard_dev` for which P(X ≤ x) = `probability`. 

"""

# ╔═╡ 09ef8522-1c2e-11eb-3681-79a262775de5
md"""
##### Applied in practice: ...
"""

# ╔═╡ 2767c1f0-1c2e-11eb-3ac2-91f3fe6c7ff3
md"""
##### Bonus: The central limit theorem
In the introduction to the normal distribution it was noted that the normal distribution is special mainly because of a result called the *central limit theorem*. The central limit theorem states that sums (or averages) of many random variables - which need not to be normal - will have an approximately normal distribution. Formal detail of The central limit theorem will be skipped here, but the theorem has many important implications in statistical application. Most notably

- It allows us to make plausible assumptions about the distribution for our hypothesis tests
- Many distributions will be approximately normal under certain circumstances

"""

# ╔═╡ 1de538f8-1aa9-11eb-3e04-cd877a3189b4
@bind clt_t Clock(1, false, false)

# ╔═╡ 35d3f606-1aac-11eb-3d3f-939fb1664d38
@bind clt_n Slider(1:25, default = 5, show_value = true)

# ╔═╡ 434481aa-1aa9-11eb-07be-bdae3a394a77
@bind clt_new_sequence Button("New sequence")

# ╔═╡ 10339808-1aab-11eb-0372-7763d8552bce
@bind clt_population_dist Select(["norm" => "normal", "chisq" => "skewed", "bimodal" => "bimodal"])

# ╔═╡ dd4f5eac-1aac-11eb-0697-bd08f7aa0b38
begin
	if clt_population_dist == "norm"
		cltDist = Normal(5, 1.5)
	elseif clt_population_dist == "chisq"
		cltDist = Chisq(4)
	elseif clt_population_dist == "bimodal"
		cltDist = MixtureModel([Normal(3.5, 1), Normal(7, 0.75)])
	end
	clt_popdist_range = 0:.01:10
	plot(clt_popdist_range, pdf.(cltDist, clt_popdist_range), legend = false)
end

# ╔═╡ 39979854-1aa9-11eb-1357-49ea07d9e5dc
begin
	clt_new_sequence
	clt_means = [mean(rand(cltDist, clt_n)) for i = 1:1000]
end

# ╔═╡ 2ff866b6-1aa9-11eb-21b8-d77a79095f0c
begin
	clt_t
	clt_range = -3:.01:3
	plot(clt_range, pdf.(Normal(mean(cltDist), std(cltDist)/sqrt(clt_n)), clt_range), label = "theoretical distribution", ylimits = [0, 2.25])
	histogram!(clt_means[1:clt_t], normalize = true, label = "sampling distribution")
end

# ╔═╡ bd43c770-fc15-11ea-0280-fbca8eff4b1a
md"""##### χ² distribution
The *χ² distribution* is a special continuous probability distribution. It is most commonly used for statistical hypothesis testing. It's probability density function can be written as,

$f(x ~|~ \nu) = \frac{1}{2^\frac{\nu}{2}\Gamma(\frac{\nu}{2})}x^{\frac{\nu}{2}-1}e^{-\frac{x}{2}}.$

The shape of the distribution is governed by a single parameter $\nu$ - the **degrees of freedom**. The expected values of the χ² distribution is, 

$\mu = \nu$

and it has a variance of

$\sigma^2 = 2\nu.$

The short notation for a χ² distributed random variable is 

$X \sim \chi^2(\nu)$

The χ² distribution arises when squared and standard normally distributed random variables are added, which is why it is commonly encountered in hypothesis testing procedures. Mathematically written, if $X_1, \ldots, X_k$ are distributed as $X_i \sim \text{N}(0, 1)$ then $Y = \sum_{i=1}^k X_i^2$ will follow the distribution $Y \sim \chi^2(k)$.

"""

# ╔═╡ 386dc956-1a9c-11eb-063f-e920755e84e6
md"ν = $(@bind ν_chisq Slider(1:10, default = 1, show_value = true))"

# ╔═╡ 557ba964-1a9c-11eb-1ca6-99b470f1f9f2
md"μ = $(ν_chisq)"

# ╔═╡ 0a2bfa7e-1a9d-11eb-0da5-1daf0950f7d1
md"σ² = $(2*ν_chisq)"

# ╔═╡ 9b1aa96e-fc15-11ea-1a2e-e9a882e1ea5a
md"""
##### Student's T distribution
The *T distribution* is another continuous probability distribution that is commonly used in statistical estimation and hypothesis testing. The probability density function of the T distribution is, 

$f(x ~|~ \nu) = \frac{\Gamma\left(\frac{\nu + 1}{2}\right)}{\sqrt{\nu\pi} \Gamma\left(\frac{\nu}{2}\right)} \left( 1 + \frac{x^2}{\nu} \right)^{-\frac{\nu + 1}{2}}$


Just like the χ² distribution, the only parameter of the T distribution are the **degrees of freedom** $\nu$. The expected value of the T distribution is 0 for $nu > 1$ and undefined otherwise,

$\mu = 0, \quad\text{for}\ \nu > 1$

The variance is given by, 

$\sigma^2 = \frac{\nu}{\nu - 2}, \quad\text{for}\ \nu > 2$

for $\nu > 2$ the variance is undefined. T distributed random variables are usually written as,

$X \sim t(\nu).$
"""

# ╔═╡ 5e71c020-1aa2-11eb-397f-47d88f18b320
md"ν = $(@bind ν_t Slider(1:20, default = 5, show_value = true))"

# ╔═╡ 3b3d7bb6-1b75-11eb-2cff-0b4b33187e62
md"###### Relationship between normal, χ² and Student's T distribution"

# ╔═╡ 552edd8c-1c33-11eb-1708-43bc8c095cf0
md"""
The T, χ² and normal distribution have a special relationship. It is this relationship why the T distribution is encountered commonly in statistical testing. If we have two random variables, one with a χ² and one with a standard normal distribution, 

$X \sim \text{N}(0, 1)$

$Y \sim \chi^2(\nu)$

then the random variable $Z$ will follow a T distribution, 

$Z = \frac{X}{\sqrt{\frac{Y}{\nu}}} \sim \text{t}(\nu).$

"""

# ╔═╡ dc5c2300-fc15-11ea-3fae-971e3ccc7e3d
md"""## Statistical inference & estimation"""

# ╔═╡ 9a889426-1a9a-11eb-2693-01009a8e8019
md"""
In the previous section we have seen some distributions and their associated parameters. In practical applications we neither observe the distributions themselves nor their parameters. Instead, what we have to do is to *assume a statistical model* (probability distribution) and *estimate* the parameters of that model from sampled data. Sometimes the probability models arise naturally, such as in the coin toss example, but most of the time we just assume a convenient model based on our knowledge of the process.  
"""

# ╔═╡ 711d491a-1c34-11eb-3002-557c1c0ca185
md"""
### Types of estimators
Not only can we infer the *best value* of the parameters (**point estimators**), but also quantify the uncertainty of our estimates (**confidence intervals**). 

> ⚠️ Population parameters are typically denoted by greek letters, e.g. $\mu$ for the expected value. *Estimators* of population parameters are described by the same greek letter with a hat, e.g. $\hat{\mu}$. 

##### Point estimators
For the *best value* or *representative value* estimates the quality of an estimation procedure can be described by three properties:

**Unbiasedness**

An estimator is unbiased, if the *Bias* between the population value and the estimator is 0,

$\text{Bias}(\hat{\theta}, \theta) = E(\hat{\theta}) - \theta = 0.$

This will be the case only if the expected value of the estimator is $E(\hat{\theta}) = \theta$. In practical terms this means that if we repeatedly estimate the parameter for different samples, we get the population value on average.  

An example of a biased estimator is the estimator for the variance, 

$\hat{\sigma}^2 = \frac{1}{n}\sum_{i=1}^n (x_i - \overline{x})^2$

which does not approach the true population variance $\sigma^2$ as the sample size increases. Instead, 

$\hat{\sigma}^2 = \frac{1}{n - 1}\sum_{i=1}^n (x_i - \overline{x})^2$

is the unbiased estimator for the population variance $\sigma^2$ (without proof). 

All else being equal, unbiased estimators are to be preferred over biased estimators. 

**Consistency**

Consistency of an estimator refers to the fact that as we increase the sample size, the estimator converges to the population value. This means that as we increase our sample size the difference between the estimated value gets smaller on average. 

**Efficiency**

An estimator is said to be efficient if it estimates the parameter of interest in the *best possible manner*. Typically an estimator $\hat{\theta}_1$ is considered *more efficient* than an estimator $\hat{\theta}_2$ if the variance if it has smaller error than $\hat{\theta}_2$.

**Sufficiency**

An estimator is called *sufficient* if it uses the maximum amount of information in the sample. 

##### Interval estimators


"""

# ╔═╡ db26d1e0-1c33-11eb-1660-0730eae97779
md"""
- Binomial model
- Poisson model
- Normal model
"""

# ╔═╡ 4cf2848e-1c4a-11eb-3ac0-4b18f68495e0
md"""
### The binomial model
The most common application of the binomial model is the estimation of the probability parameter $p$ when the sample size $n$ is known. Under this circumstance the estimator for the probability is given by,  

$\hat{p} = \frac{x}{n}.$

A way to calculate the confidence interval for the estimate we can apply the following formula. Note, however, there are multiple ways to calculate confidence intervals for this model, which will not be covered in this course.

$\hat{p} - z_{1 - \frac{\alpha}{2}} \cdot \sqrt{\frac{\hat{p} (1- \hat{p})}{n}} \leq p \leq \hat{p} + z_{1 - \frac{\alpha}{2}} \cdot \sqrt{\frac{\hat{p} (1- \hat{p})}{n}}$
"""

# ╔═╡ bdc6a9cc-1c4c-11eb-10ad-093882351765
begin
	male_births = 43580
	female_births = 41372
	total_births = male_births + female_births
	p̂ = female_births / total_births
end

# ╔═╡ 7e69cd06-1c4a-11eb-03cc-3778422b2cbe
md"""
##### Application: Estimating birth ratios
In the lecture on sampling we have seen a hypothetical example of the birth ratio when discussing sampling. Now that we have covered the basics of statistical modeling, we can turn to the estimation of birth ratios for real data. In 2019, $(female_births) babies in Austria were born female out of $(total_births) in total. Assuming the birth ratio does not change over time, we can infer the population birth ratio using the binomial model. 

Our best estimate is simply the number of female births divided by the total births,
"""

# ╔═╡ d29f0e04-1c4f-11eb-2f0e-59db5e9ca302
md"The results suggest that the birth ratio is not 1/2, but there are more male births than female births. But how uncertain is our estimate?"

# ╔═╡ 3a5df8f0-1c4d-11eb-0cd8-4bf56251ae86
md"α = $(@bind br_α Slider(.01:.01:.99, default = .05, show_value = true))"

# ╔═╡ 0a300d1a-1c4d-11eb-2668-21c23079acac
md"To answer this question we can calculate the $(round(Int, (1 - br_α) * 100))%-confidence interval,"

# ╔═╡ fc96b292-1c4d-11eb-0e6c-99cae39589d1
md"This estimate is pretty accurate since there are a lot of observations."

# ╔═╡ 80e8800a-1c3a-11eb-3014-8ba67436f1e3
md"""
### The Poisson model
If we assume a Poisson distribution for our statistical model, e.g. when modeling count data, then we care about estimating the parameter λ. The maximum likelihood estimator

$\hat{\lambda} = \frac{1}{n}\sum_{i=1}^n k_i$

can be used to estimate the parameter. To address uncertainty in our estimate, we can calculate the confidence interval for λ with confidence level 1 - α by

$\frac{1}{2n}Q(\frac{\alpha}{2}, 2k) \leq \lambda \leq \frac{1}{2n}Q(1 - \frac{\alpha}{2}; 2k + 2),$

where $Q(p, n)$ is the quantile function of the χ² distribution with $n$ degrees of freedom, and $k = \sum_{i=1}^n k_i$.



"""

# ╔═╡ 1a64a1be-1c3d-11eb-0385-cb21ecce4e18
md"""
##### Application: Road traffic deaths revisited
Statistik Austria provides data on road traffic deaths in Vienna since 2010. Let us assume that the road traffic deaths in Vienna every year follow a Poisson distribution with constant parameter λ, i.e. the expected number of road traffic deaths stay the same every year, then we can apply the Poisson model to the sampled data. 

First take a look at the raw data,
"""

# ╔═╡ 4b9fff1a-1c3d-11eb-11ac-c9de8a9b2aec
road_traffic_deaths = [29, 22, 24, 17, 21, 13, 19, 20, 18, 12]

# ╔═╡ 63f84e28-1c3d-11eb-2366-57c6f696e6cd
years = 2010:2019

# ╔═╡ 7dab61d4-1c3d-11eb-0376-39b29753fa7b
λ̂ = mean(road_traffic_deaths)

# ╔═╡ f21396b2-1c3e-11eb-050e-5b313974aee2
md"""
It seems that our assumption about expected road traffic deaths staying the same is violated as the number of traffic deaths seems to be decreasing. For simplicity, let us still continue with our analysis.

By calculating the mean road traffic deaths, we get our point estimate $\hat{\lambda}$ = $(λ̂). 
"""

# ╔═╡ 5fc11a7a-1c3f-11eb-086d-ad6eeffe5e14
md"Since the Poisson distribution is completly defined by our estimated parameter we can plot the distribution with $\hat{\lambda}$ = 19.5."

# ╔═╡ 7fa4042a-1c40-11eb-2536-3da95ea9f7f2
md"number of deaths: $(@bind rtd_n Slider(0:40, default = 20, show_value = true))"

# ╔═╡ 1d1f56d8-1c40-11eb-1b40-e3c5cb7c447d
md"""
If we were interested in the road traffic deaths in the following year, 2020, we can also derice this from our statistical model. Assuming the expected number of road traffic deaths stay the same (as in the previous years), our best estimate is $(λ̂) for 2020.

Not only can we calculate the best estimate, but also ask other questions such as: What is the probability that the number of road traffic deaths excedes $(rtd_n)? Application of the rules of probability theory gives us the result, 
"""

# ╔═╡ 687c4126-1c41-11eb-0245-abf9f9d5e831
md"α = $(@bind rtd_α Slider(.01:.01:.99, default = .05, show_value = true))"

# ╔═╡ 497828a8-1c41-11eb-3eae-af37ff72c89f
md"To quantify the uncertainty in our estimate, we can calculate the $(round(Int, (1 - rtd_α)*100))%-confidence interval by applying the formula above."

# ╔═╡ d2c88b38-1c3d-11eb-06d4-710e41cf18f0
begin
	k = sum(road_traffic_deaths)
	n = length(road_traffic_deaths)
	pois_ci_lower = 1/2n * quantile(Chisq(2k), rtd_α/2)	
	pois_ci_upper = 1/2n * quantile(Chisq(2k + 2), 1 - rtd_α/2)
	
	(pois_ci_lower, pois_ci_upper)
end

# ╔═╡ 418f6460-1c43-11eb-2a2b-53b3d387037b
md"""
### The normal model
A very common statistical model arises when we assume a normal distribution for our process. In this simple model we most likely care about the expected value of the distribution μ. The estimate for the population mean is simply sample mean,

$\hat{\mu} = \frac{1}{n}\sum_{i=1}^n x_i.$

Already addressed when discussing properties of point estimators the unbiased estimate of the population variance is given by

$\hat{\sigma}^2 = \frac{1}{n - 1}\sum_{i=1}^n (x_i - \hat{\mu})^2.$
	
To calculate the 1 - α confidence interval for the population mean we can apply this formula, 

$\hat{\mu} - Q(1 - \frac{\alpha}{2}, n - 1) \cdot \frac{\hat{\sigma}}{\sqrt{n}} \leq \mu \leq \hat{\mu} + Q(1 - \frac{\alpha}{2}, n - 1) \cdot \frac{\hat{\sigma}}{\sqrt{n}}$

where $Q(p, n)$ is the quantile function of the T distribution with n degrees of freedom.[^2]

"""

# ╔═╡ 42cbf2e4-1c45-11eb-3f2d-c7a541614366
md"""
##### Application: Website engagement
Suppose we gathered data on 80 representative users about the usage of our website. The data contains the time spent on our website as an indicator of website engagement. 

We can visualize the raw data as an histogram.
"""

# ╔═╡ 4fcfb162-1c76-11eb-13ff-ff883bb4632d
md"Assuming the time spent on the website follows a normal distribution and the time spent on the website is not determined by external factors (an unrealisic assumption), we can estimate the expected value of the population by calculating the sample mean,"

# ╔═╡ 0cad510a-1c78-11eb-2dbe-c1639a9aba5b
md"The estimate for the population variance σ² is,"

# ╔═╡ 6ba53664-1c78-11eb-3bf3-1935bbd7ed4e
md"For better interpretability we can instead turn to the estimate for the population standard deviation, which gives us the average variability from the population mean."

# ╔═╡ 59343792-1c77-11eb-2697-afd8f709d51f
md"α = $(@bind website_α Slider(.01:.01:.99, default = .05, show_value = true))"

# ╔═╡ d27894e6-1c76-11eb-2dad-37b922437534
md"To determine the accuracy of our estimate for the population mean we can again turn to confidence intervals. The $(round(Int, (1 - website_α)*100))%-confidence interval for the sample mean in this example is"

# ╔═╡ da109f0a-1c76-11eb-2c62-f324421e75ea
md"> ⚠️ We will later see extensions of this simple normal model when discussing **linear regression**. In linear regression we can also incorporate external variables such as *age* or *gender* to determine the influence of those variables on the outcome."

# ╔═╡ 80d7e2fe-186b-11eb-38a0-d75d659dac55
md"## Summary"

# ╔═╡ 047a804a-19ce-11eb-3fe2-4fe940e78734
md"""
### Footnotes

[^1]: This result can be generalized to more than 2 sets, if $X_i \cap X_j = \emptyset$ for all $i \neq j$. Then, the probability for the set union is $P(\bigcup_{i=1}^\infty X_i) = \sum_{i=1}^\infty P(X_i)$.

"""

# ╔═╡ cf23e02c-1c74-11eb-19be-05fb6b459f97
md"""[^2]: This section assumes that the population variance is unknown, which is the typical case in application. If instead the population variance $\sigma^2$ is known and need not to be estimated, confidence intervals are instead calculated based on the quantiles of the standard normal distribution, 

$\hat{\mu} - z_{1 - \frac{\alpha}{2}} \cdot \frac{\sigma}{\sqrt{n}} \leq \mu \leq \hat{\mu} + z_{1 - \frac{\alpha}{2}} \cdot \frac{\sigma}{\sqrt{n}}.$
"""

# ╔═╡ 72b3c9fe-186b-11eb-111f-33cd57974134
md"## Computational resources"

# ╔═╡ 78747fdc-186b-11eb-10bb-e1b812e460ce
md"This section can be safely ignored..."

# ╔═╡ 8ad171d0-186b-11eb-2d03-3b2d1fbeebd6
md"### Markdown layouting"

# ╔═╡ 1899c410-fc13-11ea-3779-99e4db3939a1
function two_columns(l, r, f = [50, 50])
	html_l = Markdown.html(l)
	html_r = Markdown.html(r)
	res = """
	<div style='display: flex'>
		<div style='width: $(f[1])%'>$(html_l)</div>
		<div style='width: $(f[2])%'>$(html_r)</div>	
	</div>
	"""
	HTML(res)
end

# ╔═╡ e2f533c0-fc13-11ea-0921-5d974294b4fe
two_columns(md"""
The *Poisson distribution* is a discrete probability distribution named after Siméon Denis Poisson (right). The Poisson distribution can be employed to model *count data* and is most often used to model the number of times an event occurs in an interval of time. 
	
The probability mass function of the Poisson distribution is given by, 
	
$f(k ~|~ \lambda) = \frac{\lambda^k e^{-\lambda}}{k!}$
	
where $e$ is [Euler's number](https://en.wikipedia.org/wiki/E_(mathematical_constant)). The distribution is governed by a single parameter $\lambda$, which is simultanously the expected value and the variance, 
	
$\mu = \lambda, \qquad \sigma^2 = \lambda.$

""",
md"""
![asd](https://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Sim%C3%A9onDenisPoisson.jpg/800px-Sim%C3%A9onDenisPoisson.jpg)
	
-- *Siméon Denis Poisson*
""", [66, 33])

# ╔═╡ 06490b90-fc13-11ea-190f-85fd09099588
two_columns(md"""
The *normal distribution* or *Gaussian distribution* is arguably the most important and often used probability distribution in statistics. There are many reasons why the normal distribution is special, but one of them is the so called **central limit theorem** which states that under certain circumstances averages of arbitrary random variables follow a normal distribution (see below). As such, the normal distribution is a natural fit to model many random processes. 
	
The normal distribution has the famous **bell shape**. It's probability density function is given by, 
	
$f(x ~|~ \mu, \sigma) = \frac{1}{\sigma\sqrt{2\pi}}e^{-\frac{1}{2}\left( \frac{x - \mu}{\sigma} \right)^2}$
	
""", md"""
![Carl Friedrich Gauß](https://upload.wikimedia.org/wikipedia/commons/3/33/Bendixen_-_Carl_Friedrich_Gau%C3%9F%2C_1828.jpg)

-- *Carl Friedrich Gauss*
""", [66, 33])

# ╔═╡ 201b0000-fc13-11ea-325e-0fa70d049ec7
center(x) = HTML("<div style='text-align: center'>$(Markdown.html(x))</div>")

# ╔═╡ ad9baec0-1aa9-11eb-2d1b-43813bf8e359
md"### Confidence intervals" 

# ╔═╡ b41df384-1aa9-11eb-3b48-2933f6c96557
begin
	plusminus(x::Number, y::Number) = (x - y, x + y)
	±(x, y) = plusminus(x, y)
end

# ╔═╡ 1ae4e5bc-1c4d-11eb-1d0a-73b3a05dd7be
p̂ ± quantile(Normal(0, 1), 1 - br_α/2) * sqrt((p̂ * (1 - p̂))/(sum(female_births .+ male_births)))

# ╔═╡ c52cfd00-1aa9-11eb-3c40-2bc69bce2c71
function ci(x, α = 0.05)
	est = mean(x)
	se = std(x)/sqrt(length(x))
	df = length(x) - 1
	est ± se * quantile(TDist(df), 1 - α/2)
end

# ╔═╡ 3de5f658-1b71-11eb-3d67-03eede50d771
md"### Graphic design"

# ╔═╡ 41e810e0-1b71-11eb-0c0f-0f6780b6e01c
colors = ["#ef476f","#ffd166","#06d6a0","#118ab2","#073b4c"]

# ╔═╡ 5e73854c-1aa3-11eb-37fd-f1b78af16572
# law of large numbers
begin
	lln_t
	
	pidx = lln_t > 1000 ? (1:1000) : (1:lln_t)

	plot(pidx, lln_means[pidx], xlimits = [0, 1000], xlabel = "trials", ylimits = [1, 6], label = "observed mean", color = colors[1], lw = 2)
	hline!([3.5], label = "theoretical expectation", color = "grey")
end

# ╔═╡ bf125e56-1c7a-11eb-26b6-bd7f32ade0e7
begin
	discrete_range = 0:10
	binomPmf = pdf.(Binomial(10, 0.33), discrete_range)
	binomCdf = cdf.(Binomial(10, 0.33), discrete_range)
	
	binompmf = plot(discrete_range, binomPmf, color = colors[3], legend = false, seriestype = :bar, lw = 0, fillalpha = 0.5, xticks = discrete_range, xlabel = "x", ylabel = "P(X = x)")
	plot!(0:binom_x, pdf.(Binomial(10, 0.33), 0:binom_x), color = colors[3], seriestype = :bar, lw = 0)
	
	binomcdf = plot(discrete_range, binomCdf, color = colors[3], legend = false, seriestype = :step, lw = 2, xticks = discrete_range, xlabel = "x", ylabel = "P(X ≤ x)")
	plot!([binom_x], [cdf(Binomial(10, .33), binom_x)], seriestype = :scatter, markersize = 4, color = colors[3])
	
	plot(binompmf, binomcdf, size = [660, 320])
end


# ╔═╡ 7ee273b0-192e-11eb-2343-c795f05f2e4f
begin
	bernDist = Bernoulli(bernoulli_p)
	bern_range = 0:1
	bern_pmf = plot(bern_range, pdf.(bernDist, bern_range), ylimits = [0, 1], legend = false, seriestype = :bar, xticks = bern_range, ylabel = "P(X = x | p)", xlabel = "x", color = colors[3], lw = 0)
	bern_cdf = plot(bern_range, cdf.(bernDist, bern_range), ylimits = [0, 1], seriestype = :step, legend = false, ylabel = "P(X ≤ x | p)", xlabel = "x", color = colors[3], lw = 2)
	
	plot(bern_pmf, bern_cdf, size = [660, 320])
end

# ╔═╡ 80d960b8-1b52-11eb-3fa8-f92961ad90db
md"Below we can see the probability mass function and cumulative distribution function of a Bernoulli distribution with parameter p = $(bernoulli_p). The expected value of this distribution is μ = $(mean(bernDist)), which means that we expect a relative frequency of success of $(mean(bernDist)) if we repeatedly sample from this distribution. The variance of the distribution is σ² = $(bernoulli_p) ⋅ $(1 - bernoulli_p) = $(var(bernDist))."

# ╔═╡ eb4cd85a-1a94-11eb-3bde-09b90f38742b
begin
	binomDist = Binomial(binomial_n, binomial_p)
	binom_range = 0:binomial_n
	binom_pmf = bar(binom_range, pdf.(binomDist, binom_range), legend = false, xlabel = "k", ylabel = "P(X = k | n, p)", color = colors[3], lw = 0)
	binom_cdf = plot(binom_range, cdf.(binomDist, binom_range), legend = false, seriestype = :step, xlabel = "k", ylabel = "P(X ≤ k | n, p)", lw = 2, color = colors[3])
	
	plot(binom_pmf, binom_cdf, size = [660, 320])
end

# ╔═╡ 1a41deba-1b53-11eb-1428-65c5e8281468
md"""
The *binomial distribution* is another common discrete probability distribution. It arises if we have multiple *independent and identically distributed* random variables which follow a Bernoulli distribution with probability p. In this case we are interested in the *number of successes (k)* out of the *number of trials (n)*.    

The probability mass function for the binomial distribution is given by, 

$f(k ~|~ n, p) = \binom{n}{k}p^k (1-p)^{n-k}$

where $\binom{n}{k}$ is the [binomial coefficient](https://en.wikipedia.org/wiki/Binomial_coefficient). The expected value (the expected number of successes in *n* trials) can be calculated by, 

$\mu = np$

and the variance of the distribution is 

$\sigma^2 = np(1 - p).$

A random variable with binomial distribution can also be denoted by $X \sim \text{B}(n, p)$.

###### Bernoulli and binomial distributions
The relationship between the binomial distribution and the Bernoulli distribution can be easily seen if we consider the special case for $n = 1$ which is just a single Bernoulli trial. Then, 

$f(k ~|~ n = 1, p) = \binom{1}{k}p^k(1-p)^{1 - k}.$

Since for a single trial there are only two possible outcomes, $k = 0$ (no success in 1 trial) or $k = 1$ (1 success in 1 trial) we arrive at, 

$f(k = 0 ~|~ n = 1, p) = \binom{1}{0}p^0(1-p)^{1 - 0} = 1 - p$

for the failure, and 

$f(k = 1 ~|~ n = 1, p) = \binom{1}{1}p^1(1-p)^{1 - 1} = p$

This is *identical* to the probability mass function for the Bernoulli distribution.  


The binomial distribution can be applied if we have multiple independent and identical Bernoulli trials. For example, if we were to toss a fair coin not one time but repeat the coin toss $(binomial_n) times, the binomial distribution tells us that the expected number of heads is μ = $(binomial_n) ⋅ $(binomial_p) = $(mean(binomDist)) and the variance is σ² = $(binomial_n) ⋅ $(binomial_p) ⋅ $(1 - binomial_p) = $(var(binomDist)). 
"""

# ╔═╡ 3156f7d4-1b5d-11eb-2d9e-3168a7ee084f
md"""
The probability to observe less than 5 successes or P(X ≤ 5 | n = $binomial_n, p = $binomial_p) can be calculated through the cumulative density function which gives us P(X ≤ k | n, p) in the general cases or by just summing up the probabilities P(X = 0 | n, p) + … + P(X = 5 | n, p). In this example P(X ≤ 5 | n = $binomial_n, p = $binomial_p) = $(cdf(binomDist, 5)). 
"""

# ╔═╡ df7b0e20-f431-11ea-0304-2d1461c57a41
begin
	poisDist = Poisson(λ)
	pois_range = 0:75
	poisson_pmf = bar(pois_range, pdf.(poisDist, pois_range), legend = false, xlabel = "k", ylabel = "P(X = k | λ)", color = colors[3], lw = 0)
	poisson_cdf = plot(pois_range, cdf.(poisDist, pois_range), legend = false, seriestype = :step, xlabel = "k", ylabel = "P(X ≤ k | λ)", color = colors[3], lw = 2)
	
	plot(poisson_pmf, poisson_cdf, size = [660, 320])
end

# ╔═╡ 5d6b7434-1b59-11eb-2b73-71ee2c5cc45c
md"""
Suppose we want to model the number of yearly road traffic deaths in Vienna. [Statistik Austria](https://www.statistik.at/web_de/statistiken/energie_umwelt_innovation_mobilitaet/verkehr/strasse/unfaelle_mit_personenschaden/index.html) provides us with the information that in the year 2019 12 people died due to traffic accidents. Assuming that the number of yearly road traffic deaths is stationary and follow a Poisson distribution we find that (obviously) the expected number of road traffic deaths is μ = $λ and the variance is also σ² = $λ. 

But we can also apply the rules of probability theory to calculate the probability that the road traffic deaths excede some value, based on our assumptions. If we were interested in the probability that the road traffic deaths excede 20, what we want to know is P(X ≥ 20 | λ = $λ). The cumulative density function of the Poisson distribution provides the value P(X ≤ 20 | λ = $λ) = $(round(cdf(poisDist, 20), digits = 3)). To get the appropriate value we take the complementary probability, 1 - P(X ≤ 20 | λ = $λ) = 1 - $(round(cdf(poisDist, 20), digits = 3)) = $(round(1 - cdf(poisDist, 20), digits = 3)). 


"""

# ╔═╡ adaa43d4-1b5f-11eb-1515-4158f9ae3a89
begin
	comp_range = 0:pois_comp_n
	poisComp = pdf.(Poisson(pois_comp_n * pois_comp_p), comp_range)
	binomComp = pdf.(Binomial(pois_comp_n, pois_comp_p), comp_range)
	kl_divergence = kldivergence(poisComp, binomComp)
	
	y_max = maximum([poisComp; binomComp])
	comp_p1 = plot(comp_range, poisComp, seriestype = :bar, legend = false, ylimit = [0, y_max], color = colors[3], lw = 0, title = "Poisson distribution")
	comp_p2 = plot(comp_range, binomComp, seriestype = :bar, legend = false, ylimit = [0, y_max], color = colors[3], lw = 0, title = "Binomial distribution")
	
	plot(comp_p1, comp_p2, size = [660, 320])
end

# ╔═╡ 6e3d9d66-1b61-11eb-0c2b-25956fd9dc4b
md"The difference between the two distributions is $(round(kl_divergence, digits = 3))."

# ╔═╡ 0268b4a0-f432-11ea-3f2c-9fe01f6b1ec1
begin
	normDist = Normal(μ, σ)
	norm_range = -5:0.01:5
	norm_pdf = plot(norm_range, pdf.(normDist, norm_range), legend = false, ylimit = [0, 0.5], ylabel = "f(x | μ, σ)", xlabel = "x", color = colors[3], lw = 2, ribbon = (pdf.(normDist, norm_range), zeros(length(norm_range))), fillalpha = 0.25)
	norm_cdf = plot(norm_range, cdf.(normDist, norm_range), legend = false, seriestype = :step, ylimit = [0, 1], ylabel = "P(X ≤ x | μ, σ)", xlabel = "x", lw = 2, color = colors[3])
	
	plot(norm_pdf, norm_cdf, size = [660, 320])
end

# ╔═╡ 8f1642ae-1a99-11eb-1604-eb4a8c2fb444
md"μ = $(mean(normDist))"

# ╔═╡ a0e6d62e-1a99-11eb-274a-33676f64e92b
md"σ² = $(var(normDist))"

# ╔═╡ 7ba5f9a8-1a9c-11eb-07c1-9bd39bfc91ae
begin
	chisqDist = Chisq(ν_chisq)
	chisq_range = 0:.01:20
	chisq_pdf = plot(chisq_range, pdf.(chisqDist, chisq_range), legend = false, ylimits = [0, 0.5], ylabel = "f(x | ν)", xlabel = "x", color = colors[3], lw = 2, ribbon = (pdf.(chisqDist, chisq_range), zeros(length(chisq_range))), fillalpha = 0.25)
	chisq_cdf = plot(chisq_range, cdf.(chisqDist, chisq_range), legend = false, ylabel = "P(X ≤ x | ν)", xlabel = "x", lw = 2, color = colors[3])
	
	plot(chisq_pdf, chisq_cdf, size = [660, 320])
end

# ╔═╡ 2b36861e-1aa2-11eb-392a-8963fec7defd
begin
	tDist = TDist(ν_t)
	t_range = -3:.01:3
	t_pdf = plot(t_range, pdf.(tDist, t_range), legend = false, ylimit = [0, 0.4], ylabel = "f(x | ν)", xlabel = "x", lw = 2, color = colors[3], ribbon = (pdf.(tDist, t_range), zeros(length(t_range))), fillalpha = 0.25)
	t_cdf = plot(t_range, cdf.(tDist, t_range), legend = false, ylimit = [0, 1], ylabel = "P(X ≤ x | ν)", xlabel = "x", lw = 2, color = colors[3])
	
	plot(t_pdf, t_cdf, size = [660, 320])
end

# ╔═╡ 7be0fb08-1aa2-11eb-2399-19183962fae0
md"μ = $(mean(tDist))"

# ╔═╡ 97faa3ca-1aa2-11eb-23fd-11829adc710f
md"σ² = $(var(tDist))"

# ╔═╡ 83ce9bee-1c3d-11eb-04dc-03733c1fc440
plot(years, road_traffic_deaths, ylimit = [0, 30], lw = 2, color = colors[1], xticks = years, legend = false, xlabel = "year", ylabel = "road traffic deaths")

# ╔═╡ 5657bca0-1c3f-11eb-048f-87259f336df6
begin
	road_traffic_dist = Poisson(λ̂)
	plot(0:40, pdf.(road_traffic_dist, 0:40), seriestype = :bar, legend = false, color = colors[3], lw = 0, xlabel = "road traffic deaths", ylabel = "P(X = k | λ)")
end


# ╔═╡ ac042c28-1c40-11eb-367b-f1e2d6b08002
md"P(X ≥ $(rtd_n) | λ = $(λ̂)) = 1 - P(X ≤ $(rtd_n) | λ = $(λ̂)) = $(round(1 - cdf(road_traffic_dist, rtd_n), digits = 3))"

# ╔═╡ b9928bd6-1c75-11eb-1d42-b7febc8cf7de
begin
	website_data = rand(Normal(220, 33), 80)
	website_n = length(website_data)
	histogram(website_data, legend = false, color = colors[3], lw = 0, nbins = 10, xlabel = "time spent on website", ylabel = "count")
end

# ╔═╡ 66f039e0-1c76-11eb-13c4-2122afa6d83b
μ̂ = mean(website_data)

# ╔═╡ 6aa6beec-1c76-11eb-1b66-a79a1b28bb9e
md"This tells us that on average a user will spend about $(round(Int, μ̂)) seconds on our website."

# ╔═╡ 1c5410ba-1c78-11eb-09c4-ab8612434bae
σ̂² = var(website_data)

# ╔═╡ 5cd672ec-1c78-11eb-0bbf-3d498440bd8a
σ̂ = sqrt(σ̂²)

# ╔═╡ 9ace9972-1c77-11eb-3cfd-a94b40e72df8
μ̂ ± quantile(TDist(website_n - 1), 1 - website_α/2) * σ̂/sqrt(website_n)

# ╔═╡ efb75388-1c28-11eb-35a8-6346c1976117
md"### Helper functions for plots"

# ╔═╡ cd62d804-1c26-11eb-3113-317a750330d4
function fillarea!(dist, r, c) 
	sx = vcat(r, reverse(r))
	sy = vcat(pdf.(dist, r), zeros(length(r)))
	plot!(Shape(sx, sy), color = c, fillalpha = 0.25, lw = 0)
end

# ╔═╡ 79e98da0-1c79-11eb-1a35-ad2083e4dd1f
begin
	continuous_range = -3:.01:3
	normPdf = pdf.(Normal(), continuous_range)
	normCdf = cdf.(Normal(), continuous_range)
	
	stdnorm_pdf = plot(continuous_range, normPdf, lw = 2, color = colors[3], legend = false, xlabel = "x", ylabel = "density")
	fillarea!(Normal(), -3:.01:norm_x, colors[3])
	
	stdnorm_cdf = plot(continuous_range, normCdf, lw = 2, color = colors[3], legend = false, xlabel = "x", ylabel = "P(X ≤ x)")
	plot!([norm_x], [cdf(Normal(), norm_x)], seriestype = :scatter, color = colors[3], markersize = 4)
	
	plot(stdnorm_pdf, stdnorm_cdf, size = [660, 320])
end

# ╔═╡ 490e5d62-1c26-11eb-0a20-177becb5f62f
begin
	stdNorm = Normal()
	std_norm_range = -5:.01:5
	plot(std_norm_range, pdf.(stdNorm, std_norm_range), color = colors[3], lw = 2, legend = false, size = [360, 220])
	fillarea!(stdNorm, norm_cdf_lwr:.01:norm_cdf_upr, colors[3])
end

# ╔═╡ cdf5b628-1c27-11eb-0132-0b918cf7ad40
md"The probability of the selected area is $(round(cdf(stdNorm, norm_cdf_upr) - cdf(stdNorm, norm_cdf_lwr), digits = 3))."

# ╔═╡ Cell order:
# ╟─c222f5a0-f430-11ea-288f-d394ab49704d
# ╠═9202b92c-1862-11eb-04b6-7109223f0f59
# ╟─678f0350-186a-11eb-026b-2b830bf9ebbc
# ╟─24b48fe0-fc14-11ea-26c6-2b2dcabd228e
# ╟─0a8470ee-1920-11eb-2db7-0d83c4f23c58
# ╟─8b6fb1fe-fc14-11ea-33d4-f9a3e18de71b
# ╠═01f52f1e-19c9-11eb-39d1-39278ad7c75b
# ╟─7faaca96-186a-11eb-0ab9-5f2c89947700
# ╠═ed9f8626-1b4f-11eb-1b0b-cbf89694e89a
# ╠═3995e89e-1aa4-11eb-32a6-dd1d24a8f8a3
# ╟─4dcbe96a-1aa4-11eb-1a20-b12e72eb6956
# ╠═a1930630-1aa4-11eb-15be-590e56e680b4
# ╟─5e73854c-1aa3-11eb-37fd-f1b78af16572
# ╟─72b9b3a2-1c79-11eb-2319-6f30c2c89771
# ╟─de8d47cc-1c7b-11eb-1ce7-cb9effafad10
# ╟─af26871a-1c7a-11eb-2137-65cc9d310dac
# ╟─bf125e56-1c7a-11eb-26b6-bd7f32ade0e7
# ╟─ebd5221c-1c7b-11eb-0aee-534b1710b9ef
# ╟─e0cbbda4-1c79-11eb-1cec-0720fb2cde93
# ╟─79e98da0-1c79-11eb-1a35-ad2083e4dd1f
# ╟─89e5ad32-186a-11eb-21c2-0dfbecfc0876
# ╟─91436542-186a-11eb-2814-a930d8607030
# ╟─2b754580-fc15-11ea-38b3-a35d7aa65cc5
# ╟─fdd4168c-1b50-11eb-302d-7d4af0b76c74
# ╟─3b9674b6-1b53-11eb-3ef1-0198f2d103cd
# ╟─80d960b8-1b52-11eb-3fa8-f92961ad90db
# ╟─8cac4b60-192e-11eb-13b1-d7d6da5b571c
# ╟─7ee273b0-192e-11eb-2343-c795f05f2e4f
# ╟─37626710-fc15-11ea-3fe6-6d0a49881fb0
# ╟─1a41deba-1b53-11eb-1428-65c5e8281468
# ╟─3156f7d4-1b5d-11eb-2d9e-3168a7ee084f
# ╟─c907fbce-1a94-11eb-0b43-f53768283d08
# ╟─eb4cd85a-1a94-11eb-3bde-09b90f38742b
# ╟─c883ff10-f431-11ea-3534-d7d48b4e2cf8
# ╟─e2f533c0-fc13-11ea-0921-5d974294b4fe
# ╟─4940ebe0-1b58-11eb-18d7-978f209ae214
# ╟─5d6b7434-1b59-11eb-2b73-71ee2c5cc45c
# ╟─ce405980-f431-11ea-2f2d-1931d9d12580
# ╟─df7b0e20-f431-11ea-0304-2d1461c57a41
# ╟─82707320-1b58-11eb-3459-3998f215951f
# ╟─80696f1c-1b5f-11eb-0517-a33548797627
# ╟─9d826ad6-1b5f-11eb-3292-038f89937626
# ╟─6e3d9d66-1b61-11eb-0c2b-25956fd9dc4b
# ╟─adaa43d4-1b5f-11eb-1515-4158f9ae3a89
# ╟─a4ad3202-186a-11eb-240e-99cbe7aa0846
# ╟─cf4cc778-186a-11eb-2844-25256f858c1c
# ╟─06490b90-fc13-11ea-190f-85fd09099588
# ╟─390a9d06-1a99-11eb-2c3a-13e027732e54
# ╟─61b63f50-f431-11ea-0864-637e5c1234db
# ╟─7231265e-f431-11ea-3939-03cf49e56891
# ╟─8f1642ae-1a99-11eb-1604-eb4a8c2fb444
# ╟─a0e6d62e-1a99-11eb-274a-33676f64e92b
# ╟─0268b4a0-f432-11ea-3f2c-9fe01f6b1ec1
# ╟─2e8eaa0a-1c21-11eb-14bd-1353f04e31a4
# ╟─e17bd2b2-1c23-11eb-3afd-abd076c8f74c
# ╟─1027a0bc-1c26-11eb-330b-a36bf3405b2b
# ╟─3c175454-1c26-11eb-2b16-4b771331e1d2
# ╟─cdf5b628-1c27-11eb-0132-0b918cf7ad40
# ╟─490e5d62-1c26-11eb-0a20-177becb5f62f
# ╟─d13544e4-1c2b-11eb-2a55-fd7d9287034a
# ╟─e77ccf9a-1c28-11eb-2988-29d7d760d63a
# ╟─c07c4106-1c2a-11eb-2330-11c505f4ba81
# ╟─0c5a169c-1c29-11eb-3675-c1ba396f2d1d
# ╠═09ef8522-1c2e-11eb-3681-79a262775de5
# ╠═2767c1f0-1c2e-11eb-3ac2-91f3fe6c7ff3
# ╠═1de538f8-1aa9-11eb-3e04-cd877a3189b4
# ╠═35d3f606-1aac-11eb-3d3f-939fb1664d38
# ╟─434481aa-1aa9-11eb-07be-bdae3a394a77
# ╠═10339808-1aab-11eb-0372-7763d8552bce
# ╠═dd4f5eac-1aac-11eb-0697-bd08f7aa0b38
# ╠═39979854-1aa9-11eb-1357-49ea07d9e5dc
# ╠═2ff866b6-1aa9-11eb-21b8-d77a79095f0c
# ╟─bd43c770-fc15-11ea-0280-fbca8eff4b1a
# ╟─386dc956-1a9c-11eb-063f-e920755e84e6
# ╟─557ba964-1a9c-11eb-1ca6-99b470f1f9f2
# ╟─0a2bfa7e-1a9d-11eb-0da5-1daf0950f7d1
# ╟─7ba5f9a8-1a9c-11eb-07c1-9bd39bfc91ae
# ╟─9b1aa96e-fc15-11ea-1a2e-e9a882e1ea5a
# ╟─5e71c020-1aa2-11eb-397f-47d88f18b320
# ╟─7be0fb08-1aa2-11eb-2399-19183962fae0
# ╟─97faa3ca-1aa2-11eb-23fd-11829adc710f
# ╟─2b36861e-1aa2-11eb-392a-8963fec7defd
# ╟─3b3d7bb6-1b75-11eb-2cff-0b4b33187e62
# ╟─552edd8c-1c33-11eb-1708-43bc8c095cf0
# ╟─dc5c2300-fc15-11ea-3fae-971e3ccc7e3d
# ╠═9a889426-1a9a-11eb-2693-01009a8e8019
# ╟─711d491a-1c34-11eb-3002-557c1c0ca185
# ╠═db26d1e0-1c33-11eb-1660-0730eae97779
# ╟─4cf2848e-1c4a-11eb-3ac0-4b18f68495e0
# ╟─7e69cd06-1c4a-11eb-03cc-3778422b2cbe
# ╟─bdc6a9cc-1c4c-11eb-10ad-093882351765
# ╟─d29f0e04-1c4f-11eb-2f0e-59db5e9ca302
# ╟─0a300d1a-1c4d-11eb-2668-21c23079acac
# ╟─3a5df8f0-1c4d-11eb-0cd8-4bf56251ae86
# ╠═1ae4e5bc-1c4d-11eb-1d0a-73b3a05dd7be
# ╟─fc96b292-1c4d-11eb-0e6c-99cae39589d1
# ╟─80e8800a-1c3a-11eb-3014-8ba67436f1e3
# ╟─1a64a1be-1c3d-11eb-0385-cb21ecce4e18
# ╠═4b9fff1a-1c3d-11eb-11ac-c9de8a9b2aec
# ╠═63f84e28-1c3d-11eb-2366-57c6f696e6cd
# ╟─83ce9bee-1c3d-11eb-04dc-03733c1fc440
# ╟─f21396b2-1c3e-11eb-050e-5b313974aee2
# ╠═7dab61d4-1c3d-11eb-0376-39b29753fa7b
# ╟─5fc11a7a-1c3f-11eb-086d-ad6eeffe5e14
# ╟─5657bca0-1c3f-11eb-048f-87259f336df6
# ╟─1d1f56d8-1c40-11eb-1b40-e3c5cb7c447d
# ╟─7fa4042a-1c40-11eb-2536-3da95ea9f7f2
# ╟─ac042c28-1c40-11eb-367b-f1e2d6b08002
# ╟─497828a8-1c41-11eb-3eae-af37ff72c89f
# ╠═687c4126-1c41-11eb-0245-abf9f9d5e831
# ╠═d2c88b38-1c3d-11eb-06d4-710e41cf18f0
# ╟─418f6460-1c43-11eb-2a2b-53b3d387037b
# ╟─42cbf2e4-1c45-11eb-3f2d-c7a541614366
# ╠═b9928bd6-1c75-11eb-1d42-b7febc8cf7de
# ╟─4fcfb162-1c76-11eb-13ff-ff883bb4632d
# ╠═66f039e0-1c76-11eb-13c4-2122afa6d83b
# ╟─6aa6beec-1c76-11eb-1b66-a79a1b28bb9e
# ╟─0cad510a-1c78-11eb-2dbe-c1639a9aba5b
# ╠═1c5410ba-1c78-11eb-09c4-ab8612434bae
# ╟─6ba53664-1c78-11eb-3bf3-1935bbd7ed4e
# ╠═5cd672ec-1c78-11eb-0bbf-3d498440bd8a
# ╟─d27894e6-1c76-11eb-2dad-37b922437534
# ╟─59343792-1c77-11eb-2697-afd8f709d51f
# ╠═9ace9972-1c77-11eb-3cfd-a94b40e72df8
# ╟─da109f0a-1c76-11eb-2c62-f324421e75ea
# ╟─80d7e2fe-186b-11eb-38a0-d75d659dac55
# ╟─047a804a-19ce-11eb-3fe2-4fe940e78734
# ╟─cf23e02c-1c74-11eb-19be-05fb6b459f97
# ╟─72b3c9fe-186b-11eb-111f-33cd57974134
# ╟─78747fdc-186b-11eb-10bb-e1b812e460ce
# ╠═138a0a50-f431-11ea-053a-8f430d193cb1
# ╟─8ad171d0-186b-11eb-2d03-3b2d1fbeebd6
# ╠═1899c410-fc13-11ea-3779-99e4db3939a1
# ╠═201b0000-fc13-11ea-325e-0fa70d049ec7
# ╠═ad9baec0-1aa9-11eb-2d1b-43813bf8e359
# ╠═b41df384-1aa9-11eb-3b48-2933f6c96557
# ╠═c52cfd00-1aa9-11eb-3c40-2bc69bce2c71
# ╟─3de5f658-1b71-11eb-3d67-03eede50d771
# ╠═41e810e0-1b71-11eb-0c0f-0f6780b6e01c
# ╟─efb75388-1c28-11eb-35a8-6346c1976117
# ╠═cd62d804-1c26-11eb-3113-317a750330d4

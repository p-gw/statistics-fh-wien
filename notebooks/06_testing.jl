### A Pluto.jl notebook ###
# v0.12.10

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

# ╔═╡ f5e5879e-2b04-11eb-1eae-df089d8cb101
begin
	using Pkg
	Pkg.add("HypothesisTests")
	Pkg.add("Distributions")
	Pkg.add("Plots")
	Pkg.add("PlutoUI")
	Pkg.add("HTTP")
	Pkg.add("CSV")
	Pkg.add("GLM")
	Pkg.add("DataFrames")
	using HypothesisTests, Distributions, Plots, PlutoUI, HTTP, CSV, GLM, DataFrames, Random
end

# ╔═╡ d05918a0-f437-11ea-3af4-9f911fe287a4
md"# Null hypothesis significance testing"

# ╔═╡ 9c798ca4-3159-11eb-3b8e-5d88359d4cff
md"""
In the previous lectures we have seen that we can describe data, and how to infer or estimate quantities of the population of interest, e.g. by employing methods such as linear regression. Sometimes, however, merely estimating parameters is not enough and decisions have to be made from uncertain data. In frequentist statistics, *null hypothesis significance testing* is the method of choice for making such decisions.

In this lecture we are going to cover the basic principles of null hypothesis significance testing procedures and also how to carry out special hypothesis tests. The special tests we are going to see are testing the **probability parameter in a binomial model**, **population means** and **idependence of two discrete variables**. Furthermore, we will see how null hypothesis significance tests relate to methods we have already seen, namely confidence intervals and linear regression. 
"""

# ╔═╡ cfc79c06-2b08-11eb-15b8-a1caaf982997
md"## Making decisions from data"

# ╔═╡ d69cc1dc-2b08-11eb-3d27-b3073ad6c790
md"""
 In null hypothesis significance testing the researcher seeks to translate the research question (hypothesis) into a set of **statistical hypothesis** that can be tested with certain statistical procedures. Specifically, two hypotheses are generated that cover the set of all possible outcomes. Typically the **null hypothesis** ($H_0$) states that there is *no difference* (e.g. between groups) and the **alternative hypothesis** ($H_1$, which is the hypothesis of interest) states that there *is a difference*. Some examples of hypothesis sets are, 

###### Heights
We could be interested in the difference between heights of males and females in the general population. The research question is then: *Is there a difference between the average heights of males and females in the population?*. The associated set of statistical hypothesis is, 

 $H_0:$ *There is no difference between the heights of males and females in the population.*

 $H_1:$ *There is a difference between the heights of males and females in the population.*

Or, expressed in mathematical terms, we can state our statistical hypotheses as $H_0 : \mu_1 - \mu_2 = 0$ and $H_1 : \mu_1 - \mu_2 \neq 0$ where $\mu_1$ and $\mu_2$ are the expected heights in the population of males and females respectively.

###### Eurovision
The Eurovision Song Contest example from the previous lecture can also be stated in a hypothesis testing framework. The research question would then be: *Is there an association between the Rainbow Index and the score given to Conchita Wurst in the Eurovision Song Contest 2014?*. The statistical hypothesis set for this research question is,

 $H_0:$ *There is no association between the Rainbow index and the score given to Conchita Wurst*
 
 $H_1:$ *There is an association between the Rainbow index and the score given to Conchita Wurst*

This can be equivalently written as $H_0 : r = 0$ and $H_1 : r \neq 0$.  
"""

# ╔═╡ 7504f65a-2b22-11eb-33ae-afbf406b6240
md"""
After the pair of statistical hypotheses is defined the choice of an appropriate statistical test has to be made. This null hypothesis test then determines *how likely the data at hand is under the null hypothesis*. Depending on the outcome of the test one then decides to *accept or reject the null hypothesis* and declares the alternative hypothesis valid if the null hypothesis is rejected.        

"""

# ╔═╡ 25a3c51e-2b18-11eb-0490-5315e67a69bf
md"""
### Types of decisions and errors
When making decisions of this sort from uncertain data, one must accept that besides correct decisions *errors can be made*. In fact, there are only four possible outcomes from a hypothesis testing procedure:

1. There is no effect/difference/association in the population and the test decision is in favour of the null hypothesis,
2. There is an effect/difference/association in the population and the test decision is in favour of the alternative hypothesis, 
3. There is no effect/difference/association in the population and the test decision is in favour of the alternative hypothesis,
4. There is an effect/difference/association in the population and the test decision is in favour of the null hypothesis.

In tabular form decisions from null hypothesis significance testing can also be displayed like this, 

"""

# ╔═╡ eb21076c-30df-11eb-191e-cd8eff971e84
html"""
<table>
	<tr>
		<th></th>
		<th></th>
		<th colspan="2" style="text-align:center;">population</th>
	</tr>
	<tr>
		<th></th>
		<th></th>
		<th>H0</th>
		<th>H1</th>
	</tr>
	<tr>
		<th rowspan="2">test decision</th>
		<th>H0</th>
		<td>correct decision</br>specificity</br>probability = 1 - α</td>
		<td>false negative</br>type II error</br>probability = β</td>
	</tr>
	<tr>
		<th>H1</th>
		<td>false positive</br>type I error</br>probability = α</td>
		<td>correct decision</br>power</br>probability = 1 - β</td>
	</tr>	
</table>
"""

# ╔═╡ 4131b1b0-2b13-11eb-22c9-6b8e1c1ae2c5
md"""
Clearly, there are two types of erros that can be made. A **type I error** or **false positive decision** occurs if we incorrectly reject the null hypothesis if the null hypothesis is valid in the population. A **type II error** or **false negative decision** occurs if the null hypothesis is retained even if the alternative hypothesis is true in the population. 

Our responsibility as the researchers is to balance both types of errors. In null hypothesis significance testing the probability of a type I error is set a priori by the **significance level**, $\alpha$. *By convention* this level is usually chosen to be 5% ($\alpha$ = 0.05) in the social sciences. The probability of a type II error is determined by various factors, including *sample size* and the *significance level*. Also by convention, the goal for $\beta$ is usually 20%, $\beta$ = 0.20. In practice this convention can be exploited to calculate the necessary sample size in the research design phase.   

> ⚠️ The choice of α = 0.05 for the significance level and β = 0.20 is historical and more or less arbitrary! 
"""

# ╔═╡ f0a129d6-2b23-11eb-2ea3-e9c60adbc42e
md"""
The probabilities for test decisions in a null hypothesis significance testing procedure are defined as conditional probabilities. The significance level $\alpha$ is the probability that we reject the null hypothesis *given* the null hypothesis is true in the population, 

$P(\text{reject\ } H_0 ~|~ H_0 \text{\ is\ valid}) = \alpha.$
"""

# ╔═╡ 325f8ea0-2b1b-11eb-0d02-c34faa06db0c
md"""
In turn the probability for the right decision given the null hypothesis in the population, also sometimes called **specificity**, is

$P(\text{accept\ } H_0 ~|~ H_0 \text{\ is\ valid}) = 1 - \alpha.$

On the other hand, if the alternative hypothesis is true in the population then the probability of accepting the null hypothesis (probability of making a type II error) is, 

$P(\text{accept\ } H_0 ~|~ H_1 \text{\ is\ valid}) = \beta.$

The probability of making the correct decision if the alternative hypothesis is true in the population gives us the **power** of the test, 

$P(\text{reject\ } H_0 ~|~ H_1 \text{\ is\ valid}) = 1 - \beta.$

"""

# ╔═╡ 981c7552-2b1b-11eb-0931-3f56703d5b8c
md"""
### Test statistics and p-values
So far we have seen the conceptual nature of null hypothesis significance tests. Typically the goal is to reject the uninteresting null hypothesis, because the hypothesis of interest is in most cases the alternative hypothesis. *But how can we calculate when we need to reject the null hypothesis?* 

Each null hypothesis significance test, as we will see later in this lecture, *implies a specific statistical model*. This means that for a given problem (e.g. testing the difference in population means) we can derive a so called **test statistic**, $T$. A test statistic is a numerical summary of the data that describes the departure from the null hypothesis. A very important property of a test statistic is, that it's probability distribution is known under the null hypothesis. It is this property that makes it possible to calculate probabilities for observed test statistics based on data. 

> 📝 Test statistics allow us to determine how likely it is to observe the data at hand assuming the null hypothesis is true.

The probabilities for decisions in null hypothesis signficance testing map directly to probabilities of this probability distribution[^1]. The significance level, $\alpha$, is defined as the **tail area probability** (c.f. probability lecture) of this distribution, 

$P(T \leq a \cup T \geq b ~|~ H_0) = \alpha.$

For symmetric and centered (μ = 0) distributions, which often arise for test statistics, this probability can be simplified as follows,

$P(T \leq -a ~|~H_0) + P(T \geq a ~|~ H_0) = 2\cdot P(T \geq |~a~| ~|~ H_0) = \alpha.$
"""

# ╔═╡ 6ca82a62-2b16-11eb-1f49-d99f07535642
md"""α = $(@bind alpha_α Slider(0.01:.01:.99, default = 0.05, show_value = true))"""

# ╔═╡ 7d78bcd0-2b28-11eb-04fc-7b0b0a1bc182
md"""
From the graph it can be observed that if we increase the significance level, the tail area probability increases as well. This tail area of the distribution is also called **critical region** and the associated quantile $a$ is called the **critical value**. If the observed test statistic, $t$,  is more extreme than the critical value, then the null hypothesis is rejected - the test is deemed *significant*. 

$|~t~| > a \implies \text{reject\ } H_0, \qquad |~t~| \leq a \implies \text{accept\ } H_0$

"""

# ╔═╡ 7c029ce4-2b29-11eb-2bbe-9f7c52940174
md"""t = $(@bind alpha_t Slider(-3:.01:3, default = 0, show_value = true))"""

# ╔═╡ 0db2d0cc-2b30-11eb-3c12-e50ca38e8375
md"""
Equivalently we can calculate the *probability that the test statistic more extreme than the observed test statistc given the null hypothesis*, or 


$2 \cdot P(T \geq |~t~| ~|~ H_0) = p.$

This probability $p$ is also known as the **p-value**. If the p-value is less than the significance level $\alpha$ then the null hypothesis is also rejected and the procedure declared significant, 

$p < \alpha \implies \text{reject\ } H_0, \qquad p \geq a \implies \text{accept\ } H_0.$
"""

# ╔═╡ 0b86fac0-2b31-11eb-2ed0-4f734ef24b31
md"""p = $(@bind alpha_p Slider(0.001:.001:.999, default = 0.1, show_value = true))"""

# ╔═╡ af0b87d4-2b32-11eb-0271-576b784a0d1b
md"""
P-values have the advantage that for every null hypothesis test they can always be compared directly to the significance level $\alpha$. Because critical values may vary between different null hypothesis tests, they are not as commonly used to determine statistical significance in practice.   
"""

# ╔═╡ 94bcf7f6-30e6-11eb-0012-4d43f03109b8
md"> ⚠️ The p-value does not give us the probability that the null hypothesis is true or that the alternative hypothesis is false! This is a common misinterpretation of p-values in practice."

# ╔═╡ 426515e8-2b33-11eb-1c14-9d11e6612eb5
md"""
### A typical workflow
In null hypothesis significance testing there are a few things to consider before we can calculate test statistics and p-values. A typical null hypothesis significance testing workflow may look something like this, 

1. Develop the research hypothesis,
2. Map the research hypothesis to a pair of statistical hypotheses (null and alternative hypothesis),
3. Decide which test is appropriate for the application,
4. Derive the distribution of the test statistic under the null hypothesis. In most cases this result will be well known (see later sections), 
5. Select the significance level $\alpha$,
6. (optional) decide on a value for $\beta$ and calculate the required sample size,
7. Collect the data,
8. Compute observed test statistic for your data,
9. Make the decision to accept or reject the null hypothesis. This can be either done by calculating the critical value for the test statistic and comparing the observed test statistic to the critical value *or* calculating the p-value of the observed test statistic and comparing the p-value to the significance level $\alpha$.
"""

# ╔═╡ 35380e5c-2b33-11eb-3edb-0b873825dcb9
md"""
### Interpretation
###### Significance tests as trials
One might think of a null hypothesis tests like trials in court. There are two possible verdicts in a trial, not guilty ($H_0$) or guilty ($H_1$). One seeks to gather evidence (the observed data). If the evidence is sufficient (the test statistic is more extreme than the critical value *or* the p-value is smaller than α), the defendant is proven guilty beyond reasonably doubt (rejecting $H_0$). If there is not enough evidence to support a guilty verdict (the test statistic is less extreme than the critical value *or* the p-value is larger than α), the defendant is aquitted (accept $H_0$). One can than either accept the result of the trial or gather more evidence against the defendant (gather more data). Note that accepting the null hypothesis does not mean it's true, jsut that there is not enough evidence to prove the alternative.

###### Frequentist nature of significance tests
Null hypothesis significance tests are an inherently frequentist technique. As such,  the frequentist definition of probability applies to the probabilities for erroneous decisions and p-values. Just like for confidence intervals this means that probabilities have to be interpreted as long-run averages for repeated trials and thus suffer from the same unintuitive interpretation.   
"""

# ╔═╡ 71b6cd26-2b35-11eb-3c78-25f2fd96fa1b
md"""α = $(@bind freq_α Slider(.01:.01:.99, default = 0.1, show_value = true))"""

# ╔═╡ 9a18642a-2b35-11eb-1015-2fbca1300415
md"""n = $(@bind freq_n Slider(5:100, default = 20, show_value = true))"""

# ╔═╡ e12838de-2b35-11eb-046d-3f534d9eacaf
md"""μ = $(@bind freq_μ Slider(-0.5:.01:0.5, default = 0, show_value = true))"""

# ╔═╡ 5ac4dcf2-2b35-11eb-1958-d93504485182
begin
	freq_μ
	freq_n
	freq_α
	freq_t   = [] 
	freq_sig = []
	popDist = Normal(freq_μ, 1.5)
	testDist = TDist(freq_n - 1)
	@bind freq_clock Clock()	
end

# ╔═╡ 1fc3c89c-2b63-11eb-271c-ad955322ff2e
md"""
From this animation it can be noted that, 

1. If the null hypothesis is true in the population ($\mu = 0$) we will observe approximately α false positive decisions and 1 - α correct decisions,
2. if the null hypothesis is false in the population ($μ \neq 0$) ratio between false negative decision (β) and correct decisions will depend on, 
    - The sample size in each trial: the larger the sample size, the more correct decisions
    - The true value in the population: the further the distance from the null hypothesis, the more correct decisions
    - The significance level: the more lenient (smaller) the critical value, the more correct decisions,
    - (not displayed): the variance of the population distribution: the smaller the variance, the more correct decisions
"""

# ╔═╡ 1997c6de-2b1e-11eb-316a-d7155126c2e8
md"""
### Relationship with other procedures
Null hypothesis significance tests are closely related to other statistical procedures we have discussed in this course already. Most notably there is a strong connection between statistical testing and confidence intervals as well as regression models. 

###### Confidence intervals
Recall from the previous lecture the definition of the $(1 - α)$ confidence interval $(a, b)$, 

$P(a \leq X \leq b) = 1 - \alpha$

where $\alpha$ is the significance level chosen by the researcher. Null significance tests and confidence intervals are related in the following way: If a hypothesis test rejects the null hypothesis at significance level $\alpha$, then the $(1 - \alpha)$ confidence interval will not contain the value of the null hypothesis. 

Imagine we want to test whether or not a population mean differs from 0. We can test this using a one sample t-test (see below) and state the following hypotheses, 

 $H_0 :$ *The population mean is zero*, $\mu = 0$,

 $H_1 :$ *The population mean differs from zero*, $\mu \neq 0$.

Assuming a significance level $\alpha = 0.05$ and that the test is significant, i.e. we observe $p < \alpha$, then the confidence interval will *not* include the value 0. We might, for example, observe the interval $(0.2, 5.4)$.

On the other hand, if we observe $p \geq \alpha$ we accept the null hypothesis. For this non-significant test result, the confidence interval will contain 0, e.g. $(-2.3, 1.7)$. 

In short hand notation we can write, 
"""

# ╔═╡ 78e395ac-2d92-11eb-1b65-fd6182de4e24
md"""H0: μ = $(@bind confint_h0 Slider(-1:.01:1, default = 0, show_value = true))"""

# ╔═╡ b0de1cd4-2d92-11eb-0212-9ff6f68b7864
@bind confint_new_sample Button("New sample")

# ╔═╡ a9b30858-2d94-11eb-36c5-f9d61508f7ff
md"""
As can be seen from these examples, in theory it does not matter whether we employ null hypothesis significance tests or the appropriate confidence intervals. In practice, however, explicit significance tests are often required as a statistical analysis even though confidence intervals contain more information: From the interval estimate we can see the uncertainty of estimation. This is not always the case for hypothesis tests and depends on how the test results are presented.  
"""

# ╔═╡ 02b4d404-2d92-11eb-2c13-618e20eb6938
md"""
###### Linear regression
The previous section outlined the equivalence between null hypothesis significance tests and confidence intervals. In the last lecture we have seen that we can construct confidence intervals for parameters in a simple linear regression model. Therefore, certain (linear) regression models are also equivalent to null hypothesis significance tests. Where appropriate, we will see both the hypothesis test as well as the equivalent linear model in the upcoming sections.

For linear regression models we can not only calculate confidence intervals, but also employ formal null hypothesis significance tests. These tests will also be covered explicitly in the next part. For now, we just state that some linear models are equivalent to some statistical tests, or
"""

# ╔═╡ 6c679802-2b65-11eb-1285-d5b323d781de
md"""
### Special null hypothesis significance tests
In this last section of the lecture we are going to cover some common null hypothesis significance tests and how they can be applied to answer specific research questions.

#### Binomial probability
In a binomial model (see probability & inference lecture) we are typically interested in the probability parameter, $p$. Here we can employ null hypothesis significance tests to test if probability parameter in the population $p$ is different from a hypothesized value, $p_0$. The corresponding hypothesis set is,  

 $H_0 : p = p_0, \qquad$ (*The probability in the population is equal to the hypothesized value*)

 $H_1 : p \neq p_0, \qquad$ (*The probability in the population is different from the hypothesized value*)

Assuming the null hypothesis $p = p_0$ is correct, the test statistic $T$ can be derived as, 

$T = \frac{\hat{p} - p_0}{\sqrt{\frac{p_0 (1 - p_0)}{n}}} \sim N(0, 1)$

This test statistic will approximately follow a standard normal distribution. 

To calculate the critical value we can therefore make use of the quantile function for the standard normal distribution, $z_{1 - \frac{\alpha}{2}}$. As described in the introductory section we reject the null hypothesis if the observed test statistic is more extreme than the critical value, 

$|~t~| > z_{1 - \frac{\alpha}{2}} \implies \text{reject\ } H_0$

and retain the null hypothesis otherwise. Alterntively we can calculate the p-value, 

$p = 2(1 - \Phi(|~t~|)),$

where $\Phi(.)$ is the cumulative distribution function of the standard normal distribution and reject the null hypothesis if $p < \alpha$.  

"""

# ╔═╡ 3dc1cde2-2e3f-11eb-24b5-8146afe2bf30
alpha_binomial = 0.01

# ╔═╡ 3dc24646-2e3f-11eb-006b-63089ece5c7d
md"""
We can then procede by calculating the test statistic. First, calculate the best estimate $\hat{p}$,
"""

# ╔═╡ 993d49d6-2e3e-11eb-2e23-699c581247bc
md"and proceed by calculating the test statistic substituting $\hat{p}$, $p_0$ and $n$."

# ╔═╡ dc09e738-2e3e-11eb-0c51-f3525c68dd69
p0 = 0.5

# ╔═╡ 3b69f6a4-2e59-11eb-1bdd-53daf0b42a36
md"The critical value to check against is the quantile function of the standard normal distribution for $(1 - \frac{\alpha}{2})$ or simply $z_{1 - \frac{\alpha}{2}}$,"

# ╔═╡ 24a8fdbc-2e3f-11eb-3fc8-7b79893f5f0d
crit_binomial = quantile(Normal(), 1 - alpha_binomial/2)

# ╔═╡ 82abecd0-2e3f-11eb-3bbc-919bc6cb09c2
md"""Since the resulting test statistic is more extreme than the critical value,"""

# ╔═╡ b8b47086-2e3f-11eb-3425-794064887aae
md"""we can reject the null hypothesis at the chosen significance level and conclude that the birth ratio in the population is different from $p_0 = 0.5$.

Equivalently, we could base our decision on the p-value which gives us the same result:
""" 

# ╔═╡ bef54094-2e35-11eb-16f0-91db2b5d868e
md"""
#### Tests for linear regression
Null hypothesis significance tests can also be constructed for parameters in a linear regression model. Here we can ask the question if a parameter in the model, $\beta$ is different from a hypothesized parameter value, $\beta_0$.

 $H_0 : \beta = \beta_0$ 

 $H_1 : \beta \neq \beta_0$

Most commonly the value under the null hypothesis is zero, so $\beta_0 = 0$, although arbitrary values are possible. The test statistic is then given by, 

 $T = \frac{\hat{\beta} - \beta_0}{se_\hat{\beta}} \sim T(n - k).$

where $\hat{\beta}$ is the best estimate of the parameter and $se_\hat{\beta}$ is the standard error of the estimate. For simple linear regression models these quantities are $\hat{a}$ and $se_\hat{a}$ for the intercept, and $\hat{b}$ and $se_\hat{b}$ for the slope parameter. The test statistic $T$ will follow a t distribution with $(n -k)$ degrees of freedom, where $n$ is the sample size and $k$ are the number of parameters in the model (for simple linear regression $k = 2$).  

Decisions are then made by comparing the observed test statistic $t$ to the critical value (quantile) of the appropriate t distribution, 

$|~t~| > Q(n - k, 1 - \frac{\alpha}{2}) \implies \text{reject\ } H_0$

or by calculating the p-value using the cumulative distribution function of the t distribution with $(n - k)$ degrees of freedom $F(x)$,

$p = 2(1 - F(|~t~|))$

and comparing it to the significance level $\alpha$, 

$p < \alpha \implies \text{reject\ } H_0$ 

> ⚠️ The interpretation of the hypothesis and test result will vary depending on the regression model! 

###### Application: Eurovision Song Contest revisited
In the applied example for the Eurovision Song Contest 2014 we analyzed if the sentiment towards LGBTI people influenced the score given to Conchita Wurst. We concluded that it was plausible that there is a positive relationship between the two variables, i.e. that countries with higher levels of equality gave more points to Conchita Wurst. Null hypothesis significance tests give us the formal framework to ask whether or not there exists a positive relationship in the population. Specifically we are interested in the slope parameter: If it is 0, there is no relationship between the variables. The corresponding hypothesis set is,

 $H_0 : b = 0$
 
 $H_1 : b \neq 0$

As the significance level we can choose the conventional $\alpha = 0.05$,
"""

# ╔═╡ 78846be0-2e5d-11eb-30f6-cd110d264ac6
alpha_eurovision = 0.05

# ╔═╡ 8c4e4002-2e5e-11eb-1d44-dd080fdfc504
b_h0 = 0.0

# ╔═╡ 068fbce2-2e5f-11eb-1048-110600ddbf19
md"The standard errors for the parameters of the regression model are (see regression lecture on how to calculate them),"

# ╔═╡ 1e8434ec-2e5f-11eb-133f-b1f493c26299
md"which gives us an observed test statistic by applying the formula from above."

# ╔═╡ 3afb98e8-2e5f-11eb-3673-85dd9880c9fc
md"To make our decision, we must then compare it to the critical value of the t distribution. To do this, first calculate the degrees of freedom by substracting the number of parameters from the number of observations,"

# ╔═╡ e489142c-2e5e-11eb-2dec-8d2d08876806
k = 2

# ╔═╡ 71c2ac04-2e5f-11eb-38ea-31c52dd9a9eb
md"Then, calculate the quantile of this t distribution for the specified level of α."

# ╔═╡ 8c21a79e-2e5f-11eb-2a7c-f30bf6fededc
md"Comparing the test statistic to the critical value tells us that the null hypothesis is indeed rejected and there is a relationship between the Rainbow Index and the score given to Conchita Wurst in the population."

# ╔═╡ fb517bf4-2e5e-11eb-0c29-03b8d5e41d2c
md"Just as before, software will typically give us the p-value which we can compare to the significance level directly,"

# ╔═╡ 42c37258-2e64-11eb-0881-cbbb274a7c1f
md"Alternatively we can derive the statistical significance by checking if the confidence interval for the parameter includes the null hypothesis value."

# ╔═╡ 35864ca4-2e65-11eb-2b64-bd4ca92bef49
md"Since the value is not within the bounds of the confidence interval, we can also reject the null hypothesis."

# ╔═╡ 6bf50de8-2e65-11eb-37b2-3dc8506c5a2c
md"""
For the intercept the same hypothesis test can be constructed (and it is often contained in the default output in software). Most of the time, however, this null hypothesis significance test does not map to an interesting research question. The hypothesis set, 

 $H_0 : a = 0$

 $H_1 : a \neq 0$

tell us that it is tested whether or not the intercept (mean value when $x = 0$) is 0 in the population. In this example we test if a country with maximal inequality will give a score unequal to zero. Mathematically we can procede in the same fashion as for the slope parameter,
"""

# ╔═╡ 10fe55be-2e67-11eb-285e-5173231ba89c
a_h0 = 0.0

# ╔═╡ 416a1790-2e67-11eb-010d-f7a8a8f08222
md"We conclude that the null hypothesis for the intercept is also rejected and we accept the alternative hypothesis that a maximally unequal country would not give zero points to Conchita Wurst."

# ╔═╡ c4559eb8-2e35-11eb-3871-e5bf96c3ade6
md"""
#### T-test family
T Tests are a family of null hypothesis significance tests that are concerned with testing *means* or *average values*. According to the specific hypotheses that are tested, different names are given to the test: 

- Testing the difference of a population mean from a hypothesized value (one sample t-test) 
- Testing the difference in means of paired samples (paired sample t-test)
- Testing the difference in means of two independent samples (two sample t-test)

"""

# ╔═╡ 03de7e50-2f06-11eb-32e7-a5597f19097b
md"""
##### One sample t-test
The one sample t-test tests the null hypothesis that the population mean $\mu$ is different from a hypothesized value $\mu_0$, 

 $H_0 : \mu = \mu_0$

 $H_1 : \mu \neq \mu_0$

Under the null hypothesis the test statistic for the one sample t-test can be calculated by,

$T = \frac{\hat{\mu} - \mu_0}{\frac{\hat{\sigma}}{\sqrt{n}}} \sim T(n - 1)$

where $\hat{\mu}$ is the estimate of the population mean (sample mean), $\hat{\sigma}$ is the estimate of the population standard deviation, and $n$ is the sample size. This test statistic follows a T distribution with $n - 1$ degrees of freedom under the null hypothesis. Accordingly we can use the quantile function of the t distribution $Q(.)$ to calculate the critical values for the significance level $\alpha$, and reject the null hypothesis if the observed test statistic $t$ is more extreme than the critical value, 

$|~t~| > Q(n - 1, 1 - \frac{\alpha}{2}) \implies \text{reject\ } H_0.$

Alternatively we calculate the p-value using the cumulative distribution function of the T distribution, $F(x)$, 

$p = 2(1 - F(|~t~|))$

and compare $p$ to the significance level $\alpha$ directly, 

$p < \alpha \implies \text{reject\ } H_0.$ 


###### The equivalent linear model
We can also express the one sample t-test as a linear model. If we include just the intercept in the model,

$y_i = a + u_i,$

then the outcome variable is modelled by the mean only. The hypothesis set then is, 

 $H_0 : a = a_0$

 $H_1 : a \neq a_0$

and the test statistic follows a t distribution with $n - 1$ degrees of freedom. The null hypothesis significance test for the intercept-only model is therefore the same as a one sample t-test! 
"""

# ╔═╡ 52ef79a0-2fc3-11eb-062e-5b54d78663da
md"""
###### Application: Website engagement
Suppose we have a goal of increasing the website engagement. The benchmark we set is that users spend 180 seconds on average on our website. We can use a one sample t-test to test if users spend more or less time on our website than hypothesized. The hypotheses for this question are, 

 $H_0 : \mu = \mu_0$
 
 $H_1 : \mu \neq \mu_0$

with $\mu_0 = 180$.
"""

# ╔═╡ f3b72ed2-2fc3-11eb-26f8-0534f88b5cee
μ0_one_sample = 180

# ╔═╡ c50341b4-2fcd-11eb-07e6-c5760f00ef95
md"The significance level we define as the conventional standard of $\alpha = 0.05$,"

# ╔═╡ bb788a3e-2fcd-11eb-216e-a5128f5a65d1
alpha_one_sample = 0.05

# ╔═╡ 03de8bce-2fcf-11eb-18a3-31c7390562e3
md"The test statistic is calculated by first estimating the mean and standard deviation of the population from the sample,"

# ╔═╡ 1b6b7a04-2fcf-11eb-2422-2f13115cf768
md"and then substituting the results in the formula for the one sample t-test,"

# ╔═╡ 2ab5e97c-2fcf-11eb-17b7-d57781e6358e
md"To get the critical value at the significance level, we use the quantile function of the t distribution with $n - 1$ degrees of freedom,"

# ╔═╡ 47e4278e-2fcf-11eb-1ef1-8fbffa0622cf
md"We can then compare the observed test statistic to the critical value."

# ╔═╡ 5832134e-2fcf-11eb-3860-375404cb2ed6
md"""
For the collected website engagement data, the result of the hypothesis test is not signficant meaning that we cannot reject the null hypothesis. Recall that a non-significant result does not mean the null hypothesis is true, but simply that we have insufficient evidence to reject it. We interpret the test result as inconclusive.

The alternative approach to get a decision is based on the p-value,
"""

# ╔═╡ b09fbc52-2fcf-11eb-1d4a-99367f5fb319
md"which can be directly compared to the significance level,"

# ╔═╡ bd445db4-2fcf-11eb-0b10-49351afa5fd3
md"This of course yields the same result as before."

# ╔═╡ 0d6dc590-2fd1-11eb-28b5-21c8a98beb4d
md"""
From a linear regression point of view the one sample t-test model is a regression model where the outcome is modelled by the intercept only, 

$y_i = a + u_i$

Using a null hypothesis significance test on the intercept parameter exactly replicates the result of the one sample t-test,

 $H_0 : a = \mu_0$

 $H_1 : a \neq \mu_0$

The calculation of the test statistic procedes in the same way as before,
"""

# ╔═╡ 3b5c26bc-2fd2-11eb-0166-bde60dc1cd91
md"As you can see, the results are identical to the test statistic for the one sample t-test and will give the exact same test result."

# ╔═╡ abcf7ec8-2f03-11eb-2436-c1b9cf418d79
md"""
##### Paired sample t-test
A paired sample t-test can be used to test if the population means of two dependent samples are differen from a hypothesized value $\mu_0$. Dependent samples can arise in a variety of ways. Some common examples include, 

- **repeated measurement:** If we study people at two different time points the measurements are considered dependent. For example, if we test the same students in an achievement test before and after some intervention, the test scores at the second measurement occasion do not only depend on the intervention but also on the test score on the first measurement occasion.
- **natural pairs:** If measurements are gathered from different persons, but they form a pair. If we, for example, conduct research on pairs of mothers and daughters, they can be considered dependent.

The hypothesis of the paired sample t-test can be written as, 

 $H_0 : \mu_d = \mu_0$
 
 $H_1 : \mu_d \neq \mu_0$

where $\mu_d$ is the difference between means in the population. The test statistic for this test is calculated by, 

$T = \frac{\hat{\mu}_d - \mu_0}{\frac{\hat{\sigma}_d}{\sqrt{n}}} \sim T(n - 1)$

 $\hat{\sigma}_d$ describes the estimate for the standard deviation of the differences in the population and $n$ is again the sample size (number of pairs). From the formula you can see the similarity in structure to the one sample t-test. The estimate is divided by the standard error of the estimate. The difference between the one sample t-test and the paired sample t-test is just a small one: *The paired sample t-test is one sample t-test for the differences between measurement pairs*. 

This means the approach to rejecting the null hypothesis is the same. For the critical value approach,  


$|~t~| > Q(n - 1, 1 - \frac{\alpha}{2}) \implies \text{reject\ } H_0.$

or based on p-values, 

$p = 2(1 - F(|~t~|))$

$p < \alpha \implies \text{reject\ } H_0.$ 


###### The equivalent linear model
Just like the one sample t-test, the paired sample t-test can be described by an intercept-only linear regression model,

$y_i = a + u_i.$

The only difference here is that the outcome measure is the difference between the pair values, so $y_i = y_{i,1} - y_{i,2}$ where $i$ indicates the measurement pair and 1 or 2 indicates the first or second sampling unit within the pair. To make things clear, the exact linear regression model then becomes, 

$y_{i,1} - y_{i,2} = a + u_i.$
"""

# ╔═╡ f97e6b7a-2fbc-11eb-0592-95a8bd60fc0c
alpha_paired = 0.1

# ╔═╡ acfea2c6-2fbf-11eb-3bec-e9be16a8127d
md"""
The hypotheses we test are, 

 $H_0 : \mu_d = 0$

 $H_1 : \mu_d \neq 0$

so $\mu_0 = 0$. 
"""

# ╔═╡ 7ef9068a-2fbc-11eb-055a-a712387ee69a
μ0_d = 0.0

# ╔═╡ f65af7ce-2fbf-11eb-2cbd-356d4b72342c
md"Calculation of the test statistic can be conducted by first calculating the difference in measurements,"

# ╔═╡ 27acf522-2fc0-11eb-19b3-db2c0d03476a
md"Then calculating the mean ($\hat{\mu}_d$) and standard deviation ($\hat{\sigma}_d$) of that difference," 

# ╔═╡ 4beec56e-2fc0-11eb-2581-f74f7b4a823b
md"and finally substituting the calculated values in the formula above."

# ╔═╡ 5dea47b8-2fc0-11eb-04a4-2fe568e203fc
md"The resulting test statistic can then be compared to the critical value of the t distribution with $n - 1$ degrees of freedom,"

# ╔═╡ 784de40a-2fc0-11eb-35db-674a7039bc6e
md"or by calculating the p-value and comparing it to the significance level directly,"

# ╔═╡ 8855aa48-2fc0-11eb-31f0-eb691e0d571f
md"Both approaches give the same result of a significant difference between the two drugs. The increase in sleep duration using the second drug is higher than the increase in sleep duration using the first drug." 

# ╔═╡ 765dd98c-2fbd-11eb-25bd-df3aa2710ebf
md"""As we have seen in the theoretical section for the paired sample t-test we can also test the same hypothesis by fitting the intercept-only regression model on the observed differences. Formally, this corresponds to the model

$y_{i,1} - y_{i,2} = a + u_i.$

The null hypothesis significance test for $a$ will then give the same result as the paired sample t-test.
"""

# ╔═╡ 5cff4d70-2f1a-11eb-1fc0-63ddf417576f
md"""
##### Two sample t-test
The two sample t-test can be employed to test if the means of two independent populations are unequal. This test is probably the most commonly used t-test in practice, because statistical analysis of common research design is most often based on group comparisons. Some examples include, 

- The group difference between an experimental and a control group in a clinical trial,
- Sex differences in an observational study,
- Differences in an outcome depending on the handedness (left- vs. right-handed) of persons.

The hypotheses being tested in a two sample t-test are, 

 $H_0 : \mu_1 = \mu_2$
 
 $H_1 : \mu_1 \neq \mu_2$

where $\mu_1$ is the population mean of the first group (e.g. experimental group) and $\mu_2$ is the population mean of the second group (e.g. control group). To test if the group difference is statistically significant we calculate the test statistic, 

$T = \frac{\hat{\mu}_1 - \hat{\mu}_2}{\hat{\sigma}_p\sqrt{\frac{1}{n_1} + \frac{1}{n_2}}} \sim T(n_1 + n_2 - 2).$

Here, $n_1$ and $n_2$ refer to the sample sizes in the respective groups and $\hat{\sigma}_p$ is the so called *pooled standard deviation*,

$\hat{\sigma}_p = \sqrt{\frac{(n_1 - 1)\hat{\sigma}^2_1 + (n_2 - 1)\hat{\sigma}^2_2}{n_1 + n_2 - 2}}.$

The pooled standard deviation is the **overall standard deviation** of the two groups.

Since the test statistic $T$ follows a t distribution with $(n_1 + n_2 - 2)$ degrees of freedom, we can again make use of the quantile function and cumulative distribution function for the t distribution to calculate critical values and p-values in order to reach our test decision. For the critical value approach we compare the test statistic to the appropriate quantile of the t distribution,  

$|~t~| > Q(n_1 + n_2 - 2, 1 - \frac{\alpha}{2}) \implies \text{reject\ } H_0.$

For p-values we can use the cumulative distribution function, 

$p = 2(1 - F(|~t~|))$

$p < \alpha \implies \text{reject\ } H_0.$ 


###### The equivalent linear model
Besides the two sample t-test we have already seen a method to estimate the differences between two groups. Indeed the simple linear regression with a binary dummy coded predictor is exactly equivalent to the t-test outlined here. The hypothesis test for the slope $b$,

 $H_0 : b = 0$

 $H_1 : b \neq 0$

in the simple linear regression model, 

$y_i = a + b\cdot x_i + u_i$

with the dummy coded predictor $x_i \in \{0, 1\}$ is the same test for the group difference as in the two sample t-test. Recall that the parameter $b$ in this model is interpreted not as a slope in the classical sense, but as the difference between the groups where $x = 0$ and $x = 1$ (for details see the lecture on linear regression). 
"""

# ╔═╡ 10997d48-2f33-11eb-22a0-7144c5face29
md"""
###### Application: SAT scores revisited
In the regression lecture we analyzed gender differences in the quantitative portion of the SAT which is used for college admission in the USA. We concluded that it was plausible that females had lower SAT scores in the population. Now, knowing about the two sample t-test we can formally test this hypothesis,

 $H_0 : \mu_1 = \mu_2$
 
 $H_1 : \mu_1 \neq \mu_2$

For this example we denote $\mu_1$ as the mean of female students and $\mu_2$ as the mean for male students. Next, we set the usual significance level to $\alpha = 0.05$"""

# ╔═╡ 0e6e60a4-2f37-11eb-2d1f-b3e83d5477c2
alpha_two_sample = 0.05

# ╔═╡ 0e702f06-2f37-11eb-07ec-058b4187ab96
md"""
To calculate the test statistic we must first calculate the two means, 
"""

# ╔═╡ abda0950-2f36-11eb-3712-fd93df0fd177
md"Then, the pooled standard deviation is calculated by,"

# ╔═╡ 153b0d0e-2f37-11eb-077b-ed535d424c74
md"And finally we can derive the test statistc by subsituting the values in the formula above,"

# ╔═╡ bcf352b8-2f37-11eb-3574-b3a6eb8eead6
md"""As mentioned before, we can alternatively fit the regression model of the previos lecture to the data and test the hypothesis that the slope is different from 0.

 $H_0 : b = 0$

 $H_1 : b \neq 0$

Full calculation will be omitted here (you can do this as an exercise), but the resulting test statistic is exactly the same,
"""

# ╔═╡ b9613094-2f3b-11eb-2742-45f4940ce540
md"and therefore gives the same test result of rejecting the null hypothesis. Based on the p-value, for example,"

# ╔═╡ 8d04e6be-2f20-11eb-0662-7d7aab01eeb9
md"""
##### Assumptions
We have already seen that t-tests can be equivalently expressed as regression models. Because they are the same method in disguise, they also share the same assumptions. 

###### Representativeness & validity 
It is assumed that the test can answer the research question (*validity*) and that the sample is representative of the population of interest (*representativeness*). See lecture on linear regression for a detailed explanation. 

###### Interval scale
In order to calculate a t-test we must assume that the outcome is *continuous* or on an *interval scale*. 

###### Independence
For t-tests we assume that the observations are *independent*, i.e. that one observation does not depend on another observation. This assumption would be obviously violated for the paired t-test. Here, we instead treat the *pairs* as observations and state that pairs of measurements (e.g. repeated measurements of the same person) must be independent from one another. 

> 📝 This assumption corresponds to the independence of errors in linear regression.

###### Normal distribution
For t-tests it is usually stated that the population follows a normal distribution. This is the case for the one sample t-test as well as the paired sample t-test. For the two sample t-test we do not assume that the population itself follows a normal distribution, but that each group is normally distributed. 

> 📝 This assumption about the normal distribution (within groups) maps directly to the assumption about the normal distribution of the errors in linear regression.

###### Homogenity of variances 
In the two sample t-test it is additionally assumed that the variance in both subpopulations (groups) is equal.

> 📝 This assumption is equivalent to the homoscedasticity of errors in linear regression. 


###### What to do if assumptions are not met?
In practice it can happen that the assumptions outlined above do not hold. Fortunately there exist a variety of alternative procedures that can be used if assumptions are violated. Just like in regression analysis, the assumption about equality of variances is not neccesarily the most important and unequal variances can be modelled explicily. The two sample t-test for unequal variances is referred to as **Welch's t-test**.

More serious violations of assumptions (e.g. non-continuous data) there exists a class of statistical methods called **non-parametric tests** that do not require as many assumptions. Typically, these methods use on *order statistics*, which are not based on the raw data values but on the ranks of data values. Therefore, some information is lost when applying non-parametric test (c.f. scale levels). 


#####  

"""

# ╔═╡ 75ab7ff0-2f20-11eb-0e5d-1bf97d3c5bc0
md"""
#### χ² test
Another common class of null hypothesis significance tests are χ² tests (chi-squared tests). Using χ² tests we can test if an observed distribution follows a hypothesized probability distribution,

 $H_0 : F(x) = F_0(x), \qquad$ *(The observed distribution $F$ follows the hypothesized distribution $F_0$)*

 $H_1 : F(x) \neq F_0(x), \qquad$ *(The observed distribution $F$ does not follow the hypothesized distribution $F_0$)*

Because of this very general formulation, χ² tests can be applied in various ways. The most common examples relate to statistical testing for discrete data. In general, we can ask questions about the **goodness of fit**, investigating how good the data at hand fits the model (probability distribution). Special applications for the χ² test are

1. Testing whether two discrete variables are *independent* in the population,
2. Testing for *homogenity* or if the population distributions within groups are identical. 

These two applications imply a χ² test of a contingency table (see descriptive statistics lecture). The test statistic is then given by, 

$X^2 = \sum_{i=1}^k\sum_{j=1}^m \frac{(n_{ij} - e_{ij})^2}{e_{ij}} \sim \chi^2((k - 1)(m - 1))$

where $n_{ij}$ are the observed cell frequencies and $e_{ij}$ are the expected cell frequencies under the null hypothesis. The indices $i$ and $j$ refer to the rows and columns of the contingency table respectively. The test statistic under the null hypothesis follows a χ² distribution with $(k - 1)(m - 1)$ degrees of freedom, $k$ being the number of rows and $m$ the number of columns in the contingency table. 

We reject the null hypothesis when the observed test statistic is larger than the critical value, 

$X^2 > Q(1 - \alpha, (k - 1)(m - 1)) \implies \text{reject\ }H_0.$

Based on p-value, one rejects the null hypothesis if the calculated p-value, 

$p = 1 - F(X²)$

is smaller than the significance level $\alpha$. $F(x)$ denotes the cumulative distribution function of the χ² distribution with $(k - 1)(m - 1)$ degrees of freedom.
"""

# ╔═╡ 3391b126-30a0-11eb-265a-497cb953e026
md"""
###### Application: Test for independence
To test the independence of to discrete variables one must first derive the probability distribution under the null hypothesis. Recall that the probability for two independent variables $A$ and $B$ is, 

$P(A \cap B) = P(A) \cdot P(B)$

If we consider the simple case of a 2x2 contingency table,

| a\b | b1 | b2 | total |
| --- | --- | --- | --- |
| **a1** | $e_{11}$ | $e_{12}$ | $n_{1.}$ |
| **a2** | $e_{21}$ | $e_{22}$ | $n_{2.}$ |
| **total** | $n_{.1}$ | $n_{.2}$ | $n_{..}$ |

the expected cell frequencies $e$ must be derived and the marginal frequencies are treated as known. Assuming independence, the expected cell freqencies then are calculated by,  

$e_{ij} = \frac{n_{i.} \cdot n_{.j}}{n_{..}}$

With the expected cell frequencies given the null hypothesis known the formula from the previous section can be applied. 

Suppose we want to know if the attendance in a university course is associated with person failing or passing the course. We can classify attendance in a binary way by defining high attendance by the person 90% or more of the lessons and low attendance by the person attending less than 90% of lessons. 

In an introductory course at a large unversity (n = 631) we observe the following contingency table, 

| attendance\result | pass | fail | total |
| --- | --- | --- | --- |
| **high** | 322 | 81 | 403 |
| **low** | 164 | 64 | 228 |
| **total** | 486 | 145 | 631 |

From this table we can see that students with high attendance pass with a rate of $(round(322/403, digits = 2)), while students with low attendance pass with a rate of $(round(164/228, digits = 2)).

To test if the attendance is independent from the passing/failing of the course we calculate the χ² test for independence. Assuming independence of the two variables we can calculate the expected contingency table, 

| attendance\result | pass | fail | total |
| --- | --- | --- | --- |
| **high** | 310.4 | 92.6 | 403 |
| **low** | 175.6 | 52.4 | 228 |
| **total** | 486 | 145 | 631 |

To exemplify we can show the calculation of $e_{11} = 310.4$, 

$e_{11} = \frac{n_{1.} \cdot n_{.1}}{n_{..}} = \frac{486 \cdot 403}{631} \approx 310.4$

To calculate the $X^2$ test statistic we apply the formula to the contingency table,
"""

# ╔═╡ 3933bb88-30b4-11eb-145b-8ded6858ec9a
md"This value we can compare to the critical value of the χ² distribution setting a significance level of $\alpha = 0.05$,"

# ╔═╡ 662bd29c-30b4-11eb-2c0b-d713d0270146
alpha_chisq = 0.05

# ╔═╡ 4c047b12-30b4-11eb-0a51-ff5ca87263e5
crit_chisq = quantile(Chisq((2 - 1)*(2 - 1)), 1 - alpha_chisq)

# ╔═╡ d0469f70-30b6-11eb-07e3-c1640f135a5e
md"""Zoom: $(@bind chisq_zoom CheckBox())"""

# ╔═╡ a3a5a1a2-30b4-11eb-3acd-0b98018e3898
md"""Since this value is less extreme than our observed test statistic we can reject the null hypothesis that attendance and passing the exam are independent. Students with higher rates of attendance indeed do have a higher chance of passing the course.

The alternative approach to evaluate the significance of a result is to calculate the p-value,
"""

# ╔═╡ 1498871c-30b5-11eb-1a39-5fe7a273f512
md"This gives the same significant test result, because the p-value is less than the significance level $\alpha$"

# ╔═╡ 0bdb4eda-30b2-11eb-3d92-b191224f3afb
md"""
##### Assumptions
To guarantee that the test statistic $X^2$ approximately follows a χ² distribution some assumptions have to be met. As usual *representativeness* of the sample and *validity* must be considered. Special assumptions for the χ² test are that the cells are *mutually exclusive*, meaning that every sampling unit can only reside in one cell of the contingency table. There are also two assumptions we make about the expected cell frequencies of the table:

1. all expected cell frequencies $e_{ij}$ must be larger than 1,
2. 80% of the expected cell frequencies $e_{ij}$ must be larger than 5.

These two assumptions are essentially guaranteed if the sample size is large enough.
"""

# ╔═╡ 567ccc10-3092-11eb-13c1-0d4e1ad28755
md"""
## Summary
In this lecture we were concerned with making decisions from uncertain data by employing null hypothesis significance tests. Significance tests work by creating a pair of statistical hypotheses, the **null hypothesis** and the **alternative hypothesis** and we seek to **reject the null hypothesis** in favour of the alternative hypothesis, which is in most cases the hypothesis of interest. Making such decisions is prone to errors. We can either make correct decisions, false positive decision (type I error) or false negative decisions (type II error). The framework of null hypothesis significance testing allows us to specify the probability if these two types of errors beforehand. Type I errors are controlled by the **significance level**, $\alpha$ that is conventionally set to 5%. The probability of a type II error can be controlled by the sample size: larger samples lead to a lower probability for false negative decisions. Once the signficance level is set, one can calculate a **test statistic** from the data for the specific application. This observed test statistic is then compared to a **critical value**. If the test statistic is *more extreme* than the critical value we can reject the null hypothesis. More commonly used in practice are *p-values*, which are defined as the probability that we observe a test statistic more extreme than the observed test statistic under the null hypothesis. These p-values can be directly compared to the significance level to reach the test decision.      

It was also noted that null hypothesis significance tests are actually equivalent to other methods we already encountered in this course. $(1 - \alpha)$ confidence intervals will give us the same decision as the corresponding hypothesis test. Also, regression analysis is equivalent to many tests. We have seen examples of this when discussing statistical tests for means. 

From a practical point of view we encountered some common statistical tests for the probability parameter in a binomial model, regression parameters, comparing means and the independence of two discrete variables and seen applied examples of how to reach decisions from real data. 

### Footnotes
[^1]: For simplicity we cover only two-tailed significance tests in this course. Two tailed significance tests as shown in this lesson map directly to non-directional hypothesis such as $H_0 : \mu = 0, H_1 : \mu \neq 0$. Sometimes we are only interested in one-directional hypothesis similar to $H_0 : \mu \leq 0, H_1 : \mu > 0$. These so called **one-tailed** significance tests require somewhat different definitions for tail area probabilities, test decisions, and p-values. Still, the same theoretical concepts apply to one-tailed significance tests.
"""

# ╔═╡ ec0bcb70-2b04-11eb-25b1-272893194a99
md"## Computational resources"

# ╔═╡ f10b8190-2b04-11eb-2ec3-69c141f0c0b4
md"This section can be safely ignored..."

# ╔═╡ c6398592-2b16-11eb-0c60-a7e8a30d97ad
md"### Helper functions"

# ╔═╡ cc0fd370-2b16-11eb-1963-1d0e92c41618
colors = ["#ef476f","#ffd166","#06d6a0","#118ab2","#073b4c"]

# ╔═╡ d5907816-2b16-11eb-0bc1-c5228eff3ecd
center(x) = HTML("<div style='text-align: center;'>$(Markdown.html(x))</div>")

# ╔═╡ 0543a682-2d92-11eb-264d-190ef3fdd1b0
center(md""" significant test result $\iff$ confidence interval excludes null hypothesis value,""")

# ╔═╡ 5cfb8534-2d92-11eb-3f4a-7dd6a31eb787
center(md""" non-significant test result $\iff$ confidence interval includes null hypothesis value.""")

# ╔═╡ 070c90c2-2d98-11eb-07f4-47a084b55dd1
center(md"""some linear models $\iff$ some null hypothesis significance tests.""")

# ╔═╡ ddcfbff0-2b16-11eb-2154-b9233c1ebda4
function two_columns(l, r)
	html_l = Markdown.html(l)
	html_r = Markdown.html(r)
	res = """
	<div style='display: flex'>
		<div style='width: 50%'>$(html_l)</div>
		<div style='width: 50%'>$(html_r)</div>	
	</div>
	"""
	HTML(res)
end

# ╔═╡ e200a224-2b16-11eb-1e0d-d3909f3dc02b
function fillarea!(dist, r, c) 
	sx = vcat(r, reverse(r))
	sy = vcat(pdf.(dist, r), zeros(length(r)))
	plot!(Shape(sx, sy), color = c, fillalpha = 0.25, lw = 0)
end

# ╔═╡ 605e6eea-2b16-11eb-0c56-3106b579c695
# alpha
begin
	alpha_range = collect(-3:.01:3)
	alphaDist = Normal()
	alpha_critical = quantile(alphaDist, 1 - alpha_α/2)
	
	function alpha_plot()
		plot(alpha_range, pdf.(alphaDist, alpha_range), color = colors[3], legend = false, lw = 2, size = [420, 320], xlabel = "T")
	
		# ribbons
		fillarea!(alphaDist, collect(minimum(alpha_range):.01:-alpha_critical), colors[3])
		fillarea!(alphaDist, collect(alpha_critical:.01:maximum(alpha_range)), colors[3])
		end
	alpha_plot()
end

# ╔═╡ 8ef8965a-2b29-11eb-16d7-9bc98accf14c
begin
	alpha_plot()
	significant = abs(alpha_t) >= alpha_critical
	vline!([alpha_t], color = significant ? colors[1] : "grey", lw = 2)
end

# ╔═╡ 89ce5784-2b2a-11eb-1b15-53783a69a3bb
md"""The observed test statistic, t = $(alpha_t) is $(significant ? "more" : "less") extreme than the critical value of α = $(round(alpha_critical, digits = 2)). The null hypothesis is $(significant ? "" : "not") rejected."""

# ╔═╡ de9c0604-2b30-11eb-1742-a31e988eb891
begin
	alpha_plot()
	significant_p = alpha_p < alpha_α
	
	p_quant = quantile(alphaDist, (1 - alpha_p/2))
	
	# ribbons
	fillarea!(alphaDist, collect(minimum(alpha_range):.01:-p_quant), significant_p ? colors[1] : "grey")
	 fillarea!(alphaDist, collect(p_quant:.01:maximum(alpha_range)), significant_p ? colors[1] : "grey")
end

# ╔═╡ acde2752-2b31-11eb-1bc5-33abdcfea2c7
md""" The p-value, p = $(alpha_p) is $(significant_p ? "smaller" : "larger") than the significance level α = $(alpha_α). The null hypothesis is $(significant_p ? "" : "not") rejected."""

# ╔═╡ 641e8988-2b35-11eb-34f3-c5940fc1a389
begin
	dist_range = collect(-3:.01:3)
	
	plot(dist_range, pdf.(popDist, dist_range), lw = 2, legend = false, color = "grey", size = [420, 320])
	fillarea!(popDist, dist_range, "grey") 
end

# ╔═╡ 5b2363d4-2b31-11eb-3af1-3da709743a37
begin
	plusminus(x::Number, y::Number) = (x - y, x + y)
	±(x, y) = plusminus(x, y)
end

# ╔═╡ ce259964-2b64-11eb-0895-cf95c3bd8be5
md"### Introduction"

# ╔═╡ 3f986a40-2b38-11eb-0fa6-d1dc59267fe2
begin
	freq_clock
	freq_samp = rand(popDist, freq_n)
	freq_t_crit = quantile(testDist, 1 - freq_α/2)
	append!(freq_t, [mean(freq_samp) / sqrt(var(freq_samp)/freq_n)])
	append!(freq_sig, [abs(last(freq_t)) > freq_t_crit])
	
	freq_correct = if freq_μ == 0
		mean(.!freq_sig)
	else 
		mean(freq_sig)
	end
end

# ╔═╡ 58847abc-2b3a-11eb-1526-0f0916b315fa
md"""
correct decisions: $(round(freq_correct, digits = 2))

type $(freq_μ == 0 ? "I" : "II") errors: $(round(1 - freq_correct, digits = 2))
	
"""

# ╔═╡ 83d70e98-2b36-11eb-0091-a553c28e12e9
begin
	function testdist_plot()
		plot(dist_range, pdf.(testDist, dist_range), lw = 2, legend = false, color = colors[3], size = [420, 320], ylimit = [0, 0.4])
	

		fillarea!(testDist, minimum(dist_range):.01:-freq_t_crit, colors[3])
		fillarea!(testDist, freq_t_crit:.01:maximum(dist_range), colors[3])
	end
end

# ╔═╡ 2434f052-2b38-11eb-15c0-510df672edb9
begin
	freq_clock
	testdist_plot()
	freq_vline = [sign(last(freq_t)) * minimum([3.0, abs(last(freq_t))])] 
	vline!(freq_vline, lw = 2, color = last(freq_sig) ? colors[1] : "grey")
end

# ╔═╡ 70dab02a-2d92-11eb-1ab7-1b070f98c3d1
begin
	confint_new_sample
	confint_samp = randn(40)
	confint_result = OneSampleTTest(confint_samp, confint_h0)
end

# ╔═╡ 449548d0-2d93-11eb-38ef-2b5b9d6efac6
md"""
confidence interval: $(round.(confint(confint_result), digits = 2))

test result: t = $(round(confint_result.t, digits = 2)), p = $(round(pvalue(confint_result), digits = 2))

The null hypothesis of μ = $(confint_h0) is $(pvalue(confint_result) < .05 ? "" : "not") rejected at the significance level α = 0.05. 
"""

# ╔═╡ 4c44eaec-2e40-11eb-2de3-b3fefc6fe2f4
md"### Birth ratios"

# ╔═╡ 95b1d71a-2e3d-11eb-1b7d-e515f23daf58
begin
    male_births = 43580
    female_births = 41372
    total_births = male_births + female_births
end

# ╔═╡ 63bedadc-2e3d-11eb-1dc3-09c049588d68
md"""
###### Application: Birth ratios revisited
Suppose we are interested in the birth ratio (c.f. probability & inference lecture) in the Austrian population. Recall that in 2019 there were a total of $(total_births) births, $(female_births) of them being female. 

Here we want to test if the birth ratio is equal in the population. We can express this as the hypothesis set, 

 $H_0 : p = 0.5, \qquad$ *(A female birth is equally likely as a male birth)*

 $H_1 : p \neq 0.5, \qquad$ *(A female birth is not equally likely as a male birth)*

substituting the theoretical value $p_0$ by $p_0 = 0.5$ indicating equal probability for male and female births. Since we want to be pretty certain about our test result and do not wish to have a high probability of a false positive result, we set $\alpha = 0.01$. 
"""

# ╔═╡ 8d3936fc-2e3e-11eb-0f3f-53b479c7fe0e
p̂ = female_births / total_births

# ╔═╡ 6e392048-2e3e-11eb-3190-d72e588d480d
t_binomial = (p̂ - p0)/sqrt((p0 * (1 - p0))/(total_births))

# ╔═╡ 6aebd510-2e3f-11eb-0afe-4f6318bb0e1f
abs(t_binomial) > crit_binomial

# ╔═╡ b8b130b8-2e67-11eb-042a-45da03d5128f
begin
	binomial_range = -8:.01:8
	plot(binomial_range, pdf.(Normal(), binomial_range), lw = 2, color = colors[3], legend = false, size = [620, 320])
	
	# ribbons
	fillarea!(Normal(), collect(minimum(binomial_range):.01:-crit_binomial), colors[3])
	 fillarea!(Normal(), collect(crit_binomial:.01:maximum(binomial_range)), colors[3])
	
	# test statistic
	vline!([t_binomial], lw = 2, color = colors[1])
end

# ╔═╡ f346b896-2e3f-11eb-3a82-65fe5dfb7097
p_binomial = 2 * (1 - cdf(Normal(), abs(t_binomial)))

# ╔═╡ 3de768be-2e40-11eb-1aa3-63f6875138b7
p_binomial < alpha_binomial

# ╔═╡ 9872c566-2e5d-11eb-05bd-df6e157ec316
md"### Eurovision example"

# ╔═╡ 9b5c1020-2e5d-11eb-2ed6-b9188a073e7d
begin
    eurovision_url = "https://raw.githubusercontent.com/p-gw/statistics-fh-wien/master/data/eurovision.csv"
    eurovision = CSV.File(HTTP.get(eurovision_url).body; missingstring = "NA") |> DataFrame
    eurovision = eurovision[.!ismissing.(eurovision.rainbow), :]
end

# ╔═╡ d3ca5984-2e5e-11eb-2e59-35f6c1e6593e
df = nrow(eurovision) - k

# ╔═╡ b7f3810e-2e5e-11eb-1b5d-431c602510f6
crit_slope = quantile(TDist(df), 1 - alpha_eurovision/2)

# ╔═╡ 2a1ab4ca-2e67-11eb-2bab-f17a715eac69
crit_intercept = crit_slope

# ╔═╡ 63bdab70-2e68-11eb-1bd3-45397521a379
begin
	slope_range = -8:.01:8
	plot(slope_range, pdf.(TDist(df), slope_range), lw = 2, color = colors[3], legend = false, size = [620, 320])
	
	# ribbons
	fillarea!(TDist(df), collect(minimum(slope_range):.01:-crit_slope), colors[3])
	 fillarea!(TDist(df), collect(crit_slope:.01:maximum(slope_range)), colors[3])
	
	# test statistic
	vline!([t_binomial], lw = 2, color = colors[1])
end

# ╔═╡ a3eec53e-2e5d-11eb-1288-23ba6f0b32bf
begin
    eurovision_fit = lm(@formula(points ~ rainbow), eurovision)
    eurovision_â, eurovision_b̂ = coef(eurovision_fit)
end

# ╔═╡ 7af24138-2e5d-11eb-33ad-ad98abe9bd07
se_â, se_b̂ = stderror(eurovision_fit)

# ╔═╡ 79cfcb12-2e5e-11eb-149a-0d4543a007a8
t_slope = (eurovision_b̂ - b_h0)/se_b̂

# ╔═╡ f3aff268-2e5e-11eb-3fe4-a98a5914d726
abs(t_slope) > crit_slope

# ╔═╡ fd5b81b2-2e5f-11eb-2c1c-8f143bf3e624
p_eurovision = 2 * (1 - cdf(TDist(df), abs(t_slope)))

# ╔═╡ 22484796-2e60-11eb-0218-b5d2288d6f35
p_eurovision < alpha_eurovision

# ╔═╡ a7d8cf1e-2e64-11eb-2963-27cda0cebfab
ci_slope = confint(eurovision_fit)[2,:]

# ╔═╡ cf355bca-2e64-11eb-3f5e-b5478020e8d7
ci_slope[1] <= b_h0 <= ci_slope[2]

# ╔═╡ deae3f2a-2e66-11eb-10ca-7de9102e5b22
t_intercept = (eurovision_â - a_h0)/se_â

# ╔═╡ 38ac3220-2e67-11eb-0294-cfdd1a83ac33
abs(t_intercept) > crit_intercept

# ╔═╡ 769dfcd8-2f33-11eb-21fa-3548b6184b8f
md"### SAT example"

# ╔═╡ 7da06712-2f33-11eb-10a5-39426f4eed73
begin
	sat_url = "https://raw.githubusercontent.com/vincentarelbundock/Rdatasets/master/csv/psych/sat.act.csv"
	sat = CSV.File(HTTP.get(sat_url).body; missingstring = "NA") |> DataFrame
	sat[!, :gender] = sat[!, :gender] .- 1
end

# ╔═╡ 6cf21f7c-2f34-11eb-078a-535da793726c
begin
	sat_fit = lm(@formula(SATQ ~ gender), sat)
	sat_â, sat_b̂ = coef(sat_fit)
	sat_data = sat_fit.mf.data
end

# ╔═╡ 1d13e976-2f38-11eb-1572-ab7d762b9829
sat_t_slope =  coef(sat_fit)[2]/stderror(sat_fit)[2]

# ╔═╡ 54f97e18-2f36-11eb-0834-2f770f041784
sat_scores_male = sat_data.SATQ[sat_data.gender .== 0]

# ╔═╡ 5cec63c4-2f36-11eb-2879-57f73f4f5e7f
sat_scores_female = sat_data.SATQ[sat_data.gender .== 1]

# ╔═╡ 112e7bda-2f35-11eb-0b18-61af0a05f2b8
μ̂_1, μ̂_2 = mean(sat_scores_female), mean(sat_scores_male)

# ╔═╡ 2a880910-2f36-11eb-3dfb-b99ad17a28c4
n_1, n_2 = length(sat_scores_female), length(sat_scores_male)

# ╔═╡ 2504c9b4-2f37-11eb-3984-7ddde827359a
md"To evaluate if the resulting test statistic is significant we can compare it to the critical value of the T distribution with $(n_1 + n_2 -2) degrees of freedom,"

# ╔═╡ 61f4cc32-2f37-11eb-2d8f-67d765c7b7c1
crit_two_sample = quantile(TDist(n_1 + n_2 - 2), 1 - alpha_two_sample/2)

# ╔═╡ cff2ab26-2f3b-11eb-17c2-5198791d3a2f
sat_p_slope = 2 * (1 - cdf(TDist(n_1 + n_2 - 2), abs(sat_t_slope)))

# ╔═╡ f51dc44e-2f3b-11eb-157a-3d43582eb462
sat_p_slope < alpha_two_sample

# ╔═╡ 1523bbd0-2f36-11eb-35c0-9b45de74ffbb
σ̂_p = sqrt(((n_1 - 1) * var(sat_scores_female) + (n_2 - 1) * var(sat_scores_male))/(n_1 + n_2 - 2))

# ╔═╡ c11d3b2a-2f36-11eb-1e2c-c30890a6f9ba
t_two_sample = (μ̂_1 - μ̂_2) / (σ̂_p * sqrt(1/n_1 + 1/n_2))

# ╔═╡ 70cf32ee-2f37-11eb-0b62-7bd4714bbe9e
abs(t_two_sample) > crit_two_sample

# ╔═╡ 7f442b0e-2f37-11eb-3fbc-c17329912ff8
md"Because $(round(abs(t_two_sample), digits = 2)) is greater than $(round(crit_two_sample, digits = 2)) we reject the null hypothesis and accept the alternative hypothesis that the SAT scores between male and female students in the population are different." 

# ╔═╡ 8d5cc154-2fb6-11eb-1327-ab5019588124
begin
	two_sample_range = -5:.01:5
	plot(two_sample_range, pdf.(TDist(n_1 + n_2 - 2), two_sample_range), legend = false, color = colors[3], lw = 2, size = [620, 320])
	
	# ribbons
	fillarea!(TDist(n_1 + n_2 - 2), collect(minimum(two_sample_range):.01:-crit_two_sample), colors[3])
	fillarea!(TDist(n_1 + n_2 - 2), collect(crit_two_sample:.01:maximum(two_sample_range)), colors[3])
	
	# test statistic
	vline!([t_two_sample], lw = 2, color = colors[1])
end

# ╔═╡ b0038ad8-2f3b-11eb-395a-e17438e6ede9
sat_t_slope ≈ t_two_sample

# ╔═╡ 199f8b02-2fc0-11eb-3840-a791395e8182
md"### Sleep example"

# ╔═╡ f31c6d14-2fbb-11eb-0660-bd1b20bbfea1
begin
	drug_1 = [0.7, -1.6, -0.2, -1.2, -0.1, 3.4, 3.7, 0.8, 0.0, 2.0]
	drug_2 = [1.9, 0.8, 1.1, 0.1, -0.1, 4.4, 5.5, 1.6, 4.6, 3.4]
	n_paired = length(drug_1)
end

# ╔═╡ 55db4022-2fbe-11eb-3d60-35b2a462ab20
md"""
###### Application: Effect of drugs on sleep
To investigate the effect two different drugs have on the sleep duration, a repeated measurement design can be employed and we collect data on the increase or decrease of sleep duration for each participant when using each drug. 

For each participant (n = $n_paired) we then get two measurements, 

1. The difference in sleep duration when using the first drug, and
2. The difference in sleep duration when using the second drug.

Negative values indicate a decrease in sleep duration compared to normal and positive values indicate an increase in sleep duration compared to normal. 

For the first drug we observe an average of $(mean(drug_1)), so participants' sleep duration increases $(mean(drug_1)) hours on average. Using the second drug, the increase in sleep duration is $(round(mean(drug_2), digits = 2)) hours on average. 

To decide which drug has larger increase in sleep duration we can calculate a t-test. Since each participant is measured twice, once using the first and once using the second drug, the samples are paired or dependent. Thus, the paired t-test is the method of choice here. 

Considering this is a pilot study with only 10 participants we can set a more lenient significance level, i.e. allow for a higher type I error rate.
"""

# ╔═╡ 2b624f40-2fbc-11eb-2b93-5d1296988482
diff = drug_1 .- drug_2

# ╔═╡ 6d91e61e-2fbc-11eb-2caf-e5610b35bbba
μ̂_d = mean(diff)

# ╔═╡ 64401a04-2fbc-11eb-2239-678cfab3f0e1
σ̂_d = std(diff)

# ╔═╡ 755c8930-2fbc-11eb-2ac8-31df8e261350
t_paired = (μ̂_d - μ0_d)/(σ̂_d / sqrt(n_paired))

# ╔═╡ 4db7def6-2fbd-11eb-0623-a58698fc0c3d
crit_paired =  quantile(TDist(n_paired - 1), 1 - alpha_paired/2)

# ╔═╡ e0965b5e-2fbc-11eb-1ae6-4bb3af446766
abs(t_paired) > crit_paired

# ╔═╡ 28612b64-2fbd-11eb-063a-ffcdb4a9d885
begin
	paired_range = -5:.01:5
	plot(paired_range, pdf.(TDist(n_paired - 1), paired_range), legend = false, color = colors[3], lw = 2, size = [620, 320])
	
	# ribbons
	fillarea!(TDist(n_paired - 1), collect(minimum(paired_range):.01:-crit_paired), colors[3])
	fillarea!(TDist(n_paired - 1), collect(crit_paired:.01:maximum(paired_range)), colors[3])
	
	# test statistic
	vline!([t_paired], lw = 2, color = colors[1])

end

# ╔═╡ 0ac85c38-2fbd-11eb-35b3-694595035b88
p_paired = 2 * (1 - cdf(TDist(n_paired - 1), abs(t_paired)))

# ╔═╡ 2133b78a-2fbd-11eb-046d-f969ad871d08
p_paired < alpha_paired

# ╔═╡ 799ee0be-2fbd-11eb-186d-13637204412b
begin
	paired_fit = lm(@formula(y1 - y2 ~ 1), DataFrame("y1" => drug_1, "y2" => drug_2))
end

# ╔═╡ 045d97d6-2fbe-11eb-141f-1f3ce1dea1ec
paired_intercept = first(coef(paired_fit))

# ╔═╡ b4dce68a-2fbd-11eb-0dc6-250d859d47f7
paired_t_intercept = paired_intercept/first(stderr(paired_fit))

# ╔═╡ 20da6434-2fbe-11eb-21be-df2a965821e1
paired_t_intercept ≈ t_paired

# ╔═╡ 9095a068-2fd2-11eb-0069-b9b2a69a5020
md"### Website engagement example"

# ╔═╡ fb815354-2fc3-11eb-1ab3-1f5d46478ed8
begin
	Random.seed!(35498)
	n_one_sample = 30
	website_duration = rand(Normal(180, 30), n_one_sample)
	one_sample_fit = lm(@formula(y ~ 1), DataFrame("y" => website_duration))
end

# ╔═╡ 93da52c6-2fcd-11eb-3dea-7d90b47c4583
μ̂_one_sample = mean(website_duration)

# ╔═╡ acd6c5a4-2fcd-11eb-3bef-6f4d0233730c
σ̂_one_sample = std(website_duration)

# ╔═╡ b74ed602-2fcd-11eb-2ae0-c31da205d057
t_one_sample = (μ̂_one_sample - μ0_one_sample) / σ̂_one_sample * sqrt(n_one_sample)

# ╔═╡ 1ea3531e-2fce-11eb-28a4-2fd02e9f021e
crit_one_sample = quantile(TDist(n_one_sample - 1), 1 - alpha_one_sample/2)

# ╔═╡ 84d17c60-2fce-11eb-3054-89c05ad66b06
abs(t_one_sample) > crit_one_sample

# ╔═╡ 8f6fddc2-2fce-11eb-2576-2d8cda45df4a
begin
	one_sample_range = -5:.01:5
	plot(one_sample_range, pdf.(TDist(n_one_sample - 1), one_sample_range), legend = false, color = colors[3], lw = 2, size = [620, 320])
	
	# ribbons
	fillarea!(TDist(n_one_sample - 1), collect(minimum(one_sample_range):.01:-crit_one_sample), colors[3])
	fillarea!(TDist(n_one_sample - 1), collect(crit_one_sample:.01:maximum(one_sample_range)), colors[3])
	
	# test statistic
	vline!([t_one_sample], lw = 2, color = "grey")
end

# ╔═╡ 995fad96-2fce-11eb-08ef-ffdc6d773878
p_one_sample = 2 * (1 - cdf(TDist(n_one_sample - 1), abs(t_one_sample)))

# ╔═╡ b2642452-2fce-11eb-26fe-0be0cb94ca89
p_one_sample < alpha_one_sample

# ╔═╡ 56ec1b90-2fd1-11eb-36ce-97fec869f9ef
one_sample_intercept = first(coef(one_sample_fit))

# ╔═╡ 0e080aee-2fd2-11eb-0d3d-f5b1a3f53706
one_sample_stderr = first(stderr(one_sample_fit))

# ╔═╡ f6d8a146-2fd1-11eb-3d3a-936fa88ca0ef
t_one_sample_intercept = (one_sample_intercept - μ0_one_sample) / one_sample_stderr

# ╔═╡ 659e02b2-2fd2-11eb-3800-39df2b28cbde
t_one_sample ≈ t_one_sample_intercept

# ╔═╡ 3574ab04-30bb-11eb-12a9-0967da3180b9
md"### χ² example"

# ╔═╡ d25f2214-30ae-11eb-16a3-8b200a8ca615
begin
	marg_pass = [486, 145]
	marg_att  = [403, 228]
	chisq_data = [322 (marg_att[1] - 322); (marg_pass[1] - 322) (marg_pass[2] - (marg_att[1] - 322))]
	chisq_expected = [.0 0; 0 0]
	
	for i = 1:2
		for j = 1:2
			chisq_expected[i, j] = marg_att[i] * marg_pass[j] / 631
		end
	end
end

# ╔═╡ ef8b717e-30b3-11eb-02cb-d5ac1fe3180c
X² = sum(((chisq_data .- chisq_expected).^2)./chisq_expected)

# ╔═╡ 0b727b66-30b5-11eb-32c8-c595ae18f06c
X² > crit_chisq

# ╔═╡ a30c3f34-30b5-11eb-24b5-ab1004189488
begin
	chisq_range = chisq_zoom ? (3:.01:5.5) : (0:.01:6)
	chisq_plot = plot(chisq_range, pdf.(Chisq(1), chisq_range), color = colors[3], legend = false, lw = 2, size = [620, 320])
	fillarea!(Chisq(1), crit_chisq:.01:maximum(chisq_range), colors[3])
	
	vline!([X²], color = colors[1], lw = 2)
end

# ╔═╡ f3ccfc2a-30b4-11eb-3e20-2bc9199e4865
p_chisq = 1 - cdf(Chisq(1), X²)

# ╔═╡ 32d76d88-30b5-11eb-22a7-35b7a2a0313b
p_chisq < alpha_chisq

# ╔═╡ Cell order:
# ╟─d05918a0-f437-11ea-3af4-9f911fe287a4
# ╟─9c798ca4-3159-11eb-3b8e-5d88359d4cff
# ╟─cfc79c06-2b08-11eb-15b8-a1caaf982997
# ╟─d69cc1dc-2b08-11eb-3d27-b3073ad6c790
# ╟─7504f65a-2b22-11eb-33ae-afbf406b6240
# ╟─25a3c51e-2b18-11eb-0490-5315e67a69bf
# ╟─eb21076c-30df-11eb-191e-cd8eff971e84
# ╟─4131b1b0-2b13-11eb-22c9-6b8e1c1ae2c5
# ╟─f0a129d6-2b23-11eb-2ea3-e9c60adbc42e
# ╟─325f8ea0-2b1b-11eb-0d02-c34faa06db0c
# ╟─981c7552-2b1b-11eb-0931-3f56703d5b8c
# ╟─6ca82a62-2b16-11eb-1f49-d99f07535642
# ╟─605e6eea-2b16-11eb-0c56-3106b579c695
# ╟─7d78bcd0-2b28-11eb-04fc-7b0b0a1bc182
# ╟─7c029ce4-2b29-11eb-2bbe-9f7c52940174
# ╟─89ce5784-2b2a-11eb-1b15-53783a69a3bb
# ╟─8ef8965a-2b29-11eb-16d7-9bc98accf14c
# ╟─0db2d0cc-2b30-11eb-3c12-e50ca38e8375
# ╟─0b86fac0-2b31-11eb-2ed0-4f734ef24b31
# ╟─acde2752-2b31-11eb-1bc5-33abdcfea2c7
# ╟─de9c0604-2b30-11eb-1742-a31e988eb891
# ╟─af0b87d4-2b32-11eb-0271-576b784a0d1b
# ╟─94bcf7f6-30e6-11eb-0012-4d43f03109b8
# ╟─426515e8-2b33-11eb-1c14-9d11e6612eb5
# ╟─35380e5c-2b33-11eb-3edb-0b873825dcb9
# ╟─71b6cd26-2b35-11eb-3c78-25f2fd96fa1b
# ╟─9a18642a-2b35-11eb-1015-2fbca1300415
# ╟─e12838de-2b35-11eb-046d-3f534d9eacaf
# ╟─5ac4dcf2-2b35-11eb-1958-d93504485182
# ╟─58847abc-2b3a-11eb-1526-0f0916b315fa
# ╟─641e8988-2b35-11eb-34f3-c5940fc1a389
# ╟─2434f052-2b38-11eb-15c0-510df672edb9
# ╟─1fc3c89c-2b63-11eb-271c-ad955322ff2e
# ╟─1997c6de-2b1e-11eb-316a-d7155126c2e8
# ╟─0543a682-2d92-11eb-264d-190ef3fdd1b0
# ╟─5cfb8534-2d92-11eb-3f4a-7dd6a31eb787
# ╟─78e395ac-2d92-11eb-1b65-fd6182de4e24
# ╟─b0de1cd4-2d92-11eb-0212-9ff6f68b7864
# ╟─449548d0-2d93-11eb-38ef-2b5b9d6efac6
# ╟─a9b30858-2d94-11eb-36c5-f9d61508f7ff
# ╟─02b4d404-2d92-11eb-2c13-618e20eb6938
# ╟─070c90c2-2d98-11eb-07f4-47a084b55dd1
# ╟─6c679802-2b65-11eb-1285-d5b323d781de
# ╟─63bedadc-2e3d-11eb-1dc3-09c049588d68
# ╟─3dc1cde2-2e3f-11eb-24b5-8146afe2bf30
# ╟─3dc24646-2e3f-11eb-006b-63089ece5c7d
# ╠═8d3936fc-2e3e-11eb-0f3f-53b479c7fe0e
# ╟─993d49d6-2e3e-11eb-2e23-699c581247bc
# ╟─dc09e738-2e3e-11eb-0c51-f3525c68dd69
# ╠═6e392048-2e3e-11eb-3190-d72e588d480d
# ╟─3b69f6a4-2e59-11eb-1bdd-53daf0b42a36
# ╠═24a8fdbc-2e3f-11eb-3fc8-7b79893f5f0d
# ╟─82abecd0-2e3f-11eb-3bbc-919bc6cb09c2
# ╠═6aebd510-2e3f-11eb-0afe-4f6318bb0e1f
# ╟─b8b130b8-2e67-11eb-042a-45da03d5128f
# ╟─b8b47086-2e3f-11eb-3425-794064887aae
# ╠═f346b896-2e3f-11eb-3a82-65fe5dfb7097
# ╠═3de768be-2e40-11eb-1aa3-63f6875138b7
# ╟─bef54094-2e35-11eb-16f0-91db2b5d868e
# ╠═78846be0-2e5d-11eb-30f6-cd110d264ac6
# ╠═8c4e4002-2e5e-11eb-1d44-dd080fdfc504
# ╟─068fbce2-2e5f-11eb-1048-110600ddbf19
# ╠═7af24138-2e5d-11eb-33ad-ad98abe9bd07
# ╟─1e8434ec-2e5f-11eb-133f-b1f493c26299
# ╠═79cfcb12-2e5e-11eb-149a-0d4543a007a8
# ╟─3afb98e8-2e5f-11eb-3673-85dd9880c9fc
# ╟─e489142c-2e5e-11eb-2dec-8d2d08876806
# ╠═d3ca5984-2e5e-11eb-2e59-35f6c1e6593e
# ╟─71c2ac04-2e5f-11eb-38ea-31c52dd9a9eb
# ╠═b7f3810e-2e5e-11eb-1b5d-431c602510f6
# ╟─8c21a79e-2e5f-11eb-2a7c-f30bf6fededc
# ╠═f3aff268-2e5e-11eb-3fe4-a98a5914d726
# ╟─63bdab70-2e68-11eb-1bd3-45397521a379
# ╟─fb517bf4-2e5e-11eb-0c29-03b8d5e41d2c
# ╠═fd5b81b2-2e5f-11eb-2c1c-8f143bf3e624
# ╠═22484796-2e60-11eb-0218-b5d2288d6f35
# ╟─42c37258-2e64-11eb-0881-cbbb274a7c1f
# ╠═a7d8cf1e-2e64-11eb-2963-27cda0cebfab
# ╠═cf355bca-2e64-11eb-3f5e-b5478020e8d7
# ╟─35864ca4-2e65-11eb-2b64-bd4ca92bef49
# ╟─6bf50de8-2e65-11eb-37b2-3dc8506c5a2c
# ╟─10fe55be-2e67-11eb-285e-5173231ba89c
# ╠═deae3f2a-2e66-11eb-10ca-7de9102e5b22
# ╠═2a1ab4ca-2e67-11eb-2bab-f17a715eac69
# ╠═38ac3220-2e67-11eb-0294-cfdd1a83ac33
# ╟─416a1790-2e67-11eb-010d-f7a8a8f08222
# ╟─c4559eb8-2e35-11eb-3871-e5bf96c3ade6
# ╟─03de7e50-2f06-11eb-32e7-a5597f19097b
# ╟─52ef79a0-2fc3-11eb-062e-5b54d78663da
# ╠═f3b72ed2-2fc3-11eb-26f8-0534f88b5cee
# ╟─c50341b4-2fcd-11eb-07e6-c5760f00ef95
# ╠═bb788a3e-2fcd-11eb-216e-a5128f5a65d1
# ╟─03de8bce-2fcf-11eb-18a3-31c7390562e3
# ╠═93da52c6-2fcd-11eb-3dea-7d90b47c4583
# ╠═acd6c5a4-2fcd-11eb-3bef-6f4d0233730c
# ╟─1b6b7a04-2fcf-11eb-2422-2f13115cf768
# ╠═b74ed602-2fcd-11eb-2ae0-c31da205d057
# ╟─2ab5e97c-2fcf-11eb-17b7-d57781e6358e
# ╠═1ea3531e-2fce-11eb-28a4-2fd02e9f021e
# ╟─47e4278e-2fcf-11eb-1ef1-8fbffa0622cf
# ╠═84d17c60-2fce-11eb-3054-89c05ad66b06
# ╟─8f6fddc2-2fce-11eb-2576-2d8cda45df4a
# ╟─5832134e-2fcf-11eb-3860-375404cb2ed6
# ╠═995fad96-2fce-11eb-08ef-ffdc6d773878
# ╟─b09fbc52-2fcf-11eb-1d4a-99367f5fb319
# ╠═b2642452-2fce-11eb-26fe-0be0cb94ca89
# ╟─bd445db4-2fcf-11eb-0b10-49351afa5fd3
# ╟─0d6dc590-2fd1-11eb-28b5-21c8a98beb4d
# ╠═56ec1b90-2fd1-11eb-36ce-97fec869f9ef
# ╠═0e080aee-2fd2-11eb-0d3d-f5b1a3f53706
# ╠═f6d8a146-2fd1-11eb-3d3a-936fa88ca0ef
# ╟─3b5c26bc-2fd2-11eb-0166-bde60dc1cd91
# ╠═659e02b2-2fd2-11eb-3800-39df2b28cbde
# ╟─abcf7ec8-2f03-11eb-2436-c1b9cf418d79
# ╟─55db4022-2fbe-11eb-3d60-35b2a462ab20
# ╠═f97e6b7a-2fbc-11eb-0592-95a8bd60fc0c
# ╟─acfea2c6-2fbf-11eb-3bec-e9be16a8127d
# ╠═7ef9068a-2fbc-11eb-055a-a712387ee69a
# ╟─f65af7ce-2fbf-11eb-2cbd-356d4b72342c
# ╠═2b624f40-2fbc-11eb-2b93-5d1296988482
# ╟─27acf522-2fc0-11eb-19b3-db2c0d03476a
# ╠═6d91e61e-2fbc-11eb-2caf-e5610b35bbba
# ╠═64401a04-2fbc-11eb-2239-678cfab3f0e1
# ╟─4beec56e-2fc0-11eb-2581-f74f7b4a823b
# ╠═755c8930-2fbc-11eb-2ac8-31df8e261350
# ╟─5dea47b8-2fc0-11eb-04a4-2fe568e203fc
# ╠═4db7def6-2fbd-11eb-0623-a58698fc0c3d
# ╠═e0965b5e-2fbc-11eb-1ae6-4bb3af446766
# ╟─28612b64-2fbd-11eb-063a-ffcdb4a9d885
# ╟─784de40a-2fc0-11eb-35db-674a7039bc6e
# ╠═0ac85c38-2fbd-11eb-35b3-694595035b88
# ╠═2133b78a-2fbd-11eb-046d-f969ad871d08
# ╟─8855aa48-2fc0-11eb-31f0-eb691e0d571f
# ╟─765dd98c-2fbd-11eb-25bd-df3aa2710ebf
# ╠═045d97d6-2fbe-11eb-141f-1f3ce1dea1ec
# ╠═b4dce68a-2fbd-11eb-0dc6-250d859d47f7
# ╠═20da6434-2fbe-11eb-21be-df2a965821e1
# ╟─5cff4d70-2f1a-11eb-1fc0-63ddf417576f
# ╟─10997d48-2f33-11eb-22a0-7144c5face29
# ╟─0e6e60a4-2f37-11eb-2d1f-b3e83d5477c2
# ╟─0e702f06-2f37-11eb-07ec-058b4187ab96
# ╠═112e7bda-2f35-11eb-0b18-61af0a05f2b8
# ╟─abda0950-2f36-11eb-3712-fd93df0fd177
# ╠═2a880910-2f36-11eb-3dfb-b99ad17a28c4
# ╠═1523bbd0-2f36-11eb-35c0-9b45de74ffbb
# ╟─153b0d0e-2f37-11eb-077b-ed535d424c74
# ╠═c11d3b2a-2f36-11eb-1e2c-c30890a6f9ba
# ╟─2504c9b4-2f37-11eb-3984-7ddde827359a
# ╠═61f4cc32-2f37-11eb-2d8f-67d765c7b7c1
# ╠═70cf32ee-2f37-11eb-0b62-7bd4714bbe9e
# ╟─7f442b0e-2f37-11eb-3fbc-c17329912ff8
# ╟─8d5cc154-2fb6-11eb-1327-ab5019588124
# ╟─bcf352b8-2f37-11eb-3574-b3a6eb8eead6
# ╠═1d13e976-2f38-11eb-1572-ab7d762b9829
# ╠═b0038ad8-2f3b-11eb-395a-e17438e6ede9
# ╟─b9613094-2f3b-11eb-2742-45f4940ce540
# ╠═cff2ab26-2f3b-11eb-17c2-5198791d3a2f
# ╠═f51dc44e-2f3b-11eb-157a-3d43582eb462
# ╟─8d04e6be-2f20-11eb-0662-7d7aab01eeb9
# ╟─75ab7ff0-2f20-11eb-0e5d-1bf97d3c5bc0
# ╟─3391b126-30a0-11eb-265a-497cb953e026
# ╠═ef8b717e-30b3-11eb-02cb-d5ac1fe3180c
# ╟─3933bb88-30b4-11eb-145b-8ded6858ec9a
# ╠═662bd29c-30b4-11eb-2c0b-d713d0270146
# ╠═4c047b12-30b4-11eb-0a51-ff5ca87263e5
# ╠═0b727b66-30b5-11eb-32c8-c595ae18f06c
# ╟─d0469f70-30b6-11eb-07e3-c1640f135a5e
# ╟─a30c3f34-30b5-11eb-24b5-ab1004189488
# ╟─a3a5a1a2-30b4-11eb-3acd-0b98018e3898
# ╠═f3ccfc2a-30b4-11eb-3e20-2bc9199e4865
# ╟─1498871c-30b5-11eb-1a39-5fe7a273f512
# ╠═32d76d88-30b5-11eb-22a7-35b7a2a0313b
# ╟─0bdb4eda-30b2-11eb-3d92-b191224f3afb
# ╟─567ccc10-3092-11eb-13c1-0d4e1ad28755
# ╟─ec0bcb70-2b04-11eb-25b1-272893194a99
# ╟─f10b8190-2b04-11eb-2ec3-69c141f0c0b4
# ╠═f5e5879e-2b04-11eb-1eae-df089d8cb101
# ╠═c6398592-2b16-11eb-0c60-a7e8a30d97ad
# ╠═cc0fd370-2b16-11eb-1963-1d0e92c41618
# ╠═d5907816-2b16-11eb-0bc1-c5228eff3ecd
# ╠═ddcfbff0-2b16-11eb-2154-b9233c1ebda4
# ╠═e200a224-2b16-11eb-1e0d-d3909f3dc02b
# ╠═5b2363d4-2b31-11eb-3af1-3da709743a37
# ╟─ce259964-2b64-11eb-0895-cf95c3bd8be5
# ╠═3f986a40-2b38-11eb-0fa6-d1dc59267fe2
# ╟─83d70e98-2b36-11eb-0091-a553c28e12e9
# ╠═70dab02a-2d92-11eb-1ab7-1b070f98c3d1
# ╟─4c44eaec-2e40-11eb-2de3-b3fefc6fe2f4
# ╠═95b1d71a-2e3d-11eb-1b7d-e515f23daf58
# ╟─9872c566-2e5d-11eb-05bd-df6e157ec316
# ╠═9b5c1020-2e5d-11eb-2ed6-b9188a073e7d
# ╠═a3eec53e-2e5d-11eb-1288-23ba6f0b32bf
# ╟─769dfcd8-2f33-11eb-21fa-3548b6184b8f
# ╠═7da06712-2f33-11eb-10a5-39426f4eed73
# ╠═6cf21f7c-2f34-11eb-078a-535da793726c
# ╠═54f97e18-2f36-11eb-0834-2f770f041784
# ╠═5cec63c4-2f36-11eb-2879-57f73f4f5e7f
# ╟─199f8b02-2fc0-11eb-3840-a791395e8182
# ╠═f31c6d14-2fbb-11eb-0660-bd1b20bbfea1
# ╠═799ee0be-2fbd-11eb-186d-13637204412b
# ╟─9095a068-2fd2-11eb-0069-b9b2a69a5020
# ╠═fb815354-2fc3-11eb-1ab3-1f5d46478ed8
# ╟─3574ab04-30bb-11eb-12a9-0967da3180b9
# ╠═d25f2214-30ae-11eb-16a3-8b200a8ca615

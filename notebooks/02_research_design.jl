### A Pluto.jl notebook ###
# v0.11.14

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

# ╔═╡ 1daa5d00-f814-11ea-0310-e349861cdfa7
using PlutoUI, Random, Statistics

# ╔═╡ 14ec6500-f427-11ea-1078-254be1839698
md"# Principles of quantitative research"

# ╔═╡ 35974d90-f73f-11ea-13c1-d946b6d0155c
md"""
## Introduction to quantitative research
### Experiments

Example AB Testing

### Natural experiments

Example Wiki

### Observational studies

...

"""

# ╔═╡ 5ed37c60-f73f-11ea-2f77-29f539dee7a0
md"""
## Measurement 📏

[insert example from student questionnaire]

### Tests
- Definition of (psychological) tests (Jan Folien 8ff)
- Why tests instead of single questions?
- Example: Zeitschriftentest

"""

# ╔═╡ 22363e10-f761-11ea-0a1d-e34a07732aeb
md"""
### Measurement in the social sciences

>  measurement, in the broadest sense, is defined as the **assignment of numerals to objects or events** according to rules.

-- Stevens, S. S. (1946). On the Theory of Scales of Measurements. *Science*. [📩](https://psychology.okstate.edu/faculty/jgrice/psyc3214/Stevens_FourScales_1946.pdf)

- Very broad definition of measurement, which is not necessarily compatible with measurement in a physical sense.
- Allows a classification of *scales* with associated mathematical and statistical operations.  
"""

# ╔═╡ cefeba70-f7f5-11ea-3ed6-b77e7bfa32bd
md"""
### Types of variables
- discrete vs. continuous
- quantitative vs. qualitative
- latent vs. manifest

[two_column layout]
"""

# ╔═╡ d54664f0-f7f5-11ea-24df-5bc68da34315
md"""
### Scales
According to Steven's (1946) classification there exist 4 scales: 

| Scale | mathematical operation | statistical operation |
| :--- | :--- | :--- |
| *nominal* | determination of (in)equality | (relative) frequency, mode | 
| *ordinal* | determination of greater/less (ranking) | median, percentiles |
| *interval* | determination of equality of intervals or differences | mean, standard deviation, ... |
| *ratio* | determination of equality of ratios | coefficient of variation |

- Scales are **cumulative**, meaning that a scale must satisfy all properties of *lower* scales.
"""

# ╔═╡ 31572eb0-f746-11ea-3a11-67414d23ec4d
md"""
#### Nominal scale
- Most unrestricted type of measurement
- Fewest mathematical operations admissible

When forming a nominal scale we are using numbers as **group labels**. An example of a nominal scale would be the classification of students according to their area of study, e.g. *humanities* (1), *social sciences* (2) *natural sciences* (3), and *other* (4).

Formally we could write this as

$x_i = \begin{cases}
1 & \text{if area of study is humanities,} \\
2 & \text{if area of study is social sciences,} \\
3 & \text{if area of study is natural sciences,} \\
4 & \text{otherwise.}
\end{cases}$

The assigned numbers are mere labels, as it makes no reason to state that $x_1 = 1$ is in some way smaller than $x_2 = 2$ or even calculate differences like $x_2 - x_1 = 1$. Instead the only thing we can reasonably ask from a nominal scale is the number of occurances for each category. We call this statistical summary a **frequency** and call the most frequent category the **mode** (see lecture on descriptive statistics for additional information). 

> **Assignment rule:** Do not assign the same number to different classes or different numbers to the same class.
"""

# ╔═╡ 219fe5be-f746-11ea-3fd6-898d0fb0b316
md"""
#### Ordinal scale
The next step in the hierarchy is the *ordinal scale* which allows **rank ordering** of the categories.

- most common type of measurement in the social sciences

A classic example of an ordinal scale is the *grading scheme* in school and university. In Austria we construct the following scale, 

$x_i = \begin{cases}
1 & \text{if the performance is very good,} \\
2 & \text{if the performance is good,} \\
3 & \text{if the performance is satisfactory,} \\
4 & \text{if the performance is sufficient,} \\
5 & \text{if the performance is insufficient.}
\end{cases}$

If we observe data from 2 people, $x_1 = 4$ and $x_2 = 5$ it is easy to see that $x_1 < x_2$ and $x_1$ is in some sense better than $x_2$. While we can calculate differences in ranks, - a property that is reserved for interval and ratio scales.

> **Assignment rule:** Assign increasing numbers to the classes according to their rank order.
"""

# ╔═╡ 29061fa0-f746-11ea-3e2a-75a5bbf9254f
md"""
#### Interval Scale
- Lowest level of a *quantitative* scale
- allows for comparison of intervals and differences

"""

# ╔═╡ 14bffa50-f7f7-11ea-328a-ad856cdfc29f
md"""
#### Ratio Scale
- almost never encountered in social science
- implies knowledge of an absolute zero
- 
"""

# ╔═╡ d8758610-f74b-11ea-1468-5371a7daa121
md"""
## Designing and constructing questionnaires
- What do I want to measure?
- What is my target population?
- Is there any relevant existing material?
- Which item format(s) should I consider?
- Is the questionnaire length appropriate?  

"""

# ╔═╡ 7f907640-f7fa-11ea-1577-ad0d67b4e558
md"""
### Item construction
Construction of a psychological test of questionnaire can be a difficult task. We differentiate between *intuitive* and *rational* construction of a test.
"""

# ╔═╡ cebf6020-f7f8-11ea-28c1-a7b698519e0e
md"""
### Item Types

"""

# ╔═╡ 83066dae-f7fb-11ea-0c33-ffec1c4aac82
md"""
### Response Formats
#### Open response format
"""

# ╔═╡ dc6efff0-f7fd-11ea-32ee-c7666031fe06
md"#### Multiple-Choice format"

# ╔═╡ c5f7b2c0-f7fe-11ea-3256-c575b19ef133
md"#### Dichotomous response format"

# ╔═╡ 5917baf0-f7ff-11ea-15ef-bdacf4f79449
md"""#### Categorical response format
Differentiate based on

- polarity (unipolar, bipolar)
- numerical vs. verbal vs. optical
- number of categories (even vs. odd)
"""

# ╔═╡ 6749ea80-f7ff-11ea-0c46-e92f53e468a0
md"#### continuous response formats"

# ╔═╡ 879dd020-f7fb-11ea-3d0c-79f1de822629
md"""
### Biases
"""

# ╔═╡ cc5125a0-f800-11ea-160b-c1f1a2eb13db
md"## Evaluating questionnaires"  # Testgütekriterien

# ╔═╡ a874bae0-f817-11ea-2b43-ff026f3a5ad5
begin
	Random.seed!(4)
	population = rand(["👨", "👩"], 8, 8)
end

# ╔═╡ cabadb00-f74c-11ea-08f6-698e030feb5c
md"""
## Sampling
We almost never collect data randomly, but are interested in a specific group of people or other groups (e.g. schools). In surveying it is paramount to define this group of people we are interested in exactly. We call it our **target population**.

In the vast majority of cases, we cannot collect data on every *unit* of our population. This is because we usually do not have enough resources (time and/or money) to do so. In many cases it is even theoretically impossible to collect data for every unit of our population. Instead we turn to a statistical process called **sampling**, where we collect data on a *subset of the target population* according to some rule. Using inferential statistics we can then (under some circumstances) *estimate* from the sample the quantity of interest in the population.[^1] 

There are a variety of ways in which to construct a sample. On a basic level we differentiate between **probability sampling** and **nonprobability sampling**. 

In probability sampling, each unit of the target population has some probability greater than 0 to be included in the sample *and* the inclusion probabilities are known for each unit. In other words this means that in theory every unit has a possibility to get sampled and we know how probable it is. Probability sampling schemes include

###### Simple random sampling
Simple random sampling is a basic selection process. It is defined as a sampling procedure in which units are chosen completely at random, such that every unit has the exact same probability of being included in the sample. Usually the units are sampled **without replacement**, i.e. each unit can only be included at most once.
When sampling **with replacement** each unit can potentially be included multiple times. 

Imagine we want to figure out what is the percentage of girl births. Our hypothetical population consists of N = 64 births, as you can see below. In the population we observe that $(round(mean(population .== "👩") * 100))% of births are girls.
"""

# ╔═╡ 9ddb9090-f817-11ea-01b8-5fc77c57439a
md"""
In practice we do not observe the whole population, but we can draw a random sample by selecting each individual birth with probability $\frac{n}{N}$ and estimate the percentage of girl births.

sample size: $(@bind sample_size Slider(1:64, default = 5)) $(@bind new_sample Button("Draw new sample"))
"""

# ╔═╡ 1995c9b0-f815-11ea-24d2-bd0b25905784
begin
	new_sample
	idx = randperm(64)
end

# ╔═╡ 82bb3c70-f812-11ea-3cd3-e56c047d9ba8
sample_idx = idx[1:sample_size]

# ╔═╡ 11675672-f818-11ea-2db5-f145e043edc3
begin
	p2 = copy(population)
	p2[sample_idx] .= "❎"
	p2
end

# ╔═╡ c7f6ee12-f812-11ea-0a4c-c549497ecb01
sample = population[sample_idx]

# ╔═╡ 1b75f400-f818-11ea-3080-717a802487e2
md"""You can see we sampled n = $(sample_size) people from our population, resulting in an estimate of $(round(mean(sample .== "👩") * 100))% of girl births. As we increase our sample size, our estimate gets more accurate."""

# ╔═╡ 961ad440-f80f-11ea-2360-39edf365e26b
md"""
###### Stratified sampling

[...]
[Wahlumfragedaten heute.at]
"""

# ╔═╡ d0088550-f821-11ea-39ce-7dcfa8bbc450
md"""
In constrast, nonprobability sampling refers to sampling processes which allow a probability of zero for some sampling units *or* to sampling processes where the probabilities are unknown. In general this leads to a phenomenon called **sampling bias**, where quantities of the population cannot be estimated correctly. Samples from these processes are called *non-representative* samples, because they do not adequatly reflect the target population. Nonprobability samples are very common, especially in the social sciences. 

> ⚠️ The results from a nonprobability sample **cannot be generalized** to the target population!

###### Convenience sampling
"""

# ╔═╡ fc39fc20-f81d-11ea-02cc-27ff11c91303
md"[^1]: We will cover the topic of inference and estimation later in this course."

# ╔═╡ d22bace0-f7f4-11ea-1858-ddc3259e5ebd
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

# ╔═╡ d0052690-f7f8-11ea-3c3b-138df428e074
two_columns(md"""
**intuitive construction:**
- based on expertise of the author 
- seldom based on theory
- construct is evaluated after test construction	

""",
md"""
**rational construction:**	
- elaborate theory is a necessary condition
- construct is based on literature
- definition and collection of indicators which describe low and high values of the attribute
""")

# ╔═╡ a6183e00-f7fb-11ea-1c16-995824fd898b
two_columns(md"""
**Strong points:**
- asd
- asd
""", md"""
**Weak points:**
- asd
""")

# ╔═╡ fcc86700-f7fd-11ea-01e1-c7134cc7a58b
two_columns(md"""
**Strong points:**
- economical scoring
- unique solution
- no influence of assessor
""", md"""
**Weak points:**
- probability of guessing correctly
- difficult to construct well
""")

# ╔═╡ 37536880-f81b-11ea-0e94-73ca89a3a08c

two_columns(md"""
**Strong points:**
- **requires very little knowledge** about the population
- **unbiased** estimates (can draw conclusions about the population)
- easily realized
""", md"""
**Weak points:**
- **inefficient** (needs larger sample sizes compared to other methods)
""")

# ╔═╡ d4bb5f00-f821-11ea-1208-27534472e671
two_columns(md"""
**Strong points:**
- can be **more efficient** than simple random sampling
- can give **accurate estimates for subpopulations** (especially if group sizes are small)
- practical advantages in data collection (cost, management, ...)
""", md"""
**Weak points:**
- **only for populations which can be partitioned** into disjoint subgroups
- **requires knowledge** of population sizes for all strata 
- requires more complex statistical procedures (weighted methods)
""")

# ╔═╡ 82858ca0-f7f5-11ea-2ca9-cd5c02cf03f3
center(x) = HTML("<div style='text-align: center'>$(Markdown.html(x))</div>")

# ╔═╡ d81c6852-f7f5-11ea-38fa-c1c5297b07f0
two_columns(md"""
$(center(md"##### discrete"))
  ✔️
  ❌
""", md"""
$(center(md"##### continuous"))
	
""")

# ╔═╡ bc9a0f50-f7f6-11ea-2b17-f18050cc9a87
two_columns(md"""
$(center(md"##### quantitative"))
  ✔️
  ❌
""", md"""
$(center(md"##### qualitative"))
	
""")

# ╔═╡ c42c1420-f7f6-11ea-36e9-e90adaa3edc0
two_columns(md"""
$(center(md"#### manifest"))
  ✔️ directly observable
""", md"""
$(center(md"#### latent"))
  ❌ only indirectly obserable
""")

# ╔═╡ 94bfa120-f7fb-11ea-00f1-83ab1e2b58b1
center(md"[show an example here]")

# ╔═╡ f61a0b70-f7fd-11ea-1207-5f658c441630
center(md"[show an example here]")

# ╔═╡ 11e12a10-f807-11ea-3684-a3d424570b93
plus(x) = HTML("<li class='plus'>$(Markdown.html(x))</li>")

# ╔═╡ Cell order:
# ╟─14ec6500-f427-11ea-1078-254be1839698
# ╠═35974d90-f73f-11ea-13c1-d946b6d0155c
# ╠═5ed37c60-f73f-11ea-2f77-29f539dee7a0
# ╠═22363e10-f761-11ea-0a1d-e34a07732aeb
# ╠═cefeba70-f7f5-11ea-3ed6-b77e7bfa32bd
# ╠═d81c6852-f7f5-11ea-38fa-c1c5297b07f0
# ╠═bc9a0f50-f7f6-11ea-2b17-f18050cc9a87
# ╠═c42c1420-f7f6-11ea-36e9-e90adaa3edc0
# ╠═d54664f0-f7f5-11ea-24df-5bc68da34315
# ╟─31572eb0-f746-11ea-3a11-67414d23ec4d
# ╠═219fe5be-f746-11ea-3fd6-898d0fb0b316
# ╠═29061fa0-f746-11ea-3e2a-75a5bbf9254f
# ╠═14bffa50-f7f7-11ea-328a-ad856cdfc29f
# ╠═d8758610-f74b-11ea-1468-5371a7daa121
# ╠═7f907640-f7fa-11ea-1577-ad0d67b4e558
# ╠═d0052690-f7f8-11ea-3c3b-138df428e074
# ╠═cebf6020-f7f8-11ea-28c1-a7b698519e0e
# ╟─83066dae-f7fb-11ea-0c33-ffec1c4aac82
# ╠═94bfa120-f7fb-11ea-00f1-83ab1e2b58b1
# ╠═a6183e00-f7fb-11ea-1c16-995824fd898b
# ╠═dc6efff0-f7fd-11ea-32ee-c7666031fe06
# ╠═f61a0b70-f7fd-11ea-1207-5f658c441630
# ╠═fcc86700-f7fd-11ea-01e1-c7134cc7a58b
# ╠═c5f7b2c0-f7fe-11ea-3256-c575b19ef133
# ╠═5917baf0-f7ff-11ea-15ef-bdacf4f79449
# ╠═6749ea80-f7ff-11ea-0c46-e92f53e468a0
# ╠═879dd020-f7fb-11ea-3d0c-79f1de822629
# ╟─cc5125a0-f800-11ea-160b-c1f1a2eb13db
# ╟─cabadb00-f74c-11ea-08f6-698e030feb5c
# ╟─a874bae0-f817-11ea-2b43-ff026f3a5ad5
# ╟─9ddb9090-f817-11ea-01b8-5fc77c57439a
# ╟─11675672-f818-11ea-2db5-f145e043edc3
# ╟─c7f6ee12-f812-11ea-0a4c-c549497ecb01
# ╟─1b75f400-f818-11ea-3080-717a802487e2
# ╠═1daa5d00-f814-11ea-0310-e349861cdfa7
# ╠═1995c9b0-f815-11ea-24d2-bd0b25905784
# ╠═82bb3c70-f812-11ea-3cd3-e56c047d9ba8
# ╟─37536880-f81b-11ea-0e94-73ca89a3a08c
# ╟─961ad440-f80f-11ea-2360-39edf365e26b
# ╠═d4bb5f00-f821-11ea-1208-27534472e671
# ╠═d0088550-f821-11ea-39ce-7dcfa8bbc450
# ╟─fc39fc20-f81d-11ea-02cc-27ff11c91303
# ╠═d22bace0-f7f4-11ea-1858-ddc3259e5ebd
# ╠═82858ca0-f7f5-11ea-2ca9-cd5c02cf03f3
# ╠═11e12a10-f807-11ea-3684-a3d424570b93

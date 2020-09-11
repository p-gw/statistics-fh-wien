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

# ╔═╡ 9342bc00-f293-11ea-3232-ad6b72c3c76e
begin
	using Pkg
	Pkg.add("Distributions")
	Pkg.add("Plots")
	Pkg.add("CSV")
	Pkg.add("HTTP")
	Pkg.add("DataFrames")
	Pkg.add("PlutoUI")
	using Distributions, Plots, CSV, HTTP, DataFrames, PlutoUI
end

# ╔═╡ 90992400-f28c-11ea-09c2-c7e9e2522724
md"""
# Descriptive Statistics & Visualization

Describing data is always an important step during an emprical research project or data analysis in general. 
There are a lot of different ways to carry out this task, but both **numerical** and **visual** data description of some sort are employed almost every time.

In this lecture we will first discuss numerical statistics to describe quantitative data. We will subsequently look at some of the most common statistical visualization types and learn when to use them.
"""

# ╔═╡ 5723dca0-f28d-11ea-1195-a74c01361283
md"""
## Descriptive statistics
Descriptive measures can be categorized in various ways. Most commonly they are grouped by the *number of variables* they consider. If a descriptive measure summarizes one variable we call them **univariate** descriptive statistics. If they summarize two variables, we label them as **bivariate** descriptive statistics. Generally statistics which consider more than two variables are called **multivariate** statistics.
	
Lets start with an example: In the student questionnaire at the beginning of the semester I asked you to provide both your *height* and the *handspan* of your dominant hand. 

As you can see, just looking at the raw data for our heights does not give us very much information.
"""

# ╔═╡ 440397c0-f290-11ea-3db5-8532bcb6723f
n = 40

# ╔═╡ 863b5830-f290-11ea-21e0-2b0a8133925a
heights = rand(Normal(mean([179, 166]), 15), n)

# ╔═╡ 4627d750-f290-11ea-0a38-09206ac4082c
md"""
So instead we would prefer to summarize it such that it is easier to interpret.
We can do this by choosing the appropriate descriptive statistic for the task. 

We can, for example, calculate the average height in the data.
"""

# ╔═╡ 5cb878e0-f28f-11ea-3bad-195a7b79b7fe
mean(heights)

# ╔═╡ 4673a2d0-f28f-11ea-33ec-ff59d41242c4
md"""
or, if we are interested in the variability of the data look at the minimum and maxumum values.
"""

# ╔═╡ 14faec6e-f291-11ea-3ef7-99c8bf75eb0e
[minimum(heights), maximum(heights)]

# ╔═╡ 7f4b7f70-f293-11ea-0944-810378f076d8
md"""
Alternatively we can represent the sample of heights visually like this:
"""

# ╔═╡ 9af65290-f293-11ea-0916-15f402e2f43a
histogram(heights, bins = 8, legend = false, xlabel = "height (cm)", color = "grey", ylabel = "count")

# ╔═╡ 07c2bf30-f28f-11ea-01aa-51457d3ed6e3
md"""
### Univariate descriptive statistics
Both descriptive statistics in the example were *univariate*, but did differ significantly in their interpretation. The average is concerned with finding a **representative value** for the sample, the extent (minimum and maximum) were a attempt to summarize how **different** the values in the sample are.

This theme arises all over statistics and we can group descripitve statistics accordingly. We call descriptive statistics which try to find a representative value *measures of central tendency* and statistics which try to summarize the spread of the data *measures of variability*.

In this section we will get to know some of the most common univariate statistics and see when and for which type of variable they are appropriate.
"""

# ╔═╡ 8c693c52-f294-11ea-2e30-d15bad950231
md"""
#### Measures of central tendency
##### Mean
The *sample mean* or *arithmetic mean* of a sample $x_1, \ldots, x_N$ is defined by

$\bar{x} = \frac{1}{N}\sum_{i=1}^N x_i,$

where $N$ is the sample size. To calculate the sample mean we must first add up all the samples and then divide by the number of samples. 
The result we get is an *average* data point.

Consider the sample $x_1 = 1.5$, $x_2 = 4.0$ and $x_3 = 5.4$. If we calculate the sum we get 

$\sum_{i=1}^3 x_i = x_1 + x_2 + x_3 = 1.5 + 4.0 + 5.4 = 10.9.$

Then we must divide by the number of data points ($N = 3$ in the example) to get the sample mean of $\bar{x} = 10.9/3 \approx 3.63$.

We can verify this result in software:
"""

# ╔═╡ 1997dae0-f296-11ea-0dab-ddaa25a2ec82
(1.5 + 4.0 + 5.4)/3

# ╔═╡ 22863b60-f296-11ea-3b7c-1fdf27791ab7
md"This is identical to the included `mean` function and matches our result from manual calulation."

# ╔═╡ 33901c02-f296-11ea-1965-4dc0fa850d8f
mean([1.5, 4.0, 5.4])

# ╔═╡ 10b45a60-f297-11ea-3ec6-89bbb6c0d54c
md"""
The sample mean is probably the most important measure of central tendency. But when is it applicable? In general it is appropriate for all *metric* variables, but as we will see later it might not be the best choice for some sample distributions.

A notable exception to this is binary data. In the student questionnaire we also collected *Gender*. Not including the category *prefer not to say* this is a nominal binary variable with the respective values *male* and *female*. If we code our nominal variable with 

$x_i = \begin{cases} 
1 & \text{if gender is female,}\\
0 & \text{otherwise.}
\end{cases}$

we can calculate the sample mean as well!
"""

# ╔═╡ 4a048630-f299-11ea-3352-83c2eeae90f6
genders = rand([0, 1], 40)

# ╔═╡ 4469a100-f29a-11ea-21d6-3f9c9fe7fa7c
mean(genders)

# ╔═╡ 4c507c8e-f29a-11ea-253a-cd317776a579
md"""
The result is called the **relative frequency** of *female*.
"""

# ╔═╡ 46fee750-f299-11ea-1e70-0dccb5db9034
md"""
In practical application the arithmetic mean is used *everywhere*. We will see some examples of this later in the course, for example when the arithmetic mean is used to estimate expected values from probability distributions. 

###### Practical application: COVID-19 cases in Austria
But for now let us consider a practical example in time series analysis, the **simple moving average**. As an example we will use the time series of daily COVID-19 cases in Austria. From the following plot it is obvious there is a clear 'trend', but there is also a lot of variability from day to day (zig-zag-line). The moving average can help us to better visualize the trend. 

window length: $(@bind window Slider(1:2:31, default = 7))

display trend: $(@bind display_trend CheckBox()) 
"""

# ╔═╡ b0cab5c0-f2a2-11ea-3b86-8705da08a72f
md"""
The moving average is what is typically displayed in news reports, see e.g. [here](https://at.staticfiles.at/snippets/interaktiv/2020/03-covid19/neuinfektionen.html?599c7e4cbe44eac594e3).

Calculation of the moving average is identical to the simple arithmetic mean with one exception. Instead of calculating the mean over the whole sample, we define some time frame (the so called window length) and calculate the mean for every subseqent time. Consider the following toy example with 7 measurements of stress level (0 - 100) during the week:

| day | t | stress level |
| --- | --- | --- |
| Monday | 1 | 53 |
| Tuesday | 2 | 77 |
| Wednesday | 3 | 68 |
| Thursday | 4 | 61 |
| Friday | 5 | 39 |
| Saturday | 6 | 21 |
| Sunday | 7 | 19 |
"""

# ╔═╡ bb0ecc20-f2ab-11ea-3699-6d4940be3151
md"""
To calculate the moving average we first must define the window length to know how many values to use for each mean. Let us set a window length of 3, such that for each day we take the previous, current, and upcoming day into account.

Monday: There is no previous day, so no moving average can be calculated.

Tuesday: $\bar{x}_2 = \frac{1}{3}(x_1 + x_2 + x_3) = \frac{1}{3}(53 + 77 + 68) = 66$

Wednesday: $\bar{x}_3 = \frac{1}{3}(x_2 + x_3 + x_4) = \frac{1}{3}(77 + 68 + 61) \approx 68.6$

Thursday: $\bar{x}_4 = \frac{1}{3}(x_3 + x_4 + x_5) = \frac{1}{3}(68 + 61 + 39) = 56$

Friday: $\bar{x}_5 = \frac{1}{3}(x_4 + x_5 + x_6) = \frac{1}{3}(61 + 39 + 21) \approx 40.3$

Saturday: $\bar{x}_6 = \frac{1}{3}(x_5 + x_6 + x_7) = \frac{1}{3}(39 + 21 + 19) = 79$

Sunday: There is no upcoming day, so no moving average can be calculated.
"""

# ╔═╡ 0d8b988e-f296-11ea-095a-d939b5a05c57
md"""
##### Median
Sometimes the arithmetic mean is not a very good representation of a *typical* value. We can see this in many examples, but a common one is the income distribution in the general population. Income distributions are typically not very *symmetric*, but skewed. There are a lot of people with low and medium incomes and a disproportionate number of people with very high incomes.

As an alternative we can use the **median**, which is defined as the value seperating the lower and upper half of the data. Calculating the median requires multiple steps:

1. Order the data from smallest value to greatest value,
2. Calculate the median from the ordered list  
    - If the number of elements in the ordered list is *odd*, take the middle value
    - If the number of elements in the ordered list is *even*, calculate the mean of the two values in the middle
    
Formally we can write

$\text{median}(x) = \frac{1}{2}(x_{\lfloor\frac{n+1}{2}\rfloor} + x_{\lceil\frac{n+1}{2}\rceil}).$

 $\lfloor \ldots \rfloor$ and $\lceil \ldots \rceil$ describe the [floor and ceiling functions](https://en.wikipedia.org/wiki/Floor_and_ceiling_functions). The floor function rounds down to the nearest integer while the ceiling function rounds up to the nearest integer.
"""

# ╔═╡ d643d080-f3ff-11ea-042f-9921a17fee31
some_number = 13.1

# ╔═╡ e1f855e0-f3ff-11ea-0ce5-a77606410b63
["floor" => floor(some_number), "ceiling" => ceil(some_number)]

# ╔═╡ 7fd6d900-f363-11ea-1f3a-0777dd89e0f2
md"""
We can again take a look at the stress level example to calculate the median stress level during the week.

First we sort the data in ascending order.

	19, 21, 39, 53, 61, 68, 77

Since the number of data points is odd, we can just take the middle value of the ordered list. The resulting median is $x_4 = 53$.

Alternatively we can use the mathematical formula to calculate the median.
To do this we first get the appropriate indizes for the $x$ values, $\frac{n + 1}{2} = \frac{7 + 1}{2} = 4$. It follows that $\lfloor 4 \rfloor = \lceil 4 \rceil = 4$. So the resulting median is,

$\text{median}(x) = \frac{1}{2}(x_4 + x_4) = \frac{1}{2}2x_4 = x_4 = 53.$

We can verify this result in software:
"""

# ╔═╡ 20403760-f364-11ea-1a71-93505276d665
md"The built-in software function `median` again gives us an identical result."

# ╔═╡ a3963520-f368-11ea-33ab-4b372a6cda2f
md"""
Since we now know how the median is calculated, we can see how it is different from the arithmetic mean. It **does not** take into account the numerical distance of the data points, but only their ordering. This has the conseqence that

1. The median is more *robust*, meaning that *outliers* do not have a large influence on the result,
2. It is appropriate for **ordinal data**.
"""

# ╔═╡ 3c716cc0-f40d-11ea-1f57-eb98d3ffe710
md"""
###### Example: [Outliers]

"""

# ╔═╡ de47e89e-f2ad-11ea-2614-6d7a298c0a97
md"""
###### Practical example: Calculating average grades 🎓

Often you will see people calculate the arithmetic mean of grades. With the information we have so far we know that this is in general not appropriate. Take for example the grading scheme of this course:

	90 < very good (1) <= 100
	75 < good (2) <= 90
	60 < satisfactory (3) <= 75
	50 < sufficient (4) <= 60
	0 < insufficient (5) <= 50

It is easy to see that some grade categories have a much wider range than others, so we should not simply calulate the mean of grades. Instead we notice that grades are obviosly ordered, from best to worst `1, 2, 3, 4, 5`.
"""

# ╔═╡ 707fbef0-f407-11ea-0ea4-8fa045ff2e48
grade_distribution = rand(Binomial(5, 0.65), 40)

# ╔═╡ 0fe249be-f40a-11ea-0f89-dfd75b97d6f7
n_grades = [sum(grade_distribution .== i) for i = 1:5]

# ╔═╡ be83d280-f407-11ea-19f2-0172b4c00335
bar(n_grades, color = "grey", legend = false)

# ╔═╡ 1c401200-f40b-11ea-3975-a928e58bd1ff
median(grade_distribution)

# ╔═╡ 924fa010-f2ac-11ea-04e3-af66e2d701ed
md"""
##### Mode
Another popular choice to describe a representative value of a dataset is the *sample mode*. It is the value of the sample which **appears most often**. For discrete data (e.g. student grades) we can find the mode by just counting the number of appearances and choosing the value which appears most often. 

If we take a look at the sample $x = [1, 1, 4, 5, 3, 3, 3]$ of student grades and their associated number of occurances,

| value | count |
| --- | --- |
1 | 2 |
3 | 3 |
4 | 1 |
5 | 1 |

we can easily see that the mode of the sample is 3. Again, we can verify this in software.
"""

# ╔═╡ 04000e8e-f413-11ea-2e84-b163bff47d27
student_grades = [1, 1, 4, 5, 3, 3, 3]

# ╔═╡ 48888ae0-f415-11ea-1b4b-ed36195e735e
maximum([sum(student_grades .== i) => i for i in unique(student_grades)])

# ╔═╡ 9250c980-f415-11ea-2c75-f118cd2a3ecf
md"or using built-in functionality:"

# ╔═╡ 80ae1632-f413-11ea-0264-9bb2a6cccafe
mode(student_grades)

# ╔═╡ aa0c24e0-f413-11ea-247e-6d5a99d65650
md"""
Since the mode does not use numerical information of the data, it is appropriate for *all types of data*, even nominal variables.

Note that for samples of continuous data the mode is not very useful, because the values will be generally *unique* (the number of occurances for each data point will be one). In practice one often bins the data to make them discrete and calculate the mode of the discretized sample data. We will see an example of this later when we take a look at the histogram.

In contrast to the mean and median, the mode is not always unique. Consider the data $x = [0, 1, 1, 0, 1, 0, 0, 1, 0, 1]$. Calculating the number of appearances here reveals that both 0 and 1 appear 5 times. We can then say that both 0 and 1 are modes. We call this type of data **bimodal**. If there exist more than 2 modes the data can be considered **multimodal**.
"""

# ╔═╡ 43d27250-f414-11ea-0e7b-d34d250faa7e
md"""
##### Comparing mean, median, and mode
"""

# ╔═╡ 9f7349f0-f369-11ea-2906-99c09958b9f7
md"""
#### Measures of variability
##### Sample variance and standard deviation

"""

# ╔═╡ 35fa82a0-f412-11ea-0881-17431c64d61d
md"""
##### Interquartile range 
##### Range

### Bivariate descriptive statistics
#### Frequency tables
#### Correlation
"""

# ╔═╡ b7618952-f2b0-11ea-14d9-5db7d9af0477
md"""
## Visualization

In this section we will visualize our student questionnaire data. In order for this to work paste the URL you received in the Moodle course in the following cell. 📑 Note that this is a security feature such that the data does not become publicly available.
"""

# ╔═╡ da29bb7e-f376-11ea-2b53-59a1390345fa
questionnaire_url = ""

# ╔═╡ e6f52f20-f376-11ea-3b55-757d3c970433
if (questionnaire_url == "")
	md"		Please paste the URL in the cell above!"

else 
	questionnaire_data = HTTP.get(questionnaire_url)
end

# ╔═╡ a192bba0-f376-11ea-1730-6d80d0d40230
md"""
### Univariate visualization
barchart, histogram, barchart, dotplot, boxplot & violinplot

Bsp: Handedness

### Bivariate visualization
linechart, scatterplot, 

### Trivariate visualization
heatmap, ... 

### practical considerations
color, ordering, highlighting, annotations, ...
"""

# ╔═╡ a4fbe942-f2b0-11ea-354f-63ea981d242a
md"""
## Computational resources
This section can be savely ignored...
"""

# ╔═╡ a2ad49e0-f2a6-11ea-1140-0d4a32e2c4f3
t = 1:7

# ╔═╡ a552a050-f2a6-11ea-3800-25fb2ad555ee
stress_level = [53.0, 77.0, 68.0, 61.0, 39.0, 21.0, 19.0]

# ╔═╡ f32e7a0e-f364-11ea-3d4b-cf4633717388
stress_level_ordered = sort(stress_level)

# ╔═╡ 5e753ed0-f365-11ea-19bd-e54562d00b8c
n_stress_level = length(stress_level_ordered)

# ╔═╡ 854a58b0-f365-11ea-1e6d-af04a3f77f1c
idx = [
	floor(Integer, (n_stress_level + 1)/2), 
	ceil(Integer, (n_stress_level + 1)/2)
]

# ╔═╡ b0f6c430-f365-11ea-20fc-f957295297e5
0.5 * (stress_level_ordered[idx[1]] + stress_level_ordered[idx[2]])

# ╔═╡ f3bb4630-f363-11ea-365b-d7ef73328544
median(stress_level)

# ╔═╡ 201a3d10-f299-11ea-2598-d7961ac8cf06
covid_data_url = "https://covid.ourworldindata.org/data/owid-covid-data.csv"

# ╔═╡ 22e8db80-f29b-11ea-14a4-830328be148a
res = HTTP.get(covid_data_url)

# ╔═╡ 62c805f0-f29b-11ea-2699-b99c6e6bd2fd
covid_data = DataFrame(CSV.File(res.body))

# ╔═╡ 05beed02-f29c-11ea-2860-51c3ebfd1158
at_idx = covid_data.location .== "Austria"

# ╔═╡ 315e1210-f29c-11ea-3cc2-35d8b6f16e36
covid_data_at = covid_data[at_idx,:]

# ╔═╡ f134c9d0-f29c-11ea-3197-053482b02068
date = covid_data_at.date

# ╔═╡ f73d2160-f29c-11ea-0659-977c5baf054f
cases = covid_data_at.new_cases

# ╔═╡ 1297ffc0-f29d-11ea-2def-e971ca81f763
function ma(x::Vector, n)
	back = div(n, 2)
	res = Vector{Union{Missing, Float64}}(missing, length(x))
	
	for i = (back + 1):(length(x) - back)
		res[i] = mean(x[(i - back):(i + back)])
	end
	
	return res
end

# ╔═╡ f15f54e0-f29f-11ea-2a87-2f684475fe66
begin
	p = plot(date, cases, xlabel = "Date", ylabel = "daily new cases", label = "raw data", color = "grey")
	
	if (display_trend)
		plot!(date, ma(cases, window), label = "moving average ($(window) days)", lw = 2)
	end
	
	p
end

# ╔═╡ ade43ad2-f2a6-11ea-1567-231151b869bc
begin
	plot(t, stress_level, label = "raw data", ylim = [0, 100], xlabel = "Day", ylabel = "stress level", color = "grey")
	plot!(t, ma(stress_level, 3), lw = 2, label = "moving average")
end

# ╔═╡ de4a4ce0-f29d-11ea-01c2-bbc82fa042c9
smoothed_cases = ma(cases, window)

# ╔═╡ Cell order:
# ╟─90992400-f28c-11ea-09c2-c7e9e2522724
# ╟─5723dca0-f28d-11ea-1195-a74c01361283
# ╠═440397c0-f290-11ea-3db5-8532bcb6723f
# ╠═863b5830-f290-11ea-21e0-2b0a8133925a
# ╟─4627d750-f290-11ea-0a38-09206ac4082c
# ╠═5cb878e0-f28f-11ea-3bad-195a7b79b7fe
# ╟─4673a2d0-f28f-11ea-33ec-ff59d41242c4
# ╠═14faec6e-f291-11ea-3ef7-99c8bf75eb0e
# ╟─7f4b7f70-f293-11ea-0944-810378f076d8
# ╠═9af65290-f293-11ea-0916-15f402e2f43a
# ╟─07c2bf30-f28f-11ea-01aa-51457d3ed6e3
# ╟─8c693c52-f294-11ea-2e30-d15bad950231
# ╠═1997dae0-f296-11ea-0dab-ddaa25a2ec82
# ╟─22863b60-f296-11ea-3b7c-1fdf27791ab7
# ╠═33901c02-f296-11ea-1965-4dc0fa850d8f
# ╟─10b45a60-f297-11ea-3ec6-89bbb6c0d54c
# ╠═4a048630-f299-11ea-3352-83c2eeae90f6
# ╠═4469a100-f29a-11ea-21d6-3f9c9fe7fa7c
# ╟─4c507c8e-f29a-11ea-253a-cd317776a579
# ╟─46fee750-f299-11ea-1e70-0dccb5db9034
# ╟─f15f54e0-f29f-11ea-2a87-2f684475fe66
# ╟─b0cab5c0-f2a2-11ea-3b86-8705da08a72f
# ╟─ade43ad2-f2a6-11ea-1567-231151b869bc
# ╟─bb0ecc20-f2ab-11ea-3699-6d4940be3151
# ╟─0d8b988e-f296-11ea-095a-d939b5a05c57
# ╠═d643d080-f3ff-11ea-042f-9921a17fee31
# ╠═e1f855e0-f3ff-11ea-0ce5-a77606410b63
# ╟─7fd6d900-f363-11ea-1f3a-0777dd89e0f2
# ╠═f32e7a0e-f364-11ea-3d4b-cf4633717388
# ╠═5e753ed0-f365-11ea-19bd-e54562d00b8c
# ╠═854a58b0-f365-11ea-1e6d-af04a3f77f1c
# ╠═b0f6c430-f365-11ea-20fc-f957295297e5
# ╟─20403760-f364-11ea-1a71-93505276d665
# ╠═f3bb4630-f363-11ea-365b-d7ef73328544
# ╟─a3963520-f368-11ea-33ab-4b372a6cda2f
# ╠═3c716cc0-f40d-11ea-1f57-eb98d3ffe710
# ╟─de47e89e-f2ad-11ea-2614-6d7a298c0a97
# ╟─707fbef0-f407-11ea-0ea4-8fa045ff2e48
# ╟─0fe249be-f40a-11ea-0f89-dfd75b97d6f7
# ╟─be83d280-f407-11ea-19f2-0172b4c00335
# ╠═1c401200-f40b-11ea-3975-a928e58bd1ff
# ╟─924fa010-f2ac-11ea-04e3-af66e2d701ed
# ╠═04000e8e-f413-11ea-2e84-b163bff47d27
# ╠═48888ae0-f415-11ea-1b4b-ed36195e735e
# ╟─9250c980-f415-11ea-2c75-f118cd2a3ecf
# ╠═80ae1632-f413-11ea-0264-9bb2a6cccafe
# ╠═aa0c24e0-f413-11ea-247e-6d5a99d65650
# ╠═43d27250-f414-11ea-0e7b-d34d250faa7e
# ╠═9f7349f0-f369-11ea-2906-99c09958b9f7
# ╠═35fa82a0-f412-11ea-0881-17431c64d61d
# ╠═b7618952-f2b0-11ea-14d9-5db7d9af0477
# ╠═da29bb7e-f376-11ea-2b53-59a1390345fa
# ╠═e6f52f20-f376-11ea-3b55-757d3c970433
# ╠═a192bba0-f376-11ea-1730-6d80d0d40230
# ╟─a4fbe942-f2b0-11ea-354f-63ea981d242a
# ╠═9342bc00-f293-11ea-3232-ad6b72c3c76e
# ╠═a2ad49e0-f2a6-11ea-1140-0d4a32e2c4f3
# ╠═a552a050-f2a6-11ea-3800-25fb2ad555ee
# ╠═f134c9d0-f29c-11ea-3197-053482b02068
# ╠═de4a4ce0-f29d-11ea-01c2-bbc82fa042c9
# ╠═f73d2160-f29c-11ea-0659-977c5baf054f
# ╠═201a3d10-f299-11ea-2598-d7961ac8cf06
# ╠═05beed02-f29c-11ea-2860-51c3ebfd1158
# ╠═22e8db80-f29b-11ea-14a4-830328be148a
# ╠═62c805f0-f29b-11ea-2699-b99c6e6bd2fd
# ╠═315e1210-f29c-11ea-3cc2-35d8b6f16e36
# ╠═1297ffc0-f29d-11ea-2def-e971ca81f763

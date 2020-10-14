### A Pluto.jl notebook ###
# v0.12.3

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
	Pkg.add("StatsPlots")
	using Distributions, StatsPlots, Plots, CSV, HTTP, DataFrames, PlutoUI, StatsBase 
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
The sample mean is probably the most important measure of central tendency. But when is it applicable? In general it is appropriate for all *quantitative* variables (interval and ratio scale), but as we will see later it might not be the best choice for some sample distributions.

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
But for now let us consider a practical example in time series analysis, the **simple moving average**. As an example we will use the time series of daily COVID-19 cases in Austria. From the following plot it is obvious there is a clear 'trend', but there is also a lot of variability from day to day (zig-zag-line). The moving average can help us to better visualize the trend in the data. 

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

As an alternative we can use the **median**, which is defined as the value seperating the lower and upper half of the sorted data. Calculating the median requires multiple steps:

1. Order the data from smallest value to greatest value,
2. Calculate the median from the ordered list  
    - If the number of elements in the ordered list is *odd*, take the middle value
    - If the number of elements in the ordered list is *even*, calculate the mean of the two values in the middle
    
Formally we can write the formula for the median as

$\text{median}(x) = \frac{1}{2}(x_{\lfloor\frac{n}{2} + 1\rfloor} + x_{\lceil\frac{n}{2}\rceil}).$

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

# ╔═╡ de47e89e-f2ad-11ea-2614-6d7a298c0a97
md"""
###### Practical example: Calculating average grades

Often you will see people calculate the arithmetic mean of grades. With the information we have so far we know that this is generally not appropriate. Take for example the grading scheme of this course:

	90 < very good (1) <= 100
	75 < good (2) <= 90
	60 < satisfactory (3) <= 75
	50 < sufficient (4) <= 60
	0 < insufficient (5) <= 50

It is easy to see that some grade categories have a much wider range than others, so we should not simply calulate the mean of grades. Instead we notice that grades are obviosly ordered, from best to worst, `1, 2, 3, 4, 5`.
"""

# ╔═╡ 707fbef0-f407-11ea-0ea4-8fa045ff2e48
grade_distribution = rand(Binomial(5, 0.65), 40)

# ╔═╡ 0fe249be-f40a-11ea-0f89-dfd75b97d6f7
n_grades = [sum(grade_distribution .== i) for i = 1:5]

# ╔═╡ 1c401200-f40b-11ea-3975-a928e58bd1ff
median(grade_distribution)

# ╔═╡ 7c9bc01a-0941-11eb-3980-11e52acd91d4
md"""
##### Quantiles
The median is actually a special case of a more general concept called *quantiles*. While the median splits the data in 2 equally sized parts, the number of splits is arbitrarily large when calculating quantiles. We call a $p$-quantile a quantile a fraction $p$ of the data values are below the quantile and a fraction $(1 - p)$ of the data is above the quantile. The calculation of a $p$-quantile is almost exactly the same as for the median, but requires different indizes for the data values.

To calculate the $k$-th $q$-quantile we can apply the following formula[^1],

$\mathrm{quantile}_p(x) = \frac{1}{2}(x_{\lfloor np + 1\rfloor} + x_{\lceil np \rceil}).$

If we choose $p = \frac{1}{2}$ we can see that the formula is identical to the formula for the median,

$\textrm{quantile}_\frac{1}{2} = \frac{1}{2}(x_{\lfloor \frac{n}{2} + 1\rfloor} + x_{\lceil \frac{n}{2} \rceil}) = \mathrm{median}(x).$

There are other are types of quantiles which are often used in statistics and thus have a special name. The most common ones are **quartiles** and **percentiles**.

**Quartiles**

Quartiles arise when we partition the data in four equally sized groups. The three cutpoints between the groups correspond exactly to the 0.25-quantile, 0.50-quantile and 0.75-quantile in the data. 

| p | quantile | name |
| --- | --- | --- |
| 0.25 | 0.25-quantile | lower quartile, first quartile |
| 0.50 | 0.50-quantile | median, second quartile |
| 0.75 | 0.75-quantile | upper quartile, third quartile |

Quartiles are used often when summarizing data or in visualizations (e.g. Boxplots). 

**Percentiles**

Similarly the data can be split into 100 groups equally sized groups. The resulting 99 cutpoints are then called percentiles. Accordingly the 33th-percentile would refer to the value of the data where 33% of the values are lower and 77% of the values are higher than the value in question. 

> 50th-percentile, second quartile, and median all refer to the same quantity!

"""

# ╔═╡ e5c920a0-0947-11eb-182d-25d00aa0f8d6
md"###### Example (cont.): COVID-19 cases in Austria"

# ╔═╡ 89eb7302-0951-11eb-066f-f70d638703e8
md"
Looking again at the daily new cases of COVID-19 in Austria we might be interested in learning what is the count of new cases, where only some percentage of days had lower or higher numbers respectively. Quantiles are a way to calculate this."

# ╔═╡ c5953532-0951-11eb-287e-b1337e4b67ee
md"percentile = $(@bind quantile_p Slider(1:99, default = 50, show_value = true))"

# ╔═╡ 967a7fee-0953-11eb-2147-7569b6ddb7dd
md"Below you can see a visual representation of the number of days with specific case counts and the $(quantile_p)th-percentile as a vertical line."

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
We have already seen that different measures of central tendency are appropriate for different data types. An important consideration when calculating summary statistics is also the **robustness** of the statistic. Robustness refers to the effect that some influential observations, so called **outliers**, can have on the value of a statistic. If outliers do not change the value of of the statistic much we call the statistic *robust*.

As can be seen in the following example, the median and mode are both more robust to outliers than the arithmetic mean. 
"""

# ╔═╡ 7f763402-0adc-11eb-29d5-dd8abb3358e9
md"Number of outliers: $(@bind n_outliers Slider(0:100, default = 0, show_value = true))"

# ╔═╡ 76aec958-0adf-11eb-034e-4b313e839e7b
@bind reset_samp_central_measures Button("Draw new sample")

# ╔═╡ 4cdc48e4-0adf-11eb-36b0-f51bb7442daf
begin
	reset_samp_central_measures
	comp_samp = rand(0:8, 100)
	comp_outliers = rand(20:30, 100)
end

# ╔═╡ 993fb1c8-0ae0-11eb-26e1-09c6d9c56c56
comp_samp2 = vcat(comp_samp, comp_outliers[1:n_outliers])

# ╔═╡ 895473e0-0ae0-11eb-1539-7d50f49627c3
md"""
mean = $(round(mean(comp_samp2), digits = 2))

median = $(round(median(comp_samp2), digits = 2))

mode = $(mode(comp_samp2))
"""

# ╔═╡ ac723432-0961-11eb-072c-4553a0367c7c
md"Additional statistics can give us a way to summarize our data more accurately. Measures of dispersion are designed to yield *numerical summaries of the spread* in the data."

# ╔═╡ 4df00304-0960-11eb-2dce-154e97940501
md"""
##### Sample variance and standard deviation
Arguably the most important and most used measure of dispersion is the sample *variance* defined as,  

$s^2 = \textrm{Var}(x) = \frac{1}{n} \sum_{i=1}^n (x_i - \bar{x})^2$

where $\bar{x}$ is the sample mean as discussed before. If you were to calculate the sample variance by hand you

1. calculate the sample mean $\bar{x}$,
2. substract the mean from each data value and square the result,
3. add the calculated differences from step 2,
4. divide the result from step 3 by the sample size $n$.

Revisiting the example of weekly stress levels, we first calculate the mean stress level
"""

# ╔═╡ d319c416-0a0a-11eb-1240-6504a7af9d4c
md"Then calculating the squared differences,"

# ╔═╡ f455956a-0a0a-11eb-0daa-c51cafa64abe
md"Third sum up the squared differences,"

# ╔═╡ 04cb8760-0a0b-11eb-0d2a-c5877454edcc
md"and finally divide by the number of data points"

# ╔═╡ 885a5466-0965-11eb-0a60-c3b42582ca7e
md"Obviously, today's software provide us with convenient shortcuts to calculate such statistics."

# ╔═╡ dac13df0-0965-11eb-01ba-574409793961
md"""
>⚠️ Some software will calculate the variance with $(n - 1)$ instead of $n$! 
>
> In **Excel** `VAR.P` divides by $n$ and `VAR.S` divides by $(n - 1)$. 
>
> In **Julia** `var(..., corrected = false)` divides by $n$ and `var(...)` divides by $(n - 1)$.
>
> **SPSS** will typically divide by $(n - 1)$. 
"""

# ╔═╡ c670251e-0967-11eb-0e8e-1f92d8d67d62
md"""
**A note on measurement units**

At a first glance it is not really clear what the results for the variance mean and how to interpret them. The reason is that the unit of measurement is the square of the original unit itself. If we we have a data set with height measurements in `cm`, the variance of the measurements are in `cm²`. Similarly, the units of measurement for the variance of `stress level` is `(stress level)²` - not very intuitive.

To make the dispersion of the data more interpretable, we transform the variance back to the original measurement unit by taking the square root,

"""

# ╔═╡ 1a4b5234-0964-11eb-3335-314b48ccc1d4
md"""
$s = \sqrt{s^2} = \sqrt{\frac{1}{n} \sum_{i=1}^n (x_i - \bar{x})^2}.$

The result $s$ is called the sample **standard deviation**. Since it is on the same measurement scale as the original data it has a natural interpretation: It is the *average distance* of all data points from the mean. Just like the variance a low standard deviation indicates low dispersion, and a high standard deviation indicates high dispersion in the data. 
"""

# ╔═╡ d1569288-0971-11eb-326d-7d0b76b16531
md"""
Both variance and standard deviation involve the calculation of means and differences and are therefore applicable to *quantitative* data only (interval and ratio scale). 
"""

# ╔═╡ 35fa82a0-f412-11ea-0881-17431c64d61d
md"""
##### Interquartile range 
When we do not operate with interval or ratio scale data, but ordinal scale data or we want a more robust measure of dispersion we can calculate the *interquartile range* (IQR). It is defined as the distance between the upper and the lower quantile,

$\mathrm{IQR}(x) = \mathrm{quantile}_{0.75}(x) - \mathrm{quantile}_{0.25}(x).$

To calculate the interquartile range simply calculate the first and third quartile and take the difference.

For the daily COVID-19 cases in Austria the interquartile range is calculated as follows:
"""

# ╔═╡ 84e2b79e-0974-11eb-0237-b905b6a79354
md"""
The interquartile range is not only applied when we cannot use variances or standard deviation, but also has important applications in visualization. We will revisit the interquartile range when we discuss it as an integral component of boxplots. 
"""

# ╔═╡ a1642908-0962-11eb-31b3-d7eba2ba44a1
md"""
##### Range
Another way to summarize the dispersion in the data is to calulate the *range*. The range is just the difference between the highest and the lowest value in the data. 

$\mathrm{range}(x) = \mathrm{maximum}(x) - \mathrm{minimum}(x)$

The range does not carry as much information as variances or the interquartile range and is therefore seldom used on its own. Calculating the range can be useful if we do not have a lot of data or in addition to other measures of dispersion. Because the range only does take into account two values (the minimum and the maximum) in the data, it is **highly sensitive to outliers**. 

Consider a datasset of daily steps, $x = [6618, 6981, 7073, 6799, 6901]$. Here the range would be $\mathrm{range}(x) = 7073 - 6618 = 455$. If we ran a half-marathon the next day we would observe a step count of $x_6 = 29813$. Then the calculated range of the data is $(29813 - 6618)!

"""

# ╔═╡ c3fd0eda-096e-11eb-256f-3d5b41d6f26d
md"##### Comparing measures of dispersion"

# ╔═╡ dc0b73cc-096e-11eb-2d04-8bb36496a381
md"dispersion: $(@bind dispersion Slider(0.5:0.1:5, default = 2))"

# ╔═╡ 80e71700-096f-11eb-1775-a74924dcfc5b
md"""measure of dispersion:  $(@bind dispersion_fn Select(["std" => "standard deviation", "iqr" => "interquartile range", "range" => "range"]))"""

# ╔═╡ 47b02778-0970-11eb-06f2-ad5732bba06d
	dispersion_sample = rand(Normal(0, dispersion), 10000)

# ╔═╡ 9142b718-0970-11eb-2065-49b60bb3c927
md"""
standard deviation: $(round(std(dispersion_sample), digits = 2))

interquartile range: $(round(iqr(dispersion_sample), digits = 2))

range: $(round(maximum(dispersion_sample) - minimum(dispersion_sample), digits = 2))
"""

# ╔═╡ 4ca727b2-0a0e-11eb-17f5-bfba4e817b5b
md"#### Summary statistics in software"

# ╔═╡ 66c467a6-0a0e-11eb-008b-7fd0a7c78317
md"""
Most statistical software provide a high-level interface for calculating a variety of descriptive measures.

In `R` a variable can be described by the `summary()` function, which gives the following output.

![](https://github.com/p-gw/statistics-fh-wien/blob/master/notebooks/img/r_summary.png?raw=true)

Similarly, `Julia` provides the `describe()` function with an output like this.

![](https://github.com/p-gw/statistics-fh-wien/blob/master/notebooks/img/julia_describe.png?raw=true)

In `SPSS` summary statistics of one or multiple variables can be calculated under 

1. `Analyze -> Descriptive Statistics -> Frequencies...`, or 
2. `Analyze -> Descriptive Statistics -> Descriptives...` or
3. `Analyze -> Descriptive Statistics -> Explore...`
 

Additional options are available via `statistics...` and `options...` dialog fields if you chose `Frequencies...` or `Descriptives...` respectively. They yield outputs similar to this, 

![]()
![]()
"""

# ╔═╡ f826acc2-0962-11eb-3097-c56a039ab88b
md"""
### Bivariate descriptive statistics


#### Contingency tables
A *contingency table* or *cross tabulation* is a statistical method to display the **frequency distribution** of two (or more) variables. Contingency tables contain the count of each variable combination as well as the marginal sums, and total sum. 

As an example we can look at a 2x2 contingency table of the variables $a$ and $b$: 

| a \ b | b1 | b2 | total |
| --- | --- | --- | --- |
| **a1** 	 | $n_{11}$ | $n_{12}$ | $n_{1.}$ |
| **a2** | $n_{21}$ | $n_{22}$ | $n_{2.}$ |
| **total**	 | $n_{.1}$ | $n_{.2}$ | $n_{..}$ |

The cell frequencies $n_{ij}$ refer to the frequency of the variable combination $a = i$ and $b = j$. To get the marginal frequencies $n_{.j}$ or $n_{i.}$, which reflect the count of $a = i$ over all categories of $b$ or the count of $b = j$ over all categories of $a$, we can sum the elements in each row or column. 

For examplewe can calculate the marginal sum of **a2**: $n_{2.} = \sum_{i=1}^2 n_{2i} = n_{21} + n_{22}$. 
"""

# ╔═╡ 6d94738a-0bc6-11eb-1d20-ad56eeb7c69c
md"""
Often it can be helpful to not display the counts, but the relative frequency of the category combinations. The relative frequency of a cell can be calculated by dividing the count by the total count,

$r_{ij} = \frac{n_{ij}}{n_{..}}.$

In the example below we can see the contingency table for the variables *sex* and *handedness* for a hypothetical sample of $n_{..} = 100$ persons. 

| sex \ handedness | right-handed | left-handed | total |
| --- | --- | --- | --- |
| **male** 	 | 43 | 9 | 52 |
| **female** | 44 | 4 | 48 |
| **total**	 | 87 | 13 | 100 |

As can be seen, the marginal sums are just calculated by summing up each row or column of the table respectively. To get a contingency table with relative frequencies we just divide every entry in the table by the grand total.

| sex \ handedness | right-handed | left-handed | total |
| --- | --- | --- | --- |
| **male** 	 | 0.43 | 0.09 | 0.52 |
| **female** | 0.44 | 0.04 | 0.48 |
| **total**	 | 0.87 | 0.13 | 1.00 |


In spreadsheet software contingency tables are sometimes called **pivot tables**.
"""

# ╔═╡ 9f21ea74-0bce-11eb-0c1e-4751876c9048
md"""
#### Covariance and correlation
To measure the amount of **linear association** between to variables $x$ and $y$ one can calculate the sample *covariance* with the formula,

$s_{xy} = \frac{1}{n}\sum_{i=1}^n(x_i - \bar{x})(y_i - \bar{y}).$

The formula for the covariance is similar to the formula for the variance. Instead of taking the squared differences from the mean $(x_i - \bar{x})^2$, we substitute the expression $(x_i -\bar{x})(y_i - \bar{y})$. In fact the variance of a variable is mathematically identical to the covariance of the variable with itself, 

$s_{xx} = \frac{1}{n}\sum_{i=1}^n (x_i - \bar{x})(x_i - \bar{x}) = \frac{1}{n}\sum_{i=1}^n (x_i - \bar{x})^2 = s^2_x.$

Since there is no quadratic expression in the general form of the covariance for two different variables, the covariance can also take negative values. The interpretation for the covariance are, 

- if the covariance is (approximately) zero, there is *no linear association* between the two variables, 
- if the covariance is positive, there is a *positive linear association* between the two variables, i.e. greater values in one variable correspond with greater values in the other variable. Similarly lower values in one variable correspond with lower values in the other variable. 
- if the covariance is negative, there is a *negative linear association* between the two variables. Then, greater values in one variables correspond with lower values in the other variable and vice versa. 

To calculate the covariance by hand we can more or less follow the procedure for the variance, 

1. calculate the means of variable $x$ ($\bar{x}$) and $y$ ($\bar{y}$),
2. For each data point $(x, y)$ calculate the differences from the means $(x_i - \bar{x})$ and $(y_i - \bar{y})$ and multiply them,
3. Add the differences from step 2 for all data points, 
4. Divide the summed differences from step 3 by $n$. 

[add example here]

> ⚠️ As is the case for the variance, the covariance is sometimes calculated by dividing by $(n - 1)$ instead of $n$!

The covariance suffers from similar issues with interpretation as the variance. It is not clear how to interpret a covariance of $s_{xy} = 432.48$, except that there exist a positive linear relationship between the variables $x$ and $y$. The problem is again that of measurement units. The measurement units for the covariance is the unit of $x$ muliplied by the unit of $y$. If we were to calculate the covariance of *height* in `cm` and *weight* in `kg`, the measurement unit would be `cm⋅kg`. 
"""

# ╔═╡ de123994-0c72-11eb-1199-4b44601c6162
height_cm = [168, 189, 202, 158, 189, 177]

# ╔═╡ f53b87f4-0c72-11eb-017c-876b8df9a68d
weight_kg = [54, 90, 102, 64, 86, 73]

# ╔═╡ 14559b84-0c73-11eb-2e17-633ccb1efa1f
cov(height_cm, weight_kg, corrected = false)

# ╔═╡ 3f02ca00-0c73-11eb-38ac-853b1b585765
md"""

If we instead calculate the covariance of height in `m` and weight in `kg` the value of the covariance differs altough the strength of association clearly stays the same.
"""

# ╔═╡ edd4df2e-0c72-11eb-2695-3354a89f508b
height_m = height_cm / 100

# ╔═╡ 283f2ef8-0c73-11eb-0a0e-fd55f5afffd8
cov(height_m, weight_kg, corrected = false)

# ╔═╡ d8e4347a-0c72-11eb-224e-ff9a66b0038d
md"""


To get a more interpretable measure of linear association we *remove the measurement units* and make the covariance **dimensionless**. We can do this by dividing the covariance by the standard deviations $s_x$ and $s_y$,

$r_{xy} = \frac{s_{xy}}{s_x s_y}.$

This result is the **correlation coefficient** of the variables $x$ and $y$. It is in the range $-1 \leq r_{xy} \leq 1$ and the amount refers to the *strength of linear association*,

- if the correlation coefficient is (approximately) zero, there is no linear relationship between the variables $x$ and $y$,
- if the correlation coefficient is positive, there is a positive linear relationship between the variables $x$ and $y$. A correlation coefficient of +1 indicates a perfect positive linear relationship in the data. 
- if the correlation coefficient is negative, there is a negative linear relationship between the variables $x$ and $y$. A correlation coefficient of -1 indicates a perfect negative linear relationship in the data.
"""

# ╔═╡ 7a4cb48c-0c77-11eb-0927-99af49aebd27
md"Examples of data with different correlation coefficients can be seen in the following graph."

# ╔═╡ 0add59a4-0c71-11eb-2e52-afe45281d698
md"![](https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/Correlation_examples2.svg/1280px-Correlation_examples2.svg.png)"

# ╔═╡ 7c9ed00e-0c73-11eb-1bd6-c714889309bb
md"Taking a look again at the association of height and weight, we can see that the correlation coefficient is the same *regardless of the units of measurement* and that there is clearly a strong positive relationship in the data."

# ╔═╡ 9a13c55e-0c73-11eb-122f-914637426a2d
cor(height_cm, weight_kg)

# ╔═╡ a66446ce-0c73-11eb-31b1-3de03014ccd8
cor(height_m, weight_kg)

# ╔═╡ 04b1c4ac-0c71-11eb-00f4-b5d60b0b65aa
md"""
The correlation coefficient is a very widely utilized concept in statistics and it is important to get a feeling of the strength of association a correlation coefficient implies. To train your understanding in a playful way you can try games such as [guess the correlation](http://guessthecorrelation.com/). Feel free to share your high scores on Moodle!
"""

# ╔═╡ b7618952-f2b0-11ea-14d9-5db7d9af0477
md"""
## Visualization

Visualization of data, descriptive statistics and statistical models is a vital part in the statistical workflow. Graphs can provide you with information which remain hidden when just calculating summary statistics. Often you will find that graphs reveal outliers or implausible values.  

While graphs are essential when exploring the data before or during statistical analysis, they can also be used to great effect in the communication of results. We will see in the next section different types of statistical graphs as well as visualization techniques and see when it is appropriate to use them.

In modern news reporting the use of graphics is also heavily emphasized. These types of visualizations do not necessarily follow the guidelines provided here, but are sometimes effectively employed for communication. You can find examples of these so called *infographics* on the website of [The New York Times](https://www.nytimes.com/column/whats-going-on-in-this-graph).

"""

# ╔═╡ abdf03e4-0a22-11eb-309a-dbc06caa769d
md"As is often the case there are many different ways to classify visualization types. We will take a look at the different types depending on the *number of variables* they take into account."

# ╔═╡ 01725c66-0bb3-11eb-007b-29dc4d762c92
md">⚠️ This is not an exhaustive list of statistical charts! If you are interested in visualization you might want to take a look at additional resources such as [The R Graph Gallery](https://www.r-graph-gallery.com/)."

# ╔═╡ a192bba0-f376-11ea-1730-6d80d0d40230
md"""
### Univariate visualizations
Which type of visualization you use for a single variable can depend on the scale of the variable itself. For quantitative variables 

###### Histograms
Histograms are appropriate to visualize a quantitative variable (interval or ratio scale). Histograms are used to (approximately) represent the distribution of the variable by discretizing or **binning** the data. Binning refers to the grouping of the variable in consecutive and non-overlapping intervals. The choice of size and number of bins are up to the researcher. 

Typically, we construct *bins of equal width* and count the number of values within each interval. 
"""

# ╔═╡ c19a1e26-0a2c-11eb-34bf-69109ac871f4
md"""
Under these circumstances, the height of the bin is proportional to the number of cases. However, this is *not* always the case. We may also construct *bins of unequal width* like this,
"""

# ╔═╡ 83a82e56-0a30-11eb-1a37-0558a2b1ff03
md"""
When using unequal bin sizes, the *area of the bin* is proportional to the number of cases. The height of each bin is then calculated by weighting the count $n_i$ in an interval by the bin width, 

$\mathrm{binheight}_i = \frac{\mathrm{minimum}(\mathrm{binwidth})}{\mathrm{binwidth}_i} \cdot n_i$

In the example above the adjusted bin widths are, 

| interval | count | bin width | bin height |
| --- | --- | --- | --- |
| [164, 169] | 22 | 6 | 7.33 |
| [170, 171] | 27 | 2 | 27 |
| [172, 173] | 30 | 2 | 30 |
| [174, 179] | 21 | 6 | 7 |
"""

# ╔═╡ 24694086-0a32-11eb-3128-a55e4331a041
md"""
Histograms can give us a lot of useful information about the distribution of the data. 
By using histograms we can recognize for outliers in the data, skewness of the distribution or multimodality.  

Distribution type: $(@bind dist_type Select(["symmetric", "skewed", "outlier", "multimodal"]))
$(@bind new_hist Button("Draw new sample"))
"""

# ╔═╡ ddf392f8-0a33-11eb-195d-4f9c619ba973
md"number of bins: $(@bind hist_bins Slider(4:60, default = 30))"

# ╔═╡ b255d4a0-0a3b-11eb-19e4-5f81a36d0c2a
md"""
###### Boxplots

Another way to visualize the distribution of a quantitative variable is the *boxplot*. Instead of plotting the grouped raw data, the boxplot makes use of descriptive statistics based on ordinal data. It displays the quartiles (lower quartile, median, and upper quartile) as the box. The so called *whiskers* extend beyond the box on both ends to the minimum and maximum values in the data. If there are values lower or higher than ±1.5 times the interquartile range in the data, the whiskers extend to this range and more extreme points are classified as outliers.  

![](https://lsc.studysixsigma.com/wp-content/uploads/sites/6/2015/12/1435.png)

The boxplot, just like the histogram, can give us information about the shape of a distribution. 

A more modern variant of the boxplot is the **violin plot**. Instead of displaying summary statistics, which can hide information in the data, the violin plot shows the whole distribution by a procedure called *kernel density estimation*.

Plot type: $(@bind box_or_violin Select(["box" => "boxplot", "violin" => "violin plot"]))

Distribution type: $(@bind dist_type_boxplot Select(["symmetric", "skewed", "outlier", "multimodal"]))

$(@bind new_boxplot Button("Draw new sample"))
"""

# ╔═╡ 8830ed10-0bb0-11eb-3db5-75446e0e1800
begin
  # ... boxplot code goes here
end

# ╔═╡ c6b0cb88-0a24-11eb-1038-f3e2c51046fd
md"""
###### Bar charts
For categorical data *bar charts* are a very common choice of visualization. They can be used to display category counts or relative frequencies of nominal and ordinal data. 
"""

# ╔═╡ 1c241ffc-0bb5-11eb-2db8-5db5af80efe6
md"> ⚠️ For bar charts the y-axis should (almost) always start at zero! Cutting the y axis exaggerates differences between categories."

# ╔═╡ a273bd94-0ae1-11eb-10e1-77148844eb4b
md"""
###### Pie charts
Pie charts, similar to bar charts, are used to depict counts or relative frequencies of categorical data. Although they show the same informatin, bar charts are superior to pie charts, because the comparison of categories is easier in bar charts than in pie charts. The reason for this is that the information in a bar chart is encoded by the *length* of the bars, whereas for pie charts the information is encoded in the *angle* of the arc. It is generally recognized that the human perception is more accurate for lengths than it is for angles, making bar charts easier to interpret than pie charts. This is not necessarily an issue if the number of categories is small, but becomes clearly apparent for a larger number of categories. 
"""

# ╔═╡ 24920adc-0ae3-11eb-3814-b37214b2ba5a
md"""Type of chart: $(@bind chart_type Select(["pie" => "pie chart", "bar" => "bar chart"]))"""

# ╔═╡ 5d42b098-0ae3-11eb-171e-cd55fc477eb9
md"""Number of categories: $(@bind n_categories Slider(2:16, default = 4, show_value = true))"""

# ╔═╡ 4c30819e-0977-11eb-2c60-698f3c520dca
md"
### Bivariate visualization"

# ╔═╡ 547a2746-0c66-11eb-2d71-6f8f713d156d
md"""
###### Scatter plots
Scatter plots are used to visualize the association between two variables. In a scatter plot the data are displayed as a collection of points. Each point in a scatter plot describes a combination $(x_i, y_i)$ of an observation along the variables $x$ and $y$. 
"""

# ╔═╡ 7630c57a-0c66-11eb-3f3e-3fe917936422
md"""
###### Line chart
A linechart in principle is similar to a scatter plot and displays as it also displays observations as combinations $(x_i, y_i)$ of the variables $x$ and $y$. The difference is that instead of plotting points for each observation, a line is used to connect the observations. 
"""

# ╔═╡ 7fac255e-0e4e-11eb-0248-b92772c59a51
md"""From the graph above it is obvious that a scatter plot is preferrable to a line chart for this data.

Line charts are typically used when the variable on the x-axis is *ordered*. This is the case in **time series analysis** where the x-axis displays *time* (e.g. in days). Then a line chart may look like the COVID-19 example below. 
"""

# ╔═╡ 971088e6-0e4f-11eb-3f88-c18531461c2e
md"Sometimes it can be useful to display both points and lines if the x-axis is ordered but the measurement intervals are not equal and number of measurements is small."

# ╔═╡ ad5b0f9c-0bb2-11eb-37b9-0f430e1cdf0c
md"""
### multivariate visualization
- 3D plots

- coloring

- facetting


"""

# ╔═╡ ffc57e6a-0bb3-11eb-1e74-ebd0938a6c93
md"""
### General design principles
Creating good graphics requires a lot of thought. Not only do you have to think about which type of visualization is appropriate for your application, but also about graphical design. While guidelines for graphical design (such as this) are often highly opinionated, they can still give you valuable information.

###### Color 
The choice of colors in your graphics is a very important one. Good color design can make your graph more appealing to look at and attract attention of the viewer. 

On the most basic level you have to consider your color palette. There are three types of palettes available: *sequential*, *diverging* and *qualitative*. 

**Sequential color palette**
"""

# ╔═╡ 9bb34a48-0ad4-11eb-0ff0-33d64271d5ed
md"""
Sequential color palettes are used for unipolar continuous data. In the discrete case, you can use sequential color palettes if your data has a natural ordering (ordinal scale). 
"""

# ╔═╡ eee785fe-0ad0-11eb-15d9-d1209968d6c6
cgrad(:Blues_7)

# ╔═╡ 3e1c844e-0ad1-11eb-1b3a-4d7096d5deca
palette(:Blues_7)

# ╔═╡ 0b58b14a-0ad1-11eb-063d-fdc02aa2757f
md"""
**Diverging color palette**

Similarly, diverging color palettes are used for bipolar continuous or discrete data when there is some neutral middle value.  
"""

# ╔═╡ 159cf422-0ad1-11eb-1a94-bbeeef526166
cgrad(:BrBG_7)

# ╔═╡ 5ddef906-0ad1-11eb-0274-a9068c7befaf
palette(:BrBG_7)

# ╔═╡ 7e2cfa50-0ad1-11eb-114e-0981e4b75aaf
md"""
**Qualitative color palettes**

Qualitative scales should generally not be used for continuous data. They can be used to great effect however if you want to distinguish between categories that cannot be ordered (nominal scale data). 
"""

# ╔═╡ 83e2a828-0ad1-11eb-03c9-bf14dca140f8
cgrad(:Set1_7)

# ╔═╡ 9517cb64-0ad1-11eb-346b-5f90ef4a63bd
palette(:Set1_7)

# ╔═╡ b15bac50-0ad1-11eb-0a95-f3b9469c1122
md"""
About 5% of the general population have some form of **colorblindness**.  The most common form is *red-green colorblindness*, which affects approxmately 8% of males and 0.4% of females. Accordingly, one has to take care to avoid ambiguity of the graphic when it is viewed by a person affected by colorblindness. Although there exist many colorblindness friendly color palettes, a lot of software still defaults to unsave color scales. A very common example for this is the *jet* color scale often used in heatmaps. Jet is a qualitative continuous color palette with blue, green, yellow and red which makes it very difficult for people with colorblindness to distinguish between the associated variable values.
"""

# ╔═╡ eee98c5a-0ad0-11eb-1096-052897ea9764
md"""
###### Ordering
Ordering of categories is natural for ordinal data. For ordinal data it is advisable to keep the original order of the data. In communicating results for nominal scale data it can often be helpful to order categories based on their count or value in the graph, especially when the number of categories is large.
"""

# ╔═╡ 4a04545c-0ae1-11eb-3055-cdb33e3613b2
md"## Summary"

# ╔═╡ 42a3954a-0944-11eb-08dc-f9ab89ebf48c
md"### Footnotes"

# ╔═╡ 4979d942-0944-11eb-03f1-f1a8db8c4a25
md"[^1]: Note that there are different ways to calculate quantiles in practice. The results you get from software might differ slightly from the formula presented here."

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

# ╔═╡ 54c8f8da-0964-11eb-1129-ddb2e44d6f7c
mean_stress_level = mean(stress_level)

# ╔═╡ 5ab741d4-0964-11eb-020a-4fceed9f2f86
stress_level_differences = (stress_level .- mean_stress_level).^2

# ╔═╡ 7b9679b2-0964-11eb-2a93-d38c6f5178d4
summed_stress_level_difference = sum(stress_level_differences)

# ╔═╡ 5ad5a178-0965-11eb-0ffe-fb2920aa1278
s² = summed_stress_level_difference/7

# ╔═╡ 7536302c-0a0b-11eb-24c0-c9220b13b793
s = √s²

# ╔═╡ 453a209e-0971-11eb-2a3e-d93a7f2e6b08
md"For the weekly stress level example we find a sample standard deviation of $(round(s, digits = 2)), which means that on average the observed stress level is $(round(s, digits = 2)) points from the mean stress level of $(round(mean_stress_level, digits = 2))."

# ╔═╡ b292e8f8-0965-11eb-244b-d349c1f860e6
var(stress_level, corrected = false)

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

# ╔═╡ 453ccc7e-0974-11eb-075f-bb6d221f1031
first_quartile = quantile(cases, 0.25)

# ╔═╡ 4e84d60a-0974-11eb-37ec-b70cbc458b7d
third_quartile = quantile(cases, 0.75)

# ╔═╡ 542057ee-0974-11eb-3d20-07f94775e7c3
iqr_covid_cases = third_quartile - first_quartile

# ╔═╡ 1297ffc0-f29d-11ea-2def-e971ca81f763
function ma(x::Vector, n)
	back = div(n, 2)
	res = Vector{Union{Missing, Float64}}(missing, length(x))
	
	for i = (back + 1):(length(x) - back)
		res[i] = mean(x[(i - back):(i + back)])
	end
	
	return res
end

# ╔═╡ de4a4ce0-f29d-11ea-01c2-bbc82fa042c9
smoothed_cases = ma(cases, window)

# ╔═╡ 06554d18-0953-11eb-2717-11b101378f11
begin
	if quantile_p == 50
		extra_text = "The 50th-percentile is equivalent to the second quartile and the median."
	elseif quantile_p == 25
		extra_text = "The 25th-percentile is equivalent to the lower quartile."
	elseif quantile_p == 75
		extra_text = "The 75th-percentile is equivalent to the upper quartile."
	else
		extra_text = ""
	end
end

# ╔═╡ a795d090-0952-11eb-3f56-990a80ccfbbf
md"
The $(quantile_p)th-percentile of daily new COVID-19 cases in Austria is $(quantile_res = round(quantile(cases, quantile_p/100), digits = 2)). This means that $(quantile_p)% of days (since 1.1.2020) had fewer cases than $quantile_res. $extra_text 
"

# ╔═╡ 634bf79c-0a34-11eb-00a3-9f33ec8b0700
md"### Markdown functions"

# ╔═╡ 04235eba-0956-11eb-3327-4bb93baa3b9c
function two_columns(l, r, w = [50, 50])
	html_l = Markdown.html(l)
	html_r = Markdown.html(r)
	res = """
	<div style='display: flex'>
		<div style='width: $(w[1])%'>$(html_l)</div>
		<div style='width: $(w[2])%'>$(html_r)</div>	
	</div>
	"""
	HTML(res)
end

# ╔═╡ 545bde62-0a13-11eb-3357-09a21e8e609d
colors = ["#ef476f","#ffd166","#06d6a0","#118ab2","#073b4c"]

# ╔═╡ 9af65290-f293-11ea-0916-15f402e2f43a
histogram(heights, bins = 8, legend = false, xlabel = "height (cm)", color = colors[4], linecolor = "white", ylabel = "count")

# ╔═╡ f15f54e0-f29f-11ea-2a87-2f684475fe66
begin
	p = plot(date, cases, xlabel = "Date", ylabel = "daily new cases", label = "raw data", color = "grey", alpha = 0.75, legend = :topleft)
	
	if (display_trend)
		plot!(date, ma(cases, window), label = "moving average ($(window) days)", lw = 2, color = colors[1])
	end
	
	p
end

# ╔═╡ 0825ea52-0e4f-11eb-0014-ef73a3767f8c
plot(p)

# ╔═╡ ade43ad2-f2a6-11ea-1567-231151b869bc
begin
	plot(t, stress_level, label = "raw data", ylim = [0, 100], xlabel = "Day", ylabel = "stress level", color = "grey", alpha = 0.75)
	plot!(t, ma(stress_level, 3), lw = 2, label = "moving average", color = colors[1])
end

# ╔═╡ be83d280-f407-11ea-19f2-0172b4c00335
grades_barchart = bar(n_grades, color = colors[4], linecolor = "white", legend = false)

# ╔═╡ 0980a2ce-0bb2-11eb-30d1-a13dc7d983a4
begin
	plot(grades_barchart)
	plot!(ylabel = "count", xlabel = "grade", xticks = (1:5, ["very good", "good", "satisfactory", "sufficient", "insufficient"]))
end

# ╔═╡ 6ecdb8f2-094a-11eb-0bf2-4d35f6d36386
begin
	histogram(cases, legend = false, color = colors[4], linecolor = "white")
	vline!([quantile_res], color = colors[1], lw = 2, xlabel = "daily cases", ylabel = "number of days")
end

# ╔═╡ 540f7ac6-0960-11eb-23eb-2f2dcb0caecc
begin
	samp1 = rand(Normal(0, 1), 10000)
	samp2 = rand(Normal(0, 10), 10000)
	
	p1 = histogram(samp1, xlimits = [-30, 30], legend = false, yaxis = false, title = "dataset 1", color = colors[3], linecolor = colors[3])
	p2 = histogram(samp2, xlimits = [-30, 30], legend = false, yaxis = false, title = "dataset 2", color = colors[3], linecolor = colors[3])
	
	plot(p1, p2)
	plot!(size = (600, 250))
end

# ╔═╡ 9f7349f0-f369-11ea-2906-99c09958b9f7
md"""
#### Measures of variability
As data summaries measures of central tendency are immensly helpful, but do not give us the full picture. While clearly different, the following datasets have approximately the same mean and median. 

dataset 1: mean = $(round(mean(samp1), digits = 2)), median = $(round(median(samp1), digits = 2))

dataset 2: mean = $(round(mean(samp2), digits = 2)), median = $(round(median(samp2), digits = 2))

"""

# ╔═╡ eff5d196-096e-11eb-1ff6-898e0a0e23c7
begin

	histogram(dispersion_sample, xlimits = [-20, 20], yaxis = false, label = "data", legend = false, color = colors[4], linecolor = colors[4])
	if dispersion_fn == "std"
		tmp_std = std(dispersion_sample)
		vline!([-tmp_std, tmp_std], color = colors[1], lw = 2)
	elseif dispersion_fn == "iqr"
		tmp_iqr = quantile(dispersion_sample, [0.25, 0.75])
		vline!(tmp_iqr, color = colors[1], lw = 2)
	elseif dispersion_fn == "range"
		vline!([minimum(dispersion_sample), maximum(dispersion_sample)], color = colors[1], lw = 2)
	end
end

# ╔═╡ 988d7ac6-0e4d-11eb-3e3a-e7a09e9a3b79
begin
	scatter_x = randn(100)
	scatter_y = scatter_x * 0.6 .+ randn(100)
	plot(scatter_x, scatter_y, seriestype = :scatter, legend = false, xlabel = "x", ylabel = "y", color = colors[1], xlimit = [-3, 3], ylimit = [-3, 3], size = (350, 350))
end

# ╔═╡ 63bc5b54-0e4e-11eb-019e-5530d2fff0b4
plot(scatter_x, scatter_y, xlimit = [-3, 3], ylimit = [-3, 3], size = (350, 350), legend = false, ylabel = "y", xlabel = "x", color = colors[1], lw = 1)

# ╔═╡ bb97b08e-0e4f-11eb-361f-7facd7a24a4b
begin
	scatterline_x = rand(0:100, 20)
	scatterline_y = scatterline_x .* .005 .+ randn(20) * 0.05
	plot(scatterline_x, scatterline_y, seriestype = [:line, :scatter], color = colors[1], legend = false, xlabel = "time", ylabel = "y")
end

# ╔═╡ 621e3680-0a13-11eb-0d2c-716ab3c5b8cc
center(x) = HTML("<div style='text-align: center'>$(Markdown.html(x))</div>")

# ╔═╡ aa820244-0a31-11eb-3227-4319ffbfee3f
center(md"> 🙋 In practice unequal bin widths are not very commonly used.")

# ╔═╡ 715d9296-0a34-11eb-2cab-f92abf389adf
md"### Histogram section"

# ╔═╡ 62f20d38-0a2d-11eb-0420-3117a73e66b6
bins_unequal = [164, 170, 172, 174]

# ╔═╡ be498a9e-0a2d-11eb-08fc-e3873e049230
bin_counts_unequal = [22, 27, 30, 21]

# ╔═╡ d7f6c8b2-0a2d-11eb-2b40-9f9fde607e19
hist_data_unequal = vcat([fill(bins_unequal[i], bin_counts_unequal[i]) for i = 1:length(bins_unequal)]...)

# ╔═╡ b91a5e3a-0a2e-11eb-02c4-0b6a82872ab2
hist_weights_unequal = vcat([fill([1/3, 1, 1, 1/3][i], bin_counts_unequal[i]) for i = 1:length(bins_unequal)]...)

# ╔═╡ c5a93a1e-0a2d-11eb-2a0e-f34ec1802fd6
hist_fit_unequal = fit(Histogram, hist_data_unequal, weights(hist_weights_unequal), vcat(bins_unequal, 180))

# ╔═╡ 4712d4f8-0a2d-11eb-373d-efdd34f16d90
two_columns(md"""
| interval | count | 
| --- | --- |
| [164, 169] | 22 |
| [170, 171] | 27 |
| [172, 173] | 30 |
| [174, 179] | 21 |
""", md"""
$(plot(hist_fit_unequal, xticks = 164:2:180, xlabel = "height", ylabel = "count", legend = false, color = colors[3], linecolor = "white", size = (450, 270)))	
""", [30, 70])

# ╔═╡ 704f2aa6-0a2d-11eb-3c18-dde7982f9022
hist_weights_unequal

# ╔═╡ 75d3e116-0a29-11eb-2f3b-ad43200b5439
bins_equal = [164, 166, 168, 170, 172, 174, 176, 178]

# ╔═╡ 8b128bca-0a29-11eb-1c20-3f4f7f0846d6
bin_counts_equal = [4, 8, 10, 27, 30, 10, 6, 5]

# ╔═╡ 65869778-0a2b-11eb-0d72-c7dadec81128
hist_data_equal = vcat([fill(bins_equal[i], bin_counts_equal[i]) for i = 1:length(bins_equal)]...)

# ╔═╡ a0c85eaa-0a32-11eb-30c6-f5007ac90d82
begin
	new_hist
	if dist_type == "symmetric"
		hist_data = randn(10000)
	elseif dist_type == "skewed"
		hist_data = rand(Chisq(5), 10000)
	elseif dist_type == "outlier"
		hist_data = rand(MixtureModel([Normal(0, 1), Normal(5, 0.25)], [0.975, 0.025]), 10000)
	elseif dist_type == "multimodal"
		hist_data = rand(MixtureModel([Normal(0, 1), Normal(4, 1)], [0.5, 0.5]), 1000)
	end

end

# ╔═╡ 1ade20b6-0a34-11eb-39cb-71bad9338abc
histogram(hist_data, bins = hist_bins, color = colors[3], linecolor = "white", normalize = true, legend = false, yaxis = false)

# ╔═╡ be736df2-0a2b-11eb-1a74-91c70ee7031c
hist_fit_equal = fit(Histogram, hist_data_equal, vcat(bins_equal, 180))

# ╔═╡ a78e5f92-0a2c-11eb-1ee9-d1ebd3f97e1f
two_columns(md"""
| interval | count | 
| --- | --- |
| [164, 165] | 4  |
| [166, 167] | 8  |
| [168, 169] | 10 |
| [170, 171] | 27 |
| [172, 173] | 30 |
| [174, 175] | 10 |
| [176, 177] | 6  |
| [178, 179] | 5  |
""", md"""
$(plot(hist_fit_equal, xticks = 164:2:180, xlabel = "height", ylabel = "count", legend = false, color = colors[3], linecolor = "white", size = (450, 270)))
""", [30, 70])

# ╔═╡ 0e6ff122-0adb-11eb-3aed-2796b3f888dc
md"### General considerations"

# ╔═╡ 92feba54-0ad6-11eb-28b6-459e318f3e73
begin
	large_cat_bar = counts(rand(1:15, 500))
	alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
	large_bar_data = [alphabet[1:15], large_cat_bar]
	sort_idx = sortperm(large_bar_data[2])
	large_bar_data_ordered = [alphabet[sort_idx], large_cat_bar[sort_idx]]
end

# ╔═╡ 8b24ffe8-0ae3-11eb-1648-d18d4ad0a9da
begin
	pie_categories = alphabet[1:n_categories]
	pie_values_tmp = randn(n_categories)
	pie_values = exp.(pie_values_tmp) ./ sum(exp.(pie_values_tmp))
	
	if chart_type == "pie"
		pie(pie_categories, pie_values, linecolor = "white")
	elseif chart_type == "bar"
		bar(pie_categories, pie_values, color = colors[4], linecolor = "white")
	end
end

# ╔═╡ 85d9bfd6-0ad6-11eb-3050-c51baeaef20f
two_columns(md"""
**ordered by name (default)**
	
$(bar(reverse(large_bar_data[1]), reverse(large_bar_data[2]), orientation = :h, size = (250, 500), legend = false, axis = false, xticks = false, color = colors[4], linecolor = "white"))
""", md"""
**ordered by value**
	
$(bar(large_bar_data_ordered[1], large_bar_data_ordered[2], orientation = :h, size = (250, 500), legend = false, axis = false, xticks = false, color = colors[4], linecolor = "white"))
""")

# ╔═╡ 1f6a5b28-0ad3-11eb-25ba-d591c439bf8d
surf_f(x,y) = x^2 + y^2

# ╔═╡ 1aa5a278-0ad3-11eb-1724-f1140e309e9e
two_columns(md"""
**color scale: jet**
	
$(plot(-10:10, -10:10, surf_f, linetype=:surface, c = :jet, axis = false, legend = false, size = [300, 200], ticks = []))""",
md"""
**color scale: viridis**
	
$(plot(-10:10, -10:10, surf_f, linetype=:surface, c = :viridis, axis = false, legend = false, size = [300, 200], ticks = []))"""
)

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
# ╟─9af65290-f293-11ea-0916-15f402e2f43a
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
# ╟─de47e89e-f2ad-11ea-2614-6d7a298c0a97
# ╟─707fbef0-f407-11ea-0ea4-8fa045ff2e48
# ╟─0fe249be-f40a-11ea-0f89-dfd75b97d6f7
# ╠═be83d280-f407-11ea-19f2-0172b4c00335
# ╠═1c401200-f40b-11ea-3975-a928e58bd1ff
# ╟─7c9bc01a-0941-11eb-3980-11e52acd91d4
# ╟─e5c920a0-0947-11eb-182d-25d00aa0f8d6
# ╟─89eb7302-0951-11eb-066f-f70d638703e8
# ╟─c5953532-0951-11eb-287e-b1337e4b67ee
# ╟─a795d090-0952-11eb-3f56-990a80ccfbbf
# ╟─967a7fee-0953-11eb-2147-7569b6ddb7dd
# ╟─6ecdb8f2-094a-11eb-0bf2-4d35f6d36386
# ╟─924fa010-f2ac-11ea-04e3-af66e2d701ed
# ╠═04000e8e-f413-11ea-2e84-b163bff47d27
# ╠═48888ae0-f415-11ea-1b4b-ed36195e735e
# ╟─9250c980-f415-11ea-2c75-f118cd2a3ecf
# ╠═80ae1632-f413-11ea-0264-9bb2a6cccafe
# ╟─aa0c24e0-f413-11ea-247e-6d5a99d65650
# ╟─43d27250-f414-11ea-0e7b-d34d250faa7e
# ╟─7f763402-0adc-11eb-29d5-dd8abb3358e9
# ╟─76aec958-0adf-11eb-034e-4b313e839e7b
# ╟─895473e0-0ae0-11eb-1539-7d50f49627c3
# ╟─993fb1c8-0ae0-11eb-26e1-09c6d9c56c56
# ╟─4cdc48e4-0adf-11eb-36b0-f51bb7442daf
# ╟─9f7349f0-f369-11ea-2906-99c09958b9f7
# ╟─540f7ac6-0960-11eb-23eb-2f2dcb0caecc
# ╟─ac723432-0961-11eb-072c-4553a0367c7c
# ╟─4df00304-0960-11eb-2dce-154e97940501
# ╠═54c8f8da-0964-11eb-1129-ddb2e44d6f7c
# ╟─d319c416-0a0a-11eb-1240-6504a7af9d4c
# ╠═5ab741d4-0964-11eb-020a-4fceed9f2f86
# ╟─f455956a-0a0a-11eb-0daa-c51cafa64abe
# ╠═7b9679b2-0964-11eb-2a93-d38c6f5178d4
# ╟─04cb8760-0a0b-11eb-0d2a-c5877454edcc
# ╠═5ad5a178-0965-11eb-0ffe-fb2920aa1278
# ╟─885a5466-0965-11eb-0a60-c3b42582ca7e
# ╠═b292e8f8-0965-11eb-244b-d349c1f860e6
# ╟─dac13df0-0965-11eb-01ba-574409793961
# ╟─c670251e-0967-11eb-0e8e-1f92d8d67d62
# ╟─1a4b5234-0964-11eb-3335-314b48ccc1d4
# ╠═7536302c-0a0b-11eb-24c0-c9220b13b793
# ╟─453a209e-0971-11eb-2a3e-d93a7f2e6b08
# ╟─d1569288-0971-11eb-326d-7d0b76b16531
# ╟─35fa82a0-f412-11ea-0881-17431c64d61d
# ╠═453ccc7e-0974-11eb-075f-bb6d221f1031
# ╠═4e84d60a-0974-11eb-37ec-b70cbc458b7d
# ╠═542057ee-0974-11eb-3d20-07f94775e7c3
# ╟─84e2b79e-0974-11eb-0237-b905b6a79354
# ╟─a1642908-0962-11eb-31b3-d7eba2ba44a1
# ╟─c3fd0eda-096e-11eb-256f-3d5b41d6f26d
# ╟─dc0b73cc-096e-11eb-2d04-8bb36496a381
# ╟─9142b718-0970-11eb-2065-49b60bb3c927
# ╟─80e71700-096f-11eb-1775-a74924dcfc5b
# ╟─eff5d196-096e-11eb-1ff6-898e0a0e23c7
# ╟─47b02778-0970-11eb-06f2-ad5732bba06d
# ╟─4ca727b2-0a0e-11eb-17f5-bfba4e817b5b
# ╟─66c467a6-0a0e-11eb-008b-7fd0a7c78317
# ╟─f826acc2-0962-11eb-3097-c56a039ab88b
# ╟─6d94738a-0bc6-11eb-1d20-ad56eeb7c69c
# ╟─9f21ea74-0bce-11eb-0c1e-4751876c9048
# ╠═de123994-0c72-11eb-1199-4b44601c6162
# ╠═f53b87f4-0c72-11eb-017c-876b8df9a68d
# ╠═14559b84-0c73-11eb-2e17-633ccb1efa1f
# ╟─3f02ca00-0c73-11eb-38ac-853b1b585765
# ╠═edd4df2e-0c72-11eb-2695-3354a89f508b
# ╠═283f2ef8-0c73-11eb-0a0e-fd55f5afffd8
# ╟─d8e4347a-0c72-11eb-224e-ff9a66b0038d
# ╟─7a4cb48c-0c77-11eb-0927-99af49aebd27
# ╟─0add59a4-0c71-11eb-2e52-afe45281d698
# ╟─7c9ed00e-0c73-11eb-1bd6-c714889309bb
# ╠═9a13c55e-0c73-11eb-122f-914637426a2d
# ╠═a66446ce-0c73-11eb-31b1-3de03014ccd8
# ╟─04b1c4ac-0c71-11eb-00f4-b5d60b0b65aa
# ╟─b7618952-f2b0-11ea-14d9-5db7d9af0477
# ╟─abdf03e4-0a22-11eb-309a-dbc06caa769d
# ╟─01725c66-0bb3-11eb-007b-29dc4d762c92
# ╟─a192bba0-f376-11ea-1730-6d80d0d40230
# ╟─a78e5f92-0a2c-11eb-1ee9-d1ebd3f97e1f
# ╟─c19a1e26-0a2c-11eb-34bf-69109ac871f4
# ╟─4712d4f8-0a2d-11eb-373d-efdd34f16d90
# ╟─83a82e56-0a30-11eb-1a37-0558a2b1ff03
# ╟─aa820244-0a31-11eb-3227-4319ffbfee3f
# ╟─24694086-0a32-11eb-3128-a55e4331a041
# ╟─ddf392f8-0a33-11eb-195d-4f9c619ba973
# ╟─1ade20b6-0a34-11eb-39cb-71bad9338abc
# ╟─b255d4a0-0a3b-11eb-19e4-5f81a36d0c2a
# ╠═8830ed10-0bb0-11eb-3db5-75446e0e1800
# ╟─c6b0cb88-0a24-11eb-1038-f3e2c51046fd
# ╟─0980a2ce-0bb2-11eb-30d1-a13dc7d983a4
# ╟─1c241ffc-0bb5-11eb-2db8-5db5af80efe6
# ╟─a273bd94-0ae1-11eb-10e1-77148844eb4b
# ╟─24920adc-0ae3-11eb-3814-b37214b2ba5a
# ╟─5d42b098-0ae3-11eb-171e-cd55fc477eb9
# ╟─8b24ffe8-0ae3-11eb-1648-d18d4ad0a9da
# ╠═4c30819e-0977-11eb-2c60-698f3c520dca
# ╟─547a2746-0c66-11eb-2d71-6f8f713d156d
# ╟─988d7ac6-0e4d-11eb-3e3a-e7a09e9a3b79
# ╟─7630c57a-0c66-11eb-3f3e-3fe917936422
# ╠═63bc5b54-0e4e-11eb-019e-5530d2fff0b4
# ╟─7fac255e-0e4e-11eb-0248-b92772c59a51
# ╟─0825ea52-0e4f-11eb-0014-ef73a3767f8c
# ╟─971088e6-0e4f-11eb-3f88-c18531461c2e
# ╟─bb97b08e-0e4f-11eb-361f-7facd7a24a4b
# ╟─ad5b0f9c-0bb2-11eb-37b9-0f430e1cdf0c
# ╟─ffc57e6a-0bb3-11eb-1e74-ebd0938a6c93
# ╟─9bb34a48-0ad4-11eb-0ff0-33d64271d5ed
# ╟─eee785fe-0ad0-11eb-15d9-d1209968d6c6
# ╟─3e1c844e-0ad1-11eb-1b3a-4d7096d5deca
# ╟─0b58b14a-0ad1-11eb-063d-fdc02aa2757f
# ╟─159cf422-0ad1-11eb-1a94-bbeeef526166
# ╟─5ddef906-0ad1-11eb-0274-a9068c7befaf
# ╟─7e2cfa50-0ad1-11eb-114e-0981e4b75aaf
# ╟─83e2a828-0ad1-11eb-03c9-bf14dca140f8
# ╟─9517cb64-0ad1-11eb-346b-5f90ef4a63bd
# ╟─b15bac50-0ad1-11eb-0a95-f3b9469c1122
# ╟─1aa5a278-0ad3-11eb-1724-f1140e309e9e
# ╟─eee98c5a-0ad0-11eb-1096-052897ea9764
# ╟─85d9bfd6-0ad6-11eb-3050-c51baeaef20f
# ╟─4a04545c-0ae1-11eb-3055-cdb33e3613b2
# ╟─42a3954a-0944-11eb-08dc-f9ab89ebf48c
# ╟─4979d942-0944-11eb-03f1-f1a8db8c4a25
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
# ╟─06554d18-0953-11eb-2717-11b101378f11
# ╟─634bf79c-0a34-11eb-00a3-9f33ec8b0700
# ╠═04235eba-0956-11eb-3327-4bb93baa3b9c
# ╠═545bde62-0a13-11eb-3357-09a21e8e609d
# ╠═621e3680-0a13-11eb-0d2c-716ab3c5b8cc
# ╠═715d9296-0a34-11eb-2cab-f92abf389adf
# ╠═62f20d38-0a2d-11eb-0420-3117a73e66b6
# ╠═be498a9e-0a2d-11eb-08fc-e3873e049230
# ╠═d7f6c8b2-0a2d-11eb-2b40-9f9fde607e19
# ╠═b91a5e3a-0a2e-11eb-02c4-0b6a82872ab2
# ╠═c5a93a1e-0a2d-11eb-2a0e-f34ec1802fd6
# ╠═704f2aa6-0a2d-11eb-3c18-dde7982f9022
# ╠═75d3e116-0a29-11eb-2f3b-ad43200b5439
# ╠═8b128bca-0a29-11eb-1c20-3f4f7f0846d6
# ╠═65869778-0a2b-11eb-0d72-c7dadec81128
# ╟─a0c85eaa-0a32-11eb-30c6-f5007ac90d82
# ╠═be736df2-0a2b-11eb-1a74-91c70ee7031c
# ╟─0e6ff122-0adb-11eb-3aed-2796b3f888dc
# ╟─92feba54-0ad6-11eb-28b6-459e318f3e73
# ╟─1f6a5b28-0ad3-11eb-25ba-d591c439bf8d

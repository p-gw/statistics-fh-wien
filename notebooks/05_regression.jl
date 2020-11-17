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

# ╔═╡ d68ae886-2326-11eb-12ac-2f963f78e691
begin
	using Pkg
	Pkg.add("CSV")
	Pkg.add("HTTP")
	Pkg.add("DataFrames")
	Pkg.add("Plots")
	Pkg.add("GLM")
	Pkg.add("PlutoUI")
	Pkg.add("Distributions")
	Pkg.add("StatsBase")
	using CSV, HTTP, DataFrames, Plots, GLM, PlutoUI, Statistics, Distributions, StatsBase
end

# ╔═╡ b6d87880-f437-11ea-11ed-29b755ee68bb
md"# Linear regression"

# ╔═╡ 415f55c2-28b4-11eb-02c1-a3c491710f9c
md"""
In the previous lectures we have seen how to calculate descriptive statistics, visualize data and how to estimate parameters for simple statistical models. Now it is time to turn our attention to the first 'real' statistical model - *linear regression*. 

In this lecture we will first revisit the topic of correlation, i.e. the association between two variables and discuss the intricacies of correlation when it comes to causation. Afterwards we will spend the remaining lecture on simple linear regression where we care to explain a variable by a single predictor. We are going to cover the basics of linear regression and it's interpretation as a line through data, the **estimation of parameters**, and different ways of how to **predict new values**. We will also see how to **evaluate the model** and what can be done if the goodness of fit is insufficient. Finally, the concepts of the lecture are applied to two real world examples. 

"""

# ╔═╡ 0eb284c0-2326-11eb-39fe-5799689586a3
md"""
## Revisiting correlation & causation
In the lesson on descriptive statistics & visualization we have already seen some methods to evaluate the association between two variables, most notably the *correlation coefficient*. With the correlation coefficient it is possible to describe the amount of linear association (magnitude) between two variables as well as the direction of the association (sign). We did not, however, discuss *causality* for associations. Since correlation analysis and simple linear regression are closely related to each other, now is the time to consider the aspects of causal interpretation of correlation. In statistics there is the famous saying,
"""

# ╔═╡ 162fca24-2726-11eb-06c7-89832fc51da3
md"""
which means that only because we observe an association between two variables this does *not* indicate a special causal relation between them. """

# ╔═╡ 84de7b14-28b6-11eb-36f7-0d099321b53b
md"""
In theory there are various ways in which variables like in the example above might be causally related. 
"""

# ╔═╡ 591d1f6c-2726-11eb-1b36-2d2a58183130
md"""The two most obvious forms of causation is that either the first variable causes the second ($X \rightarrow Y$) or vice versa ($X \leftarrow Y$). In these two examples, whatever the causal direction the correlation coefficient will give the same numeric answer. The data alone will not tell us about the causal direction.

More complicated forms of causation exist that require the introduction of a third variable, $Z$. This variable is said to be a **mediatior** if it is in the middle of the causation chain, $X \rightarrow Z \rightarrow Y$. $Z$ can also be a **common cause** of both $X$ and $Y$ we can write $X \leftarrow Z \rightarrow Y$.  

If we do not properly account for the third variable or **confounder** $Z$, then our statistical analysis will be biased and give us the wrong answers. With correlation analysis alone, we cannot consider a third variable and must thus turn to more advanced methods. Extensions of linear regression (multiple linear regression) can incorporate confounding factors and are therefore the preferred method to handle these more complex cases.

But what happens if we analyze the data without consideration for confounding factors? This can lead to a phenomenon called **spurious correlation** (in correlation analysis) or **Simpson's paradox** (in regression analysis). They both describe the same phenomenon: If we do not accurately account for confounding factors, we might observe no association between variables or a even an association in the opposite direction!

We can find many bizarre spurious correlations in the real world, such as a almost perfect correlation between death by entanglement in the bedsheets and the per capita cheese consumption.
"""

# ╔═╡ 864912b6-28b6-11eb-171e-178f58f0571b
html"""<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Stop eating cheese. <br>That&#39;s just freakin awesome! <a href="https://twitter.com/hashtag/datascience?src=hash&amp;ref_src=twsrc%5Etfw">#datascience</a> <a href="https://twitter.com/hashtag/spuriouscorrelations?src=hash&amp;ref_src=twsrc%5Etfw">#spuriouscorrelations</a> <a href="https://t.co/Am2QhT86S7">https://t.co/Am2QhT86S7</a> <a href="https://t.co/XcvmdGR3H0">pic.twitter.com/XcvmdGR3H0</a></p>&mdash; Der Stylepapst (@Stylepapst) <a href="https://twitter.com/Stylepapst/status/668984993599893512?ref_src=twsrc%5Etfw">November 24, 2015</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>"""

# ╔═╡ 3b912ef6-272c-11eb-09d2-13a9187db87d
md"""include confounder: $(@bind unconfound CheckBox())"""

# ╔═╡ 03c7c1cc-272e-11eb-0fec-8fd790a91765
md"""
As can be seen from this hypothetical example it is extremely important to properly account for all confounding variables in our analysis to arrive at the correct solution. In statistical practice this introduces a major problem: The confounding factors are often not measured, not measurable or even completely unknown. One must rely on their expert knowledge in the domain of analysis to make sure the statistical analysis is sensible. 

In the previous example we have seen that somewhat more complicated statistical methods (multiple regression) are required to properly analyze data with confounding. First, however, we must learn the regression techniques that serve as a basis for all of these extensions - *simple linear regression*.

> If you are interested in learning more about Simpson's paradox in real world applications you can start with [this article](https://towardsdatascience.com/gender-bias-in-admission-statistics-the-simpson-paradox-cd381d994b16).

"""

# ╔═╡ 2ee8496e-2326-11eb-3674-45135868a7fc
md"""## Linear regression with a single predictor"""

# ╔═╡ 0a032cc0-233c-11eb-230a-e1c4fcbd2ca2
md"""show regression line: $(@bind heights_show_line CheckBox())"""

# ╔═╡ 9d1bbbe2-2339-11eb-0037-87d1668c36b9
md"""show prediction: $(@bind height_prediction CheckBox())"""

# ╔═╡ c57c1366-2339-11eb-38c7-8d3b7c5b9d9d
md"""mother's height: $(@bind mother_height_prediction Slider(120:.1:200, default = 165, show_value = true))"""

# ╔═╡ 283d523a-2335-11eb-3738-017a69191b5d
md"""

As could be seen from the example, the goals of linear regression are multi-facetted. Using this method we can **explore associations** in the data: We can summarize how well one (or multiple) variables explain an outcome. For example, the question *do people get more conservative with increasing age?* can be answered by a simple linear regression with *age* as the predictor for *conservativeness*. Linear regression also allows us to make **predictions** or forecasts for future data. If we fit a regression model that estimates a persons *height* by their *handspan* for example, and observe the handspan of other people, we can use the regression model to predict the height of these people based on their handspan. Lastly, regression models can be employed for **causal inference**, i.e. estimating a causal effect under certain circumstances. The most common example of this is to estimate the difference between an experimental and a control group of an experiment. 


"""

# ╔═╡ 3f1bd86a-233e-11eb-1f94-35e880f5b201
md"""
In the following sections we will see how simple linear regression looks from a mathematical perspective, how we can estimate the parameters and their confidence intervals, make predictions and see how we can evaluate regression models and determine how well the model fits the data. Finally we will look at different types of applications and possible extensions to simple linear regression. 
"""

# ╔═╡ 8b337fe2-23ec-11eb-2711-7df12b02955b
md"### Theoretical basics"

# ╔═╡ 2a059362-233e-11eb-0531-f5119e1b9840
md"""
#### It all starts with a line
From a purely mathematical standpoint simple linear regression is just a straight line. Remember from high school that the equation for a straight line is given by, 

$f(x) = a + b\cdot x.$

The parameters of the line, $a$ and $b$ are called the **intercept** and **slope** respectively. The intercept tells us about the y-axis value $f(x)$ when $x = 0$, since

$f(0) = a + b \cdot 0 = a.$

The slope on the other hand tells us about the relationship between the values on the x-axis and the values on the y-axis. For simplicity lets assume $a = 0$ such that 

$f(x) = b\cdot x.$

If the slope is zero, $b = 0$, then there is no relationship between the values $f(x)$ and $x$. Whatever the value $x$, the y-axis value $f(x)$ will be zero, 

$f(x) = b\cdot x = 0\cdot x = 0.$

If there is a positive slope, $b > 0$, then there is a positive relationship between the function values $f(x)$ and $x$. The higher values in the variable $x$ will coincide with higher values in the outcome $f(x)$. The higher the value for $b$, the *steeper* the slope. 

In the case of a negative slope, $b < 0$, the relationship between $x$ and $f(x)$ is inverted, i.e. there is a negative relationship between the two variables. For high values of $x$ the values of $f(x)$ will be low and vice versa. 

We can also interpret the slope of a line in the following way: If we increase the value $x$ by one, the value $f(x)$ will change by $b$. 

$f(x + 1) - f(x) = (a + b\cdot(x+1)) - (a + b\cdot x) = a + b\cdot x + b - a - b\cdot x = b$ 

> ⚠️ This property will be important when interpreting linear regression for real data!

To conclude the mathematical description of simple lines we can take a look at a visualization.
"""

# ╔═╡ ace02510-2341-11eb-04dd-8774a0690252
md"""a = $(@bind basic_line_a Slider(2.5:.01:7.5, default = 2.5, show_value = true))"""

# ╔═╡ c5e5c4b8-2341-11eb-18ed-e701cf6dbe55
md"""b = $(@bind basic_line_b Slider(-2.5:.01:2.5, default = 1, show_value = true))"""

# ╔═╡ a42f64e0-2345-11eb-1afb-f7b0ca2382a8
md"""
#### Estimation of parameters
When using a linear model in the application of linear regression, the parameters of the line equation $a$ and $b$ are unknown and have to be estimated from data. What is known, however, is our sampled data. The predictor or independent variable are treated as the $x$ values in the equation for the line, and the outcome or dependent variable $y$ are treatead as the $f(x)$ values. In contrast to the theoretical line there are also some things to note: 

1. We typically observe not one but many sampling units $n$,
2. The data will not all fall on the line, but will have some *error* associated with it. 

With these two things in mind we can write the regression equation as, 

$y_i = a + b\cdot x_i + u_i, \qquad i = 1, \ldots, n$

Here, the outcome $y_i$ of sampling unit $i$ is given by

1. The unknown intercept $a$,
2. The predictor value $x_i$ mulitplied by the slope $b$, 
3. An error term $u_i$ containing the difference between the expected value and the observed value. 

Since we only observe the value pairs $(x_i, y_i)$ all other quantities $(a, b, u_i)$ are unknown. *So, how can we estimate the best values for our parameters?* From the following plot it becomes clear that some parameter values fit the data much better than others.
"""

# ╔═╡ bac8437e-234b-11eb-2523-e58a100d3980
@bind parest_optimize Button("Optimize!")

# ╔═╡ 180a8e4c-234d-11eb-3972-c58875c62060
md"""It's pretty obvious that we want to make the **smallest possible error** in total. They way to accomplish this for linear regression is a method called **least squares**, where seek to minimize the sum of squared errors $S$,

$S = \sum_{i=1}^n u_i^2$

Rearranging the initial formula for regression tells us that $u_i = y_i - a - b\cdot x_i$, so 

$S = \sum_{i=1}^n (y_i - a - b\cdot x_i)^2.$

This shows us that the sum of squared errors depends only on the unknown parameter values $a$, and $b$. We can get the parameter values that minimize this squared error by calculating the partial derivatives of the expression above. Technical detail will be omitted here, but the resulting estimates for the regression line parameters can be derived as, 

$\hat{a} = \bar{y} - \hat{b}\cdot \bar{x}, \qquad \hat{b} = \frac{\hat{\sigma}_{xy}}{\hat{\sigma}^2_x}$

Here, $\bar{x}$ and $\bar{y}$ are the sample mean of the $x$ and $y$ variable respectively, $\hat{\sigma}_{xy}$ is the estimate for the covariance between $x$ and $y$, and $\hat{\sigma}^2_x$ is the estimate for the variance of $x$. 

> ⚠️ Note the similarity between the formula for the regression slope and the correlation coefficient,
> $r_{xy} = \frac{\hat{\sigma}_{xy}}{\hat{\sigma}_{x}\hat{\sigma}_{y}}$. 
> In fact, the correlation coefficient and the regression slope will be identical if both variables $x$ and $y$ are standardized (all standard deviations are 1)!

Assuming a normal model for these parameters, which can arise by assuming a normal distribution for the errors, we can also construct confidence intervals for the parameters of the regression equation to quantify the uncertainty of the estimate. The $(1 - \alpha)$ confidence interval for $b$ is given by, 

$\hat{b} \pm Q(1 - \frac{\alpha}{2}, n - 2) se_{\hat{b}}, \qquad se_{\hat{b}} = \sqrt{\frac{\frac{S}{n-2}}{\sum_{i=1}^n (x_i - \bar{x})^2}}$

Where $Q(p, n)$ is the quantile of the T distribution with $n$ degrees of freedom and $se_{\hat{b}}$ the standard error of the estimate. Similarly, we can construct the confidence interval for $a$ by, 

$\hat{a} \pm Q(1 - \frac{\alpha}{2}, n - 2)se_{\hat{a}}, \qquad se_{\hat{a}} = se_{\hat{b}} \sqrt{\frac{1}{n}\sum_{i=1}^n x_i^2}$
"""

# ╔═╡ 2adf4664-235e-11eb-03fa-1d404ef0c77c
md"""
As an exercise, we can apply these formulas to the simulated data above. First we can calculate the point estimates $\hat{a}$ and $\hat{b}$. Because the estimate of b is needed for the calculation of $\hat{a}$, we calculate $\hat{b}$ first,
"""

# ╔═╡ fd21bb96-235e-11eb-125f-4319e7644194
md"Then continue with our estimate for $\hat{a}$,"

# ╔═╡ 1d497244-235f-11eb-3a2b-23e92f7dfd0c
md"To address uncertainty in the estimates let us calculate the confidence intervalls as well. For our intervals we choose a coverage probability of 80%. Again we start with the confidence interval for $\hat{b}$ and calculate the associated standard error," 

# ╔═╡ 01669c8c-2364-11eb-1b4d-e131b071ad1c
α = 0.2

# ╔═╡ 729169f6-28bb-11eb-188e-a118f5baa5d9
md"and finish the calculation of the confidence interval by applying the formula above."

# ╔═╡ 84c0024a-28bb-11eb-31e5-c39d6af6e1c4
md"For $\hat{a}$ we can procede in the same way,"

# ╔═╡ 12fd1b62-2367-11eb-2e6e-cd1944643366
md"""α = $(@bind confidence_band_α Slider(.01:.01:.99, default = .05, show_value = true))"""

# ╔═╡ 52c796a8-2369-11eb-29d5-a97593bd2c73
md"""
The confidence band includes both the uncertainty of $\hat{a}$ and $\hat{b}$ and always features a special *bowtie shape*. This shape tells us that the estimates are more accurate in the center where we have a lot of data and less accurate where there is less data.
"""

# ╔═╡ 2960c9c0-235e-11eb-1059-7f8b56a0c657
md"""
#### Predicting new values
So far we have seen how to infer the parameters of a regression line and their associated confidence intervals. Estimating parameters, however, is not the ultimate goal of linear regression. What we usually want to do is to predict new values. For this we typically observe new $x$ values, which we henceforth denote as $x_{\text{new}}$ and want to predict the outcome $y_\text{new}$ based on these values. This prediction can take three different forms, 

1. Prediction of the best estimate for the outcome $y_\text{new}$, 
2. Prediction of the uncertainty for the best estimate (confidence interval),
3. Prediction of the uncertainty for new sampling units (prediction interval).

Note that 1. and 2. are both concerned with predicting an *average value* given the new predictor values $x_\text{new}$ and the goal of 3. is to predict the plausible range for *new observations* given the new predictor values $x_\text{new}$. 

This is best illustrated by example, 
"""

# ╔═╡ ab7edd7c-23e3-11eb-366c-294c5c1cd3e2
md"""prediction type: $(@bind prediction_type Select(["none" => "best estimate", "ci" => "confidence interval", "pi" => "prediction interval"])) """

# ╔═╡ 27b21b34-23e4-11eb-2150-0bc92a230ff2
md"""α = $(@bind prediction_band_α Slider(.01:.01:.99, default = .05, show_value = true))"""

# ╔═╡ c86b8556-23e4-11eb-0870-6115617fef9a
md"""xnew = $(@bind x_pred Slider(0:.01:6, default = 3, show_value = true))"""

# ╔═╡ 37bfc470-23e3-11eb-1626-9f4290cc4264
md"""
##### Best estimate prediction
The equation for our regression line with estimated parameters $\hat{a}$ and $\hat{b}$ is given by,

$\hat{y}_i = \hat{a} + \hat{b}\cdot x_i,$

and all variables known. To predict the average value given new data $x_\text{new}$ we just replace the existing $x_i$, 

$\hat{y}_\text{new} = \hat{a} + \hat{b}\cdot x_\text{new}$

Let us assume we observe a new predictor value $x_\text{new} = 6.2$ for the simulated regression of the previous section.
"""

# ╔═╡ d0884c92-23e9-11eb-0e55-19f66fe2f1d1
x_new = 6.2

# ╔═╡ dd4cac5c-23e9-11eb-2566-9d7dbe8d3668
md"""
We already know the parameter estimates for $a$ and $b$,
"""

# ╔═╡ 8a52f574-23e9-11eb-0256-79bfe953e63d
md"In order to predict an outcome $y_\text{new}$ for the newly observed $x_\text{new}$ we simply insert $x_\text{new}$ into the formula above," 

# ╔═╡ 722f9bd6-23ea-11eb-0eaa-4ddaedb8a8e9
md"""
##### Confidence interval for best estimate
To get the confidence interval, i.e. the uncertainty about our best estimate prediction, at the value $x_\text{new}$ we can apply the following formula, 

$\hat{y}_\text{new} \pm Q(1 - \frac{\alpha}{2}, n - 2) \cdot \sqrt{\left( \frac{S}{n-2}\right)\left( \frac{1}{n} + \frac{(x_\text{new} - \bar{x})^2}{\sum_{i=1}^n (x_i - \bar{x})^2} \right)}$

where $Q(p, n)$ is the quantile function of the T Distribution with $n$ degrees of freedom. 

As an exercise we can calculate these intervals by hand, although they are typically provided by statistical software. At the same value $x_\text{new}$ = $x_new we first calculate the standard error, 
"""

# ╔═╡ c61e09b0-2770-11eb-2aa2-0143f2df5342
md"and finish the calculation of the confidence interval by adding and substracting the product of the T distribution quantile and the standard error from the best estimate,"

# ╔═╡ b4ba95c6-23ec-11eb-0514-bb6efa67aadb
md"""
##### Prediction intervals
Prediction intervals for the outcome at the predictor value $x_\text{new}$ are given by,

$\hat{y}_\text{new} \pm Q(1 - \frac{\alpha}{2}, n - 2) \cdot \sqrt{\left( \frac{S}{n-2}\right)\left(1 + \frac{1}{n} + \frac{(x_\text{new} - \bar{x})^2}{\sum_{i=1}^n (x_i - \bar{x})^2} \right)}$

where $Q(p, n)$ is again the quantile function of the T Distribution with $n$ degrees of freedom. Note that the formula for the prediction interval is the same as for the confidence interval, but including the extra $1 +$ in the calculation of the standard error. This introduces additional uncertainty that will make the prediction interval wider than the confidence interval. Intuitively this also makes sense: The prediction of individual new data values will always be more uncertain than the prediction of the mean value for new data.   

Let us calculate the prediction interval for the new data value $x_\text{new}$ = $x_new. Similar to previous calculations for intervals we start by calculating the standard error of interval,
"""

# ╔═╡ 8c7c718c-2780-11eb-1624-fd7f8591f9bb
md"and then add and substract the product of the quantile function with the standard error, "

# ╔═╡ 78976c04-25b3-11eb-174c-0d6a16346a8d
md"""
##### Assumptions
Getting sensible results from regression analysis hinges on a few assumptions about our data generating process. 

###### Validity & Representativeness
These two assumptions are not necessarily special to linear regression, but apply to all statistical models we fit to data. *Validity* refers to the assumption that our model must correspond to the research question we ask from the data. Of course if the research question and the statistical model do not align, the model can never answer our question regardless of how good it fits the data. We have discussed this extensively in the research design lecture already. 

A second mayor assumption is that the sample is representative of the population of interest. Again, this was already discussed in the lecture on research design and clearly also applies to simple linear regression. If we care about the estimation of associations and prediction of new values for individuals in a population, but do not have a representative sample of that population when estimating the model, we will get *biased estimates*. 

"""

# ╔═╡ 5eb55edc-25b7-11eb-2850-4974e75102e4
md"""

###### Linearity
The assumption of a *linear relationship* between the outcome and the predictor is one of the most important assumptions in simple linear regression. In practice, many problems will be nonlinear and therefore it must be carefully analyzed if the application of linear regression is appropriate. 

If the relationship between the outcome and the predictor is nonlinear, it can sometimes help to transform the predictor to preserve linearity. One common example of this is to model the outcome $y$ by $\log(x)$ instead of $x$. However, care must be taken when interpreting these types of models, because the scale of the predictor variable changes when it is transformed. 
"""

# ╔═╡ 63ab345a-25b7-11eb-048a-f1a770501898
md"""predictor: $(@bind transform_pred Select(["identity" => "x", "log" => "log(x)"]))"""

# ╔═╡ b84b74d4-25b9-11eb-32c9-7f2cfbe9f272
md"If we cannot find a suitable transformation, there exist many advanced statistical methods to estimate even complex nonlinear effects."

# ╔═╡ 5eb69d24-25b7-11eb-2cf2-459c54c622ca
md"""
###### Error term
There are a total of three assumptions made about the error terms $u_i$. First, we assume that errors are *independent*, i.e. that the error of one observation does not depend on the error of another observation. Typically this is not an issue (e.g. when having a random sample of observations that are independent), but there are certain applications such as time series analysis where dependent errors arise. 

Second, we assume that the errors have *equal variance* (are *homoscedastic*). If this assumption is violated, this is in most cases a minor issue and hardly affects the estimation. However, if we observe unequal variances (*heteroscedastic errors*) it might be appropriate to account for it in the model to make estimation more efficient. 

Third, errors are assumed to *follow a normal distribution*. This assumption is hardly important if the only thing we care about in our model is the estimation of the regression line, but comes into play when calculating confidence intervals and making predictions from our model. All in all, however, the previous assumptions about linearity, representativeness, and validity are more of a concern in practice.

> ⚠️ There are no assumptions about the distributions of our variables $y$ or $x$!


"""

# ╔═╡ 2b24ad38-25b3-11eb-12c9-d375b0cc727c
md"""
##### Model evaluation
After fitting the model to data an intuitive question is *how good does our model explain the data?* and whether or not any assumptions we outlined in the previous section are violated. Let us first start with checking the assumptions of a simple linear regression model. 

###### Checking assumptions
We have already seen that we can easily check for linearity by simply plotting the data and regression line. Assumptions about linearity and the error term can be checked visually by creating so called **residual plots**. Residuals are the difference between the observed values $y_i$ and expected values $\hat{y}_i$,

$\hat{u}_i = y_i - \hat{y}_i = y_i - (\hat{a} + \hat{b}\cdot x_i)$

Once we calculate the residulas we can plot them against the expected values $\hat{y}_i$. For the simulated data of the theoretical section, 
"""

# ╔═╡ ef399102-265d-11eb-024b-218f0e34fa00
md"""
In an inconspicuous residual plot such as this one you will observe the following things: 

1. The residual will vary randomly around 0, 
2. The spread of the residuals is (approximately) the same independent of the expected value.  

We can also take a look at what happens if assumptions are violated. If we fit a linear model to nonlinear data such as the logarithmic relationship in the previous section, you will observe that the residuals do not vary randomly around 0. In this case we observe a bias towards negative residuals for both low and high expected values and a bias towards positive residuals in the middle.  
"""

# ╔═╡ 2ac2a7c6-265f-11eb-3533-4b572f0f6528
md"""
For heteroscedastic errors the error will vary randomly around 0, but the spread of the errors will not be the same for all expected values. In this hypothetical example the variance of the errors increases with increasing expected value. This is also visible in a residual plot. 
"""

# ╔═╡ bc780930-2660-11eb-1c56-77945d4d2093
md"""
###### Model evaluation
A simple linear regression model can be evaluated in various ways. In this course we will focus on the most common type of model evaluation, **goodness-of-fit statistics** that give us a numeric summary of how good the model fits the data at hand. 

The most obvious choice to determine how good a linear regression model performs is the *residual standard deviation*, i.e. the dispersion of the residuals. If this standard deviaion is low, the data is not far from the estimated regression line on average, and if the standard deviation is high, the data will be far from the regression line on average. In the following visualization we can take a look at models with varying degrees of residual standard deviation. 
"""

# ╔═╡ 96b1533a-2667-11eb-2053-6b1a278066bd
md"""residual standard deviation: $(@bind resid_std Slider(0.25:.01:1, default = 0.5, show_value = true))"""

# ╔═╡ 617a1108-2668-11eb-10d1-a96b66fb0ae0
md"""R² = $(@bind rsquared Slider(0:.01:1, default = 0.33, show_value = true))"""

# ╔═╡ c03dc0d0-23ec-11eb-20a8-956c06590a68
md"""
### Applications
In this section we will take a look at two possible applications for simple linear regression. We start with the already familiar case of simple linear regression with a *continuous predictor*. Subsequently we will see how to apply simple linear regression to data with a *dichotomous predictor* to estimate differences between two groups. 

"""

# ╔═╡ ccf18122-23ec-11eb-20d1-0be88539ebc1
md"""
#### Continuous predictors
Simple linear regression with a continuous predictor is arguably the most common application. We have already seen how to calculate estimates, make predictions and how to interpret the results from this model. The application to real data here is therefore just a repetition of the concepts. 

In 2014, *Conchita Wurst* won the Eurovision Song contest. As a controversial character, it seems plausible that the ratings given did not only represent the musical ability of the performer but also depended on the sentiments with regards to the LGBTI community in the specific countries. The [Rainbow Index](https://www.ilga-europe.org/rainboweurope) gives us an equality index for LGBTI people in all European countries. From their website, 

> Rainbow Europe Map reflecting the 49 European countries’ legislation and policies that have a direct impact on the enjoyment of human rights by LGBTI people. The Rainbow Map reflects each country’s situation and provides overall score on how far this country is on a scale between 0% and 100%.

-- Description of the Rainbow Index, [🌐](https://www.ilga-europe.org/rainboweurope/2014)

"""

# ╔═╡ 442e174e-24ee-11eb-2a1c-d1b95ae9fb4a
md"""
So what we are interested in is the association between the score given to Conchita Wurst in the 2014 European Song Contest and the Rainbow Index (2014). Taking a look at the raw data tells us that there is an obvious positive relationship between the two variables.
"""

# ╔═╡ 7e36fa8e-24ef-11eb-3c65-7133c6912d7e
md"Now we are ready to fit our regression model to the data. Treating the score given as the dependent variable and the Rainbow index as the independent variable, we get the following parameter estimates:"

# ╔═╡ 6ba8840e-24f2-11eb-27e4-278610594787
md"Uncertainty of our estimates can be described by the confidence intervals of the estimates. If we choose α = 0.05 we get the 95% confidence intervals,"

# ╔═╡ d650052e-24f3-11eb-30e2-bb17023d1bae
md"Or visually,"

# ╔═╡ 0669fcd2-2586-11eb-36c0-83c6d8420ada
md"As can be seen from the graph, it seems possible that there is only a weak relationship between the two variables, but also that there is quite a strong association."

# ╔═╡ 989bc61a-24f7-11eb-31a0-e3385420890e
rainbow_austria = 52

# ╔═╡ 4f6ec29c-24f4-11eb-0ea4-e7d2e331a9f5
md"We can also use our model to create predictions. For example, if Austria was allowed to vote for Conchita Wurst, what score would we expect based on our model? We know that Austria's Rainbow Index in 2014 was $rainbow_austria."

# ╔═╡ c862e29a-2504-11eb-11ae-2135c7d9599a
md"To calculate the expected score from Austria we just plug in the value into the fitted model."

# ╔═╡ 54f1745e-24f5-11eb-3a4c-bd5ddf7499c9
md"If we care about the uncertainty in our predictions we can calculate the prediction intervals. Assuming a 80% prediction interval, meaning that we expect 80% of newly collected data to fall within the interval, the graph looks like this:"

# ╔═╡ d6be2632-24f6-11eb-2e01-e172a060c244
rainbow_bosnia = 20

# ╔═╡ 6bc6c756-24f6-11eb-232e-5dd0b01f1345
md"If Bosnia & Herzegovina would have attended the Eurovision Song Contest in 2014, what would the 80% prediction interval be? Bosnia & Herzegovina at the time had a Rainbow Index of $(rainbow_bosnia)."

# ╔═╡ d7848858-23ec-11eb-0ed4-15f0b17df27a
md"""
#### Dichotomous predictors
So far we have only considered the case for a continuous variable for $x$. In simple linear regression, however, there is no assumption about the scale level of the predictor. A common application is therefore to use simple linear regression with a *dichotomous* predictor[^3].

Commonly dichotomous predictors are constructed from binary nominal or ordinal variables. We usually create a variable by labelling the two groups with 0 and 1 respectively. If $x$ is the variable *gender* we could, for example, assign the value 1 to females and the value 0 to males,

$x_i = \begin{cases}
	0, & \text{if\ gender\ is\ female} \\
	1, & \text{otherwise} \\
\end{cases}$

Assignment of this type is typically referred to as **dummy coding**. While we could also employ other coding schemes, dummy coding is the most popular and usually the default in software. 

> ⚠️ The interpretation of results depends on the coding scheme used! Make sure to know what type of coding is employed in your software.

If we code *gender* in this way our regression model can be stated as, 

$\hat{y}_i = \hat{a} + \hat{b}\cdot x_i, \qquad x_i \in \{0, 1\}$

Note that here $x_i$ can exclusively take the values zero or one. Using this we can state the regression equation when the gender is *male* ($x_i = 0$),

$\hat{y}_i = \hat{a} + \hat{b}\cdot x_i = \hat{a} + \hat{b}\cdot 0 = \hat{a}$

For males the regression equation reduces to the intercept only, since the slope is multiplied by 0. For females ($x_i = 1$) the regression equation then becomes, 

$\hat{y}_i = \hat{a} + \hat{b}\cdot x_i = \hat{a} + \hat{b}\cdot 1 = \hat{a} + \hat{b}.$

This means that for males we estimate the expected or average value by the intercept $\hat{a}$, while this estimate for females is $\hat{a} + \hat{b}$. Since $\hat{a}$ is the average value if the gender is male, the estimate $\hat{b}$ can be interpreted as the **difference between groups** between males and females.    

> ❗ Simple linear regression allows us to estimate the *difference between two groups*.

Now that we know how to interpret the coefficents of a simple linear regression with a dummy coded predictor we are ready to apply it to real data. This analysis is concerned with the gender differences in a standardized educational test, the [SAT](https://en.wikipedia.org/wiki/SAT) which is used for college admission in the USA. Here we take a look at the mathematical portion of the test where students can score anywhere from 200 to 800 points.  

The following plot displays the raw data. On the y-axis we can find the reported SAT score and on the x-axis we have displayed gender, where 0 indicates male and 1 indicates female students. Some jitter has been applied to make the single data points more visible. 
"""

# ╔═╡ 3fced7ce-258e-11eb-3b23-1993ceff3cd1
md"which means we are pretty confident that females have a lower SAT score in the population."

# ╔═╡ 9a98a6d2-258f-11eb-0995-25712a41fd6f
md"""
Similar to the first application for the Eurovision Song Contest, this model for SAT scores is way too simple to account for all possible influencing factors and we have to take care when interpreting the results of such models. Nevertheless, even these simple models can give us interesting insight into our data, which simple descriptive statistics cannot provide.
"""

# ╔═╡ b3dda100-2326-11eb-1228-b990eae439ba
md"""
## Extensions to simple linear regression
Simple linear regression can be extended in various ways. These methods are beyond the scope of this course, but many of them are among the workhorse models of statistics and are used very frequently. Here, we will just quickly describe what lies ahead if you delve deeper into statistics.

###### Multiple linear regression
The most obvious extension to simple linear regression is to consider multiple predictors. When we model multiple predictors for a single outcome using regression, we call it *multiple linear regression*. For example we could extend our SAT score regression to include not only gender, but also the socio-econimic status of the students. In general this will make our models more realistic and we will get better predictions out of our model. 

###### Generalized linear models
Simple and multiple linear regression assume a normal model (for the errors). We have seen in our examples that often this assumption is not appropriate, e.g. when modeling binary data, counts, or the data has lower and/or upper bounds. *Generalized linear models* give us the toolkit to further extend our modeling capabilities. For example *logistic regression* (a special generalized linear model) allows us to model binary dependent variables. This can be used, e.g. to model the probability of passing an exam (0 = fail, 1 = pass) based on one or multiple predictors (e.g. gender, hours studied, etc.). Another common generalized linear model is *Poisson regression* which can be used to model count data or contingency tables.  

###### Hierarchical models
Often the assumption that observations are independent is violated and the data is *clustered* or *grouped* instead. A common example of clustered data arises in educational studies. Here, students are *not* independent, but their outcome most likely depends also on their *school*, *state*, *teacher* or similar variables. One way to account for such dependencies in the data are *multilevel* or *hierarchical regression models*. 


"""

# ╔═╡ c086411e-2326-11eb-3892-b7437fb653f9
md"""
## Summary
In this lecture we covered simple linear regression as a basic model for statistical inference. Starting with causation we have seen that statistical methods for associations are inherently **acausal**, meaning that the causal direction between two (or more) variables cannot be derived from data alone. However, causality and **confounding** plays an important role when building statistical models, because leaving out confounding variables might lead to bias in the resulting parameters. 

We have seen that simple linear regression can be interpreted as a simple line through data and dealt with the **estimation** of the intercept and slope parameters. When discussing the ultimate goal of linear regression, **prediction**, it was distinguished between three cases. First, the most simple type of prediction is concerned with predicting an average value given a predictor value. Second, uncertainty for this type of prediction can be considered using **confidence intervals** (or a **confidence band**). Third, we were interested in getting a plausible range *for new data values*, i.e. calculating a **prediction interval** for a given predictor value. 

When applying (simple) linear regression models one must make sure to check that specific assumptions are met. The most important assumptions of **validity** and **representativeness** are not unique to regression models but always a concern when doing statistical analysis. Regression-specific assumptions are based on **linearity** and various assumptions about the **error term**, which can be checked by graphical methods such as **residual plots**. 

Finally, to evaluate the model fit of a regression model we can choose from a variety of methods such as the **residual standard deviation** or the **coefficient of determination**.

The applied examples have shown us how one would go about modeling data using simple linear regression. An important point was to show that *no assumptions are made about the predictor variable*. This means that we can not only apply simple linear regression to continous predictors, but also binary predictors. For binary predictors this means that we model **differences between two groups**, an application that we will revisit in the upcoming lecture.  

Lastly, I have given a small preview of what lies ahead: There are many extensions to simple linear regression that are applied in statistical practice - all appropriate for different use cases.  
"""

# ╔═╡ defb8750-2365-11eb-2e1b-4f4026d8854f
md"### Footnotes"

# ╔═╡ 813d15cc-272d-11eb-39c8-6fc664b12d76
md"[^1]: We can account for confounders in correlation analysis with *partial correlation*. This type of correlation is not covered in this course and is reserved for advanced statistics courses."

# ╔═╡ e559b66c-2365-11eb-1e53-c1a3b415ee41
md"[^2]: The confidence band, while similar, is not exactly the same as the confidence intervals for the parameters, because the confidence band also includes information about the correlation between the estimates, i.e. it uses the *joint distribution* of $(\hat{a}, \hat{b})$."

# ╔═╡ 8ca6101e-23f2-11eb-165b-abbcbfa7557f
md"[^3]: Nominal and ordinal variables with more than two levels require the use of *multiple linear regression*, because more than one predictor has to be constructed for the variable of interest. The treatment of this case will be omitted."

# ╔═╡ c9414e48-2326-11eb-2197-7718aeb1c760
md"""## Computational resources"""

# ╔═╡ db7e06fa-2326-11eb-3712-95dfe57cd486
md"This section can be ignored..."

# ╔═╡ b39f1f24-272d-11eb-27ed-0fd71f34618b
md"### Simpson's paradox"

# ╔═╡ b7e4cde0-272d-11eb-253a-d5edd0628a88
begin
	simpsons_n = 200
	g1_x = randn(simpsons_n)
	g2_x = randn(simpsons_n) .- 2.0

	simpsons_x = vcat(g1_x, g2_x)
	simpsons_z = vcat(zeros(simpsons_n), ones(simpsons_n))
	simpsons_y = simpsons_x .* 0.6 .+ simpsons_z .* 3.0 .+ randn(simpsons_n * 2) .* 0.5
end

# ╔═╡ 352e0d36-28b7-11eb-3a73-614c334bcec9
md"""
Let's take a look at another example. If we calculate the correlation coefficient for the data displayed in the following scatterplot, the result we get is $(round(cor(simpsons_x, simpsons_y), digits = 2)). This result corresponds with the regression analysis, which will also give us a regression line with negative slope (for explanations see below). As can be seen visually, this result is clearly inappropriate, because there are two groups in the data. If we properly account for the confounding variable, we will get a correlation of $(round(partialcor(simpsons_x, simpsons_y, simpsons_z), digits = 2))[^1] and regression analysis reveals the true positive slope in both groups.
"""

# ╔═╡ 6233e554-2334-11eb-27cd-0ff75f1db32c
md"### Pearson Lee example"

# ╔═╡ 6743692a-2334-11eb-365e-272c13bb92b2
begin
	heights_url = "https://raw.githubusercontent.com/avehtari/ROS-Examples/master/PearsonLee/data/Heights.txt"
	mother_daughter = CSV.File(HTTP.get(heights_url).body) |> DataFrame
	mother_daughter[!, :mother_height] = mother_daughter.mother_height * 2.54
	mother_daughter[!, :daughter_height] = mother_daughter.daughter_height * 2.54
	mother_daughter.mother_height_jittered = mother_daughter.mother_height .+ rand(nrow(mother_daughter))*3 .- 1.5
	mother_daughter.daughter_height_jittered = mother_daughter.daughter_height .+ rand(nrow(mother_daughter))*3 .- 1.5
end

# ╔═╡ 68f50128-2331-11eb-0740-f7b58a5d5297
md"""Linear regression is a statistical method for estimating expected values of an *outcome*, also sometimes referred to as the **dependent variable**, dependent on a set of *predictors* or **independent variables**. In this course we will discuss the simplest case, *simple linear regression*, which is concerned with the estimation of the outcome, $y$, based on a single predictor, $x$.

This is best shown by example: One of the original applications for linear regression was to investigate the inheritability of *height*. In this use case, linear regression can be employed to predict heights of adult children from the heights of their parents. The following scatter plot displays heights for $(nrow(mother_daughter)) pairs of mothers and daugthers. From this data we can estimate the relationship between mother's and daughter's heights and predict heights of daughters when the height of the mother is known. 
"""

# ╔═╡ 27c4e22a-2338-11eb-18c6-c77343b3db27
begin
	heights_fit = lm(@formula(daughter_height_jittered ~ mother_height_jittered), mother_daughter)
	heights_intercept, heights_slope = coef(heights_fit)
end

# ╔═╡ 43ea2384-233d-11eb-2a10-e76c69653218
md"""If a mother's height is $mother_height_prediction centimeters, we would expect their daughter to have a height of $(round(heights_intercept + heights_slope * mother_height_prediction, digits = 1)) centimeters."""

# ╔═╡ 4d9b6a2a-2665-11eb-309b-b976a8d12d72
md"""
For this data, the residual standard deviations is $(round(resid_std, digits = 2)), meaning that the average deviation of data points from the regression line is $(round(resid_std, digits = 2)).

We can also frame the interpretation of the residual standard deviation in terms of predictions. For the example on heights in the introductory section of the lecture, the residual standard deviation is $(round(std(residuals(heights_fit)), digits = 2)). This indicates that the linear regression model can predict the height of daughters with an accuracy of about $(round(std(residuals(heights_fit)), digits = 2)) centimeters (about 2/3 of new values will be between ŷ ± $(round(std(residuals(heights_fit)), digits = 2))). 

Another method to evaluate the goodness-of-fit of a regression model is called $R^2$, **coefficient of determination** or **explained variance** of the model. For simple linear regression $R^2$ is calculated by

$R^2 = \frac{\hat{\sigma}^2_{\hat{y}}}{\hat{\sigma}^2_y} = 1 - \frac{\hat{\sigma}_\hat{u}^2}{\hat{\sigma}^2_y}.$

It is the fraction of the variance explained by the regression model $\hat{\sigma}^2_{\hat{y}}$ of the total variance in the data $\hat{\sigma}^2_y$. $R^2$ can be in the range $[0, 1]$. If it is 1, all of the variance in the outcome is explained by the model and all observations will fall exactly on the line. The other extreme, $R^2 = 0$, means that no variance in the outcome is explained by the model. In this case the slope will be approximately 0 as well.  

From the alternative formulation you can also see the relationship between $R^2$ and the residual standard devation we discussed before. If the residual standard deviation is zero, $\hat{\sigma}_\hat{u} = \hat{\sigma}_\hat{u}^2 = 0$, then $R^2 = 1$ and if the model does not explain any variance, i.e. the residual standard deviation equals the standard deviation of the data, $\hat{\sigma}_\hat{u} = \hat{\sigma}_y$ then $R^2$ will be 0.

In this animation we can see how simple linear regressions with different levels of explained variance look like. 
"""

# ╔═╡ b54ed652-24e9-11eb-0ded-dba4208e1fd6
md"### Eurovision example"

# ╔═╡ b940dd44-24e9-11eb-1f79-d35b9c4757eb
begin
	eurovision_url = "https://raw.githubusercontent.com/p-gw/statistics-fh-wien/master/data/eurovision.csv"
	eurovision = CSV.File(HTTP.get(eurovision_url).body; missingstring = "NA") |> DataFrame
	eurovision = eurovision[.!ismissing.(eurovision.rainbow), :]
end

# ╔═╡ d5c52f44-24e9-11eb-01d8-53b6ed55668a
begin
	function eurovision_dataplot()
		plot(eurovision.rainbow, eurovision.points, seriestype = :scatter, ylimit = [0, 12], xlimit = [0, 100], legend = false, color = "grey", markerstrokewidth = 2, markerstrokecolor = "white", markersize = 6, xlabel = "Rainbow Index", ylabel = "score", yticks = 0:4:12)	
	end
	
	eurovision_dataplot()
end

# ╔═╡ af758cde-24ef-11eb-1793-219e43dccda8
begin
	eurovision_fit = lm(@formula(points ~ rainbow), eurovision)
	eurovision_a, eurovision_b = coef(eurovision_fit)
end

# ╔═╡ 41616bd0-24f1-11eb-1510-b18715ada205
md"a = $(round(eurovision_a, digits = 2))"

# ╔═╡ 4f1ceedc-24f1-11eb-18cc-ed1fba6efafe
md"b = $(round(eurovision_b, digits = 2))"

# ╔═╡ 61adb6c8-24f1-11eb-2a7b-112007e17458
md"We can then interpret the intercept as the expected number of points given by a country with maximal inequality (a hypothetical country where the Rainbow Index is zero). From such a country we would expect $(round(eurovision_a, digits = 2)) points given to Conchita Wurst." 

# ╔═╡ 910ffdb8-24f1-11eb-01fa-c38794faa6a5
md"The slope of our regression model can be interpreted in the following way: For each additional point in the Rainbow Index, we expect an increase of $(round(eurovision_b, digits = 2)) points. If we plot the regression line through our scatter plot we get this picture:"

# ╔═╡ 8c9ca900-24f3-11eb-0eb4-3321cf9cccaa
begin
	eurovision_par_ci = confint(eurovision_fit)	
	md"a = ($(round(eurovision_par_ci[1, 1], digits = 2)), $(round(eurovision_par_ci[1, 2], digits = 2)))" 
end


# ╔═╡ a6a02c32-24f3-11eb-2e53-bbb253027ebb
md"b = ($(round(eurovision_par_ci[2, 1], digits = 2)), $(round(eurovision_par_ci[2, 2], digits = 2)))" 

# ╔═╡ aa1eb012-24f4-11eb-2d40-45408e687c1d
score_austria = eurovision_a + eurovision_b * rainbow_austria

# ╔═╡ b83140de-24f4-11eb-16f3-87338c6b6a8c
md"In this instance we would therefore expect $(round(Int, score_austria)) points from Austria."

# ╔═╡ dfa1a6ae-24f6-11eb-0dd0-895a16fdd132
begin
	pi_bosnia = predict(eurovision_fit, DataFrame("rainbow" => rainbow_bosnia); interval = :prediction, level = 0.8)
	md"This gives a prediction interval of ($(round(Int, pi_bosnia.lower[1])), $(round(Int, pi_bosnia.upper[1]))) with a best estimate of $(round(Int, pi_bosnia.prediction[1])) points. "
end

# ╔═╡ 10edfd9e-2670-11eb-003b-4b195bc031d5
md"""To evaluate goodness of fit for the model, we can calculate R² = $(round(r2(eurovision_fit), digits = 2)) and accordingly our model (the Rainbow Index) explains about $(round(Int, r2(eurovision_fit)*100))% of variance of the countries voting behaviour in the Eurovision Song Contest. While there is still a lot of room for improvement, i.e. there is a lot of variance left unexplained, this is not a bad performance for such a simple regression model."""

# ╔═╡ f17dbe56-24f4-11eb-20eb-8d8eab5aa7c5
md"Note, however that this model clearly is a vast simplification of the actual data generating process. It will also give us nonsensical answers in certain cases: If we were to predict the score for a country with full equality (a Rainbow Score of 100), the model gives us $(round(Int, eurovision_a + eurovision_b * 100)) as the answer. Of course this is impossible, because the maximum points are 12. Since this information (the number of maximum points) is not included in the model, there is no way to account for it accurately.

> 🙋‍♂️ There are extensions of simple linear regression, where we can incorporate such information."

# ╔═╡ 3cf82ab6-24f1-11eb-16d3-ed1135807bf6
eurovision_fit

# ╔═╡ f214364e-258f-11eb-066b-a399488bcbbf
md"### SAT example"

# ╔═╡ fba5b288-2589-11eb-1687-eb8ef6402a88
begin
	sat_url = "https://raw.githubusercontent.com/vincentarelbundock/Rdatasets/master/csv/psych/sat.act.csv"
	sat = CSV.File(HTTP.get(sat_url).body; missingstring = "NA") |> DataFrame
	sat[!, :gender] = sat[!, :gender] .- 1
end

# ╔═╡ 5bd3bd3a-258a-11eb-2605-c7c6ab18e95c
begin
	gender_jittered = sat.gender .+ (rand(length(sat.gender)) .* 0.2 .- 0.1) 
	function sat_dataplot()
		plot(gender_jittered, sat.SATQ, seriestype = :scatter, color = "grey", markerstrokewidth = 0, markersize = 3, legend = false, ylimit = [200, 800], xticks = 0:1, size = [420, 400], xlimit = [-.2, 1.2], ylabel = "SAT Quantitative score", xlabel = "gender")
	end
	
	sat_dataplot()
end

# ╔═╡ 7c16e78e-258a-11eb-0dca-4b39340f2bb1
begin
	sat_fit = lm(@formula(SATQ ~ gender), sat)
	sat_a, sat_b = coef(sat_fit)
	sat_ci = confint(sat_fit)
	sat_pi = predict(sat_fit, DataFrame("gender" => [0, 1]), interval = :prediction, level = 0.8)
end

# ╔═╡ 857697e6-258c-11eb-294d-59397d4cce35
md"""Just from the raw data alone it is not obvious if there is a gender difference in the SAT scores. It seems like male students perform a little bit better on average. 

To get better insight, we can fit a regression model to our data. Treating the SAT score as the dependent variable and gender as the predictor, we arrive at the following estimates,

a = $(round(sat_a, digits = 2))

b = $(round(sat_b, digits = 2))

The intercept tells us the expected value if the predictor is 0. In this case it is the average for male students. Male students score $(round(sat_a, digits = 2)) points on average. The slope gives us the group difference. Since it is negative, female studens score $(abs(round(sat_b, digits = 2))) points less on average and their expected score is $(round(sat_a + sat_b, digits = 2)). 
"""

# ╔═╡ d634f582-258d-11eb-1097-89dfc59f4165
md"""
The accuracy of our estimate is pretty good in this case as we have a lot of observations (n = $(nrow(sat))). The 95% confidence interval for the estimates are, 

a = ($(round(sat_ci[1, 1], digits = 2)), $(round(sat_ci[1, 2], digits = 2)))

b = ($(round(sat_ci[2, 1], digits = 2)), $(round(sat_ci[2, 2], digits = 2)))
"""

# ╔═╡ ef815ca0-258e-11eb-2b4a-9d96692e2e14
md"""
What would predictions for new students look like? If we calculate the 80% prediction interval we can see the range that 80% of new observation will fall in given the assumptions of our model. For male students we expect 80% of new data will be between $(round(sat_pi[1, :lower], digits = 1)) and $(round(sat_pi[1, :upper], digits = 1)) points. For female students we expect $(round(sat_pi[2, :lower], digits = 1)) to $(round(sat_pi[2, :upper], digits = 1)) points.
"""

# ╔═╡ b1119902-2670-11eb-2260-5ba3e4543225
md"""
For this example we calculate the residual standard deviation to assess goodness of fit. The residual standard deviation is $(round(std(residuals(sat_fit)), digits = 2)), which means that we can predict the SAT score with an accuracy of about $(round(Int, std(residuals(sat_fit)))) points based on gender alone. This predictive accuracy is very low and in practice one would seek to improve the predictive performance by including additional variables in the model.

"""

# ╔═╡ 8c400c9e-23e1-11eb-2237-77928608ffd2
md"### Helper functions"

# ╔═╡ 22e6459a-2339-11eb-27da-c52636ef08cd
colors = ["#ef476f","#ffd166","#06d6a0","#118ab2","#073b4c"]

# ╔═╡ 2b0cc222-2335-11eb-37c6-27184b56d9ba
begin
	# scatter
	height_regression_plot = plot(mother_daughter.mother_height_jittered, mother_daughter.daughter_height_jittered, seriestype = :scatter, xlabel = "mother's height", ylabel = "daughter's height", legend = false, markerstrokewidth = 0, markersize = 1.5, aspect_ratio = 1, size = [420, 400], color = height_prediction ? "lightgrey" : "grey", xlimit = [120, 200], ylimit = [120, 200])
	
	# regression line
	if heights_show_line
		Plots.abline!(heights_slope, heights_intercept, lw = 4, color = "white")
		Plots.abline!(heights_slope, heights_intercept, lw = 2, color = colors[1], alpha = height_prediction ? 0.33 : 1)
	end
	
	# prediction
	if height_prediction
		height_ypred = heights_intercept + heights_slope * mother_height_prediction
		plot!([mother_height_prediction, mother_height_prediction], [45, height_ypred], color = "grey")
		plot!([45, mother_height_prediction], [height_ypred, height_ypred], color = "grey")
		plot!([mother_height_prediction], [height_ypred], seriestype = :scatter, markersize = 6, markerstrokecolor = "white", markerstrokewidth = 2, color = color = colors[1])
	end
	
	height_regression_plot
end

# ╔═╡ a78ee6a0-2341-11eb-353f-6107e76cfaf4
begin
	basic_line_x = collect(0:.01:10)
	plot(basic_line_x, basic_line_a .+ basic_line_b .* basic_line_x, xlimit = [0, 4], ylimit = [0, 10], legend = false, size = [420, 380], xlabel = "x", ylabel = "f(x)") 
	
	# slope triangle
	plot!([1.5, 2.5], [basic_line_a + 1.5 * basic_line_b, basic_line_a + 1.5 * basic_line_b], color = "grey")
	plot!([2.5, 2.5], [basic_line_a + 1.5 * basic_line_b, basic_line_a + 2.5 * basic_line_b], color = "grey")
	
	# intercept
	plot!([0, 0], [0, basic_line_a], color = "grey")
	
	Plots.abline!(basic_line_b, basic_line_a, color = "white", lw = 4)
	Plots.abline!(basic_line_b, basic_line_a, color = colors[1], lw = 2)	
	
	# annotations
	annotate!(2, basic_line_a - (basic_line_b > 0 ? 0.5 : -0.5) + 1.5 * basic_line_b, Plots.text("1", 9))
	annotate!(2.6, basic_line_a + 2 * basic_line_b, Plots.text("b = $basic_line_b", 9, :left))
	annotate!(0.1, basic_line_a/2, Plots.text("a = $basic_line_a", 9, :left))
end

# ╔═╡ 831ccfb4-24f2-11eb-315b-b5a6e4f95b8e
begin
	eurovision_dataplot()
	Plots.abline!(eurovision_b, eurovision_a, lw = 4, color = "white")
	Plots.abline!(eurovision_b, eurovision_a, lw = 2, color = colors[1])
end

# ╔═╡ 7eb7b254-24f2-11eb-089d-519cc099dd31
begin
	rainbow_range = collect(-5:.01:105)
	eurovision_ci =  predict(eurovision_fit, DataFrame("rainbow" => rainbow_range); interval = :confidence, level = 1 - .05)
	eurovision_dataplot()
	
	plot!(Shape(vcat(rainbow_range, reverse(rainbow_range)), vcat(eurovision_ci.lower, reverse(eurovision_ci.upper))), lw = 0, alpha = 0.1, color = "grey")
	
	Plots.abline!(eurovision_b, eurovision_a, lw = 4, color = "white")
	Plots.abline!(eurovision_b, eurovision_a, lw = 2, color = colors[1])
end

# ╔═╡ 2a83c834-24f6-11eb-3a08-775dcb48d1b4
begin
	eurovision_pi =  predict(eurovision_fit, DataFrame("rainbow" => rainbow_range); interval = :prediction, level = 0.8)
	eurovision_dataplot()
	
	plot!(Shape(vcat(rainbow_range, reverse(rainbow_range)), vcat(eurovision_pi.lower, reverse(eurovision_pi.upper))), lw = 0, alpha = 0.1, color = "grey")
	
	Plots.abline!(eurovision_b, eurovision_a, lw = 4, color = "white")
	Plots.abline!(eurovision_b, eurovision_a, lw = 2, color = colors[1])
	
end

# ╔═╡ bb02e914-258c-11eb-3c31-79c7bdf7cd12
begin
	sat_dataplot()
	
	Plots.abline!(sat_b, sat_a, lw = 4, color = "white")
	Plots.abline!(sat_b, sat_a, lw = 2, color = colors[1])
end

# ╔═╡ 5f4654e2-258e-11eb-1bce-b913aba5bccc
begin
	sat_dataplot()
	sat_range = collect(-0.5:.01:1.5)
	sat_plot_ci = predict(sat_fit, DataFrame("gender" => sat_range), interval = :confidence, level = .95)
		
	plot!(Shape(vcat(sat_range, reverse(sat_range)), vcat(sat_plot_ci.lower, reverse(sat_plot_ci.upper))), lw = 0, alpha = 0.1, color = "grey")
	
	
	Plots.abline!(sat_b, sat_a, lw = 4, color = "white")
	Plots.abline!(sat_b, sat_a, lw = 2, color = colors[1])	
end

# ╔═╡ d02aff6e-258e-11eb-3d62-5928600a8007
begin
	sat_dataplot()
	sat_plot_pi = predict(sat_fit, DataFrame("gender" => sat_range), interval = :prediction, level = .8)
		
	plot!(Shape(vcat(sat_range, reverse(sat_range)), vcat(sat_plot_pi.lower, reverse(sat_plot_pi.upper))), lw = 0, alpha = 0.1, color = "grey")
	
	
	Plots.abline!(sat_b, sat_a, lw = 4, color = "white")
	Plots.abline!(sat_b, sat_a, lw = 2, color = colors[1])	
end

# ╔═╡ e22d0dbe-2349-11eb-3ee8-c166df86713e
rect(w, h, x, y) = Shape(x .+ [0, w, w, 0], y .+ [0, 0, h, h])

# ╔═╡ e2dba8d0-2349-11eb-0fe0-b7c445d19c9c
begin
	plusminus(x::Number, y::Number) = (x - y, x + y)
	±(x, y) = plusminus(x, y)
end

# ╔═╡ c1d67c82-2725-11eb-3931-258aa940bf85
center(x) = HTML("<div style='text-align: center;'>$(Markdown.html(x))</div>")

# ╔═╡ a315b18e-2725-11eb-36d6-7910b9a3d487
center(md"*Correlation does not imply causation.*")

# ╔═╡ 028718ca-2781-11eb-32cb-c5d2e20e7664
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

# ╔═╡ 8371b176-23e1-11eb-1d6f-9935ce912c54
md"### Estimation"

# ╔═╡ ac9bc826-2347-11eb-06a7-85b7d89b588c
begin
	parest_line_n = 20
	parest_true_a = 0.73
	parest_true_b = 0.89
	parest_true_σ = 0.5
	
	parest_line_x = rand(1:.01:5, parest_line_n)
	parest_line_y = parest_true_a .+ parest_true_b .* parest_line_x + randn(parest_line_n) .* parest_true_σ
	
	parest_df = DataFrame("x" => parest_line_x, "y" => parest_line_y)
	parest_fit = lm(@formula(y ~ x), parest_df)
	parest_coef = round.(coef(parest_fit), digits = 2)
	
	# easier names for example
	y = parest_line_y
	x = parest_line_x
	n = parest_line_n
end

# ╔═╡ ec6bd58e-272a-11eb-374a-c3ca4ed1ec98
begin
	plot(simpsons_x, simpsons_y, seriestype = :scatter, legend = false, color = "grey", markerstrokewidth = 2, markerstrokecolor = "white", markersize = 6)
	
	simpsons_df = DataFrame("x" => simpsons_x, "y" => simpsons_y, "z" => simpsons_z)
	if unconfound == true
		simpsons_fit = lm(@formula(y ~ x + z), simpsons_df)
		simpsons_a, simpsons_b1, simpsons_b2 = coef(simpsons_fit)
		
		Plots.abline!(simpsons_b1, simpsons_a, color = "white", lw = 4)
		Plots.abline!(simpsons_b1, simpsons_a, color = colors[1], lw = 2)	
		
		Plots.abline!(simpsons_b1, simpsons_a + simpsons_b2, color = "white", lw = 4)
		Plots.abline!(simpsons_b1, simpsons_a + simpsons_b2, color = colors[4], lw = 2)	
		
	else
		simpsons_fit = lm(@formula(y ~ x), simpsons_df)
		simpsons_a, simpsons_b = coef(simpsons_fit)
		Plots.abline!(simpsons_b, simpsons_a, color = "white", lw = 4)
		Plots.abline!(simpsons_b, simpsons_a, color = colors[1], lw = 2)	
		
	end
end

# ╔═╡ b73c9f88-2347-11eb-1782-0f1676fe2e6d
begin
	parest_optimize
	md"""a = $(@bind parest_line_a Slider(0:.01:2, default = parest_coef[1], show_value = true))"""		
end

# ╔═╡ 0515cf56-2348-11eb-17e2-934c1061da9c
begin
	parest_optimize
	md"""b = $(@bind parest_line_b Slider(-1:.01:2, default = parest_coef[2], show_value = true))"""
end



# ╔═╡ 270a35e0-2349-11eb-3824-dff7ffa71419
begin
	parest_yhat = parest_line_a .+ parest_line_b .* parest_line_x
	parest_error = parest_line_y .- parest_yhat
	parest_ssq = sum(parest_error.^2)
	S = parest_ssq
	
	md"""sum of squared errors: $(round(parest_ssq, digits = 2))"""
end

# ╔═╡ 8a85711c-2348-11eb-3f15-05a888e32c45
begin
	parest_plot = plot(parest_line_x, parest_line_y, seriestype = :scatter, legend = false, color = "grey", markerstrokewidth = 2, markerstrokecolor = "white", markersize = 6, ylimit = [0, 6], xlimit = [0, 6], aspect_ratio = 1, size = [420, 400])
	
	# line
	Plots.abline!(parest_line_b, parest_line_a, color = "white", lw = 4)
	Plots.abline!(parest_line_b, parest_line_a, color = colors[1], lw = 2)	

	# errors
	for i = 1:parest_line_n
		plot!(rect(-parest_error[i], parest_error[i], parest_line_x[i], parest_yhat[i]), fillalpha = 0.1, color = "grey", lw = 0)
	end
	
	parest_plot
end

# ╔═╡ a9a4f4d0-235e-11eb-2957-8bda39429ef3
b̂ = cov(x, y)/var(x)

# ╔═╡ 4d4af9c8-235e-11eb-2e34-33424b427b87
â = mean(y) - b̂ * mean(x)

# ╔═╡ 875305f0-23e9-11eb-0756-e74f6e9f1a68
(â, b̂)

# ╔═╡ ca413e16-23e9-11eb-2c56-a54bc8efb825
ŷ_new = â + b̂ * x_new 

# ╔═╡ 6296022e-28bc-11eb-36fa-c552b16c8020
md"For an observation with predictor value $x_new we would therefore expect a outcome of $(round(ŷ_new, digits = 2)). Or, in other words: the average value of the outcome is $(round(ŷ_new, digits = 2)) given a predictor value of $x_new."

# ╔═╡ 9a498cf8-2363-11eb-2a9c-475cc43b5762
se_b̂ = sqrt((S/(n - 2))/sum((x .- mean(x)).^2))

# ╔═╡ f4988326-2363-11eb-1e44-19eda60f6cb5
b̂ ± quantile(TDist(n - 2), 1 - α/2) * se_b̂

# ╔═╡ 32f2f5de-2364-11eb-29c6-1da5815788c8
se_â = se_b̂ * sqrt(mean(x.^2))

# ╔═╡ 55c9a852-2364-11eb-376b-0de0ca05d414
â ± quantile(TDist(n - 2), 1 - α/2) * se_â

# ╔═╡ 61b69244-2365-11eb-1c53-79ede6b13a9f
md"""The resulting confidence intervals are pretty wide as we do not have a lot of observations (n = $n) that can give us information about the parameters. In regression analysis the uncertainty of estimation can also be displayed visually. This is done by plotting the so called **confidence band** around the best estimate.[^2]""" 

# ╔═╡ 2341002a-2366-11eb-01fb-ddc7d519c549
begin
	confidence_band_x = collect(-0.5:.01:6.2)
	confidence_band_fit = lm(@formula(y ~ x), DataFrame("x" => x, "y" => y))
	confidence_band_y = predict(confidence_band_fit, DataFrame("x" => confidence_band_x); interval = :confidence, level = 1 - confidence_band_α)
	
	plot(x, y, seriestype = :scatter, legend = false, color = "grey", markerstrokewidth = 2, markerstrokecolor = "white", markersize = 6, ylimit = [0, 6], xlimit = [0, 6], aspect_ratio = 1, size = [420, 400])

	# CI
	plot!(Shape(vcat(confidence_band_x, reverse(confidence_band_x)), vcat(confidence_band_y.lower, reverse(confidence_band_y.upper))), lw = 0, alpha = 0.1, color = "grey")
	
	# line
	Plots.abline!(b̂, â, color = "white", lw = 4)
	Plots.abline!(b̂, â, color = colors[1], lw = 2)	
end

# ╔═╡ 44b8fbd6-23e3-11eb-3f23-f5f00ae3256c
begin
	prediction_band_ci = predict(confidence_band_fit, DataFrame("x" => confidence_band_x); interval = :confidence, level = 1 - prediction_band_α)
	prediction_band_pi = predict(confidence_band_fit, DataFrame("x" => confidence_band_x); interval = :prediction, level = 1 - prediction_band_α)
	
	prediction_plot = plot(x, y, seriestype = :scatter, legend = false, color = "grey", markerstrokewidth = 2, markerstrokecolor = "white", markersize = 6, ylimit = [0, 6], xlimit = [0, 6], aspect_ratio = 1, size = [420, 400])

	# CI
	if prediction_type == "ci"
		plot!(Shape(vcat(confidence_band_x, reverse(confidence_band_x)), vcat(prediction_band_ci.lower, reverse(prediction_band_ci.upper))), lw = 0, alpha = 0.1, color = "grey")
	end
	
	# PI
		if prediction_type == "pi"
		plot!(Shape(vcat(confidence_band_x, reverse(confidence_band_x)), vcat(prediction_band_pi.lower, reverse(prediction_band_pi.upper))), lw = 0, alpha = 0.1, color = "grey")
	end
	
	# line
	Plots.abline!(b̂, â, color = "white", lw = 4)
	Plots.abline!(b̂, â, color = colors[1], lw = 2)	
	
	# predictions
	if prediction_type == "none"
		y_pred = predict(confidence_band_fit, DataFrame("x" => x_pred))
		plot!([x_pred, x_pred], [-1, y_pred[1]], color = "grey")
		plot!([-1, x_pred], [y_pred[1], y_pred[1]], color = "grey")
		plot!([x_pred], [y_pred], seriestype = :scatter, markersize = 6, markerstrokecolor = "white", markerstrokewidth = 2, color = colors[1])
	end
	
	if prediction_type == "ci"
		y_pred = predict(confidence_band_fit, DataFrame("x" => x_pred); interval = :confidence, level = 1 - prediction_band_α)
		plot!([x_pred, x_pred], [-1, y_pred.upper[1]], color = "grey")
		plot!(Shape([-1, x_pred, x_pred, -1], [y_pred.lower[1], y_pred.lower[1], y_pred.upper[1], y_pred.upper[1]]), color = "grey", alpha = 0.1), 
		plot!([x_pred, x_pred], [y_pred.lower[1], y_pred.upper[1]], lw = 4, color = "white")
		plot!([x_pred, x_pred], [y_pred.lower[1], y_pred.upper[1]], lw = 2, color = colors[1])
	end
	
	if prediction_type == "pi"
		y_pred = predict(confidence_band_fit, DataFrame("x" => x_pred); interval = :prediction, level = 1 - prediction_band_α)
		plot!([x_pred, x_pred], [-1, y_pred.upper[1]], color = "grey")
		plot!(Shape([-1, x_pred, x_pred, -1], [y_pred.lower[1], y_pred.lower[1], y_pred.upper[1], y_pred.upper[1]]), color = "grey", alpha = 0.1), 
		plot!([x_pred, x_pred], [y_pred.lower[1], y_pred.upper[1]], lw = 4, color = "white")
		plot!([x_pred, x_pred], [y_pred.lower[1], y_pred.upper[1]], lw = 2, color = colors[1])		
	end
	
	prediction_plot
end

# ╔═╡ b04cb946-24e2-11eb-3d71-77a4d98b6dd2
begin
	if prediction_type == "none"
		md"""The best estimate given the predictor value $x_pred is $(round(y_pred[1], digits = 2))."""
	elseif prediction_type == "ci"
		md"""The confidence interval for the best estimate is ($(round(y_pred.lower[1], digits = 2)), $(round(y_pred.upper[1], digits = 2)))."""
	elseif prediction_type == "pi"
		md"""The prediction interval for new data is ($(round(y_pred.lower[1], digits = 2)), $(round(y_pred.upper[1], digits = 2)))."""		
	end
end

# ╔═╡ 020a4dfe-2770-11eb-29de-c74da838eee8
se_ŷ = sqrt((S/(n - 2)) * (1/n + (x_new - mean(x))^2/(sum((x .- mean(x)).^2))))

# ╔═╡ 5cd69230-2770-11eb-0313-df0949b9de56
ci_ŷ = ŷ_new ± quantile(TDist(n - 2), 1 - 0.2/2) * se_ŷ

# ╔═╡ f1aa1d58-2770-11eb-0e25-edbff3b0f646
md"This confidence interval is exactly the same as the confidence band at the value $x_\text{new}$. We can interpret this result as follows: We are 80% (the coverage probability is chosen to be 0.8) sure that the expected value of the population is within the interval $(round.(ci_ŷ, digits = 2)) for the predictor value $x_new."

# ╔═╡ 7261057e-2771-11eb-23f1-9f5beb79610a
se_p = sqrt((S/(n - 2)) * (1 + 1/n + (x_new - mean(x))^2/(sum((x .- mean(x)).^2))))

# ╔═╡ 63863c36-2771-11eb-2900-837be86d4f0a
prediction_interval = ŷ_new ± quantile(TDist(n - 2), 1 - 0.2/2) * se_p

# ╔═╡ 32be34a2-2781-11eb-1f20-15b58a051a70
md"""The prediction interval gives us a range of values for *future data*. In this case with α = 0.2, the interval tells us that 80% of outcomes for future data with the predictor value $x_\text{new}$ = $x_new will fall between $(round(first(prediction_interval), digits = 2)) and $(round(last(prediction_interval), digits = 2))."""

# ╔═╡ 60bad7b6-25b7-11eb-31ec-d94c246ca65f
begin
	log_n = 100
	log_x = rand(log_n) * 2
	log_y = log.(log_x) .+ randn(log_n)*0.5
	
	if transform_pred == "identity"
		log_fit = lm(@formula(y ~ x), DataFrame("x" => log_x, "y" => log_y))
		log_xvals = log_x
	elseif transform_pred == "log"
		log_fit = lm(@formula(y ~ x), DataFrame("x" => log.(log_x), "y" => log_y))
		log_xvals = log.(log_x)
	end
	

	
	plot(log_xvals, log_y, seriestype = :scatter, legend = false, color = "grey", markerstrokewidth = 2, markerstrokecolor = "white", markersize = 6, ylabel = "y", xlabel = transform_pred == "identity" ? "x" : "log(x)")
	
	log_a, log_b = coef(log_fit)
	Plots.abline!(log_b, log_a, lw = 4, color = "white")
	Plots.abline!(log_b, log_a, lw = 2, color = colors[1])
end

# ╔═╡ 191c5000-265d-11eb-2185-e3562ca666c1
ŷ = (â .+ b̂ .* x)

# ╔═╡ 43b5a906-265d-11eb-2612-a1a5c5b24f66
û = y .- ŷ

# ╔═╡ 3baa7674-265d-11eb-3e65-fbabf90baac4
begin
	plot(ŷ, û, seriestype = :scatter, legend = false, color = "grey", markerstrokewidth = 2, markerstrokecolor = "white", markersize = 6, ylimit = [-1.5, 1.5], xlabel = "fitted value", ylabel = "residual")
	
	hline!([0], lw = 4, color = "white")
	hline!([0], lw = 2, color = colors[1])	
end

# ╔═╡ 6594f83c-265e-11eb-0df7-5b0e86530c85
begin
	resid_fit = lm(@formula(y ~ x), DataFrame("x" => log_x, "y" => log_y))
	resid_xvals = log_x

	plot(predict(resid_fit), residuals(resid_fit), seriestype = :scatter, legend = false, color = "grey", markerstrokewidth = 2, markerstrokecolor = "white", markersize = 6, ylimit = [-1.5, 1.5], xlabel = "fitted value", ylabel = "residual")
	
	hline!([0], lw = 4, color = "white")
	hline!([0], lw = 2, color = colors[1])		
end


# ╔═╡ 49e39c1e-265f-11eb-0ea6-ebe5cdbb8c01
begin
	varunequal_n = 250
	varunequal_x = sort(rand(varunequal_n))
	varunequal_y = varunequal_x .* 1.6 .+ randn(varunequal_n) .* range(0.5, 3; length = varunequal_n)
	
	varunequal_fit = lm(@formula(y ~ x), DataFrame("x" => varunequal_x, "y" => varunequal_y))
	

	plot(predict(varunequal_fit), residuals(varunequal_fit), seriestype = :scatter, legend = false, color = "grey", markerstrokewidth = 2, markerstrokecolor = "white", markersize = 6, ylimit = [-6, 6], xlabel = "fitted value", ylabel = "residual")
	
	hline!([0], lw = 4, color = "white")
	hline!([0], lw = 2, color = colors[1])		

end

# ╔═╡ d058c3a6-2663-11eb-2775-bb04a4341df3
begin
	resid_std_n = 3000
	resid_std_x = randn(resid_std_n) * 1
	resid_std_b = 1
	resid_std_y = 2 .+ resid_std_x .* resid_std_b .+ randn(resid_std_n) .* resid_std
	
	resid_std_fit = lm(@formula(y ~ x), DataFrame("x" => resid_std_x, "y" => resid_std_y))
	
	resid_std_a, resid_std_b = coef(resid_std_fit)
	resid_std_est = std(residuals(resid_std_fit))
	
	plot(resid_std_x, resid_std_y, seriestype = :scatter, legend = false, color = "grey", markerstrokewidth = 0, markerstrokecolor = "white", markersize = 1.5, xlabel = "x", ylabel = "y", ylimit = [-1, 5], xlimit = [-3, 3])
	
	Plots.abline!(resid_std_b, resid_std_a, lw = 4, color = "white")
	Plots.abline!(resid_std_b, resid_std_a, lw = 2, color = colors[1])
end

# ╔═╡ 8abd16cc-2667-11eb-3a2d-37468ff2a6c4
begin
	rsquared_n = 1000
	
	rsq = rsquared == 1 ? .9999 : rsquared
	
	dist = MvNormal(convert(Matrix, [1.0 sqrt(rsq); sqrt(rsq) 1.0]))
	rsquared_samp = rand(dist, rsquared_n)

	rsquared_x = rsquared_samp[1, :]
	rsquared_y = rsquared_samp[2, :]	
	
	rsquared_fit = lm(@formula(y ~ x), DataFrame("x" => rsquared_x, "y" => rsquared_y))
	rsquared_a, rsquared_b = coef(rsquared_fit)
	
	plot(rsquared_x, rsquared_y, seriestype = :scatter, legend = false, color = "grey", markerstrokewidth = 0, markerstrokecolor = "white", markersize = 1.5, xlabel = "x", ylabel = "y")
	
	Plots.abline!(rsquared_b, rsquared_a, lw = 4, color = "white")
	Plots.abline!(rsquared_b, rsquared_a, lw = 2, color = colors[1])
end

# ╔═╡ Cell order:
# ╟─b6d87880-f437-11ea-11ed-29b755ee68bb
# ╟─415f55c2-28b4-11eb-02c1-a3c491710f9c
# ╟─0eb284c0-2326-11eb-39fe-5799689586a3
# ╟─a315b18e-2725-11eb-36d6-7910b9a3d487
# ╟─162fca24-2726-11eb-06c7-89832fc51da3
# ╟─84de7b14-28b6-11eb-36f7-0d099321b53b
# ╟─591d1f6c-2726-11eb-1b36-2d2a58183130
# ╟─864912b6-28b6-11eb-171e-178f58f0571b
# ╟─352e0d36-28b7-11eb-3a73-614c334bcec9
# ╟─3b912ef6-272c-11eb-09d2-13a9187db87d
# ╟─ec6bd58e-272a-11eb-374a-c3ca4ed1ec98
# ╟─03c7c1cc-272e-11eb-0fec-8fd790a91765
# ╟─2ee8496e-2326-11eb-3674-45135868a7fc
# ╟─68f50128-2331-11eb-0740-f7b58a5d5297
# ╟─0a032cc0-233c-11eb-230a-e1c4fcbd2ca2
# ╟─9d1bbbe2-2339-11eb-0037-87d1668c36b9
# ╟─c57c1366-2339-11eb-38c7-8d3b7c5b9d9d
# ╟─43ea2384-233d-11eb-2a10-e76c69653218
# ╟─2b0cc222-2335-11eb-37c6-27184b56d9ba
# ╟─283d523a-2335-11eb-3738-017a69191b5d
# ╟─3f1bd86a-233e-11eb-1f94-35e880f5b201
# ╟─8b337fe2-23ec-11eb-2711-7df12b02955b
# ╟─2a059362-233e-11eb-0531-f5119e1b9840
# ╟─ace02510-2341-11eb-04dd-8774a0690252
# ╟─c5e5c4b8-2341-11eb-18ed-e701cf6dbe55
# ╟─a78ee6a0-2341-11eb-353f-6107e76cfaf4
# ╟─a42f64e0-2345-11eb-1afb-f7b0ca2382a8
# ╟─b73c9f88-2347-11eb-1782-0f1676fe2e6d
# ╟─0515cf56-2348-11eb-17e2-934c1061da9c
# ╟─bac8437e-234b-11eb-2523-e58a100d3980
# ╟─8a85711c-2348-11eb-3f15-05a888e32c45
# ╟─270a35e0-2349-11eb-3824-dff7ffa71419
# ╟─180a8e4c-234d-11eb-3972-c58875c62060
# ╟─2adf4664-235e-11eb-03fa-1d404ef0c77c
# ╠═a9a4f4d0-235e-11eb-2957-8bda39429ef3
# ╟─fd21bb96-235e-11eb-125f-4319e7644194
# ╠═4d4af9c8-235e-11eb-2e34-33424b427b87
# ╟─1d497244-235f-11eb-3a2b-23e92f7dfd0c
# ╠═01669c8c-2364-11eb-1b4d-e131b071ad1c
# ╠═9a498cf8-2363-11eb-2a9c-475cc43b5762
# ╟─729169f6-28bb-11eb-188e-a118f5baa5d9
# ╠═f4988326-2363-11eb-1e44-19eda60f6cb5
# ╟─84c0024a-28bb-11eb-31e5-c39d6af6e1c4
# ╠═32f2f5de-2364-11eb-29c6-1da5815788c8
# ╠═55c9a852-2364-11eb-376b-0de0ca05d414
# ╟─61b69244-2365-11eb-1c53-79ede6b13a9f
# ╟─12fd1b62-2367-11eb-2e6e-cd1944643366
# ╟─2341002a-2366-11eb-01fb-ddc7d519c549
# ╟─52c796a8-2369-11eb-29d5-a97593bd2c73
# ╟─2960c9c0-235e-11eb-1059-7f8b56a0c657
# ╟─ab7edd7c-23e3-11eb-366c-294c5c1cd3e2
# ╟─27b21b34-23e4-11eb-2150-0bc92a230ff2
# ╟─c86b8556-23e4-11eb-0870-6115617fef9a
# ╟─b04cb946-24e2-11eb-3d71-77a4d98b6dd2
# ╟─44b8fbd6-23e3-11eb-3f23-f5f00ae3256c
# ╟─37bfc470-23e3-11eb-1626-9f4290cc4264
# ╠═d0884c92-23e9-11eb-0e55-19f66fe2f1d1
# ╟─dd4cac5c-23e9-11eb-2566-9d7dbe8d3668
# ╠═875305f0-23e9-11eb-0756-e74f6e9f1a68
# ╟─8a52f574-23e9-11eb-0256-79bfe953e63d
# ╠═ca413e16-23e9-11eb-2c56-a54bc8efb825
# ╟─6296022e-28bc-11eb-36fa-c552b16c8020
# ╟─722f9bd6-23ea-11eb-0eaa-4ddaedb8a8e9
# ╠═020a4dfe-2770-11eb-29de-c74da838eee8
# ╟─c61e09b0-2770-11eb-2aa2-0143f2df5342
# ╠═5cd69230-2770-11eb-0313-df0949b9de56
# ╟─f1aa1d58-2770-11eb-0e25-edbff3b0f646
# ╟─b4ba95c6-23ec-11eb-0514-bb6efa67aadb
# ╠═7261057e-2771-11eb-23f1-9f5beb79610a
# ╟─8c7c718c-2780-11eb-1624-fd7f8591f9bb
# ╠═63863c36-2771-11eb-2900-837be86d4f0a
# ╟─32be34a2-2781-11eb-1f20-15b58a051a70
# ╟─78976c04-25b3-11eb-174c-0d6a16346a8d
# ╟─5eb55edc-25b7-11eb-2850-4974e75102e4
# ╟─63ab345a-25b7-11eb-048a-f1a770501898
# ╟─60bad7b6-25b7-11eb-31ec-d94c246ca65f
# ╟─b84b74d4-25b9-11eb-32c9-7f2cfbe9f272
# ╟─5eb69d24-25b7-11eb-2cf2-459c54c622ca
# ╟─2b24ad38-25b3-11eb-12c9-d375b0cc727c
# ╠═191c5000-265d-11eb-2185-e3562ca666c1
# ╠═43b5a906-265d-11eb-2612-a1a5c5b24f66
# ╟─3baa7674-265d-11eb-3e65-fbabf90baac4
# ╟─ef399102-265d-11eb-024b-218f0e34fa00
# ╟─6594f83c-265e-11eb-0df7-5b0e86530c85
# ╟─2ac2a7c6-265f-11eb-3533-4b572f0f6528
# ╟─49e39c1e-265f-11eb-0ea6-ebe5cdbb8c01
# ╟─bc780930-2660-11eb-1c56-77945d4d2093
# ╟─96b1533a-2667-11eb-2053-6b1a278066bd
# ╟─d058c3a6-2663-11eb-2775-bb04a4341df3
# ╟─4d9b6a2a-2665-11eb-309b-b976a8d12d72
# ╟─617a1108-2668-11eb-10d1-a96b66fb0ae0
# ╟─8abd16cc-2667-11eb-3a2d-37468ff2a6c4
# ╟─c03dc0d0-23ec-11eb-20a8-956c06590a68
# ╟─ccf18122-23ec-11eb-20d1-0be88539ebc1
# ╟─442e174e-24ee-11eb-2a1c-d1b95ae9fb4a
# ╟─d5c52f44-24e9-11eb-01d8-53b6ed55668a
# ╟─7e36fa8e-24ef-11eb-3c65-7133c6912d7e
# ╟─41616bd0-24f1-11eb-1510-b18715ada205
# ╟─4f1ceedc-24f1-11eb-18cc-ed1fba6efafe
# ╟─61adb6c8-24f1-11eb-2a7b-112007e17458
# ╟─910ffdb8-24f1-11eb-01fa-c38794faa6a5
# ╟─831ccfb4-24f2-11eb-315b-b5a6e4f95b8e
# ╟─6ba8840e-24f2-11eb-27e4-278610594787
# ╟─8c9ca900-24f3-11eb-0eb4-3321cf9cccaa
# ╟─a6a02c32-24f3-11eb-2e53-bbb253027ebb
# ╟─d650052e-24f3-11eb-30e2-bb17023d1bae
# ╟─7eb7b254-24f2-11eb-089d-519cc099dd31
# ╟─0669fcd2-2586-11eb-36c0-83c6d8420ada
# ╟─4f6ec29c-24f4-11eb-0ea4-e7d2e331a9f5
# ╟─989bc61a-24f7-11eb-31a0-e3385420890e
# ╟─c862e29a-2504-11eb-11ae-2135c7d9599a
# ╠═aa1eb012-24f4-11eb-2d40-45408e687c1d
# ╟─b83140de-24f4-11eb-16f3-87338c6b6a8c
# ╟─54f1745e-24f5-11eb-3a4c-bd5ddf7499c9
# ╟─2a83c834-24f6-11eb-3a08-775dcb48d1b4
# ╟─6bc6c756-24f6-11eb-232e-5dd0b01f1345
# ╟─d6be2632-24f6-11eb-2e01-e172a060c244
# ╟─dfa1a6ae-24f6-11eb-0dd0-895a16fdd132
# ╟─10edfd9e-2670-11eb-003b-4b195bc031d5
# ╟─f17dbe56-24f4-11eb-20eb-8d8eab5aa7c5
# ╟─d7848858-23ec-11eb-0ed4-15f0b17df27a
# ╟─5bd3bd3a-258a-11eb-2605-c7c6ab18e95c
# ╟─857697e6-258c-11eb-294d-59397d4cce35
# ╟─bb02e914-258c-11eb-3c31-79c7bdf7cd12
# ╟─d634f582-258d-11eb-1097-89dfc59f4165
# ╟─3fced7ce-258e-11eb-3b23-1993ceff3cd1
# ╟─5f4654e2-258e-11eb-1bce-b913aba5bccc
# ╟─ef815ca0-258e-11eb-2b4a-9d96692e2e14
# ╟─d02aff6e-258e-11eb-3d62-5928600a8007
# ╟─b1119902-2670-11eb-2260-5ba3e4543225
# ╟─9a98a6d2-258f-11eb-0995-25712a41fd6f
# ╟─b3dda100-2326-11eb-1228-b990eae439ba
# ╟─c086411e-2326-11eb-3892-b7437fb653f9
# ╟─defb8750-2365-11eb-2e1b-4f4026d8854f
# ╟─813d15cc-272d-11eb-39c8-6fc664b12d76
# ╟─e559b66c-2365-11eb-1e53-c1a3b415ee41
# ╟─8ca6101e-23f2-11eb-165b-abbcbfa7557f
# ╟─c9414e48-2326-11eb-2197-7718aeb1c760
# ╟─db7e06fa-2326-11eb-3712-95dfe57cd486
# ╠═d68ae886-2326-11eb-12ac-2f963f78e691
# ╟─b39f1f24-272d-11eb-27ed-0fd71f34618b
# ╠═b7e4cde0-272d-11eb-253a-d5edd0628a88
# ╟─6233e554-2334-11eb-27cd-0ff75f1db32c
# ╠═6743692a-2334-11eb-365e-272c13bb92b2
# ╠═27c4e22a-2338-11eb-18c6-c77343b3db27
# ╟─b54ed652-24e9-11eb-0ded-dba4208e1fd6
# ╠═b940dd44-24e9-11eb-1f79-d35b9c4757eb
# ╠═3cf82ab6-24f1-11eb-16d3-ed1135807bf6
# ╠═af758cde-24ef-11eb-1793-219e43dccda8
# ╟─f214364e-258f-11eb-066b-a399488bcbbf
# ╠═fba5b288-2589-11eb-1687-eb8ef6402a88
# ╠═7c16e78e-258a-11eb-0dca-4b39340f2bb1
# ╟─8c400c9e-23e1-11eb-2237-77928608ffd2
# ╠═22e6459a-2339-11eb-27da-c52636ef08cd
# ╠═e22d0dbe-2349-11eb-3ee8-c166df86713e
# ╠═e2dba8d0-2349-11eb-0fe0-b7c445d19c9c
# ╠═c1d67c82-2725-11eb-3931-258aa940bf85
# ╠═028718ca-2781-11eb-32cb-c5d2e20e7664
# ╟─8371b176-23e1-11eb-1d6f-9935ce912c54
# ╟─ac9bc826-2347-11eb-06a7-85b7d89b588c

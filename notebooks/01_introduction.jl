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

# ╔═╡ 503367b4-f5c6-11ea-0838-910afc85b4f3
begin
	using Pkg
	Pkg.add("Distributions")
	Pkg.add("Plots")
	Pkg.add("GLM")
	Pkg.add("DataFrames")
	Pkg.add("PlutoUI")
	using Distributions, Plots, GLM, DataFrames, PlutoUI
end

# ╔═╡ 39d4ca10-f427-11ea-2d6d-4392d7df0183
md"""
# Introduction
"""

# ╔═╡ 2e0c4ab0-f42b-11ea-1d7e-e18c5d37e4cf
md"""
## About me
"""

# ╔═╡ 57fbc3f0-f42b-11ea-3192-4d048c9b1208
md"""
## 💡 What are you going to learn? 
### Research design
We will cover the basics of research- and questionnaire design. This includes,

- The collection of quantitative data,
- Scales & Tests,
- Construction of questionnaires,
- Sampling
"""

# ╔═╡ cd4bcafa-f5be-11ea-3508-0d436b24bf33
md"""
## 💡 What are you going to learn? 
### Descriptive statistics

Learn how to describe quantitative data *numerically* and *visually*.

[insert COVID example here]
"""

# ╔═╡ d5b2acb4-f5be-11ea-3392-f9d0aacc0e7e
md"""
## 💡 What are you going to learn? 
### Probability
What is $P(X \leq x)$?

$(@bind x_value Slider(-3:0.01:3, default = -1))
"""

# ╔═╡ 0c7e1a42-f5d2-11ea-1d6f-b1a2cded18ba
["x" => x_value, "P(X <= $(x_value))" => cdf(Normal(), x_value)]

# ╔═╡ bb7d81d0-f5ce-11ea-3873-4b14b1c50ec3
begin
	plotrange = -3:0.01:3
	# PDF
	pdf_plot = plot(plotrange, pdf.(Normal(), plotrange), legend = false)
	integral_range = -3:0.01:x_value
	sx = vcat(integral_range, reverse(integral_range))
	sy = vcat(pdf.(Normal(), integral_range), zeros(length(integral_range)))
	plot!(Shape(sx, sy), color = "grey", opacity = 0.33)
	
	# CDF
	cdf_plot = plot(plotrange, cdf.(Normal(), plotrange), legend = false)
	plot!((x_value, cdf(Normal(), x_value)), seriestype = :scatter, color = "grey")
	plot(pdf_plot, cdf_plot)
end

# ╔═╡ dab70702-f5be-11ea-2201-7fbfffd42c20
md"""
## 💡 What are you going to learn? 
### Linear regression
"""

# ╔═╡ ac41c918-f5c6-11ea-1ba3-a5a92d45b990
n = 30

# ╔═╡ 6383026c-f5c6-11ea-0bf3-b921b30c01f8
x = rand(truncated(Normal(60, 20), 0, 100), n)

# ╔═╡ 6bf2def6-f5c6-11ea-18ec-c7e7a1194767
y = -5 .+ 0.83 .* x .+ rand(Normal(0, 8), n)

# ╔═╡ 349992a4-f5c8-11ea-2e68-4f440a089704
lm_data = DataFrame("x" => x,"y" => y)

# ╔═╡ 63c76358-f5c8-11ea-17a8-71ff55e9841c
ols_fit = lm(@formula(y ~ x), lm_data)

# ╔═╡ ad490ec8-f5c8-11ea-2b3a-b19655e14edb
α, β = coef(ols_fit)

# ╔═╡ d79ea8f2-f5c8-11ea-1776-a9385d0efee5
y_hat = predict(ols_fit)

# ╔═╡ 319f9176-f5c9-11ea-219f-e713853fc37d
resid = y - y_hat

# ╔═╡ 7d3f577a-f5cb-11ea-134a-f5482f307912
rect(w, h, x, y) = Shape(x .+ [0, w, w, 0], y .+ [0, 0, h, h])

# ╔═╡ a08492ea-f5c6-11ea-2901-f349f6498e33
begin
	fig = plot(x, y, seriestype = :scatter, legend = false, xlimit = [0, 100], ylimit = [0, 100], aspect_ratio = :equal, xlabel = "test score (midterm)", ylabel = "test score (endterm)", markercolor = "grey", markerstrokecolor = "grey")
	Plots.abline!(β, α, lw = 2)

	for i = 1:n
		plot!(rect(-resid[i], resid[i], x[i], y_hat[i]), opacity = 0.4, color = "grey")
	end
	
	fig
end

# ╔═╡ f19592ea-f5be-11ea-3403-cbd6c9840a32
md"""
## 💡 What are you going to learn? 
### Testing
"""

# ╔═╡ 6870907e-f42b-11ea-2c27-8b5bf45d06f3
md"""
## How does this course work?
### Lectures
"""

# ╔═╡ acc852c6-f5b7-11ea-2453-d1abcfbb6994
md"""
## How does this course work?
### Homework 📘
- Total of **5 graded homeworks** (+1 ungraded) worth 8 points each,
- Homeworks can be done either *alone* or *in pairs*.
- Homeworks will be due until the upcoming synchronous distance learning session.

> ✔️ Turn in your Homework in Moodle in *Portable Document Format* (PDF). 

When working in pairs (*highly* recommended):
- Stay in the **same pairing** for the whole semester, 
- Every person has to turn in the homework in Moodle, 
- Note both of your names in the final document.
"""

# ╔═╡ afd576fe-f5b7-11ea-11a4-654403973111
md"""
## How does this course work?
### Exam 📝
"""

# ╔═╡ 1e5060c8-f8ee-11ea-3532-69b3322d6045
md"""
- **1x long-form open question** (*20 points*)

  Answer a question using multiple sentences/paragraphs. Question will probably be conceptual and broad."""

# ╔═╡ 4bdeb60a-f8ee-11ea-2e18-09c211cb061d
md"""
- **2x short-form open questions** (*10 points each*)

  Can be answered using a few sentences. Questions will likely involve explaining specific concepts or interpreting computational results. 
"""

# ╔═╡ 1e512524-f8ee-11ea-1501-5d62eea4f4d5
md"""

  - **5x multiple-choice** (*4 points each*)

    Closed-form answer format: Choose the *2 correct answers* out of 5 possible answers. *2 points* will be awarded for each correct answer. If any incorrect answers are chosen, you get 0 points.
"""

# ╔═╡ b32fc9fa-f8f0-11ea-008a-c3dacabaffbf
md"> ⚠️ **No calculations required**, but be prepared to interpret results and software output!"

# ╔═╡ b2b6ef4e-f5b7-11ea-3346-e5d980ee7168
md"""
## How does this course work?
### Grading

You can reach a **maximum** of **100 points** (60 exam, 40 homework). 

| minimum | grade | maximum |
| ---: | :---: | :--- |
| 90 < | very good(1) 	  | <= 100 |
| 75 < | good (2)    	  | <= 90  |
| 60 < | satisfactory (3) | <= 75  |
| 50 < | sufficient (4)   | <= 60  |
|  0 < | insufficient (5) | <= 50  |
"""

# ╔═╡ 6f6412e6-f5bf-11ea-0495-2d22aeefc492
md"""
## How does this course work?
### Software
1) My notebooks will make extensive use of interactivity. Installing [Julia](https://julialang.org/) and [Pluto.jl](https://github.com/fonsp/Pluto.jl) is required for this to work correctly.  
2) Most of this course will require statistical software. There are many choices available: 

| Type | Point & Click | Command line |
| --- | --- | --- |
| free | PSPP | **R**, Python, Julia |
| paid | **SPSS**, Excel, SYSTAT | MATLAB, SAS |

> 💻 If you have previous experience in *any* suitable program feel free to use it!
"""

# ╔═╡ c4005d80-f5d2-11ea-1cf7-b50392525cb5
md"""
## Homework 0

1. Install your preferred statistical software,
2. (optional) Install Julia and Pluto.jl if you want reactive learning materials,
3. Fill in the [student questionnaire](https://docs.google.com/forms/d/e/1FAIpQLSePQz1A6QZUzAucMC51-AS7KlVBZFXvvgIpaFYc19al3I1-Sw/viewform).

> 🙋 The data will **exclusively** be used for examples and homeworks in this course!

This homework will **not** be graded!
"""

# ╔═╡ 1405cda6-f8ee-11ea-2f12-89130cedd15f
center(x) = HTML("<div style='text-align: center'>$(Markdown.html(x))</div>")

# ╔═╡ 65195ddc-f8ee-11ea-2902-0d0e3a14c7d0
center(md"First possible date on *21.12.2020*!")

# ╔═╡ 166dbb10-f8ee-11ea-0973-d511f7a6f02c
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

# ╔═╡ 409bd216-f8f1-11ea-2ecb-8188ab05d9ef
two_columns(md"""
**📹 Video lectures**
- Asynchronous distance learning
- Introduction of new topics

| Date | Topic |
| ---: | :--- |
| 5.10. | Research design & planning |
| 27.10. | Descriptive statistics |
| 9.11. | Probability & inference |
| 23.11. | Correlation & linear regression |
| 30.11. | Null hypothesis significance testing |
""", md"""
**💬 Discussion sessions**
- Zoom Meetings
- Discussion of homework and video lectures
- Place to **ask questions!** (If possible, ask them in the Moodle forum before the lecture)
	
> See [syllabus](https://moodle.fh-wien.ac.at/moodle/mod/resource/view.php?id=514814) for schedule!
""")

# ╔═╡ Cell order:
# ╠═39d4ca10-f427-11ea-2d6d-4392d7df0183
# ╠═2e0c4ab0-f42b-11ea-1d7e-e18c5d37e4cf
# ╟─57fbc3f0-f42b-11ea-3192-4d048c9b1208
# ╠═cd4bcafa-f5be-11ea-3508-0d436b24bf33
# ╟─d5b2acb4-f5be-11ea-3392-f9d0aacc0e7e
# ╟─0c7e1a42-f5d2-11ea-1d6f-b1a2cded18ba
# ╟─bb7d81d0-f5ce-11ea-3873-4b14b1c50ec3
# ╟─dab70702-f5be-11ea-2201-7fbfffd42c20
# ╟─a08492ea-f5c6-11ea-2901-f349f6498e33
# ╟─503367b4-f5c6-11ea-0838-910afc85b4f3
# ╟─ac41c918-f5c6-11ea-1ba3-a5a92d45b990
# ╟─6383026c-f5c6-11ea-0bf3-b921b30c01f8
# ╟─6bf2def6-f5c6-11ea-18ec-c7e7a1194767
# ╟─349992a4-f5c8-11ea-2e68-4f440a089704
# ╟─63c76358-f5c8-11ea-17a8-71ff55e9841c
# ╟─ad490ec8-f5c8-11ea-2b3a-b19655e14edb
# ╟─d79ea8f2-f5c8-11ea-1776-a9385d0efee5
# ╟─319f9176-f5c9-11ea-219f-e713853fc37d
# ╠═7d3f577a-f5cb-11ea-134a-f5482f307912
# ╠═f19592ea-f5be-11ea-3403-cbd6c9840a32
# ╟─6870907e-f42b-11ea-2c27-8b5bf45d06f3
# ╟─409bd216-f8f1-11ea-2ecb-8188ab05d9ef
# ╟─acc852c6-f5b7-11ea-2453-d1abcfbb6994
# ╟─afd576fe-f5b7-11ea-11a4-654403973111
# ╟─65195ddc-f8ee-11ea-2902-0d0e3a14c7d0
# ╟─1e5060c8-f8ee-11ea-3532-69b3322d6045
# ╟─4bdeb60a-f8ee-11ea-2e18-09c211cb061d
# ╟─1e512524-f8ee-11ea-1501-5d62eea4f4d5
# ╟─b32fc9fa-f8f0-11ea-008a-c3dacabaffbf
# ╟─b2b6ef4e-f5b7-11ea-3346-e5d980ee7168
# ╠═6f6412e6-f5bf-11ea-0495-2d22aeefc492
# ╟─c4005d80-f5d2-11ea-1cf7-b50392525cb5
# ╠═1405cda6-f8ee-11ea-2f12-89130cedd15f
# ╠═166dbb10-f8ee-11ea-0973-d511f7a6f02c

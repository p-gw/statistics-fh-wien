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

Employed at the federal ministry for Education, Science & Research as a *psychometrician*. 

> **Psychometrics** is a field of study concerned with the theory and technique of psychological measurement. [...]
> 
> The field is concerned with the objective *measurement* of skills and knowledge, abilities, attitudes, personality traits, and educational achievement.

-- Wikipedia [🌐](https://en.wikipedia.org/wiki/Psychometrics)

A main goal of my work is to ensure the *quality* of tasks (difficuly, fairness, ...) in the standardized Austrian matriculation exam by **empirical testing**.  
"""

# ╔═╡ 57fbc3f0-f42b-11ea-3192-4d048c9b1208
md"""
## What are you going to learn? 
### Research design
We will cover the basics of research- and questionnaire design. This includes,

- The collection of quantitative data,
- Scales & tests,
- Construction of questionnaires,
- Sampling
"""

# ╔═╡ cd4bcafa-f5be-11ea-3508-0d436b24bf33
md"""
### Descriptive statistics

Learn how to describe quantitative data *numerically* and *visually*.

[insert example here]
"""

# ╔═╡ d5b2acb4-f5be-11ea-3392-f9d0aacc0e7e
md"""
### Probability
Get to know the basics of *probability theory* and *probability distributions*.

What is $P(X \leq x)$?

$(@bind x_value Slider(-3:0.01:3, default = -1))
"""

# ╔═╡ 0c7e1a42-f5d2-11ea-1d6f-b1a2cded18ba
["x" => x_value, "P(X <= $(x_value))" => cdf(Normal(), x_value)]

# ╔═╡ e75f6dae-fbfd-11ea-2b29-33b9c4082535
md"""
### Statistical inference

The goal of statistical inference is to *estimate* some numerical quantity of a population from a sample. 

For example we could be interested in the *height* of the adult population in Austria,
"""

# ╔═╡ a744a580-fcdc-11ea-004c-9d0b84968438
@bind new_sample Button("Draw new sample")

# ╔═╡ dab70702-f5be-11ea-2201-7fbfffd42c20
md"""
### Linear regression
"""

# ╔═╡ a19219a0-fcdd-11ea-2884-3bc702738f12
md"Aside from estimation we are also interested in *predicting* future observations."

# ╔═╡ fa21f7c0-fce2-11ea-3202-4b8fd9bd5136
md"midterm score: $(@bind midterm NumberField(0:100, default = 20))"

# ╔═╡ f19592ea-f5be-11ea-3403-cbd6c9840a32
md"""
### Testing
Sometimes it can be necessary to generate *decisions* from uncertain data. One such question could be: Does our new website generate more engagement? 
"""

# ╔═╡ 6870907e-f42b-11ea-2c27-8b5bf45d06f3
md"""
## How does this course work?
### Lectures
"""

# ╔═╡ 27c2fec0-fccc-11ea-2e18-8923216f61c1
md"> Due to COVID-19 there is **no mandatory attendance**, however attendance of discussion sessions is *highly suggested*!"

# ╔═╡ acc852c6-f5b7-11ea-2453-d1abcfbb6994
md"""
### 📘 Homework 
- Total of **5 graded homeworks** (+1 ungraded) worth 8 points each,
- Homeworks should be done *in pairs* (exceptions according to prior agreement).
- Homeworks will be due until the upcoming synchronous distance learning session.

> ✔️ Turn in your Homework in Moodle in *Portable Document Format* (PDF). 

When working in pairs (*highly* recommended):
- Stay in the **same pairing** for the whole semester
- *Every person* has to turn in the homework in Moodle
- Note both of your names in the final document
- Every person in a group gets the **same score**
"""

# ╔═╡ afd576fe-f5b7-11ea-11a4-654403973111
md"""
### 📝 Exam 
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

# ╔═╡ b929dab0-fccb-11ea-2281-714caa89d508
md"""
### Schedule

| Date | Time | Topic | Lesson type |
| ---: | :--- | :--- | :--- |
| 1.10. | 09:25-11:05 | Introduction | classroom lecture |
| 5.10. | - | Research design & planning (Homework 1)| video lecture |
| 12.10. | 15:45-17:20 | Previous lesson and homework | discussion session | 
| 27.10. | - | Descriptive statistics (Homework 2) | video lecture |
| 5.11.  | 16:35-17:20 | Previous lesson and homework | discussion session |
| 9.11. | - | Probability & inference (Homework 3) | video lecture |
| 16.11. | 15:45-17:20 | Previous lesson and homework | discussion session |
| 23.11. | - | Linear regression (Homework 4) | video lecture |
| 30.11. | - | Significance testing (Homework 5) | video lecture |
| 7.12. | 15:45-17:20 | Previous lessons, homework & exam prep | discussion session |
| 21.12. | 12:10-13:45 | Exam | classroom lecture
"""

# ╔═╡ b2b6ef4e-f5b7-11ea-3346-e5d980ee7168
md"""
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
2) Most of this course will require statistical software. There are many choices available, e.g. 

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

# ╔═╡ be96b69e-fbfc-11ea-1248-f1ce5af6579f
md"## Computational resources"

# ╔═╡ c9464f22-fbfc-11ea-2e98-4dbae9055340
md"This section can be safely ignored..."

# ╔═╡ 1405cda6-f8ee-11ea-2f12-89130cedd15f
center(x) = HTML("<div style='text-align: center'>$(Markdown.html(x))</div>")

# ╔═╡ e31c67a0-fc0f-11ea-3541-6143fbce5289
center(md"If you have any questions you can reach me at [philipp.gewessler@edu.fh-wien.ac.at](mailto:philipp.gewessler@edu.fh-wien.ac.at).")

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
- Link to video will be posted on Moodle

""", md"""
**💬 Discussion sessions**
- Zoom Meetings
- *Discussion* of homework and video lectures
- Place to **ask questions!** (If possible, ask them in the Moodle forum before the lecture)
""")

# ╔═╡ 21ad28d0-fbff-11ea-014f-27606020265e
begin
	plusminus(x::Number, y::Number) = (x - y, x + y)
	±(x, y) = plusminus(x, y)
end

# ╔═╡ 5ea86d30-fbff-11ea-1606-1d50b9d21e31
function ci(x, α = 0.05)
	est = mean(x)
	se = std(x)/sqrt(length(x))
	df = length(x) - 1
	est ± se * quantile(TDist(df), 1 - α/2)
end

# ╔═╡ f2f0daae-fbfd-11ea-06bc-edd8c65f2206
heights = MixtureModel(Normal, [(166, 8), (179, 10)], [0.48, 1 - 0.48])

# ╔═╡ 6d48ab80-fce9-11ea-3261-ab5af7748354
cdf(Normal(179, 10), 170)

# ╔═╡ 71333df0-fbfe-11ea-037f-c12ae8aff59c
begin
	new_sample
	sample = rand(heights, 40)
end


# ╔═╡ 7b1758f0-fcd6-11ea-32f2-d91f35dc7ae4
fitted = Normal(mean(sample), std(sample))

# ╔═╡ 445ea410-fcd8-11ea-2a84-fd96866c20b6
err = 0.2

# ╔═╡ eb429940-fcd7-11ea-10c6-890f9f9679c6
md"The average height of an adult in Austria is $(round(mean(sample), digits = 1)) centimeters. The $(Int(round((1 - err)*100, digits = 0)))% confidence interval of the estimate is $(round.(ci(sample, err), digits = 1))."

# ╔═╡ 8b45ed60-fcd9-11ea-10c0-175867dfe576
colors = ["#ef476f","#ffd166","#06d6a0","#118ab2","#073b4c"]

# ╔═╡ bb7d81d0-f5ce-11ea-3873-4b14b1c50ec3
begin
	plotrange = -3:0.01:3
	# PDF
	integral_range = -3:0.01:x_value
	sx = vcat(integral_range, reverse(integral_range))
	sy = vcat(pdf.(Normal(), integral_range), zeros(length(integral_range)))
	integral_range = -3:0.01:x_value
	pdf_plot = plot(Shape(sx, sy), color = colors[3], alpha = 0.1, linealpha = 0)
	plot!(plotrange, pdf.(Normal(), plotrange), legend = false, lw = 2, color = colors[3])
	
	# CDF
	cdf_plot = plot(plotrange, cdf.(Normal(), plotrange), legend = false, color = colors[3], lw = 2)
	plot!((x_value, cdf(Normal(), x_value)), seriestype = :scatter, color = colors[3], markersize=4)
	plot(pdf_plot, cdf_plot)
	plot!(size = (600, 250))
end

# ╔═╡ 812545f0-fbfe-11ea-20c7-35831f0ad609
histogram(sample, xlimits = [140, 220], bins = 10, legend = false, color = colors[4], linecolor = "white", yaxis = false)

# ╔═╡ 8c4d8772-fcdb-11ea-2c44-f57c88feded9
range = 140:0.1:220

# ╔═╡ 679dd4ae-fcd2-11ea-3fe9-f9ac3655fa40
population() = plot(range, pdf.(heights, range), xlimits = [140, 220], color = colors[1], ylimits = [0, 0.045], lw = 2, ribbon = (pdf.(heights, range), zeros(length(range))), fillalpha = 0.1, label = "population", yaxis = false, foreground_color_legend = nothing, background_color_legend = nothing)

# ╔═╡ e3e4ee12-fcdb-11ea-317b-65b71750aa71
population()

# ╔═╡ 8fc429e0-fcd6-11ea-2c80-f9c0bc2f3332
begin
	population()
	plot!(range, pdf.(fitted, range), label = "estimation", color = colors[4], lw = 2, ribbon = (pdf.(fitted, range), zeros(length(range))), fillalpha = 0.1)
end

# ╔═╡ 9af8fe52-fcde-11ea-2d3d-c74da830f2d4
begin
	reference = Normal(120, 12)
	target = Normal(140, 12)
	
	gc = rand(reference, 40)
	gt = rand(target, 40)
end

# ╔═╡ 64d9bfc0-fcdf-11ea-3d1d-5b265a6a0c6d
begin
	r = 75:0.1:185
	plot(r, pdf.(reference, r), label = "old website", color = colors[4], lw = 2, ribbon = (pdf.(reference, r), zeros(length(r))), fillalpha = 0.1, xlabel = "time spent on website", yaxis = false, foreground_color_legend = nothing, background_color_legend = nothing)
	plot!(r, pdf.(target, r), label = "new website", color = colors[2], lw = 2, ribbon = (pdf.(target, r), zeros(length(r))), fillalpha = 0.1)
end

# ╔═╡ f9411500-fcdf-11ea-0307-c7435d34f154
s = ((length(gc)-1)*std(gc) + (length(gt)-1)*std(gt))/(length(gc) + length(gt) - 2)

# ╔═╡ 89318820-fce0-11ea-0334-3b3d628107b0
t = (mean(gc) - mean(gt))/s

# ╔═╡ 99940530-fce0-11ea-06ba-93de00e71f17
sig_level = 0.05

# ╔═╡ a3ee2ab0-fce0-11ea-0788-d3d13e3c3a76
cutoff = quantile(TDist(length(gc) + length(gt) - 2), 1 - sig_level/2)

# ╔═╡ d3c33140-fce0-11ea-0533-63559b18a8f0
decision = abs(t) > cutoff

# ╔═╡ 9d1b3ab0-fce1-11ea-208c-356ee3bd371f
begin
	if decision
		md"Based on our test statistic t($(length(gc) + length(gt) - 2)) = $(round(abs(t), digits = 2)) we can conclude that the new website leads to more engagement."
	else
		md"The cannot conclude that the new website leads to more engagement"
	end
end

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

# ╔═╡ 74e2cad0-fce2-11ea-3498-cde2cea55dc3
md"For a person with a midterm test score of $midterm we predict a endterm test score of $(Int(round(α + midterm * β)))."

# ╔═╡ d79ea8f2-f5c8-11ea-1776-a9385d0efee5
y_hat = predict(ols_fit)

# ╔═╡ 319f9176-f5c9-11ea-219f-e713853fc37d
resid = y - y_hat

# ╔═╡ 7d3f577a-f5cb-11ea-134a-f5482f307912
rect(w, h, x, y) = Shape(x .+ [0, w, w, 0], y .+ [0, 0, h, h])

# ╔═╡ a08492ea-f5c6-11ea-2901-f349f6498e33
begin
	fig = plot(x, y, seriestype = :scatter, legend = false, xlimit = [0, 100], ylimit = [0, 100], aspect_ratio = :equal, xlabel = "test score (midterm)", ylabel = "test score (endterm)", markercolor = colors[4], markerstrokecolor = colors[4])
	Plots.abline!(β, α, lw = 2, color = colors[1])

	for i = 1:n
		plot!(rect(-resid[i], resid[i], x[i], y_hat[i]), fillalpha = 0.2, color = colors[5], linealpha = 0)
	end
	
	fig
end

# ╔═╡ Cell order:
# ╟─39d4ca10-f427-11ea-2d6d-4392d7df0183
# ╟─2e0c4ab0-f42b-11ea-1d7e-e18c5d37e4cf
# ╟─e31c67a0-fc0f-11ea-3541-6143fbce5289
# ╟─57fbc3f0-f42b-11ea-3192-4d048c9b1208
# ╠═cd4bcafa-f5be-11ea-3508-0d436b24bf33
# ╟─d5b2acb4-f5be-11ea-3392-f9d0aacc0e7e
# ╠═0c7e1a42-f5d2-11ea-1d6f-b1a2cded18ba
# ╟─bb7d81d0-f5ce-11ea-3873-4b14b1c50ec3
# ╟─e75f6dae-fbfd-11ea-2b29-33b9c4082535
# ╟─e3e4ee12-fcdb-11ea-317b-65b71750aa71
# ╟─812545f0-fbfe-11ea-20c7-35831f0ad609
# ╠═8fc429e0-fcd6-11ea-2c80-f9c0bc2f3332
# ╟─a744a580-fcdc-11ea-004c-9d0b84968438
# ╟─eb429940-fcd7-11ea-10c6-890f9f9679c6
# ╟─dab70702-f5be-11ea-2201-7fbfffd42c20
# ╟─a19219a0-fcdd-11ea-2884-3bc702738f12
# ╟─a08492ea-f5c6-11ea-2901-f349f6498e33
# ╟─fa21f7c0-fce2-11ea-3202-4b8fd9bd5136
# ╟─74e2cad0-fce2-11ea-3498-cde2cea55dc3
# ╟─f19592ea-f5be-11ea-3403-cbd6c9840a32
# ╠═64d9bfc0-fcdf-11ea-3d1d-5b265a6a0c6d
# ╟─9d1b3ab0-fce1-11ea-208c-356ee3bd371f
# ╟─6870907e-f42b-11ea-2c27-8b5bf45d06f3
# ╟─409bd216-f8f1-11ea-2ecb-8188ab05d9ef
# ╟─27c2fec0-fccc-11ea-2e18-8923216f61c1
# ╟─acc852c6-f5b7-11ea-2453-d1abcfbb6994
# ╟─afd576fe-f5b7-11ea-11a4-654403973111
# ╟─65195ddc-f8ee-11ea-2902-0d0e3a14c7d0
# ╟─1e5060c8-f8ee-11ea-3532-69b3322d6045
# ╟─4bdeb60a-f8ee-11ea-2e18-09c211cb061d
# ╟─1e512524-f8ee-11ea-1501-5d62eea4f4d5
# ╟─b32fc9fa-f8f0-11ea-008a-c3dacabaffbf
# ╟─b929dab0-fccb-11ea-2281-714caa89d508
# ╟─b2b6ef4e-f5b7-11ea-3346-e5d980ee7168
# ╟─6f6412e6-f5bf-11ea-0495-2d22aeefc492
# ╟─c4005d80-f5d2-11ea-1cf7-b50392525cb5
# ╟─be96b69e-fbfc-11ea-1248-f1ce5af6579f
# ╟─c9464f22-fbfc-11ea-2e98-4dbae9055340
# ╠═503367b4-f5c6-11ea-0838-910afc85b4f3
# ╠═1405cda6-f8ee-11ea-2f12-89130cedd15f
# ╠═166dbb10-f8ee-11ea-0973-d511f7a6f02c
# ╠═21ad28d0-fbff-11ea-014f-27606020265e
# ╠═5ea86d30-fbff-11ea-1606-1d50b9d21e31
# ╠═f2f0daae-fbfd-11ea-06bc-edd8c65f2206
# ╠═6d48ab80-fce9-11ea-3261-ab5af7748354
# ╠═71333df0-fbfe-11ea-037f-c12ae8aff59c
# ╟─7b1758f0-fcd6-11ea-32f2-d91f35dc7ae4
# ╠═445ea410-fcd8-11ea-2a84-fd96866c20b6
# ╟─8b45ed60-fcd9-11ea-10c0-175867dfe576
# ╟─8c4d8772-fcdb-11ea-2c44-f57c88feded9
# ╠═679dd4ae-fcd2-11ea-3fe9-f9ac3655fa40
# ╟─9af8fe52-fcde-11ea-2d3d-c74da830f2d4
# ╟─f9411500-fcdf-11ea-0307-c7435d34f154
# ╠═89318820-fce0-11ea-0334-3b3d628107b0
# ╠═99940530-fce0-11ea-06ba-93de00e71f17
# ╠═a3ee2ab0-fce0-11ea-0788-d3d13e3c3a76
# ╠═d3c33140-fce0-11ea-0533-63559b18a8f0
# ╠═6383026c-f5c6-11ea-0bf3-b921b30c01f8
# ╠═6bf2def6-f5c6-11ea-18ec-c7e7a1194767
# ╠═349992a4-f5c8-11ea-2e68-4f440a089704
# ╠═ad490ec8-f5c8-11ea-2b3a-b19655e14edb
# ╠═63c76358-f5c8-11ea-17a8-71ff55e9841c
# ╠═ac41c918-f5c6-11ea-1ba3-a5a92d45b990
# ╠═d79ea8f2-f5c8-11ea-1776-a9385d0efee5
# ╠═319f9176-f5c9-11ea-219f-e713853fc37d
# ╠═7d3f577a-f5cb-11ea-134a-f5482f307912

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
	Pkg.add("CSV")
	Pkg.add("HTTP")
	using Distributions, Plots, GLM, DataFrames, PlutoUI, CSV, HTTP
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

# ╔═╡ 5139d928-fe65-11ea-2650-0b2596c6f4cf
md"##"  # Dummy section for presentation

# ╔═╡ cc2e7da8-fe3f-11ea-25b8-3753accab312
@bind sample_new_item Button("Draw new item")

# ╔═╡ 84001352-fe3f-11ea-3e6a-d3338b4ce59d
begin
	sample_new_item
	difficulty = rand(Normal())
	dif = rand(Normal(0, 0.5))
	theta_range = -3:0.01:3
	p_male = Logistic(Real(-difficulty - 0.5*dif), 1) 
	p_female = Logistic(Real(-difficulty + 0.5*dif), 1) 
	plot(theta_range, cdf.(p_male, theta_range), label = "male", ylimits = [0, 1], xlabel = "Ability", ylabel = "Probability of correct answer", legend = :topleft, foreground_color_legend = nothing, background_color_legend = nothing)
	plot!(theta_range, cdf.(p_female, theta_range), label = "female")
end

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

# ╔═╡ 6996c652-fe65-11ea-03eb-eb2ac6a7386e
md"##"  # Dummy section for presentation

# ╔═╡ cd4bcafa-f5be-11ea-3508-0d436b24bf33
md"""
### Descriptive statistics

Learn how to describe quantitative data *numerically* and *visually*.
"""

# ╔═╡ 792ca55a-fe65-11ea-000a-ef64f124b28e
md"**Univariate statistics**"

# ╔═╡ 70f2c61c-fe65-11ea-2882-e3e71e171cf1
md"##"  # Dummy section for presentation

# ╔═╡ 96472662-fe65-11ea-366f-33aaf7af81ba
md"**Bivariate statistics**"

# ╔═╡ 74bd633a-fe4a-11ea-0095-75cf840d8913
md"true correlation: $(@bind true_correlation Slider(-1:0.01:1, default = .33))"

# ╔═╡ 3e274542-fe4b-11ea-222f-f1b803d04ef4
@bind new_sample_scatter Button("Draw new sample")

# ╔═╡ a1f2dbf8-fe65-11ea-3f03-6702b498fdf6
md"##"  # Dummy section for presentation

# ╔═╡ 46aca280-fe43-11ea-0c9e-4f7a6a43ab69
md"IQ value: $(@bind x_value Slider(60:140, default = 100))"

# ╔═╡ d5b2acb4-f5be-11ea-3392-f9d0aacc0e7e
md"""
### Probability
Get to know the basics of *probability theory* and *probability distributions*.

What is the probability of having an IQ smaller or equal than $(x_value)?
"""

# ╔═╡ a928ff42-fe65-11ea-0d0e-87285b83ee45
md"##"  # Dummy section for presentation

# ╔═╡ e75f6dae-fbfd-11ea-2b29-33b9c4082535
md"""
### Statistical inference

The goal of statistical inference is to *estimate* some numerical quantity of a population from a sample. 

For example we could be interested in the *height* of the adult population in Austria,
"""

# ╔═╡ a744a580-fcdc-11ea-004c-9d0b84968438
@bind new_sample Button("Draw new sample")

# ╔═╡ b15ac416-fe65-11ea-3d26-7f5efd2e30a7
md"##"  # Dummy section for presentation

# ╔═╡ dab70702-f5be-11ea-2201-7fbfffd42c20
md"""
### Linear regression
"""

# ╔═╡ a19219a0-fcdd-11ea-2884-3bc702738f12
md"Aside from estimation we are also interested in *predicting* future observations."

# ╔═╡ fa21f7c0-fce2-11ea-3202-4b8fd9bd5136
md"midterm score: $(@bind midterm NumberField(0:100, default = 20))"

# ╔═╡ 3362570e-fe4c-11ea-1879-8397dd0f2df8
md"show prediction: $(@bind show_prediction CheckBox())"

# ╔═╡ b6f9165c-fe65-11ea-0f9c-3b31970a66e8
md"##"  # Dummy section for presentation

# ╔═╡ f19592ea-f5be-11ea-3403-cbd6c9840a32
md"""
### Testing
Sometimes it can be necessary to generate *decisions* from uncertain data. One such question could be: Does our new website generate more engagement? 
"""

# ╔═╡ c75f2f28-fe41-11ea-1d88-896fb457e5ce
@bind new_sample_nhst Button("Draw new sample")

# ╔═╡ 6870907e-f42b-11ea-2c27-8b5bf45d06f3
md"""
## How does this course work?
### Lectures
"""

# ╔═╡ 27c2fec0-fccc-11ea-2e18-8923216f61c1
md"> Due to COVID-19 there is **no mandatory attendance**, however attendance of discussion sessions is *highly suggested*! The content of discussion will be part of the exam."

# ╔═╡ bf2d41ea-fe65-11ea-2bc0-01ed5455c0c5
md"##"  # Dummy section for presentation

# ╔═╡ acc852c6-f5b7-11ea-2453-d1abcfbb6994
md"""
### 📘 Homework 
- Total of **5 graded homework exercises** (+1 ungraded) worth 8 points each,
- Homeworks should be done *in pairs* (exceptions according to prior agreement).
- Homeworks will be due until the upcoming synchronous distance learning session.

> ✔️ Turn in your Homework in Moodle in *Portable Document Format* (PDF). 

When working in pairs (*highly* recommended):
- Stay in the **same pairing** for the whole semester
- *Every person* has to turn in the homework in Moodle
- Note both of your names in the final document
- Every person in a group gets the **same score**
"""

# ╔═╡ 3d9db834-fe3e-11ea-1b85-57ab8ff02df3
md"> ⚡ Homework exercises can include calculation by hand or in software."

# ╔═╡ c25587d8-fe65-11ea-3eee-19e4ceadb66b
md"##"  # Dummy section for presentation

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
md"> ⚠️ **No calculations** (e.g. means, variances, test statistics, ...) **required**, but be prepared to interpret results and software output!"

# ╔═╡ ccd0d4e2-fe65-11ea-0e03-5b16977c6957
md"##"  # Dummy section for presentation

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

# ╔═╡ c69bf994-fe65-11ea-290d-15e62af5c841
md"##"  # Dummy section for presentation

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

# ╔═╡ ca0b715e-fe65-11ea-17e2-57d034bd8dea
md"##"  # Dummy section for presentation

# ╔═╡ 6f6412e6-f5bf-11ea-0495-2d22aeefc492
md"""
### Software
1) My notebooks will make extensive use of interactivity. Installing [Julia](https://julialang.org/) and [Pluto.jl](https://github.com/fonsp/Pluto.jl) is required for this to work correctly.  

> ✔️ Static HTML versions will be provided if you do not want to install additional software.

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
3. Work out your pairings for the homework exercises,
4. Fill in the [student questionnaire](https://forms.gle/ZJ87NWpVk2inHbzBA).

> 🙋 The data will **exclusively** be used for examples and homeworks in this course!

This homework will **not** be graded!
"""

# ╔═╡ 1af8fcfe-ff0f-11ea-3d8d-8794f99dda17
md"##"  # Dummy section for presentation

# ╔═╡ 8a8b7788-fe4d-11ea-1836-3567773cd690
md"## Why is statistics important?"

# ╔═╡ 4662e85e-ff0b-11ea-1c8a-f3f787003fea
md"""
Statistics provides us with methods to: 

- Reduce complexity in the data and make it interpretable
- Infer (conceptual) quantities that do not exist in the real world or cannot be observed directly (e.g. R0 of an infectious disease)
- Help us make decisions und uncertain conditions
- Predict future events based on collected data
"""

# ╔═╡ 6d43a5a8-ff10-11ea-0aed-693d96769fdf
md"##"  # Dummy section for presentation

# ╔═╡ b50d2656-fe4e-11ea-023d-ebd9048e4bf8
md"""
### Understanding the world
"""

# ╔═╡ af7daf68-fe6b-11ea-3d27-bb3714fc249d
md"###### Example: Cherry blossom in Kyoto"

# ╔═╡ cc400cc0-fefe-11ea-07a5-1533d4060ee4
md"""
![](https://sugoii-japan.com/wp-content/uploads/2020/03/Best-Cherry-Blossom-Sakura-Spots-in-Kyoto-Daigo-ji-Temple-1-1600x900.jpg)

- Important event in Japanese culture
- The dates of cherry blossom in Kyoto have been documented for more than 1000 years!
- They typically bloom in mid April, but *highly dependent* on temperatures in February and March
- Temperature data can be reconstructed (estimated) by cherry blossom date
- Temperature reconstruction suggests historical *cold periods* due to reduced *solar activity*
- Influence of solar activity on temperature reduced since the 20th century due to e.g. greenhouse gases
"""

# ╔═╡ ee3851fe-ff04-11ea-3584-b5ecb2a5b4a2
md"-- Aono & Kazui (2008). Phenological data series of cherry tree ﬂowering in Kyoto,Japan, and its application to reconstruction of springtimetemperatures since the 9th century. *Int. J. Climatol. 28*. [📄](https://rmets.onlinelibrary.wiley.com/doi/epdf/10.1002/joc.1594)"

# ╔═╡ 879ac970-ff05-11ea-2111-abe94a5ceacf
md"For a more gentle introduction to the topic see [this](https://public.tableau.com/views/CherryblossomphenologyandtemperaturereconstructionsatKyoto/Dashboard1?%3Aembed=y&%3AshowVizHome=no&%3Adisplay_count=y&%3Adisplay_static_image=y&%3AbootstrapWhenNotified=true)."

# ╔═╡ e3f419c0-ff05-11ea-2ef0-6ff0dc682731
md"show solar minima: $(@bind solar_minima CheckBox())"

# ╔═╡ 77311152-ff10-11ea-3b85-d7e10be6e501
md"##"  # Dummy section for presentation

# ╔═╡ 920ad230-fe4d-11ea-0c3e-0d7e731eb7aa
md"### Decision-making in the real world"

# ╔═╡ ca65bbe4-fe4e-11ea-1302-f3685c4d917b
md"**The problem:** Evidence and data are uncertain. How can we guarantee to make the *best* decision under these circumstances?"

# ╔═╡ 02936052-fe66-11ea-1510-11f1524cb289
md"##"  # Dummy section for presentation

# ╔═╡ 54e3badc-fe4f-11ea-1b32-03b5497dc105
md"###### Example: COVID-19 risk assessment in Austria ('Corona-Ampel')"

# ╔═╡ e4a9dc8c-fe4f-11ea-03f4-bb9de7b04582
md"""
Assessment of risk includes *quantitative criteria*:

*Transmissibility*
- Number of cases (7 day average)
- Incidence (7 day average)
- Number of new clusters (calender week)
- Number of districts with new clusters (calender week)
- Number of districts without new clusters (calender week)

*Case & Contact tracing* 
- Number of cases with known sources (by transmission source)

*Ressources*
- Indicators of system capacity (e.g. bed occupancy)

*Testing*
- Rate of tests with positive results
- Relative number of tests to population size (7 day average)

Quantitative criteria together with *qualitative assessment* yields decisions about risk at the district level.

-- Corona-Ampel Bewertungskriterien [🌐](https://corona-ampel.gv.at/corona-kommission/bewertungskriterien/) (24.9.2020)
"""

# ╔═╡ 2b32a890-fe56-11ea-2e9d-0d29583403d4
html"""<iframe title="Die Corona-Ampel" aria-label="Karte" id="datawrapper-chart-m8ujA" src="https://datawrapper.dwcdn.net/m8ujA/13/" scrolling="no" frameborder="0" style="border: none;" width="100%" height="491"></iframe>"""

# ╔═╡ d286f844-fe65-11ea-34e9-f1d0c0e88c3e
md"##"  # Dummy section for presentation

# ╔═╡ 172fcdfe-fe57-11ea-2fa8-3754346967cc
md"""
### Prediction

###### Example: 2020 presidential election forecast in the USA

- statistical models are highly relevant in predicting election results
- statistical analysis/modelling is not *objective* -- different models might yield different results

We can compare two popular forecasts:
"""

# ╔═╡ e289d8c4-fe65-11ea-394c-231d0465ac5b
md"##"  # Dummy section for presentation

# ╔═╡ 031507a2-fe58-11ea-0b1e-3dbca6f40310
md"### Statistical literacy"

# ╔═╡ aa1e0856-ff09-11ea-2e6e-2f157875a7a7
html"""<blockquote class="twitter-tweet"><p lang="en" dir="ltr">AfD makes a formal request with the German government about how many people in Germany earn below median income. With that secures the content of „why do we have to learn stats“ intro slides for the next years. h/t <a href="https://twitter.com/erik_fluegge?ref_src=twsrc%5Etfw">@erik_fluegge</a> <a href="https://t.co/L3ueNL1vTv">pic.twitter.com/L3ueNL1vTv</a></p>&mdash; Tarik Abou-Chadi (@tabouchadi) <a href="https://twitter.com/tabouchadi/status/1309159182810185729?ref_src=twsrc%5Etfw">September 24, 2020</a></blockquote><script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>"""

# ╔═╡ 81327a78-fe5a-11ea-2677-17a44aa9c1cc
md"""
- Even professional scientists or whole scientific fields sometimes struggle with adequate application of statistical procedures.
- This can lead to nonsensical and bizarre results
- Do not blindly trust, but *critically deal with published results*
"""

# ╔═╡ 103cbca0-fe66-11ea-1c34-abcf94ffa7d4
md"##"  # Dummy section for presentation

# ╔═╡ a4ce85d8-fe5a-11ea-0068-9db0d73d960b
md"###### Example: Brain activity in a dead atlantic salmon"

# ╔═╡ 175495f4-fe5b-11ea-0d42-fb68eb160e10
Resource("https://www.wired.com/images_blogs/wiredscience/2009/09/fmri-salmon.jpg", :width => "80%")

# ╔═╡ c9c127d8-fe5e-11ea-0535-a108365def2b
md"""
In this case:
- Study specifically designed to expose common but bad statistical practices in the field of funcional neuroscience
- Make an argument for the adoption of new methods to avoid spurious results (controlling **false discovery rate**)

"""

# ╔═╡ 25ce569e-fe59-11ea-150d-fbef155f1792
md"-- Bennett, C. M., Miller, M. B., & Wolford, G. L. (2009). Neural correlates of interspecies perspective taking in the post-mortem Atlantic Salmon: An argument for multiple comparisons correction. *Neuroimage, 47*. [📄](http://prefrontal.org/files/posters/Bennett-Salmon-2009.pdf)"

# ╔═╡ 544cab20-fe5d-11ea-12cc-27e19f290602
md"> ☝️ Acquiring statistical knowledge is important to determine which results you can trust!"

# ╔═╡ 3e716968-fe66-11ea-25aa-4b930fd8e083
md"##"  # Dummy section for presentation

# ╔═╡ be96b69e-fbfc-11ea-1248-f1ce5af6579f
md"## Computational resources"

# ╔═╡ c9464f22-fbfc-11ea-2e98-4dbae9055340
md"This section can be safely ignored..."

# ╔═╡ 1405cda6-f8ee-11ea-2f12-89130cedd15f
center(x) = HTML("<div style='text-align: center'>$(Markdown.html(x))</div>")

# ╔═╡ 4bfc0656-fe61-11ea-1fba-111ac02fe4ec
center(md"#### Statistics")

# ╔═╡ 5676e856-fe61-11ea-3d7d-2bf6a238dd58
center(md"Module: Research Skills & Methods 1")

# ╔═╡ 3e23ee60-0319-11eb-32de-ffee21acd141
center(md"Philipp Gewessler")

# ╔═╡ 806cef86-fe61-11ea-08bd-7ba2b43302cf
center(md"1.10.2020")

# ╔═╡ e31c67a0-fc0f-11ea-3541-6143fbce5289
center(md"If you have any questions you can reach me at [philipp.gewessler@edu.fh-wien.ac.at](mailto:philipp.gewessler@edu.fh-wien.ac.at).")

# ╔═╡ 65195ddc-f8ee-11ea-2902-0d0e3a14c7d0
center(md"First possible date on *21.12.2020*!")

# ╔═╡ b50a66fa-fe4e-11ea-0d8d-737bdbb637a7
center(md"Solutions to many decision problems in the real world have a statistical justification!")

# ╔═╡ 8122d91a-fe5a-11ea-14e4-6de3ce95b5a0
center(md"Statistics can be *hard* and unintuitive at times!")

# ╔═╡ 99f2635c-fe5d-11ea-13ca-ad3b654f18a9
center(md"This raises the question: *When can we trust statistical results and interpretations thereof?*")

# ╔═╡ 2f0967ba-fe60-11ea-297a-73d810159d0d
center(md"###### The goal of this course is to give you the basic skillset produce well-founded statistical analyses and evaluate claims based on statistical procedures.")

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
- Notebooks will be available on Moodle

""", md"""
**💬 Discussion sessions**
- Zoom Meetings
- *Discussion* of homework and video lectures
- Place to **ask questions!** (If possible, ask them in the Moodle forum before the lecture)
""")

# ╔═╡ 4b193ebc-ff23-11ea-039a-c9a06dae1118
two_columns(center(md"[FiveThirtyEight](https://projects.fivethirtyeight.com/2020-election-forecast/)"), center(md"[The Economist](https://projects.economist.com/us-2020-forecast/president)"))

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

# ╔═╡ 121d98a0-fe48-11ea-39bf-2ff19f6313f5
begin
	grade_levels = ["very good", "good", "satisfactory", "sufficient", "insufficient"]
	grades = [6.9, 13.3, 28.2, 30.2, 21.4]
	
	plot(grade_levels, grades, seriestype = :bar, color = colors[4], linecolor = "white", legend = false)
end

# ╔═╡ 0fc1cd90-fe4a-11ea-2046-4975267fa355
md"""
The relative frequency of *satisfactory* assessments is $(grades[3]/100).
"""

# ╔═╡ 51ab3302-fe4a-11ea-2494-c7fc73689e31
begin
	new_sample_scatter
	scatter_x = rand(Normal(), 200)
	scatter_y = scatter_x * true_correlation .+ rand(Normal(0, 1), 200)
	plot(scatter_x, scatter_y, seriestype = :scatter, xlimits = [-4, 4], ylimits = [-4, 4], yaxis = false, xaxis = false, legend = false, color = colors[1])
end

# ╔═╡ f23b333c-fe4a-11ea-2847-aff82185116e
md"The observed correlaton is $(round(cor(scatter_x, scatter_y), digits = 2))."

# ╔═╡ bb7d81d0-f5ce-11ea-3873-4b14b1c50ec3
begin
	IQDist = Normal(100, 15)
	plotrange = 50:0.1:150
	# PDF
	integral_range = minimum(plotrange):0.01:x_value
	sx = vcat(integral_range, reverse(integral_range))
	sy = vcat(pdf.(IQDist, integral_range), zeros(length(integral_range)))
	pdf_plot = plot(Shape(sx, sy), color = colors[3], alpha = 0.1, linealpha = 0, xlabel = "IQ", ylabel = "density")
	plot!(plotrange, pdf.(IQDist, plotrange), legend = false, lw = 2, color = colors[3])
	
	# CDF
	cdf_plot = plot(plotrange, cdf.(IQDist, plotrange), legend = false, color = colors[3], lw = 2, xlabel = "IQ", ylabel = "P(X ≤ x)")
	plot!((x_value, cdf(IQDist, x_value)), seriestype = :scatter, color = colors[3], markersize=4)
	plot(pdf_plot, cdf_plot)
	plot!(size = (600, 250))
end

# ╔═╡ cd576e5c-fe43-11ea-1208-137fc9784a5b
md"The probability is P(IQ ≤ $x_value) = $(round(cdf(IQDist, x_value), digits = 2))."

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
	new_sample_nhst
	reference = Normal(120, 12)
	target = Normal(145, 12)
	
	gc = rand(reference, 40)
	gt = rand(target, 40)
end

# ╔═╡ 64d9bfc0-fcdf-11ea-3d1d-5b265a6a0c6d
begin
	r = 75:0.1:185
	plot(r, pdf.(reference, r), label = "old website", color = colors[4], lw = 2, ribbon = (pdf.(reference, r), zeros(length(r))), fillalpha = 0.1, xlabel = "time spent on website", yaxis = false, foreground_color_legend = nothing, background_color_legend = nothing)
	plot!(r, pdf.(target, r), label = "new website", color = colors[2], lw = 2, ribbon = (pdf.(target, r), zeros(length(r))), fillalpha = 0.1)
end

# ╔═╡ c19ca424-fe41-11ea-3292-0fc5e770b477
begin
	histogram(gc, color = colors[4], foreground_color_legend = nothing, background_color_legend = nothing, label = "old website", alpha = 0.8, linecolor = "white", bins = 10, yaxis = false, xlimits = [minimum(r), maximum(r)])
	histogram!(gt, color = colors[2], label = "new_website", alpha = 0.8, linecolor = "white", bins = 10)
end

# ╔═╡ 881e9690-fe42-11ea-3c77-9536a8271f76
md"mean group difference: $(round(mean(gt) - mean(gc))) seconds"

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
		md"Based on our test statistic t($(length(gc) + length(gt) - 2)) = $(round(abs(t), digits = 2)) we cannot conclude that the new website leads to more engagement."
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
	fig = plot(x, y, seriestype = :scatter, legend = false, xlimit = [0, 100], ylimit = [0, 100], aspect_ratio = :equal, xlabel = "test score (midterm)", ylabel = "test score (endterm)", markercolor = colors[4])
	Plots.abline!(β, α, lw = 2, color = colors[1])

	for i = 1:n
		plot!(rect(-resid[i], resid[i], x[i], y_hat[i]), fillalpha = 0.2, color = colors[5], linealpha = 0)
	end
	
	if show_prediction
		plot!([midterm, midterm], [-5, α + midterm * β], color = colors[5], line = (:dash, 1))
		plot!([-5, midterm], [α + midterm * β, α + midterm * β], color = colors[5], line = (:dash, 1))
		plot!([midterm], [α + midterm * β], seriestype = :scatter, color = colors[5], markersize = 4)
	end
	fig
end

# ╔═╡ b70c3ba4-fe73-11ea-10d3-4d6a040e0b1b
begin
	cherry_blossom = DataFrame(CSV.File(HTTP.get("https://raw.githubusercontent.com/rmcelreath/rethinking/master/data/cherry_blossoms.csv").body; missingstrings = ["NA"]))
	cherry_blossom = cherry_blossom[completecases(cherry_blossom), :]
end

# ╔═╡ 16d51626-ff00-11ea-38f4-615272f1bee0
md"minimum year: $(@bind min_year NumberField(minimum(cherry_blossom[:,:year]):maximum(cherry_blossom[:,:year]), default=minimum(cherry_blossom[:,:year])))"

# ╔═╡ 5f0e09c0-ff00-11ea-17ce-1b9880406aad
md"maximum year: $(@bind max_year NumberField(min_year:maximum(cherry_blossom[:,:year]), default=maximum(cherry_blossom[:,:year])))"

# ╔═╡ 3ce5a83a-fe74-11ea-0740-ef5358e528fc
begin
	pd = cherry_blossom[min_year .<= cherry_blossom[:year] .<= max_year, :]
	doy_diff = pd.doy .- mean(cherry_blossom[:,:doy])
	temp_diff = pd.temp .- mean(cherry_blossom[:, :temp])
	p1 = plot(pd.year, doy_diff, legend = false, seriestype = [:line, :scatter], color = colors[3], ylabel = "day differential", ylimits = [-20, 20], xlimits = [min_year, max_year])
	p2 = plot(pd.year, temp_diff, seriestype = [:line, :scatter], color = colors[2], legend = false, ylabel = "temperature differential", xlabel = "year", ylimits = [-2.5, 2.5], xlimits = [min_year, max_year])
	
	if solar_minima
		plot!(rect(40, 6, 1100, -3), fillalpha = 0.2, color = colors[5], linealpha = 0)
		plot!(rect(60, 6, 1280, -3), fillalpha = 0.2, color = colors[5], linealpha = 0)
		plot!(rect(150, 6, 1420, -3), fillalpha = 0.2, color = colors[5], linealpha = 0)
		plot!(rect(70, 6, 1645, -3), fillalpha = 0.2, color = colors[5], linealpha = 0)
		plot!(rect(30, 6, 1790, -3), fillalpha = 0.2, color = colors[5], linealpha = 0)
	end
	
	plot(p1, p2, layout = (2, 1))
	plot!(size = (680, 400))
end

# ╔═╡ f3d57ac8-fe76-11ea-2aca-395697343f4c
plot(temp_diff, doy_diff, seriestype = :scatter, legend = false, ylabel = "day differential", xlabel = "temperature differential", color = colors[4])

# ╔═╡ 2114e430-ff01-11ea-3df6-dd0d6b561d0a
md"the correlation between mean march temperature and cherry blossom date between $min_year and $max_year is $(round(cor(temp_diff, doy_diff), digits = 2))."

# ╔═╡ Cell order:
# ╟─39d4ca10-f427-11ea-2d6d-4392d7df0183
# ╟─4bfc0656-fe61-11ea-1fba-111ac02fe4ec
# ╟─5676e856-fe61-11ea-3d7d-2bf6a238dd58
# ╟─3e23ee60-0319-11eb-32de-ffee21acd141
# ╟─806cef86-fe61-11ea-08bd-7ba2b43302cf
# ╟─2e0c4ab0-f42b-11ea-1d7e-e18c5d37e4cf
# ╟─5139d928-fe65-11ea-2650-0b2596c6f4cf
# ╟─cc2e7da8-fe3f-11ea-25b8-3753accab312
# ╟─84001352-fe3f-11ea-3e6a-d3338b4ce59d
# ╟─e31c67a0-fc0f-11ea-3541-6143fbce5289
# ╟─57fbc3f0-f42b-11ea-3192-4d048c9b1208
# ╟─6996c652-fe65-11ea-03eb-eb2ac6a7386e
# ╟─cd4bcafa-f5be-11ea-3508-0d436b24bf33
# ╟─792ca55a-fe65-11ea-000a-ef64f124b28e
# ╟─0fc1cd90-fe4a-11ea-2046-4975267fa355
# ╟─121d98a0-fe48-11ea-39bf-2ff19f6313f5
# ╟─70f2c61c-fe65-11ea-2882-e3e71e171cf1
# ╟─96472662-fe65-11ea-366f-33aaf7af81ba
# ╟─51ab3302-fe4a-11ea-2494-c7fc73689e31
# ╟─74bd633a-fe4a-11ea-0095-75cf840d8913
# ╟─3e274542-fe4b-11ea-222f-f1b803d04ef4
# ╟─f23b333c-fe4a-11ea-2847-aff82185116e
# ╟─a1f2dbf8-fe65-11ea-3f03-6702b498fdf6
# ╟─d5b2acb4-f5be-11ea-3392-f9d0aacc0e7e
# ╟─46aca280-fe43-11ea-0c9e-4f7a6a43ab69
# ╟─bb7d81d0-f5ce-11ea-3873-4b14b1c50ec3
# ╟─cd576e5c-fe43-11ea-1208-137fc9784a5b
# ╟─a928ff42-fe65-11ea-0d0e-87285b83ee45
# ╟─e75f6dae-fbfd-11ea-2b29-33b9c4082535
# ╟─e3e4ee12-fcdb-11ea-317b-65b71750aa71
# ╟─812545f0-fbfe-11ea-20c7-35831f0ad609
# ╟─8fc429e0-fcd6-11ea-2c80-f9c0bc2f3332
# ╟─a744a580-fcdc-11ea-004c-9d0b84968438
# ╟─eb429940-fcd7-11ea-10c6-890f9f9679c6
# ╟─b15ac416-fe65-11ea-3d26-7f5efd2e30a7
# ╟─dab70702-f5be-11ea-2201-7fbfffd42c20
# ╟─a19219a0-fcdd-11ea-2884-3bc702738f12
# ╟─a08492ea-f5c6-11ea-2901-f349f6498e33
# ╟─fa21f7c0-fce2-11ea-3202-4b8fd9bd5136
# ╟─3362570e-fe4c-11ea-1879-8397dd0f2df8
# ╟─74e2cad0-fce2-11ea-3498-cde2cea55dc3
# ╟─b6f9165c-fe65-11ea-0f9c-3b31970a66e8
# ╟─f19592ea-f5be-11ea-3403-cbd6c9840a32
# ╟─64d9bfc0-fcdf-11ea-3d1d-5b265a6a0c6d
# ╟─c19ca424-fe41-11ea-3292-0fc5e770b477
# ╟─c75f2f28-fe41-11ea-1d88-896fb457e5ce
# ╟─881e9690-fe42-11ea-3c77-9536a8271f76
# ╟─9d1b3ab0-fce1-11ea-208c-356ee3bd371f
# ╟─6870907e-f42b-11ea-2c27-8b5bf45d06f3
# ╟─409bd216-f8f1-11ea-2ecb-8188ab05d9ef
# ╟─27c2fec0-fccc-11ea-2e18-8923216f61c1
# ╟─bf2d41ea-fe65-11ea-2bc0-01ed5455c0c5
# ╟─acc852c6-f5b7-11ea-2453-d1abcfbb6994
# ╟─3d9db834-fe3e-11ea-1b85-57ab8ff02df3
# ╟─c25587d8-fe65-11ea-3eee-19e4ceadb66b
# ╟─afd576fe-f5b7-11ea-11a4-654403973111
# ╟─65195ddc-f8ee-11ea-2902-0d0e3a14c7d0
# ╟─1e5060c8-f8ee-11ea-3532-69b3322d6045
# ╟─4bdeb60a-f8ee-11ea-2e18-09c211cb061d
# ╟─1e512524-f8ee-11ea-1501-5d62eea4f4d5
# ╟─b32fc9fa-f8f0-11ea-008a-c3dacabaffbf
# ╟─ccd0d4e2-fe65-11ea-0e03-5b16977c6957
# ╟─b2b6ef4e-f5b7-11ea-3346-e5d980ee7168
# ╟─c69bf994-fe65-11ea-290d-15e62af5c841
# ╟─b929dab0-fccb-11ea-2281-714caa89d508
# ╟─ca0b715e-fe65-11ea-17e2-57d034bd8dea
# ╟─6f6412e6-f5bf-11ea-0495-2d22aeefc492
# ╟─c4005d80-f5d2-11ea-1cf7-b50392525cb5
# ╟─1af8fcfe-ff0f-11ea-3d8d-8794f99dda17
# ╟─8a8b7788-fe4d-11ea-1836-3567773cd690
# ╟─4662e85e-ff0b-11ea-1c8a-f3f787003fea
# ╟─6d43a5a8-ff10-11ea-0aed-693d96769fdf
# ╟─b50d2656-fe4e-11ea-023d-ebd9048e4bf8
# ╟─af7daf68-fe6b-11ea-3d27-bb3714fc249d
# ╟─cc400cc0-fefe-11ea-07a5-1533d4060ee4
# ╟─ee3851fe-ff04-11ea-3584-b5ecb2a5b4a2
# ╟─879ac970-ff05-11ea-2111-abe94a5ceacf
# ╟─16d51626-ff00-11ea-38f4-615272f1bee0
# ╟─5f0e09c0-ff00-11ea-17ce-1b9880406aad
# ╟─e3f419c0-ff05-11ea-2ef0-6ff0dc682731
# ╟─3ce5a83a-fe74-11ea-0740-ef5358e528fc
# ╟─f3d57ac8-fe76-11ea-2aca-395697343f4c
# ╟─2114e430-ff01-11ea-3df6-dd0d6b561d0a
# ╟─77311152-ff10-11ea-3b85-d7e10be6e501
# ╟─920ad230-fe4d-11ea-0c3e-0d7e731eb7aa
# ╟─b50a66fa-fe4e-11ea-0d8d-737bdbb637a7
# ╟─ca65bbe4-fe4e-11ea-1302-f3685c4d917b
# ╟─02936052-fe66-11ea-1510-11f1524cb289
# ╟─54e3badc-fe4f-11ea-1b32-03b5497dc105
# ╟─e4a9dc8c-fe4f-11ea-03f4-bb9de7b04582
# ╟─2b32a890-fe56-11ea-2e9d-0d29583403d4
# ╟─d286f844-fe65-11ea-34e9-f1d0c0e88c3e
# ╟─172fcdfe-fe57-11ea-2fa8-3754346967cc
# ╟─4b193ebc-ff23-11ea-039a-c9a06dae1118
# ╟─e289d8c4-fe65-11ea-394c-231d0465ac5b
# ╟─031507a2-fe58-11ea-0b1e-3dbca6f40310
# ╟─8122d91a-fe5a-11ea-14e4-6de3ce95b5a0
# ╟─aa1e0856-ff09-11ea-2e6e-2f157875a7a7
# ╟─81327a78-fe5a-11ea-2677-17a44aa9c1cc
# ╟─103cbca0-fe66-11ea-1c34-abcf94ffa7d4
# ╟─a4ce85d8-fe5a-11ea-0068-9db0d73d960b
# ╟─175495f4-fe5b-11ea-0d42-fb68eb160e10
# ╟─99f2635c-fe5d-11ea-13ca-ad3b654f18a9
# ╟─c9c127d8-fe5e-11ea-0535-a108365def2b
# ╟─25ce569e-fe59-11ea-150d-fbef155f1792
# ╟─544cab20-fe5d-11ea-12cc-27e19f290602
# ╟─3e716968-fe66-11ea-25aa-4b930fd8e083
# ╟─2f0967ba-fe60-11ea-297a-73d810159d0d
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
# ╠═9af8fe52-fcde-11ea-2d3d-c74da830f2d4
# ╠═f9411500-fcdf-11ea-0307-c7435d34f154
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
# ╠═b70c3ba4-fe73-11ea-10d3-4d6a040e0b1b

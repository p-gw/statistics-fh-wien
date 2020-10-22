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

# ╔═╡ df191b8c-f83e-11ea-3284-1ff04daa4e61
begin
	using Pkg
	Pkg.add("StatsBase")
	Pkg.add("PlutoUI")
	Pkg.add("Random")
	Pkg.add("Statistics")
	Pkg.add("Distributions")
	using StatsBase, PlutoUI, Random, Statistics, Distributions
end

# ╔═╡ 14ec6500-f427-11ea-1078-254be1839698
md"""
# Principles of quantitative research

In this lecture we will cover the basic principles of quantitative research, what are the typical steps in conducting quantitative research, and introduce basic concepts of measurement and data collection. 

The overarching questions we seek to answer are,

1. In which ways can we conduct quantitative empirical research?
2. What is measurement? 
3. How can we construct appropriate measurement instruments?
4. What are typical approaches to data collection?
"""

# ╔═╡ 35974d90-f73f-11ea-13c1-d946b6d0155c
md"""
## Introduction to quantitative research
### Controlled experiments

> [An experiment is] a series of observations conducted under **controlled conditions** to study a relationship with the purpose of drawing **causal inferences** about that relationship. An experiment involves the **manipulation** of an independent variable, the **measurement** of a dependent variable, and the exposure of various participants to one or more of the conditions being studied. Random selection of participants and their **random assignment** to conditions also are necessary in experiments.

-- APA Dictionary of Psychology [🌐](https://dictionary.apa.org/experiment)

From the definition it becomes clear that the definining characteristics of an experiment are

1. the experimental manipulation, 
2. random assignment to the experimental or control conditions,
3. control of experimental conditions.

The goal of a controlled experiment is to isolate a **treatment effect**. The treatment effect is a *causal effect* of one variable (the treatment exposure) on an observed outcome. The way to achieve this is the random assignment of participants to treatment and control groups. It guarantees us (probabilistically) that the groups *do not differ systematically* and other variables (*covariates*) do not influence the exposure to treatment. 

Visually, we can represent controlled experiments like this:
"""

# ╔═╡ 3f375cd6-0297-11eb-0d85-a7433ab9d98b
Resource("https://github.com/p-gw/statistics-fh-wien/blob/master/notebooks/img/rct_dag.png?raw=true", :width => 600)

# ╔═╡ df770e54-0298-11eb-2408-c3f3a67f2877
md"""
If a controlled experiment is carried out correctly, it can give us strong evidence about the treatment effect in question -- it has high **internal validity**. However, when applied in the social sciences controlled experiments can sometimes generalize poorly to the real world (low **external validity**), because in practice treatment effects can be variable and influenced by a lot of additional factors that cannot be controlled for. 
"""

# ╔═╡ 3f401f58-0297-11eb-01f8-05f78ed486e5
md"""
Let us take a look at the most well known example of a controlled experiment.

**Example:** Testing of drug efficacy

In clinical research efficacy of a drug is tested only after the safety has been established. Testing of drug efficacy is usually designed as a randomized controlled trial (RCT). In these trials, patients are assigned to treatment or control conditions at random. The treatment assignment is in many cases **double-blind**, i.e. neither participant nor investigator know whether the participant is in the control or experimental condition. Another possibility is to carry out a **blind** study, where only the participant is unaware of the experimental group they are in. The difference is that a double-blinded study can rule out **experimenter bias**, while a blinded study can not. 

Once the random assignment is completed and the trial is run, one compares the groups with respect to some predefined outcome measure (e.g. tumor size for cancer drugs). If the analysis shows that the outcome measure is different between groups (smaller tumor size in experimental group compared to control) the drug can be declared effective. 

Choice of control conditions are very important, especially in clinical trials. One typically does not compare *treatment vs. no treatment*, but *treatment vs. placebo* or *new treatment vs. established treatment*. Comparing the treatment group to a placebo group is preferable since it is known that even inert treatments (placebos) can have a therapeutic effect (**placebo effect**). In clinical research it is often not possible to compare a treatment to a placebo due to ethical concerns, since this would mean denying treatment to patients. Another possibility is to compare different treatments and declare the trial a success if the new treatment is an improvement over the established treatment options.
"""

# ╔═╡ ad1158f8-0288-11eb-15ac-4fae4a5a91b4
md"""
### Natural experiments

> [A natural experiment is] the study of a naturally occurring situation as it unfolds in the real world. [...] The researcher **does not exert any influence** over the situation but rather simply observes individuals and circumstances, **comparing the current condition to some other condition**. 

-- APA Dictionary of Psychology [🌐](https://dictionary.apa.org/natural-experiment)

A natural experiment is similar to a controlled experiment, but with a crucial difference: The assignment to the experimental conditions is *not random* but occurs through some known mechanism such that treatment and control groups do not differ systematically. Thus, the treatment exposure is provided to us naturally through this process. Natural experiments also allow for the investigation of causal treatment effects. They are often used if it is not feasible or ethical to carry out a controlled experiment.

The stylized graph of a natural experiment matches exactly that of a randomized controlled trial (see above).
"""

# ╔═╡ f6bdec0e-02ff-11eb-1c84-39f2e7521636
md"""
During the outbreak it was observed that the death rate in specific areas in the city were very different and that the death rate was highly associated with the water source of an area. The investigators discovered that areas which recieved water from the Thames downstream from a sewage plant had much higher death rates than areas which recieved water upstream from the plant.

In this example the treatment assignment is nonrandom and people were assigned to "treatment" (sewage water) or control group (clean water) based on where they received their water supply from. Since people in different areas did not differ systematically in ways other than their water supply, one can infer the causal effect of the treatment. The investigator came to the conclusion that impure water causes cholera and higher death rates, thus providing strong evidence for the germ theory of disease transmission for the disease. 
"""

# ╔═╡ 6c859ee0-028b-11eb-0d12-fb3584e18a15
md"""
### Observational studies

> [An observational study is] research in which the experimenter **passively observes** the behavior of the participants without any attempt at intervention or manipulation of the behaviors being observed. Such studies typically involve observation of cases under **naturalistic conditions** rather than the random assignment of cases to experimental conditions [...].

-- APA Dictionary of Psychology [🌐](https://dictionary.apa.org/observational-study)
"""

# ╔═╡ 7fb6b3b0-0302-11eb-10fd-bd663217809e
md"""
Observational studies differ from controlled and natural experiments in that there is no manipulation of the treatment exposure, either through randomization or known process. Instead, the researcher in an observational study simply observes the subjects of the study *without an intervention*. 

It can be seen from the graph below, that there is no treatment assignment in an observational study. Both treatment exposure and the outcome can be influenced by covariates. If this is the case, the covariate is called a **confounder** and causes **spurious associations** between treatment exposure and the outcome. A spurious association arises when two variables are associated, but not causally related. 
"""

# ╔═╡ 87c43fa4-0297-11eb-26ba-a73baa362ca3
Resource("https://github.com/p-gw/statistics-fh-wien/blob/master/notebooks/img/observational_study_dag.png?raw=true", :width => 400)

# ╔═╡ 87cb90ea-0297-11eb-0bc0-1f0405ca6f33
md"""
**Example:** Evaluation of an academic support program

Suppose we want to investigate the effectiveness of an existing educational support program. The goal of this program is to close the gap in achievement between children with low and high socioeconomic background. For this reason the program is aimed at children with low socioeconomic background, who get additional remedial lessons. Through this program children are exposed to treatment (remedial lessons) if they are considered low socioeconomic status and control otherwise. Note that there is no intervention by the researcher and the resulting groups differ systematically in their socioeconomic status.

When evaluating this program one has to take precautions because the covariate (socioeconomic status) influences *both* treatment exposure and outcome (academic achievement). If the researcher does not correctly account for socioeconomic status in the analysis, the results are incorrect. One might for example conclude that the program is effective even if it has no effect.    

In practical application the problem arises that not all confounders are observed or even known and accordingly cannot account for them in our analysis. Thus, we *cannot make claims about causal effects from observational studies*.

"""

# ╔═╡ 5ed37c60-f73f-11ea-2f77-29f539dee7a0
md"""
## Measurement

"""

# ╔═╡ 22363e10-f761-11ea-0a1d-e34a07732aeb
md"""
### Measurement in the social sciences

>  measurement, in the broadest sense, is defined as the **assignment of numerals to objects or events** according to rules.

-- Stevens, S. S. (1946). On the Theory of Scales of Measurements. *Science*. [📩](https://psychology.okstate.edu/faculty/jgrice/psyc3214/Stevens_FourScales_1946.pdf)
"""

# ╔═╡ 76674c0c-fb55-11ea-080f-17be4987a64d
md"""
### Types of variables
The objects or events of examination (units) are described through *variables*. 

> A variable is a **characteristic** of a unit being observed that may assume **more than one of a set of values** to which a **numerical measure or a category** from a classification can be assigned.

-- OECD, Glossary of statistical terms [🌐](https://stats.oecd.org/glossary/detail.asp?ID=2857)

In other words, a variable is an *attribute* of a observational unit, which can *vary* from one unit to another. We might, for example, describe people by the variable *handedness*. We can then describe a person's handedness as *right-handed* or *left-handed*. As you can see the definition of variables is broad in general and one can classify them based on their properties.   

The first type of classification is based on *which values a variable can take*. This distinction between *discrete* and *continuous* variables is very important in statistics. We will see many examples of this later in this course when we discuss probability and probability distributions."""

# ╔═╡ a155051c-fb55-11ea-0064-83bfa4e39f1e
md"Another way to classify variables is based on whether they physically *measure* something. In this case we distinguish between *quantitative* and *qualitative* variables:"

# ╔═╡ b24a853a-fb56-11ea-1cf5-8515f15806a6
md"An important concept of variables in the social sciences is based on the *observability* of the variable. If the construct is *not* directly observable, i.e. personality or intelligence, it is called *latent construct* or *latent variable*. It has to be measured indirectly through observable indicators, which are called *manifest indicators* or *manifest variables*."

# ╔═╡ 2a31f5f6-fb57-11ea-30a6-ef9d46a47e0e
md"""
Note that multiple definitions can apply to a specific variable, as exemplified below.

- *Intelligence:* continuos, quantitative, latent
- *Exam score:* discrete, quantitative, manifest
- *Eye color:* discrete, qualitative, manifest
"""

# ╔═╡ d54664f0-f7f5-11ea-24df-5bc68da34315
md"""
### Scales
According to Steven's (1946) classification there exist 4 scales, which can be assigned to variables. The scale of a variable describes *which mathematical and statistical operations can be applied*. 

| Scale | mathematical operation | statistical operation |
| :--- | :--- | :--- |
| *nominal* | determination of (in)equality | (relative) frequency, mode | 
| *ordinal* | determination of greater/less (ranking) | median, percentiles |
| *interval* | determination of equality of intervals or differences | mean, standard deviation, ... |
| *ratio* | determination of equality of ratios | coefficient of variation |
"""

# ╔═╡ 31572eb0-f746-11ea-3a11-67414d23ec4d
md"""
#### Nominal scale
The nominal scale is the most unrestricted type of measurement. Accordingly, the fewest mathematical operations of all scales are admissible. When forming a nominal scale we are using numbers as **group labels**. An example of a nominal scale would be the classification of students according to their area of study, e.g. *humanities* (1), *social sciences* (2) *natural sciences* (3), and *other* (4).

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
The next step in the hierarchy is the ordinal scale which allows **rank ordering** of the categories. Ordinal scales are the most common type of measurement in the social sciences. A classic example of an ordinal scale is the *grading scheme* in school and university. In Austria we typically construct the following scale, 

$x_i = \begin{cases}
1 & \text{if the performance is very good,} \\
2 & \text{if the performance is good,} \\
3 & \text{if the performance is satisfactory,} \\
4 & \text{if the performance is sufficient,} \\
5 & \text{if the performance is insufficient.}
\end{cases}$

If we observe data from 3 people, $x_1 = 4$, $x_2 = 5$, and $x_3 = 3$ it is easy to see that $x_1 < x_2$ and $x_1$ is in some sense better than $x_2$. But when comparing differences like $x_2 - x_1 = 5 - 4 = 1$ and $x_1 - x_3 = 4 - 3 = 1$ we can see that even though the differences are the same numerically, they are very different with regards to performance. For ordinal scales we can calculate statistical measures which are appropriate for rank-ordered data. This includes the **median** or **percentiles**. The cumulative property of scales also allows calculation of statistical summaries appropriate for nominal scales, such as category frequencies. 

> **Assignment rule:** Assign increasing numbers to the classes according to their rank order.
"""

# ╔═╡ 29061fa0-f746-11ea-3e2a-75a5bbf9254f
md"""
#### Interval scale
The interval scale is the lowest level of a truly *quantitative* scale. This allows for **comparison of intervals and differences**. In contrast to the ratio scale the location of the *zero point is arbitrary*. 

We can see interval scales in temperature measurement. When comparing the *Celsius* and *Fahrenheit* scales it is easy to see that each value corresponds to another value on the other scale. 
"""

# ╔═╡ 94105db6-f8c8-11ea-0918-cdfb9741f80e
md"""Temperature in degree Celsius: $(@bind temp_c NumberField(-273.15:0.01:100, default = 24))"""

# ╔═╡ 643d7184-f8c9-11ea-2eef-83f767d6952d
md"""
Temperature in degrees Fahrenheit: $temp_c * 1.8 + 32 ≈ $(round(temp_c * 1.8 + 32; digits = 1))

We can observe that while each value has a corresponding value on the other scale, zero points are *not the same*, which differentiates the interval scale from the ratio scale.

When we operate with interval scales almost all statistical operations can be applied. This includes the **mean**, **standard deviation**, and of course all other measurements applicable to nominal and ordinal scales.
"""

# ╔═╡ 904bf0d0-f8c8-11ea-0dbc-1dab8e6243e6
md"""

> **Assignment rule:** numbers $y$ are assigned according to the rule $y = a\cdot x + b$, where $x$ is another interval or ratio scale.
"""

# ╔═╡ 14bffa50-f7f7-11ea-328a-ad856cdfc29f
md"""
#### Ratio scale
The ratio scale is an interval scale with the additional property of an **absolute zero**. It is almost never encountered in psychological measurement, but occurs commonly in physical measurement. *Height* or *weight* are common examples of ratio scales. 

The difference between *interval* and *ratio* scales can be seen if we consider two different length measurements *inches* and *centimeters*. If a person has a height of $(h_cm = 176)cm we can calculate their height in inches: $(round(h_cm/2.54)), just like we did with the temperature scales. The difference is the existence of absolute 0 point: a length of 0cm equals 0in. This was not the case for the interval scale (see example above). 

With data on the ratio scale we can compute all statistical measures, including **coefficients of variation**.

> **Assignment rule:** numbers $y$ are assigned according to the rule $y = a\cdot x$, where $x$ is another ratio scale. 
"""

# ╔═╡ d8758610-f74b-11ea-1468-5371a7daa121
md"""
## Designing and constructing questionnaires
We should aspire to satisfy the the principles of psychological testing when constructing our own questionnaire. In order to achieve this we have to ask ourselfes multiple questions.

**What do I want to measure?**

At the beginning of each research project is some sort of question in need of an answer. Whether or not the research question is assigned to us by someone or intrinsically motivated, it often starts out very broad. For example the question  
"""

# ╔═╡ fe1c327c-f8e2-11ea-151f-bbda9624eff6
md"""
could arise from the observation that the relative frequency of negative assessments is larger for female students than it is for male students. After brainstorming and literature research one might come to the conclusion that among other reasons students differ in their [academic self concept](https://link.springer.com/referenceworkentry/10.1007%2F978-3-319-28099-8_1118-1), i.e. the perception of one's abilities in school. After coming to this conclusion, we can formulate a more concrete research questions or **hypothesis**, which we can test empirically: 
"""

# ╔═╡ 6cf1542a-f8e8-11ea-1273-59e3f3808073
md"-- Gewessler et al. (2018). [🌐](https://p-gw.github.io/dgps-2018/)"

# ╔═╡ f0d2a9ca-f8e2-11ea-2a92-cba6bef4e4d9
md"""
As you can see from this example we generally try to explain instead of merely describing something. Oftentimes research questions therefore focus on (causal) relationships between variables. 

A hypothesis typically contains information about

- *The variables of interest* (gender difference in mathematics achievement, gender differences in academic self concept)
- *The relationship between variables* (gender difference in mathematics achievement is caused by differences in academic self concept)
- The conditions under which the relationship holds (Austrian matriculation exam)

To answer our concrete research question it is clear that we need to measure *mathematical achievement* and *academic self-concept*. The process of defining how to measure theoretical constructs of interest is called **operationalization**.   

| construct | operationalization |
| :--- | :--- |
| mathematical achievement | number of items correct in the exam |
| academic self concept | sum score of self concept questionnaire | 

**What is my target audience?**

Definition of the *target population* is a integral part of research design. Depending on the construct of interest, the target population might be obvious such as in the example of *gender differences in the Austrian matriculation exam*.

Under certain circumstances the choice of target audience will have implications for questionnaire design. If we, for example, want to research the *daily use of mass media* in the general population an intuitive question would be 
"""

# ╔═╡ 3a84d7a2-fa4c-11ea-2c6a-65ba16e2a958
md"""
As can be seen [here](https://www.marketingcharts.com/charts/us-traditional-tv-viewing-in-q1-2020/attachment/nielsen-traditional-tv-viewing-by-age-in-q1-sept2020) this question alone does not adequately depict mass media usage in the general population. Younger people do not use less mass media as implied by the graph, but switched to alternative services. We can adapt our questionnaire design to accurately reflect this change in usage,
"""

# ╔═╡ 1c78e04e-fa4e-11ea-00e6-fd56c1935370
md"""
and calculate a sum score of all three questions in analysis phase of the research project. 
"""

# ╔═╡ fd3d0768-fa4b-11ea-10db-5fa125b0ddb2
md"> ✏️ As we will see later, definition of the correct target population also very important in the data collection step!"

# ╔═╡ 6000a772-fa4e-11ea-3008-e5255a29b308
md"""
**Is there any relevant existing material?**

For a lot of research topics there already exist a variety of material. Especially for research projects which contain constructs that are hard to measure (e.g. personality, leadership skills, ...) it is in many cases advisable to incorporate or use already existing and validated tests. 

If existing material is for whatever reason not appropriate for your application (e.g. different target population, language, ...), it can be useful in practice to adapt the questionnaires for your specific application. 

An example of this is again the research on academic self concept in the context of the Austrian matriculation exam, where we translated and customized existing measures on academic self concept:
"""

# ╔═╡ f0bb4d60-fa50-11ea-1886-d157f45f43c9
md"-- Gewessler et al. (2018). [🌐](https://p-gw.github.io/dgps-2018/)"

# ╔═╡ b7c7ab28-fb1f-11ea-2ca9-3358038b052c
md"""
**Is the questionnaire length appropriate for my application?**

In the example above we have seen that the length of a questionnaire can vary dramatically between applications. There are no general guidelines, because you have to find a balance between *measurement accuracy* (**reliability**) and practicability. The more questions your questionnaire/test contains the more accurate are your measurements, assuming all questions measure the construct of interest (i.e. your measurement instrument is **valid**). On the other hand one has to consider *motivational aspects* of the participants: With increasing test duration the answer quality decreases and probability of dropout (non-response) increases. 
"""

# ╔═╡ 7f907640-f7fa-11ea-1577-ad0d67b4e558
md"""
### Item construction
Construction of a psychological test of questionnaire can be a difficult task. We differentiate between *intuitive* and *rational* construction of a test or questionnaire. Even though rational construction based on theory and literature is a more principled approach, we encounter most often the intuitive construction based solely on the expertise of the author.
"""

# ╔═╡ 83066dae-f7fb-11ea-0c33-ffec1c4aac82
md"""
### Response formats
There are many different response formats for psychological tests. In this section we will *not* cover item construction for achievement tests, which include response formats such as **multiple choice**. Instead we focus on item construction for questionnaires and surveys.  

#### Open response format
"""

# ╔═╡ 8cd9a9ac-fa55-11ea-25aa-a933fdef46ff
md"""
When creating a quantitative questionnaire open response formats are rarely used. Many of their advantages are counteracted by their disadvantages in a quantitative setting. While an open ended question might get you long and elaborate answers, coding and analysing open format questions takes a lot of effort, especially when the number of participants in a study is large. Open response formats are widely used when using questionnaires for **evaluation** or when gathering **feedback**. If open ended questions are not engaging for the participants they will likely lead to non-response.
"""

# ╔═╡ c5f7b2c0-f7fe-11ea-3256-c575b19ef133
md"""
#### Dichotomous response formats
The dichotomous or binary response format is a very restrictive type of questions which provides only two possibile answers. In questionnaires dichotomous response formats are typically used for *Yes / No*, *True / False* or *Agree / Disagree* questions. 
"""

# ╔═╡ b1ca550e-fa5c-11ea-1c9d-295ba21f2212
html"""
<blockquote>
<p><strong>Example:</strong> Please state your gender.</p>
<p><label><input type="radio" name="q1" value="1"> Male</label></p>
<p><label><input type="radio" name="q1" value="2"> Female</label></p>
</blockquote>
"""

# ╔═╡ 5917baf0-f7ff-11ea-15ef-bdacf4f79449
md"""#### Categorical response formats
Categorical response format can be considered an extension to dichotomous reponse formats for **multiple categories**. Categorical response formats come in many flavours and one can classify them based on their scale level. Categorical answers can thus be *nominal* or *ordinal*. For nominal categorical questions we just list the possible answers and participants have to chose the appropriate one.
"""

# ╔═╡ b4e021de-fa5b-11ea-1d67-9788882e7139
md"""
Ordinal categorical response formats are arguably the most common in questionnaire design. One can distinguish them based on **polarity**, whether they are **numerical**, **verbal**, or **optical**, and their **number of categories**.
"""

# ╔═╡ 289496b4-fa5c-11ea-24a0-6ba7ff5e577a
html"""
<blockquote>
<p><strong>Example</strong> (verbal response format)</p>
<table cellpadding="10" cellspacing="10">
<tbody><tr>
<td align="center" valign="top"><label><input name="option1" type="radio" value="1"><br>
Strongly<br>
Disagree</label></td>
<td align="center" valign="top"><label><input name="option1" type="radio" value="2"><br>
Disagree</label></td>
<td align="center" valign="top"><label><input name="option1" type="radio" value="3"><br>
Neutral</label></td>
<td align="center" valign="top"><label><input name="option1" type="radio" value="4"><br>
Agree</label></td>
<td align="center" valign="top"><label><input name="option1" type="radio" value="5"><br>
Strongly<br>Agree</label></td>
</tr>
</tbody></table>
</blockquote>
"""

# ╔═╡ eee9edb8-fa5d-11ea-33c9-9d875c0ed4e6
md"Unipolar numeric response scale typically start at 0 or 1 and go a *single direction*." 

# ╔═╡ 9505d6ea-fa5d-11ea-2e31-b935d9d92a84
html"""
<blockquote>
<p><strong>Example</strong> (numeric unipolar response format, no neutral category)</p>
<table cellpadding="10" cellspacing="10">
<tbody><tr>
<td align="center" valign="top"><label><input name="option1" type="radio" value="1"><br>
1</label></td>
<td align="center" valign="top"><label><input name="option1" type="radio" value="2"><br>
2</label></td>
<td align="center" valign="top"><label><input name="option1" type="radio" value="4"><br>
3</label></td>
<td align="center" valign="top"><label><input name="option1" type="radio" value="5"><br>
4</label></td>
</tr>
</tbody></table>
</blockquote>
"""

# ╔═╡ 243da2f2-fa5e-11ea-2ef1-477e8b39e392
md"Bipolar scales are symmetric and run *from a negative to a positive value* via a zero or middle point."

# ╔═╡ c931b5ec-fa5d-11ea-1603-47b2ff595245
html"""
<blockquote>
<p><strong>Example</strong> (numeric bipolar response format)</p>
<table cellpadding="10" cellspacing="10">
<tbody><tr>
<td align="center" valign="top"><label><input name="option1" type="radio" value="1"><br>
-2</label></td>
<td align="center" valign="top"><label><input name="option1" type="radio" value="2"><br>
-1</label></td>
<td align="center" valign="top"><label><input name="option1" type="radio" value="3"><br>
0</label></td>
<td align="center" valign="top"><label><input name="option1" type="radio" value="4"><br>
1</label></td>
<td align="center" valign="top"><label><input name="option1" type="radio" value="5"><br>
2</label></td>
</tr>
</tbody></table>
</blockquote>
"""

# ╔═╡ 821d4340-fa5f-11ea-3beb-d3958cfab24c
md"The goal of numeric reponse types is that it used like an **inverval scale**. Note that while this property is desirable for statistical analysis (see section on scale types), it has to be verified and *cannot be assumed* in general! Sometimes these types of scales are referred to as **Likert scales**."

# ╔═╡ aab13a2e-fa5e-11ea-2dd9-dfdb2ec3daf5
md"Often you will find a **mixture** of numeric and verbal question types, where only the *most extreme values* are given verbally."

# ╔═╡ d52e1560-fa5e-11ea-39a4-c727697ca694
html"""
<blockquote>
<p><strong>Example</strong> (mixed response format)</p>
<table cellpadding="10" cellspacing="10">
<tbody><tr>
<td align="center" valign="top"><label><br>Strongly disagree</label></td>
<td align="center" valign="top"><label><input name="option1" type="radio" value="1"><br>
1</label></td>
<td align="center" valign="top"><label><input name="option1" type="radio" value="2"><br>
2</label></td>
<td align="center" valign="top"><label><input name="option1" type="radio" value="3"><br>
3</label></td>
<td align="center" valign="top"><label><input name="option1" type="radio" value="4"><br>
4</label></td>
<td align="center" valign="top"><label><input name="option1" type="radio" value="5"><br>
5</label></td>
<td align="center" valign="top"><label><input name="option1" type="radio" value="5"><br>
6</label></td>
<td align="center" valign="top"><label><br>Strongly agree</label></td>
</tr>
</tbody></table>
</blockquote>
"""

# ╔═╡ bf33e59c-fa62-11ea-2915-596f74c948ad
md"Symbolic response scales, a variant of optical response scales, can be used when one cannot rely on verbal skills of the participant, e.g. when working with children."

# ╔═╡ 50d8a48e-fa62-11ea-36b3-4bd8759b9fe5
html"""
<blockquote>
<p><strong>Example:</strong> (symbolic response format)</p>
<p>☹️🙁😐🙂😃</p>
</blockquote>
"""

# ╔═╡ 6749ea80-f7ff-11ea-0c46-e92f53e468a0
md"""
#### Continuous response formats
Sometimes continuous response formats are an appropriate choice in a questionnaire. Most commonly they appear when asking for *counts* or *amount* of variables. 
"""

# ╔═╡ b87fb3c2-fa6a-11ea-3670-013131152938
html"""
<blockquote>
<p><strong>Example:</strong> Please state your height in centimeters. 
<input type="number" min="0", max="300"></p>
</blockquote>
"""

# ╔═╡ f80a379c-fa6a-11ea-2668-2dc3c779a838
md"Another way to construct questions which yield continuous data, are so called **visual analogue scales**. For visual analogue scales respondents state their level of agreement or level attribute on a continuous scale between two endpoints."

# ╔═╡ 8205f11c-fa60-11ea-271d-a185d52d4a65
html"""
<style>
.slidecontainer {
  width: 100%;
}

.slider {
  -webkit-appearance: none;
  width: 60%;
  height: 25px;
  background: #d3d3d3;
  outline: none;
  opacity: 0.7;
  -webkit-transition: .2s;
  transition: opacity .2s;
}

.slider:hover {
  opacity: 1;
}

.slider::-webkit-slider-thumb {
  -webkit-appearance: none;
  appearance: none;
  width: 25px;
  height: 25px;
  background: #4CAF50;
  cursor: pointer;
}

.slider::-moz-range-thumb {
  width: 25px;
  height: 25px;
  background: #4CAF50;
  cursor: pointer;
}
</style>

<blockquote>
<p><strong>Example:</strong></p>
<div style="text-align: center;">
introverted <input type="range" min="1" max="100" value="50" class="slider"> extraverted
</div>
</blockquote>
"""

# ╔═╡ d459b620-f8b1-11ea-0be5-43cbd66bc846
md"""
### Practical considerations
#### General tips
In practice, the content of a questionnaire is highly dependent on the application. However, some general guidelines can help you purge your questionnaire of unnecessary clutter or increase detail whenever appropriate. Ask yourself these questions:

**Is this question relevant for my research question?**

The necessity of a question is determined by the relevance for the research question. Generally, if you do not need to know some information do not ask for it to keep your questionnaire as short as possible. Even if some information is necessary for your analysis it is sometimes preferrable to *estimate* a quantity instead of asking for it. This is especially true for variables that are prone to **response biases** (see below) such as social desirability. 

> ☝️ Keep your questionnaire streamlined!

**Do I need to ask multiple questions?**

Often a question does not cover all the possibilities we need to know. We encountered such an example already when we discussed the social media usage in the general population. Just asking for television usage is not enough in this case, because the younger generation typically prefers other means of entertainment. 

Psychological tests or scales as we have shown are a systematic approach to investigate a construct of interest. Use already existing ones or exploit their design principles in your own questionnaire design, if the construct is highly relevant to your research question.

#### Wording
##### Item types
"""

# ╔═╡ e153c196-fb21-11ea-345a-63f7427c3395
md"""
**direct vs. indirect questions**

Questions can either *directly* address the construct of interest or be worded such that query is based on indicators of the construct (*indirect*).

> **direct:** Are you anxious?
>
> **indirect:** Do you feel unsafe if you are out on the streets alone at night? 

Direct questions can prove problematic when they require an interpretation of the construct (*anxiety* in the example above). Well chosen (indirect) indicators of the construct can remove this interindividual ambiguity. In certain cases such as *sensitive topics* direct questions can also be uncomfortable or disturbing to answer. This in turn might lead to non-response.

"""

# ╔═╡ cde1a47e-fb27-11ea-1725-5b857216b791
md"""
**hypothetical vs. biographical questions**

> **hypothetical:** Image there are conflicts between the employees in your departments. What would you do about it?
>
> **biographical:** How did you behave the last time you had a conflict with a colleague?

Typically biographical questions are considered more reliable, but necessitate situational judgement. Therefore biographical items can only be utilized if you assume every participant already experienced the situation in question. In this respect hypothetical items are more general. In many cases however they are misjudged by the participants, leading to less reliable information.  
"""

# ╔═╡ 50762e7a-fb2b-11ea-097b-033f654dc9b7
md"""
**concrete vs. abstract questions**

Similarly, questions can be classified as either concrete or abstract. Much like biographical questions, concrete questions provide reliable information, but are situational in their application, while abstract questions can be misjudged by participants of the study. 


"""

# ╔═╡ 707c7002-fb2c-11ea-3562-eb8f3239bce2
md"""
**personal vs. unpersonal**

Personal questions yield very reliable information about participants. Depending on the context participants might consider personal questions inappropriate or disturbing. In these instances unpersonal questions must be used. Note that unpersonal questions do not necessarily give you the answer you are looking for.  

> **personal:** Do you use condoms?
>
> **unpersonal:** Should one use condoms?

If we want to know about condom usage, the personal variant gives us exactly the infomation we need (provided that participants answer truthfully). In the unpersonal version of the question one could give a *socially desirable* answer (e.g. "Yes, one should"), although they do not use condoms themselves. 
"""

# ╔═╡ c2e5a072-fb2f-11ea-27ec-dfe9c67b7035
md"""
**Classification based on content**

A complementary classification system can be based on question content. It should be noted that mixing of the question types described in this section is not recommended as it might lead to **method bias**. Method bias describes a type of measurement error, which arises because of the methods (in this case: different types of questions) in use. In practice one should utilize as few question types as possible, while not compromising questionnaire content. Question content can be based on,

- self-description (*I laugh often.*)
- description of self by others (*Friends consider me a joyous person*)
- biographical facts (*I went on backpacking holidays multiple times*)
- trait descriptions (*I consider myself spontaneous*)
- motivational questions (*I have a preference for challenging tasks*)
- Interests and desires (*I like to watch scientific documentaries*)
- Attitudes and opinions (*There are more important thing in life than work*)
"""

# ╔═╡ 011cea2e-fb2d-11ea-0fb6-f34e2de6ecc5
md"##### Comprehensibility"

# ╔═╡ 3463bdea-fb2d-11ea-3326-afa53e2ae562
md"""
**Avoid negations**

Formulating questions in a positive manner should be preferred when constructing questionnaires. (Double) negations introduce unnecessary complexity to questions. 

> ❌ I do not find the tropical deforestation concerning. 

> ✔️ I find the tropical deforestation concerning. 
"""

# ╔═╡ 3ee48ba8-fb2d-11ea-2d38-bdb875c6c135
md"""
**Avoid complex questions**

Overly long and complex sentence construction makes questions difficult to understand. Keep your questions as short and simple as possible while still maintaining the relevant content. 

> ❌ If I drive my car to an important meeting I would be upset if there was a traffic jam along the way due to rush hour.  

> ✔️ I get upset easily if I am in a traffic jam.

"""

# ╔═╡ 5edf6cce-fb2d-11ea-1f87-135d21c6cb3f
md"""
**Avoid jargon**

Jargon should be avoided or only used when you can assume that the target audience is familiar with the concept. For example it might be appropriate to refer to *aggressiveness* in a questionnaire for psychologists, it is not suitable for the general population as the laymans definition might vary wildly from the academic definition for *aggressiveness*. In this example one could substitute the general question for a behavioural indicator. 

> ❌ I am aggressive. 

> ✔️I have been in a bar fight in the past year.
"""

# ╔═╡ 61962438-fb2d-11ea-1457-474a6f1bed46
md"""
**Intensities**

Referring to intensities like *seldom*, *often*, *few* or frequencies leads to ambiguous questions. Make sure to revise these questions so that they do not include quantities or ask for quantities directly. 

> ❌ I often drink wine.

> ✔️ I like to relax with a glass of wine.
>
> ✔️ How many glasses of wine do you drink in an average week?

"""

# ╔═╡ c81ed218-fb2d-11ea-0ede-d5a95b552f76
md"##### Unambiguity"

# ╔═╡ 350931d6-fb2c-11ea-33d6-f92777cf80cb
md"""
**Avoid conjunctions**

Most often a question formulated with *and*/*or* should be split into multiple questions to maximize information and avoid ambiguity.

> ❌  How satisfied are you with the current government *and* which party would you vote for if there were elections next sunday?

> ✔️ How satisfied are you with the current government?
>
>  ✔️ Which party would you vote for if there were elections next sunday?
"""

# ╔═╡ 3c5603a0-fb3a-11ea-1b1d-1b810afd0f3c
md"""
**Avoid loaded questions**

Questions should avoid to suggest a particular answer.

> ❌ Do you agree to avoid dealing with choleric persons?

> ✔️ I steer clear of choleric persons. 
"""

# ╔═╡ 804d9d48-fb3a-11ea-2534-6b24ce15d757
md"""
**Do not use absolutes**

Asking in absolute terms (*always*, *never*, ...) almost always forces participants to answer in a certain way. 

> ❌ My child is never able to concentrate on the task at hand.

> ✔️ It is difficult for my child to concentrate on the task at hand.
"""

# ╔═╡ 472736f8-fb20-11ea-334a-0317b6f7c5bb
md"""

#### Placement
Accurate placement of questions or question groups can be a challenging task when designing a questionnaire. Depending on the length of the questionnaire it is not advisable to ask the most important questions at the end, because participants might get tired and the quality of the answers drops. On the other hand, is not a good idea to start off with the main topic without a proper introduction. There are many factors at play, but a good rule of thumb is to follow this general advice,  

- Start your questionnaire with a few easy and non-sensitive questions (*icebreaker questions*)
- Place the difficult and/or sensitive questions near the end of the questionnaire
- Keep topics, scales, and tests clustered together 
- Mark transitions in topics, scales, or tests clearly (e.g. new sections or pages)
- Introduce sections, especially when containing difficult topics, with a short statement
"""

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

In probability sampling, each unit of the target population has some probability greater than 0 to be included in the sample *and* the inclusion probabilities are known for each unit. In other words this means that in theory every unit has a possibility to get sampled and we know how probable it is. While there are many probability sampling schemes, we will take a look at **simple random sampling** and **stratified sampling** in greater detail.

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

# ╔═╡ 91bbef94-f8cd-11ea-23c2-d995c54ea6cd
md"probability of inclusion: $(sample_size)/64 = $(round(sample_size/64; digits = 2))"

# ╔═╡ 4c1ac444-f842-11ea-3a52-ab7b9386cfb9
md"""
relative sample size: $(@bind sample_fraction Slider(0.03:0.01:1, default = 0.2))
$(@bind new_stratified_sample Button("Draw new sample"))
"""

# ╔═╡ fc4a831a-f842-11ea-0855-0726089dcd2b
md"""
In addition to more accurate estimates for the target population we also get estimates at the level of the stratum (age group 1, 2 and 3), because the sampling design *guarantees* a certain amount of cases for each stratum.

Note that in practice *many variables* (and combinations of variables) are used to stratify data! See, for example, [this poll](https://www.unique-research.at/post/umfrage-f%C3%BCr-heute-und-atv-sonntagsfrage-zur-wien-wahl-2020), which incorporates *age*, *education*, *district*, and *sex* as stratification variables.
"""

# ╔═╡ d0088550-f821-11ea-39ce-7dcfa8bbc450
md"""
In constrast, nonprobability sampling refers to sampling processes which allow a probability of zero for some sampling units *or* to sampling processes where the probabilities are unknown. In general this leads to a phenomenon called **sampling bias**, where quantities of the population cannot be estimated correctly. Samples from these processes are called *non-representative* samples, because they do not adequatly reflect the target population. Nonprobability samples are very common, especially in the social sciences. 

> ⚠️ The results from a nonprobability sample **cannot be generalized** to the target population!

###### Convenience sampling
The convenience sampling method is a common nonprobability sampling method that samples units from the population which are easy to reach. As described above, convenience sampling is not representative of the target population and leads to sampling bias.

Consider again the opinion polling example. Instead of collecting a serious stratified sample of the general population - which takes a lot of effort - we just sample easy to reach people. As we are at university we just ask people in front of the building their political preference. Notice that people at university are younger than the general population and therefore hold a more liberal political opinion (on average).


sample size: $(@bind convenience_sample_size Slider(1:100, default = 5))
$(@bind new_convenience_sample Button("Draw new sample"))
"""

# ╔═╡ 66405444-f845-11ea-0289-0f281a912820
md"As you can see, the sample does not reflect the target population even when the sample size is large."

# ╔═╡ 6fdc7fe4-f847-11ea-04de-4b121ccc8de6
md"n = $convenience_sample_size"

# ╔═╡ c7d2cb9a-f847-11ea-3772-3382948535f5
md"""
## Summary
In quantitative research we distinguish between different research methods. Both **controlled experiments** and **natural experiments** are a systematic approach for drawing **causal conclusions** about a phenomenon of interest. **Observational studies**, however, do not allow for causal conclusions, because (unobserved) variables might act as a **confounder** and bias our results.   

Whatever research method used, measurement is a central part of the research design. There are various ways of classifying variables, all used in different contexts. Variables are usually distinguished as **quantitative/qualitative**, **continuous/discrete** or **manifest/latent**. A classification in terms of **scales** (nominal, ordinal, interval, ratio) allows to associate statistical operations with specific types of variables.

Good item and questionnaire design requires a lot of experience to do well. We have seen the general way of how to arrive at a empirically **testable research questions** and learned how to construct items and questionnaires using different response formats like **dichotomous**, **ordinal** and **continuous response formats**. A general goal was to **keep questionnaires short** and to avoid common pitfalls in the item development process and look out for mistakes regarding **wording**, **comprehension**, **ambiguity** and question **placement**.

We have seen that there are different ways of sampling or how to collect data. While there are approaches like **convenience sampling** which seem tempting at first, one has to be aware that results of these **non-probability sampling** procedures do not allow the researcher to make (statistical) statements about the target population. If at all feasible **probability sampling** schemes are to be preferred. Even though data collection using **simple random sampling**, **stratified sampling** or other sampling methods can be a lot more complex, the additional effort is in many cases worth it, because inferences about the target population can be drawn. 
"""

# ╔═╡ fc39fc20-f81d-11ea-02cc-27ff11c91303
md"""
### Footnotes
[^1]: We will cover the topic of inference and estimation later in this course.
[^2]: Note that this is a hypothetical and vastly simplified example of voting behaviour in the general population in Austria.
"""

# ╔═╡ a86064fc-f847-11ea-30d2-8916c38b275b
md"""
## Computational resources
This section can be ignored...
"""

# ╔═╡ 3e7ba3f0-f83b-11ea-248e-ff7dfe60f64e
α = 48

# ╔═╡ 42cee020-f83b-11ea-24d6-2f14293b9d89
β = 14

# ╔═╡ 8205f45e-f83b-11ea-2cdb-b935856c1839
ϵ = Normal(0, 7)

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

# ╔═╡ 831f5224-f839-11ea-3d78-3918811d0a5d
estimate_conservativeness(age) = cdf(Logistic(0, 1), (age - α + rand(ϵ))/β)

# ╔═╡ d3156610-f839-11ea-0282-5bcc40d80e14
ages = [rand(18:39, 32); rand(40:59, 47); rand(60:100, 21)]

# ╔═╡ 9c7f4bf6-f83a-11ea-0aa5-2fdbd1a55d73
conservativeness = estimate_conservativeness.(ages)

# ╔═╡ 66246f08-f83c-11ea-292f-3730ef22f732
begin
	new_stratified_sample
	idx_s1 = StatsBase.sample(1:32, 32; replace = false)
	idx_s2 = StatsBase.sample(33:79, 47; replace = false)
	idx_s3 = StatsBase.sample(80:100, 21; replace = false)
end

# ╔═╡ 86704ee6-f83f-11ea-239f-bbea986b5b72
begin
	s1 = idx_s1[1:convert(Integer, round(32 * sample_fraction))]
	s2 = idx_s2[1:convert(Integer, round(47 * sample_fraction))]
	s3 = idx_s3[1:convert(Integer, round(21 * sample_fraction))]
end

# ╔═╡ 47caadc4-f841-11ea-2e4c-0b3bc6f34ef2
md"""
When using a stratified sampling procedure, we draw a simple random sample in each stratum with the sample size *proportional to the size of the subpopulation*.

stratum 1: n = $(length(s1)), stratum 2: n = $(length(s2)), stratum 3: n = $(length(s3))
"""

# ╔═╡ d45180e2-f832-11ea-22fa-c35ee3e39c87
function party_classification(x)
	if x < .3
		return "🟢"
	elseif x < .68
		return "🔴"
	elseif x < .88
		return "⚫"
	else 
		return "🔵"
	end
end

# ╔═╡ f9164c5a-f832-11ea-1634-e91163458a28
begin
	stratified_population = reshape(party_classification.(conservativeness), 10, 10)
end


# ╔═╡ 961ad440-f80f-11ea-2360-39edf365e26b
md"""
###### Stratified sampling
Stratified sampling can be employed when an overall population can be *exhaustively partitioned* into subpopulations. This partitioning requires additional knowledge about the population, because we need to know the partitioning variables of each unit in the population. We can, for example, partition a population by *age* by assigning people to age groups `<= 39`, `40 - 59`, and `>= 60` years. Note that this classification must be **exhaustive**, i.e. each unit in the population is classified, and **exclusive**: each unit is assigned to one group only. The process of partitioning is called **stratification**. The resulting subpopulation groups are **strata**. After stratification we sample units by *simple random sampling in each stratum*. The sample sizes in each stratum are proportional to the respective size of the subpopulation.  

A classic example of stratified sampling are political opinion polls. For the following example, assume that people get more conservative with increasing age and in turn vote for more conservative political parties. In this case we might want to *stratify by age* to get an accurate picture of how the upcoming election will turn out. We define 3 strata in a population of N = 100 people, 

| stratum (age group) | stratum index | population size |
| --- | --- | --- |
|  <= 39 | 1 | 32 |
| 40 - 59 | 2 | 47 |
|  >= 60 | 3 | 21 |

In the population we observe the following distribution of preferred parties.[^2]

Die Grünen (🟢): $(round(mean(stratified_population .== "🟢") * 100))%

SPÖ (🔴): $(round(mean(stratified_population .== "🔴") * 100))%

ÖVP (⚫): $(round(mean(stratified_population .== "⚫") * 100))%

FPÖ (🔵): $(round(mean(stratified_population .== "🔵") * 100))%

"""

# ╔═╡ 2d46071c-f83e-11ea-2d19-130b91a9cd39
begin
	ps2 = copy(stratified_population)
	ps2[[s1; s2; s3]] .= "❎"
	ps2
end

# ╔═╡ ec3b87a6-f83d-11ea-214a-e7b565eb3017
sample_stratum1 = stratified_population[s1]

# ╔═╡ 1709c52e-f83e-11ea-08fb-bb392b1fae55
sample_stratum2 = stratified_population[s2]

# ╔═╡ 170d1a12-f83e-11ea-08bf-a31a85565ecd
sample_stratum3 = stratified_population[s3]

# ╔═╡ 1201a710-f846-11ea-3863-db1ebda95fb6
stratum_mean(x) = round((mean(sample_stratum1 .== x) * 0.32 + mean(sample_stratum2 .== x) * 0.47 +  mean(sample_stratum3 .== x) * 0.21) * 100)

# ╔═╡ f2d031b8-f845-11ea-0709-8775f541172f
md"""
**estimates:**

Die Grünen (🟢): $(stratum_mean("🟢"))%

SPÖ (🔴): $(stratum_mean("🔴"))%

ÖVP (⚫): $(stratum_mean("⚫"))%

FPÖ (🔵): $(stratum_mean("🔵"))%
"""

# ╔═╡ 98eb5c32-f844-11ea-2680-edbe20c15aba
begin
	new_convenience_sample
	convenience_ages = round.(rand(TruncatedNormal(40, 7, 18, Inf), 100))
	convenience_conservativeness = estimate_conservativeness.(convenience_ages)
	convenience_classification = party_classification.(convenience_conservativeness)
	convenience_idx = randperm(100)
end

# ╔═╡ bd01f196-f844-11ea-2d57-3d645e744af1
convenience_sample = convenience_classification[convenience_idx[1:convenience_sample_size]]

# ╔═╡ 4768a90e-f847-11ea-36d8-8954804fd4ac
md"""
Die Grünen (🟢): $(round(mean(convenience_sample .== "🟢") * 100))%

SPÖ (🔴): $(round(mean(convenience_sample .== "🔴") * 100))%

ÖVP (⚫): $(round(mean(convenience_sample .== "⚫") * 100))%

FPÖ (🔵): $(round(mean(convenience_sample .== "🔵") * 100))%
"""

# ╔═╡ d22bace0-f7f4-11ea-1858-ddc3259e5ebd
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

# ╔═╡ f7efe38c-029a-11eb-0347-0d48f10012cb
two_columns(md"""
**Example:** 1854 Cholera outbreak
	
One of the most well known examples of a natural experiment is the 1854 Cholera outbreak in London. 

At the time there were two competing theories about the causes of the disease. The *Miasma theory* argued for a transmission via "bad air", whereas the *germ theory* considered transmission of diseases via "germs" (microorganisms in todays language). 
""", md"""
![](https://upload.wikimedia.org/wikipedia/commons/thumb/2/27/Snow-cholera-map-1.jpg/1280px-Snow-cholera-map-1.jpg)""",
[60, 40])

# ╔═╡ d81c6852-f7f5-11ea-38fa-c1c5297b07f0
two_columns(md"""
**discrete**

- Finite or countably infinite number of values 
- Represented as (a subset of) the natural numbers $\mathbb{N}$
- *Examples*: grades in school (1 - 5; finite), number of yearly car accidents (0, 1, ...; countably infinite) 
	
""", md"""
**continuous**
	
- Uncountable infinite number of values
- Represented as (a subset of) the real numbers $\mathbb{R}$
- *Example:* Height
""")

# ╔═╡ bc9a0f50-f7f6-11ea-2b17-f18050cc9a87
two_columns(md"""
**quantitative**

- numeric
- result from *counting* or *measuring*
- *Example:* Weight
	
""", md"""
**qualitative**
	
- categorical
- result from *labelling*
- *Example:* eye color
	
""")

# ╔═╡ c42c1420-f7f6-11ea-36e9-e90adaa3edc0
two_columns(md"""
**manifest**
	
- directly observable
- *Example:* Exam score

""", md"""
**latent**

- only indirectly obserable (through multiple indicators)
- *Example:* Anxiety
""")

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
- No limits on answer length
- Can give creative and unexpected results	
""", md"""
**Weak points:**
- Difficult to score
- High effort to analyse
- Time consuming to answer
- Possibility of non-response
""")

# ╔═╡ 36061016-fa52-11ea-1e01-2bfbdd06240e
two_columns(md"""
**Strong points:**
- Easy to construct
- Easy to score
- Participants are *forced* to make a choice. 
""", md"""
**Weak points:**
- Only provides binary information and **no information about the amount** of the construct in question.
""")

# ╔═╡ 620dd28c-fa63-11ea-25e0-7559f13582be
two_columns(md"""
**Strong points:**
- very flexible
- commonly used
- participants are familiar with this type of response format
""", md"""
**Weak points:**
- Might need more complex analysis methods if interval scale cannot be assumed
""")

# ╔═╡ ad8bec80-fa63-11ea-37da-b991a3d0d447
two_columns(md"""
**Strong points:**
- very flexible
- no (arbitrary) categorization needed
""", md"""
**Weak points:**
- implies accuracy which might not exist
- difficult to score when testing with paper & pencil 
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

# ╔═╡ 17658f6c-055e-11eb-1e3e-252f83f0543d
center(md"Whatever the method of conducting empirical research, one has to recognize that **measurement** of the quantities of interest is a central part of the process.")

# ╔═╡ 0b44b96e-f8cb-11ea-3c5f-d3ac7b8532a9
center(md"Very **broad definition** of measurement, which is not necessarily compatible with measurement in a physical sense.")

# ╔═╡ 0b46c6f0-f8cb-11ea-1576-6f95efd722c6
center(md"Allows for a **classification of scales** with associated mathematical and statistical operations.")

# ╔═╡ 18570cb2-f8ba-11ea-2bcf-1f043918ac3f
center(md"Scales are **cumulative**, meaning that a scale must satisfy all properties of *lower* scales!")

# ╔═╡ f092df50-f8d5-11ea-2d09-438f4f8d2a31
md"""
### Tests

> Any **standardized instrument**, including scales and self-report inventories, used to measure behavior or mental attributes, such as attitudes, emotional functioning, intelligence and cognitive abilities (reasoning, comprehension, abstraction, etc.), aptitudes, values, interests, and personality characteristics. [...]

-- *APA Dictionary of Psychology* [🌐](https://dictionary.apa.org/psychological-test)

- Psychological tests meet specific **scientific standards**
- Tests are constructed of multiple **stimuli** (e.g. questions or tasks). Participants *react* to these stimuli and in turn get assigned numerical values corresponding to their reaction. 
- Based on these assignments one strives to *infer the magnitude behaviour or mental attribute* in question (construct). 

In general, psychological constructs are not observable directly (they are **latent**), but manifest in specific behaviours. Psychological tests are used to assess the magnitude of said psychological construct by using observable (**manifest**) behaviours as *idicators of the construct*,

$(Resource("https://upload.wikimedia.org/wikipedia/commons/d/de/Congeneric_measurement_model.png", :width => 500))

Psychological tests use multiple indicators to increase the coverage of the construct as well as the accuracy of the results. Tests vary dramatically by their number of indicators as we can see in the following example, 

| Test | number of indicators | required time |
| :--- | :--- | :--- |
| Handedness Inventory (student questionnaire) | 10 | 1-2 minutes |
| NEO-PI-R (personality questionnaire) | 240 | 30-40 minutes |

**sample indicators:** (Big Five - Extraversion)
$(center(md"*I start conversations.*"))
$(center(md"*I think a lot before I speak or act.*"))
$(center(md"*I don't mind being the center of attention.*"))

As you can see, different indicators refer to different behaviours. The sum of behaviour tendencies then leads to some score on the latent extraversion construct. With these scores we can apply statistical analysis to compare people or groups of people.
"""

# ╔═╡ fe192f00-f8e2-11ea-1ec1-d13817384e16
center(md"*Why do male students perform better than female students in the standardized Austrian matriculation exam in mathematics?*")

# ╔═╡ 0af84652-f8e3-11ea-03ad-410028348cf8
center(md"*The gender difference in mathematics achievement in the Austrian matriculation exam arises (at least in part) due to differences in the academic self concept between males and females.*")

# ╔═╡ fcec6896-fa4b-11ea-1313-172ef1f8e605
center(md"*How many hours of television do you watch daily?*")

# ╔═╡ bb4ad5b8-fa4d-11ea-09fd-09302dfbbe01
center(md"""
1. *How many hours of television do you watch daily?*
2. *How many hours of streaming services (Netflix, Amazon Prime, Youtube, ...) do you use daily?* 
3. *How many hours of social media do you use daily?*
""")

# ╔═╡ 9b1dc7ca-fa50-11ea-33d6-c94bf890970e
center(md"*Ich bin zuversichtlich, die Matura in Mathematik mit angemessener Vorbereitung bewältigen zu können.*")

# ╔═╡ 94bfa120-f7fb-11ea-00f1-83ab1e2b58b1
center(md"> **Example:** *What do you expect to learn in this course?*")

# ╔═╡ 501198a4-fa57-11ea-2036-afbb7e6d5c17
center(md"Student A: *I've been interested in statistics for a long time. I am eager to learn the ways to conduct empirical research and analyse the results. I can't wait getting to know methods to make statements about people from just a little bit of data. How that works is just beyond me...*")

# ╔═╡ a9bd88e0-fa57-11ea-0284-01d319d7c321
center(md"Student B: *Just enough to pass...*")

# ╔═╡ Cell order:
# ╟─14ec6500-f427-11ea-1078-254be1839698
# ╟─35974d90-f73f-11ea-13c1-d946b6d0155c
# ╟─3f375cd6-0297-11eb-0d85-a7433ab9d98b
# ╟─df770e54-0298-11eb-2408-c3f3a67f2877
# ╟─3f401f58-0297-11eb-01f8-05f78ed486e5
# ╟─ad1158f8-0288-11eb-15ac-4fae4a5a91b4
# ╟─f7efe38c-029a-11eb-0347-0d48f10012cb
# ╟─f6bdec0e-02ff-11eb-1c84-39f2e7521636
# ╟─6c859ee0-028b-11eb-0d12-fb3584e18a15
# ╟─7fb6b3b0-0302-11eb-10fd-bd663217809e
# ╟─87c43fa4-0297-11eb-26ba-a73baa362ca3
# ╟─87cb90ea-0297-11eb-0bc0-1f0405ca6f33
# ╟─17658f6c-055e-11eb-1e3e-252f83f0543d
# ╟─5ed37c60-f73f-11ea-2f77-29f539dee7a0
# ╟─22363e10-f761-11ea-0a1d-e34a07732aeb
# ╟─0b44b96e-f8cb-11ea-3c5f-d3ac7b8532a9
# ╟─0b46c6f0-f8cb-11ea-1576-6f95efd722c6
# ╟─76674c0c-fb55-11ea-080f-17be4987a64d
# ╟─d81c6852-f7f5-11ea-38fa-c1c5297b07f0
# ╟─a155051c-fb55-11ea-0064-83bfa4e39f1e
# ╟─bc9a0f50-f7f6-11ea-2b17-f18050cc9a87
# ╟─b24a853a-fb56-11ea-1cf5-8515f15806a6
# ╟─c42c1420-f7f6-11ea-36e9-e90adaa3edc0
# ╟─2a31f5f6-fb57-11ea-30a6-ef9d46a47e0e
# ╟─d54664f0-f7f5-11ea-24df-5bc68da34315
# ╟─18570cb2-f8ba-11ea-2bcf-1f043918ac3f
# ╟─31572eb0-f746-11ea-3a11-67414d23ec4d
# ╟─219fe5be-f746-11ea-3fd6-898d0fb0b316
# ╟─29061fa0-f746-11ea-3e2a-75a5bbf9254f
# ╟─94105db6-f8c8-11ea-0918-cdfb9741f80e
# ╟─643d7184-f8c9-11ea-2eef-83f767d6952d
# ╟─904bf0d0-f8c8-11ea-0dbc-1dab8e6243e6
# ╟─14bffa50-f7f7-11ea-328a-ad856cdfc29f
# ╟─f092df50-f8d5-11ea-2d09-438f4f8d2a31
# ╟─d8758610-f74b-11ea-1468-5371a7daa121
# ╟─fe192f00-f8e2-11ea-1ec1-d13817384e16
# ╟─fe1c327c-f8e2-11ea-151f-bbda9624eff6
# ╟─0af84652-f8e3-11ea-03ad-410028348cf8
# ╟─6cf1542a-f8e8-11ea-1273-59e3f3808073
# ╟─f0d2a9ca-f8e2-11ea-2a92-cba6bef4e4d9
# ╟─fcec6896-fa4b-11ea-1313-172ef1f8e605
# ╟─3a84d7a2-fa4c-11ea-2c6a-65ba16e2a958
# ╟─bb4ad5b8-fa4d-11ea-09fd-09302dfbbe01
# ╟─1c78e04e-fa4e-11ea-00e6-fd56c1935370
# ╟─fd3d0768-fa4b-11ea-10db-5fa125b0ddb2
# ╟─6000a772-fa4e-11ea-3008-e5255a29b308
# ╟─9b1dc7ca-fa50-11ea-33d6-c94bf890970e
# ╟─f0bb4d60-fa50-11ea-1886-d157f45f43c9
# ╟─b7c7ab28-fb1f-11ea-2ca9-3358038b052c
# ╟─7f907640-f7fa-11ea-1577-ad0d67b4e558
# ╟─d0052690-f7f8-11ea-3c3b-138df428e074
# ╟─83066dae-f7fb-11ea-0c33-ffec1c4aac82
# ╟─8cd9a9ac-fa55-11ea-25aa-a933fdef46ff
# ╟─94bfa120-f7fb-11ea-00f1-83ab1e2b58b1
# ╟─501198a4-fa57-11ea-2036-afbb7e6d5c17
# ╟─a9bd88e0-fa57-11ea-0284-01d319d7c321
# ╟─a6183e00-f7fb-11ea-1c16-995824fd898b
# ╟─c5f7b2c0-f7fe-11ea-3256-c575b19ef133
# ╟─b1ca550e-fa5c-11ea-1c9d-295ba21f2212
# ╟─36061016-fa52-11ea-1e01-2bfbdd06240e
# ╟─5917baf0-f7ff-11ea-15ef-bdacf4f79449
# ╟─b4e021de-fa5b-11ea-1d67-9788882e7139
# ╟─289496b4-fa5c-11ea-24a0-6ba7ff5e577a
# ╟─eee9edb8-fa5d-11ea-33c9-9d875c0ed4e6
# ╟─9505d6ea-fa5d-11ea-2e31-b935d9d92a84
# ╟─243da2f2-fa5e-11ea-2ef1-477e8b39e392
# ╟─c931b5ec-fa5d-11ea-1603-47b2ff595245
# ╟─821d4340-fa5f-11ea-3beb-d3958cfab24c
# ╟─aab13a2e-fa5e-11ea-2dd9-dfdb2ec3daf5
# ╟─d52e1560-fa5e-11ea-39a4-c727697ca694
# ╟─bf33e59c-fa62-11ea-2915-596f74c948ad
# ╟─50d8a48e-fa62-11ea-36b3-4bd8759b9fe5
# ╟─620dd28c-fa63-11ea-25e0-7559f13582be
# ╟─6749ea80-f7ff-11ea-0c46-e92f53e468a0
# ╟─b87fb3c2-fa6a-11ea-3670-013131152938
# ╟─f80a379c-fa6a-11ea-2668-2dc3c779a838
# ╟─8205f11c-fa60-11ea-271d-a185d52d4a65
# ╟─ad8bec80-fa63-11ea-37da-b991a3d0d447
# ╟─d459b620-f8b1-11ea-0be5-43cbd66bc846
# ╟─e153c196-fb21-11ea-345a-63f7427c3395
# ╟─cde1a47e-fb27-11ea-1725-5b857216b791
# ╟─50762e7a-fb2b-11ea-097b-033f654dc9b7
# ╟─707c7002-fb2c-11ea-3562-eb8f3239bce2
# ╟─c2e5a072-fb2f-11ea-27ec-dfe9c67b7035
# ╟─011cea2e-fb2d-11ea-0fb6-f34e2de6ecc5
# ╟─3463bdea-fb2d-11ea-3326-afa53e2ae562
# ╟─3ee48ba8-fb2d-11ea-2d38-bdb875c6c135
# ╟─5edf6cce-fb2d-11ea-1f87-135d21c6cb3f
# ╟─61962438-fb2d-11ea-1457-474a6f1bed46
# ╟─c81ed218-fb2d-11ea-0ede-d5a95b552f76
# ╟─350931d6-fb2c-11ea-33d6-f92777cf80cb
# ╟─3c5603a0-fb3a-11ea-1b1d-1b810afd0f3c
# ╟─804d9d48-fb3a-11ea-2534-6b24ce15d757
# ╟─472736f8-fb20-11ea-334a-0317b6f7c5bb
# ╟─cabadb00-f74c-11ea-08f6-698e030feb5c
# ╟─a874bae0-f817-11ea-2b43-ff026f3a5ad5
# ╟─9ddb9090-f817-11ea-01b8-5fc77c57439a
# ╟─91bbef94-f8cd-11ea-23c2-d995c54ea6cd
# ╟─11675672-f818-11ea-2db5-f145e043edc3
# ╟─c7f6ee12-f812-11ea-0a4c-c549497ecb01
# ╟─1b75f400-f818-11ea-3080-717a802487e2
# ╟─37536880-f81b-11ea-0e94-73ca89a3a08c
# ╟─961ad440-f80f-11ea-2360-39edf365e26b
# ╟─f9164c5a-f832-11ea-1634-e91163458a28
# ╟─47caadc4-f841-11ea-2e4c-0b3bc6f34ef2
# ╟─4c1ac444-f842-11ea-3a52-ab7b9386cfb9
# ╟─2d46071c-f83e-11ea-2d19-130b91a9cd39
# ╟─ec3b87a6-f83d-11ea-214a-e7b565eb3017
# ╟─1709c52e-f83e-11ea-08fb-bb392b1fae55
# ╟─170d1a12-f83e-11ea-08bf-a31a85565ecd
# ╟─f2d031b8-f845-11ea-0709-8775f541172f
# ╟─fc4a831a-f842-11ea-0855-0726089dcd2b
# ╟─d4bb5f00-f821-11ea-1208-27534472e671
# ╟─d0088550-f821-11ea-39ce-7dcfa8bbc450
# ╟─bd01f196-f844-11ea-2d57-3d645e744af1
# ╟─66405444-f845-11ea-0289-0f281a912820
# ╟─6fdc7fe4-f847-11ea-04de-4b121ccc8de6
# ╟─4768a90e-f847-11ea-36d8-8954804fd4ac
# ╟─c7d2cb9a-f847-11ea-3772-3382948535f5
# ╟─fc39fc20-f81d-11ea-02cc-27ff11c91303
# ╟─a86064fc-f847-11ea-30d2-8916c38b275b
# ╠═df191b8c-f83e-11ea-3284-1ff04daa4e61
# ╟─3e7ba3f0-f83b-11ea-248e-ff7dfe60f64e
# ╟─42cee020-f83b-11ea-24d6-2f14293b9d89
# ╟─8205f45e-f83b-11ea-2cdb-b935856c1839
# ╟─98eb5c32-f844-11ea-2680-edbe20c15aba
# ╟─9c7f4bf6-f83a-11ea-0aa5-2fdbd1a55d73
# ╠═82bb3c70-f812-11ea-3cd3-e56c047d9ba8
# ╠═1995c9b0-f815-11ea-24d2-bd0b25905784
# ╟─831f5224-f839-11ea-3d78-3918811d0a5d
# ╟─1201a710-f846-11ea-3863-db1ebda95fb6
# ╟─d3156610-f839-11ea-0282-5bcc40d80e14
# ╟─66246f08-f83c-11ea-292f-3730ef22f732
# ╠═86704ee6-f83f-11ea-239f-bbea986b5b72
# ╟─d45180e2-f832-11ea-22fa-c35ee3e39c87
# ╠═d22bace0-f7f4-11ea-1858-ddc3259e5ebd
# ╠═82858ca0-f7f5-11ea-2ca9-cd5c02cf03f3

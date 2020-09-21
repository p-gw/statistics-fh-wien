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

# ╔═╡ 138a0a50-f431-11ea-053a-8f430d193cb1
begin
	using Pkg
	Pkg.add("Distributions")
	Pkg.add("PlutoUI")
	Pkg.add("Plots")
	using Distributions, PlutoUI, Plots
end

# ╔═╡ c222f5a0-f430-11ea-288f-d394ab49704d
md"# Probability & statistical inference"

# ╔═╡ 24b48fe0-fc14-11ea-26c6-2b2dcabd228e
md"## Set theory"

# ╔═╡ 8b6fb1fe-fc14-11ea-33d4-f9a3e18de71b


# ╔═╡ 61b63f50-f431-11ea-0864-637e5c1234db
@bind μ Slider(-1:0.01:1, default = 0)

# ╔═╡ 7231265e-f431-11ea-3939-03cf49e56891
@bind σ Slider(0.5:0.01:3, default = 1)

# ╔═╡ 2e6d95d0-f431-11ea-0a3d-237a6205e52e
normDist = Normal(μ, σ)

# ╔═╡ 5174dece-f431-11ea-0338-a32fba27d90b
mean(normDist)

# ╔═╡ 5a27e400-f431-11ea-1a27-a1727caa79a4
std(normDist)

# ╔═╡ a4e77af0-f431-11ea-012e-936cbd44c101
var(normDist)

# ╔═╡ 0268b4a0-f432-11ea-3f2c-9fe01f6b1ec1
plot(-5:0.01:5, pdf.(normDist, -5:0.01:5), ylimit = [0, 0.75], legend = false)

# ╔═╡ 263f3210-fc15-11ea-1790-45dba8507246
md"## Discrete probability distributions"

# ╔═╡ 2b754580-fc15-11ea-38b3-a35d7aa65cc5
md"""### Bernoulli distribution"""

# ╔═╡ 37626710-fc15-11ea-3fe6-6d0a49881fb0
md"""### Binomial distribution"""

# ╔═╡ 3f0b0120-fc15-11ea-20a4-d76076d953a7
md"""### Uniform distribution"""

# ╔═╡ c883ff10-f431-11ea-3534-d7d48b4e2cf8
md"### Poisson distribution"

# ╔═╡ ce405980-f431-11ea-2f2d-1931d9d12580
@bind λ Slider(0.5:0.1:100, default = 5)

# ╔═╡ df7b0e20-f431-11ea-0304-2d1461c57a41
poisDist = Poisson(λ)

# ╔═╡ e81dbfa0-f431-11ea-0681-a1c7f11b3470
mean(poisDist)

# ╔═╡ ec07cb10-f431-11ea-3146-59849abd0a5a
var(poisDist)

# ╔═╡ fbb947a0-f431-11ea-11d0-d928e9f7961e
plot(0:50, pdf.(poisDist, 0:50), ylimit = [0, 0.65], xlabel = "x", ylabel = "P(X = x)", seriestype = :bar, legend = false)

# ╔═╡ 6261c9b0-fc15-11ea-35d6-ed44c70cfde6
md"## Continuous distributions"

# ╔═╡ 93acf580-fc15-11ea-2147-11037c3ef3f5
md"""### Exponential distribution"""

# ╔═╡ 98b716f0-fc15-11ea-207a-95e605fd43b5
md"""### Normal distribution"""

# ╔═╡ 9b1aa96e-fc15-11ea-1a2e-e9a882e1ea5a
md"""### Students T distribution"""

# ╔═╡ bbd80270-fc15-11ea-365d-a9596c8fbdf3
md"""### F distribution"""

# ╔═╡ bd43c770-fc15-11ea-0280-fbca8eff4b1a
md"""### χ² distribution"""

# ╔═╡ dc5c2300-fc15-11ea-3fae-971e3ccc7e3d
md"""## Inference & estimation"""

# ╔═╡ 77bff3d0-fc16-11ea-0ed8-fb8e7cfba439
md"""## Interpretations of probability"""

# ╔═╡ 9e90ea0e-f436-11ea-0b7f-ed0033c1cd86
plotly()

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
""",
md"""
![asd](https://upload.wikimedia.org/wikipedia/commons/thumb/0/0d/Sim%C3%A9onDenisPoisson.jpg/800px-Sim%C3%A9onDenisPoisson.jpg)
	
-- *Siméon Denis Poisson*
""", [66, 33])

# ╔═╡ 06490b90-fc13-11ea-190f-85fd09099588
two_columns(md"""
left content
""", md"""
![Carl Friedrich Gauß](https://upload.wikimedia.org/wikipedia/commons/3/33/Bendixen_-_Carl_Friedrich_Gau%C3%9F%2C_1828.jpg)

-- *Carl Friedrich Gauss*
""", [66, 33])

# ╔═╡ 201b0000-fc13-11ea-325e-0fa70d049ec7
center(x) = HTML("<div style='text-align: center'>$(Markdown.html(x))</div>")

# ╔═╡ 209b538e-fc13-11ea-1a2a-f1766b3d5671


# ╔═╡ Cell order:
# ╟─c222f5a0-f430-11ea-288f-d394ab49704d
# ╠═24b48fe0-fc14-11ea-26c6-2b2dcabd228e
# ╠═8b6fb1fe-fc14-11ea-33d4-f9a3e18de71b
# ╠═61b63f50-f431-11ea-0864-637e5c1234db
# ╠═7231265e-f431-11ea-3939-03cf49e56891
# ╠═2e6d95d0-f431-11ea-0a3d-237a6205e52e
# ╠═5174dece-f431-11ea-0338-a32fba27d90b
# ╠═5a27e400-f431-11ea-1a27-a1727caa79a4
# ╠═a4e77af0-f431-11ea-012e-936cbd44c101
# ╠═0268b4a0-f432-11ea-3f2c-9fe01f6b1ec1
# ╠═263f3210-fc15-11ea-1790-45dba8507246
# ╠═2b754580-fc15-11ea-38b3-a35d7aa65cc5
# ╠═37626710-fc15-11ea-3fe6-6d0a49881fb0
# ╠═3f0b0120-fc15-11ea-20a4-d76076d953a7
# ╠═c883ff10-f431-11ea-3534-d7d48b4e2cf8
# ╠═e2f533c0-fc13-11ea-0921-5d974294b4fe
# ╠═ce405980-f431-11ea-2f2d-1931d9d12580
# ╠═df7b0e20-f431-11ea-0304-2d1461c57a41
# ╠═e81dbfa0-f431-11ea-0681-a1c7f11b3470
# ╠═ec07cb10-f431-11ea-3146-59849abd0a5a
# ╟─fbb947a0-f431-11ea-11d0-d928e9f7961e
# ╠═6261c9b0-fc15-11ea-35d6-ed44c70cfde6
# ╠═93acf580-fc15-11ea-2147-11037c3ef3f5
# ╟─98b716f0-fc15-11ea-207a-95e605fd43b5
# ╟─06490b90-fc13-11ea-190f-85fd09099588
# ╠═9b1aa96e-fc15-11ea-1a2e-e9a882e1ea5a
# ╠═bbd80270-fc15-11ea-365d-a9596c8fbdf3
# ╟─bd43c770-fc15-11ea-0280-fbca8eff4b1a
# ╠═dc5c2300-fc15-11ea-3fae-971e3ccc7e3d
# ╠═77bff3d0-fc16-11ea-0ed8-fb8e7cfba439
# ╠═9e90ea0e-f436-11ea-0b7f-ed0033c1cd86
# ╠═138a0a50-f431-11ea-053a-8f430d193cb1
# ╠═1899c410-fc13-11ea-3779-99e4db3939a1
# ╠═201b0000-fc13-11ea-325e-0fa70d049ec7
# ╠═209b538e-fc13-11ea-1a2a-f1766b3d5671

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

# ╔═╡ c883ff10-f431-11ea-3534-d7d48b4e2cf8
md"## Poisson"

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

# ╔═╡ 9e90ea0e-f436-11ea-0b7f-ed0033c1cd86
plotly()

# ╔═╡ Cell order:
# ╠═c222f5a0-f430-11ea-288f-d394ab49704d
# ╠═61b63f50-f431-11ea-0864-637e5c1234db
# ╠═7231265e-f431-11ea-3939-03cf49e56891
# ╠═2e6d95d0-f431-11ea-0a3d-237a6205e52e
# ╠═5174dece-f431-11ea-0338-a32fba27d90b
# ╠═5a27e400-f431-11ea-1a27-a1727caa79a4
# ╠═a4e77af0-f431-11ea-012e-936cbd44c101
# ╠═0268b4a0-f432-11ea-3f2c-9fe01f6b1ec1
# ╠═c883ff10-f431-11ea-3534-d7d48b4e2cf8
# ╠═ce405980-f431-11ea-2f2d-1931d9d12580
# ╠═df7b0e20-f431-11ea-0304-2d1461c57a41
# ╠═e81dbfa0-f431-11ea-0681-a1c7f11b3470
# ╠═ec07cb10-f431-11ea-3146-59849abd0a5a
# ╟─fbb947a0-f431-11ea-11d0-d928e9f7961e
# ╠═9e90ea0e-f436-11ea-0b7f-ed0033c1cd86
# ╠═138a0a50-f431-11ea-053a-8f430d193cb1

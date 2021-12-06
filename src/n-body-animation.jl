using CSV
using DataFrames
using Plots

df = DataFrame(CSV.File("nbody_data.csv"))

x1 = df[!, "x1"]
y1 = df[!, "y1"]
x2 = df[!, "x2"]
y2 = df[!, "y2"]

N = length(x1)

anim = Plots.Animation()
@time for i = 1:N-1
    scatter(x1[i:i], y1[i:i], color = "red", legend = false, xlim = (-10, 10), ylim = (-10, 10))
    scatter!(x2[i:i], y2[i:i], color = "blue", legend = false)
    Plots.frame(anim)
end

gif(anim, "2-body.gif", fps = 120)
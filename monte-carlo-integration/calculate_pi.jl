function in_circle(x, y)
    radius_of_circle = 1
    return (x^2 + y^2) < radius_of_circle
end

count_circle = 0
count_square = 0
n = 100000000

@time for i = 1:n
    x = rand()
    y = rand()
    if in_circle(x, y)
        global count_circle += 1
    else
        global count_square += 1
    end
end

π_est = 4 * count_circle/n
println("Estimate of π = $(π_est)")
percent_error = (abs(π - π_est) / π) * 100
println("Pecentage Error = $percent_error %")

#=
using Plots
plt = scatter(circle_x, circle_y, color = "green", aspect_ratio = :equal)
scatter!(square_x, square_y, color = "red")

savefig(plt, "pi.png")
=#
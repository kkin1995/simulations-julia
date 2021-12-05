include("spring-pendulum.jl")
using Plots

initialAngle = 45
initialExtension = 1
l0 = 1
time, x, vx, θ, ω = SpringPendulum(initialAngle, initialExtension, l0 = l0, k = 1, step_size = 0.5, cycles = 1000)

l = l0 .+ x

xs = l .* sin.(θ)
ys = -l .* cos.(θ)

anim = Plots.Animation()
no_of_steps = length(time)

@time for i = 1:no_of_steps-1
    plot([0, xs[i]], [0, ys[i]], xlim = (-10, 10), ylim = (-10, 10),
        legend = false, title = "Initial Angle = " * string(initialAngle),
        aspect_ratio = :equal
        )
    scatter!(xs[i:i], ys[i:i], color = "red", legend = false)
    plot!(xs[1:i], ys[1:i], color = "blue", legend = false, linestyle = :dashdot)
    angle = rad2deg(atan(xs[i] / -ys[i]))
    annotate!(0, 1, text("Angle = " * string(angle), 10))
    Plots.frame(anim)
end

gif(anim, "spring_pendulum_animation.gif", fps = 240)
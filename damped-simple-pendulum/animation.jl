include("./damped-simple-pendulum.jl")
using .DampedSimplePendulumSimulation
using Plots

time, theta, _, _ = DampedSimplePendulum(45, alpha = 0.5, cycles = 10, step_size = 0.1)

xs = sin.(theta)
ys = -cos.(theta)

anim = Plots.Animation()
no_of_steps = length(time)

@time for i = 1:no_of_steps-1
    plot([0, xs[i]], [0, ys[i]], xlim = (-2,2), ylim = (-2,2), 
        legend = false, title = "Initial Angle = " * string(45),
        aspect_ratio = :equal
        )
    scatter!(xs[i:i], ys[i:i], color = "red", legend = false)
    angle = rad2deg(atan(xs[i] / -ys[i]))
    annotate!(0, 1, text("Angle = " * string(angle), 10))
    Plots.frame(anim)
end

gif(anim, "damped_simple_pendulum_animation.gif", fps = 120)
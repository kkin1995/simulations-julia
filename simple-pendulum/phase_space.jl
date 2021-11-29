include("./simple-pendulum.jl")
using .SimplePendulumSimulation
using Plots

function phase_plot(initialAngles)
    plot_list = Any[]
    for initialAngle in initialAngles
        println(initialAngle)
        _, theta, omega, _ = SimplePendulum(initialAngle)
        title = "Phase Space Plot"
        label = string(initialAngle) * " degress"
        push!(plot_list, plot(theta, omega, title = title, label = label))
    end
    xlabel!("Theta")
    ylabel!("Theta Dot")
    return plot_list
end


if abspath(PROGRAM_FILE) == @__FILE__
    initialAngles = 5
    plot_list = phase_plot(initialAngles)
    savefig(plot(plot_list...), "phase.png")
end

if isinteractive()
    initialAngles = 5
    plot_list = phase_plot(initialAngles)
    display(plot(plot_list...))
end
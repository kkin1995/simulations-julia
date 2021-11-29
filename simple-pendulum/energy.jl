include("./simple-pendulum.jl")
using .SimplePendulumSimulation
using Plots

function calculateEnergy(initialAngle, m = 1, g = 9.8, L = 1, cycles = 10, step_size = 0.001)
    time, theta, thetadot, _ = SimplePendulum(initialAngle, cycles = cycles, step_size = step_size)
    kineticEnergy = (1/2) * m * L^2 * thetadot.^2
    potentialEnergy = m * g * L * (1 .- cos.(theta))
    energy = kineticEnergy .+ potentialEnergy
    energy_plot = plot(time, kineticEnergy, label = "Kinetic Energy")
    plot!(time, potentialEnergy, label = "Potential Energy")
    plot!(time, energy, label = "Energy")
    xlabel!("Time")
    ylabel!("Energy")
    return kineticEnergy, potentialEnergy, energy, energy_plot
end

if abspath(PROGRAM_FILE) == @__FILE__
    _, _, _, energy_plot = calculateEnergy(10)
    savefig(energy_plot, "energy.png")
end
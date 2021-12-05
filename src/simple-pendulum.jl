function SimplePendulum(initialAngle; cycles = 10, step_size = 0.001)

    time = range(0.0, stop = cycles, step = step_size)
    N = length(time)

    theta = zeros(N)
    omega = zeros(N)

    theta[1] = deg2rad(initialAngle)
    omega[1] = deg2rad(0.0)

    for i = 1:N-1
        dtheta1 = step_size * omega[i]
        domega1 = step_size * omegaDot(theta[i])

        dtheta2 = step_size * (omega[i] + domega1/2)
        domega2 = step_size * omegaDot(theta[i] + dtheta1/2)

        dtheta3 = step_size * (omega[i] + domega2/2)
        domega3 = step_size * omegaDot(theta[i] + dtheta2/2)

        dtheta4 = step_size * (omega[i] + domega3)
        domega4 = step_size * omegaDot(theta[i] + dtheta3)

        dtheta = (dtheta1 + 2*dtheta2 + 2*dtheta3 + dtheta4) / 6
        domega = (domega1 + 2*domega2 + 2*domega3 + domega4) / 6

        theta[i+1] = theta[i] + dtheta
        omega[i+1] = omega[i] + domega

    end
    
    title = "Simple Pendulum Initial Angle: " * string(initialAngle)
    plt = plot(time, theta, title = title, label = "Non - Linear Pendulum")
    xlabel!("Time")
    ylabel!("Theta θ")
    return time, theta, omega, plt
end

function omegaDot(theta, g = 9.8, L = 1)
    return - (g/L) * sin(theta)
end

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
    initialAngle = parse(Float64, ARGS[1])
    theta, omega, plt = SimplePendulum(initialAngle)
    savefig(plt, "plot.png")
end
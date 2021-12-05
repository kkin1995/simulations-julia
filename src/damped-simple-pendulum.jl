function DampedSimplePendulum(initialAngle; alpha = 0.1, cycles = 10, step_size = 0.001)

    time = range(0.0, stop = cycles, step = step_size)
    N = length(time)

    theta = zeros(N)
    omega = zeros(N)

    theta[1] = deg2rad(initialAngle)
    omega[1] = deg2rad(0.0)

    for i = 1:N-1
        dtheta1 = step_size * omega[i]
        domega1 = step_size * omegaDot(theta[i], omega[i], alpha = alpha)

        dtheta2 = step_size * (omega[i] + domega1/2)
        domega2 = step_size * omegaDot(theta[i] + dtheta1/2, omega[i], alpha = alpha)

        dtheta3 = step_size * (omega[i] + domega2/2)
        domega3 = step_size * omegaDot(theta[i] + dtheta2/2, omega[i], alpha = alpha)

        dtheta4 = step_size * (omega[i] + domega3)
        domega4 = step_size * omegaDot(theta[i] + dtheta3, omega[i], alpha = alpha)

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

function omegaDot(theta, omega; alpha = 0.1, g = 9.8, L = 1)
    return (-alpha * omega) - (g/L) * sin(theta)
end


if abspath(PROGRAM_FILE) == @__FILE__
    initialAngle = parse(Float64, ARGS[1])
    _, theta, omega, plt = DampedSimplePendulum(initialAngle)
    savefig(plt, "plot.png")
end
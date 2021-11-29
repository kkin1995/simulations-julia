module DoublePendulumSimulation

using Plots

function DoublePendulum(initialAngle_1, initialAngle_2; m1 = 1, m2 = 1, L1 = 1, L2 = 1, g = 9.8, cycles = 10, step_size = 0.1)

    time = range(0.0, stop = cycles, step = step_size)
    N = length(time)
    println("Total Number of Time Steps = $N")
    θ1 = zeros(N)
    θ2 = zeros(N)
    ω1 = zeros(N)
    ω2 = zeros(N)

    θ1[1] = deg2rad(initialAngle_1)
    ω1[1] = deg2rad(0.0)
    θ2[1] = deg2rad(initialAngle_2)
    ω2[1] = deg2rad(0.0)

    @time for i = 1:N-1
        #dω1_1 = 0.0
        dω2_1 = 0.0
        println("Time Step $i")
        println("θ1 = $(θ1[i])")
        println("θ2 = $(θ2[i])")
        println("ω1 = $(ω1[i])")
        println("ω2 = $(ω2[i])")

        dθ1_1 = step_size * ω1[i]
        dω1_1 = step_size * ω1dot(dω2_1, θ1[i], θ2[i], ω2[i], m1, m2, L1, L2, g)
        dθ2_1 = step_size * ω2[i]
        dω2_1 = step_size * ω2dot(dω1_1, θ1[i], θ2[i], ω1[i], m2, L1, L2, g)

        dθ1_2 = step_size * (ω1[i] + (dω1_1 / 2))
        dω1_2 = step_size * ω1dot(dω2_1, θ1[i] + (dθ1_1 / 2), θ2[i] + (dθ2_1 / 2), ω2[i] + (dω2_1 / 2), m1, m2, L1, L2, g)
        dθ2_2 = step_size * (ω2[i] + (dω2_1 / 2))
        dω2_2 = step_size * ω2dot(dω1_1, θ1[i] + (dθ1_1 / 2), θ2[i] + (dθ2_1 / 2), ω1[i] + (dω1_1 / 2), m2, L1, L2, g)

        dθ1_3 = step_size * (ω1[i] + (dω1_2 / 2))
        dω1_3 = step_size * ω1dot(dω2_2, θ1[i] + (dθ1_2 / 2), θ2[i] + (dθ2_2 / 2), ω2[i] + (dω2_2 / 2), m1, m2, L1, L2, g)
        dθ2_3 = step_size * (ω2[i] + (dω2_2 / 2))
        dω2_3 = step_size = ω2dot(dω1_2, θ1[i] + (dθ1_2 / 2), θ2[i] + (dθ2_2 / 2), ω1[i] + (dω1_2 / 2), m2, L1, L2, g)

        dθ1_4 = step_size * (ω1[i] + dω1_3)
        dω1_4 = step_size * ω1dot(dω2_3, θ1[i] + dθ1_3, θ2[i] + dθ2_3, ω2[i] + dω2_3, m1, m2, L1, L2, g)
        dθ2_4 = step_size * (ω2[i] + dω2_3)
        dω2_4 = step_size * ω2dot(dω1_3, θ1[i] + dθ1_3, θ2[i] + dθ2_3, ω1[i] + dω1_3, m2, L1, L2, g)

        dθ1 = (dθ1_1 + 2*dθ1_2 + 2*dθ1_3 + dθ1_4) / 6
        dω1 = (dω1_1 + 2*dω1_2 + 2*dω1_3 + dω1_4) / 6
        dθ2 = (dθ2_1 + 2*dθ2_2 + 2*dθ2_3 + dθ2_4) / 6
        dω2 = (dω2_1 + 2*dω2_2 + 2*dω2_3 + dω2_4) / 6

        θ1[i+1] = θ1[i] + dθ1
        ω1[i+1] = ω1[i] + dω1
        θ2[i+1] = θ2[i] + dθ2
        ω2[i+1] = ω2[i] + dω2

    end
    return time, θ1, ω1, θ2, ω2
end

function ω1dot(ω2dot, θ1, θ2, ω2, m1, m2, L1, L2, g)
    numerator = (- m2 * L2 * ω2dot * cos(θ1 - θ2)) - (m2 * L2 * ω2^2 * sin(θ1 - θ2)) - ((m1 + m2) * g * sin(θ1))
    denominator = (m1 + m2) * L1
    return numerator / denominator
end

function ω2dot(ω1dot, θ1, θ2, ω1, m2, L1, L2, g)
    numerator = (- m2 * L1 * ω1dot * cos(θ1 - θ2)) + (m2 * L1 * ω1^2 * sin(θ1 - θ2)) - (m2 * g * sin(θ2))
    denominator = m2 * L2
    return numerator / denominator
end


#if abspath(PROGRAM_FILE) == @__FILE__
    #initialAngle_1 = parse(Float64, ARGS[1])
    #initialAngle_2 = parse(Float64, ARGS[2])
    initialAngle_1 = 0.0
    initialAngle_2 = 1.0
    time, θ1, θ2, ω1, ω2 = DoublePendulum(initialAngle_1, initialAngle_2)
    p1 = plot(time, θ1)
    p2 = plot(time, θ2)
    p3 =  plot(time, ω1)
    p4 = plot(time, ω2)
    plt = plot(p1, p2, p3, p4)
    savefig(plt, "plot.png")
#end

end
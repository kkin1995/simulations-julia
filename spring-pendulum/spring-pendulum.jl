module SpringPendulumSimulation

export SpringPendulum, omegaDot, vxdot

using Plots

function SpringPendulum(initialAngle, initialExtension; l0 = 1, k = 1, m = 1, g = 9.8, cycles = 10, step_size = 0.01)

    time = range(0.0, stop = cycles, step = step_size)
    N = length(time)

    θ = zeros(N)
    ω = zeros(N)
    x = zeros(N)
    vx = zeros(N)

    θ[1] = deg2rad(initialAngle)
    ω[1] = deg2rad(0.0)
    x[1] = initialExtension
    vx[1] = 0.0

    @time for i = 1:N-1
        #=
        println("θ = $(θ[i])")
        println("ω = $(ω[i])")
        println("x = $(x[i])")
        println("vx = $(vx[i])")
        =#
        
        dxdot1 = step_size * vx[i]
        dvxdot1 = step_size * vxdot(x[i], θ[i], ω[i], m = m, l0 = l0, g = g, k = k)
        dθdot1 = step_size * ω[i]
        dωdot1 = step_size * omegaDot(x[i], vx[i], θ[i], ω[i], l0 = l0, g = g)

        dxdot2 = step_size * (vx[i] + (dvxdot1 / 2))
        dvxdot2 = step_size * vxdot(x[i] + (dxdot1 / 2), θ[i] + (dθdot1 / 2), ω[i] + (dωdot1 / 2), m = m, l0 = l0, g = g, k = k)
        dθdot2 = step_size * (ω[i] + (dωdot1 / 2))
        dωdot2 = step_size * omegaDot(x[i] + (dxdot1 / 2), vx[i] + (dvxdot1 / 2), θ[i] + (dθdot1 / 2), ω[i] + (dωdot1 / 2), l0 = l0, g = g)

        dxdot3 = step_size * (vx[i] + (dvxdot2 / 2))
        dvxdot3 = step_size * vxdot(x[i] + (dxdot2 / 2), θ[i] + (dθdot2 / 2), ω[i] + (dωdot2 / 2), m = m, l0 = l0, g = g, k = k)
        dθdot3 = step_size * (ω[i] + (dωdot2 / 2))
        dωdot3 = step_size * omegaDot(x[i] + (dxdot2 / 2), vx[i] + (dvxdot2 / 2), θ[i] + (dθdot2 / 2), ω[i] + (dωdot2 / 2), l0 = l0, g = g)

        dxdot4 = step_size * vx[i] + dvxdot3
        dvxdot4 = step_size * vxdot(x[i] + dxdot3, θ[i] + dθdot3, ω[i] + dωdot3, m = m, l0 = l0, g = g, k = k)
        dθdot4 = step_size * ω[i] + dωdot3
        dωdot4 = step_size * omegaDot(x[i] + dxdot3, vx[i] + dvxdot3, θ[i] + dθdot3, ω[i] + dωdot3, l0 = l0, g = g)

        dxdot = (dxdot1 + 2*dxdot2 + 2*dxdot3 + dxdot4) / 6
        dvxdot = (dvxdot1 + 2*dvxdot2 + 2*dvxdot3 + dvxdot4) / 6
        dθdot = (dθdot1 + 2*dθdot2 + 2*dθdot3 + dθdot4) / 6
        dωdot = (dωdot1 + 2*dωdot2 + 2*dωdot3 + dωdot4) / 6

        x[i+1] = x[i] + dxdot
        vx[i+1] = vx[i] + dvxdot
        θ[i+1] = θ[i] + dθdot
        ω[i+1] = ω[i] + dωdot

    end
    return time, x, vx, θ, ω
end

function omegaDot(x, vx, θ, ω; l0 = 1, g = 9.8)
    eqn = ((-2 / (l0 + x)) * vx * ω) - (g / (l0 + x)) * sin(θ)
    return eqn
end

function vxdot(x, θ, ω; m = 1, l0 = 1, g = 9.8, k = 1)
    eqn = ((l0 + x) * ω^2) + (g * cos(θ)) - (k / m) * x
    return eqn
end


if abspath(PROGRAM_FILE) == @__FILE__
    initialAngle = 10
    initialExtension = 2
    time, x, vx, θ, ω = SpringPendulum(initialAngle, initialExtension)
    p1 = plot(time, x, xlabel = "time", ylabel = "x")
    p2 = plot(time, vx, xlabel = "time", ylabel = "vx")
    p3 = plot(time, θ, xlabel = "time", ylabel = "θ")
    p4 = plot(time, ω, xlabel = "time", ylabel = "ω")
    p5 = plot(θ, ω, xlabel = "θ", ylabel = "ω")
    p6 = plot(x, vx, xlabel = "x", ylabel = "vx")
    plt = plot(p1, p2, p3, p4, p5, p6)
    savefig(plt, "plot.png")
end

end
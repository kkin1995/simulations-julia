"""
Performs a single step of the Runge - Kutta 4th Order for a
single order ordinary differential equation

Parameters:
time::Vector{Float64} - Vector of time steps to integrate the differential equation at
x0::Float64 - Initial Condition at t = 0
F::Function - Callable Function representing the first order differential equation in the form

\$\\ddot{x}\$ = F(x, args)

args - Other arguments to be passed into the function F
"""
function rk4_single_order(time::Vector{Float64}, x0::Float64, F::Function, args...)
    step_size = time[2] - time[1]
    N = length(time)
    x = zeros(N)
    x[1] = x0
    for i = 1:N
        dx1 = step_size * F(x[i], args...)
        dx2 = step_size * F(x[i] * (dx1 / 2), args...)
        dx3 = step_size * F(x[i] * (dx2 / 2), args...)
        dx4 = step_size * F(x[i] * dx3, args...)
        dx = (dx1 + 2*dx2 + 2*dx3 + dx4) / 6
        x[i+1] = x[i] + dx
    end
    return x
end

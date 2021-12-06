#=
TODO:
-- Velocity of both bodies remaining constant. Needs to be fixeds
=#
function dvx2dt(m1, x1, x2, y1, y2)
    global G
    r12 = sqrt((x2 - x1)^2 + (y2 - y1)^2)
    eqn = G * m1 * (x2 - x1)
    eqn = eqn / r12^3
    return eqn
end

function dvx1dt(m2, x1, x2, y1, y2)
    global G
    r12 = sqrt((x2 - x1)^2 + (y2 - y1)^2)
    eqn = G * m2 * (x2 - x1)
    eqn = eqn / r12^3
    return eqn
end

function dvy1dt(m2, x1, x2, y1, y2)
    global G
    r12 = sqrt((x2 - x1)^2 + (y2 - y1)^2)
    eqn =  G * m2 * (y2 - y1)
    eqn = eqn / r12^3
    return eqn
end

function dvy2dt(m1, x1, x2, y1, y2)
    global G
    r12 = sqrt((x2 - x1)^2 + (y2 - y1)^2)
    eqn = G * m1 * (y2 - y1)
    eqn = eqn / r12^3
    return eqn
end

G = 6.67408e-11 # m3 kg-1 s-2

m1 = 1.0
m2 = 333165.0

x1_0 = 1
x2_0 = 0
y1_0 = 0
y2_0 = 0
vx1_0 = 0.5
vx2_0 = 0.5
vy1_0 = 0.5
vy2_0 = 0.5

no_of_steps = 100
step_size = 0.1
time = range(0.0, no_of_steps, step = step_size)
N = length(time) # number of steps

x1 = zeros(N)
x2 = zeros(N)
y1 = zeros(N)
y2 = zeros(N)
vx1 = zeros(N)
vx2 = zeros(N)
vy1 = zeros(N)
vy2 = zeros(N)

x1[1] = x1_0
x2[1] = x2_0
y1[1] = y1_0
y2[1] = y2_0
vx1[1] = vx1_0
vx2[1] = vx2_0
vy1[1] = vy1_0
vy2[1] = vy2_0

f = open("nbody_data.csv", "w")
write(f, "x1,x2,y1,y2,vx1,vx2,vy1,vy2\n")

@time for i = 1:N-1
    dx1_1 = step_size * vx1[i]
    dvx1_1 = step_size * dvx1dt(m2, x1[i], x2[i], y1[i], y2[i])
    dx2_1 = step_size * vx2[i]
    dvx2_1 = step_size * dvx2dt(m1, x1[i], x2[i], y1[i], y2[i])
    dy1_1 = step_size * vy1[i]
    dvy1_1 = step_size * dvy1dt(m2, x1[i], x2[i], y1[i], y2[i])
    dy2_1 = step_size * vy2[i]
    dvy2_1 = step_size * dvy2dt(m1, x1[i], x2[i], y1[i], y2[i])

    dx1_2 = step_size * (vx1[i] + dvx1_1 / 2)
    dvx1_2 = step_size * dvx1dt(m2, x1[i] + dx1_1 / 2, x2[i] + dx2_1 / 2, y1[i] + dy1_1 / 2, y2[i] + dy2_1 / 2)
    dx2_2 = step_size * (vx2[i] + dvx2_1 / 2)
    dvx2_2 = step_size * dvx2dt(m1, x1[i] + dx1_1 / 2, x2[i] + dx2_1 / 2, y1[i] + dy1_1 / 2, y2[i] + dy2_1 / 2)
    dy1_2 = step_size * (vy1[i] + dvy1_1 / 2)
    dvy1_2 = step_size * dvy1dt(m2, x1[i] + dx1_1 / 2, x2[i] + dx2_1 / 2, y1[i] + dy1_1 / 2, y2[i] + dy2_1 / 2)
    dy2_2 = step_size * (vy2[i] + dvy2_1 / 2)
    dvy2_2 = step_size * dvy2dt(m1, x1[i] + dx1_1 / 2, x2[i] + dx2_1 / 2, y1[i] + dy1_1 / 2, y2[i] + dy2_1 / 2)

    dx1_3 = step_size * (vx1[i] + dvx1_2 / 2)
    dvx1_3 = step_size * dvx1dt(m2, x1[i] + dx1_2 / 2, x2[i] + dx2_2 / 2, y1[i] + dy1_2 / 2, y2[i] + dy2_2 / 2)
    dx2_3 = step_size * (vx2[i] + dvx2_2 / 2)
    dvx2_3 = step_size * dvx2dt(m1, x1[i] + dx1_2 / 2, x2[i] + dx2_2 / 2, y1[i] + dy1_2 / 2, y2[i] + dy2_2 / 2)
    dy1_3 = step_size * (vy1[i] + dvy1_2 / 2)
    dvy1_3 = step_size * dvy1dt(m2, x1[i] + dx1_2 / 2, x2[i] + dx2_2 / 2, y1[i] + dy1_2 / 2, y2[i] + dy2_2 / 2)
    dy2_3 = step_size * (vy2[i] + dvy2_2 / 2)
    dvy2_3 = step_size * dvy2dt(m1, x1[i] + dx1_2 / 2, x2[i] + dx2_2 / 2, y1[i] + dy1_2 / 2, y2[i] + dy2_2 / 2)

    dx1_4 = step_size * (vx1[i] + dvx1_3)
    dvx1_4 = step_size * dvx1dt(m2, x1[i] + dx1_3, x2[i] + dx2_3, y1[i] + dy1_3, y2[i] + dy2_3)
    dx2_4 = step_size * (vx2[i] + dvx2_3)
    dvx2_4 = step_size * dvx2dt(m1, x1[i] + dx1_3, x2[i] + dx2_3, y1[i] + dy1_3, y2[i] + dy2_3)
    dy1_4 = step_size * (vy1[i] + dvy1_3)
    dvy1_4 = step_size * dvy1dt(m2, x1[i] + dx1_3, x2[i] + dx2_3, y1[i] + dy1_3, y2[i] + dy2_3)
    dy2_4 = step_size * (vy2[i] + dvy2_3)
    dvy2_4 = step_size * dvy2dt(m1, x1[i] + dx1_3, x2[i] + dx2_3, y1[i] + dy1_3, y2[i] + dy2_3)

    dx1 = (dx1_1 + 2*dx1_2 + 2*dx1_3 + dx1_4) / 6
    dx2 = (dx2_1 + 2*dx2_2 + 2*dx2_3 + dx2_4) / 6
    dy1 = (dy1_1 + 2*dy1_2 + 2*dy1_3 + dy1_4) / 6
    dy2 = (dy2_1 + 2*dy2_2 + 2*dy2_3 + dy2_4) / 6
    dvx1 = (dvx1_1 + 2*dvx1_2 + 2*dvx1_3 + dvx1_4) / 6
    dvx2 = (dvx2_1 + 2*dvx2_2 + 2*dvx2_3 + dvx2_4) / 6
    dvy1 = (dvy1_1 + 2*dvy1_2 + 2*dvy1_3 + dvy1_4) / 6
    dvy2 = (dvy2_1 + 2*dvy2_2 + 2*dvy2_3 + dvy2_4) / 6

    x1[i+1] = x1[i] + dx1
    x2[i+1] = x2[i] + dx2
    y1[i+1] = y1[i] + dy1
    y2[i+1] = y2[i] + dy2
    vx1[i+1] = vx1[i] + dvx1
    vx2[i+1] = vx2[i] + dvx2
    vy1[i+1] = vy1[i] + dvy1
    vy2[i+1] = vy2[i] + dvy2

    write(f, "$(x1[i]),$(x2[i]),$(y1[i]),$(y2[i]),$(vx1[i]),$(vx2[i]),$(vy1[i]),$(vy2[i])\n")
end

close(f)
module Donut

using GLMakie

export donut

"""
donut

# Arguments
- `K1::Float64`: Distance from eye to screen
- `K2::Float64`: Distance from screen to donut
- `R1::Float64`: Donut thickness radius
- `R2::Float64`: Donut hole radius

"""
function donut(
        K1::Float64=5.0,
        K2::Float64=5.0,
        R1::Float64=1.0,
        R2::Float64=2.0,
        nframes::Integer=50
    )
    # Define the donut
    fx(θ, ϕ, A, B) = (R2+R1*cos(θ))*(cos(B)*cos(ϕ)+sin(A)*sin(B)*sin(ϕ))-R1*cos(A)*sin(B)*sin(θ)
    fy(θ, ϕ, A, B) = (R2+R1*cos(θ))*(sin(B)*cos(ϕ)-sin(A)*cos(B)*sin(ϕ))+R1*cos(A)*cos(B)*sin(θ)
    fz(θ, ϕ, A, B) = cos(A)*(R2+R1*cos(θ))*sin(ϕ)+R1*sin(A)*sin(θ)

    # Make the donut
    Ts = range(0, stop=2pi, length=100)
    Ps = range(0, stop=2pi, length=100)
    As = range(0, stop=2pi, length=nframes)
    Bs = range(0, stop=2pi, length=nframes)
    x = [[fx(t, p, As[i], Bs[i]) for t in Ts, p in Ps] for i in 1:nframes]
    y = [[fy(t, p, As[i], Bs[i]) for t in Ts, p in Ps] for i in 1:nframes]
    z = [[fz(t, p, As[i], Bs[i]) for t in Ts, p in Ps] for i in 1:nframes]

    # Show the donut
    fig = Figure(resolution = (1200, 800))
    ax = Axis3(
        fig; 
        aspect=(1, 1, 1), 
        limits=(-3, 3, -3, 3, -3, 3), 
        viewmode=:fit
    )
    torus = surface!(
        ax, 
        x[30], y[30], z[30], 
        colormap=:heat
    )
    hidedecorations!(ax)
    hidespines!(ax)
    fig[1, 1] = ax
    fig

    return fig
end

end # module

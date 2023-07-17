module Donut

using GLMakie

export donut

"""
    donut()

Animate a 3D spinning donut.

# Keyword arguments
- `outfile::AbstractString`: Output to a file instead of displaying on screen. 
  Supports `.gif`, `.mp4`, `.mkv`, and `.webm`. 
  See https://docs.makie.org/stable/documentation/animation/#file_formats.
- `R1::Real`: Donut thickness radius
- `R2::Real`: Donut hole radius
- `xspinperiod::Real`: Donut spin period about the x-axis in seconds
- `zspinperiod::Real`: Donut spin period about the z-axis in seconds
- `duration::Real`: Duration of the animation
- `framerate::Real`: Framerate of the animation
- `resolution::Tuple{Int,Int}`: Resolution of the animation in pixels
"""
function donut(;
        outfile::Union{Nothing,AbstractString}=nothing,
        R1::Real=1.0,
        R2::Real=2.0,
        xspinperiod::Real=2.0,
        zspinperiod::Real=5.0,
        duration::Real=10.0,
        framerate::Real=60,
        resolution::Tuple{Integer,Integer}=(800, 800)
    )
    # Define the donut surface
    fx(θ, ϕ, A, B) = (R2+R1*cos(θ))*(cos(B)*cos(ϕ)+sin(A)*sin(B)*sin(ϕ))-R1*cos(A)*sin(B)*sin(θ)
    fy(θ, ϕ, A, B) = (R2+R1*cos(θ))*(sin(B)*cos(ϕ)-sin(A)*cos(B)*sin(ϕ))+R1*cos(A)*cos(B)*sin(θ)
    fz(θ, ϕ, A, B) = cos(A)*(R2+R1*cos(θ))*sin(ϕ)+R1*sin(A)*sin(θ)

    # Define the donut spin
    fA(t) = 2pi / xspinperiod * t
    fB(t) = 2pi / zspinperiod * t

    # Make the donut
    time = Observable(0.0)
    θs = range(0, stop=2pi, length=100)
    ϕs = range(0, stop=2pi, length=50)
    fx(t) = [fx(θ, ϕ, fA(t), fB(t)) for θ in θs, ϕ in ϕs]
    fy(t) = [fy(θ, ϕ, fA(t), fB(t)) for θ in θs, ϕ in ϕs]
    fz(t) = [fz(θ, ϕ, fA(t), fB(t)) for θ in θs, ϕ in ϕs]
    xs = @lift fx($time)
    ys = @lift fy($time)
    zs = @lift fz($time)

    # Plot the donut
    fig = Figure(resolution=resolution)
    ax = Axis3(
        fig; 
        aspect=(1, 1, 1), 
        limits=(-3, 3, -3, 3, -3, 3), 
    )
    surface!(
        ax, 
        xs, ys, zs;
        colormap=:heat
    )
    hidedecorations!(ax)
    hidespines!(ax)
    fig[1, 1] = ax

    # Spin the donut
    timestamps = range(0, stop=duration, step=1/framerate)
    if !isnothing(outfile)
        # Save the donut
        record(fig, outfile, timestamps; framerate=framerate) do t
            time[] = t
        end
    else
        # Show the donut
        display(fig)
        for t in timestamps
            time[] = t
            sleep(1 / framerate)
        end
    end

    return fig
end

end # module

module Donut

# import Plots
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
    )
    # Define the donut
    donut_surface(θ, ϕ, A, B) = [
        (R2+R1*cos(θ))*(cos(B)*cos(ϕ)+sin(A)*sin(B)*sin(ϕ))-R1*cos(A)*sin(B)*sin(θ);
        (R2+R1*cos(θ))*(sin(B)*cos(ϕ)-sin(A)*cos(B)*sin(ϕ))+R1*cos(A)*sin(B)*sin(θ);
        cos(A)*(R2+R1*cos(θ))*sin(ϕ)+R1*sin(A)*sin(θ)
    ]

    # Make the donut
    theta = range(0, stop=2pi, length=100)
    phi = range(0, stop=2pi, length=100)
    A = 0
    B = 0
    points = donut_surface.(theta, phi, A, B)

    # Show the donut
    fig = Figure()
    ax = LScene(fig)
    torus = wireframe!(
        ax, 
        [p[1] for p in points], 
        [p[2] for p in points], 
        [p[3] for p in points]; 
        # colormap=:plasma, 
        # shading=false
    )

    return fig
end

function example()
    # U = LinRange(-pi, pi, 100)
    # V = LinRange(-pi, pi, 20)
    # x1 = [cos(u) + 0.5 * cos(u) * cos(v) for u in U, v in V]
    # y1 = [sin(u) + 0.5 * sin(u) * cos(v) for u in U, v in V]
    # z1 = [0.5 * sin(v) for u in U, v in V]
    # x2 = [1 + cos(u) + 0.5 * cos(u) * cos(v) for u in U, v in V]
    # y2 = [0.5 * sin(v) for u in U, v in V]
    # z2 = [sin(u) + 0.5 * sin(u) * cos(v) for u in U, v in V]

    R1=1.0
    R2=2.0
    donut_surface(θ, ϕ, A, B) = [
        (R2+R1*cos(θ))*(cos(B)*cos(ϕ)+sin(A)*sin(B)*sin(ϕ))-R1*cos(A)*sin(B)*sin(θ);
        (R2+R1*cos(θ))*(sin(B)*cos(ϕ)-sin(A)*cos(B)*sin(ϕ))+R1*cos(A)*sin(B)*sin(θ);
        cos(A)*(R2+R1*cos(θ))*sin(ϕ)+R1*sin(A)*sin(θ)
    ]
    theta = range(0, stop=2pi, length=100)
    phi = range(0, stop=2pi, length=100)
    A = 0
    B = 0
    points = [donut_surface(t, p, A, B) for t in theta for p in phi]
    x1 = [p[1] for p in points]
    y1 = [p[2] for p in points]
    z1 = [p[3] for p in points]

    fig = Figure(resolution = (1200, 800))
    ax = LScene(fig, show_axis = true)
    tori1 = surface!(ax, x1, y1, z1; colormap = :viridis, shading = false,
        transparency = true)
    # tori2 = surface!(ax, x2, y2, z2; colormap = :plasma, shading = false,
    #     transparency = false)
    # wireframe!(ax, x1, y1, z1; linewidth = 0.5, transparency = true)

    # axis = ax.scene[OldAxis]
    # axis[:names, :axisnames] = ("x", "y", "z")
    # tstyle = axis[:names] #  get the nested attributes and work directly with them

    # tstyle[:fontsize] = 15
    # tstyle[:textcolor] = (:red, :green, :black)
    # tstyle[:font] = "helvetica"
    # tstyle[:gap] = 10
    # axis[:ticks][:textcolor] = :black
    # axis[:ticks][:fontsize] = 10
    # cbar1 = Colorbar(fig, tori1, label = "z", width = 25, ticklabelsize = 20,
    #     labelsize = 20, ticksize = 25, tickalign = 1, height = Relative(0.5))
    # cbar2 = Colorbar(fig, tori2, label = "z", width = 25, flipaxis = false,
    #     labelsize = 20, ticklabelsize = 20, ticksize = 25, tickalign = 1,
    #     height = Relative(0.5))
    # fig[1, 2] = ax
    # fig[1, 3] = cbar1
    # fig[1, 1] = cbar2
    # colgap!(fig.layout, 2)
    fig
end

end # module

using DDS
using CairoMakie

begin # test of the structure
    f = Figure(resolution = (3000, 4000))

    grid = GridLayout()
    upper_grid = GridLayout()
    lower_grid1 = GridLayout()
    lower_grid2 = GridLayout()

    grid[1,1] = upper_grid
    grid[2:3,1] = Axis(f, backgroundcolor=:blue)
    grid[4,1] = lower_grid1
    grid[5,1] = lower_grid2

    upper_grid[1,1] = Axis(f,backgroundcolor=:red)
    upper_grid[1,3] = Axis(f,backgroundcolor=:red)

    lower_grid1[1,1] = Axis(f, backgroundcolor=:red)
    lower_grid2[1,1] = Axis(f, backgroundcolor=:red)

    f.layout[1, 1] = grid
    rowgap!(grid, 100)
    colgap!(upper_grid, -600)
    # colgap!(lower_grid, -30)

    f
end
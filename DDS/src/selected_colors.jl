using MakiePublication

begin
    # const color_pallete = MakiePublication.COLORS[2]
    # const color_pallete = MakiePublication.COLORS[12]
    const color_pallete = MakiePublication.COLORS[14]
    const BLUE = color_pallete[1]
    const ORANGE = color_pallete[2]
    const GREEN = color_pallete[3]
    const RED = color_pallete[4]
    const PURPLE = color_pallete[5]
    const BROWN = color_pallete[6]
    const PINK = color_pallete[7]
    const GRAY = color_pallete[8]
    const YELLOW = color_pallete[9]
    const LIGHT_BLUE = color_pallete[10];
end;

rgba(r, g, b, a) = RGBAf(r/255, g/255, b/255, a)

export BLUE, ORANGE, GREEN, RED, PURPLE, BROWN, PINK, GRAY, YELLOW, LIGHT_BLUE
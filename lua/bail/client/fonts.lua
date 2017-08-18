--print("bail/lua/bail/client/fonts.lua")

-- Fonts
local font_family = "Trebuchet MS"
if COINTOSS_CONFIG ~= nil and COINTOSS_CONFIG.font_family ~= nil then font_family = COINTOSS_CONFIG.font_family end 
local fonts = {
    {size = 32, weight = 1000},
    {size = 28, weight = 1000},
    {size = 24, weight = 1000},
    {size = 20, weight = 600},
    {size = 16, weight = 500},
}

for k,v in ipairs(fonts) do
    local font_name = "BailOfficer_" .. v.size .. "_" .. v.weight
    --print("LOADED FONT: " .. font_name)
    surface.CreateFont(font_name, {
        font = font_family,
        size = v.size,
        weight = v.weight,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false,
    })
end
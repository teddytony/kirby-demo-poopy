function rgbToHex(r,g,b)
    -- EXPLANATION:
    -- The integer form of RGB is 0xRRGGBB
    -- Hex for red is 0xRR0000
    -- Multiply red value by 0x10000(65536) to get 0xRR0000
    -- Hex for green is 0x00GG00
    -- Multiply green value by 0x100(256) to get 0x00GG00
    -- Blue value does not need multiplication.

    -- Final step is to add them together
    -- (r * 0x10000) + (g * 0x100) + b =
    -- 0xRR0000 +
    -- 0x00GG00 +
    -- 0x0000BB =
    -- 0xRRGGBB
    local rgb = (r * 0x10000) + (g * 0x100) + b
    return string.format("%x", rgb)
end
function onCreate()
    makeLuaSprite("playerHealthBar", null, 0, 0)
    makeGraphic("playerHealthBar", 256, 256, rgbToHex(
        getProperty("boyfriend.healthColorArray[0]")
        ,getProperty("boyfriend.healthColorArray[1]")
        ,getProperty("boyfriend.healthColorArray[2]")))
    setObjectCamera("playerHealthBar", 'camHUD')
    addLuaSprite("playerHealthBar", false)
end
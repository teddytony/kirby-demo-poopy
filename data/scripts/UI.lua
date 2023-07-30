local wkueya = {40,40}
local uiyg = {5,5}
local bfHealth = 200 / 10
local dadHealth = 0 / 10
local broJustMissedANote = 1
function to_hex(rgb)
	return string.format("%x", (rgb[1] * 0x10000) + (rgb[2] * 0x100) + rgb[3])
end
function setObjectPosition(object,x,y)
    if x == nil and y ~= nil then
        setProperty(object..".x", getProperty(object..".x"))
        setProperty(object..".y", y)
    elseif x ~= nil and y == nil  then
        setProperty(object..".x", x)
        setProperty(object..".y", getProperty(object..".y"))
    elseif x == nil and y == nil then
        setProperty(object..".x", getProperty(object..".x"))
        setProperty(object..".y", getProperty(object..".y"))
    else
        setProperty(object..".x", x)
        setProperty(object..".y", y)
    end
end
function setObjectWandH(object,width,height)
    if width == nil and height ~= nil then
        setProperty(object..".width", getProperty(object..".width"))
        setProperty(object..".height", height)
    elseif width ~= nil and height == nil  then
        setProperty(object..".width", width)
        setProperty(object..".height", getProperty(object..".height"))
    elseif width == nil and height == nil then
        setProperty(object..".width", getProperty(object..".width"))
        setProperty(object..".height", getProperty(object..".height"))
    else
        setProperty(object..".x", width)
        setProperty(object..".height", height)
    end
end
function onCreatePost()
    luaDebugMode = true
    setHealth(2)
    setProperty("healthBarBG.visible", false)
    setProperty("healthBar.visible", false)
    setProperty("iconP1.visible", false)
    setProperty("iconP2.visible", false)

    makeLuaSprite("healthBarP1", nil, 0, 0)
    makeGraphic("healthBarP1", 190, 30, to_hex(getProperty("boyfriend.healthColorArray")))
    setProperty("healthBarP1.alpha", getPropertyFromClass("backend.ClientPrefs", "healthBarAlpha"))
    setProperty("healthBarP1.visible", not getPropertyFromClass("backend.ClientPrefs", "hideHud"))
    setProperty("healthBarP1.angle", uiyg[2] * (-1) - 7)
    setObjectCamera("healthBarP1", 'other')
    addLuaSprite("healthBarP1", false)

    makeLuaSprite("healthBarP2", nil, 0, 0)
    makeGraphic("healthBarP2", 90, 30, to_hex(getProperty("dad.healthColorArray")))
    setProperty("healthBarP2.alpha", getPropertyFromClass("backend.ClientPrefs", "healthBarAlpha"))
    setProperty("healthBarP2.visible", not getPropertyFromClass("backend.ClientPrefs", "hideHud"))
    setProperty("healthBarP2.angle", uiyg[1] * (-1))
    setObjectCamera("healthBarP2", 'other')
    addLuaSprite("healthBarP2", false)

    makeAnimatedLuaSprite("playerHealthShit", 'Healthbars', 650, 0)
    addAnimationByPrefix("playerHealthShit", "bf", "Bf non pixel Health Bar", 24, false)
    playAnim("playerHealthShit", "bf", false, false, 0)
    setProperty("playerHealthShit.alpha", getPropertyFromClass("backend.ClientPrefs", "healthBarAlpha"))
    setProperty("playerHealthShit.visible", not getPropertyFromClass("backend.ClientPrefs", "hideHud"))
    setObjectCamera("playerHealthShit", 'other')
    addLuaSprite("playerHealthShit", false)

    makeAnimatedLuaSprite("opponentHealthShit", 'Healthbars', 150, 0)
    addAnimationByPrefix("opponentHealthShit", "casing", "Casing Kirby Health Bar", 24, false)
    playAnim("opponentHealthShit", "casing", false, false, 0)
    setProperty("opponentHealthShit.alpha", getPropertyFromClass("backend.ClientPrefs", "healthBarAlpha"))
    setProperty("opponentHealthShit.visible", not getPropertyFromClass("backend.ClientPrefs", "hideHud"))
    setObjectCamera("opponentHealthShit", 'other')
    addLuaSprite("opponentHealthShit", false)

    setObjectPosition("healthBarP1", getProperty("playerHealthShit.x") + 170, getProperty("playerHealthShit.y") + 40 - wkueya[2])
    setObjectPosition("healthBarP2", getProperty("opponentHealthShit.x") + 170, getProperty("opponentHealthShit.y") + 30 - wkueya[1])
end
function reloadHealthBarColors(player)
    if player == 1 then
        setProperty("healthBarP1.color", to_hex(getProperty("boyfriend.healthColorArray")))
    elseif player == 2 then
        setProperty("healthBarP2.color", to_hex(getProperty("dad.healthColorArray")))
    else
        setProperty("healthBarP1.color", to_hex(getProperty("boyfriend.healthColorArray")))
        setProperty("healthBarP2.color", to_hex(getProperty("dad.healthColorArray")))
    end
end
function goodNoteHit(i,d,t,s)
    if not s then
        if bfHealth > 200 / 10 or bfHealth == 200 / 10 then
            bfHealth = 200 / 10
            dadHealth = 0
        else
            bfHealth = bfHealth + .2
            dadHealth = dadHealth - .2
        end
    end
end
function opponentNoteHit(i,d,t,s)
    if not s then
        if dadHealth > 200 / 10 or dadHealth == 200 / 10 then
            dadHealth = 200 / 10
            bfHealth = 0
        else
            dadHealth = dadHealth + .2
            bfHealth = bfHealth - .2
        end 
    end
end
function noteMiss(i,d,t,s)
    if not s then
        broJustMissedANote = broJustMissedANote + 1
    end
    --//Note misses
    dadHealth = dadHealth + .2
    bfHealth = bfHealth - .2
    addHealth(-0.00000000000000000000000000000000000000000000000000000000000000000000000000000000001)
end
function onUpdatePost(elapsed)
    debugPrint('BF Health: '..bfHealth, ' Dad Health: '..dadHealth, ' Health: '.. getProperty("health"))
    setObjectPosition("healthBarP1.scale", bfHealth / 10, nil)
    setObjectPosition("healthBarP2.scale", dadHealth / 10, nil)
    if bfHealth == 0 or bfHealth < 0 and misses == broJustMissedANote + 1 then
        setHealth(0)
        addHealth(-500) --//Instant death like in the real game!! WOAH!
    end
end
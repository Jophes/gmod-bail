AddCSLuaFile("bail/shared/config.lua")
include("bail/shared/config.lua")

--print("bail/lua/bail/server/init.lua");

-- Register network strings
util.AddNetworkString("open_bail_menu")
util.AddNetworkString("request_bail_menu")
util.AddNetworkString("result_bail_menu")

-- Declare server global, bail prices
BAIL_PRICES = {}

-- Recieve bail accept request
local function BailRequest(len, ply)
    local canAffordBail = (ply:getDarkRPVar("money") >= BAIL_PRICES[ply:SteamID()])
    local isArrested = ply:isArrested()
    --print(ply:isArrested())

    net.Start("result_bail_menu")
        if canAffordBail and isArrested then
            net.WriteString(BAIL_CONFIG.bailCodes.success)
        elseif isArrested ~= true then
            net.WriteString(BAIL_CONFIG.bailCodes.notArrested)
        elseif canAffordBail == false then
            net.WriteString(BAIL_CONFIG.bailCodes.cantAfford)
        else
            net.WriteString(BAIL_CONFIG.bailCodes.error)
        end
    net.Send(ply)

    if canAffordBail and isArrested then
        ply:addMoney(-BAIL_PRICES[ply:SteamID()])
        ply:unArrest()
    end
end
net.Receive("request_bail_menu", BailRequest)
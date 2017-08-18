--print("bail/lua/bail/shared/config.lua");

BAIL_CONFIG = {}

if SERVER then
-- Bail Price
    function GetBailPrice(player)
        local wallet = player:getDarkRPVar("money") or 10000
        local bankAccount = (util.JSONToTable(file.Read(ARCBank.GetAccountDir("",player),"DATA") or "") or {[4]=0})[4]
        local plyMoney = wallet + bankAccount
        --print("Total money: " .. plyMoney)
        local percentage = math.Round((plyMoney * 0.015), 2)
        if percentage >= 10000 then return percentage end
        return 10000
    end
    BAIL_CONFIG.GetBailPrice = GetBailPrice

    -- Bail Codes
    BAIL_CONFIG.bailCodes = {}
    BAIL_CONFIG.bailCodes.success = "You have successfully paid for bail"
    BAIL_CONFIG.bailCodes.cantAfford = "You cannot afford bail, call for a buddy to lend you some cash!"
    BAIL_CONFIG.bailCodes.notArrested = "You cannot pay for bail, you're not arrested"
    BAIL_CONFIG.bailCodes.error = "Error, please contact an administrator"
end

-- Fonts
BAIL_CONFIG.font_family = "Trebuchet MS"

-- Colours
BAIL_CONFIG.cols = {}

BAIL_CONFIG.cols.base_primary = Color(45, 45, 45, 255)
BAIL_CONFIG.cols.base_secondary = Color(35, 35, 35, 255)

BAIL_CONFIG.cols.btn_primary = Color(35, 35, 35, 255)
BAIL_CONFIG.cols.btn_hover = Color(38, 38, 38, 255)
BAIL_CONFIG.cols.btn_pressed = Color(50, 50, 50, 255)

BAIL_CONFIG.cols.text_primary = Color(240, 240, 240, 255)
BAIL_CONFIG.cols.text_feature = Color(255, 153, 0, 255)
BAIL_CONFIG.cols.text_feature_back = Color(218, 128, 14, 255)
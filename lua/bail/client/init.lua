include("bail/shared/config.lua")
include("fonts.lua")

--print("bail/lua/bail/client/init.lua");

local BAIL = {}

function BAIL:menu_open(ply, cmd, args)
    BAIL.frame = vgui.Create("bail_frame")
    BAIL.frame:MakePopup()
end
concommand.Add("bail_menu_open", BAIL.menu_open)

function BAIL:net_menu_open(len)
    if ispanel(BAIL.frame) == false or BAIL.frame:IsValid() == false then
        BAIL:menu_open()
    else
        BAIL.frame:Show()
    end
    local bailPrice = net.ReadDouble()
    BAIL.frame:SetBailPrice(bailPrice)
end
net.Receive("open_bail_menu", BAIL.net_menu_open)

function BAIL:net_bail_result(len)
    BAIL.frame:Close()
    notification.AddLegacy(net.ReadString(), NOTIFY_GENERIC, 6)
end
net.Receive("result_bail_menu", BAIL.net_bail_result)

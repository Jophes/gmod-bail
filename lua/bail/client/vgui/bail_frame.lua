include("bail/shared/config.lua")
--print("bail/lua/bail/client/vgui/bail_frame.lua")

local titleBarHeight = 52
local centerHeight = 106
local creditsBarHeight = 24

local PANEL = {}

function PANEL:Paint()
    -- Main frame background
    draw.RoundedBoxEx(16, 0, 0, self:GetWide(), self:GetTall(), BAIL_CONFIG.cols.base_primary, true, false, false, false)

    draw.DrawText(self.bailText, "BailOfficer_20_600", self:GetWide() * 0.5, 56, BAIL_CONFIG.cols.text_primary, TEXT_ALIGN_CENTER)

    -- Title bar
    draw.RoundedBoxEx(16, 0, 0, self:GetWide(), titleBarHeight, BAIL_CONFIG.cols.base_secondary, true, false, false, false)
    draw.DrawText("Bail Officer", "BailOfficer_32_1000", self:GetWide() * 0.5, 2, BAIL_CONFIG.cols.text_feature, TEXT_ALIGN_CENTER)
    draw.DrawText("H&J's Gaming", "BailOfficer_16_500", self:GetWide() * 0.5, 32, BAIL_CONFIG.cols.text_feature, TEXT_ALIGN_CENTER)

    -- Credit bar
    draw.RoundedBox(0, 0, centerHeight+titleBarHeight, self:GetWide(), creditsBarHeight, BAIL_CONFIG.cols.base_secondary)
    draw.DrawText("Version: 1.0", "BailOfficer_16_500", 8, centerHeight+titleBarHeight+4, BAIL_CONFIG.cols.text_primary, TEXT_ALIGN_LEFT)
    draw.DrawText("Built by H&J's Developers", "BailOfficer_16_500", self:GetWide() - 8, centerHeight+titleBarHeight+4, BAIL_CONFIG.cols.text_primary, TEXT_ALIGN_RIGHT)
end

function PANEL:SetBailPrice(price)
    self.priceText = DarkRP.formatMoney(price)
    if LocalPlayer():isArrested() then self.bailText = "Pay " .. self.priceText .. " to be released from jail." end
end

function PANEL:AcceptPressed()
    net.Start("request_bail_menu")
    net.SendToServer()
end

function PANEL:ClosePressed()
    self:GetParent():Close()
end

function PANEL:Init()
    self.bailText = "You aren't arrested, you cannot pay for bail."
    self:SetBailPrice(10000)
    self:SetTitle("")
    self:SetDraggable(false)
    self:SetSize(400, centerHeight+titleBarHeight+creditsBarHeight)
    self:SetPos(ScrW() * 0.5 - self:GetWide() * 0.5, ScrH() * 0.5 - self:GetTall() * 0.5)

    if LocalPlayer():isArrested() == true then
        local acceptBtn = vgui.Create("bail_button", self)
        acceptBtn.label = "Accept"
        acceptBtn:SetPos(8, titleBarHeight + 34)
        acceptBtn.DoClick = self.AcceptPressed

        local cancelBtn = vgui.Create("bail_button", self)
        cancelBtn.label = "Cancel"
        cancelBtn:SetPos(self:GetWide() - 8 - cancelBtn:GetWide(), titleBarHeight + 34)
        cancelBtn.DoClick = self.ClosePressed
    else
        local cancelBtn = vgui.Create("bail_button", self)
        cancelBtn.label = "Close"
        cancelBtn:SetPos(8, titleBarHeight + 34)
        cancelBtn:SetSize(self:GetWide() - 16, 64)
        cancelBtn.DoClick = self.ClosePressed
    end
end

vgui.Register("bail_frame", PANEL, "DFrame")

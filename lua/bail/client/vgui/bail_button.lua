include("bail/shared/config.lua")
--print("bail/lua/bail/client/vgui/bail_button.lua")

local PANEL = {}
PANEL.targetBackground = BAIL_CONFIG.cols.btn_primary
PANEL.curBackground = PANEL.targetBackground
PANEL.mouseHovering = false
PANEL.btnDown = false

function PANEL:UpdateBackgroundColor()
    if self.mouseHovering == false and self.btnDown == false then
        self.targetBackground = BAIL_CONFIG.cols.btn_primary
    elseif self.mouseHovering == true and self.btnDown == false then
        self.targetBackground = BAIL_CONFIG.cols.btn_hover
    elseif self.btnDown == true then
        self.targetBackground = BAIL_CONFIG.cols.btn_pressed
    end
end

function PANEL:OnCursorEntered()
    self.mouseHovering = true
	self:UpdateBackgroundColor()
end

function PANEL:OnCursorExited()
	self.mouseHovering = false
    self.btnDown = false
    self:UpdateBackgroundColor()
end

function PANEL:OnMousePressed()
    self.btnDown = true
    self:UpdateBackgroundColor()
    self:DoClick()
end

function PANEL:OnMouseReleased()
    self.btnDown = false
    self:UpdateBackgroundColor()
end

function ColorToVector(color)
    return Vector(color.r, color.g, color.b)
end

function PANEL:Paint()
    -- Lerp background colours
    self.curBackground = LerpVector(0.25, ColorToVector(self.curBackground), ColorToVector(self.targetBackground))
    -- Main background
    draw.RoundedBox(4, 0, 0, self:GetWide(), self:GetTall(), self.curBackground)

    draw.DrawText(self.label, "BailOfficer_24_1000", self:GetWide() * 0.5, 20, BAIL_CONFIG.cols.text_primary, TEXT_ALIGN_CENTER)
end

function PANEL:Init()
    self.label = "Button"
    self:SetText("")
    self:SetSize(188, 64)
end

vgui.Register("bail_button", PANEL, "DButton")

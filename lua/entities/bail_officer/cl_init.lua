include('shared.lua')
--print("lua/entities/bail_officer/cl_init.lua")

function ENT:drawMoneyInfo()
    draw.SimpleTextOutlined("Bail Officer", "HUDNumber5", 0, 0, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
end

function ENT:Draw()
    self:DrawModel()
    local Ang = self:GetAngles()
    Ang:RotateAroundAxis(Ang:Forward(), 90)
    Ang:RotateAroundAxis(Ang:Right(), -90)
    cam.Start3D2D(self:GetPos()+self:GetUp()*82, Ang, 0.35)
        self:drawMoneyInfo()
    cam.End3D2D()
    cam.Start3D2D(self:GetPos()+self:GetUp()*82, Ang + Angle(0,180,0), 0.35)
        self:drawMoneyInfo()
    cam.End3D2D()
end
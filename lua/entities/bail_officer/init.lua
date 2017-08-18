AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')
AddCSLuaFile("bail/shared/config.lua")
include("../../bail/shared/config.lua")

--print("lua/entities/bail_officer/init.lua")

function ENT:Initialize()
	self:SetModel("models/Barney.mdl")
    self:SetHullType(HULL_HUMAN)
    self:SetHullSizeNormal()
    self:SetNPCState(NPC_STATE_SCRIPT)
	self:SetSolid(SOLID_BBOX)
	self:CapabilitiesAdd(CAP_ANIMATEDFACE)
	self:SetUseType(SIMPLE_USE)
	self:DropToFloor()
end

function ENT:SpawnFunction(ply, tr)
    if (!tr.Hit) then return end
    local ent = ents.Create("bail_officer")
    ent:SetPos(tr.HitPos + tr.HitNormal * 16) 
    ent:Spawn()
    ent:Activate()
    return ent
end

function ENT:AcceptInput(name, activator, caller)
	if name == "Use" and caller:IsPlayer() then
		--print(caller:Nick() .. " used the bail officer!")
        BAIL_PRICES[caller:SteamID()] = BAIL_CONFIG.GetBailPrice(caller)
        net.Start("open_bail_menu")
        net.WriteDouble(BAIL_PRICES[caller:SteamID()])
        net.Send(caller)
        --print("Bail price set at: " .. BAIL_PRICES[caller:SteamID()])
	end
end

function ENT:PhysgunPickup(ply)
	return IsAdmin(ply) 
end

function ENT:CanTool(ply, trace, mode)
	return IsAdmin(ply) 
end
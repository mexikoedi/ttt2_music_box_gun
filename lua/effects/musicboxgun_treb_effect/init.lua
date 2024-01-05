if engine.ActiveGamemode() ~= "terrortown" then return end
AddCSLuaFile()
function EFFECT:Init(data)
    self.Position = data:GetOrigin()
    self.WeaponEntity = data:GetEntity()
    if not IsValid(self.WeaponEntity) then return end
    self.Direction = (self.WeaponEntity:GetPos() - self.Position):Angle()
    self.Normal = data:GetNormal()
    self.KillTime = CurTime() + 0.65
    self:SetRenderBoundsWS(self.Position + Vector() * 280, self.Position - Vector() * 280)
    if self.Normal == nil then return end
    local emitter = ParticleEmitter(self.Position)
    for i = 1, 30 do
        local vec = (self.Normal + 5 * VectorRand()):GetNormalized()
        local particle = emitter:Add("sprites/glow04_noz", self.Position + math.Rand(3, 30) * vec)
        particle:SetVelocity(math.Rand(70, 70) * vec)
        particle:SetDieTime(1)
        particle:SetStartAlpha(0)
        particle:SetEndAlpha(255)
        particle:SetStartSize(5)
        particle:SetEndSize(0)
        particle:SetStartLength(5)
        particle:SetEndLength(0)
        particle:SetColor(70 * math.sin(RealTime() * 3) + 180, 120 * math.sin(RealTime() / 3) + 180, 50 * math.cos(RealTime() + 3) + 180)
        particle:SetGravity(Vector(0, 0, 0))
        particle:SetAirResistance(5)
        particle:SetCollide(true)
        particle:SetBounce(0.9)
    end

    emitter:Finish()
end

function EFFECT:Think()
    if not IsValid(self.WeaponEntity) then return false end
    if CurTime() > self.KillTime then return false end
    return true
end

function EFFECT:Render()
    if self.KillTime == nil then return end
    local invintrplt = (self.KillTime - CurTime()) / 0.15
    local intrplt = 1 - invintrplt
    local size = 15 + 15 * intrplt
    self:SetRenderBoundsWS(self.Position + Vector() * size, self.Position - Vector() * size)
end
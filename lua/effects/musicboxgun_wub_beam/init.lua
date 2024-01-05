if engine.ActiveGamemode() ~= "terrortown" then return end
AddCSLuaFile()
EFFECT.Mat = Material("trails/laser")
EFFECT.Mat2 = Material("trails/plasma")
function EFFECT:Init(data)
    local entity = data:GetEntity()
    if not IsValid(entity) then return end
    self.Position = data:GetEntity():GetPos()
    self.WeaponEnt = data:GetEntity()
    if not IsValid(self.WeaponEnt) then return end
    if not IsValid(self.WeaponEnt:GetOwner()) then return end
    self.WeaponEntO = self.WeaponEnt:GetOwner()
    self.Attachment = data:GetAttachment()
    self.StartPos = self:GetTracerShootPos(self.Position, self.WeaponEnt, self.Attachment)
    self.StartPosTemp = self.StartPos
    self.EndPos = data:GetOrigin()
    self.Alpha = 255
end

function EFFECT:Think()
    if not IsValid(self.WeaponEnt) then return end
    if not IsValid(self.WeaponEnt:GetOwner()) then return end
    if self.Alpha then self.Alpha = self.Alpha - FrameTime() * 548 end
    if self.StartPos == nil then self.StartPos = Vector() end
    if self.EndPos == nil then self.EndPos = Vector() end
    if self.Alpha == nil then return false end
    self:SetRenderBoundsWS(self.StartPos, self.EndPos)
    if self.Alpha < 0 then return false end
    return true
end

function EFFECT:Render()
    if not IsValid(self.WeaponEnt) then return end
    if self.Alpha == nil then return end
    local col = Color(70 * math.sin(RealTime() * 3) + 180, 120 * math.sin(RealTime() / 3) + 180, 50 * math.cos(RealTime() + 3) + 180)
    self.Length = (self.StartPos - self.EndPos):Length()
    local texcoord = math.Rand(0, 1)
    local width = 15
    render.SetMaterial(self.Mat2)
    for i = 1, 6 do
        render.DrawBeam(self.StartPos, self.EndPos, width / 2, texcoord, texcoord + self.Length / 128, Color(col.r, col.g, col.b, self.Alpha))
    end

    render.SetMaterial(self.Mat)
    for i = 1, 6 do
        render.DrawBeam(self.StartPos, self.EndPos, width, texcoord, texcoord + self.Length / 128, Color(col.r, col.g, col.b, self.Alpha))
    end
end
local songs = {}
local song_path = "weapons/musicboxgun/songs/"
if SERVER then
    AddCSLuaFile()
    resource.AddFile("materials/effects/mbg/refract_ring.vmt")
    resource.AddFile("materials/vgui/weapon_music_box_gun.vmt")
    resource.AddFile("materials/models/mark2580/sr4/dubstepgun_lg_d.vmt")
    resource.AddFile("models/mark2580/sr4/dubstepgun.mdl")
    resource.AddFile("sound/meme.wav")
    local song_files = file.Find("sound/" .. song_path .. "*.wav", "GAME")
    if song_files then
        for i = 1, #song_files do
            local song = song_files[i]
            resource.AddFile("sound/" .. song_path .. song_files[i])
            songs[i] = song
        end
    end
end

SWEP.EquipMenuData = {
    type = "item_weapon",
    name = "ttt2_music_box_gun_name",
    desc = "ttt2_music_box_gun_desc"
}

SWEP.Kind = WEAPON_EQUIP1
SWEP.CanBuy = {ROLE_DETECTIVE}
SWEP.LimitedStock = true
SWEP.Icon = "vgui/weapon_music_box_gun"
SWEP.Base = "weapon_tttbase"
SWEP.Author = "mexikoedi"
SWEP.PrintName = "Music Box Gun"
SWEP.Contact = "Steam"
SWEP.Instructions = "Left click to shoot beams with random sounds and secondary attack to play a sound."
SWEP.Purpose = "Kill your enemies with music and colorful lights."
SWEP.AutoSpawnable = false
SWEP.Spawnable = false
SWEP.AdminOnly = false
SWEP.AdminSpawnable = false
SWEP.AllowDrop = true
SWEP.AllowPickup = true
SWEP.ViewModel = "models/mark2580/sr4/dubstepgun.mdl"
SWEP.WorldModel = "models/mark2580/sr4/dubstepgun.mdl"
SWEP.ShowWorldModel = true
SWEP.ShowViewModel = true
SWEP.HoldType = "rpg"
SWEP.ViewModelFOV = 90
SWEP.UseHands = true
SWEP.IronSightsPos = Vector(10.6, 0, -12.12)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.PreventEffectSpam = false
SWEP.AllowBounce = false
SWEP.SkinType = 1
SWEP.ViewModelFlip = false
SWEP.Primary.Damage = GetConVar("ttt2_music_box_gun_damage"):GetInt()
SWEP.Primary.ClipSize = 1
SWEP.Primary.Delay = 0.1
SWEP.Primary.Radius = GetConVar("ttt2_music_box_gun_radius"):GetInt()
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = 1
SWEP.Secondary.Delay = 3
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Pos = nil
SWEP.Ang = nil
SWEP.Offset = {
    Pos = {
        Up = 0,
        Right = 4.5,
        Forward = 3,
    },
    Ang = {
        Up = 0,
        Right = 0,
        Forward = 0,
    }
}

function SWEP:Initialize()
    if CLIENT then
        self:AddTTT2HUDHelp("ttt2_music_box_gun_help1", "ttt2_music_box_gun_help2")
        self:SetWeaponHoldType(self.HoldType)
    end

    if SERVER then self:SetWeaponHoldType(self.HoldType) end
    return true
end

function SWEP:PrimaryAttack()
    if not self:CanPrimaryAttack() then return end
    local owner = self:GetOwner()
    if not IsValid(owner) then return end
    if SERVER and GetConVar("ttt2_music_box_gun_primary_sound"):GetBool() and not self.LoopSound then
        self.LoopSound = CreateSound(owner, Sound(song_path .. songs[math.random(#songs)]))
        if self.LoopSound then self.LoopSound:Play() end
    end

    if self.BeatSound then self.BeatSound:ChangeVolume(0, 0.1) end
    if self.PreventEffectSpam == true then return end
    self.PreventEffectSpam = true
    self.AllowBounce = true
    timer.Simple(0.3, function() self.PreventEffectSpam = false end)
    timer.Simple(0.45, function() self.AllowBounce = false end)
    local tr = owner:GetEyeTrace()
    local effectdata = EffectData()
    effectdata:SetOrigin(tr.HitPos)
    util.Effect("musicboxgun_wub_effect", effectdata, true, true)
    util.Effect("musicboxgun_treb_effect", effectdata, true, true)
    effectdata:SetOrigin(tr.HitPos)
    effectdata:SetStart(owner:GetShootPos())
    effectdata:SetScale(5)
    effectdata:SetAttachment(1)
    effectdata:SetEntity(self)
    local dmg = self.Primary.Damage / 2
    util.Effect("musicboxgun_wub_beam", effectdata, true, true)
    util.BlastDamage(self, owner, tr.HitPos, self.Primary.Radius, dmg)
    self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
end

function SWEP:SecondaryAttack()
    if SERVER and GetConVar("ttt2_music_box_gun_secondary_sound"):GetBool() then
        self.currentOwner = self:GetOwner()
        if IsValid(self.currentOwner) then self.currentOwner:EmitSound("meme.wav") end
    end

    self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
end

function SWEP:Reload()
    return false
end

function SWEP:DoImpactEffect(trace)
    local effectdata = EffectData()
    effectdata:SetStart(trace.HitPos)
    effectdata:SetOrigin(trace.HitNormal + Vector(math.Rand(-0.5, 0.5), math.Rand(-0.5, 0.5), math.Rand(-0.5, 0.5)))
    return true
end

function SWEP:FireAnimationEvent()
    return true
end

function SWEP:KillSounds()
    if self.BeatSound then
        self.BeatSound:Stop()
        self.BeatSound = nil
    end

    if self.LoopSound then
        self.LoopSound:Stop()
        self.LoopSound = nil
    end
end

function SWEP:OnRemove()
    self:KillSounds()
    if SERVER and IsValid(self.currentOwner) then self.currentOwner:StopSound("meme.wav") end
end

function SWEP:CalcAbsolutePosition(pos, ang)
    self.Pos = pos
    self.Ang = ang
    return
end

function SWEP:Think()
    local owner = self:GetOwner()
    ironSightStatus = self:GetNWBool("Ironsights", false)
    if ironSightStatus == false then self:SetNWBool("Ironsights", true) end
    if owner:IsPlayer() and (owner:KeyReleased(IN_ATTACK) or not owner:KeyDown(IN_ATTACK)) then
        if self.BeatSound then self.BeatSound:ChangeVolume(1, 0.1) end
        if self.LoopSound then
            self.LoopSound:Stop()
            self.LoopSound = nil
        end
    end

    self:DrawWorldModel()
end

function SWEP:RenderOverride()
    self:DrawWorldModel()
end

function SWEP:OnDrop()
    self:KillSounds()
    self.GetOwner = nil
    if SERVER and IsValid(self.currentOwner) then self.currentOwner:StopSound("meme.wav") end
end

function SWEP:DrawWorldModel()
    local hand, offset
    local owner = self:GetOwner()
    if not IsValid(owner) then
        self:SetRenderOrigin(self.Pos)
        self:SetRenderAngles(self.Ang)
        self:DrawModel()
        return
    end

    if not self.Hand then self.Hand = owner:LookupAttachment("anim_attachment_rh") end
    hand = owner:GetAttachment(self.Hand)
    if not hand then
        self:SetRenderOrigin(self.Pos)
        self:SetRenderAngles(self.Ang)
        self:DrawModel()
        return
    end

    offset = hand.Ang:Right() * self.Offset.Pos.Right + hand.Ang:Forward() * self.Offset.Pos.Forward + hand.Ang:Up() * self.Offset.Pos.Up
    hand.Ang:RotateAroundAxis(hand.Ang:Right(), self.Offset.Ang.Right)
    hand.Ang:RotateAroundAxis(hand.Ang:Forward(), self.Offset.Ang.Forward)
    hand.Ang:RotateAroundAxis(hand.Ang:Up(), self.Offset.Ang.Up)
    if self.SetRenderOrigin == nil or self.SetRenderAngles == nil then return end
    self:SetRenderOrigin(hand.Pos + offset)
    self:SetRenderAngles(hand.Ang)
    self:DrawModel()
end

function SWEP:Deploy()
    self:SendWeaponAnim(ACT_VM_DRAW)
    self:SetNextPrimaryFire(CurTime() + self:SequenceDuration())
    if CLIENT then return true end
    if GetConVar("ttt2_music_box_gun_standby_sound"):GetBool() then
        local owner = self:GetOwner()
        self.BeatSound = CreateSound(owner, Sound("weapons/musicboxgun/songs/dullsounds/popstar_loop.wav"))
    end

    if self.BeatSound then self.BeatSound:Play() end
    return true
end

function SWEP:Holster()
    self:KillSounds()
    if SERVER and IsValid(self.currentOwner) then self.currentOwner:StopSound("meme.wav") end
    return true
end

local IRONSIGHT_TIME = 0.25
function SWEP:GetViewModelPosition(pos, ang)
    if not self.IronSightsPos then return pos, ang end
    local bIron = self:GetNWBool("Ironsights")
    if bIron ~= self.bLastIron then
        self.bLastIron = bIron
        self.fIronTime = CurTime()
        if bIron then
            self.SwayScale = 0.3
            self.BobScale = 0.1
        else
            self.SwayScale = 1.0
            self.BobScale = 1.0
        end
    end

    local fIronTime = self.fIronTime or 0
    if not bIron and fIronTime < CurTime() - IRONSIGHT_TIME then return pos, ang end
    local Mul = 1.0
    if fIronTime > CurTime() - IRONSIGHT_TIME then
        Mul = math.Clamp((CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1)
        if not bIron then Mul = 1 - Mul end
    end

    local Offset = self.IronSightsPos
    if self.IronSightsAng then
        ang = ang * 1
        ang:RotateAroundAxis(ang:Right(), self.IronSightsAng.x * Mul)
        ang:RotateAroundAxis(ang:Up(), self.IronSightsAng.y * Mul)
        ang:RotateAroundAxis(ang:Forward(), self.IronSightsAng.z * Mul)
    end

    local Right = ang:Right()
    local Up = ang:Up()
    local Forward = ang:Forward()
    pos = pos + Offset.x * Right * Mul
    pos = pos + Offset.y * Forward * Mul
    pos = pos + Offset.z * Up * Mul
    return pos, ang
end

if CLIENT then
    function SWEP:AddToSettingsMenu(parent)
        local form = vgui.CreateTTT2Form(parent, "header_equipment_additional")
        form:MakeCheckBox({
            serverConvar = "ttt2_music_box_gun_primary_sound",
            label = "label_music_box_gun_primary_sound"
        })

        form:MakeCheckBox({
            serverConvar = "ttt2_music_box_gun_secondary_sound",
            label = "label_music_box_gun_secondary_sound"
        })

        form:MakeCheckBox({
            serverConvar = "ttt2_music_box_gun_standby_sound",
            label = "label_music_box_gun_standby_sound"
        })

        form:MakeSlider({
            serverConvar = "ttt2_music_box_gun_damage",
            label = "label_music_box_gun_damage",
            min = 0,
            max = 200,
            decimal = 0
        })

        form:MakeSlider({
            serverConvar = "ttt2_music_box_gun_radius",
            label = "label_music_box_gun_radius",
            min = 0,
            max = 500,
            decimal = 0
        })
    end
end
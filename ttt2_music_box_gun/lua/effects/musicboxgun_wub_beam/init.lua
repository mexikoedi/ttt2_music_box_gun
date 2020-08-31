if engine.ActiveGamemode( ) != "terrortown" then return end
EFFECT.Mat = Material( "trails/laser" ) //Material( "effects/beam001_blu_dx80" ) effects/laser_tracer
EFFECT.Mat2 = Material( "trails/plasma" ) //Material( "effects/beam001_blu" )

/*---------------------------------------------------------
   Init( data table )
-----------------------------------------------------------*/
function EFFECT:Init( data )
    self.Position = data:GetStart( )
    self.WeaponEnt = data:GetEntity( )
    self.WeaponEntO = self.WeaponEnt:GetOwner( )
    self.Attachment = data:GetAttachment( )
    // Keep the start and end pos - we're going to interpolate between them
    self.StartPos = self:GetTracerShootPos( self.Position , self.WeaponEnt , self.Attachment )
    self.StartPosTemp = self.StartPos
    self.EndPos = data:GetOrigin( )
    self.Alpha = 255
end

/*---------------------------------------------------------
   THINK
-----------------------------------------------------------*/
function EFFECT:Think( )
    if self.Alpha then
        self.Alpha = self.Alpha - FrameTime( ) * 548
    end

    if self.StartPos == nil then
        self.StartPos = Vector( )
    end

    if self.EndPos == nil then
        self.EndPos = Vector( )
    end

    if self.Alpha == nil then return false end //newaly added
    self:SetRenderBoundsWS( self.StartPos , self.EndPos )
    if ( self.Alpha < 0 ) then return false end

    return true
end

/*---------------------------------------------------------
   Draw the effect
-----------------------------------------------------------*/
function EFFECT:Render( )
    if !IsValid( self.WeaponEnt ) then return end
    if ( self.Alpha < 1 ) then return end
    local col = Color( 70 * math.sin( RealTime( ) * 3 ) + 180 , 120 * math.sin( RealTime( ) / 3 ) + 180 , 50 * math.cos( RealTime( ) + 3 ) + 180 ) //Color( 160, 160, 255 ) // 255 160, 255
    //local col2 = Color( 220, 60, 190 )
    //local col = Color( 60, 20, 220 )
    self.Length = ( self.StartPos - self.EndPos ):Length( )
    local texcoord = math.Rand( 0 , 1 )
    local width = 15
    render.SetMaterial( self.Mat2 )

    for i = 1 , 6 do
        render.DrawBeam( self.StartPos , self.EndPos , width / 2 , texcoord , texcoord + self.Length / 128 , Color( col.r , col.g , col.b , self.Alpha ) )
    end

    render.SetMaterial( self.Mat )

    for i = 1 , 6 do
        render.DrawBeam( self.StartPos , self.EndPos , width , texcoord , texcoord + self.Length / 128 , Color( col.r , col.g , col.b , self.Alpha ) )
    end
end

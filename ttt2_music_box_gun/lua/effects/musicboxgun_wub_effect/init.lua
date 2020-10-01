if engine.ActiveGamemode( ) != "terrortown" then return end
local matBulge2 = Material( "effects/mbg/refract_ring" )
local matBulge = Material( "Effects/freeze_unfreeze" )
local matBulge3 = Material( "particle/warp_ripple" )
local lighteffect = CreateClientConVar( "cl_musicboxgun_wub_light" , "0" , true , false )

function EFFECT:Init( data )
    self.Position = data:GetOrigin( )
    self.Normal = data:GetNormal( )
    self.Ent = data:GetEntity( )
    self.KillTime = CurTime( ) + 0.65
    self:SetRenderBoundsWS( self.Position + Vector( ) * 280 , self.Position - Vector( ) * 280 )

    timer.Simple( 0.1 , function( )
        if self.Normal == nil then return end
        local ang = self.Normal:Angle( ):Right( ):Angle( )
        local emitter = ParticleEmitter( self.Position )
        local size = 270
        local Low , High = Vector( -size , -size , -size ) , Vector( size , size , size * 2 )

        for i = 1 , 25 do
            local vPos = self.Position + Vector( math.random( Low.x , High.x ) , math.random( Low.y , High.y ) , math.random( Low.z , High.z ) )
            local particle = emitter:Add( "/effects/laser_tracer" , vPos + Vector( 0 , 0 , 15 ) )

            if ( particle ) then
                particle:SetColor( 120 , 80 , 220 , 128 )
                particle:SetVelocity( Vector( 0 , 0 , -1 ) )
                particle:SetLifeTime( 0 )
                particle:SetDieTime( 2 )
                particle:SetStartAlpha( 172 )
                particle:SetEndAlpha( 0 )
                particle:SetStartSize( 5 )
                particle:SetStartLength( 90 )
                particle:SetEndSize( 5 )
                particle:SetEndLength( 200 )
                particle:SetRoll( 0 )
                particle:SetRollDelta( 0 )
                particle:SetAirResistance( 90 )
                particle:SetGravity( Vector( 0 , 0 , -450 ) )
                particle:SetBounce( 0.3 )
            end

            local particles = emitter:Add( "/effects/laser_tracer" , vPos + Vector( 0 , 0 , 10 ) )

            if ( particles ) then
                particles:SetColor( 60 , 20 , 220 , 128 )
                particles:SetVelocity( Vector( 0 , 0 , -1 ) )
                particles:SetLifeTime( 0 )
                particles:SetDieTime( 2 )
                particles:SetStartAlpha( 172 )
                particles:SetEndAlpha( 0 )
                particles:SetStartSize( 5 )
                particles:SetStartLength( 90 )
                particles:SetEndSize( 5 )
                particles:SetEndLength( 200 )
                particles:SetRoll( 0 )
                particles:SetRollDelta( 0 )
                particles:SetAirResistance( 90 )
                particles:SetGravity( Vector( 0 , 0 , -450 ) )
                particles:SetBounce( 0.3 )
            end

            local particle2 = emitter:Add( "/effects/laser_tracer" , vPos )

            if ( particle2 ) then
                particle2:SetColor( 60 , 0 , 160 , 128 )
                particle2:SetVelocity( Vector( 0 , 0 , -1 ) )
                particle2:SetLifeTime( 0 )
                particle2:SetDieTime( 2 )
                particle2:SetStartAlpha( 172 )
                particle2:SetEndAlpha( 0 )
                particle2:SetStartSize( 5 )
                particle2:SetStartLength( 100 )
                particle2:SetEndSize( 5 )
                particle2:SetEndLength( 200 )
                particle2:SetRoll( 0 )
                particle2:SetRollDelta( 0 )
                particle2:SetAirResistance( 100 )
                particle2:SetGravity( Vector( 0 , 0 , -500 ) )
                particle2:SetBounce( 0.3 )
            end

            local particle3 = emitter:Add( "/effects/laser_tracer" , vPos + Vector( 0 , 0 , 0 ) )

            if ( particle3 ) then
                particle3:SetColor( 220 , 20 , 60 , 128 )
                particle3:SetVelocity( Vector( 0 , 0 , -1 ) )
                particle3:SetLifeTime( 0 )
                particle3:SetDieTime( 2 )
                particle3:SetStartAlpha( 172 )
                particle3:SetEndAlpha( 0 )
                particle3:SetStartSize( 5 )
                particle3:SetStartLength( 80 )
                particle3:SetEndSize( 5 )
                particle3:SetEndLength( 150 )
                particle3:SetRoll( 0 )
                particle3:SetRollDelta( 0 )
                particle3:SetAirResistance( 80 )
                particle3:SetGravity( Vector( 0 , 0 , -500 ) )
                particle3:SetBounce( 0.3 )
            end
        end

        emitter:Finish( )

        if lighteffect:GetInt( ) == 1 then
            local dlight = DynamicLight( math.random( 2048 , 4096 ) )
            dlight.Pos = self.Position
            dlight.Size = 5000
            dlight.DieTime = CurTime( ) + 0.2
            dlight.r = 70 * math.sin( RealTime( ) * 3 ) + 180
            dlight.g = 120 * math.sin( RealTime( ) / 3 ) + 180
            dlight.b = 50 * math.cos( RealTime( ) + 3 ) + 180
            dlight.Brightness = 1
            dlight.Decay = 1000
        end
    end )
end

function EFFECT:Think( )
    if CurTime( ) > self.KillTime then return false end

    return true
end

function EFFECT:Render( )
    local invintrplt = ( self.KillTime - CurTime( ) ) / 0.15
    local intrplt = 1 - invintrplt
    local size = 200 + 200 * intrplt
    self:SetRenderBoundsWS( self.Position + Vector( ) * size , self.Position - Vector( ) * size )
    matBulge:SetFloat( "$refractamount" , math.sin( 0.5 * invintrplt * math.pi ) * 0.16 )
    render.SetMaterial( matBulge )
    render.UpdateRefractTexture( )
    render.DrawSprite( self.Position , size , size , Color( 70 * math.sin( RealTime( ) * 3 ) + 180 , 120 * math.sin( RealTime( ) / 3 ) + 180 , 50 * math.cos( RealTime( ) + 3 ) + 180 , 150 * invintrplt ) )
    local invintrplt = ( self.KillTime - CurTime( ) ) / 0.65
    local intrplt = 1 - invintrplt
    local size = 200 + 50 * intrplt * 10
    self:SetRenderBoundsWS( self.Position + Vector( ) * size , self.Position - Vector( ) * size )
    matBulge2:SetFloat( "$refractamount" , math.sin( 0.5 * invintrplt * math.pi ) * 0.16 )
    render.SetMaterial( matBulge2 )
    render.UpdateRefractTexture( )
    render.DrawSprite( self.Position , size , size , Color( 255 , 255 , 255 , 150 * invintrplt ) )
    matBulge3:SetFloat( "$refractamount" , math.sin( 0.5 * invintrplt * math.pi ) * 0.16 )
    render.SetMaterial( matBulge3 )
    render.UpdateRefractTexture( )
    render.DrawSprite( self.Position , size , size , Color( 255 , 255 , 255 , 150 * invintrplt ) )
end

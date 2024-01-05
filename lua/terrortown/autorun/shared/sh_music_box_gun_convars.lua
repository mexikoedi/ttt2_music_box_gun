-- convars added with default values
CreateConVar("ttt2_music_box_gun_primary_sound", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Sound of the primary attack")
CreateConVar("ttt2_music_box_gun_secondary_sound", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Sound of the secondary attack")
CreateConVar("ttt2_music_box_gun_standby_sound", "1", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Standby sound")
CreateConVar("ttt2_music_box_gun_damage", "20", {FCVAR_ARCHIVE, FCVAR_NOTIFY}, "Damage of the music box gun")
if CLIENT then
    -- Use string or string.format("%.f",<steamid64>) 
    -- addon dev emblem in scoreboard
    hook.Add("TTT2FinishedLoading", "TTT2RegistermexikoediAddonDev", function() AddTTT2AddonDev("76561198279816989") end)
end
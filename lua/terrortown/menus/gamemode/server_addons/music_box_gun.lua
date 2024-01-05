CLGAMEMODESUBMENU.base = "base_gamemodesubmenu"
CLGAMEMODESUBMENU.priority = 0
CLGAMEMODESUBMENU.title = "submenu_addons_music_box_gun_title"
function CLGAMEMODESUBMENU:Populate(parent)
    local form = vgui.CreateTTT2Form(parent, "header_addons_music_box_gun")
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
end
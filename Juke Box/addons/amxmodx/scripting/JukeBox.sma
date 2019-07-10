#include <amxmodx>
#include <reapi>
#include <xs>

#define ADMIN_FLAG ADMIN_RCON

#define JUKEBOXMDL "models/csd_muzikkutusu.mdl"
new const ENTCLASS[] = "Ent_JukeBox";

#define SoundFile1 "ambience/Opera.wav"
#define SoundFile2 "ambience/lv_jubilee.wav"
#define SoundFile3 "ambience/guit1.wav"
#define StartingSoundFile "jukestarting.wav"

#define MAXJUKE 3   //How much should on game
#define SOUNDVOLUME 1.0 // Max 1.0 | Min 0.0
#define SOUNDATT 0.9

#define RGBGLOW 0.0, 255.0 , 255.0 // // color when music (Red,Green,Blue)

new totalJuke
new g_MapFile[64];
new SoundFile[32] = SoundFile1;
new bool: BLOCKMOREUSING
#define BLOCKUSEINROUNDEND 1907
new ent_admin[MAX_PLAYERS], i_jukeboxmdl;
new i_stoproundend, i_music
public plugin_init()
{
    register_plugin("JukeBox", "1.2", "Yek'-ta")
    set_task(5.0,"CreateJukeBoxsOnMap")

    register_clcmd( "amx_jukeboxmenu", "JukeBoxMenu")
    i_stoproundend = register_cvar("amx_stopjuke_re","1")
    i_music = register_cvar("amx_juke_music","1")

    RegisterHookChain(RG_CBasePlayer_PreThink, "RG_PreThink",true);
    RegisterHookChain(RG_RoundEnd, "RGRoundEnd",true);
    register_dictionary("JukeBox.txt");
}
public RGRoundEnd(status, event, tmDelay){
    if(get_pcvar_num(i_stoproundend) == 1){
        set_task(Float:tmDelay,"stopJuke", BLOCKUSEINROUNDEND)
    }
    if(get_pcvar_num(i_music) == 1){
        SoundFile = SoundFile1
    }
    else if(get_pcvar_num(i_music) == 2){
        SoundFile = SoundFile2
    }
    else{
        SoundFile = SoundFile3
    }

}
public stopJuke(){
    new ent = NULLENT
    while ((ent = rg_find_ent_by_class(ent, ENTCLASS))) {
        new jent = get_entvar(ent, var_button)
        if(!(jent == 0)){
            rh_emit_sound2(ent, 0, CHAN_VOICE, SoundFile, 0.0, SOUNDATT, 0, PITCH_NORM)
            DestroyEntity(jent);
            set_entvar(ent, var_button, 0)
        }
    }
    remove_task(BLOCKUSEINROUNDEND);
}
public RG_PreThink(id)
{
    if(ent_admin[id] != 0 && is_user_alive(id) && is_user_connected(id)){
        if(get_entvar(id, var_button) & IN_ATTACK)
        {
            new Float:originaldegistir[3];
            get_entvar(ent_admin[id], var_angles, originaldegistir)
            originaldegistir[1] += 0.6
            set_entvar(ent_admin[id], var_angles, originaldegistir);
        }
        else if(get_entvar(id, var_button) & IN_ATTACK2)
        {
            new Float:originaldegistir[3];
            get_entvar(ent_admin[id], var_angles, originaldegistir)
            originaldegistir[1] -= 0.6
            set_entvar(ent_admin[id], var_angles, originaldegistir);
        }
        new iOrigin[ 3 ], Float:vOrigin[ 3 ] = { 0.0, 0.0, 0.0 };
        get_user_origin( id, iOrigin, 3 );
        IVecFVec( iOrigin,  vOrigin);
        vOrigin[ 2 ] += 5.0;
        set_entvar(ent_admin[id], var_origin, vOrigin)

    }
    if(!BLOCKMOREUSING && !task_exists(BLOCKUSEINROUNDEND)){
        if(get_entvar(id, var_button) & IN_USE)
        {
            static temp, enty;
            get_user_aiming(id, enty, temp);

            if(!FClassnameIs(enty, ENTCLASS))
            {
                return HC_BREAK;
            }

            new uzaklik = rg_entity_distance(id, enty)
            if(uzaklik <= 60.0)
            {
                BLOCKMOREUSING=true;
                new jent=get_entvar(enty, var_button)
                if(jent == 0){
                    rh_emit_sound2(enty, 0, CHAN_VOICE, StartingSoundFile, SOUNDVOLUME, SOUNDATT, 0, PITCH_NORM)
                    GlowEntity(enty)
                    set_task(1.0,"backtouse", enty)
                }
                else {
                    rh_emit_sound2(enty, 0, CHAN_VOICE, SoundFile, 0.0, SOUNDATT, 0, PITCH_NORM)
                    DestroyEntity(jent);
                    set_entvar(enty, var_button, 0)
                    set_task(0.5,"backtouse",0)
                }
            }
        }
    }
    return HC_BREAK;
}
public backtouse(enty){
    if(enty != 0){    rh_emit_sound2(enty, 0, CHAN_VOICE, SoundFile, SOUNDVOLUME, SOUNDATT, 0, PITCH_NORM);  }
    BLOCKMOREUSING=false
}
public JukeBoxMenu(oyuncu){
    if(get_user_flags(oyuncu) & ADMIN_FLAG){
        new menu, Menuz[512]

        formatex(Menuz, charsmax(Menuz), "\y [ \r%L\y ]", LANG_PLAYER, "JUKEMENUTITLE");

        menu = menu_create(Menuz, "JukeBoxMenu_c")

        formatex(Menuz, charsmax(Menuz), "\w%L", LANG_PLAYER, ent_admin[oyuncu] == 0 ? "CREATEJUKE" : "DROPJUKE");
        menu_additem(menu, Menuz, "1")

        formatex(Menuz, charsmax(Menuz), "\w%L", LANG_PLAYER, ent_admin[oyuncu] == 0 ? "SELECTJUKE" : "REMOVEJUKE");
        menu_additem(menu, Menuz, "2")

        if(ent_admin[oyuncu] == 0){
            formatex(Menuz, charsmax(Menuz), "\w%L", LANG_PLAYER, "SAVEJUKES");
            menu_additem(menu, Menuz, "3")
        }

        menu_display(oyuncu, menu, 0)
    }

    return PLUGIN_HANDLED
}
public JukeBoxMenu_c(oyuncu, menu, item)
{
    if (item == MENU_EXIT)
    {
        menu_destroy(menu)

        return PLUGIN_HANDLED;
    }
    new data[6], iName[64]
    new access, callback
    menu_item_getinfo(menu, item, access, data,5, iName, 63, callback)

    new key = str_to_num(data)
    if(!is_user_alive(oyuncu)){
        client_print_color(oyuncu, print_team_blue, "%L",LANG_PLAYER,"ALIVE")
    }
    switch(key)
    {
        case 1:
        {
            if(ent_admin[oyuncu] == 0){
                if(totalJuke < MAXJUKE){
                    CreateJukeBox(Float:{0.0,0.0,0.0}, 1, oyuncu, Float:{0.0,0.0,0.0});
                    new Float:originaldegistir[3], Float:originaldegistir_oyuncu[3];
                    get_entvar(ent_admin[oyuncu], var_angles, originaldegistir)
                    get_entvar(oyuncu, var_angles, originaldegistir_oyuncu)

                    originaldegistir[1] = originaldegistir_oyuncu[1] - 90.0
                    set_entvar(ent_admin[oyuncu], var_angles, originaldegistir);
                    totalJuke++;
                }
                else{
                    client_print_color(oyuncu, print_team_blue, "%L", LANG_PLAYER, "ENOUGHJUKE")
                }

                JukeBoxMenu(oyuncu)
            }
            else {
                SelectEntity(ent_admin[oyuncu], 0);
                new Float:originaldegistir[3]
                get_entvar(ent_admin[oyuncu], var_origin, originaldegistir)
                originaldegistir[2]-=5.0
                set_entvar(ent_admin[oyuncu], var_origin, originaldegistir);
                ent_admin[oyuncu] = 0
                JukeBoxMenu(oyuncu)
            }
        }

        case 2:
        {
            if(ent_admin[oyuncu] == 0){
                static temp, target;
                get_user_aiming(oyuncu, target, temp);

                if(!FClassnameIs(target, ENTCLASS))
                {
                    client_print_color(oyuncu, oyuncu, "%L", LANG_PLAYER, "THEREISNOJUKE")
                    JukeBoxMenu(oyuncu)
                    return HC_BREAK;
                }
                if(get_entvar(target, var_button) != 0){
                    client_print_color(oyuncu, oyuncu, "%L", LANG_PLAYER, "TURNOFFJUKE")
                    JukeBoxMenu(oyuncu)
                    return HC_BREAK;
                }
                ent_admin[oyuncu] = target
                SelectEntity(ent_admin[oyuncu], 1);
                JukeBoxMenu(oyuncu)
            }
            else {
                client_print_color(oyuncu, oyuncu, "%L", LANG_PLAYER, "REMOVEDJUKE")
                DestroyEntity(ent_admin[oyuncu])
                totalJuke--
                ent_admin[oyuncu] = 0
                JukeBoxMenu(oyuncu)
            }

        }
        case 3:
        {
            save_allobject()
            client_print_color(oyuncu, oyuncu, "%L", LANG_PLAYER, "SAVEDJUKES")
        }
    }
    return PLUGIN_HANDLED;
}

public CreateJukeBoxsOnMap(){
    new map[32]
    get_mapname(map, charsmax(map))
    format(g_MapFile, sizeof(g_MapFile), "maps/%s.juke.cfg", map)
    if (file_exists(g_MapFile)) {
        new data[124], len
        new line = 0
        new coord[5][8]
        new Float:origin[3]
        new Float:angle[3];
        while((line = read_file(g_MapFile , line , data , 123 , len)))
        {
            if (len < 2 || data[0] == ';' || data[0] == '/')
                continue;
            parse(data, coord[0], 7, coord[1], 7, coord[2], 7, coord[3], 7)
            origin[0] = (str_to_float(coord[0]))
            origin[1] = (str_to_float(coord[1]))
            origin[2] = (str_to_float(coord[2]))
            angle[1] = (str_to_float(coord[3]))
            CreateJukeBox(origin, 0, 0, angle)
            totalJuke++;
        }
    }
}
public save_allobject() {
    delete_file(g_MapFile)
    new ent = NULLENT
    new Float:fOrigin[3], line[64]
    new Float:angle[3];
    while ((ent = rg_find_ent_by_class(ent, ENTCLASS))) {
        get_entvar(ent, var_origin, fOrigin)
        get_entvar(ent, var_angles, angle)
        formatex(line, sizeof(line), "%0.3f %0.3f %0.3f %0.3f", fOrigin[0], fOrigin[1], fOrigin[2], angle[1])
        write_file(g_MapFile, line)
    }
}
stock GlowEntity(obje)
{
    new pEntity = rg_create_entity("info_target");

    new Float:originaldegistir[3];

    set_entvar(pEntity, var_classname, "GLOWLUSINIF");

    set_entvar(pEntity, var_model, JUKEBOXMDL);
    set_entvar(pEntity, var_modelindex, i_jukeboxmdl);

    get_entvar(obje, var_origin, originaldegistir)
    set_entvar(pEntity, var_origin, originaldegistir);
    set_entvar(pEntity, var_body, 1);

    get_entvar(obje, var_angles, originaldegistir)
    set_entvar(pEntity, var_angles, originaldegistir);

    set_entvar(pEntity,var_movetype,MOVETYPE_TOSS)
    set_entvar(pEntity,var_solid,SOLID_NOT)


    set_entvar(pEntity, var_renderfx, kRenderFxGlowShell);
    set_entvar(pEntity, var_rendercolor, Float:{RGBGLOW});

    set_entvar(obje, var_button, pEntity)
    return pEntity;
}
stock CreateJukeBox(Float:fOrigin[3], skin,oyuncu, Float:fAngle[3])
{
    new pEntity = rg_create_entity("info_target");

    set_entvar(pEntity, var_classname, ENTCLASS);
    set_entvar(pEntity, var_model, JUKEBOXMDL);
    set_entvar(pEntity, var_modelindex, i_jukeboxmdl);

    set_entvar(pEntity, var_skin, skin);
    new Float:mins[3] = { -26.67,-62.04,-24.68 }
    set_entvar(pEntity, var_mins, mins)
    new Float:maxs[3] = { 2.54,19.69,25.82 }
    set_entvar(pEntity, var_maxs, maxs)
    new Float:size[3]
    math_mins_maxs(mins, maxs, size)
    set_entvar(pEntity, var_size, size)
    set_entvar(pEntity,var_movetype,MOVETYPE_TOSS)

    if(skin == 1){
        set_entvar(pEntity,var_solid,SOLID_NOT)
        ent_admin[oyuncu] = pEntity
    }
    else{
        set_entvar(pEntity, var_origin, fOrigin);
        set_entvar(pEntity, var_angles, fAngle);
        set_entvar(pEntity,var_solid,SOLID_BBOX)
    }
    set_entvar(pEntity, var_button, 0)
    return pEntity;
}
public plugin_precache()
{
    i_jukeboxmdl = precache_model(JUKEBOXMDL)
    precache_sound(SoundFile1)
    precache_sound(SoundFile2)
    precache_sound(SoundFile3)
    precache_sound(StartingSoundFile)
}
public client_disconnected(id){
    if(ent_admin[id] != 0){
        DestroyEntity(ent_admin[id])
        totalJuke--
        ent_admin[id] = 0
    }
}
public DestroyEntity(ent) {
    if (is_entity(ent))
        set_entvar(ent, var_flags, get_entvar(ent, var_flags) | FL_KILLME);
}
public SelectEntity(ent, flag) {
    set_entvar(ent,var_solid, flag==0 ? SOLID_BBOX : SOLID_NOT)
    set_entvar(ent, var_skin, flag);
}
math_mins_maxs(const Float:mins[3], const Float:maxs[3], Float:size[3])
{
    size[0] = (xs_fsign(mins[0]) * mins[0]) + maxs[0]
    size[1] = (xs_fsign(mins[1]) * mins[1]) + maxs[1]
    size[2] = (xs_fsign(mins[2]) * mins[2]) + maxs[2]
}
stock rg_entity_distance(ent1, ent2) //Yek'-ta
{
    new Float:orig1[3], Float:orig2[3], origin1[3], origin2[3]
    get_entvar(ent1, var_origin, orig1)
    for(new a = 0; a < 3; a++)
        origin1[a] = floatround(orig1[a])

    get_entvar(ent2, var_origin, orig2)
    for(new b = 0; b < 3; b++)
        origin2[b] = floatround(orig2[b])

    return get_distance(origin1, origin2)
}

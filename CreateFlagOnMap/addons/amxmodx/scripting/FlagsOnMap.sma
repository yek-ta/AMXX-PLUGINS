#include <amxmodx>
#include <amxmisc>
#include <engine>
#include <fakemeta>

#define MENU_COMMAND "amx_flagmenu"


#if AMXX_VERSION_NUM < 183
    #define argbreak strbreak
#endif

#define MAXFLAG 30

new const FlagClass[] = "CFlag";
new g_MapFile[64];
enum _:FlagValue
{
    flag[33],
    flag_model,
    flag_body,
    flag_skin
}
new PlayerFlagValue[FlagValue][33];
new FlagsModels[MAXFLAG][32];
new FlagModelSkins[MAXFLAG][3][32]
new totalFlags
new configsdir[200]
new bool:cstrikerun
public plugin_init()
{
    register_plugin("Create Flag on Map", "3.2", "Yek'-ta")
    register_dictionary("FlagsOnMap.txt")

    register_clcmd(MENU_COMMAND, "FlagMenu", ADMIN_RCON)

    if(cstrike_running()){
        cstrikerun = true
        register_event("HLTV", "round_start", "a", "1=0", "2=0");
    }
    else {
        cstrikerun = false
    }
}

public plugin_precache()
{
    get_configsdir(configsdir,199)
    new precachefile[200]
    format(precachefile,199,"%s/FlagModels.ini",configsdir)
    if(file_exists(precachefile))
    {
        new read[96], trash, string[96], modelname[32], skin1[32], skin2[32], skin3[32]
        for(new i=0;i<file_size(precachefile,1);i++)
        {
            read_file(precachefile,i,read,charsmax(string),trash)
            argbreak (read,modelname,charsmax(modelname),string,charsmax(string))
            argbreak (string,skin1,charsmax(skin1),string,charsmax(string))
            argbreak (string,skin2,charsmax(skin2),string,charsmax(string))
            argbreak (string,skin3,charsmax(skin3),string,charsmax(string))
            if(strlen(modelname) && modelname[0] != '/')
            {
                precache_model(modelname)
                FlagsModels[totalFlags] = modelname
                FlagModelSkins[totalFlags][0] = skin1
                FlagModelSkins[totalFlags][1] = skin2
                FlagModelSkins[totalFlags][2] = skin3
                totalFlags++;
            }
        }
    }
    CreateMapFlags()
}

public client_putinserver(id){
    PlayerFlagValue[flag_model][id]=0;
    PlayerFlagValue[flag_body][id]=0;
    PlayerFlagValue[flag_skin][id]=0;
    PlayerFlagValue[flag][id]=0;
}

public round_start(){
    new ent, Float:Angle[3];
    ent = -1
    Angle[1] = float(random_num(0, 359))
    while ((ent = find_ent_by_class(ent, FlagClass))){
        if(pev(ent,pev_impulse)){
            set_pev(ent, pev_angles, Angle);
        }
    }
}

public FlagMenu(player, level, cid){
    if( !cmd_access( player, level, cid, 1 ) )
        return PLUGIN_HANDLED;

    new menu, Menuz[512]

    formatex(Menuz, charsmax(Menuz), "%L", player, "FLAG_MENU");

    menu = menu_create(Menuz, "FlagMenuC")

    if(PlayerFlagValue[flag][player] == 0){

        formatex(Menuz, charsmax(Menuz), "%L", player, "CREATE_FLAG");
        menu_additem(menu, Menuz, "1")

        formatex(Menuz, charsmax(Menuz), "%L", player, "FLAG_MODEL", FlagsModels[PlayerFlagValue[flag_model][player]][7]);
        menu_additem(menu, Menuz, "2")

        formatex(Menuz, charsmax(Menuz), "%L", player, "FLAG_BODY", PlayerFlagValue[flag_body][player] == 0 ? "Small" : "Large" );
        menu_additem(menu, Menuz, "3")

        formatex(Menuz, charsmax(Menuz), "%L", player, "FLAG_SKIN", FlagModelSkins[PlayerFlagValue[flag_model][player]][PlayerFlagValue[flag_skin][player]]);
        menu_additem(menu, Menuz, "4")

        formatex(Menuz, charsmax(Menuz), "%L", player, "SELECT_FLAG" );
        menu_additem(menu, Menuz, "5")
        formatex(Menuz, charsmax(Menuz), "%L", player, "SAVE_FLAGS" );
        menu_additem(menu, Menuz, "6")
        formatex(Menuz, charsmax(Menuz), "%L", player, "DELETE_FLAGS" );
        menu_additem(menu, Menuz, "7")
    }
    else {
        if(cstrikerun){
            formatex(Menuz, charsmax(Menuz), "%L", player, "RANDOM_TURN", pev(PlayerFlagValue[flag][player],pev_impulse) == 0 ? "OFF" : "ON");
            menu_additem(menu, Menuz, "1")
        }

        if(pev(PlayerFlagValue[flag][player], pev_impulse) == 0){
            formatex(Menuz, charsmax(Menuz), "%L", player, "TURN");
            menu_additem(menu, Menuz, "2")
        }

        formatex(Menuz, charsmax(Menuz), "%L", player, "ANIM_FLAG");
        menu_additem(menu, Menuz, "3")

        formatex(Menuz, charsmax(Menuz), "%L", player, "DELETE_FLAG");
        menu_additem(menu, Menuz, "4")

        formatex(Menuz, charsmax(Menuz), "%L", player, "DROP_FLAG");
        menu_additem(menu, Menuz, "5")
    }

    menu_display(player, menu, 0)


    return PLUGIN_HANDLED
}

public FlagMenuC(player, menu, item)
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
    switch(key)
    {
        case 1:
        {
            if(PlayerFlagValue[flag][player] == 0){
                NowCreateFlag(GetUser3Origin(player), player)
            }
            else{
                set_pev(PlayerFlagValue[flag][player], pev_impulse, !pev(PlayerFlagValue[flag][player],pev_impulse))
            }
            client_cmd(player, MENU_COMMAND)
        }
        case 2:
        {
            if(PlayerFlagValue[flag][player] == 0){
                PlayerFlagValue[flag_model][player]++
                PlayerFlagValue[flag_skin][player] = 0
                if(PlayerFlagValue[flag_model][player] >= totalFlags)
                    PlayerFlagValue[flag_model][player] = 0;
            }
            else{
                static Float:f_Angles[3];
                pev(PlayerFlagValue[flag][player], pev_angles, f_Angles)
                f_Angles[1] += 5.0
                if(f_Angles[1] >= 360.0){
                    f_Angles[1]=0.0
                }
                set_pev(PlayerFlagValue[flag][player], pev_angles, f_Angles);
            }
            client_cmd(player, MENU_COMMAND)
        }
        case 3:
        {
            if(PlayerFlagValue[flag][player] == 0){
                PlayerFlagValue[flag_body][player] = PlayerFlagValue[flag_body][player] == 0 ? 1 : 0;
            }
            else{
                set_pev(PlayerFlagValue[flag][player], pev_sequence, !pev(PlayerFlagValue[flag][player], pev_sequence))
            }
            client_cmd(player, MENU_COMMAND)
        }
        case 4:
        {
            if(PlayerFlagValue[flag][player] == 0){
                PlayerFlagValue[flag_skin][player]++
                if(PlayerFlagValue[flag_skin][player] >= 3 || !strlen(FlagModelSkins[PlayerFlagValue[flag_model][player]][PlayerFlagValue[flag_skin][player]]))
                    PlayerFlagValue[flag_skin][player] = 0;
            }
            else{
                DestroyEntity(PlayerFlagValue[flag][player]);
                PlayerFlagValue[flag][player] = 0
            }
            client_cmd(player, MENU_COMMAND)
        }
        case 5:
        {
            if(PlayerFlagValue[flag][player] == 0){
                static Float: originf[3]
                pev(player, pev_origin, originf);
                static victim = -1;
                static thereisflag
                thereisflag = 0
                while ((victim = engfunc(EngFunc_FindEntityInSphere, victim, originf, 50.0)))
                {
                    static classname[32];
                    pev(victim, pev_classname, classname, charsmax(classname));
                    if(equal (classname, FlagClass))
                    {
                        thereisflag = victim
                    }
                }

                PlayerFlagValue[flag][player] = thereisflag
            }
            else{
                PlayerFlagValue[flag][player] = 0
            }
            client_cmd(player, MENU_COMMAND)
        }
        case 6:
        {
            save_allobject()
            client_print(player,print_chat, "%L",player,"SAVED_FLAGS")
        }
        case 7:
        {
            client_print(player,print_chat, "%L",player,"DELETED_FLAGS")
            delete_file(g_MapFile);
            new ent = -1;
            while ((ent = find_ent_by_class(ent, FlagClass)))
                DestroyEntity(ent);

            client_cmd(player, MENU_COMMAND)
        }
    }
    return PLUGIN_HANDLED;
}

DestroyEntity(ent) {
    if (is_valid_ent(ent))
        remove_entity(ent)
}

stock Float:GetUser3Origin(id)
{
    new Float:originf[3]
    pev(id,pev_origin,originf)
    originf[2] = PlayerFlagValue[flag_body][id] == 1 ? originf[2]+25.0 : originf[2]-35.0
    return originf;
}

CreateMapFlags(){
    new map[32]
    get_mapname(map, 31)
    format(g_MapFile, sizeof(g_MapFile), "maps/%s.mapflags.cfg", map)
    if (file_exists(g_MapFile)) {
        new data[124], len
        new line = 0
        new coord[9][8]
        new Float:origin[3]
        new Float:angle
        new modeli[5]
        while((line = read_file(g_MapFile , line , data , 123 , len)))
        {
            if (len < 2 || data[0] == ';' || data[0] == '/')
                continue;
            parse(data, coord[0], 7, coord[1], 7, coord[2], 7,coord[3], 7, coord[4], 1, coord[5], 1, coord[6], 1, coord[7], 1, coord[8], 1)
            origin[0] = (str_to_float(coord[0]))
            origin[1] = (str_to_float(coord[1]))
            origin[2] = (str_to_float(coord[2]))
            angle = (str_to_float(coord[3]))
            modeli[0] = (str_to_num(coord[4]))
            modeli[1] = (str_to_num(coord[5]))
            modeli[2] = (str_to_num(coord[6]))
            modeli[3] = (str_to_num(coord[7]))
            modeli[4] = (str_to_num(coord[8]))
            if(modeli[0] < totalFlags)
                CreateFlag(origin,modeli[0],modeli[1], modeli[2], 0, modeli[3], angle, modeli[4])
        }
    }
}

stock NowCreateFlag(Float:fOrigin[3],player)
{
    CreateFlag(fOrigin, PlayerFlagValue[flag_model][player], PlayerFlagValue[flag_body][player],PlayerFlagValue[flag_skin][player], player, 0, 0.0 , 0);
}

save_allobject() {
    delete_file(g_MapFile)
    new ent = -1
    new Float:fOrigin[3], line[64], Float:fAngle[3]
    while ((ent = find_ent_by_class(ent, FlagClass))) {
        pev(ent,pev_origin,fOrigin)
        pev(ent,pev_angles,fAngle)

        formatex(line, sizeof(line), "%0.3f %0.3f %0.3f %0.3f %i %i %i %i %i", fOrigin[0], fOrigin[1], fOrigin[2], fAngle[1], pev(ent,pev_button), pev(ent,pev_body), pev(ent,pev_skin), pev(ent,pev_impulse), pev(ent,pev_sequence))
        write_file(g_MapFile, line)
    }
}

CreateFlag(Float:fOrigin[3], model, body, skin, player, random, Float:Angle, anim)
{
    new pEntity = create_entity("info_target");
    entity_set_string(pEntity, EV_SZ_classname, FlagClass );
    new Float: Angles[3]
    Angles[1] = Angle
    set_pev( pEntity, pev_angles, Angles)
    set_pev( pEntity, pev_origin, fOrigin)
    set_pev( pEntity, pev_movetype, MOVETYPE_NONE)
    set_pev( pEntity, pev_body, body)
    set_pev( pEntity, pev_skin, skin)
    entity_set_model(pEntity, FlagsModels[model]);
    set_pev( pEntity, pev_button, model)
    set_pev( pEntity, pev_impulse, random)
    set_pev( pEntity, pev_animtime, get_gametime())
    set_pev( pEntity, pev_framerate, 1.0)
    set_pev( pEntity, pev_sequence, anim)
    PlayerFlagValue[flag][player] = pEntity
}

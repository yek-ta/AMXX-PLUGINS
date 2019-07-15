#include <amxmodx>
#include <amxmisc>
#include <engine>
#include <fakemeta>

#if AMXX_VERSION_NUM < 183
    #define argbreak strbreak
#endif

#define MAXFLAG 30

new const FlagClass[] = "CFlag";
new g_MapFile[64];
enum _:FlagValue
{
    flag_model,
    flag_body,
    flag_skin
}
new PlayerFlagValue[FlagValue][33];
new FlagsModels[MAXFLAG][32];
new FlagModelSkins[MAXFLAG][3][32]
new totalFlags
new configsdir[200]
public plugin_init()
{
    register_plugin("Create Flags on Map", "2.1", "Yek'-ta")
    set_task(5.0,"CreateMapFlags")

    register_clcmd( "amx_flagmenu", "FlagMenu")
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
}
public FlagMenu(player){
    if(get_user_flags(player) & ADMIN_RCON){
        new menu, Menuz[512]

        formatex(Menuz, charsmax(Menuz), "\y [ \rFlag Menu \y]");

        menu = menu_create(Menuz, "FlagMenuC")

        formatex(Menuz, charsmax(Menuz), "\wCreate Flag");
        menu_additem(menu, Menuz, "1")

        formatex(Menuz, charsmax(Menuz), "\wFlag Model [%s]", FlagsModels[PlayerFlagValue[flag_model][player]][7]);
        menu_additem(menu, Menuz, "2")

        formatex(Menuz, charsmax(Menuz), "\wFlag Body [%s]", PlayerFlagValue[flag_body][player] == 0 ? "Small" : "Large" );
        menu_additem(menu, Menuz, "3")

        formatex(Menuz, charsmax(Menuz), "\wFlag Skin [%s]", FlagModelSkins[PlayerFlagValue[flag_model][player]][PlayerFlagValue[flag_skin][player]]);
        menu_additem(menu, Menuz, "4")

        formatex(Menuz, charsmax(Menuz), "\wSave Flags" );
        menu_additem(menu, Menuz, "5")
        formatex(Menuz, charsmax(Menuz), "\wDelete Flags" );
        menu_additem(menu, Menuz, "6")

        menu_display(player, menu, 0)
    }

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
    if(!is_user_alive(player)){
        client_print(player,print_chat, "You should be alive for this command")
        return PLUGIN_HANDLED;
    }
    switch(key)
    {
        case 1:
        {
            NowCreateFlag(GetUser3Origin(player), player)
        }
        case 2:
        {
            PlayerFlagValue[flag_model][player]++
            PlayerFlagValue[flag_skin][player] = 0
            if(PlayerFlagValue[flag_model][player] >= totalFlags)
                PlayerFlagValue[flag_model][player] = 0;
            FlagMenu(player)
        }
        case 3:
        {
            PlayerFlagValue[flag_body][player] = PlayerFlagValue[flag_body][player] == 0 ? 1 : 0;
            FlagMenu(player)
        }
        case 4:
        {
            PlayerFlagValue[flag_skin][player]++
            if(PlayerFlagValue[flag_skin][player] >= 3 || !strlen(FlagModelSkins[PlayerFlagValue[flag_model][player]][PlayerFlagValue[flag_skin][player]]))
                PlayerFlagValue[flag_skin][player] = 0;
            FlagMenu(player)
        }
        case 5:
        {
            save_allobject()
            client_print(player,print_chat, "Saved Flags..")
        }
        case 6:
        {
            client_print(player,print_chat, "Deleted Flags..")
            delete_file(g_MapFile);
            new ent = -1;
            while ((ent = find_ent_by_class(ent, FlagClass)))
                DestroyEntity(ent);
        }
    }
    return PLUGIN_HANDLED;
}




public client_putinserver(id){
    PlayerFlagValue[flag_model][id]=0;
    PlayerFlagValue[flag_body][id]=0;
    PlayerFlagValue[flag_skin][id]=0;
}

public DestroyEntity(ent) {
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

public CreateMapFlags(){
    new map[32]
    get_mapname(map, 31)
    format(g_MapFile, sizeof(g_MapFile), "maps/%s.mflags.cfg", map)
    if (file_exists(g_MapFile)) {
        new data[124], len
        new line = 0
        new coord[6][8]
        new Float:origin[3]
        new modeli[3]
        while((line = read_file(g_MapFile , line , data , 123 , len)))
        {
            if (len < 2 || data[0] == ';' || data[0] == '/')
                continue;
            parse(data, coord[0], 7, coord[1], 7, coord[2], 7, coord[3], 1, coord[4], 1, coord[5], 1)
            origin[0] = (str_to_float(coord[0]))
            origin[1] = (str_to_float(coord[1]))
            origin[2] = (str_to_float(coord[2]))
            modeli[0] = (str_to_num(coord[3]))
            modeli[1] = (str_to_num(coord[4]))
            modeli[2] = (str_to_num(coord[5]))
            if(modeli[0] < totalFlags)
                CreateFlag(origin,modeli[0],modeli[1], modeli[2])
        }
    }
}

stock NowCreateFlag(Float:fOrigin[3],player)
{
    CreateFlag(fOrigin, PlayerFlagValue[flag_model][player], PlayerFlagValue[flag_body][player],PlayerFlagValue[flag_skin][player]);
}

public save_allobject() {
    delete_file(g_MapFile)
    new ent = -1
    new Float:fOrigin[3], line[64]
    while ((ent = find_ent_by_class(ent, FlagClass))) {
        pev(ent,pev_origin,fOrigin)

        formatex(line, sizeof(line), "%0.3f %0.3f %0.3f %i %i %i", fOrigin[0], fOrigin[1], fOrigin[2], pev(ent,pev_button), pev(ent,pev_body), pev(ent,pev_skin))
        write_file(g_MapFile, line)
    }
}

CreateFlag(Float:fOrigin[3], model, body, skin)
{
    new pEntity = create_entity("info_target");
    entity_set_string(pEntity, EV_SZ_classname, FlagClass );
    set_pev( pEntity, pev_movetype, MOVETYPE_NONE)
    set_pev( pEntity, pev_origin, fOrigin)
    set_pev( pEntity, pev_body, body)
    set_pev( pEntity, pev_skin, skin)
    entity_set_model(pEntity, FlagsModels[model]);
    set_pev( pEntity, pev_button, model)
    Set_Entity_Anim(pEntity,0,0)
}
Set_Entity_Anim(ent, forumcsd, ResetFrame)
{
    if(!is_valid_ent(ent))
        return

    set_pev( ent, pev_animtime, get_gametime())
    set_pev( ent, pev_framerate, 1.0)
    set_pev( ent, pev_sequence, forumcsd)

    if(ResetFrame) set_pev( ent, pev_frame, 0.0)
}

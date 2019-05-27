#include <amxmodx>
#include <reapi>
#include <engine>

#define FLAGMODEL "models/TurkBayragi.mdl"
#define SKIN1NAME "Turk Bayragi"
#define SKIN2NAME "Ataturkiye"
#define SKIN3NAME "Ataturk"

new const FlagClass[] = "CFlag";
new g_MapFile[64];
enum
{
    Skin1 = 0,
    Skin2,
    Skin3
}
enum _:FlagValue
{
    flag_body,
    flag_skin
}
new PlayerFlagValue[FlagValue][33];
public plugin_init()
{
    register_plugin("Create Flags on Map", "1.1", "Yek'-ta")
    set_task(5.0,"CreateMapFlags")

    register_clcmd( "amx_flagmenu", "FlagMenu")
}

public FlagMenu(player){
    if(get_user_flags(player) & ADMIN_RCON){
        new menu, Menuz[512]

        formatex(Menuz, charsmax(Menuz), "\y [ \rFlag Menu \y]");

        menu = menu_create(Menuz, "FlagMenuC")

        formatex(Menuz, charsmax(Menuz), "\wCreate Flag" );
        menu_additem(menu, Menuz, "1")
        formatex(Menuz, charsmax(Menuz), "\wFlag Body [%s]", PlayerFlagValue[flag_body][player] == Skin1 ? "Small" : "Large" );
        menu_additem(menu, Menuz, "2")

        if(PlayerFlagValue[flag_skin][player] == Skin1){ formatex(Menuz, charsmax(Menuz), "\wFlag Skin [%s]",SKIN1NAME ); }
        else if(PlayerFlagValue[flag_skin][player] == Skin2){ formatex(Menuz, charsmax(Menuz), "\wFlag Skin [%s]",SKIN2NAME ); }
        else if(PlayerFlagValue[flag_skin][player] == Skin3){ formatex(Menuz, charsmax(Menuz), "\wFlag Skin [%s]",SKIN3NAME ); }
        menu_additem(menu, Menuz, "3")

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
        client_print_color(player, print_team_blue, "^3You should be alive for this command")
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
            PlayerFlagValue[flag_body][player] = PlayerFlagValue[flag_body][player] == Skin1 ? Skin2 : Skin1;
            FlagMenu(player)
        }
        case 3:
        {
            if(PlayerFlagValue[flag_skin][player] == Skin1){ PlayerFlagValue[flag_skin][player] = Skin2; }
            else if(PlayerFlagValue[flag_skin][player] == Skin2){ PlayerFlagValue[flag_skin][player] = Skin3; }
            else if(PlayerFlagValue[flag_skin][player] == Skin3){ PlayerFlagValue[flag_skin][player] = Skin1; }
            FlagMenu(player)
        }
        case 5:
        {
            save_allobject()
            client_print_color(player, player, "^3Saved Flags..")
        }
        case 6:
        {
            client_print_color(player, player, "^3Deleted Flags..")
            delete_file(g_MapFile);
            new ent = NULLENT;
            while ((ent = rg_find_ent_by_class(ent, FlagClass)))
                DestroyEntity(ent);
        }
    }
    return PLUGIN_HANDLED;
}




public client_putinserver(id){
    PlayerFlagValue[flag_body][id]=Skin1;
    PlayerFlagValue[flag_skin][id]=Skin1;
}

public DestroyEntity(ent) {
    if (is_entity(ent))
        set_entvar(ent, var_flags, get_entvar(ent, var_flags) | FL_KILLME);
}

stock Float:GetUser3Origin(id)
{
    new Float:originf[3]
    get_entvar(id, var_origin, originf);
    originf[2] = PlayerFlagValue[flag_body][id] == Skin2 ? originf[2]+25.0 : originf[2]-35.0
    return originf;
}

public CreateMapFlags(){
    new map[32]
    get_mapname(map, 31)
    format(g_MapFile, sizeof(g_MapFile), "maps/%s.flags.cfg", map)
    if (file_exists(g_MapFile)) {
        new data[124], len
        new line = 0
        new coord[5][8]
        new Float:origin[3]
        new modeli[2]
        while((line = read_file(g_MapFile , line , data , 123 , len)))
        {
            if (len < 2 || data[0] == ';' || data[0] == '/')
                continue;
            parse(data, coord[0], 7, coord[1], 7, coord[2], 7, coord[3], 1, coord[4], 1)
            origin[0] = (str_to_float(coord[0]))
            origin[1] = (str_to_float(coord[1]))
            origin[2] = (str_to_float(coord[2]))
            modeli[0] = (str_to_num(coord[3]))
            modeli[1] = (str_to_num(coord[4]))
            CreateFlag(origin,modeli[0],modeli[1])
        }
    }
}

stock NowCreateFlag(Float:fOrigin[3],player)
{
    CreateFlag(fOrigin, PlayerFlagValue[flag_body][player],PlayerFlagValue[flag_skin][player]);
}

public save_allobject() {
    delete_file(g_MapFile)
    new ent = NULLENT
    new Float:fOrigin[3], line[64]
    while ((ent = rg_find_ent_by_class(ent, FlagClass))) {
        get_entvar(ent, var_origin, fOrigin)
        formatex(line, sizeof(line), "%0.3f %0.3f %0.3f %i %i", fOrigin[0], fOrigin[1], fOrigin[2], get_entvar(ent, var_body), get_entvar(ent, var_skin))
        write_file(g_MapFile, line)
    }
}

stock CreateFlag(Float:fOrigin[3], body, skin)
{
    new pEntity = rg_create_entity("info_target");
    if(!pEntity)
        return 1;
    set_entvar(pEntity, var_classname, FlagClass);
    set_entvar(pEntity, var_movetype, MOVETYPE_NONE);
    set_entvar(pEntity, var_origin, fOrigin);
    set_entvar(pEntity, var_body, body);
    set_entvar(pEntity, var_skin, skin);
    entity_set_model(pEntity, FLAGMODEL);
    Set_Entity_Anim(pEntity,0,0)
    return pEntity;
}

public plugin_precache()
{
    precache_model(FLAGMODEL);
}
stock Set_Entity_Anim(ent, forumcsd, ResetFrame)
{
    if(!is_entity(ent))
        return

    set_entvar(ent, var_animtime, get_gametime())
    set_entvar(ent, var_framerate, 1.0)
    set_entvar(ent, var_sequence, forumcsd)
    if(ResetFrame) set_entvar(ent, var_frame, 0.0)
}

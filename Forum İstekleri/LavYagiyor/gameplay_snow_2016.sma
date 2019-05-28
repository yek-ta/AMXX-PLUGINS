#include <amxmodx>
#include <engine>
#include <hamsandwich>

#define PLUGIN  "Galaxy"
#define VERSION "2016"
#define AUTHOR  "Ult_Nut" // Yek'-ta

#define get_bit(%1,%2)  (%1 & (1 << (%2 & MAXCLIENTS-1)))
#define set_bit(%1,%2)  (%1 |= (1 << (%2 & MAXCLIENTS-1)))
#define reset_bit(%1,%2)        (%1 &= ~(1 << (%2 & MAXCLIENTS-1)))

#define MAXCLIENTS 32
#define SNOW_SPRITE "sprites/lavabu3.spr"
#define CLASSNAME "SnowEntity"

new g_bAlive;

new g_iSpriteSnow;
new g_iMaxPlayers;

public plugin_init()
{
    register_plugin(PLUGIN, VERSION, AUTHOR);

    register_event("HLTV", "Event_NewRound", "a", "1=0", "2=0");

    new ent = create_entity("info_target");

    entity_set_string(ent, EV_SZ_classname, CLASSNAME);
    entity_set_float(ent, EV_FL_nextthink, get_gametime() + 2.0);

    register_think(CLASSNAME, "ThinkSnow");

    RegisterHam(Ham_Spawn, "player", "Ham_PlayerSpawn_Post", 1);
    RegisterHam(Ham_Killed, "player", "HamPlayerKilled_Post", 1);

    g_iMaxPlayers = get_maxplayers();
}
public plugin_precache()
{
    g_iSpriteSnow = precache_model(SNOW_SPRITE);
}
public Ham_PlayerSpawn_Post(id)
{
    if(is_user_alive(id)) set_bit(g_bAlive, id);
}
public Event_NewRound(){
    set_fog(25, 10, 35);
    set_lights ("f");
}
public HamPlayerKilled_Post(id)
{
    reset_bit(g_bAlive, id);
}
public ThinkSnow(ent)
{
    entity_set_float(ent, EV_FL_nextthink, get_gametime() + 0.10);

    static id;
    for(id = 1; id <= g_iMaxPlayers; id++)
    {
        if(!get_bit(g_bAlive, id)) continue;

        new Float:fOrigin[3], iOrigin[3];
        entity_get_vector(id, EV_VEC_origin, fOrigin);
        FVecIVec(fOrigin, iOrigin);
        iOrigin[0] += random_num(-1000, 1000);
        iOrigin[1] += random_num(-1000, 1000);
        iOrigin[2] += random_num(100, 200);
        UTIL_CreateSnow(iOrigin, g_iSpriteSnow, 1, 1, 2);
    }
}
stock UTIL_CreateSnow(const iOrigin[3], const iSpriteID, const iCount, const iLife, const iScale)
{
    message_begin(MSG_BROADCAST,SVC_TEMPENTITY);
    write_byte(TE_SPRITETRAIL);
    write_coord(iOrigin[0]);
    write_coord(iOrigin[1]);
    write_coord(iOrigin[2]);
    write_coord(iOrigin[0]);
    write_coord(iOrigin[1]);
    write_coord(iOrigin[2]);
    write_short(iSpriteID);
    write_byte(iCount);
    write_byte(iLife);
    write_byte(iScale);
    write_byte(random_num(1, 5));
    write_byte(random_num(1, 8));
    message_end();
}

stock set_fog(red, green, blue){
    message_begin(MSG_ALL, get_user_msgid("Fog"));
    write_byte(red);
    write_byte(green);
    write_byte(blue);
    write_long(_:0.00065)
    message_end();
}

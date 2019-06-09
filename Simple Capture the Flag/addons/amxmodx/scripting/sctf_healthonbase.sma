/* Yek'-ta */

#include <amxmodx>
#include <simple_ctf>
#include <reapi>

#define PLUGIN  "SCTF Health on Base"
#define VERSION "1.1"
#define AUTHOR  "Yek'-ta"
new gSpr_regeneration
public plugin_init()
{
    register_plugin(PLUGIN, VERSION, AUTHOR)
}

public sctf_player_entered_CTFlagBase(player,ent){
    if(get_user_team(player) == 2){
        set_task(0.5,"yetonbase",player)
    }
}
public sctf_player_entered_TEFlagBase(player,ent){
    if(get_user_team(player) == 1){
        set_task(0.5,"yetonbase",player)
    }
}
public yetonbase(player){
    if(is_user_connected(player) && is_user_alive(player)){
        if(is_user_inCTFlagBase(player) || is_user_inTEFlagBase(player)){
            set_task(0.4,"yetonbase",player)
            new Float:health = Float:get_entvar(player, var_health);
            if(health < 100.0){
                player_healingEffect(player)
                set_entvar(player, var_health, health+1.0);
            }
        }
    }
}

public plugin_precache()
{
    gSpr_regeneration = precache_model("sprites/simple_ctf/Health.spr")
}


player_healingEffect(id)
{
    new iOrigin[3]

    get_user_origin(id, iOrigin)

    message_begin(MSG_PVS, SVC_TEMPENTITY, iOrigin)
    write_byte(TE_PROJECTILE)
    write_coord(iOrigin[0]+ random_num(-10, 10))
    write_coord(iOrigin[1]+ random_num(-10, 10))
    write_coord(iOrigin[2]+ random_num(0, 30))
    write_coord(0)
    write_coord(0)
    write_coord(15)
    write_short(gSpr_regeneration)
    write_byte(1)
    write_byte(id)
    message_end()
}

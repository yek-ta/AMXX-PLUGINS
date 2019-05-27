/* Yek'-ta */

#include <amxmodx>
#include <csd_bayrakkapmaca>
#include <reapi>

#define PLUGIN  "Alanda Can Toplama"
#define VERSION "1.0"
#define AUTHOR  "Yek'-ta"
new gSpr_regeneration
public plugin_init()
{
    register_plugin(PLUGIN, VERSION, AUTHOR)
}

public csd_ctalaninagirdi(oyuncu,obje){
    if(get_user_team(oyuncu) == 2){
        set_task(0.5,"halaalandasin",oyuncu)
    }
}
public csd_tealaninagirdi(oyuncu,obje){
    if(get_user_team(oyuncu) == 1){
        set_task(0.5,"halaalandasin",oyuncu)
    }
}
public halaalandasin(oyuncu){
    if(is_user_connected(oyuncu) && is_user_alive(oyuncu)){
        if(csd_ctalanindami(oyuncu) || csd_tealanindami(oyuncu)){
            set_task(1.0,"halaalandasin",oyuncu)
            new Float:health = Float:get_entvar(oyuncu, var_health);
            if(health < 100.0){
                player_healingEffect(oyuncu)
                set_entvar(oyuncu, var_health, health+1.0);
            }
        }
    }
}

public plugin_precache()
{
    gSpr_regeneration = precache_model("sprites/csd_bayrakkapmaca/cantoplama.spr")
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

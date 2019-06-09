/* Yek'-ta */

#include <amxmodx>
#include <amxmisc>
#include <simple_ctf>

#define TIME 80.0
public plugin_init()
{
    register_plugin("SCTF Flaggers Controller", "1.0", "Yek'-ta")
    register_clcmd("sctf_backtoflag", "move_back_flag_com" , ADMIN_BAN)
}
public move_back_flag_com(id, level, cid){
    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED;

    sctf_move_to_flag_back(sctf_ent_TEFlag())
    sctf_move_to_flag_back(sctf_ent_CTFlag())
    new name[MAX_NAME_LENGTH]
    get_user_name(id, name, charsmax(name))
    client_print_color(0, id, "^1[SCTF] ^3%s ^4moves flags to base",name)

    return PLUGIN_HANDLED;
}
public sctf_flag_dropped(player, ent){
    remove_task(player);
}
public sctf_flag_scored(player, ent){
    remove_task(player);
}
public client_disconnected(player){
    remove_task(player);
}
public sctf_flag_is_takenoff(player, ent){
    set_task(TIME,"slay_player",player);
}
public slay_player(player){
    if(is_user_connected(player) && is_user_alive(player)){
        new name[MAX_NAME_LENGTH]
        get_user_name(player, name, charsmax(name))
        client_print_color(0, player, "^1[SCTF] ^3%s ^4slayed. Because carried the flag for a long time.",name)
        user_kill(player)
    }
}

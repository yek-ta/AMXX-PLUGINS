/* Yek'-ta */

#include <amxmodx>
#include <amxmisc>
#include <simple_ctf>

new Float:pCvar_Flagger_Time;
new Float:pCvar_BackToBase_Time;
public plugin_init()
{
    register_plugin("SCTF Flaggers Controller", "1.1", "Yek'-ta")
    register_clcmd("sctf_backtoflag", "move_back_flag_com" , ADMIN_BAN)
    register_dictionary("Simple_CTF.txt");
    pCvar_Flagger_Time = get_pcvar_float(register_cvar("sctf_flagger_time", "90"))
    pCvar_BackToBase_Time = get_pcvar_float(register_cvar("sctf_flag_backtobase", "90"))
}
public move_back_flag_com(id, level, cid){
    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED;

    sctf_move_to_flag_back(sctf_ent_TEFlag())
    sctf_move_to_flag_back(sctf_ent_CTFlag())
    new name[MAX_NAME_LENGTH]
    get_user_name(id, name, charsmax(name))
    client_print_color(0, id, "%L", LANG_PLAYER, "ADMIN_MOVED_FLAGS",name)

    return PLUGIN_HANDLED;
}
public backtobaseflag(flag){
    sctf_move_to_flag_back(flag)
    client_print_color(0, flag == sctf_ent_TEFlag() ? print_team_red : print_team_blue, "%L", LANG_PLAYER, "FLAGTOBASE", flag == sctf_ent_TEFlag() ? "TEFLAG" : "CTFLAG")
}
public sctf_flag_dropped(player, ent){
    remove_task(player);
    set_task(pCvar_BackToBase_Time,"backtobaseflag",ent);
}
public sctf_flag_scored(player, ent){
    remove_task(player);
}
public client_disconnected(player){
    remove_task(player);
}
public sctf_flag_is_takenoff(player, ent){
    remove_task(ent);
    set_task(pCvar_Flagger_Time,"slay_player",player);
}
public slay_player(player){
    if(is_user_connected(player) && is_user_alive(player)){
        new name[MAX_NAME_LENGTH]
        get_user_name(player, name, charsmax(name))
        client_print_color(0, player, "%L", LANG_PLAYER, "FLAGGER_SLAYED",name)
        user_kill(player)
    }
}

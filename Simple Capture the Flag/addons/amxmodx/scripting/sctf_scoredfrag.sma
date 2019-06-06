/* Yek'-ta */

#include <amxmodx>
#include <simple_ctf>
#include <fun>

new skorinfo;
new pCvar_scored_frag;
public plugin_init()
{
    register_plugin("SCTF Scored Frag", "1.2", "Yek'-ta")
    skorinfo = get_user_msgid("ScoreInfo")
    pCvar_scored_frag = get_pcvar_num(register_cvar("sctf_scored_frag", "3"))
}
public sctf_flag_scored(player, ent){

    new newFrags = get_user_frags(player) + pCvar_scored_frag
    set_user_frags(player,newFrags)
    message_begin(MSG_ALL, skorinfo)
    write_byte(player)
    write_short(newFrags)
    write_short(get_user_deaths(player))
    write_short(0)
    write_short(get_user_team(player))
    message_end()
}

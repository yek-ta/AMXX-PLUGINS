#include <amxmisc>
#include <simple_ctf>

new gMsg_ScoreAttrib

public plugin_init()
{
    register_plugin("VIP in Score Board", "1.0", "Yek'-ta")

    gMsg_ScoreAttrib = get_user_msgid("ScoreAttrib")
    register_message(gMsg_ScoreAttrib, "msg_scoreAttrib")
}

public msg_scoreAttrib()
    return (get_msg_arg_int(2) & (1<<1) ? PLUGIN_HANDLED : PLUGIN_CONTINUE)

public sctf_flag_dropped(player, ent){
    message_begin(MSG_BROADCAST, gMsg_ScoreAttrib)
    write_byte(player)
    write_byte(0)
    message_end()
}
public sctf_flag_scored(player, ent){
    message_begin(MSG_BROADCAST, gMsg_ScoreAttrib)
    write_byte(player)
    write_byte(0)
    message_end()
}
public sctf_flag_is_takenoff(player, ent){
    message_begin(MSG_BROADCAST, gMsg_ScoreAttrib)
    write_byte(player)
    write_byte(get_user_team(player) == 2 ? 4 : 2)
    message_end()
}

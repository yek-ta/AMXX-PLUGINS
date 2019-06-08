#include <amxmisc>
#include <simple_ctf>
#include <reapi>

new Msg_ScreenFade;
#define BLUECOLOR 255
#define REDCOLOR 255
#define TRANSPARAN 15
public plugin_init()
{
    register_plugin("SCTF Flagger ScreenFade", "1.2", "Yek'-ta")
    Msg_ScreenFade = get_user_msgid("ScreenFade");
    RegisterHookChain(RG_PlayerBlind, "PlayerBlind", .post = false)
}

public PlayerBlind(const index, const inflictor, const attacker, const Float:fadeTime, const Float:fadeHold, const alpha, Float:color[3])
{
    if(index == sctf_who_TEflagger() || index == sctf_who_CTflagger()){
        set_task(fadeTime+2.0,"sctf_flag_is_takenoff", index);
    }
}

public sctf_flag_dropped(player, ent){
    remove_task(player)
    message_begin(MSG_ONE, Msg_ScreenFade, {0,0,0}, player)
    write_short(0);write_short(0);write_short(0);write_byte(0);
    write_byte(0);write_byte(0);write_byte(0);
    message_end()
}
public sctf_flag_scored(player, ent){
    remove_task(player)
    message_begin(MSG_ONE, Msg_ScreenFade, {0,0,0}, player)
    write_short(0);write_short(0);write_short(0);write_byte(0);
    write_byte(0);write_byte(0);write_byte(0);
    message_end()
}
public sctf_flag_is_takenoff(player, ent){
    if(is_user_alive(player) && is_user_connected(player)){
        message_begin(MSG_ONE, Msg_ScreenFade, {0,0,0}, player)
        write_short(0);write_short(0);write_short(4);
        if(player == sctf_who_TEflagger()){
            write_byte(REDCOLOR);write_byte(100);write_byte(0)
        }
        else{
            write_byte(0);write_byte(100);write_byte(BLUECOLOR)
        }
        write_byte(TRANSPARAN)
        message_end()
    }
}

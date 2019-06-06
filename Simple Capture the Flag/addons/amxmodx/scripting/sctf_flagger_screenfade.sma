#include <amxmisc>
#include <simple_ctf>

new Msg_ScreenFade;
#define BLUECOLOR 255
#define REDCOLOR 255
#define TRANSPARAN 15
public plugin_init()
{
    register_plugin("SCTF Flagger ScreenFade", "1.0", "Yek'-ta")
    Msg_ScreenFade = get_user_msgid("ScreenFade");
}

public sctf_flag_dropped(player, ent){
    message_begin(MSG_ONE, Msg_ScreenFade, {0,0,0}, player)
    write_short(0);write_short(0);write_short(0);write_byte(0);
    write_byte(0);write_byte(0);write_byte(0);
    message_end()
}
public sctf_flag_scored(player, ent){
    message_begin(MSG_ONE, Msg_ScreenFade, {0,0,0}, player)
    write_short(0);write_short(0);write_short(0);write_byte(0);
    write_byte(0);write_byte(0);write_byte(0);
    message_end()
}
public sctf_flag_is_takenoff(player, ent){
    message_begin(MSG_ONE, Msg_ScreenFade, {0,0,0}, player)
    write_short(0);write_short(0);write_short(4);
    if(ent == sctf_ent_CTFlag()){
        write_byte(REDCOLOR);write_byte(100);write_byte(0)
    }
    else{
        write_byte(0);write_byte(100);write_byte(BLUECOLOR)
    }
    write_byte(TRANSPARAN)
    message_end()
}

#include <amxmodx>
#include <simple_ctf>

new name[32]
new g_MsgSync;

public plugin_init()
{
    register_plugin("SCTF Texts and Sounds", "1.2", "Yek'-ta")
    g_MsgSync = CreateHudSyncObj()
}
public sctf_flag_dropped(player,ent){
    if(get_user_team(player) == 1){
        set_hudmessage( 0, 50, 160, -1.0, 0.25, 1, 6.0, 3.0, 0.1, 3.0 );
        ShowSyncHudMsg(0, g_MsgSync, "%s dropped the CTFlag",learnname(player))

        client_cmd(0, "mp3 play ^"sound/simple_ctf/Others/blue_flag_dropped^"")
    }
    else {
        set_hudmessage( 160, 50, 0, -1.0, 0.25, 1, 6.0, 3.0, 0.1, 3.0 );
        ShowSyncHudMsg(0, g_MsgSync,"%s dropped the TEFlag",learnname(player))

        client_cmd(0, "mp3 play ^"sound/simple_ctf/Others/red_flag_dropped^"")
    }
}
public sctf_flag_is_takenoff(player,ent){
    if(get_user_team(player) == 1){
        set_hudmessage( 160, 50, 0, -1.0, 0.25, 1, 6.0, 3.0, 0.1, 3.0 );
        ShowSyncHudMsg(0, g_MsgSync,"%s took CTFlag",learnname(player))

        client_cmd(0, "mp3 play ^"sound/simple_ctf/Others/blue_flag_taken^"")
    }
    else {
        set_hudmessage( 0, 50, 160, -1.0, 0.25, 1, 6.0, 3.0, 0.1, 3.0 );
        ShowSyncHudMsg(0, g_MsgSync,"%s took TEFlag",learnname(player))

        client_cmd(0, "mp3 play ^"sound/simple_ctf/Others/red_flag_taken^"")
    }
}
public sctf_flag_backtobase(player,ent){
    if(get_user_team(player) == 1){
        set_hudmessage( 160, 50, 0, -1.0, 0.25, 1, 6.0, 3.0, 0.1, 3.0 );
        ShowSyncHudMsg(0, g_MsgSync,"%s took own flag and flag is back to base",learnname(player))

        client_cmd(0, "mp3 play ^"sound/simple_ctf/Others/red_flag_returned^"")
    }
    else {
        set_hudmessage( 0, 50, 160, -1.0, 0.25, 1, 6.0, 3.0, 0.1, 3.0 );
        ShowSyncHudMsg(0, g_MsgSync, "%s took own flag and flag is back to base",learnname(player))

        client_cmd(0, "mp3 play ^"sound/simple_ctf/Others/blue_flag_returned^"")
    }
}
public sctf_flag_scored(player,ent){
    if(get_user_team(player) == 1){
        set_hudmessage( 160, 50, 0, -1.0, 0.25, 1, 6.0, 3.0, 0.1, 3.0 );
        ShowSyncHudMsg(0, g_MsgSync, "%s SCORED!!",learnname(player))

        client_cmd(0, "mp3 play sound/simple_ctf/Others/red_scores")
    }
    else {
        set_hudmessage( 0, 50, 160, -1.0, 0.25, 1, 6.0, 3.0, 0.1, 3.0 );
        ShowSyncHudMsg(0, g_MsgSync, "%s SCORED!!",learnname(player))

        client_cmd(0, "mp3 play sound/simple_ctf/Others/blue_scores")
    }
}
public learnname(player){
    get_user_name(player, name, 31)
    return name;
}
public plugin_precache()
{
    precache_generic("sound/simple_ctf/Others/blue_scores.mp3")
    precache_generic("sound/simple_ctf/Others/red_scores.mp3")
    precache_generic("sound/simple_ctf/Others/blue_flag_returned.mp3")
    precache_generic("sound/simple_ctf/Others/red_flag_returned.mp3")
    precache_generic("sound/simple_ctf/Others/red_flag_taken.mp3")
    precache_generic("sound/simple_ctf/Others/blue_flag_taken.mp3")
    precache_generic("sound/simple_ctf/Others/red_flag_dropped.mp3")
    precache_generic("sound/simple_ctf/Others/blue_flag_dropped.mp3")
}

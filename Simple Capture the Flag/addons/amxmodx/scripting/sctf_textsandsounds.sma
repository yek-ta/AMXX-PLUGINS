#include <amxmodx>
#include <simple_ctf>

new name[32]
new g_MsgSync;

public plugin_init()
{
    register_plugin("SCTF Texts and Sounds", "1.3", "Yek'-ta")
    g_MsgSync = CreateHudSyncObj()
    register_dictionary("Simple_CTF.txt");
}
public sctf_flag_dropped(player,ent){
    if(get_user_team(player) == 1){
        set_hudmessage( 0, 50, 160, -1.0, 0.25, 1, 6.0, 3.0, 0.1, 3.0 );
        ShowSyncHudMsg(0, g_MsgSync, "%L", LANG_PLAYER, "DROPFLAGCT",learnname(player))

        client_cmd(0, "mp3 play ^"sound/simple_ctf/Others/blue_flag_dropped^"")
    }
    else {
        set_hudmessage( 160, 50, 0, -1.0, 0.25, 1, 6.0, 3.0, 0.1, 3.0 );
        ShowSyncHudMsg(0, g_MsgSync,"%L", LANG_PLAYER, "DROPFLAGTE",learnname(player))

        client_cmd(0, "mp3 play ^"sound/simple_ctf/Others/red_flag_dropped^"")
    }
}
public sctf_flag_is_takenoff(player,ent){
    if(get_user_team(player) == 1){
        set_hudmessage( 160, 50, 0, -1.0, 0.25, 1, 6.0, 3.0, 0.1, 3.0 );
        ShowSyncHudMsg(0, g_MsgSync,"%L", LANG_PLAYER, "TOOKFLAGCT",learnname(player))

        client_cmd(0, "mp3 play ^"sound/simple_ctf/Others/blue_flag_taken^"")
    }
    else {
        set_hudmessage( 0, 50, 160, -1.0, 0.25, 1, 6.0, 3.0, 0.1, 3.0 );
        ShowSyncHudMsg(0, g_MsgSync,"%L", LANG_PLAYER, "TOOKFLAGTE",learnname(player))

        client_cmd(0, "mp3 play ^"sound/simple_ctf/Others/red_flag_taken^"")
    }
}
public sctf_flag_backtobase(player,ent){
    if(get_user_team(player) == 1){
        set_hudmessage( 160, 50, 0, -1.0, 0.25, 1, 6.0, 3.0, 0.1, 3.0 );
        ShowSyncHudMsg(0, g_MsgSync,"%L", LANG_PLAYER, "TOOKOWNFLAGTE",learnname(player))

        client_cmd(0, "mp3 play ^"sound/simple_ctf/Others/red_flag_returned^"")
    }
    else {
        set_hudmessage( 0, 50, 160, -1.0, 0.25, 1, 6.0, 3.0, 0.1, 3.0 );
        ShowSyncHudMsg(0, g_MsgSync, "%L", LANG_PLAYER, "TOOKOWNFLAGCT",learnname(player))

        client_cmd(0, "mp3 play ^"sound/simple_ctf/Others/blue_flag_returned^"")
    }
}
public sctf_flag_scored(player,ent){
    if(get_user_team(player) == 1){
        set_hudmessage( 160, 50, 0, -1.0, 0.25, 1, 6.0, 3.0, 0.1, 3.0 );
        ShowSyncHudMsg(0, g_MsgSync, "%L", LANG_PLAYER, "SCOREDTE",learnname(player))

        client_cmd(0, "mp3 play sound/simple_ctf/Others/red_scores")
    }
    else {
        set_hudmessage( 0, 50, 160, -1.0, 0.25, 1, 6.0, 3.0, 0.1, 3.0 );
        ShowSyncHudMsg(0, g_MsgSync, "%L", LANG_PLAYER, "SCOREDCT",learnname(player))

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

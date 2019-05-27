#include <amxmodx>
#include <reapi>
#if AMXX_VERSION_NUM < 183
    #define client_disconnected client_disconnect
#endif

enum _:SETTINGS
{
    RATE,
    UPDATERATE,
    CMDRATE
}
new bool:passed[33]=false;
new actual_settings[SETTINGS][33];
new current_settings[SETTINGS][33];
public plugin_init()
{
    register_plugin("Client Rates Menu","2.5","Yek'-ta");
    register_clcmd("say", "handle_say");
    register_dictionary("ClientRatesMenu.txt");
}
public handle_say(id) {
    new szSaid[10]; read_args(szSaid,charsmax(szSaid));
    remove_quotes(szSaid);

    if( (szSaid[0] == '!' || szSaid[0] == '/' || szSaid[0] == '.') && szSaid[1] == 'r' && szSaid[2] == 'a' && szSaid[3] == 't' && szSaid[4] == 'e')
        RateAyarlamaMenu(id);
    return PLUGIN_CONTINUE
}

public client_disconnected(id) {
    if(task_exists(id)) {
        remove_task(id);
    }
    passed[id]=false;
    return PLUGIN_CONTINUE;
}
public client_putinserver(id) {
    if(!is_user_bot(id) && is_user_connected(id) && !is_user_hltv(id)){
        passed[id]=false;
        learn_to_settings(id);
        set_task(3.0,"topassed",id);
    }
    return PLUGIN_CONTINUE;
}
public topassed(id){
    if(!passed[id]) passed[id]=true;
}
public learn_to_settings(id)
{
    if(is_user_connected(id) && is_user_steam(id)){
        query_client_cvar(id, "rate", "cvarfonksion");
        query_client_cvar(id, "cl_updaterate", "cvarfonksion");
        query_client_cvar(id, "cl_cmdrate", "cvarfonksion");
    }
    else if(is_user_connected(id) && !is_user_steam(id)){
        new non_rate[8],non_updaterate[8];
        get_user_info(id, "rate", non_rate, charsmax(non_rate));
        get_user_info(id, "cl_updaterate", non_updaterate, charsmax(non_updaterate));
        if(!passed[id]){
            actual_settings[RATE][id] = str_to_num(non_rate);
        }
        current_settings[RATE][id] = str_to_num(non_rate);
        if(!passed[id]){
            actual_settings[UPDATERATE][id] = str_to_num(non_updaterate);
        }
        current_settings[UPDATERATE][id] = str_to_num(non_updaterate);
    }
}

public cvarfonksion(id, const cvar[], const resultFunc[])
{
    if(equali(cvar,"rate"))
    {
        if(!passed[id]){
            actual_settings[RATE][id] = str_to_num(resultFunc);
        }
        current_settings[RATE][id] = str_to_num(resultFunc);
    }
    if(equali(cvar,"cl_updaterate"))
    {
        if(!passed[id]){
            actual_settings[UPDATERATE][id] = str_to_num(resultFunc);
        }
        current_settings[UPDATERATE][id] = str_to_num(resultFunc);
    }
    if(equali(cvar,"cl_cmdrate"))
    {
        if(!passed[id]){
            actual_settings[CMDRATE][id] = str_to_num(resultFunc);
        }
        current_settings[CMDRATE][id] = str_to_num(resultFunc);
    }
}


public RateAyarlamaMenu(id){
    new menu, Menuz[512];

    if(is_user_steam(id)){
        formatex(Menuz, charsmax(Menuz), "\y %L^nrate %d^ncl_cmdrate %d^ncl_updaterate %d",LANG_PLAYER, "MENU_TITLE",current_settings[RATE][id],current_settings[CMDRATE][id],current_settings[UPDATERATE][id] );
    }
    else {
        formatex(Menuz, charsmax(Menuz), "\y %L^nrate %d^ncl_updaterate %d^n",LANG_PLAYER, "MENU_TITLE",current_settings[RATE][id],current_settings[UPDATERATE][id] );
    }

    menu = menu_create(Menuz, "h_RateAyarlamaMenu");

    formatex(Menuz, charsmax(Menuz), "\w112k \d[6000, 20, 15]" );
    menu_additem(menu, Menuz, "2");

    formatex(Menuz, charsmax(Menuz), "\w256k \d[9000, 25, 20]" );
    menu_additem(menu, Menuz, "3");

    formatex(Menuz, charsmax(Menuz), "\w384k \d[15000, 30, 25]" );
    menu_additem(menu, Menuz, "4");

    formatex(Menuz, charsmax(Menuz), "\w512k \d[17000, 35, 30]" );
    menu_additem(menu, Menuz, "5");

    formatex(Menuz, charsmax(Menuz), "\w768k \d[20000, 40, 35]" );
    menu_additem(menu, Menuz, "6");

    formatex(Menuz, charsmax(Menuz), "\w1MB+ \d[23000, 45, 40]" );
    menu_additem(menu, Menuz, "7");

    formatex(Menuz, charsmax(Menuz), "\wMax. \d[25000, 101, 101]" );
    menu_additem(menu, Menuz, "1");

    if(is_user_steam(id)){
        formatex(Menuz, charsmax(Menuz), "\w%L \d[%d, %d, %d]^n^n",LANG_PLAYER, "YOUR_RATES",actual_settings[RATE][id], actual_settings[CMDRATE][id],actual_settings[UPDATERATE][id] );
        menu_additem(menu, Menuz, "8");
    }
    else{
        formatex(Menuz, charsmax(Menuz), "\d%L \d[%d, %d]^n^n",LANG_PLAYER, "YOUR_RATES",actual_settings[RATE][id],actual_settings[UPDATERATE][id] );
        menu_additem(menu, Menuz, "8");
    }

    formatex(Menuz, charsmax(Menuz), "\w%L",LANG_PLAYER, "CLOSE_MENU");
    menu_additem(menu, Menuz, "9");

    menu_setprop(menu,MPROP_EXIT,MEXIT_NEVER);
    menu_setprop(menu, MPROP_PERPAGE, 0);

    menu_display(id, menu, 0);



    return PLUGIN_HANDLED;
}

public h_RateAyarlamaMenu(id, menu, item)
{
    if (item == MENU_EXIT)
    {
        menu_destroy(menu);

        return PLUGIN_HANDLED;
    }
    new data[6], iName[64];
    new access, callback;
    menu_item_getinfo(menu, item, access, data,5, iName, 63, callback);

    new key = str_to_num(data);
    switch(key)
    {
        case 1:
        {
            client_cmd(id,"rate 25000");
            client_cmd(id,"cl_cmdrate 101");
            client_cmd(id,"cl_updaterate 101");
            client_cmd(id,"cl_rate 9999");
            client_cmd(id,"cl_cmdbackup 2");
            set_task(0.7,"learn_to_settings",id);
            set_task(1.5,"RateAyarlamaMenu",id);
            ChatColor(id,"!y%L",LANG_PLAYER, "LEAVE_BEST_RATE");
        }

        case 2:
        {
            client_cmd(id,"rate 6000");
            client_cmd(id,"cl_cmdrate 20");
            client_cmd(id,"cl_updaterate 15");
            client_cmd(id,"cl_rate 9999");
            client_cmd(id,"cl_cmdbackup 2");
            set_task(0.7,"learn_to_settings",id);
            set_task(1.5,"RateAyarlamaMenu",id);
            ChatColor(id,"!y%L",LANG_PLAYER, "LEAVE_BEST_RATE");
        }

        case 3:
        {
            client_cmd(id,"rate 9000");
            client_cmd(id,"cl_cmdrate 25");
            client_cmd(id,"cl_updaterate 20");
            client_cmd(id,"cl_rate 9999");
            client_cmd(id,"cl_cmdbackup 2");
            set_task(0.7,"learn_to_settings",id);
            set_task(1.5,"RateAyarlamaMenu",id);
            ChatColor(id,"!y%L",LANG_PLAYER, "LEAVE_BEST_RATE");
        }

        case 4:
        {
            client_cmd(id,"rate 15000");
            client_cmd(id,"cl_cmdrate 30");
            client_cmd(id,"cl_updaterate 25");
            client_cmd(id,"cl_rate 15000");
            client_cmd(id,"cl_cmdbackup 2");
            set_task(0.7,"learn_to_settings",id);
            set_task(1.5,"RateAyarlamaMenu",id);
            ChatColor(id,"!y%L",LANG_PLAYER, "LEAVE_BEST_RATE");
        }

        case 5:
        {
            client_cmd(id,"rate 17000");
            client_cmd(id,"cl_cmdrate 35");
            client_cmd(id,"cl_updaterate 30");
            client_cmd(id,"cl_rate 17000");
            client_cmd(id,"cl_cmdbackup 2");
            set_task(0.7,"learn_to_settings",id);
            set_task(1.5,"RateAyarlamaMenu",id);
            ChatColor(id,"!y%L",LANG_PLAYER, "LEAVE_BEST_RATE");
        }

        case 6:
        {
            client_cmd(id,"rate 20000");
            client_cmd(id,"cl_cmdrate 40");
            client_cmd(id,"cl_updaterate 35");
            client_cmd(id,"cl_rate 20000");
            client_cmd(id,"cl_cmdbackup 2");
            set_task(0.7,"learn_to_settings",id);
            set_task(1.5,"RateAyarlamaMenu",id);
            ChatColor(id,"!y%L",LANG_PLAYER, "LEAVE_BEST_RATE");
        }

        case 7:
        {
            client_cmd(id,"rate 23000");
            client_cmd(id,"cl_cmdrate 45");
            client_cmd(id,"cl_updaterate 40");
            client_cmd(id,"cl_rate 23000");
            client_cmd(id,"cl_cmdbackup 2");
            set_task(0.7,"learn_to_settings",id);
            set_task(1.5,"RateAyarlamaMenu",id);
            ChatColor(id,"!y%L",LANG_PLAYER, "LEAVE_BEST_RATE");
        }

        case 8:
        {
            if(is_user_steam(id)){
                client_cmd(id,"rate ^"%d^"",actual_settings[RATE][id]);
                client_cmd(id,"cl_cmdrate ^"%d^"",actual_settings[CMDRATE][id]);
                client_cmd(id,"cl_updaterate ^"%d^"",actual_settings[UPDATERATE][id] );
                client_cmd(id,"cl_cmdbackup 2");
                set_task(0.7,"learn_to_settings",id);
                set_task(1.5,"RateAyarlamaMenu",id);
            }
            else{
                RateAyarlamaMenu(id);
            }
        }

        case 9:
        {
            ChatColor(id,"!y%L",LANG_PLAYER, "MENU_WAS_CLOSED");
        }

    }


    return PLUGIN_HANDLED;
}
stock ChatColor(const id, const input[], any:...)
{
    new count = 1, players[32]
    static msg[191]
    vformat(msg, charsmax(msg), input, 3)
    format(msg, sizeof(msg), "%s", msg)
    replace_all(msg, charsmax(msg), "!g", "^4")
    replace_all(msg, charsmax(msg), "!y", "^1")
    replace_all(msg, charsmax(msg), "!t", "^3")

    if (id) players[0] = id; else get_players(players, count, "ch")
    {
        for (new i = 0; i < count; i++)
        {
            if (is_user_connected(players[i]))
            {
                message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("SayText"), _, players[i])
                write_byte(players[i]);
                write_string(msg);
                message_end();
            }
        }
    }
}

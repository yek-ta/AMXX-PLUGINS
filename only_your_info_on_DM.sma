/*

Herhangi biri düşmanı öldürdüğünde, sağ üstte yazar. Ancak sadece öldürme bilgilerinizi görmek istiyorsanız ve başkalarının da öldürme bilgilerini görmek istemiyorsanız, bu eklentiyi kullanabilirsiniz.

When someone kills enemy, it writes on top right. But if you want to see just your killing information and you don't want to see others killing information, you can use this plugin.

Когда кто-то убивает врага, пишет вверху справа. Но если вы хотите видеть только свою информацию об убийстве и не хотите видеть информацию об убийстве других людей, вы можете использовать этот плагин.


*/

#include <amxmodx>

#define PLUGIN  "Only Your Info on DM"
#define VERSION "1.1"
#define AUTHOR  "Yek'-ta"

new msgID_deathMsg, msgID_sayText
public plugin_init()
{
    register_plugin(PLUGIN, VERSION, AUTHOR)

    msgID_sayText = get_user_msgid("SayText")
    msgID_deathMsg = get_user_msgid("DeathMsg")
    register_message(msgID_deathMsg, "msg_deathMsg")

    register_event("DeathMsg", "player_die", "ae")
}
public msg_deathMsg()
    return PLUGIN_HANDLED;

public player_die()
{
    new iVictim = read_data(2)
    new iKiller = read_data(1)
    new iHS = read_data(3)
    new szWeapon[24]
    read_data(4, szWeapon, 23)
    set_msg_block(msgID_sayText, BLOCK_ONCE)


    do_deathmsg(iKiller, iVictim, iHS, szWeapon)
}

stock do_deathmsg(iKiller, iVictim, iHS, const szWeapon[])
{
    if(is_user_connected(iKiller) && is_user_connected(iVictim)){
        message_begin(MSG_ONE, msgID_deathMsg, _, iKiller);
        write_byte(iKiller)
        write_byte(iVictim)
        write_byte(iHS)
        write_string(szWeapon)
        message_end()

        if(!is_user_bot(iVictim)){
            message_begin(MSG_ONE, msgID_deathMsg, _, iVictim);
            write_byte(iKiller)
            write_byte(iVictim)
            write_byte(iHS)
            write_string(szWeapon)
            message_end()
        }
    }
}

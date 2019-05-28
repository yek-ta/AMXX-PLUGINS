/*

    https://dev-cs.ru/resources/771/
    Yek'-ta
    Mistrick

    When someone kills enemy, it writes on top right. But if you want to see just your killing information and you don't want to see others killing information, you can use this plugin.

    Когда кто-то убивает врага, пишет вверху справа. Но если вы хотите видеть только свою информацию об убийстве и не хотите видеть информацию об убийстве других людей, вы можете использовать этот плагин.

    Herhangi biri düşmanı öldürdüğünde, sağ üstte yazar. Ancak sadece öldürme bilgilerinizi görmek istiyorsanız ve başkalarının da öldürme bilgilerini görmek istemiyorsanız, bu eklentiyi kullanabilirsiniz.
*/

#include <amxmodx>

#define PLUGIN  "Only Your Info on DM"
#define VERSION "1.3"
#define AUTHOR  "Dev-cs.ru"

public plugin_init()
{
    register_plugin(PLUGIN, VERSION, AUTHOR)
    register_message(get_user_msgid("DeathMsg"), "msg_deathMsg")
}
public msg_deathMsg(msgid, dest, receiver)
{
    enum { arg_killer = 1, arg_victim, arg_headshot, arg_weapon_name };

    new killer = get_msg_arg_int(arg_killer);
    new victim = get_msg_arg_int(arg_victim);
    new headshot = get_msg_arg_int(arg_headshot);
    new weapon_name[64];
    get_msg_arg_string(arg_weapon_name, weapon_name, charsmax(weapon_name));

    if(killer) {
        send_deathmsg(msgid, MSG_ONE, killer, killer, victim, headshot, weapon_name);
    }
    if(victim != killer) {
        send_deathmsg(msgid, MSG_ONE, victim, killer, victim, headshot, weapon_name);
    }
    return PLUGIN_HANDLED;
}

stock send_deathmsg(msgid, dest, receiver, killer, victim, headshot, weapon_name[])
{
    message_begin(dest, msgid, _, receiver);
    write_byte(killer);
    write_byte(victim);
    write_byte(headshot);
    write_string(weapon_name);
    message_end();
}

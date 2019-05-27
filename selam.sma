/* Say üzerinden oyuncu bir yazı yazdığı vakit ilk harfleri "s.a", "selam" veya "sa " ise sunucu "Aleyküm Selam Hoşgeldin." karşılığını verir. */

#include <amxmodx>

#define TAG "[forum.csduragi.com]: "

public plugin_init() {
    register_plugin("Selam", "1.0", "Yek'-ta")
    register_clcmd("say","HookSay")
}

public HookSay(id) {
    new szSaid[128]; read_args(szSaid,charsmax(szSaid))
    remove_quotes(szSaid)

    formatex(szSaid,charsmax(szSaid),"%s ",szSaid)
    if((szSaid[0] == 's' && szSaid[1] == 'a' && szSaid[2] == ' ') ||
       (szSaid[0] == 's' && szSaid[1] == '.' && szSaid[2] == 'a') ||
       (szSaid[0] == 's' && szSaid[1] == 'e' && szSaid[2] == 'l' && szSaid[3] == 'a' && szSaid[4] == 'm')) {
            set_task(1.0,"yonlendir",id)
    }
    return PLUGIN_CONTINUE;
}
public yonlendir(id){
    client_print_color(id, print_team_grey, "^3%s ^4Aleyküm Selam Hoşgeldin.",TAG)
}

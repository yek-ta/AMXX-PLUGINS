#include <amxmodx>

public plugin_init(){
    register_plugin("RastgeleTE", "1.1", "Yek'-ta")
    register_clcmd("say /test", "test");
}
public test(id){
    new secilenoyuncu = RastgeleTE()
    new isim[MAX_NAME_LENGTH]
    get_user_name(secilenoyuncu, isim, charsmax(isim))
    client_print_color(0, secilenoyuncu, "^1Secilen Rastgele TE: ^3%s",isim)
}
public RastgeleTE()
{
    new degisken[MAX_PLAYERS],counter;
    for(new i=1;i<=MAX_PLAYERS;i++){
        if(get_user_team(i) == 1 && is_user_alive(i)){
            degisken[counter] = i;
            counter++;
        }
    }
    if(counter != 0){
        new player = random_num(0, counter-1);
        return degisken[player];
    }

    return 0;
}

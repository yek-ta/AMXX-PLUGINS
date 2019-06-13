#include <amxmodx>
#include <amxmisc>
#include <cstrike>
new sansli[4]=0;
new secilenoyuncularoylari[4];
#define SURE 10.0
#define TASK 1337
new bool:OylamaZamani=false;
public plugin_init() {
    register_plugin("Rastgele 4P ve T Gecimi", "1.0", "nd && Yek'-ta"); //forum.csduragi.com
    register_clcmd("say /oylama", "devam", ADMIN_VOTE);
}
public client_disconnected(id){
    if(id == sansli[0] || id == sansli[1] || id == sansli[2] || id == sansli[3]){
        client_print_color(0, print_team_grey, "^3Oylamadaki bir oyuncu cikis yaptigi icin oylama iptal edildi..");
        OylamaZamani=false;
        remove_task(TASK);
    }
}
public devam(id, level, cid){
    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED;

    if(!OylamaZamani){
        secilenoyuncularoylari[0]=0;
        secilenoyuncularoylari[1]=0;
        secilenoyuncularoylari[2]=0;
        secilenoyuncularoylari[3]=0;
        sansli[0]=0;
        sansli[1]=0;
        sansli[2]=0;
        sansli[3]=0;
        new players[MAX_PLAYERS],num; get_players(players, num, "chi");
        if(num>3) {

            while(sansli[0]==0) sansli[0]=players[random_num(0, num-1)];
            while(sansli[1]==0 || sansli[1]==sansli[0]) sansli[1]=players[random_num(0, num-1)];
            while(sansli[2]==0 || sansli[2]==sansli[0] || sansli[2]==sansli[1]) sansli[2]=players[random_num(0, num-1)];
            while(sansli[3]==0 || sansli[3]==sansli[0] || sansli[3]==sansli[1] || sansli[3]==sansli[2]) sansli[3]=players[random_num(0, num-1)];

            client_print_color(0, print_team_grey, "^3Oylama baslatildi...! ^4%.0f ^1saniye sonra bitecek..",SURE);
            client_print_color(0, id, "^1Oylamayi Baslatan ^3%s",isimcek(id));

            OylamaZamani=true;
            for (new i = 1; i <= MaxClients; i++)
            {
                if (is_user_connected(i) && !is_user_bot(i))
                {
                    Menus(i)
                }
            }
            set_task(SURE,"oylamayibitir",TASK);

        } else client_print_color(id, id, "^4Oylama baslatabilmek icin gercek oyuncu sayisi yeterli degil.");
    }
    else{
        client_print_color(id, id, "^4Suanda zaten bir oylama var..")
    }
    return PLUGIN_HANDLED;
}
isimcek(id) {
    new isim[MAX_NAME_LENGTH];
    get_user_name(id, isim, charsmax(isim));
    return isim;
}

public Menus(id){
    new menu, Menuz[512]

    formatex(Menuz, charsmax(Menuz), "\y Rastgele Oyuncu Secimi" );

    menu = menu_create(Menuz, "MenuDevam")



    formatex(Menuz, charsmax(Menuz), "\w%s" ,isimcek(sansli[0]));
    menu_additem(menu, Menuz, "1")
    formatex(Menuz, charsmax(Menuz), "\w%s" ,isimcek(sansli[1]));
    menu_additem(menu, Menuz, "2")
    formatex(Menuz, charsmax(Menuz), "\w%s" ,isimcek(sansli[2]));
    menu_additem(menu, Menuz, "3")
    formatex(Menuz, charsmax(Menuz), "\w%s" ,isimcek(sansli[3]));
    menu_additem(menu, Menuz, "4")

    formatex(Menuz, charsmax(Menuz), "\wRastgele Sec");
    menu_additem(menu, Menuz, "5")

    menu_display(id, menu, 0)

    return PLUGIN_HANDLED
}
public MenuDevam(iId, menu, item)
{
    if(!OylamaZamani)
        return PLUGIN_HANDLED;

    if (item == MENU_EXIT)
    {
        menu_destroy(menu)

        return PLUGIN_HANDLED;
    }
    new data[6], iName[64]
    new access, callback
    menu_item_getinfo(menu, item, access, data,5, iName, 63, callback)

    new key = str_to_num(data)

    switch(key)
    {
        case 1:
        {
            secilenoyuncularoylari[0]++;
            client_print_color(0, sansli[0], "^3%s ^1Oyuncusuna^4 +1 ^1oy",isimcek(sansli[0]))
        }
        case 2:
        {
            secilenoyuncularoylari[1]++;
            client_print_color(0, sansli[1], "^3%s ^1Oyuncusuna^4 +1 ^1oy",isimcek(sansli[1]))
        }
        case 3:
        {
            secilenoyuncularoylari[2]++;
            client_print_color(0, sansli[2], "^3%s ^1Oyuncusuna^4 +1 ^1oy",isimcek(sansli[2]))
        }
        case 4:
        {
            secilenoyuncularoylari[3]++;
            client_print_color(0, sansli[3], "^3%s ^1Oyuncusuna^4 +1 ^1oy",isimcek(sansli[3]))
        }
        case 5:
        {
            new rastgeleoyuncu = random_num(0, 3)
            secilenoyuncularoylari[rastgeleoyuncu]++;
            client_print_color(0, sansli[rastgeleoyuncu], "^3%s ^1Oyuncusuna^4 +1 ^1oy (rastgele)",isimcek(sansli[rastgeleoyuncu]))
        }
    }
    return PLUGIN_HANDLED;

}

public oylamayibitir(){
    new enyuksekoyuncu[2]
    if(secilenoyuncularoylari[0] > secilenoyuncularoylari[1]){
        enyuksekoyuncu[0] = sansli[0];enyuksekoyuncu[1] = secilenoyuncularoylari[0];
    }
    else{
        enyuksekoyuncu[0] = sansli[1];enyuksekoyuncu[1] = secilenoyuncularoylari[1];
    }
    if(enyuksekoyuncu[1] < secilenoyuncularoylari[2]){
        enyuksekoyuncu[0] = sansli[2];enyuksekoyuncu[1] = secilenoyuncularoylari[2];
    }
    if(enyuksekoyuncu[1] < secilenoyuncularoylari[3]){
        enyuksekoyuncu[0] = sansli[3];enyuksekoyuncu[1] = secilenoyuncularoylari[3];
    }
    if(enyuksekoyuncu[0] == 0){
        client_print_color(0, enyuksekoyuncu[0], "^1Oylamadan kimse cikmadi..")
    }
    else{
        client_print_color(0, enyuksekoyuncu[0], "^1Oylamadan ^4%i ^1oy ile ^3%s ^1oyuncusu cikti.",enyuksekoyuncu[1],isimcek(enyuksekoyuncu[0]))
    }
    OylamaZamani=false;

    if(is_user_alive(enyuksekoyuncu[0])){
        user_kill(enyuksekoyuncu[0]);
    }
    cs_set_user_team(enyuksekoyuncu[0], CS_TEAM_T);
    client_print_color(0, enyuksekoyuncu[0], "^3%s ^1oyuncusu ^3TE ^1takimina gecti.",isimcek(enyuksekoyuncu[0]))
}

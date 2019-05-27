#include <amxmodx>
#include <reapi>

#define ChatTag "^3CSDuragi :"

new kisi_rate[33],kisi_updaterate[33],kisi_cmdrate[33],kisi_clrate[33];
new y_kisi_rate[33],y_kisi_updaterate[33],y_kisi_cmdrate[33],y_kisi_clrate[33];
new bozulma[33];
new bool:gecti[33]=false;
new bool:uygun[33]=false;

public plugin_init()
{
    register_plugin("Rate Kontrol","1.7","Yek'-ta");
    register_concmd("say .rate","RateAyarlamaMenu")
    register_concmd("say !rate","RateAyarlamaMenu")
    register_concmd("say /rate","RateAyarlamaMenu")
}
public ogren(id)
{
    if(is_user_connected(id) && is_user_steam(id)){
        query_client_cvar(id, "rate", "cvarfonksion");
        query_client_cvar(id, "cl_updaterate", "cvarfonksion");
        query_client_cvar(id, "cl_cmdrate", "cvarfonksion");
        query_client_cvar(id, "cl_rate", "cvarfonksion");
    }
    else if(is_user_connected(id) && !is_user_steam(id)){
        new non_rate[50],non_updaterate[50];
        get_user_info(id, "rate", non_rate, charsmax(non_rate));
        if(equal(non_rate,"25000")){
            bozulma[id]++;
        }
        get_user_info(id, "cl_updaterate", non_updaterate, charsmax(non_updaterate));
        if(equal(non_updaterate,"66")){
            bozulma[id]++;
        }
        if(!gecti[id]){
            kisi_rate[id] = str_to_num(non_rate)
        }
        y_kisi_rate[id] = str_to_num(non_rate)
        if(!gecti[id]){
            kisi_updaterate[id] = str_to_num(non_updaterate)
        }
        y_kisi_updaterate[id] = str_to_num(non_updaterate)
    }
}
public client_disconnected(id) {
    if(task_exists(id)) {
        remove_task(id);
    }
    bozulma[id]=0;
    gecti[id]=false;
    uygun[id]=false;
    return PLUGIN_CONTINUE;
}
public client_putinserver(id) {
    if(!is_user_bot(id) && is_user_connected(id)){
        gecti[id]=false;
        uygun[id]=false;
        bozulma[id]=0;
        set_task(11.0,"ogren",id);
        set_task(25.0,"sorgula",id);
    }
    return PLUGIN_CONTINUE;
}
public sorgula(id){
    if(is_user_connected(id)){
        gecti[id]=true;
        if(bozulma[id] >= 2){
            client_print_color(id,id,"%s ^3Rate ayarlariniz bozulmus..",ChatTag);
            RateAyarlamaMenu(id)
            uygun[id]=false;
        }
        else{
            uygun[id]=true;
        }
        client_print_color(id,id,"%s ^1Hazir Rate ayarlarini denemek isterseniz ^3/rate ^1yaziniz.",ChatTag);
    }
}
public cvarfonksion(id, const cvar[], const deger[])
{

    if(equali(cvar,"rate"))
    {
        if(str_to_num(deger) == 25000){
            bozulma[id]++;
        }
        if(!gecti[id]){
            kisi_rate[id] = str_to_num(deger)
        }
        y_kisi_rate[id] = str_to_num(deger)
    }
    if(equali(cvar,"cl_updaterate"))
    {
        if(str_to_num(deger) == 66){
            bozulma[id]++;
        }
        if(!gecti[id]){
            kisi_updaterate[id] = str_to_num(deger)
        }
        y_kisi_updaterate[id] = str_to_num(deger)
    }
    if(equali(cvar,"cl_cmdrate"))
    {
        if(str_to_num(deger) == 66){
            bozulma[id]++;
        }
        if(!gecti[id]){
            kisi_cmdrate[id] = str_to_num(deger)
        }
        y_kisi_cmdrate[id] = str_to_num(deger)
    }
    if(equali(cvar,"cl_rate"))
    {
        if(!gecti[id]){
            kisi_clrate[id] = str_to_num(deger)
        }
        y_kisi_clrate[id] = str_to_num(deger)
    }
}


public RateAyarlamaMenu(id){
    if(!gecti[id]){
        return PLUGIN_HANDLED
    }
    new menu, Menuz[512]

    if(is_user_steam(id)){
        formatex(Menuz, charsmax(Menuz), "\y [ \rRate Ayarlama \y]^n\wSuanki Rate Ayarlariniz;^nrate %d^ncl_cmdrate %d^ncl_updaterate %d",y_kisi_rate[id],y_kisi_cmdrate[id],y_kisi_updaterate[id] );
    }
    else {
        if(!uygun[id]){
            formatex(Menuz, charsmax(Menuz), "\rRATE AYARLARINIZ BOZULMUS");
        }
        formatex(Menuz, charsmax(Menuz), "\y [ \rRate Ayarlama \y]^n\wSuanki Rate Ayarlariniz;^nrate %d^ncl_updaterate %d^n",y_kisi_rate[id],y_kisi_updaterate[id] );
    }

    menu = menu_create(Menuz, "h_RateAyarlamaMenu")

    formatex(Menuz, charsmax(Menuz), "\w112k \d[6000, 20, 15]" );
    menu_additem(menu, Menuz, "2")

    formatex(Menuz, charsmax(Menuz), "\w256k \d[9000, 25, 20]" );
    menu_additem(menu, Menuz, "3")

    formatex(Menuz, charsmax(Menuz), "\w384k \d[15000, 30, 25]" );
    menu_additem(menu, Menuz, "4")

    formatex(Menuz, charsmax(Menuz), "\w512k \d[17000, 35, 30]" );
    menu_additem(menu, Menuz, "5")

    formatex(Menuz, charsmax(Menuz), "\w768k \d[20000, 40, 35]" );
    menu_additem(menu, Menuz, "6")

    formatex(Menuz, charsmax(Menuz), "\w1MB+ \d[23000, 45, 40]" );
    menu_additem(menu, Menuz, "7")

    formatex(Menuz, charsmax(Menuz), "\wMax. \d[25000, 101, 101]" );
    menu_additem(menu, Menuz, "1")

    if(is_user_steam(id)){
        formatex(Menuz, charsmax(Menuz), "\wSizin Ayarlariniz \d[%d, %d, %d]^n^n",kisi_rate[id], kisi_cmdrate[id],kisi_updaterate[id] );
        menu_additem(menu, Menuz, "8")
    }
    else{
        formatex(Menuz, charsmax(Menuz), "\dGiris yaptiginiz ayarlar \d[%d, %d]^n^n",kisi_rate[id],kisi_updaterate[id] );
        menu_additem(menu, Menuz, "8")
    }

    formatex(Menuz, charsmax(Menuz), "\wMenuyu Kapat");
    menu_additem(menu, Menuz, "9")

    menu_setprop(menu, MPROP_PERPAGE, 0);

    menu_display(id, menu)

    return PLUGIN_HANDLED
}

public h_RateAyarlamaMenu(id, menu, item)
{
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
            client_cmd(id,"rate 25000")
            client_cmd(id,"cl_cmdrate 101")
            client_cmd(id,"cl_updaterate 101")
            client_cmd(id,"cl_rate 9999")
            client_cmd(id,"cl_cmdbackup 2")
            set_task(0.7,"ogren",id)
            set_task(1.5,"RateAyarlamaMenu",id)
            uygun[id]=true;
            client_print_color(id,id,"%s ^1En iyi aldiginiz pingte birakiniz.",ChatTag);
        }

        case 2:
        {
            client_cmd(id,"rate 6000")
            client_cmd(id,"cl_cmdrate 20")
            client_cmd(id,"cl_updaterate 15")
            client_cmd(id,"cl_rate 9999")
            client_cmd(id,"cl_cmdbackup 2")
            set_task(0.7,"ogren",id)
            set_task(1.5,"RateAyarlamaMenu",id)
            uygun[id]=true;
            client_print_color(id,id,"%s ^1En iyi aldiginiz pingte birakiniz.",ChatTag);
        }

        case 3:
        {
            client_cmd(id,"rate 9000")
            client_cmd(id,"cl_cmdrate 25")
            client_cmd(id,"cl_updaterate 20")
            client_cmd(id,"cl_rate 9999")
            client_cmd(id,"cl_cmdbackup 2")
            set_task(0.7,"ogren",id)
            set_task(1.5,"RateAyarlamaMenu",id)
            uygun[id]=true;
            client_print_color(id,id,"%s ^1En iyi aldiginiz pingte birakiniz.",ChatTag);
        }

        case 4:
        {
            client_cmd(id,"rate 15000")
            client_cmd(id,"cl_cmdrate 30")
            client_cmd(id,"cl_updaterate 25")
            client_cmd(id,"cl_rate 15000")
            client_cmd(id,"cl_cmdbackup 2")
            set_task(0.7,"ogren",id)
            set_task(1.5,"RateAyarlamaMenu",id)
            uygun[id]=true;
            client_print_color(id,id,"%s ^1En iyi aldiginiz pingte birakiniz.",ChatTag);
        }

        case 5:
        {
            client_cmd(id,"rate 17000")
            client_cmd(id,"cl_cmdrate 35")
            client_cmd(id,"cl_updaterate 30")
            client_cmd(id,"cl_rate 17000")
            client_cmd(id,"cl_cmdbackup 2")
            set_task(0.7,"ogren",id)
            set_task(1.5,"RateAyarlamaMenu",id)
            uygun[id]=true;
            client_print_color(id,id,"%s ^1En iyi aldiginiz pingte birakiniz.",ChatTag);
        }

        case 6:
        {
            client_cmd(id,"rate 20000")
            client_cmd(id,"cl_cmdrate 40")
            client_cmd(id,"cl_updaterate 35")
            client_cmd(id,"cl_rate 20000")
            client_cmd(id,"cl_cmdbackup 2")
            set_task(0.7,"ogren",id)
            set_task(1.5,"RateAyarlamaMenu",id)
            uygun[id]=true;
            client_print_color(id,id,"%s ^1En iyi aldiginiz pingte birakiniz.",ChatTag);
        }

        case 7:
        {
            client_cmd(id,"rate 23000")
            client_cmd(id,"cl_cmdrate 45")
            client_cmd(id,"cl_updaterate 40")
            client_cmd(id,"cl_rate 23000")
            client_cmd(id,"cl_cmdbackup 2")
            set_task(0.7,"ogren",id)
            set_task(1.5,"RateAyarlamaMenu",id)
            uygun[id]=true;
            client_print_color(id,id,"%s ^1En iyi aldiginiz pingte birakiniz.",ChatTag);
        }

        case 8:
        {
            if(is_user_steam(id)){
                client_cmd(id,"rate ^"%d^"",kisi_rate[id])
                client_cmd(id,"cl_cmdrate ^"%d^"",kisi_cmdrate[id])
                client_cmd(id,"cl_updaterate ^"%d^"",kisi_updaterate[id] )
                client_cmd(id,"cl_rate ^"%d^"",kisi_clrate[id] )
                client_cmd(id,"cl_cmdbackup 2")
                set_task(0.7,"ogren",id)
                set_task(1.5,"RateAyarlamaMenu",id)
            }
            else{
                RateAyarlamaMenu(id)
            }
        }

        case 9:
        {
            client_print_color(id,id,"%s ^1Rate menusu kapatildi. Ayarlardan memnun kalmaz iseniz /rate ile tekrar ayarlayabilirsiniz.",ChatTag);
        }

    }


    return PLUGIN_HANDLED;
}

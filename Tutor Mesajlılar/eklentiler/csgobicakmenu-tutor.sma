#include <amxmodx>
#include <amxmisc>
#include <fakemeta>

#define PLUGIN "CSGO BICAKMENU"
#define VERSION "1.0"
#define AUTHOR "-"

#define MesajTipi1 0
#define UyariMesajiKirmizi 1
#define UyariMesajiMavi 2
#define MesajTipi2 5 //Zafer Sesli


new const Knife1Model[66] = "models/bicakmenu/csgo_falchion.mdl";
new const Knife2Model[66] = "models/bicakmenu/csgo_bayonet.mdl";
new const Knife3Model[66] = "models/bicakmenu/csgo_butterfly.mdl";
new const Knife4Model[66] = "models/bicakmenu/csgo_flip.mdl";
new const Knife5Model[66] = "models/bicakmenu/csgo_karambit.mdl";
new const Knife6Model[66] = "models/bicakmenu/csgo_gut.mdl";
new const Knife7Model[66] = "models/bicakmenu/csgo_m9bayonet.mdl";

new Knife[33];


public plugin_init() {
    register_plugin(PLUGIN, VERSION, AUTHOR)
    register_clcmd("say /bicakmenu","Menu")
    register_event("CurWeapon", "CurentWeapon", "be", "1=1");
}

public Menu(id) {
    new menu = menu_create("\d[\rCS:GO KnifeMenu\d]", "menu_handler")

    menu_additem(menu, "\rFalchion Knife", "1", 0);
    menu_additem(menu, "\rBayonet Knife", "2");
    menu_additem(menu, "\rButterfly Knife", "3", 0);
    menu_additem(menu, "\rFlip Knife", "4", 0);
    menu_additem(menu, "\rKarambit Knife", "5", 0);
    menu_additem(menu, "\rGut Knife", "6", 0);
    menu_additem(menu, "\rM9 Bayonet Knife", "7", 0);

    menu_setprop(menu,MPROP_NEXTNAME,"\yIleri")
    menu_setprop(menu,MPROP_BACKNAME,"\yGeri")
    menu_setprop(menu,MPROP_EXITNAME,"\yCIKIS");
    menu_setprop(menu, MPROP_EXIT, MEXIT_ALL);
    menu_display(id, menu, 0);
    return PLUGIN_CONTINUE
}
public menu_handler(id, menu, item)
{

    if( item == MENU_EXIT )
    {
        menu_destroy(menu);
        return PLUGIN_HANDLED;
    }

    new data[6], iName[64];
    new access, callback;
    menu_item_getinfo(menu, item, access, data,5, iName, 63, callback);
    new key = str_to_num(data);
    new adminismi[32]
    get_user_name(id,adminismi,31)

    switch(key)
    {
        case 1: {
            Knife[id] = 1;
            CurentWeapon(id);
           // Falchion
            tutor_mesaj_olustur(id,"Falchion Bicagini Aldiniz",MesajTipi1,true,5);
        }
        case 2: {
            Knife[id] = 2;
            CurentWeapon(id);
          //  Bayonet
            tutor_mesaj_olustur(id,"Bayonet Bicagini Aldiniz",MesajTipi2,true,5);
        }
        case 3: {
            Knife[id] = 3;
            CurentWeapon(id);
          // Butterfly
            tutor_mesaj_olustur(id,"Butterfly Bicagini Aldiniz",UyariMesajiKirmizi,true,5);
        }
        case 4: {
            Knife[id] = 4;
            CurentWeapon(id);
           // Flip
            tutor_mesaj_olustur(id,"Flip Bicagini Aldiniz",UyariMesajiMavi,true,5);
        }
        case 5: {
            Knife[id] = 5;
            CurentWeapon(id);
           //Karambit
            tutor_mesaj_olustur(id,"Karambit Bicagini Aldiniz",MesajTipi1,true,5);
        }
        case 6: {
            Knife[id] = 6;
            CurentWeapon(id);
          // Gut
            tutor_mesaj_olustur(id,"Gut Bicagini Aldiniz",MesajTipi1,true,5);
        }
        case 7: {
            Knife[id] = 7;
            CurentWeapon(id);
           // M9 Bayonet
            tutor_mesaj_olustur(id,"M9 Bayonet Bicagini Aldiniz",MesajTipi1,true,5);
        }
    }

    menu_destroy(menu);
    return PLUGIN_HANDLED;
}
public plugin_precache()
{
    precache_model(Knife1Model);
    precache_model(Knife2Model);
    precache_model(Knife3Model);
    precache_model(Knife4Model);
    precache_model(Knife5Model);
    precache_model(Knife6Model);
    precache_model(Knife7Model);

    precache_sound( "events/enemy_died.wav" );
    precache_sound( "events/friend_died.wav" );
    precache_sound( "events/task_complete.wav" );
    precache_sound( "events/tutor_msg.wav" );

    precache_generic( "resource/TutorScheme.res" );
    precache_generic( "resource/UI/TutorTextWindow.res" );

    precache_generic( "gfx/career/icon_!.tga" );
    precache_generic( "gfx/career/icon_!-bigger.tga" );
    precache_generic( "gfx/career/icon_i.tga" );
    precache_generic( "gfx/career/icon_i-bigger.tga" );
    precache_generic( "gfx/career/icon_skulls.tga" );
    precache_generic( "gfx/career/round_corner_ne.tga" );
    precache_generic( "gfx/career/round_corner_nw.tga" );
    precache_generic( "gfx/career/round_corner_se.tga" );
    precache_generic( "gfx/career/round_corner_sw.tga" );
}
public client_putinserver(id)
{
    Knife[id] = 0;
}
public client_disconnected(id){
    Knife[id] = 0;
}
public CurentWeapon(id) {
    if(get_user_weapon(id) == CSW_KNIFE) {

        if(Knife[id] == 1)
            set_pev(id, pev_viewmodel2, Knife1Model);

        else if(Knife[id] == 2)
            set_pev(id, pev_viewmodel2, Knife2Model);

        else if(Knife[id] == 3)
            set_pev(id, pev_viewmodel2, Knife3Model);

        else if(Knife[id] == 4)
            set_pev(id, pev_viewmodel2, Knife4Model);

        else if(Knife[id] == 5)
            set_pev(id, pev_viewmodel2, Knife5Model);

        else if(Knife[id] == 6)
            set_pev(id, pev_viewmodel2, Knife6Model);

        else if(Knife[id] == 7)
            set_pev(id, pev_viewmodel2, Knife7Model);

    }
}


stock tutor_mesaj_olustur(id, mesaj[], stil, bool:ses, sure){

    if (ses){
        switch(stil){
            case 1: emit_sound(id, CHAN_ITEM, "events/friend_died.wav", VOL_NORM, ATTN_NORM, 0, PITCH_HIGH)
            case 2: emit_sound(id, CHAN_ITEM, "events/enemy_died.wav", VOL_NORM, ATTN_NORM, 0, PITCH_LOW)
            case 5: emit_sound(id, CHAN_ITEM, "events/task_complete.wav", VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
            default: emit_sound(id, CHAN_ITEM, "events/tutor_msg.wav", VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
        }
    }

    message_begin(MSG_ONE_UNRELIABLE , get_user_msgid("TutorClose"), {0, 0, 0}, id)
    message_end()

    message_begin(MSG_ONE_UNRELIABLE , get_user_msgid("TutorText"), {0, 0, 0}, id)
    write_string(mesaj)
    write_byte(0)
    write_short(0)
    write_short(0)
    write_short(1<<stil)
    message_end()

    remove_task(id)
    set_task(sure+0.0, "tutorkaldir", id)

}

public tutorkaldir(id){
    if( is_user_connected( id ) ) {
        message_begin(MSG_ONE_UNRELIABLE , get_user_msgid("TutorClose"), {0, 0, 0}, id)
        message_end()
    }
}

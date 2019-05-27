#include <amxmodx>
#include <amxmisc>
#include <fakemeta>

#define PLUGIN "CSGO BICAKMENU"
#define VERSION "1.0"
#define AUTHOR "-"

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
        }
        case 2: {
            Knife[id] = 2;
            CurentWeapon(id);
          //  Bayonet
        }
        case 3: {
            Knife[id] = 3;
            CurentWeapon(id);
          // Butterfly
        }
        case 4: {
            Knife[id] = 4;
            CurentWeapon(id);
           // Flip
        }
        case 5: {
            Knife[id] = 5;
            CurentWeapon(id);
           //Karambit
        }
        case 6: {
            Knife[id] = 6;
            CurentWeapon(id);
          // Gut
        }
        case 7: {
            Knife[id] = 7;
            CurentWeapon(id);
           // M9 Bayonet
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

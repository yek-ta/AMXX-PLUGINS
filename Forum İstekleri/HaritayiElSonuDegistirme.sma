/* Yek'-ta

    https://forum.csduragi.com/eklenti-istekleri/nextmap-amxx-t36477.html
*/

#include <amxmodx>

#define PLUGIN  "ElSonuHarita"
#define VERSION "1.0"
#define AUTHOR  "Yek'-ta" //forum.csduragi.com

new bool:SonEl
new smap[32]
public plugin_init()
{
    register_plugin(PLUGIN, VERSION, AUTHOR)

    set_task(10.0, "Son10Saniye", _, _, _, "d")
    SonEl = false;
    register_logevent("RoundEnd", 2, "1=Round_End")
}

public Son10Saniye(){
    server_cmd("mp_timelimit 0")
    get_cvar_string("amx_nextmap", smap, charsmax(smap))
    SonEl = true;
    set_dhudmessage( 149,68,0, -1.0, -0.70, 2, 4.0, 11.0, 0.01, 1.5 )
    show_dhudmessage(0, "Sonraki Harita: %s^nHarita el sonunda degisecek",smap)
}

public RoundEnd()
    if(SonEl)
        set_task(1.0, "changelevel");

public changelevel()
{
    set_dhudmessage( 0,255,0, -1.0, -0.40, 0, 11.0, 6.0, 0.1, 1.5 )
    show_dhudmessage(0, "^nHarita %s olarak degistiriliyor", smap)

    set_task(1.5, "changelevel1");
    set_task(4.0, "changelevel2");
}

public changelevel1()
{
    new _modName[10]
    get_modname(_modName, 9)
    if (!equal(_modName, "zp"))
    {
        message_begin(MSG_ALL, SVC_INTERMISSION)
        message_end()
    }
}
public changelevel2()
{
    server_cmd("changelevel %s", smap);
}

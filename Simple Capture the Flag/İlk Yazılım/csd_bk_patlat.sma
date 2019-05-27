#include <amxmodx>
#include <reapi>
#include <fakemeta>
#include <xs>
#include <engine>
#include <fun>
#include <cstrike>
#include <csd_bayrakkapmaca>

new g_SprFlame
new Float:origin[3], Float:exporigin[3];
new isim[32];
new MsgScreenShake
public plugin_init()
{
    register_plugin("Alan Patlatici", "1.0", "Yek'-ta")

    register_clcmd("say patlat","tetikle")
    MsgScreenShake = get_user_msgid("ScreenShake");
}
public plugin_precache(){
    g_SprFlame = precache_model("sprites/fexplo1.spr");
    precache_sound("csd_bayrakkapmaca/csd_alanpatlama.wav")
}
public tetikle(oyuncu){
    if(cs_get_user_money(oyuncu) >= 10000){
        new test[32]
        new deger = get_user_team(oyuncu) == 1 ? csd_obje_ctalan() : csd_obje_tealan()

        get_entvar(get_user_team(oyuncu) == 1 ? csd_obje_ctalan() : csd_obje_tealan(), var_globalname, test, charsmax(test))


        entity_get_vector(deger, EV_VEC_origin, origin);
        xs_vec_copy(origin, exporigin);
        set_task(0.5,"patlat");
        emit_sound(deger, CHAN_WEAPON, "csd_bayrakkapmaca/csd_alanpatlama.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
        client_print_color(0, get_user_team(oyuncu) == 1 ? print_team_blue : print_team_red, "^4%s ^3%sni ^1Patlatti.",isimogren(oyuncu), test)
        cs_set_user_money(oyuncu,cs_get_user_money(oyuncu)-10000)
    }
    else{
        client_print_color(oyuncu, oyuncu, "^4Yeterli Paran Yok, minimum 10000 dolarin olmasi lazim.")
    }
    return PLUGIN_HANDLED;
}
public patlat(){

    engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, origin, 0);
    write_byte(TE_EXPLOSION);
    engfunc(EngFunc_WriteCoord, exporigin[0]);
    engfunc(EngFunc_WriteCoord, exporigin[1]);
    engfunc(EngFunc_WriteCoord, exporigin[2]);
    write_short(g_SprFlame);
    write_byte(80);
    write_byte(9);
    write_byte(TE_EXPLFLAG_NOSOUND);
    message_end();

    new victim = -1;
    while ((victim = find_ent_in_sphere(victim, exporigin, 150.0)) > 0)
    {
        if(is_user_connected(victim) && is_user_alive(victim)){
            user_kill(victim)
        }
    }

    new Dura = UTIL_FixedUnsigned16(4.0, 1 << 12)
    new Freq = UTIL_FixedUnsigned16(0.7 , 1 << 8)
    new Ampl = UTIL_FixedUnsigned16(20.0, 1 << 12)

    while ((victim = find_ent_in_sphere(victim, exporigin, 300.0)) > 0)
    {
        if(is_user_connected(victim) && is_user_alive(victim)){
            message_begin(MSG_ONE , MsgScreenShake , {0,0,0} ,victim)
            write_short( Ampl ) // --| Shake amount.
            write_short( Dura ) // --| Shake lasts this long.
            write_short( Freq ) // --| Shake noise frequency.
            message_end ()
            set_user_health(victim, get_user_health(victim)-random_num(20, 50))
        }
    }
}
public isimogren(oyuncu){
    get_user_name(oyuncu, isim, 31)
    return isim;
}
UTIL_FixedUnsigned16 ( const Float:Value, const Scale ) {
    return clamp( floatround( Value * Scale ), 0, 0xFFFF );
}

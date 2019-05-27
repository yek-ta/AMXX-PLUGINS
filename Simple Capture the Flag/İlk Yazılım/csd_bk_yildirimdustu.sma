#include <amxmodx>
#include <xs>
#include <reapi>
#include <csd_bayrakkapmaca>
#include <engine>
#include <fakemeta>

new g_iLightingSpr;
enum _:XYZ { Float:X, Float:Y, Float:Z }

new const SOUND__THUNDERCLAP[] = "ambience/thunder_clap.wav"
new g_MsgScreenFade
public plugin_init() {
    register_plugin("test", "1.0", "Yek'-ta")
    register_clcmd("say test","test")
    g_MsgScreenFade = get_user_msgid("ScreenFade")
}

public plugin_precache(){

    g_iLightingSpr = precache_model("sprites/lgtning.spr")
    precache_sound(SOUND__THUNDERCLAP)
}
public test(id){

    if( get_entvar(csd_obje_tebayrak(), var_flags) & FL_ONGROUND && is_user_outside(csd_obje_tebayrak()) )
    {
        new Float:fStart[XYZ], Float:fEnd[XYZ]
        new Float:origin[3], Float:exporigin[3];

        get_entvar(csd_obje_tebayrak(), var_origin, fStart)
        xs_vec_copy(fStart, fEnd)
        fStart[Z] += 300.0
        func_MakeThunder(fStart, fEnd)
        rh_emit_sound2(csd_obje_tebayrak(), 0, CHAN_ITEM, SOUND__THUNDERCLAP)

        entity_get_vector(csd_obje_tealan(), EV_VEC_origin, origin);
        xs_vec_copy(origin, exporigin);
        new victim = -1;
        while ((victim = find_ent_in_sphere(victim, exporigin, 150.0)) > 0)
        {
            if(is_user_connected(victim) && is_user_alive(victim)){
                message_begin(MSG_ONE_UNRELIABLE, g_MsgScreenFade, .player = id)
                write_short(1<<10); write_short(1<<11); write_short(0x0000)
                write_byte(255); write_byte(255); write_byte(255)
                write_byte(75); message_end()
            }
        }
        if(csd_ctbayrak_tasiyici() == id){
            user_kill(id)
        }
    }
    else{
        client_print_color(id,id,"Bayrak Disarida Degil.")
    }


}

stock func_MakeThunder(Float:fStart[XYZ], Float:fEnd[XYZ]) {
    message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
    write_byte(TE_BEAMPOINTS)
    write_coord_f(fStart[X])
    write_coord_f(fStart[Y])
    write_coord_f(fStart[Z])
    write_coord_f(fEnd[X])
    write_coord_f(fEnd[Y])
    write_coord_f(fEnd[Z])
    write_short(g_iLightingSpr)
    write_byte(1) // starting frame
    write_byte(5) // frame rate in 0.1's
    write_byte(2) // life in 0.1's
    write_byte(60) // line width in 0.1's
    write_byte(30) // noise amplitude in 0.01's
    write_byte(200) // red
    write_byte(200) // green
    write_byte(200) // blue
    write_byte(200) // brightness
    write_byte(200) // scroll speed in 0.1's
    message_end()
}
stock Float:is_user_outside(id)
{
    new Float:vOrigin[3], Float:fDist;
    get_entvar(id, var_origin, vOrigin)

    fDist = vOrigin[2];

    while(engfunc(EngFunc_PointContents, vOrigin) == CONTENTS_EMPTY)
        vOrigin[2] += 5.0;

    if(engfunc(EngFunc_PointContents, vOrigin) == CONTENTS_SKY)
        return (vOrigin[2] - fDist);

    return 0.0;
}

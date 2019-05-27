#include <amxmodx>
#include <xs>
#include <reapi>
#include <simple_ctf>
#include <engine>
#include <fakemeta>

#define LAUNCH_SOUND "launch_rockets.wav"
new modeldosyasi
new BKMODEL[64]
new Float:originf[3]
new spr_explode
new modelsecimi
new bool:ucakgonderildi
public plugin_init() {
    register_plugin("Bayrak Tasiyicisina Hava Saldirisi", "1.0", "Yek'-ta")
    register_clcmd("say havasaldirisi","test")
}

public plugin_precache(){

    precache_sound(LAUNCH_SOUND)
    formatex(BKMODEL,charsmax(BKMODEL),"models/csd_bk/ucaklar.mdl");
    modeldosyasi = precache_model(BKMODEL)
    spr_explode = precache_model("sprites/fexplo.spr")

}
public test(id){
    if(!ucakgonderildi){
        new hangibayrak = get_user_team(id) == 1 ? sctf_ent_CTFlag() : sctf_ent_TEFlag()
        new kimpatlayacak = get_user_team(id) == 1 ? sctf_who_TEflagger() : sctf_who_CTflagger()
        modelsecimi = get_user_team(id) == 1 ? 0 : 1
        if(kimpatlayacak != -1 && kimpatlayacak != 0){
            if( get_entvar(hangibayrak, var_flags) & FL_ONGROUND && is_user_outside(hangibayrak) )
            {

                emit_sound(kimpatlayacak, CHAN_VOICE, LAUNCH_SOUND, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)

                get_entvar(kimpatlayacak, var_origin, originf);

                testttt(kimpatlayacak);
                set_task(0.6,"patlat",kimpatlayacak);
                set_task(8.0,"sifirla")
                ucakgonderildi=true;
            }
            else{
                client_print_color(id,id,"Bayrak Acik Alanda Degil.")
            }
        }
        else{
            client_print_color(id,id,"Bayrak Tasiyicisi Yok.")
        }
    }
    else{
        client_print_color(id,id,"10 Saniye sonra tekrar deneyiniz.")
    }
}
public sifirla(){
    ucakgonderildi=false;
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
public testttt(oyuncu){


    new objeefekti = rg_create_entity("info_target")

    entity_set_string(objeefekti,EV_SZ_classname, "ucak")
    set_entvar(objeefekti, var_model, BKMODEL);
    set_entvar(objeefekti, var_modelindex, modeldosyasi);
    entity_set_origin(objeefekti, originf)
    set_entvar(objeefekti, var_body, modelsecimi)
    Set_Entity_Anim(objeefekti, 1, 0)
    set_task(6.0,"bitir")

}
public bitir(){
    remove_entity_name("ucak")
}
stock Set_Entity_Anim(ent, Anim, ResetFrame)
{
    if(!is_entity(ent))
        return

    set_entvar(ent, var_animtime, get_gametime())
    set_entvar(ent, var_framerate, 1.0)
    set_entvar(ent, var_sequence, Anim)
    if(ResetFrame) set_entvar(ent, var_frame, 0.0)
}


public patlat(kimpatlayacak)
{

    new vec1[3];
    vec1[0] = floatround(originf[0]);
    vec1[1] = floatround(originf[1]);
    vec1[2] = floatround(originf[2]);


    message_begin( MSG_BROADCAST,SVC_TEMPENTITY,vec1)
    write_byte( 3 )
    write_coord(vec1[0])
    write_coord(vec1[1])
    write_coord(vec1[2] + 20)
    write_short( spr_explode )
    write_byte( 50 )
    write_byte( 10 )
    write_byte( 0 )
    message_end()

    if(is_user_alive(kimpatlayacak)){
        user_silentkill(kimpatlayacak)
    }
    xs_vec_copy(originf, originf);
    new victim = -1;
    while ((victim = find_ent_in_sphere(victim, originf, 150.0)) > 0)
    {
        if(is_user_connected(victim) && is_user_alive(victim)){
            user_kill(victim)
        }
    }
}

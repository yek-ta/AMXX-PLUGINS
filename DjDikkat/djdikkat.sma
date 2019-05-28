#include <amxmodx>
#include <reapi>
#include <engine>

enum _:TEKLIDEGISKENLER
{
    yaratik,
    modeldosyasi
}
new BKMODEL[64]
new degiskenler[TEKLIDEGISKENLER]
#define KONUSTURMA_TASK 1907
public plugin_init()
{
    register_plugin("DJ Dikkat nesne", "1.0", "Yek'-ta")
    register_clcmd("say olustur", "test")
}

public plugin_precache() {
    formatex(BKMODEL,charsmax(BKMODEL),"models/gaminga.mdl");

    degiskenler[modeldosyasi] = precache_model(BKMODEL)
    precache_sound("keslan.wav")
}

public test(oyuncu){
    degiskenler[yaratik]  = rg_create_entity("info_target")

    entity_set_string(degiskenler[yaratik],EV_SZ_classname, "test")
    set_entvar(degiskenler[yaratik], var_model, BKMODEL);
    set_entvar(degiskenler[yaratik], var_modelindex, degiskenler[modeldosyasi]);
    set_entvar(degiskenler[yaratik], var_angles, Float:{360.0, 0.0, 0.0});
    entity_set_origin(degiskenler[yaratik], Float:{-128.0, 1187.0, 36.0})
    entity_set_int(degiskenler[yaratik],EV_INT_movetype,6)
    entity_set_int(degiskenler[yaratik],EV_INT_solid,SOLID_SLIDEBOX)
    set_entvar(degiskenler[yaratik], var_gravity, 0.5)
    entity_set_size(degiskenler[yaratik],Float:{-20.0,-25.0,-5.0},Float:{10.0,10.0,200.0})
    set_task(5.0,"konustur")

}
public konustur(){

    set_task(0.5,"konustur1",KONUSTURMA_TASK)
    emit_sound(degiskenler[yaratik], CHAN_WEAPON, "keslan.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
}
public konustur1(){
    Set_Entity_Anim(degiskenler[yaratik], 4,0);
    set_task(0.5,"konustur2",KONUSTURMA_TASK)
}
public konustur2(){
    Set_Entity_Anim(degiskenler[yaratik], 0,0);
    set_task(0.3,"konustur3",KONUSTURMA_TASK)
}
public konustur3(){
    Set_Entity_Anim(degiskenler[yaratik], 4,0);
    set_task(1.0,"konustur4",KONUSTURMA_TASK)
}
public konustur4(){
    Set_Entity_Anim(degiskenler[yaratik], 0,0);
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

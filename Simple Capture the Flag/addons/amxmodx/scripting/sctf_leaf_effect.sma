
#include <amxmodx>
#include <reapi>
#include <engine>
#include <simple_ctf>

new modelfile
new BKMODEL[64]

public plugin_init()
{
    register_plugin("SCTF Leaf Effect", "1.0", "Yek'-ta")
}

public plugin_precache() {
    formatex(BKMODEL,charsmax(BKMODEL),"models/simple_ctf/sctf_leafef.mdl");
    modelfile = precache_model(BKMODEL)
    precache_sound("simple_ctf/fireworks.wav")
}

public sctf_flag_scored(player,ent){
    new Float:originf[3]
    get_entvar(ent, var_origin, originf);

    new objeefekti = rg_create_entity("info_target")

    entity_set_string(objeefekti,EV_SZ_classname, "objeicinefekt")
    set_entvar(objeefekti, var_model, BKMODEL);
    set_entvar(objeefekti, var_modelindex, modelfile);
    entity_set_origin(objeefekti, originf)
    if(get_user_team(player) == 1){
        set_entvar(objeefekti, var_skin, 2)
    }
    else {
        set_entvar(objeefekti, var_skin, 3)
    }
    Set_Entity_Anim(objeefekti, 0, 0)
    emit_sound(ent, CHAN_WEAPON, "simple_ctf/fireworks.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
    set_task(7.0,"removemdl");
}
public removemdl(){
    remove_entity_name("objeicinefekt")
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

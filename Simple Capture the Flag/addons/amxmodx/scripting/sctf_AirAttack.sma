#include <amxmodx>
#include <xs>
#include <reapi>
#include <simple_ctf>
#include <engine>
#include <fakemeta>

#define LAUNCH_SOUND "launch_rockets.wav"
new modelfile
new BKMODEL[64]
new Float:originf[3]
new spr_explode
new choosemodelbody
new bool:sendedairattack
new howmuch
public plugin_init() {
    register_plugin("SCTF Buy AirAttack", "1.0", "Yek'-ta")
    howmuch = register_cvar("sctf_airattack_money","12000")
    register_clcmd("say /buy_airattack","buy_airattack")
    register_clcmd("say !buy_airattack","buy_airattack")
    register_clcmd("say .buy_airattack","buy_airattack")
}

public plugin_precache(){

    precache_sound(LAUNCH_SOUND)
    formatex(BKMODEL,charsmax(BKMODEL),"models/simple_ctf/sctf_airattack.mdl");
    modelfile = precache_model(BKMODEL)
    spr_explode = precache_model("sprites/fexplo.spr")

}
public buy_airattack(id){
    if(get_member(id, m_iAccount) >= get_pcvar_num(howmuch)) {
        if(!sendedairattack){
            new i_flag = get_user_team(id) == 1 ? sctf_ent_TEFlag() : sctf_ent_CTFlag()
            new i_who = get_user_team(id) == 1 ? sctf_who_CTflagger() : sctf_who_TEflagger()
            choosemodelbody = get_user_team(id) == 1 ? 0 : 1
            if(i_who != -1 && i_who != 0){
                if( get_entvar(i_flag, var_flags) & FL_ONGROUND && is_user_outside(i_flag) )
                {

                    emit_sound(i_who, CHAN_VOICE, LAUNCH_SOUND, VOL_NORM, ATTN_NORM, 0, PITCH_NORM)

                    get_entvar(i_who, var_origin, originf);

                    airplane_model();
                    set_task(0.6,"willexplode",i_who);
                    set_task(8.0,"tensec")
                    sendedairattack=true;
                    rg_add_account(id, get_member(id, m_iAccount) - get_pcvar_num(howmuch), AS_SET);
                    new name[32];
                    get_user_name(id,name,charsmax(name));
                    client_print_color(id,id,"^3%s ^1bought ^4AirAttack^1!!",name)
                }
                else{
                    client_print_color(id,id,"Flagger is not at outside")
                }
            }
            else{
                client_print_color(id,id,"There is no Flagger")
            }
        }
        else{
            client_print_color(id,id,"There is no airplane now, please try in 10 sec.")
        }
    }
    else{
        client_print_color(id,print_team_red,"^3You have no money enough. ^1AirAttack is ^4$%d",get_pcvar_num(howmuch));
    }
}
public tensec(){
    sendedairattack=false;
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
public airplane_model(){


    new ent = rg_create_entity("info_target")

    entity_set_string(ent,EV_SZ_classname, "ucak")
    set_entvar(ent, var_model, BKMODEL);
    set_entvar(ent, var_modelindex, modelfile);
    entity_set_origin(ent, originf)
    set_entvar(ent, var_body, choosemodelbody)
    Set_Entity_Anim(ent, 1, 0)
    set_task(6.0,"removeair")

}
public removeair(){
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


public willexplode(i_who)
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

    if(is_user_alive(i_who)){
        user_silentkill(i_who)
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

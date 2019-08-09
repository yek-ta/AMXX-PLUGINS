#include <amxmodx>
#include <engine>
#include <fakemeta>
#include <simple_ctf>
#include <fun>

public plugin_init(){
    register_plugin("SCTF Entity Glows","1.0", "Yek'-ta")
    set_task(5.0,"givetheglow")
}
public givetheglow(){
    new a = sctf_ent_TEFlag()
    entity_set_int(a, EV_INT_renderfx, kRenderFxGlowShell)
    entity_set_float(a, EV_FL_renderamt, 30.0)
    entity_set_vector(a, EV_VEC_rendercolor, Float:{150.0, 0.0, 0.0})
    a = sctf_ent_CTFlag()
    entity_set_int(a, EV_INT_renderfx, kRenderFxGlowShell)
    entity_set_float(a, EV_FL_renderamt, 30.0)
    entity_set_vector(a, EV_VEC_rendercolor, Float:{0.0, 0.0, 150.0})
    a = sctf_ent_TEFlagBase()
    entity_set_int(a, EV_INT_renderfx, kRenderFxGlowShell)
    entity_set_float(a, EV_FL_renderamt, 50.0)
    entity_set_vector(a, EV_VEC_rendercolor, Float:{150.0, 0.0, 0.0})
    a = sctf_ent_CTFlagBase()
    entity_set_int(a, EV_INT_renderfx, kRenderFxGlowShell)
    entity_set_float(a, EV_FL_renderamt, 50.0)
    entity_set_vector(a, EV_VEC_rendercolor, Float:{0.0, 0.0, 150.0})
}
public sctf_flag_dropped(player){
    set_user_rendering(player, kRenderFxNone, 0, 0, 0, kRenderNormal, 0)
}
public sctf_flag_scored(player){
    set_user_rendering(player, kRenderFxNone, 0, 0, 0, kRenderNormal, 0)
}
public sctf_flag_is_takenoff(pPlayer){
    if(pPlayer == sctf_who_TEflagger()){
        set_user_rendering(pPlayer, kRenderFxGlowShell, 0, 0, 150, kRenderNormal, 50)
    }
    else{
        set_user_rendering(pPlayer, kRenderFxGlowShell, 150, 0, 0, kRenderNormal, 50)
    }
    renkle(pPlayer)
}
public renkle(pPlayer){
    if(pPlayer==sctf_who_TEflagger()){
        static Float:fOrigin[3]

        entity_get_vector(pPlayer, EV_VEC_origin, fOrigin)
        message_begin(MSG_ONE_UNRELIABLE, SVC_TEMPENTITY, _, pPlayer)
        write_byte(TE_DLIGHT)
        engfunc(EngFunc_WriteCoord, fOrigin[0])
        engfunc(EngFunc_WriteCoord, fOrigin[1])
        engfunc(EngFunc_WriteCoord, fOrigin[2] -16)
        write_byte(12)
        write_byte(0)
        write_byte(0)
        write_byte(150)
        write_byte(5)
        write_byte(1)
        message_end()
        set_task(0.1,"renkle",pPlayer)
    }
    else if(pPlayer==sctf_who_CTflagger()){
        static Float:fOrigin[3]

        entity_get_vector(pPlayer, EV_VEC_origin, fOrigin)
        message_begin(MSG_ONE_UNRELIABLE, SVC_TEMPENTITY, _, pPlayer)
        write_byte(TE_DLIGHT)
        engfunc(EngFunc_WriteCoord, fOrigin[0])
        engfunc(EngFunc_WriteCoord, fOrigin[1])
        engfunc(EngFunc_WriteCoord, fOrigin[2] -16)
        write_byte(12)
        write_byte(100)
        write_byte(0)
        write_byte(0)
        write_byte(5)
        write_byte(1)
        message_end()
        set_task(0.1,"renkle",pPlayer)
    }
}

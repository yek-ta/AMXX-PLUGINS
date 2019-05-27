#include <amxmodx>
#include <reapi>
#include <hamsandwich>
#include <fakemeta>
#include <csd_bayrakkapmaca>

#define PDATA_VALID 2
#define is_entity(%0) (pev_valid(%0) == PDATA_VALID)
#define MODEL_GUNDROP "models/406/gundrop.mdl"

public plugin_precache()
{
    engfunc(EngFunc_PrecacheModel, MODEL_GUNDROP)
}

public plugin_init()
{
    register_plugin("Flag Drop", "1.0", "406") //Yek'-ta for CTF
}
public csd_bayrak_dustu(oyuncu,entity){
    if(pev(entity, pev_flags) & FL_KILLME)
    {
        new gundrop = pev(entity, pev_iuser1)
        if(is_entity(gundrop)) set_pev(gundrop, pev_flags, FL_KILLME)
        return HAM_IGNORED
    }
    new Float:vOrigin[3]
    pev(entity, pev_velocity, vOrigin)
    vOrigin[0] *= 0.7; vOrigin[1] *= 0.7; vOrigin[2] *= 0.7
    set_pev(entity, pev_velocity, vOrigin)
    new gundrop = pev(entity, pev_iuser1)
    if(is_entity(gundrop)) return HAM_IGNORED
    gundrop = rg_create_entity("info_target")
    set_pev(gundrop, pev_aiment, entity)
    set_pev(gundrop, pev_movetype, MOVETYPE_FOLLOW)
    engfunc(EngFunc_SetModel, gundrop, MODEL_GUNDROP)
    set_pev(gundrop, pev_framerate, 1.0)
    set_pev(entity, pev_iuser1, gundrop)
    return HAM_IGNORED
}

public csd_bayrak_alindi(oyuncu, entity)
{
    new gundrop = pev(entity, pev_iuser1)
    if(is_entity(gundrop)) set_pev(gundrop, pev_flags, FL_KILLME)
}
public csd_bayrak_geri_tasindi(oyuncu, entity)
{
    new gundrop = pev(entity, pev_iuser1)
    if(is_entity(gundrop)) set_pev(gundrop, pev_flags, FL_KILLME)
}

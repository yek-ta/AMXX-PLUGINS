/*
    https://forum.csduragi.com/silinmis-konular/istek-hook-plugini-t28762.html
*/

//#define engine

#include <amxmodx>
#include <amxmisc>
#include <fun>
#if defined engine
#include <engine>
#else
#include <fakemeta>
#endif


//Used for Grab
new maxplayers
new grab[33]
new Float:grab_totaldis[33]
new grab_speed_cvar

//Used for Hook
new bool:hook[33]
new hook_to[33][3]
new hook_speed_cvar

//Used for Rope
new bool:rope[33]
new rope_to[33][3]
new Float:rope_totaldis[33]
new rope_speed_cvar

//Used for All
new beamsprite
#define TUS IN_JUMP
new bool:ucabilirsinizinveriyorum[33];
/****************************
 Register Commands and CVARs
****************************/

public plugin_init()
{
    register_plugin("Grab + Hook + Rope","1.0","GHW_Chronic")
    register_concmd("+grab","grab_on")
    register_concmd("-grab","grab_off")
    register_concmd("ctgrab_toggle","grab_toggle")
    register_concmd("+hook","hook_on")
    register_concmd("-hook","hook_off")
    register_concmd("cthook_toggle","hook_toggle")
    register_concmd("+rope","rope_on")
    register_concmd("-rope","rope_off")
    register_concmd("ctrope_toggle","rope_toggle")

    grab_speed_cvar = register_cvar("grab_speed","5")
    hook_speed_cvar = register_cvar("hook_speed","5")
    rope_speed_cvar = register_cvar("rope_speed","5")

    maxplayers = get_maxplayers()
}


/**********************************
 Register beam sprite + Hook Sound
**********************************/

public plugin_precache()
{
    beamsprite = precache_model("sprites/dot.spr")
    precache_sound("weapons/xbow_hit2.wav")
    precache_sound("weapons/xbow_fire1.wav")
}

public grab_toggle(id,level,cid)
{
    if(grab[id]) grab_off(id)
    else grab_on(id,level,cid)
    return PLUGIN_HANDLED
}

public grab_on(id,level,cid)
{
    if(get_user_team(id) != 2)
    {
        return PLUGIN_HANDLED
    }
    if(grab[id])
    {
        return PLUGIN_HANDLED
    }
    grab[id]=-1
    static target, trash
    target=0
    get_user_aiming(id,target,trash)
    if(target && is_valid_ent2(target) && target!=id)
    {
        if(target<=maxplayers)
        {
            if(is_user_alive(target) && !(get_user_flags(target) & ADMIN_IMMUNITY))
            {
                client_print(id,print_chat,"[AMXX] Found Target")
                grabem(id,target)
            }
        }
        else if(get_solidity(target)!=4)
        {
            client_print(id,print_chat,"[AMXX] Found Target")
            grabem(id,target)
        }
    }
    else
    {
        client_print(id,print_chat,"[AMXX] Searching for Target")
        set_task(0.1,"grab_on2",id)
    }
    return PLUGIN_HANDLED
}

public grab_on2(id)
{
    if(is_user_connected(id))
    {
        static target, trash
        target=0
        get_user_aiming(id,target,trash)
        if(target && is_valid_ent2(target) && target!=id)
        {
            if(target<=maxplayers)
            {
                if(is_user_alive(target) && !(get_user_flags(target) & ADMIN_IMMUNITY))
                {
                    client_print(id,print_chat,"[AMXX] Found Target")
                    grabem(id,target)
                }
            }
            else if(get_solidity(target)!=4)
            {
                client_print(id,print_chat,"[AMXX] Found Target")
                grabem(id,target)
            }
        }
        else
        {
            set_task(0.1,"grab_on2",id)
        }
    }
}

public grabem(id,target)
{
    grab[id]=target
    set_rendering2(target,kRenderFxGlowShell,255,0,0,kRenderTransAlpha,70)
    if(target<=maxplayers) set_user_gravity(target,0.0)
    grab_totaldis[id] = 0.0
    set_task(0.1,"grab_prethink",id+1000,"",0,"b")
    grab_prethink(id+1000)
    emit_sound(id,CHAN_VOICE,"weapons/xbow_fire1.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
}

public grab_off(id)
{
    if(is_user_connected(id))
    {
        if(grab[id]==-1)
        {
            client_print(id,print_chat,"[AMXX] No Target Found")
            grab[id]=0
        }
        else if(grab[id])
        {
            client_print(id,print_chat,"[AMXX] Target Released")
            set_rendering2(grab[id])
            if(grab[id]<=maxplayers && is_user_alive(grab[id])) set_user_gravity(grab[id],1.0)
            grab[id]=0
        }
    }
    return PLUGIN_HANDLED
}

public grab_prethink(id)
{
    id -= 1000
    if(!is_user_connected(id) && grab[id]>0)
    {
        set_rendering2(grab[id])
        if(grab[id]<=maxplayers && is_user_alive(grab[id])) set_user_gravity(grab[id],1.0)
        grab[id]=0
    }
    if(!grab[id] || grab[id]==-1)
    {
        remove_task(id+1000)
        return PLUGIN_HANDLED
    }

    //Get Id's, target's, and Where Id is looking's origins
    static origin1[3]
    get_user_origin(id,origin1)
    static Float:origin2_F[3], origin2[3]
    get_origin(grab[id],origin2_F)
    origin2[0] = floatround(origin2_F[0])
    origin2[1] = floatround(origin2_F[1])
    origin2[2] = floatround(origin2_F[2])
    static origin3[3]
    get_user_origin(id,origin3,3)

    //Create red beam
    message_begin(MSG_BROADCAST,SVC_TEMPENTITY)
    write_byte(1)       //TE_BEAMENTPOINT
    write_short(id)     // start entity
    write_coord(origin2[0])
    write_coord(origin2[1])
    write_coord(origin2[2])
    write_short(beamsprite)
    write_byte(1)       // framestart
    write_byte(1)       // framerate
    write_byte(1)       // life in 0.1's
    write_byte(5)       // width
    write_byte(0)       // noise
    write_byte(255)     // red
    write_byte(0)       // green
    write_byte(0)       // blue
    write_byte(200)     // brightness
    write_byte(0)       // speed
    message_end()

    //Convert to floats for calculation
    static Float:origin1_F[3]
    static Float:origin3_F[3]
    origin1_F[0] = float(origin1[0])
    origin1_F[1] = float(origin1[1])
    origin1_F[2] = float(origin1[2])
    origin3_F[0] = float(origin3[0])
    origin3_F[1] = float(origin3[1])
    origin3_F[2] = float(origin3[2])

    //Calculate target's new velocity
    static Float:distance[3]

    if(!grab_totaldis[id])
    {
        distance[0] = floatabs(origin1_F[0] - origin2_F[0])
        distance[1] = floatabs(origin1_F[1] - origin2_F[1])
        distance[2] = floatabs(origin1_F[2] - origin2_F[2])
        grab_totaldis[id] = floatsqroot(distance[0]*distance[0] + distance[1]*distance[1] + distance[2]*distance[2])
    }
    distance[0] = origin3_F[0] - origin1_F[0]
    distance[1] = origin3_F[1] - origin1_F[1]
    distance[2] = origin3_F[2] - origin1_F[2]

    static Float:grab_totaldis2
    grab_totaldis2 = floatsqroot(distance[0]*distance[0] + distance[1]*distance[1] + distance[2]*distance[2])

    static Float:que
    que = grab_totaldis[id] / grab_totaldis2

    static Float:origin4[3]
    origin4[0] = ( distance[0] * que ) + origin1_F[0]
    origin4[1] = ( distance[1] * que ) + origin1_F[1]
    origin4[2] = ( distance[2] * que ) + origin1_F[2]

    static Float:velocity[3]
    velocity[0] = (origin4[0] - origin2_F[0]) * (get_pcvar_float(grab_speed_cvar) / 1.666667)
    velocity[1] = (origin4[1] - origin2_F[1]) * (get_pcvar_float(grab_speed_cvar) / 1.666667)
    velocity[2] = (origin4[2] - origin2_F[2]) * (get_pcvar_float(grab_speed_cvar) / 1.666667)

    set_velo(grab[id],velocity)

    return PLUGIN_CONTINUE
}


/*****
 Hook
*****/

public hook_toggle(id,level,cid)
{
    if(hook[id]) hook_off(id)
    else hook_on(id,level,cid)
    return PLUGIN_HANDLED
}

public hook_on(id,level,cid)
{
    if(get_user_team(id) != 2)
    {
        return PLUGIN_HANDLED
    }
    if(hook[id])
    {
        return PLUGIN_HANDLED
    }
    set_user_gravity(id,0.0)
    set_task(0.1,"hook_prethink",id+10000,"",0,"b")
    hook[id]=true
    hook_to[id][0]=999999
    hook_prethink(id+10000)
    emit_sound(id,CHAN_VOICE,"weapons/xbow_hit2.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
    return PLUGIN_HANDLED
}

public hook_off(id)
{
    if(is_user_alive(id)) set_user_gravity(id)
    hook[id]=false
    ucabilirsinizinveriyorum[id]=false
    return PLUGIN_HANDLED
}

public hook_prethink(id)
{
    id -= 10000
    if(!is_user_alive(id))
    {
        hook[id]=false
    }
    if(!hook[id])
    {
        remove_task(id+10000)
        ucabilirsinizinveriyorum[id]=false;
        return PLUGIN_HANDLED
    }

    //Get Id's origin
    static origin1[3]
    get_user_origin(id,origin1)

    if(hook_to[id][0]==999999)
    {
        static origin2[3]
        get_user_origin(id,origin2,3)
        hook_to[id][0]=origin2[0]
        hook_to[id][1]=origin2[1]
        hook_to[id][2]=origin2[2]
    }

    //Create blue beam
    message_begin(MSG_BROADCAST,SVC_TEMPENTITY)
    write_byte(1)       //TE_BEAMENTPOINT
    write_short(id)     // start entity
    write_coord(hook_to[id][0])
    write_coord(hook_to[id][1])
    write_coord(hook_to[id][2])
    write_short(beamsprite)
    write_byte(1)       // framestart
    write_byte(1)       // framerate
    write_byte(2)       // life in 0.1's
    write_byte(5)       // width
    write_byte(0)       // noise
    if(ucabilirsinizinveriyorum[id]){
        write_byte(0)       // red
        write_byte(0)       // green
        write_byte(255)     // blue
    }
    else {
        write_byte(255)       // red
        write_byte(0)       // green
        write_byte(0)     // blue
    }

    write_byte(200)     // brightness
    write_byte(0)       // speed
    message_end()

    //Calculate Velocity
    static Float:velocity[3]
    velocity[0] = (float(hook_to[id][0]) - float(origin1[0])) * 3.0
    velocity[1] = (float(hook_to[id][1]) - float(origin1[1])) * 3.0
    velocity[2] = (float(hook_to[id][2]) - float(origin1[2])) * 3.0

    static Float:y
    y = velocity[0]*velocity[0] + velocity[1]*velocity[1] + velocity[2]*velocity[2]

    static Float:x
    x = (get_pcvar_float(hook_speed_cvar) * 120.0) / floatsqroot(y)

    velocity[0] *= x
    velocity[1] *= x
    velocity[2] *= x

    if((pev(id, pev_button) & TUS) && is_user_alive(id)){
        ucabilirsinizinveriyorum[id]=true;
    }
    if(ucabilirsinizinveriyorum[id]){
       set_velo(id,velocity);
    }
    return PLUGIN_CONTINUE
}


/*****
 Rope
*****/

public rope_toggle(id,level,cid)
{
    if(rope[id]) rope_off(id)
    else rope_on(id,level,cid)
    return PLUGIN_HANDLED
}

public rope_on(id,level,cid)
{
    if(get_user_team(id) != 2)
    {
        return PLUGIN_HANDLED
    }
    if(rope[id])
    {
        return PLUGIN_HANDLED
    }
    set_task(0.1,"rope_prethink",id+100000,"",0,"b")
    rope[id]=true
    rope_to[id][0]=999999
    rope_prethink(id+100000)
    emit_sound(id,CHAN_VOICE,"weapons/xbow_hit2.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
    return PLUGIN_HANDLED
}

public rope_off(id)
{
    rope[id]=false
    return PLUGIN_HANDLED
}

public rope_prethink(id)
{
    id -= 100000
    if(!is_user_alive(id))
    {
        rope[id]=false
    }
    if(!rope[id])
    {
        remove_task(id+100000)
        return PLUGIN_HANDLED
    }

    //Get Id's origin
    static origin1[3]
    get_user_origin(id,origin1)

    static Float:origin1_F[3]
    origin1_F[0] = float(origin1[0])
    origin1_F[1] = float(origin1[1])
    origin1_F[2] = float(origin1[2])

    //Check to see if this is the first time prethink is being run
    if(rope_to[id][0]==999999)
    {
        static origin2[3]
        get_user_origin(id,origin2,3)
        rope_to[id][0]=origin2[0]
        rope_to[id][1]=origin2[1]
        rope_to[id][2]=origin2[2]

        static Float:origin2_F[3]
        origin2_F[0] = float(origin2[0])
        origin2_F[1] = float(origin2[1])
        origin2_F[2] = float(origin2[2])

        static Float:distance[3]
        distance[0] = floatabs(origin1_F[0] - origin2_F[0])
        distance[1] = floatabs(origin1_F[1] - origin2_F[1])
        distance[2] = floatabs(origin1_F[2] - origin2_F[2])
        rope_totaldis[id] = floatsqroot(distance[0]*distance[0] + distance[1]*distance[1] + distance[2]*distance[2])
    }

    //Create green beam
    message_begin(MSG_BROADCAST,SVC_TEMPENTITY)
    write_byte(1)       //TE_BEAMENTPOINT
    write_short(id)     // start entity
    write_coord(rope_to[id][0])
    write_coord(rope_to[id][1])
    write_coord(rope_to[id][2])
    write_short(beamsprite)
    write_byte(1)       // framestart
    write_byte(1)       // framerate
    write_byte(1)       // life in 0.1's
    write_byte(5)       // width
    write_byte(0)       // noise
    write_byte(0)       // red
    write_byte(255)     // green
    write_byte(0)       // blue
    write_byte(200)     // brightness
    write_byte(0)       // speed
    message_end()

    //Calculate Velocity
    static Float:velocity[3]
    get_velo(id,velocity)

    static Float:velocity2[3]
    velocity2[0] = (rope_to[id][0] - origin1_F[0]) * 3.0
    velocity2[1] = (rope_to[id][1] - origin1_F[1]) * 3.0

    static Float:y
    y = velocity2[0]*velocity2[0] + velocity2[1]*velocity2[1]

    static Float:x
    x = (get_pcvar_float(rope_speed_cvar) * 20.0) / floatsqroot(y)

    velocity[0] += velocity2[0]*x
    velocity[1] += velocity2[1]*x

    if(rope_to[id][2] - origin1_F[2] >= rope_totaldis[id] && velocity[2]<0.0) velocity[2] *= -1

    set_velo(id,velocity)

    return PLUGIN_CONTINUE
}

public get_origin(ent,Float:origin[3])
{
#if defined engine
    return entity_get_vector(id,EV_VEC_origin,origin)
#else
    return pev(ent,pev_origin,origin)
#endif
}

public set_velo(id,Float:velocity[3])
{
#if defined engine
    return set_user_velocity(id,velocity)
#else
    return set_pev(id,pev_velocity,velocity)
#endif
}

public get_velo(id,Float:velocity[3])
{
#if defined engine
    return get_user_velocity(id,velocity)
#else
    return pev(id,pev_velocity,velocity)
#endif
}

public is_valid_ent2(ent)
{
#if defined engine
    return is_valid_ent(ent)
#else
    return pev_valid(ent)
#endif
}

public get_solidity(ent)
{
#if defined engine
    return entity_get_int(ent,EV_INT_solid)
#else
    return pev(ent,pev_solid)
#endif
}

stock set_rendering2(index, fx=kRenderFxNone, r=255, g=255, b=255, render=kRenderNormal, amount=16)
{
#if defined engine
    return set_rendering(index,fx,r,g,b,render,amount)
#else
    set_pev(index, pev_renderfx, fx);
    new Float:RenderColor[3];
    RenderColor[0] = float(r);
    RenderColor[1] = float(g);
    RenderColor[2] = float(b);
    set_pev(index, pev_rendercolor, RenderColor);
    set_pev(index, pev_rendermode, render);
    set_pev(index, pev_renderamt, float(amount));
    return 1;
#endif
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1055\\ f0\\ fs16 \n\\ par }
*/

/*

https://forum.csduragi.com/eklentiler-pluginler/yektas-combo-sprite-t35501.html
https://dev-cs.ru/resources/720/
https://github.com/yek-ta/AMXX-PLUGINS/tree/master/Yekta's%20Combo%20Sprite

*/

#include <amxmodx>
#include <reapi>

#define PLUGIN "Yekta's Combo Sprite"
#define VERSION "3.2"
#define AUTHOR "Yek'-ta"

#define SHOWTIME 1.5  //it should be float

#define HUD_HIDE_FLASH (1<<1)
#define HUD_HIDE_CROSS (1<<6)
#define HUD_DRAW_CROSS (1<<7)

#define CSW_SHIELD  2
new isitON[33]
new kills[33]
new bool: PlayerOnOff[MAX_PLAYERS]

enum _:MESSAGES {
    g_iMsg_WeaponList,
    g_iMsg_ScreenFade,
    g_iMsg_CurWeapon,
    g_iMsg_SetFOV,
    g_iMsg_HideWeapon,
    g_iMsg_Crosshair
}
new g_Messages[MESSAGES];
new g_Messages_Name[MESSAGES][] = {
    "WeaponList",
    "ScreenFade",
    "CurWeapon",
    "SetFOV",
    "HideWeapon",
    "Crosshair"
}

public plugin_init(){

    register_plugin(PLUGIN, VERSION, AUTHOR)
    for(new i; i < sizeof g_Messages; i++){
        g_Messages[i] = get_user_msgid(g_Messages_Name[i]);
    }
    RegisterHookChain(RG_CBasePlayer_Spawn, "CBasePlayer_Spawn",true);
    RegisterHookChain(RG_CBasePlayer_Killed, "CBasePlayer_Killed", true);
    register_event("CurWeapon","comboHudGoster","be", "1=1")
    register_clcmd("say /combosprite", "comboonoff");
}
public comboonoff(id){
    PlayerOnOff[id] = !PlayerOnOff[id]
    client_print_color(id, id, "^1Combo Sprite is ^3%s", PlayerOnOff[id] ? "ON" : "OFF")
}
public plugin_precache(){
    precache_model("sprites/yek_combo/alarm_kill.spr")
    precache_model("sprites/yek_combo/alarm_2kill.spr")
    precache_model("sprites/yek_combo/alarm_3kill.spr")
    precache_model("sprites/yek_combo/alarm_4kill.spr")
    precache_model("sprites/yek_combo/alarm_5kill.spr")
    precache_model("sprites/yek_combo/alarm_6kill.spr")
    precache_model("sprites/yek_combo/alarm_7kill.spr")
    precache_model("sprites/yek_combo/alarm_8kill.spr")
    precache_model("sprites/yek_combo/alarm_knife.spr")
    precache_model("sprites/yek_combo/alarm_combo.spr")
    precache_model("sprites/yek_combo/alarm_grenade.spr")
    precache_model("sprites/yek_combo/alarm_headshot.spr")
    precache_generic("sprites/yek_combo/alarm_kill.txt")
    precache_generic("sprites/yek_combo/alarm_2kill.txt")
    precache_generic("sprites/yek_combo/alarm_3kill.txt")
    precache_generic("sprites/yek_combo/alarm_4kill.txt")
    precache_generic("sprites/yek_combo/alarm_5kill.txt")
    precache_generic("sprites/yek_combo/alarm_6kill.txt")
    precache_generic("sprites/yek_combo/alarm_7kill.txt")
    precache_generic("sprites/yek_combo/alarm_8kill.txt")
    precache_generic("sprites/yek_combo/alarm_knife.txt")
    precache_generic("sprites/yek_combo/alarm_combo.txt")
    precache_generic("sprites/yek_combo/alarm_grenade.txt")
    precache_generic("sprites/yek_combo/alarm_headshot.txt")
}
public client_putinserver(id){
    PlayerOnOff[id] = true;
    kills[id] = 0;
}
public CBasePlayer_Killed(iVictim, iKiller)
{
    if(!is_user_connected(iKiller) || iVictim == iKiller)
        return HC_CONTINUE;

    kills[iVictim] = 0
    kills[iKiller] += 1;

    if(!PlayerOnOff[iKiller])
        return HC_CONTINUE;

    remove_task(1997+iKiller);

    if(get_member(iVictim, m_bHeadshotKilled))
        isitON[iKiller] = -1;
    else if(get_member(iVictim, m_bKilledByGrenade))
        isitON[iKiller] = -2;
    else if(get_user_weapon(iKiller) == CSW_KNIFE)
        isitON[iKiller] = -3;
    else
        isitON[iKiller] = kills[iKiller];

    comboHudGoster(iKiller)
    set_task(SHOWTIME,"RemoveHUD",1997+iKiller);

    return HC_CONTINUE;
}
public RemoveHUD(numara){
    numara = numara-1997
    if(get_member(numara, m_iFOV) == 90){
        isitON[numara] = 0;
        Hide_NormalCrosshair(numara, 0);
        show_crosshair(numara, 0)
    }
    else {
        set_task(1.0,"RemoveHUD",1997+numara);
    }
}
public CBasePlayer_Spawn(oyuncu){
    kills[oyuncu] = 0;
}
public comboHudGoster(id){
    if(isitON[id] == 0){
        return PLUGIN_HANDLED
    }
    else if(get_member(id, m_iFOV) != 90){
        return PLUGIN_HANDLED
    }
    static userwpn, prim, sprtxt[52]
    userwpn = get_user_weapon(id, prim)

    switch (isitON[id])
    {
        case -3: { formatex(sprtxt,charsmax(sprtxt),"yek_combo/alarm_knife"); }
        case -2: { formatex(sprtxt,charsmax(sprtxt),"yek_combo/alarm_grenade"); }
        case -1: { formatex(sprtxt,charsmax(sprtxt),"yek_combo/alarm_headshot"); }
        case 1: { formatex(sprtxt,charsmax(sprtxt),"yek_combo/alarm_kill"); }
        case 2: { formatex(sprtxt,charsmax(sprtxt),"yek_combo/alarm_2kill"); }
        case 3: { formatex(sprtxt,charsmax(sprtxt),"yek_combo/alarm_3kill"); }
        case 4: { formatex(sprtxt,charsmax(sprtxt),"yek_combo/alarm_4kill"); }
        case 5: { formatex(sprtxt,charsmax(sprtxt),"yek_combo/alarm_5kill"); }
        case 6: { formatex(sprtxt,charsmax(sprtxt),"yek_combo/alarm_6kill"); }
        case 7: { formatex(sprtxt,charsmax(sprtxt),"yek_combo/alarm_7kill"); }
        case 8: { formatex(sprtxt,charsmax(sprtxt),"yek_combo/alarm_8kill"); }
        default: { formatex(sprtxt,charsmax(sprtxt),"yek_combo/alarm_combo"); }
    }
    switch (userwpn)
    {
        case CSW_P228: { Msg_WeaponList(id, sprtxt,9,52,-1,-1,0,11,CSW_SHIELD,0);Hide_NormalCrosshair(id, 0); }
        case CSW_HEGRENADE: { Msg_WeaponList(id, sprtxt,12,1,-1,-1,0,11,CSW_SHIELD,0);Hide_NormalCrosshair(id, 0); }
        case CSW_XM1014: { Msg_WeaponList(id, sprtxt,5,32,-1,-1,0,11,CSW_SHIELD,0);Hide_NormalCrosshair(id, 0); }
        case CSW_C4: { Msg_WeaponList(id, sprtxt,14,1,-1,-1,0,11,CSW_SHIELD,0);Hide_NormalCrosshair(id, 0); }
        case CSW_MAC10: { Msg_WeaponList(id, sprtxt,6,100,-1,-1,0,11,CSW_SHIELD,0);Hide_NormalCrosshair(id, 0); }
        case CSW_AUG: { Msg_WeaponList(id, sprtxt,4,90,-1,-1,0,11,CSW_SHIELD,0);Hide_NormalCrosshair(id, 0); }
        case CSW_SMOKEGRENADE: { Msg_WeaponList(id, sprtxt,13,1,-1,-1,0,11,CSW_SHIELD,0);Hide_NormalCrosshair(id, 0); }
        case CSW_ELITE: { Msg_WeaponList(id, sprtxt,10,120,-1,-1,0,11,CSW_SHIELD,0);Hide_NormalCrosshair(id, 0); }
        case CSW_FIVESEVEN: { Msg_WeaponList(id, sprtxt,7,100,-1,-1,0,11,CSW_SHIELD,0);Hide_NormalCrosshair(id, 0); }
        case CSW_UMP45: { Msg_WeaponList(id, sprtxt,6,100,-1,-1,0,11,CSW_SHIELD,0);Hide_NormalCrosshair(id, 0); }
        case CSW_GALIL: { Msg_WeaponList(id, sprtxt,4,90,-1,-1,0,11,CSW_SHIELD,0);Hide_NormalCrosshair(id, 0); }
        case CSW_FAMAS: { Msg_WeaponList(id, sprtxt,4,90,-1,-1,0,11,CSW_SHIELD,0);Hide_NormalCrosshair(id, 0); }
        case CSW_USP: { Msg_WeaponList(id, sprtxt,6,100,-1,-1,0,11,CSW_SHIELD,0);Hide_NormalCrosshair(id, 0); }
        case CSW_GLOCK18: { Msg_WeaponList(id, sprtxt,10,120,-1,-1,0,11,CSW_SHIELD,0);Hide_NormalCrosshair(id, 0); }
        case CSW_MP5NAVY: { Msg_WeaponList(id, sprtxt,10,120,-1,-1,0,11,CSW_SHIELD,0);Hide_NormalCrosshair(id, 0); }
        case CSW_M249: { Msg_WeaponList(id, sprtxt,3,200,-1,-1,0,11,CSW_SHIELD,0);Hide_NormalCrosshair(id, 0); }
        case CSW_M3: {Msg_WeaponList(id, sprtxt,5,32,-1,-1,0,11,CSW_SHIELD,0);Hide_NormalCrosshair(id, 0); }
        case CSW_M4A1: { Msg_WeaponList(id, sprtxt,4,90,-1,-1,0,11,CSW_SHIELD,0);Hide_NormalCrosshair(id, 0); }
        case CSW_TMP: { Msg_WeaponList(id, sprtxt,10,120,-1,-1,0,11,CSW_SHIELD,0);Hide_NormalCrosshair(id, 0); }
        case CSW_FLASHBANG: { Msg_WeaponList(id, sprtxt,11,2,-1,-1,0,11,CSW_SHIELD,0);Hide_NormalCrosshair(id, 0); }
        case CSW_DEAGLE: { Msg_WeaponList(id, sprtxt,8,35,-1,-1,0,11,CSW_SHIELD,0);Hide_NormalCrosshair(id, 0); }
        case CSW_SG552: { Msg_WeaponList(id, sprtxt,4,90,-1,-1,0,11,CSW_SHIELD,0);Hide_NormalCrosshair(id, 0); }
        case CSW_AK47: { Msg_WeaponList(id, sprtxt,2,90,-1,-1,0,11,CSW_SHIELD,0);Hide_NormalCrosshair(id, 0); }
        case CSW_KNIFE:{ Msg_WeaponList(id, sprtxt,-1,-1,-1,-1,0,11,CSW_SHIELD,0);Hide_NormalCrosshair(id, 0); }
        case CSW_P90: { Msg_WeaponList(id, sprtxt,7,100,-1,-1,0,11,CSW_SHIELD,0);Hide_NormalCrosshair(id, 0); }
        case CSW_SCOUT: { Msg_WeaponList(id, sprtxt,2,90,-1,-1,0,11,CSW_SHIELD,0);Hide_NormalCrosshair(id, 1); }
        case CSW_AWP: { Msg_WeaponList(id, sprtxt,1,30,-1,-1,0,11,CSW_SHIELD,0);Hide_NormalCrosshair(id, 1); }
        case CSW_SG550: { Msg_WeaponList(id, sprtxt,4,90,-1,-1,0,11,CSW_SHIELD,0);Hide_NormalCrosshair(id, 1); }
        case CSW_G3SG1: { Msg_WeaponList(id, sprtxt,2,90,-1,-1,0,11,CSW_SHIELD,0);Hide_NormalCrosshair(id, 1); }
    }
    Msg_SetFOV(id, 89);
    Msg_CurWeapon(id, 1,CSW_SHIELD,prim);
    Msg_SetFOV(id, 90);
    return PLUGIN_CONTINUE
}
stock Hide_NormalCrosshair(id, flag){
    if(flag == 1){
        message_begin(MSG_ONE, g_Messages[g_iMsg_HideWeapon], _, id);
        write_byte(HUD_HIDE_CROSS | HUD_HIDE_FLASH);
        message_end();
    }
    else{
        message_begin(MSG_ONE, g_Messages[g_iMsg_HideWeapon], _, id);
        write_byte(HUD_DRAW_CROSS | HUD_HIDE_FLASH);
        message_end();
    }
}
stock show_crosshair(id, flag){
    message_begin(MSG_ONE_UNRELIABLE, g_Messages[g_iMsg_Crosshair], _, id);
    write_byte(flag);
    message_end();
}
stock Msg_CurWeapon(id, IsActive,WeaponID,ClipAmmo){
    message_begin(MSG_ONE,g_Messages[g_iMsg_CurWeapon], {0,0,0}, id);
    write_byte(IsActive);
    write_byte(WeaponID);
    write_byte(ClipAmmo);

    message_end();
}
stock Msg_WeaponList(id, const WeaponName[],PrimaryAmmoID,PrimaryAmmoMaxAmount,SecondaryAmmoID,
SecondaryAmmoMaxAmount,SlotID,NumberInSlot,WeaponID,Flags){
    message_begin(MSG_ONE,g_Messages[g_iMsg_WeaponList], {0,0,0}, id);
    write_string(WeaponName);
    write_byte(PrimaryAmmoID);
    write_byte(PrimaryAmmoMaxAmount);
    write_byte(SecondaryAmmoID);
    write_byte(SecondaryAmmoMaxAmount);
    write_byte(SlotID);
    write_byte(NumberInSlot);
    write_byte(WeaponID);
    write_byte(Flags);
    message_end();
}

stock Msg_SetFOV(id, Degrees){
    message_begin(MSG_ONE,g_Messages[g_iMsg_SetFOV], {0,0,0}, id);
    write_byte(Degrees);
    message_end();
}

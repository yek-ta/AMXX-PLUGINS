#include <amxmodx>
#include <engine>
#include <fakemeta>
#include <fun>
#include <hamsandwich>
#include <xs>
#include <cstrike>
#define MAHKUM 1
#define GARDIYAN 2

// Natives
native jbsam_esya_gir(const item_name[], const item_cost, const item_desc[], const item_team)
native jbsam_esyamenusu(id)

// Forwards
forward jbsam_esya_sec(id, item)


#define ENG_NULLENT				-1
#define EV_INT_WEAPONKEY		EV_INT_impulse
#define plasmagun_WEAPONKEY	8774
#define MAX_PLAYERS  			32
#define IsValidUser(%1) (1 <= %1 <= g_MaxPlayers)

const USE_STOPPED = 0
const OFFSET_ACTIVE_ITEM = 373
const OFFSET_WEAPONOWNER = 41
const OFFSET_LINUX = 5
const OFFSET_LINUX_WEAPONS = 4

#define WEAP_LINUX_XTRA_OFF		4
#define m_fKnown					44
#define m_flNextPrimaryAttack 		46
#define m_flTimeWeaponIdle			48
#define m_iClip					51
#define m_fInReload				54
#define PLAYER_LINUX_XTRA_OFF	5
#define m_flNextAttack				83

#define plasmagun_RELOAD_TIME 	3.5
#define plasmagun_RELOAD		1
#define plasmagun_DRAW		2
#define plasmagun_SHOOT1		3
#define plasmagun_SHOOT2		4

#define write_coord_f(%1)	engfunc(EngFunc_WriteCoord,%1)

new const Fire_Sounds[][] = {"weapons/plasmagun-1.wav"}
new plasmagun_V_MODEL[64] = "models/v_plasmagun.mdl"
new plasmagun_P_MODEL[64] = "models/p_plasmagun.mdl"
new plasmagun_W_MODEL[64] = "models/w_plasmagun.mdl"
new const Sound_Zoom[] = { "weapons/zoom.wav" }
new const GUNSHOT_DECALS[] = { 41, 42, 43, 44, 45 }

new cvar_dmg_plasmagun, cvar_recoil_plasmagun, cvar_clip_plasmagun, cvar_spd_plasmagun, cvar_plasmagun_ammo
new g_MaxPlayers, g_orig_event_plasmagun, g_IsInPrimaryAttack
new Float:cl_pushangle[MAX_PLAYERS + 1][3], m_iBlood[2]
new g_has_plasmagun[33], g_clip_ammo[33], g_plasmagun_TmpClip[33], oldweap[33], g_hasZoom[33], Float:g_flNextUseTime[33], g_Reload[33]
new gmsgWeaponList, sprexp, g_beamSpr

const PRIMARY_WEAPONS_BIT_SUM = 
(1<<CSW_SCOUT)|(1<<CSW_XM1014)|(1<<CSW_MAC10)|(1<<CSW_AUG)|(1<<CSW_UMP45)|(1<<CSW_SG550)|(1<<CSW_GALIL)|(1<<CSW_FAMAS)|(1<<CSW_AWP)|(1<<
CSW_MP5NAVY)|(1<<CSW_M249)|(1<<CSW_M3)|(1<<CSW_M4A1)|(1<<CSW_TMP)|(1<<CSW_G3SG1)|(1<<CSW_SG552)|(1<<CSW_AK47)|(1<<CSW_P90)
new const WEAPONENTNAMES[][] = { "", "weapon_p228", "", "weapon_scout", "weapon_hegrenade", "weapon_xm1014", "weapon_c4", "weapon_mac10",
			"weapon_aug", "weapon_smokegrenade", "weapon_elite", "weapon_fiveseven", "weapon_ump45", "weapon_sg550",
			"weapon_galil", "weapon_famas", "weapon_usp", "weapon_glock18", "weapon_awp", "weapon_mp5navy", "weapon_m249",
			"weapon_m3", "weapon_m4a1", "weapon_tmp", "weapon_g3sg1", "weapon_flashbang", "weapon_deagle", "weapon_sg552",
			"weapon_ak47", "weapon_knife", "weapon_p90" }

new cvar_esya_para
new esya
public jbsam_esya_sec(id, item){
	if(item != esya)
		return PLUGIN_HANDLED
		
	give_plasma(id)
	
	return PLUGIN_CONTINUE
}
public plugin_init()
{
	register_plugin("Extra: plasmagun", "1.0", "Crock| Edit CSmiLeFaCe")
	register_message(get_user_msgid("DeathMsg"), "message_DeathMsg")
	register_event("CurWeapon","CurrentWeapon","be","1=1")
	RegisterHam(Ham_Item_AddToPlayer, "weapon_mac10", "fw_plasmagun_AddToPlayer")
	RegisterHam(Ham_Use, "func_tank", "fw_UseStationary_Post", 1)
	RegisterHam(Ham_Use, "func_tankmortar", "fw_UseStationary_Post", 1)
	RegisterHam(Ham_Use, "func_tankrocket", "fw_UseStationary_Post", 1)
	RegisterHam(Ham_Use, "func_tanklaser", "fw_UseStationary_Post", 1)
	for (new i = 1; i < sizeof WEAPONENTNAMES; i++)
	if (WEAPONENTNAMES[i][0]) RegisterHam(Ham_Item_Deploy, WEAPONENTNAMES[i], "fw_Item_Deploy_Post", 1)
	RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_mac10", "fw_plasmagun_PrimaryAttack")
	RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_mac10", "fw_m4a1drag_PrimaryAttack_Post", 1)
	RegisterHam(Ham_Item_PostFrame, "weapon_mac10", "plasmagun_ItemPostFrame")
	RegisterHam(Ham_Weapon_Reload, "weapon_mac10", "plasmagun_Reload")
	RegisterHam(Ham_Weapon_Reload, "weapon_mac10", "plasmagun_Reload_Post", 1)
	RegisterHam(Ham_TakeDamage, "player", "fw_TakeDamage")
	register_forward(FM_SetModel, "fw_SetModel")
	RegisterHam(Ham_Item_Holster, "weapon_mac10", "fw_plasmagun_Holster_Post", 1)
	register_forward(FM_UpdateClientData, "fw_UpdateClientData_Post", 1)
	register_forward(FM_PlaybackEvent, "fwPlaybackEvent")
	register_forward(FM_CmdStart, "fw_CmdStart")

	RegisterHam(Ham_TraceAttack, "worldspawn", "fw_TraceAttack", 1)
	RegisterHam(Ham_TraceAttack, "func_breakable", "fw_TraceAttack", 1)
	RegisterHam(Ham_TraceAttack, "func_wall", "fw_TraceAttack", 1)
	RegisterHam(Ham_TraceAttack, "func_door", "fw_TraceAttack", 1)
	RegisterHam(Ham_TraceAttack, "func_door_rotating", "fw_TraceAttack", 1)
	RegisterHam(Ham_TraceAttack, "func_plat", "fw_TraceAttack", 1)
	RegisterHam(Ham_TraceAttack, "func_rotating", "fw_TraceAttack", 1)

	cvar_dmg_plasmagun = register_cvar("zp_plasmagun_dmg", "99")
	cvar_recoil_plasmagun = register_cvar("zp_plasmagun_recoil", "0.1")
	cvar_clip_plasmagun = register_cvar("zp_plasmagun_clip", "45")
	cvar_spd_plasmagun = register_cvar("zp_plasmagun_spd", "2.0")
	cvar_plasmagun_ammo = register_cvar("zp_plasmagun_ammo", "200")
	
	g_MaxPlayers = get_maxplayers()
	gmsgWeaponList = get_user_msgid("WeaponList")
	cvar_esya_para = register_cvar("jbsam_plazma_ucret","30")
	esya = jbsam_esya_gir("Plazma Silahi", get_pcvar_num(cvar_esya_para), "Plazma Silahi Alirsin", GARDIYAN)
}

public plugin_precache()
{
	precache_model(plasmagun_V_MODEL)
	precache_model(plasmagun_P_MODEL)
	precache_model(plasmagun_W_MODEL)
	sprexp=precache_model("sprites/plasmabomb.spr")
	g_beamSpr=precache_model("sprites/xenobeam.spr")
	for(new i = 0; i < sizeof Fire_Sounds; i++)
	precache_sound(Fire_Sounds[i])		
	precache_sound("weapons/plasmagun_clipin1.wav")
	precache_sound("weapons/plasmagun_clipin2.wav")
	precache_sound("weapons/plasmagun_clipout.wav")
	precache_sound("weapons/plasmagun_draw.wav")
	precache_sound("weapons/plasmagun_idle.wav")
	precache_sound(Sound_Zoom)
	m_iBlood[0] = precache_model("sprites/blood.spr")
	m_iBlood[1] = precache_model("sprites/bloodspray.spr")
	precache_generic("sprites/weapon_plasmagun.txt")
   	precache_generic("sprites/640hud91.spr")
   	precache_generic("sprites/640hud3.spr")
	
	register_clcmd("weapon_plasmagun", "weapon_hook")	

	register_forward(FM_PrecacheEvent, "fwPrecacheEvent_Post", 1)
}

public weapon_hook(id)
{
    	engclient_cmd(id, "weapon_mac10")
    	return PLUGIN_HANDLED
}

public fw_TraceAttack(iEnt, iAttacker, Float:flDamage, Float:fDir[3], ptr, iDamageType)
{
	if(!is_user_alive(iAttacker))
		return

	new g_currentweapon = get_user_weapon(iAttacker)

	if(g_currentweapon != CSW_MAC10) return
	
	if(!g_has_plasmagun[iAttacker]) return

	static Float:flEnd[3]
	get_tr2(ptr, TR_vecEndPos, flEnd)
	
	if(iEnt)
	{
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(TE_DECAL)
		engfunc(EngFunc_WriteCoord, flEnd[0])
		engfunc(EngFunc_WriteCoord, flEnd[1])
		engfunc(EngFunc_WriteCoord, flEnd[2])
		write_byte(GUNSHOT_DECALS[random_num (0, sizeof GUNSHOT_DECALS -1)])
		write_short(iEnt)
		message_end()
	}
	else
	{
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(TE_SPRITE)
		engfunc(EngFunc_WriteCoord, flEnd[0])
		engfunc(EngFunc_WriteCoord, flEnd[1])
		engfunc(EngFunc_WriteCoord, flEnd[2])
		write_short(sprexp)
		write_byte(10)
		write_byte(200)
		message_end()	
	}
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY )
	write_byte(TE_BEAMENTPOINT)
	write_short(iAttacker | 0x1000)
	engfunc(EngFunc_WriteCoord, flEnd[0])
	engfunc(EngFunc_WriteCoord, flEnd[1])
	engfunc(EngFunc_WriteCoord, flEnd[2])
	write_short(g_beamSpr)
	write_byte(0) // framerate
	write_byte(0) // framerate
	write_byte(1) // life
	write_byte(20)  // width
	write_byte(0)// noise
	write_byte(110)// r, g, b
	write_byte(251)// r, g, b
	write_byte(110)// r, g, b
	write_byte(200)	// brightness
	write_byte(5)	// speed
	message_end()
}

public zp_user_humanized_post(id)
{
	g_has_plasmagun[id] = false
}

public fwPrecacheEvent_Post(type, const name[])
{
	if (equal("events/mac10.sc", name))
	{
		g_orig_event_plasmagun = get_orig_retval()
		return FMRES_HANDLED
	}
	return FMRES_IGNORED
}

public fw_CmdStart(id, uc_handle, seed)
{
	if (!is_user_alive(id) || g_Reload[id] || !g_has_plasmagun[id])
		return FMRES_IGNORED
	
	if((get_uc(uc_handle, UC_Buttons) & IN_ATTACK2) && !(pev(id, pev_oldbuttons) & IN_ATTACK2))
	{
		new szClip, szAmmo
		new szWeapID = get_user_weapon(id, szClip, szAmmo)

		if(szWeapID == CSW_MAC10 && g_has_plasmagun[id] && !g_hasZoom[id] == true)
		{
			g_hasZoom[id] = true
			cs_set_user_zoom(id, CS_SET_AUGSG552_ZOOM, 0)
			emit_sound(id, CHAN_ITEM, Sound_Zoom, 0.20, 2.40, 0, 100)
		}
		else if(szWeapID == CSW_MAC10 && g_has_plasmagun[id] && g_hasZoom[id])
		{
			g_hasZoom[id] = false
			cs_set_user_zoom(id, CS_RESET_ZOOM, 0)	
		}
	}
	return FMRES_IGNORED
}

public client_connect(id)
{
	g_has_plasmagun[id] = false
}

public client_disconnect(id)
{
	g_has_plasmagun[id] = false
}



public fw_SetModel(entity, model[])
{
	if(!is_valid_ent(entity))
		return FMRES_IGNORED
	
	static szClassName[33]
	entity_get_string(entity, EV_SZ_classname, szClassName, charsmax(szClassName))
		
	if(!equal(szClassName, "weaponbox"))
		return FMRES_IGNORED
	
	static iOwner
	
	iOwner = entity_get_edict(entity, EV_ENT_owner)
	
	if(equal(model, "models/w_mac10.mdl"))
	{
		static iStoredAugID
		
		iStoredAugID = find_ent_by_owner(ENG_NULLENT, "weapon_mac10", entity)
	
		if(!is_valid_ent(iStoredAugID))
			return FMRES_IGNORED
	
		if(g_has_plasmagun[iOwner])
		{
			entity_set_int(iStoredAugID, EV_INT_WEAPONKEY, plasmagun_WEAPONKEY)
			
			g_has_plasmagun[iOwner] = false
			
			entity_set_model(entity, plasmagun_W_MODEL)
			
			return FMRES_SUPERCEDE
		}
	}
	return FMRES_IGNORED
}

public give_plasma(id)
{
	drop_weapons(id, 1)
	new iWep2 = give_item(id,"weapon_mac10")
	if( iWep2 > 0 )
	{
		cs_set_weapon_ammo(iWep2, get_pcvar_num(cvar_clip_plasmagun))
		cs_set_user_bpammo (id, CSW_MAC10, get_pcvar_num(cvar_plasmagun_ammo))	
		set_pdata_float(id, m_flNextAttack, 1.0, PLAYER_LINUX_XTRA_OFF)

		message_begin(MSG_ONE, gmsgWeaponList, {0,0,0}, id)
		write_string("weapon_plasmagun")
		write_byte(6)
		write_byte(100)
		write_byte(-1)
		write_byte(-1)
		write_byte(0)
		write_byte(13)
		write_byte(CSW_MAC10)
		message_end()
	}
	g_has_plasmagun[id] = true
	g_Reload[id] = false
}

public fw_plasmagun_AddToPlayer(plasmagun, id)
{
	if(!is_valid_ent(plasmagun) || !is_user_connected(id))
		return HAM_IGNORED
	
	if(entity_get_int(plasmagun, EV_INT_WEAPONKEY) == plasmagun_WEAPONKEY)
	{
		g_has_plasmagun[id] = true
		
		entity_set_int(plasmagun, EV_INT_WEAPONKEY, 0)

		message_begin(MSG_ONE, gmsgWeaponList, {0,0,0}, id)
		write_string("weapon_plasmagun")
		write_byte(6)
		write_byte(100)
		write_byte(-1)
		write_byte(-1)
		write_byte(0)
		write_byte(13)
		write_byte(CSW_MAC10)
		message_end()
		
		return HAM_HANDLED
	}
	else
	{
		message_begin(MSG_ONE, gmsgWeaponList, {0,0,0}, id)
		write_string("weapon_mac10")
		write_byte(6)
		write_byte(100)
		write_byte(-1)
		write_byte(-1)
		write_byte(0)
		write_byte(13)
		write_byte(CSW_MAC10)
		message_end()
	}
	return HAM_IGNORED
}

public fw_UseStationary_Post(entity, caller, activator, use_type)
{
	if (use_type == USE_STOPPED && is_user_connected(caller))
		replace_weapon_models(caller, get_user_weapon(caller))
}

public fw_Item_Deploy_Post(weapon_ent)
{
	static owner
	owner = fm_cs_get_weapon_ent_owner(weapon_ent)
	
	static weaponid
	weaponid = cs_get_weapon_id(weapon_ent)
	
	replace_weapon_models(owner, weaponid)
}

public CurrentWeapon(id)
{
     replace_weapon_models(id, read_data(2))

     if(read_data(2) != CSW_MAC10 || !g_has_plasmagun[id])
          return
     
     static Float:iSpeed
     if(g_has_plasmagun[id])
          iSpeed = get_pcvar_float(cvar_spd_plasmagun)
     
     static weapon[32],Ent
     get_weaponname(read_data(2),weapon,31)
     Ent = find_ent_by_owner(-1,weapon,id)
     if(Ent)
     {
          static Float:Delay
          Delay = get_pdata_float( Ent, 46, 4) * iSpeed
          if (Delay > 0.0)
          {
               set_pdata_float(Ent, 46, Delay, 4)
          }
     }
}

replace_weapon_models(id, weaponid)
{
	switch (weaponid)
	{
		case CSW_MAC10:
		{
			
			if(g_has_plasmagun[id])
			{
				set_pev(id, pev_viewmodel2, plasmagun_V_MODEL)
				set_pev(id, pev_weaponmodel2, plasmagun_P_MODEL)
				if(oldweap[id] != CSW_MAC10) 
				{
					set_pdata_float(id, m_flNextAttack, 1.0, PLAYER_LINUX_XTRA_OFF)

					message_begin(MSG_ONE, gmsgWeaponList, {0,0,0}, id)
					write_string("weapon_plasmagun")
					write_byte(6)
					write_byte(100)
					write_byte(-1)
					write_byte(-1)
					write_byte(0)
					write_byte(13)
					write_byte(CSW_MAC10)
					message_end()
				}
			}
		}
	}
	oldweap[id] = weaponid
}

public fw_UpdateClientData_Post(Player, SendWeapons, CD_Handle)
{
	if(!is_user_alive(Player) || (get_user_weapon(Player) != CSW_MAC10 || !g_has_plasmagun[Player]))
		return FMRES_IGNORED
	
	set_cd(CD_Handle, CD_flNextAttack, halflife_time () + 0.001)
	return FMRES_HANDLED
}

public fw_plasmagun_PrimaryAttack(Weapon)
{
	new Player = get_pdata_cbase(Weapon, 41, 4)
	
	if (!g_has_plasmagun[Player])
		return
	
	g_IsInPrimaryAttack = 1
	pev(Player,pev_punchangle,cl_pushangle[Player])
	
	g_clip_ammo[Player] = cs_get_weapon_ammo(Weapon)
}

public fwPlaybackEvent(flags, invoker, eventid, Float:delay, Float:origin[3], Float:angles[3], Float:fparam1, Float:fparam2, iParam1, iParam2, bParam1, bParam2)
{
	if ((eventid != g_orig_event_plasmagun) || !g_IsInPrimaryAttack)
		return FMRES_IGNORED
	if (!(1 <= invoker <= g_MaxPlayers))
    return FMRES_IGNORED

	playback_event(flags | FEV_HOSTONLY, invoker, eventid, delay, origin, angles, fparam1, fparam2, iParam1, iParam2, bParam1, bParam2)
	return FMRES_SUPERCEDE
}

public fw_m4a1drag_PrimaryAttack_Post(Weapon)
{
	g_IsInPrimaryAttack = 0
	new Player = get_pdata_cbase(Weapon, 41, 4)
	
	new szClip, szAmmo
	get_user_weapon(Player, szClip, szAmmo)
	
	if(!is_user_alive(Player))
		return

	if(g_has_plasmagun[Player])
	{
		if (!g_clip_ammo[Player])
			return

		new Float:push[3]
		pev(Player,pev_punchangle,push)
		xs_vec_sub(push,cl_pushangle[Player],push)
		
		xs_vec_mul_scalar(push,get_pcvar_float(cvar_recoil_plasmagun),push)
		xs_vec_add(push,cl_pushangle[Player],push)
		set_pev(Player,pev_punchangle,push)
		
		emit_sound(Player, CHAN_WEAPON, Fire_Sounds[0], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
		UTIL_PlayWeaponAnimation(Player, random_num(plasmagun_SHOOT1, plasmagun_SHOOT2))
	}
}

public fw_TakeDamage(victim, inflictor, attacker)
{
	if (victim != attacker && is_user_connected(attacker))
	{
		if(get_user_weapon(attacker) == CSW_MAC10)
		{
			if(g_has_plasmagun[attacker])
				SetHamParamFloat(4, get_pcvar_float(cvar_dmg_plasmagun))
		}
	}
}

public message_DeathMsg(msg_id, msg_dest, id)
{
	static szTruncatedWeapon[33], iAttacker, iVictim
	
	get_msg_arg_string(4, szTruncatedWeapon, charsmax(szTruncatedWeapon))
	
	iAttacker = get_msg_arg_int(1)
	iVictim = get_msg_arg_int(2)
	
	if(!is_user_connected(iAttacker) || iAttacker == iVictim)
		return PLUGIN_CONTINUE
	
	if(equal(szTruncatedWeapon, "mac10") && get_user_weapon(iAttacker) == CSW_MAC10)
	{
		if(g_has_plasmagun[iAttacker])
			set_msg_arg_string(4, "mac10")
	}
	return PLUGIN_CONTINUE
}

stock fm_cs_get_current_weapon_ent(id)
{
	return get_pdata_cbase(id, OFFSET_ACTIVE_ITEM, OFFSET_LINUX)
}

stock fm_cs_get_weapon_ent_owner(ent)
{
	return get_pdata_cbase(ent, OFFSET_WEAPONOWNER, OFFSET_LINUX_WEAPONS)
}

stock UTIL_PlayWeaponAnimation(const Player, const Sequence)
{
	set_pev(Player, pev_weaponanim, Sequence)
	
	message_begin(MSG_ONE_UNRELIABLE, SVC_WEAPONANIM, .player = Player)
	write_byte(Sequence)
	write_byte(pev(Player, pev_body))
	message_end()
}

public plasmagun_ItemPostFrame(weapon_entity) 
{
     new id = pev(weapon_entity, pev_owner)
     if (!is_user_connected(id))
          return HAM_IGNORED

     if (!g_has_plasmagun[id])
          return HAM_IGNORED

     static iClipExtra
     
     iClipExtra = get_pcvar_num(cvar_clip_plasmagun)
     new Float:flNextAttack = get_pdata_float(id, m_flNextAttack, PLAYER_LINUX_XTRA_OFF)

     new iBpAmmo = cs_get_user_bpammo(id, CSW_MAC10)
     new iClip = get_pdata_int(weapon_entity, m_iClip, WEAP_LINUX_XTRA_OFF)

     new fInReload = get_pdata_int(weapon_entity, m_fInReload, WEAP_LINUX_XTRA_OFF) 

     if( fInReload && flNextAttack <= 0.0 )
     {
	     new j = min(iClipExtra - iClip, iBpAmmo)
	
	     set_pdata_int(weapon_entity, m_iClip, iClip + j, WEAP_LINUX_XTRA_OFF)
	     cs_set_user_bpammo(id, CSW_MAC10, iBpAmmo-j)
		
	     set_pdata_int(weapon_entity, m_fInReload, 0, WEAP_LINUX_XTRA_OFF)
	     fInReload = 0
	     g_Reload[id] = 0
     }
     return HAM_IGNORED
}

public plasmagun_Reload(weapon_entity) 
{
     new id = pev(weapon_entity, pev_owner)
     if (!is_user_connected(id))
          return HAM_IGNORED

     if (!g_has_plasmagun[id])
          return HAM_IGNORED

     static iClipExtra

     if(g_has_plasmagun[id])
          iClipExtra = get_pcvar_num(cvar_clip_plasmagun)

     g_plasmagun_TmpClip[id] = -1

     new iBpAmmo = cs_get_user_bpammo(id, CSW_MAC10)
     new iClip = get_pdata_int(weapon_entity, m_iClip, WEAP_LINUX_XTRA_OFF)

     if (iBpAmmo <= 0)
          return HAM_SUPERCEDE

     if (iClip >= iClipExtra)
          return HAM_SUPERCEDE

     g_plasmagun_TmpClip[id] = iClip

     return HAM_IGNORED
}

public plasmagun_Reload_Post(weapon_entity) 
{
	new id = pev(weapon_entity, pev_owner)
	if (!is_user_connected(id))
		return HAM_IGNORED

	if (!g_has_plasmagun[id])
		return HAM_IGNORED

	if (g_plasmagun_TmpClip[id] == -1)
		return HAM_IGNORED

	set_pdata_int(weapon_entity, m_iClip, g_plasmagun_TmpClip[id], WEAP_LINUX_XTRA_OFF)

	cs_set_user_zoom(id, CS_RESET_ZOOM, 1)

	set_pdata_float(weapon_entity, m_flTimeWeaponIdle, plasmagun_RELOAD_TIME, WEAP_LINUX_XTRA_OFF)

	set_pdata_float(id, m_flNextAttack, plasmagun_RELOAD_TIME, PLAYER_LINUX_XTRA_OFF)

	set_pdata_int(weapon_entity, m_fInReload, 1, WEAP_LINUX_XTRA_OFF)

	UTIL_PlayWeaponAnimation(id, plasmagun_RELOAD)

	g_Reload[id] = 1

	return HAM_IGNORED
}

public fw_plasmagun_Holster_Post(weapon_entity)
{
	static Player
	Player = get_pdata_cbase(weapon_entity, OFFSET_WEAPONOWNER, OFFSET_LINUX_WEAPONS)
	
	g_flNextUseTime[Player] = 0.0

	if(g_has_plasmagun[Player])
	{
		cs_set_user_zoom(Player, CS_RESET_ZOOM, 1)
	}
}

stock drop_weapons(id, dropwhat)
{
     static weapons[32], num, i, weaponid
     num = 0
     get_user_weapons(id, weapons, num)
     
     for (i = 0; i < num; i++)
     {
          weaponid = weapons[i]
          
          if (dropwhat == 1 && ((1<<weaponid) & PRIMARY_WEAPONS_BIT_SUM))
          {
               static wname[32]
               get_weaponname(weaponid, wname, sizeof wname - 1)
               engclient_cmd(id, "drop", wname)
          }
     }
}

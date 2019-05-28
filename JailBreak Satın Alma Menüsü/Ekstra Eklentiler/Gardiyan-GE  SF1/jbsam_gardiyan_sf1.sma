#include <amxmodx>
#include <engine>
#include <fakemeta>
#include <fun>
#include <hamsandwich>
#include <xs>
#include <cstrike>
#include <jbsam>

#define ENG_NULLENT		-1
#define EV_INT_WEAPONKEY	EV_INT_impulse
#define SF1_WEAPONKEY 46573
#define MAX_PLAYERS  			  32
const USE_STOPPED = 0
const OFFSET_ACTIVE_ITEM = 373
const OFFSET_WEAPONOWNER = 41
const OFFSET_LINUX = 5
const OFFSET_LINUX_WEAPONS = 4
#define WEAP_LINUX_XTRA_OFF			4
#define m_fKnown				44
#define m_flNextPrimaryAttack 			46
#define m_flTimeWeaponIdle			48
#define m_iClip					51
#define m_fInReload				54
#define PLAYER_LINUX_XTRA_OFF			5
#define m_flNextAttack				83

#define PRAVA ADMIN_RESERVATION

#define SF1_RELOAD_TIME 3.7
const PRIMARY_WEAPONS_BIT_SUM = 
(1<<CSW_SCOUT)|(1<<CSW_XM1014)|(1<<CSW_MAC10)|(1<<CSW_AUG)|(1<<CSW_UMP45)|(1<<CSW_SG550)|(1<<CSW_FAMAS)|(1<<CSW_AWP)|(1<<
CSW_MP5NAVY)|(1<<CSW_M249)|(1<<CSW_M3)|(1<<CSW_M4A1)|(1<<CSW_TMP)|(1<<CSW_G3SG1)|(1<<CSW_SG552)|(1<<CSW_AK47)|(1<<CSW_P90)
new const WEAPONENTNAMES[][] = { "", "weapon_p228", "", "weapon_scout", "weapon_hegrenade", "weapon_xm1014", "weapon_c4", "weapon_mac10",
	"weapon_aug", "weapon_smokegrenade", "weapon_elite", "weapon_fiveseven", "weapon_ump45", "weapon_sg550",
	"weapon_ump45", "weapon_famas", "weapon_usp", "weapon_glock18", "weapon_awp", "weapon_mp5navy", "weapon_m249",
	"weapon_m3", "weapon_m4a1", "weapon_tmp", "weapon_g3sg1", "weapon_flashbang", "weapon_deagle", "weapon_sg552",
"weapon_ak47", "weapon_knife", "weapon_p90" }

new const Sound_Fire[][] = { "weapons/sf1-1.wav" }
new const GUNSHOT_DECALS[] = { 41, 42, 43, 44, 45 }
new SF1_V_MODEL[64]  = "models/v_sf1.mdl"
new SF1_P_MODEL[64] = "models/p_sf1.mdl"
new SF1_W_MODEL[64] = "models/w_sf1.mdl"
new cvar_dmg_SF1, cvar_recoil_SF1, g_itemid_SF1, cvar_clip_SF1, cvar_spd_SF1, cvar_SF1_ammo
new g_has_SF1[33], g_MaxPlayers, Float:cl_pushangle[MAX_PLAYERS + 1][3], m_iBlood[2],
g_orig_event_SF1, g_IsInPrimaryAttack, g_clip_ammo[33], g_SF1_TmpClip[33]
new cvar_sf1_parasi
new sf1esya

public plugin_init()
{
	register_plugin("SF-1 Smg bullpup", "1.0", "Faktor/Opo4uMapy")
	register_message(get_user_msgid("DeathMsg"), "message_DeathMsg")
	register_event("CurWeapon","CurrentWeapon","be","1=1")
	RegisterHam(Ham_Item_AddToPlayer, "weapon_ump45", "fw_Aug_AddToPlayer")
	RegisterHam(Ham_Use, "func_tank", "fw_UseStationary_Post", 1)
	RegisterHam(Ham_Use, "func_tankmortar", "fw_UseStationary_Post", 1)
	RegisterHam(Ham_Use, "func_tankrocket", "fw_UseStationary_Post", 1)
	RegisterHam(Ham_Use, "func_tanklaser", "fw_UseStationary_Post", 1)
	for (new i = 1; i < sizeof WEAPONENTNAMES; i++)
		if (WEAPONENTNAMES[i][0]) RegisterHam(Ham_Item_Deploy, WEAPONENTNAMES[i], "fw_Item_Deploy_Post", 1)
	RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_ump45", "fw_Aug_PrimaryAttack")
	RegisterHam(Ham_Weapon_PrimaryAttack, "weapon_ump45", "fw_Aug_PrimaryAttack_Post", 1)
	RegisterHam(Ham_TakeDamage, "player", "fw_TakeDamage")
	RegisterHam(Ham_Item_PostFrame, "weapon_ump45", "SF1__ItemPostFrame");
	RegisterHam(Ham_Weapon_Reload, "weapon_ump45", "SF1__Reload");
	RegisterHam(Ham_Weapon_Reload, "weapon_ump45", "SF1__Reload_Post", 1);
	register_forward(FM_SetModel, "fw_SetModel")
	register_forward(FM_UpdateClientData, "fw_UpdateClientData_Post", 1)
	register_forward(FM_PlaybackEvent, "fwPlaybackEvent")
	register_forward(FM_CmdStart, "fw_CmdStart")
	
	cvar_dmg_SF1 = register_cvar("zp_SF1_dmg", "2.75")
	cvar_recoil_SF1 = register_cvar("zp_SF1_recoil", "0.6")           
	cvar_clip_SF1 = register_cvar("zp_SF1_clip", "35")
	cvar_spd_SF1 = register_cvar("zp_SF1_spd", "0.7")
	cvar_SF1_ammo = register_cvar("zp_SF1_ammo", "240")
	cvar_sf1_parasi = register_cvar("jbsam_sf1_ucret","60")
	sf1esya = jbsam_esya_gir("SF1 Silahi", get_pcvar_num(cvar_sf1_parasi), "Keskin Vurus", GARDIYAN)
	g_MaxPlayers = get_maxplayers()
}

public plugin_precache()
{
	precache_model(SF1_V_MODEL)
	precache_model(SF1_P_MODEL)
	precache_model(SF1_W_MODEL)
	for(new i = 0; i < sizeof Sound_Fire; i++)
		precache_sound(Sound_Fire[i])
	precache_sound("weapons/sfsmg_clipin1.wav")
	precache_sound("weapons/sfsmg_clipin2.wav")
	precache_sound("weapons/sfsmg_clipout1.wav")
	precache_sound("weapons/sfsmg_draw.wav")
	m_iBlood[0] = precache_model("sprites/blood.spr")
	m_iBlood[1] = precache_model("sprites/bloodspray.spr")
	
	register_forward(FM_PrecacheEvent, "fwPrecacheEvent_Post", 1)
}

public fwPrecacheEvent_Post(type, const name[])
{
	if (equal("events/ump45.sc", name))
	{
		g_orig_event_SF1 = get_orig_retval()
		return FMRES_HANDLED
	}
	
	return FMRES_IGNORED
}

public client_connect(id)
{
	g_has_SF1[id] = false
}

public client_disconnect(id)
{
	g_has_SF1[id] = false
}

public fw_SetModel(entity, model[])
{
	if(!is_valid_ent(entity))
		return FMRES_IGNORED;
	
	static szClassName[33]
	entity_get_string(entity, EV_SZ_classname, szClassName, charsmax(szClassName))
	
	if(!equal(szClassName, "weaponbox"))
		return FMRES_IGNORED;
	
	static iOwner
	
	iOwner = entity_get_edict(entity, EV_ENT_owner)
	
	if(equal(model, "models/w_ump45.mdl"))
	{
		static iStoredAugID
		
		iStoredAugID = find_ent_by_owner(ENG_NULLENT, "weapon_ump45", entity)
		
		if(!is_valid_ent(iStoredAugID))
			return FMRES_IGNORED;
		
		if(g_has_SF1[iOwner])
		{
			entity_set_int(iStoredAugID, EV_INT_WEAPONKEY, SF1_WEAPONKEY)
			
			g_has_SF1[iOwner] = false
			
			entity_set_model(entity, SF1_W_MODEL)
			
			return FMRES_SUPERCEDE;
		}
	}
	
	return FMRES_IGNORED;
}

public jbsam_esya_sec(id, item){
	if(item != sf1esya)
		return PLUGIN_HANDLED
	new itemid
	give_sf1(id, itemid)
	
	return PLUGIN_CONTINUE
}

public give_sf1(id, itemid)
{
	if(itemid == g_itemid_SF1)
	{
		drop_weapons(id, 1);
		new iWep2 = give_item(id,"weapon_ump45")
		if( iWep2 > 0 )
		{
			cs_set_weapon_ammo( iWep2, get_pcvar_num(cvar_clip_SF1) )
			cs_set_user_bpammo (id, CSW_UMP45, get_pcvar_num(cvar_SF1_ammo))
			UTIL_PlayWeaponAnimation(id, 2)
		}
		g_has_SF1[id] = true;
	}
}

public fw_Aug_AddToPlayer(Aug, id)
{
	if(!is_valid_ent(Aug) || !is_user_connected(id))
		return HAM_IGNORED;
	
	if(entity_get_int(Aug, EV_INT_WEAPONKEY) == SF1_WEAPONKEY)
	{
		g_has_SF1[id] = true
		
		entity_set_int(Aug, EV_INT_WEAPONKEY, 0)
		
		return HAM_HANDLED;
	}
	
	return HAM_IGNORED;
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
	
	if(read_data(2) != CSW_UMP45 || !g_has_SF1[id])
		return
	
	static Float:iSpeed
	if(g_has_SF1[id])
		iSpeed = get_pcvar_float(cvar_spd_SF1)
	
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
		case CSW_UMP45:
		{
			
			if(g_has_SF1[id])
			{
				set_pev(id, pev_viewmodel2, SF1_V_MODEL)
				set_pev(id, pev_weaponmodel2, SF1_P_MODEL)
			}
		}
	}
}

public fw_UpdateClientData_Post(Player, SendWeapons, CD_Handle)
{
	if(!is_user_alive(Player) || (get_user_weapon(Player) != CSW_UMP45 || !g_has_SF1[Player]))
		
	return FMRES_IGNORED
	
	set_cd(CD_Handle, CD_flNextAttack, halflife_time () + 0.001)
	return FMRES_HANDLED
}

public fw_Aug_PrimaryAttack(Weapon)
{
	new Player = get_pdata_cbase(Weapon, 41, 4)
	
	if (!g_has_SF1[Player])
		return;
	
	g_IsInPrimaryAttack = 1
	pev(Player,pev_punchangle,cl_pushangle[Player])
	
	g_clip_ammo[Player] = cs_get_weapon_ammo(Weapon)
}

public fwPlaybackEvent(flags, invoker, eventid, Float:delay, Float:origin[3], Float:angles[3], Float:fparam1, Float:fparam2, iParam1, iParam2, bParam1, bParam2)
{
	if ((eventid != g_orig_event_SF1) || !g_IsInPrimaryAttack)
		return FMRES_IGNORED
	if (!(1 <= invoker <= g_MaxPlayers))
		return FMRES_IGNORED
	
	playback_event(flags | FEV_HOSTONLY, invoker, eventid, delay, origin, angles, fparam1, fparam2, iParam1, iParam2, bParam1, bParam2)
	return FMRES_SUPERCEDE
}

public fw_Aug_PrimaryAttack_Post(Weapon)
{
	g_IsInPrimaryAttack = 0
	new Player = get_pdata_cbase(Weapon, 41, 4)
	
	if(g_has_SF1[Player])
	{
		new Float:push[3]
		pev(Player,pev_punchangle,push)
		xs_vec_sub(push,cl_pushangle[Player],push)
		
		xs_vec_mul_scalar(push,get_pcvar_float(cvar_recoil_SF1),push)
		xs_vec_add(push,cl_pushangle[Player],push)
		set_pev(Player,pev_punchangle,push)
		
		if (!g_clip_ammo[Player])
			return
		
		emit_sound(Player, CHAN_WEAPON, Sound_Fire[0], VOL_NORM, ATTN_NORM, 0, PITCH_NORM)
		UTIL_PlayWeaponAnimation(Player, random_num(3, 4))
		
		make_blood_and_bulletholes(Player)
	}
}

public fw_TakeDamage(victim, inflictor, attacker, Float:damage)
{
	if (victim != attacker && is_user_connected(attacker))
	{
		if(get_user_weapon(attacker) == CSW_UMP45)
		{
			if(g_has_SF1[attacker])
				SetHamParamFloat(4, damage * get_pcvar_float(cvar_dmg_SF1))
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
	
	if(equal(szTruncatedWeapon, "ump45") && get_user_weapon(iAttacker) == CSW_UMP45)
	{
		if(g_has_SF1[iAttacker])
			set_msg_arg_string(4, "SF1")
	}
	
	return PLUGIN_CONTINUE
}

stock fm_cs_get_current_weapon_ent(id)
{
	return get_pdata_cbase(id, OFFSET_ACTIVE_ITEM, OFFSET_LINUX);
}

stock fm_cs_get_weapon_ent_owner(ent)
{
	return get_pdata_cbase(ent, OFFSET_WEAPONOWNER, OFFSET_LINUX_WEAPONS);
}

stock UTIL_PlayWeaponAnimation(const Player, const Sequence)
{
	set_pev(Player, pev_weaponanim, Sequence)
	
	message_begin(MSG_ONE_UNRELIABLE, SVC_WEAPONANIM, .player = Player)
	write_byte(Sequence)
	write_byte(pev(Player, pev_body))
	message_end()
}

stock make_blood_and_bulletholes(id)
{
	new aimOrigin[3], target, body
	get_user_origin(id, aimOrigin, 3)
	get_user_aiming(id, target, body)
	
	if(target > 0 && target <= g_MaxPlayers)
	{
		new Float:fStart[3], Float:fEnd[3], Float:fRes[3], Float:fVel[3]
		pev(id, pev_origin, fStart)
		
		velocity_by_aim(id, 64, fVel)
		
		fStart[0] = float(aimOrigin[0])
		fStart[1] = float(aimOrigin[1])
		fStart[2] = float(aimOrigin[2])
		fEnd[0] = fStart[0]+fVel[0]
		fEnd[1] = fStart[1]+fVel[1]
		fEnd[2] = fStart[2]+fVel[2]
		
		new res
		engfunc(EngFunc_TraceLine, fStart, fEnd, 0, target, res)
		get_tr2(res, TR_vecEndPos, fRes)
		
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY) 
		write_byte(TE_BLOODSPRITE)
		write_coord(floatround(fStart[0])) 
		write_coord(floatround(fStart[1])) 
		write_coord(floatround(fStart[2])) 
		write_short( m_iBlood [ 1 ])
		write_short( m_iBlood [ 0 ] )
		write_byte(70)
		write_byte(random_num(1,2))
		message_end()
		
		
	} 
	else if(!is_user_connected(target))
	{
		if(target)
		{
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
			write_byte(TE_DECAL)
			write_coord(aimOrigin[0])
			write_coord(aimOrigin[1])
			write_coord(aimOrigin[2])
			write_byte(GUNSHOT_DECALS[random_num ( 0, sizeof GUNSHOT_DECALS -1 ) ] )
			write_short(target)
			message_end()
		} 
		else 
		{
			message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
			write_byte(TE_WORLDDECAL)
			write_coord(aimOrigin[0])
			write_coord(aimOrigin[1])
			write_coord(aimOrigin[2])
			write_byte(GUNSHOT_DECALS[random_num ( 0, sizeof GUNSHOT_DECALS -1 ) ] )
			message_end()
		}
		
		message_begin(MSG_BROADCAST, SVC_TEMPENTITY)
		write_byte(TE_GUNSHOTDECAL)
		write_coord(aimOrigin[0])
		write_coord(aimOrigin[1])
		write_coord(aimOrigin[2])
		write_short(id)
		write_byte(GUNSHOT_DECALS[random_num ( 0, sizeof GUNSHOT_DECALS -1 ) ] )
		message_end()
	}
}

public SF1__ItemPostFrame(weapon_entity) 
{
	new id = pev(weapon_entity, pev_owner)
	if (!is_user_connected(id))
		return HAM_IGNORED;
	
	if (!g_has_SF1[id])
		return HAM_IGNORED;
	
	static iClipExtra
	
	if(g_has_SF1[id])
		iClipExtra = get_pcvar_num(cvar_clip_SF1)
	
	new Float:flNextAttack = get_pdata_float(id, m_flNextAttack, PLAYER_LINUX_XTRA_OFF)
	
	new iBpAmmo = cs_get_user_bpammo(id, CSW_UMP45);
	new iClip = get_pdata_int(weapon_entity, m_iClip, WEAP_LINUX_XTRA_OFF)
	
	new fInReload = get_pdata_int(weapon_entity, m_fInReload, WEAP_LINUX_XTRA_OFF) 
	
	if( fInReload && flNextAttack <= 0.0 )
	{
		new j = min(iClipExtra - iClip, iBpAmmo)
		
		set_pdata_int(weapon_entity, m_iClip, iClip + j, WEAP_LINUX_XTRA_OFF)
		cs_set_user_bpammo(id, CSW_UMP45, iBpAmmo-j);
		
		set_pdata_int(weapon_entity, m_fInReload, 0, WEAP_LINUX_XTRA_OFF)
		fInReload = 0
	}
	
	return HAM_IGNORED;
}

public SF1__Reload(weapon_entity) 
{
	new id = pev(weapon_entity, pev_owner)
	if (!is_user_connected(id))
		return HAM_IGNORED;
	
	if (!g_has_SF1[id])
		return HAM_IGNORED;
	
	static iClipExtra
	
	if(g_has_SF1[id])
		iClipExtra = get_pcvar_num(cvar_clip_SF1)
	
	g_SF1_TmpClip[id] = -1;
	
	new iBpAmmo = cs_get_user_bpammo(id, CSW_UMP45);
	new iClip = get_pdata_int(weapon_entity, m_iClip, WEAP_LINUX_XTRA_OFF)
	
	if (iBpAmmo <= 0)
		return HAM_SUPERCEDE;
	
	if (iClip >= iClipExtra)
		return HAM_SUPERCEDE;
	
	
	g_SF1_TmpClip[id] = iClip;
	
	return HAM_IGNORED;
}

public SF1__Reload_Post(weapon_entity) 
{
	new id = pev(weapon_entity, pev_owner)
	if (!is_user_connected(id))
		return HAM_IGNORED;
	
	if (!g_has_SF1[id])
		return HAM_IGNORED;
	
	if (g_SF1_TmpClip[id] == -1)
		return HAM_IGNORED;
	
	static Float:iReloadTime
	if(g_has_SF1[id])
		iReloadTime = SF1_RELOAD_TIME
	
	set_pdata_int(weapon_entity, m_iClip, g_SF1_TmpClip[id], WEAP_LINUX_XTRA_OFF)
	
	set_pdata_float(weapon_entity, m_flTimeWeaponIdle, iReloadTime, WEAP_LINUX_XTRA_OFF)
	
	set_pdata_float(id, m_flNextAttack, iReloadTime, PLAYER_LINUX_XTRA_OFF)
	
	set_pdata_int(weapon_entity, m_fInReload, 1, WEAP_LINUX_XTRA_OFF)
	
	UTIL_PlayWeaponAnimation(id, 1)
	
	return HAM_IGNORED;
	
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
//// Ыᤨ롧妫᩠misna 嬿 򡪲ힹ���ower-cs.ru 
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1049\\ f0\\ fs16 \n\\ par }
*/

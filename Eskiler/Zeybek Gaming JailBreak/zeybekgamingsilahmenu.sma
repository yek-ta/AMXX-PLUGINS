#include <amxmodx>
#include <cstrike>
#include <engine>
#include <fakemeta>
#include <fun>
#include <hamsandwich>
#include <xs>

// Models
new const g_szModelSalamanderP[ ] = "models/p_flamethrower.mdl"
new const g_szModelSalamanderV[ ] = "models/v_flamethrower.mdl"
new const g_szModelSalamanderW[ ] = "models/w_flamethrower.mdl"

// Fire sound
new const g_szSoundFlamethrowerFire[ ] = "weapons/flamegun-1.wav"

// Sprites
new const g_szSpriteFireBlast[ ] = "sprites/flame_puff01.spr"

// Flame velocity
const g_iFlameVelocity = 900

// FLamethower damage
const Float:g_flFlamethrowerDamage = 35.0

// Flamethrower fly distance
const Float:g_flFlamethowerDistance = 900.0

// Clip
#define SALAMANDER_CLIP 100

// BP ammo
#define SALAMANDER_BPAMMO 200

// Deploy anim id
#define ANIM_SHOOT			1
#define ANIM_SHOOT_AFTER	2
#define ANIM_RELOAD			3
#define ANIM_DEPLOY			4

new const BUYAMMO[] = 
{ 
	//	0   1	2   3   4   5   6 ....
	-1, 13, -1, 30, -1, 4, -1, 12, 30, -1, 30, 50, 12, 30, 
	100,
	30, 12, 30, 1, 30, 30, 8, 30, 30, 30, -1, 7, 30, 30, -1, 50 
}

new const MAXBPAMMO[] = 
{ 
	-1, 52, -1, 90, 1, 64,  1, 100, 90, 1, 90, 100, 100, 90, 
	200,
	90, 100, 120, 5, 120, 200, 32, 90, 120, 90, 2, 35, 90, 90, -1, 100 
}

// Weapon kill name
new const g_szKillName[ ]		= "flamethrower"
new tesilahmenu
///================================================
/// 		Customization end		///
///================================================
new Float:g_flTimeWeaponIdle[33]
new Float:g_flLastShotTime[33]
new Float:g_flNextSoundTime[33]
new Float:g_flTimeUpdate[33]
new bool:g_fHasSalamander[33]
new bool:g_fHoldingSalamander[33]
new bool:g_fUsingFlamethrower[33]

const PRIMARY_WEAPONS_BITSUM = (1<<CSW_SCOUT)|(1<<CSW_XM1014)|(1<<CSW_MAC10)|(1<<CSW_AUG)|(1<<CSW_UMP45)|(1<<CSW_SG550)|(1<<CSW_GALIL)|(1<<CSW_FAMAS)|(1<<CSW_AWP)|(1<<CSW_MP5NAVY)|(1<<CSW_M249)|(1<<CSW_M3)|(1<<CSW_M4A1)|(1<<CSW_TMP)|(1<<CSW_G3SG1)|(1<<CSW_SG552)|(1<<CSW_AK47)|(1<<CSW_P90)
const SALAMANDER_WKEY = 192616

new g_iMaxPlayers
new g_bsIsAlive
new g_bsIsConnected
new gmsgAmmoPickup
new g_iFlameBlastSpr

const m_flNextPrimaryAttack 		= 46
const m_flNextSecondaryAttack 	= 47
const m_flTimeWeaponIdle 		= 48
const m_iClip 					= 51
const m_fInReload 				= 54
const m_flNextAttack 			= 83
const m_rgAmmo_player_Slot0 	= 376

new const g_szClassFlamethrowerFlame[ ] = "env_flamethrower_fire"
// Weapon ammo ID's
new const AMMOID[] = 
{ 
	-1, 9, -1, 2, 12, 5, 14, 6, 4, 13, 10, 7, 6, 4, 4, 4, 6, 10, 1, 10, 3, 5, 4, 10, 
	2, 11, 8, 4, 2, -1, 7 
}

enum (<<=1) 
{ 
	v_angle = 1, 
	punchangle 
}

#define pev_startposition		pev_vuser1

#define IsPlayer(%0)			(1 <= %0 <= g_iMaxPlayers)
#define IsPrivateDataValid(%0)	(pev_valid( %0 ) == 2)
#define IsAlive(%0)			(1 <= %0 <= g_iMaxPlayers && (g_bsIsAlive & (1 << %0)))
#define IsConnected(%0)		(1 <= %0 <= g_iMaxPlayers && (g_bsIsConnected & (1 << %0)))
#define VectorAdd(%0,%1,%2)		( %2[0] = %0[0] + %1[0], %2[1] = %0[1] + %1[1], %2[2] = %0[2] + %1[2])

public plugin_precache()
{
	precache_model(g_szModelSalamanderV)
	precache_model(g_szModelSalamanderP)
	precache_model(g_szModelSalamanderW)
	precache_sound(g_szSoundFlamethrowerFire)
	g_iFlameBlastSpr = precache_model(g_szSpriteFireBlast)
}

public plugin_init( )
{
	register_plugin("AtesPuskurtenli Silah Menu", "1.0", "CSmiLeFaCe")
	
	
	register_clcmd("buyammo1", "fw_BuyAmmo")
	register_clcmd("buyammo2", "fw_BuyAmmo")
	
	register_event("DeathMsg", "EV_DeathMsg", "a", "1=0", "2=0")
	register_event("TextMsg", "EV_GameRestart", "a", "2=#Game_Commencing", "2=#Game_will_restart_in")
	
	register_forward(FM_SetModel, "fw_SetModel")
	register_forward(FM_PlayerPreThink, "fw_PlayerPreThink")
	register_forward(FM_CmdStart, "fw_CmdStart")
	register_forward(FM_UpdateClientData, "fw_UpdateClientData_Post", 1)
	RegisterHam(Ham_Spawn, "player", "fw_PlayerSpawn_Post", 1)
	RegisterHam(Ham_Item_Deploy, "weapon_galil", "fw_SalamanderDeploy_Post", 1)
	RegisterHam(Ham_Item_AddToPlayer, "weapon_galil", "fw_SalamanderAddToPlayer")
	RegisterHam(Ham_Item_Holster, "weapon_galil", "fw_SalamanderHolster_Post", 1)
	RegisterHam(Ham_Item_PostFrame, "weapon_galil", "fw_SalamanderPostFrame")
	RegisterHam(Ham_Weapon_Reload, "weapon_galil", "fw_SalamanderReload")
	RegisterHam(Ham_Spawn, 		"player", "silahmenu",	1)
	register_think(g_szClassFlamethrowerFlame, "fw_FlameThink")
	register_touch(g_szClassFlamethrowerFlame, "*", "fw_FlameTouch")
	tesilahmenu 		= register_cvar("jb_tesilahmenu", 		"0") 
	register_message(get_user_msgid("DeathMsg"), "fw_DeathMsg")
	register_clcmd("silahinisec", "zeybekgamingnet")
	gmsgAmmoPickup = get_user_msgid("AmmoPickup")
	register_clcmd("pukka","ver")
	g_iMaxPlayers = get_maxplayers()
}

public ver(Player, pItem){
	if (is_user_alive(Player) && get_user_team(Player) == 2)
	{
		zp_extra_item_selected(Player, pItem)
	}
	if (get_pcvar_num(tesilahmenu) && is_user_alive(Player) && get_user_team(Player) == 1)
	{
		zp_extra_item_selected(Player, pItem)
	}
}

public client_putinserver(Player)
{
	g_bsIsAlive &= ~(1 << Player)
	g_bsIsConnected |= (1 << Player)
}

public client_disconnect(Player)
{
	g_bsIsAlive &= ~(1 << Player)
	g_bsIsConnected &= ~(1 << Player)
}

public zp_extra_item_selected(Player, pItem)
{
	UTIL_DropWeapons(Player)
	
	g_fHasSalamander[Player] = true
	give_item(Player, "weapon_galil")
	
	new pWeapon = find_ent_by_owner(-1, "weapon_galil", Player)
	
	if(pWeapon)
		cs_set_weapon_ammo(pWeapon, SALAMANDER_CLIP)	
	cs_set_user_bpammo(Player, CSW_GALIL, SALAMANDER_BPAMMO)	
	return PLUGIN_CONTINUE
}

public fw_BuyAmmo(Player)
{
	if(!IsAlive(Player))
		return PLUGIN_CONTINUE
	
	if(!g_fHasSalamander[Player])
		return PLUGIN_CONTINUE	
	
	
	// Get players weapons
	static weapons[32], num, i, currentammo, weaponid, refilled
	num = 0 // reset passed weapons count (bugfix)
	refilled = false
	get_user_weapons(Player, weapons, num)
	
	// Loop through them and give the right ammo type
	for(i = 0; i < num; i++)
	{
		// Prevents re-indexing the array
		weaponid = weapons[i]
		
		// Primary and secondary only
		if(MAXBPAMMO[weaponid] > 2)
		{
			// Get current ammo of the weapon
			currentammo = cs_get_user_bpammo(Player, weaponid)
			
			// Check if we are close to the BP ammo limit
			if (currentammo < MAXBPAMMO[weaponid]-BUYAMMO[weaponid])
			{
				// Flash ammo in hud
				message_begin(MSG_ONE_UNRELIABLE, gmsgAmmoPickup, _, Player)
				write_byte(AMMOID[weaponid]) // ammo id
				write_byte(BUYAMMO[weaponid]) // ammo amount
				message_end()
				
				// Increase BP ammo
				cs_set_user_bpammo (Player, weaponid, currentammo + BUYAMMO[weaponid])
				
				refilled = true
			}
			else if (currentammo < MAXBPAMMO[weaponid])
			{
				// Flash ammo in hud
				message_begin(MSG_ONE_UNRELIABLE, gmsgAmmoPickup, _, Player)
				write_byte(AMMOID[weaponid]) // ammo id
				write_byte(MAXBPAMMO[weaponid]-currentammo) // ammo amount
				message_end()
				
				// Reached the limit
				cs_set_user_bpammo ( Player, weaponid, MAXBPAMMO[weaponid])
				
				refilled = true
			}
		}
	}
	// Weapons already have full ammo
	if (!refilled) return PLUGIN_HANDLED
	
	// Deduce ammo packs, play clip purchase sound, and notify the player
	engfunc(EngFunc_EmitSound, Player, CHAN_ITEM, "items/9mmclip1.wav", 1.0, ATTN_NORM, 0, PITCH_NORM)
	
	return PLUGIN_HANDLED	
}

public EV_DeathMsg()
{
	static pevVictim; pevVictim = read_data(2)
	
	if(!IsConnected(pevVictim))
		return
	
	g_bsIsAlive &= ~(1 << pevVictim)	
}

public EV_GameRestart()
{
	arrayset(g_fHasSalamander, false, sizeof(g_fHasSalamander))
}

public fw_SetModel(pEnt, const pszModel[])
{
	if(!pev_valid(pEnt))
		return FMRES_IGNORED
	
	if(!equal(pszModel, "models/w_galil.mdl"))
		return FMRES_IGNORED
	
	static szClassname[32]
	pev(pEnt, pev_classname, szClassname, charsmax(szClassname))
	
	if(!equal(szClassname, "weaponbox"))
		return FMRES_IGNORED
	
	static iOwner; iOwner = pev(pEnt, pev_owner)
	
	static iWeaponID; iWeaponID = find_ent_by_owner(-1, "weapon_galil", pEnt)
	
	if(g_fHasSalamander[iOwner] && is_valid_ent(iWeaponID))
	{
		set_pev(iWeaponID, pev_impulse, SALAMANDER_WKEY)
		g_fHasSalamander[iOwner] = false
		engfunc(EngFunc_SetModel, pEnt, g_szModelSalamanderW)
		return FMRES_SUPERCEDE
	}
	return FMRES_IGNORED
}

public fw_PlayerPreThink(Player)
{
	if(!IsAlive(Player) || !g_fHasSalamander[Player] || !g_fHoldingSalamander[Player])
		return
	
	static Float:tTime; tTime = get_gametime()
	
	if(g_fUsingFlamethrower[Player] && (tTime - g_flLastShotTime[Player] > 0.15))
	{
		g_fUsingFlamethrower[Player] = false
		SendWeaponAnim(Player, ANIM_SHOOT_AFTER)
	}
	
	if(g_flTimeWeaponIdle[ Player ] > tTime)
		return
	
	SendWeaponAnim(Player, 0)
	g_flTimeWeaponIdle[Player] = tTime + random_float(10.0, 15.0)	
}

public fw_CmdStart(Player, UC_Handle, Seed)
{
	if(!IsAlive(Player) || !g_fHasSalamander[Player] || !g_fHoldingSalamander[Player])
		return FMRES_IGNORED
	
	static bsButtons, Float:tTime
	bsButtons = get_uc(UC_Handle, UC_Buttons)
	
	if(bsButtons & IN_ATTACK)
	{
		bsButtons &= ~IN_ATTACK
		set_uc(UC_Handle, UC_Buttons, bsButtons)
		
		tTime = get_gametime()
		
		if(tTime - g_flLastShotTime[Player] < 0.15)
			return FMRES_IGNORED
		
		CFlamethrower__PrimaryAttack( Player)	
		g_flLastShotTime[Player] = tTime
		g_flTimeWeaponIdle[Player] = tTime + 5.0
	}
	return FMRES_HANDLED
}

public fw_UpdateClientData_Post(Player, SendWeapons, CD_Handle)
{
	if(!IsAlive(Player) || !g_fHasSalamander[Player] || !g_fHoldingSalamander[Player])
		return FMRES_IGNORED
	
	set_cd(CD_Handle, CD_flNextAttack, halflife_time() + 0.001)
	return FMRES_HANDLED
}

public fw_PlayerSpawn_Post(Player)
{
	if(!is_user_alive(Player))
		return
	
	g_bsIsAlive |= (1 << Player)	
}

public fw_SalamanderDeploy_Post(pWeapon)
{
	static Player; Player = get_pdata_cbase(pWeapon, 41, 4)
	
	if(!IsPrivateDataValid(Player))
		return
	
	if(g_fHasSalamander[Player])
	{
		g_fHoldingSalamander[Player] = true
		
		set_pev(Player, pev_viewmodel2, g_szModelSalamanderV)
		set_pev(Player, pev_weaponmodel2, g_szModelSalamanderP)
		SendWeaponAnim(Player, ANIM_DEPLOY)
		
		set_pdata_float(pWeapon, m_flTimeWeaponIdle, 9999.0, 4)
		
		new Float:tTime = get_gametime()
		
		g_fUsingFlamethrower[Player] = false
		g_flTimeWeaponIdle[Player] = tTime + 1.0
	}
}

public fw_SalamanderAddToPlayer(pEnt, Player)
{
	if(pev_valid(pEnt) && IsConnected(Player))
	{
		if(pev(pEnt, pev_impulse) == SALAMANDER_WKEY)
		{
			g_fHasSalamander[Player] = true
			
			set_pev(pEnt, pev_impulse, 0)
			return HAM_HANDLED
		}
	}
	return HAM_HANDLED
}

public fw_SalamanderHolster_Post(pEnt)
{
	static Player; Player = get_pdata_cbase(pEnt, 41, 4)
	
	if(!IsPrivateDataValid(Player))
		return
	
	if(g_fHasSalamander[Player])
	{	
		g_fHoldingSalamander[Player] = false	
		g_fUsingFlamethrower[Player] = false
	}
}

public fw_SalamanderPostFrame(pWeapon)
{
	static Player; Player = get_pdata_cbase(pWeapon, 41, 4)
	
	if(!IsPrivateDataValid(Player))
		return HAM_IGNORED
	
	if(g_fHasSalamander[Player])
	{	
		static fInReload;
		fInReload = get_pdata_int(pWeapon, m_fInReload, 4)
		
		static Float:flNextAttack; flNextAttack = get_pdata_float(Player, m_flNextAttack, 5)
		
		static iClip; iClip = get_pdata_int(pWeapon, m_iClip, 4)
		
		static iBpAmmo; iBpAmmo = cs_get_user_bpammo(Player, CSW_GALIL)
		
		if(fInReload && flNextAttack <= 0.0)
		{
			static j; j = min(SALAMANDER_CLIP - iClip, iBpAmmo)
			
			set_pdata_int(pWeapon, m_iClip, iClip + j, 4)
			cs_set_user_bpammo(Player, CSW_GALIL, iBpAmmo - j)
			set_pdata_int (pWeapon, m_fInReload, 0, 4)
			fInReload = 0
			return HAM_IGNORED
		}
		static iButton; iButton = pev(Player, pev_button)
		
		if((iButton & IN_ATTACK2 && get_pdata_float(pWeapon, m_flNextSecondaryAttack, 4) <= 0.0)
		|| (iButton & IN_ATTACK && get_pdata_float(pWeapon, m_flNextPrimaryAttack, 4) <= 0.0))
		{
			return HAM_IGNORED
		}
		
		if(iButton & IN_RELOAD && !fInReload)
		{
			if(iClip >= SALAMANDER_CLIP)
			{
				set_pev(Player, pev_button, iButton & ~IN_RELOAD)
				SendWeaponAnim(Player, 0)
			}
			else
			{
				if(!iBpAmmo)
					return HAM_IGNORED
				
				g_fUsingFlamethrower[Player] = false	
				
				set_pdata_int(pWeapon, m_fInReload, 1, 4)
				set_pdata_float(Player, m_flNextAttack, 5.3, 5)
				set_pdata_float(pWeapon, m_flTimeWeaponIdle, 9999.0, 4)
				
				SendWeaponAnim(Player, ANIM_RELOAD)
				
				static Float:tTime; tTime = get_gametime()
				
				g_flTimeWeaponIdle[Player] = tTime + 5.8
			}
		}
	}
	return HAM_IGNORED
}

public fw_SalamanderReload(pWeapon)
{
	static Player; Player = get_pdata_cbase(pWeapon, 41, 4)
	
	if(!IsPrivateDataValid(Player))
		return HAM_IGNORED
	
	if(g_fHasSalamander[Player])
	{	
		if(get_pdata_int(pWeapon, m_fInReload, 4))
		{	
			if(!cs_get_user_bpammo(Player, CSW_GALIL))
				return HAM_IGNORED
			
			g_fUsingFlamethrower[Player] = false
			
			set_pdata_float(Player, m_flNextAttack, 5.3, 5)
			set_pdata_float(pWeapon, m_flTimeWeaponIdle, 9999.0, 4)
			
			SendWeaponAnim(Player, ANIM_RELOAD)
			
			static Float:tTime; tTime = get_gametime()
			
			g_flTimeWeaponIdle[Player] = tTime + 5.8
		}
	}
	return HAM_IGNORED
}

public fw_DeathMsg(MsgID, MsgDest, iReceiver)
{
	static iKiller, iVictim;
	iKiller = get_msg_arg_int(1)
	iVictim = get_msg_arg_int(2)
	
	if( !IsConnected(iVictim) || iKiller == iVictim)
		return PLUGIN_CONTINUE
	
	static pszWeapon[32]
	get_msg_arg_string(4, pszWeapon, charsmax(pszWeapon))
	
	if(equal(pszWeapon, g_szClassFlamethrowerFlame) && g_fHoldingSalamander[iKiller])
		set_msg_arg_string(4, g_szKillName)
	
	return PLUGIN_CONTINUE
}

// Drop all secondary weapons
UTIL_DropWeapons(Player)
{
	// Get user weapons
	static weapons[32], num, i, weaponid
	num = 0 // reset passed weapons count (bugfix)
	get_user_weapons(Player, weapons, num)
	
	// Loop through them and drop primaries
	for(i = 0; i < num; i++)
	{
		// Prevent re-indexing the array
		weaponid = weapons[i]
		
		// We definetely are holding primary gun
		if(((1<<weaponid) & PRIMARY_WEAPONS_BITSUM))		
		{
			// Get weapon entity
			static wname[32]
			get_weaponname(weaponid, wname, charsmax(wname))
			
			// Player drops the weapon and looses his bpammo
			engclient_cmd(Player, "drop", wname)
		}
	}
}

SendWeaponAnim( Player, iAnim )
{
	set_pev(Player, pev_weaponanim, iAnim)
	
	message_begin(MSG_ONE, SVC_WEAPONANIM, {0, 0, 0}, Player)
	write_byte(iAnim)
	write_byte(0)
	message_end()
}

CFlamethrower__PrimaryAttack(Player)
{
	static pWeapon; pWeapon = find_ent_by_owner(-1, "weapon_galil", Player)
	
	if(get_pdata_int(pWeapon, m_fInReload, 4))
		return
	
	static iClip; iClip = cs_get_weapon_ammo(pWeapon)
	
	static Float:tTime; tTime = get_gametime()
	
	if(!iClip || pev(Player, pev_waterlevel) == 3)
	{	
		if(g_flNextSoundTime[Player] < tTime)
		{
			ExecuteHamB(Ham_Weapon_PlayEmptySound, pWeapon)
			g_flNextSoundTime[Player] = tTime + 0.5
		}
		return
	}
	
	g_fUsingFlamethrower[Player] = true
	cs_set_weapon_ammo(pWeapon, --iClip)
	
	SendWeaponAnim(Player, ANIM_SHOOT)
	
	if(g_flTimeUpdate[Player] <= tTime)
	{
		emit_sound(Player, CHAN_WEAPON, g_szSoundFlamethrowerFire, 0.8, ATTN_NORM, 0, PITCH_NORM)
		g_flTimeUpdate[Player] = tTime + 0.8
	}
	CFlame__Create(Player)
}

CFlame__Create(Player)
{
	UTIL_MakeVectors(Player, v_angle + punchangle)
	
	new pFlame = create_entity("env_sprite")
	
	if(!pFlame)
	{
		return
	}
	
	set_pev(pFlame, pev_classname,	 g_szClassFlamethrowerFlame)
	engfunc(EngFunc_SetModel, pFlame, g_szSpriteFireBlast)
	
	set_pev(pFlame, pev_movetype, MOVETYPE_FLY)
	set_pev(pFlame, pev_solid, SOLID_BBOX)
	
	static Float:vOrigin[3], Float:vSrc[3]
	static Float:vAngle[3], Float:vForward[3], Float:vRight[3], Float:vUp[3]
	pev(Player, pev_origin, vOrigin)
	pev(Player, pev_v_angle, vAngle)
	engfunc(EngFunc_MakeVectors, vAngle)
	global_get(glb_v_forward, vForward)
	global_get(glb_v_right, vRight)
	global_get(glb_v_up, vUp)
	vSrc[0] = vOrigin[0] + vForward[0] * 100.0 + vRight[0] * 8.0 + vUp[0] * 10.0;
	vSrc[1] = vOrigin[1] + vForward[1] * 100.0 + vRight[1] * 8.0 + vUp[1] * 10.0;
	vSrc[2] = vOrigin[2] + vForward[2] * 100.0 + vRight[2] * 8.0 + vUp[2] * 10.0;
	engfunc(EngFunc_SetOrigin, pFlame, vSrc)
	
	set_pev(pFlame, pev_rendermode, kRenderTransAdd)
	set_pev(pFlame, pev_rendercolor, Float:{255.0, 255.0, 255.0})
	set_pev(pFlame, pev_renderamt, 255.0)
	set_pev(pFlame, pev_scale, (random_float(0.0, 1.0) < 0.5) ? 1.0 : 2.0)
	
	engfunc(EngFunc_SetSize, pFlame, Float:{0.0, 0.0, 0.0}, Float:{0.0, 0.0, 0.0})
	
	static Float:vVelocity[3]
	velocity_by_aim( Player, g_iFlameVelocity, vVelocity)
	set_pev(pFlame, pev_velocity, vVelocity)
	
	static Float:fAngle[3]
	for(new i = 0; i < 3; i++)
		fAngle[i] = random_float(-360.0, 360.0)
	set_pev( pFlame, pev_angles, fAngle)
	
	set_pev(pFlame, pev_frame,	0.0)
	set_pev(pFlame, pev_framerate, 1.0)
	set_pev(pFlame, pev_scale, 0.15)
	
	set_pev(pFlame, pev_owner, Player)
	set_pev(pFlame, pev_startposition, vOrigin)
	
	static Float:tTime; tTime = get_gametime()
	
	set_pev(pFlame, pev_nextthink, tTime)
	set_pev(pFlame, pev_starttime, tTime)
	set_pev(pFlame, pev_dmg, g_flFlamethrowerDamage)
}	

UTIL_MakeVectors(Player, iBits)
{
	static Float:vAngles[3], Float:vPunchAngles[3]
	
	if(iBits & v_angle)
		pev(Player, pev_v_angle, vPunchAngles)
	else if(iBits & punchangle)
		pev(Player, pev_punchangle, vAngles)
	
	if(iBits & (v_angle & punchangle))
		VectorAdd(vAngles, vPunchAngles, vAngles)
	
	engfunc(EngFunc_MakeVectors, vAngles)
}

public fw_FlameThink(pFlame)
{
	if(!pev_valid(pFlame))
		return
	
	static Float:vStartPosition[3], Float:vCurrentPosition[3]
	pev(pFlame, pev_startposition, vStartPosition)
	pev(pFlame, pev_origin, vCurrentPosition)
	
	if(get_distance_f(vStartPosition, vCurrentPosition) > g_flFlamethowerDistance)
	{
		EFX_Explosion(pFlame, vCurrentPosition, g_iFlameBlastSpr, 15, 35, TE_EXPLFLAG_NOSOUND | TE_EXPLFLAG_NOPARTICLES)
		engfunc(EngFunc_RemoveEntity, pFlame)
		return
	}	
	static iWaterLevel, Float:tTime
	iWaterLevel = pev(pFlame, pev_waterlevel)
	tTime = get_gametime()
	
	if(!IsInWorld( pFlame ) || iWaterLevel == 3 || tTime - pev( pFlame, pev_starttime ) >= 4.0)
	{
		engfunc(EngFunc_RemoveEntity, pFlame)
		return
	}
	
	// Make it slower
	static Float:vVelocity[3]
	pev(pFlame, pev_velocity, vVelocity)
	xs_vec_mul_scalar(vVelocity, 0.95, vVelocity)
	set_pev(pFlame, pev_velocity, vVelocity)
	
	// Make it invisible
	static Float:fRenderAmount
	pev(pFlame, pev_renderamt, fRenderAmount)
	fRenderAmount -= 3.0
	set_pev(pFlame, pev_renderamt, fRenderAmount)
	
	// Make it bigger
	static Float:fScale
	pev(pFlame, pev_scale, fScale)
	fScale += 0.5
	set_pev(pFlame, pev_scale, fScale)
	
	// Animate it
	static Float:fFrame
	pev(pFlame, pev_frame, fFrame)
	fFrame += 2.0
	set_pev(pFlame, pev_frame, fFrame)
	
	set_pev(pFlame, pev_nextthink, tTime + 0.2)
}

public fw_FlameTouch(pFlame, pOther)
{
	if(!pev_valid(pFlame))
		return;
	
	static Float:vOrigin[3]
	pev(pFlame, pev_origin, vOrigin)
	
	vOrigin[0] += random_float(-5.0, 5.0)
	vOrigin[1] += random_float(-5.0, 5.0)
	
	EFX_Explosion(pFlame, vOrigin, g_iFlameBlastSpr, 15, 35, TE_EXPLFLAG_NOSOUND | TE_EXPLFLAG_NOPARTICLES)
	
	static pOwner; pOwner = pev(pFlame, pev_owner)
	
	UTIL_RadiusDamage(pOwner, vOrigin, pFlame, g_flFlamethrowerDamage, 100.0)
	
	engfunc(EngFunc_RemoveEntity, pFlame)	
}

EFX_Explosion(this, Float:vOrigin[], iSprite, iScale, iFrameRate, iFlags)
{
	// TODO.Add few trace lines and vector calculations
	// for proper explosion end position calculation
	static Float:vecDown[3], tr
	
	vecDown[0] = vOrigin[0]
	vecDown[1] = vOrigin[1]
	vecDown[2] = vOrigin[2] - 32.0
	
	engfunc(EngFunc_TraceLine, vOrigin, vecDown, IGNORE_MONSTERS, this, tr)
	
	if(get_tr2(tr, TR_flFraction ) != 1.0)
	{
		static Float:vEndPos[3], Float:vPlaneNormal[3]
		get_tr2(tr, TR_vecEndPos, vEndPos)
		get_tr2(tr, TR_vecPlaneNormal, vPlaneNormal)
		
		for(new i = 0; i < 3; i++)
			vOrigin[i] = vEndPos[i] + (vPlaneNormal[i] * (pev(this, pev_dmg) - 24.0) * 0.6)
	}
	engfunc(EngFunc_MessageBegin, MSG_PVS, SVC_TEMPENTITY, vOrigin, 0)
	write_byte(TE_EXPLOSION)
	engfunc(EngFunc_WriteCoord, vOrigin[0])
	engfunc(EngFunc_WriteCoord, vOrigin[1])
	engfunc(EngFunc_WriteCoord, vOrigin[2])
	write_short(iSprite)
	write_byte(iScale)
	write_byte(iFrameRate)
	write_byte(iFlags)
	message_end()
}

UTIL_RadiusDamage(iOwner, Float:vOrigin[3], this, Float:fDamage, Float:fRadius)
{
	static iVictim, Float:flDistance, Float:fRealDamage
	iVictim = -1
	
	while((iVictim = engfunc(EngFunc_FindEntityInSphere, iVictim, vOrigin, fRadius)) != 0)
	{
		if(!IsPlayer(iVictim))
			continue
		
		if(!IsAlive(iVictim))
			continue
		
		flDistance = entity_range(this, iVictim)
		fRealDamage = UTIL_FloatRadius(fDamage, fRadius, flDistance)
		
		if(fRealDamage > 0.0)
		{
			ExecuteHamB(Ham_TakeDamage, iVictim, 0, iOwner, fRealDamage, DMG_BURN | DMG_NEVERGIB)
		}		
	}
}

stock Float:UTIL_FloatRadius(Float:flMaxAmount, Float:flRadius, Float:flDistance)
	
return floatsub(flMaxAmount, floatmul(floatdiv(flMaxAmount, flRadius), flDistance ))



/*============================================================
Silah Menu Devami
============================================================*/
public silahmenu(id) 
{ 
	if (is_user_alive(id) && get_user_team(id) == 2)
	{
		new menu = menu_create("\wSilah Menüsü \d[1]", "silahinmenusu1") 
		
		menu_additem(menu, "\wM4A1", "1", 0); 
		menu_additem(menu, "\wAK47", "2", 0); 
		menu_additem(menu, "\wAWP", "3", 0); 
		menu_additem(menu, "\wFAMAS", "4", 0); 
		menu_additem(menu, "\wGALIL", "5", 0); 
		menu_additem(menu, "\wM3", "6", 0); 
		menu_additem(menu, "\wATE$ PÜSKÜRTEN", "8", 0);
		
		menu_setprop(menu, MPROP_EXIT, MEXIT_ALL); 
		menu_display(id, menu, 0); 
	}
} 
public silahinmenusu1(id,menu,item,Player,pItem) 
{ 
	
	if( item == MENU_EXIT ) 
	{ 
		menu_destroy(menu); 
		return PLUGIN_HANDLED; 
	} 
	
	new data[6], iName[64] 
	new access, callback 
	
	menu_item_getinfo(menu, item, access, data,5, iName, 63, callback); 
	
	new key = str_to_num(data) 
	
	switch(key) 
	{ 
		case 1: { 
			strip_user_weapons(id)
			tekliler(id) 
			give_item(id, "weapon_m4a1") 
			give_item(id, "weapon_knife")          
			cs_set_user_bpammo(id, CSW_M4A1, 90) 
		} 
		case 2: {  
			strip_user_weapons(id)
			tekliler(id)
			give_item(id, "weapon_ak47")
			cs_set_user_bpammo(id, CSW_AK47, 90)
			give_item(id, "weapon_knife")    
		} 
		
		case 3: {  
			strip_user_weapons(id)
			tekliler(id)
			give_item(id, "weapon_awp") 
			cs_set_user_bpammo(id, CSW_AWP, 90) 
			give_item(id, "weapon_knife")    
		} 
		
		case 4: { 
			strip_user_weapons(id)
			tekliler(id) 
			give_item(id, "weapon_famas") 
			cs_set_user_bpammo(id, CSW_FAMAS, 90) 
			give_item(id, "weapon_knife")    
		} 
		case 5: {  
			strip_user_weapons(id)
			tekliler(id)
			give_item(id, "weapon_galil") 
			cs_set_user_bpammo(id, CSW_GALIL, 90) 
			give_item(id, "weapon_knife")    
		} 
		case 6: {  
			strip_user_weapons(id)
			tekliler(id)
			give_item(id, "weapon_m3") 
			cs_set_user_bpammo(id, CSW_M3, 90) 
			give_item(id, "weapon_knife")    
		} 
		case 7: { 
			strip_user_weapons(id)
			tekliler(id)
			give_item(id, "weapon_sg550") 
			cs_set_user_bpammo(id, CSW_SG550, 90) 
			give_item(id, "weapon_knife")    
		} 
		case 8: { 
			strip_user_weapons(id)
			tekliler(id)           
			client_cmd(id, "pukka")
			give_item(id, "weapon_knife")   
			client_print(Player, print_chat, "[www.ZeybekGaming.Net]")
		} 
	} 
	
	menu_destroy(menu); 
	return PLUGIN_HANDLED; 
} 


public tekliler(id) 
{ 
	if(is_user_alive(id)) 
	{
		new menu = menu_create("\wSilah Menüsü \d[2]", "silahinmenusu2") 
		
		menu_additem(menu, "\wDEAGLE", "1", 0); 
		menu_additem(menu, "\wUSP", "2", 0); 
		menu_additem(menu, "\wGLOCK", "3", 0); 
		menu_additem(menu, "\wBERETTA \dx2", "4", 0); 
		menu_additem(menu, "\wFIVE SEVEN", "5", 0);  
		menu_setprop(menu, MPROP_EXIT, MEXIT_ALL); 
		menu_display(id, menu, 0); 
	}
} 


public silahinmenusu2(id,menu,item) 
{ 
	
	if( item == MENU_EXIT ) 
	{ 
		menu_destroy(menu); 
		return PLUGIN_HANDLED; 
	} 
	
	new data[6], iName[64] 
	new access, callback 
	
	menu_item_getinfo(menu, item, access, data,5, iName, 63, callback); 
	
	new key = str_to_num(data) 
	
	switch(key) 
	{ 
		case 1: { 
			
			give_item(id, "weapon_deagle") 
			cs_set_user_bpammo(id, CSW_DEAGLE, 90) 
			
		} 
		case 2: {  
			
			give_item(id, "weapon_usp") 
			cs_set_user_bpammo(id, CSW_USP, 90) 
		} 
		
		case 3: {  
			
			give_item(id, "weapon_glock18") 
			cs_set_user_bpammo(id, CSW_GLOCK18, 90) 
		} 
		
		case 4: { 
			
			give_item(id, "weapon_elite") 
			cs_set_user_bpammo(id, CSW_ELITE, 90) 
		} 
		case 5: {  
			
			give_item(id, "weapon_fiveseven") 
			cs_set_user_bpammo(id, CSW_FIVESEVEN, 90) 
		} 
	} 
	
	menu_destroy(menu); 
	return PLUGIN_HANDLED; 
} 

/*============================================================
TESilahMenu
============================================================*/
public zeybekgamingnet(id) 
{ 
	if (get_pcvar_num(tesilahmenu)){
		strip_user_weapons(id)
		give_item(id, "weapon_knife") 
		if (is_user_alive(id) && get_user_team(id) == 1)
		{
			new menu = menu_create("\wSilah Menüsü \d[1]", "silahinmenusu1") 
			
			menu_additem(menu, "\wM4A1", "1", 0); 
			menu_additem(menu, "\wAK47", "2", 0); 
			menu_additem(menu, "\wAWP", "3", 0); 
			menu_additem(menu, "\wFAMAS", "4", 0); 
			menu_additem(menu, "\wGALIL", "5", 0); 
			menu_additem(menu, "\wM3", "6", 0); 
			menu_additem(menu, "\wATE$ PÜSKÜRTEN", "8", 0);
			
			menu_setprop(menu, MPROP_EXIT, MEXIT_ALL); 
			menu_display(id, menu, 0); 
		}
	}
}
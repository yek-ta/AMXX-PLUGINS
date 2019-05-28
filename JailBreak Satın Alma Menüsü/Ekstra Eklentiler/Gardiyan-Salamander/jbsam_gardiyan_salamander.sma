#include <amxmodx>
#include <engine>
#include <fakemeta>
#include <fakemeta_util>
#include <hamsandwich>
#include <cstrike>
#include <xs>
#include <fun>
#define MAHKUM 1
#define GARDIYAN 2

// Natives
native jbsam_esya_gir(const item_name[], const item_cost, const item_desc[], const item_team)
native jbsam_esyamenusu(id)

// Forwards
forward jbsam_esya_sec(id, item)


#define PLUGIN "Salamander"
#define VERSION "3.0"
#define AUTHOR "Dias"

#define DAMAGE 38
#define RECOIL 0.1
#define FIRE_SPEED 500.0

#define BURN_DAMAGE 15
#define BURN_LOOP 1.0
#define BURN_TIME 5.0
#define FIREBURN_CLASSNAME "fire_burn"

#define CSW_SALAMANDER CSW_M249
#define weapon_salamander "weapon_m249"

#define DEFAULT_W_MODEL "models/w_m249.mdl"
#define WEAPON_SECRET_CODE 1962+400
#define FIRE_CLASSNAME "fire"

// Fire Start
#define WEAPON_ATTACH_F 40.0
#define WEAPON_ATTACH_R 5.0
#define WEAPON_ATTACH_U -15.0

#define TASK_RESET_AMMO 5434

const pev_ammo = pev_iuser4

new const WeaponModel[3][] =
{
	"models/v_flamethrower.mdl",
	"models/p_flamethrower.mdl",
	"models/w_flamethrower.mdl"
}

new const WeaponSound[6][] =
{
	"weapons/flamegun-1.wav",
	"weapons/flamegun-2.wav",
	"weapons/flamegun_draw.wav",
	"weapons/flamegun_clipin1.wav",
	"weapons/flamegun_clipout1.wav",
	"weapons/flamegun_clipout2.wav"
}

new const WeaponResource[7][] = 
{
	"sprites/flame_puff01.spr",
	"sprites/flame_burn01.spr",
	"sprites/weapon_flamethrower.txt",
	"sprites/640hud7_2.spr",
	"sprites/640hud59_2.spr",
	"sprites/640hud60_2.spr",
	"sprites/smokepuff.spr"
}

enum
{
	MODEL_V = 0,
	MODEL_P,
	MODEL_W
}

enum
{
	SALAMANDER_ANIM_IDLE = 0,
	SALAMANDER_ANIM_SHOOT_BEGIN,
	SALAMANDER_ANIM_SHOOT_END,
	SALAMANDER_ANIM_RELOAD,
	SALAMANDER_ANIM_DRAW
}

new g_had_salamander[33], g_old_weapon[33], Float:g_PunchAngles[33][3]
new g_smokepuff_id, g_weapon_event, g_register
new cvar_esya_para
new esya
public jbsam_esya_sec(id, item){
	if(item != esya)
		return PLUGIN_HANDLED
		
	get_salamander(id)
	
	return PLUGIN_CONTINUE
}
public plugin_init() 
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
	
	register_event("HLTV", "Event_NewRound", "a", "1=0", "2=0")
	register_event("CurWeapon", "event_CurWeapon", "be", "1=1")

	register_forward(FM_UpdateClientData, "fw_UpdateClientData_Post", 1)
	register_forward(FM_SetModel, "fw_SetModel")
	register_forward(FM_PlaybackEvent, "fw_PlaybackEvent")
	register_forward(FM_CmdStart, "fw_CmdStart")

	register_think(FIRE_CLASSNAME, "fw_Fire_Think")
	register_think(FIREBURN_CLASSNAME, "fw_FireBurn_Think")
	register_touch(FIRE_CLASSNAME, "*", "fw_Fire_Touch")
	
	RegisterHam(Ham_Spawn, "player", "fw_Spawn_Post", 1)
	RegisterHam(Ham_Item_AddToPlayer, weapon_salamander, "fw_AddToPlayer_Post", 1)
	RegisterHam(Ham_TraceAttack, "player", "fw_TraceAttack")
	RegisterHam(Ham_TraceAttack, "worldspawn", "fw_TraceAttack")
	RegisterHam(Ham_Weapon_PrimaryAttack, weapon_salamander, "fw_Weapon_PrimaryAttack")
	RegisterHam(Ham_Weapon_PrimaryAttack, weapon_salamander, "fw_Weapon_PrimaryAttack_Post", 1)
	
	//g_dragoncannon = zp_register_extra_item("Dragon Cannon", 1, ZP_TEAM_HUMAN)
	
	//register_clcmd("admin_get_salamander", "get_salamander", ADMIN_RCON)
	cvar_esya_para = register_cvar("jbsam_salamander_ucret","30")
	esya = jbsam_esya_gir("Salamander Silahi", get_pcvar_num(cvar_esya_para), "Ates Puskurten", GARDIYAN)
	register_clcmd("weapon_flamethrower", "hook_weapon")
	//register_clcmd("do_shoot", "do_shoot")
	
	register_forward(FM_PrecacheEvent, "fw_PrecacheEvent_Post", 1)
}

/*
public do_shoot(id)
{
	static Body, Target
	get_user_aiming(id, Target, Body, 9999)
	
	if(is_user_alive(Target))
	{
		static Ent; Ent = fm_get_user_weapon_entity(Target, get_user_weapon(Target))
		ExecuteHamB(Ham_Weapon_PrimaryAttack, Ent)
	}
}*/

public plugin_precache()
{
	new i
	for(i = 0; i < sizeof(WeaponModel); i++)
		engfunc(EngFunc_PrecacheModel, WeaponModel[i])
	for(i = 0; i < sizeof(WeaponSound); i++)
		engfunc(EngFunc_PrecacheSound, WeaponSound[i])
		
	engfunc(EngFunc_PrecacheModel, WeaponResource[0])
	engfunc(EngFunc_PrecacheModel, WeaponResource[1])
	engfunc(EngFunc_PrecacheGeneric, WeaponResource[2])
	engfunc(EngFunc_PrecacheModel, WeaponResource[3])
	engfunc(EngFunc_PrecacheModel, WeaponResource[4])
	engfunc(EngFunc_PrecacheModel, WeaponResource[5])
	g_smokepuff_id = engfunc(EngFunc_PrecacheModel, WeaponResource[6])
}

public fw_PrecacheEvent_Post(type, const name[])
{
	if(equal("events/m249.sc", name))
		g_weapon_event = get_orig_retval()
}

public client_putinserver(id)
{
	if(is_user_bot(id) && !g_register)
	{
		g_register = 1
		set_task(0.1, "do_register", id)
	}
}

public do_register(id)
{
	RegisterHamFromEntity(Ham_TraceAttack, id, "fw_TraceAttack")			
}

public get_salamander(id)
{
	if(!is_user_alive(id))
		return
		
	drop_weapons(id, 1)
		
	g_had_salamander[id] = 1
	fm_give_item(id, weapon_salamander)
	
	message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("CurWeapon"), _, id)
	write_byte(1)
	write_byte(CSW_SALAMANDER)
	write_byte(100)
	message_end()
	
	cs_set_user_bpammo(id, CSW_SALAMANDER, 200)
}

public remove_salamnader(id)
{
	if(!is_user_connected(id))
		return
		
	g_had_salamander[id] = 0
}

public hook_weapon(id) engclient_cmd(id, weapon_salamander)
public Event_NewRound()
{
	remove_entity_name(FIRE_CLASSNAME)
	remove_entity_name(FIREBURN_CLASSNAME)
}
public event_CurWeapon(id)
{
	if(!is_user_alive(id))
		return
		
	if(get_user_weapon(id) == CSW_SALAMANDER && g_had_salamander[id])
	{
		set_pev(id, pev_viewmodel2, WeaponModel[MODEL_V])
		set_pev(id, pev_weaponmodel2, WeaponModel[MODEL_P])
		
		if(g_old_weapon[id] != CSW_SALAMANDER)
		{
			set_weapon_anim(id, SALAMANDER_ANIM_DRAW)
			set_pdata_float(id, 83, 1.0, 5)
		}
	}
	
	g_old_weapon[id] = get_user_weapon(id)
}

public fw_UpdateClientData_Post(id, sendweapons, cd_handle)
{
	if(!is_user_connected(id) || !is_user_alive(id))
		return FMRES_IGNORED
	if(get_user_weapon(id) != CSW_SALAMANDER || !g_had_salamander[id])
		return FMRES_IGNORED
	
	set_cd(cd_handle, CD_flNextAttack, get_gametime() + 0.001) 
	
	return FMRES_HANDLED
}

public fw_SetModel(entity, model[])
{
	if(!pev_valid(entity))
		return FMRES_IGNORED
	
	static szClassName[33]
	pev(entity, pev_classname, szClassName, charsmax(szClassName))
	
	if(!equal(szClassName, "weaponbox"))
		return FMRES_IGNORED
	
	static id
	id = pev(entity, pev_owner)
	
	if(equal(model, DEFAULT_W_MODEL))
	{
		static weapon
		weapon = fm_find_ent_by_owner(-1, weapon_salamander, entity)
		
		if(!pev_valid(weapon))
			return FMRES_IGNORED
		
		if(g_had_salamander[id])
		{
			set_pev(weapon, pev_impulse, WEAPON_SECRET_CODE)
			engfunc(EngFunc_SetModel, entity, WeaponModel[MODEL_W])
			
			remove_salamnader(id)
			
			return FMRES_SUPERCEDE
		}
	}

	return FMRES_IGNORED
}

public fw_PlaybackEvent(flags, invoker, eventid, Float:delay, Float:origin[3], Float:angles[3], Float:fparam1, Float:fparam2, iParam1, iParam2, bParam1, bParam2)
{
	if(!is_user_connected(invoker) || !is_user_alive(invoker))
		return FMRES_IGNORED
	if(get_user_weapon(invoker) != CSW_SALAMANDER || !g_had_salamander[invoker])
		return FMRES_IGNORED	
	if(eventid == g_weapon_event)
	{
		playback_event(flags | FEV_HOSTONLY, invoker, eventid, delay, origin, angles, fparam1, fparam2, iParam1, iParam2, bParam1, bParam2)	

		set_weapon_anim(invoker, SALAMANDER_ANIM_SHOOT_BEGIN)
		
		/*
		if(get_gametime() - 0.1 > FireSound_Delay[invoker])
		{
			emit_sound(invoker, CHAN_WEAPON, WeaponSound[random_num(0, 1)], 1.0, ATTN_NORM, 0, PITCH_NORM)	
			FireSound_Delay[invoker] = get_gametime()
		}*/
		
		return FMRES_SUPERCEDE
	}
	
	return FMRES_HANDLED
}

public fw_CmdStart(id, uc_handle, seed)
{
	if(!is_user_connected(id) || !is_user_alive(id))
		return FMRES_IGNORED
	if(get_user_weapon(id) != CSW_SALAMANDER || !g_had_salamander[id])
		return FMRES_IGNORED
		
	static PressedButton
	PressedButton = get_uc(uc_handle, UC_Buttons)
	
	if(!(PressedButton & IN_ATTACK))
	{
		if((pev(id, pev_oldbuttons) & IN_ATTACK) && pev(id, pev_weaponanim) == SALAMANDER_ANIM_SHOOT_BEGIN)
		{
			static weapon; weapon = fm_get_user_weapon_entity(id, CSW_SALAMANDER)
			if(pev_valid(weapon)) set_pdata_float(weapon, 48, 2.0, 4)
			set_weapon_anim(id, SALAMANDER_ANIM_SHOOT_END)
			make_fire_smoke(id)
		}
	}
		
	return FMRES_HANDLED
}

public fw_Spawn_Post(id)
{
	remove_salamnader(id)
}

public fw_AddToPlayer_Post(ent, id)
{
	if(!pev_valid(ent))
		return HAM_IGNORED
		
	if(pev(ent, pev_impulse) == WEAPON_SECRET_CODE)
	{
		remove_salamnader(id)
		g_had_salamander[id] = 1
	}
	
	message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("WeaponList"), _, id)
	write_string(g_had_salamander[id] == 1 ? "weapon_flamethrower" : "weapon_m249")
	write_byte(3)
	write_byte(200)
	write_byte(-1)
	write_byte(-1)
	write_byte(0)
	write_byte(4)
	write_byte(CSW_SALAMANDER)
	write_byte(0)
	message_end()			
	
	return HAM_HANDLED	
}

public fw_TraceAttack(Ent, Attacker, Float:Damage, Float:Dir[3], ptr, DamageType)
{
	if(!is_user_alive(Attacker))
		return HAM_IGNORED
	if(get_user_weapon(Attacker) != CSW_SALAMANDER || !g_had_salamander[Attacker])
		return HAM_IGNORED
		
	static Float:Origin[3], Float:TargetOrigin[3]
	//get_tr2(ptr, TR_vecEndPos, TargetOrigin)
	
	get_position(Attacker, WEAPON_ATTACH_F, WEAPON_ATTACH_R, WEAPON_ATTACH_U + 10.0, Origin)
	get_position(Attacker, WEAPON_ATTACH_F * 100.0, WEAPON_ATTACH_R, WEAPON_ATTACH_U + 10.0, TargetOrigin)
	
	create_fire(Attacker, Origin, TargetOrigin, FIRE_SPEED)
		
	return HAM_SUPERCEDE
}

public fw_Weapon_PrimaryAttack(ent)
{
	static id; id = pev(ent, pev_owner)
	pev(id, pev_punchangle, g_PunchAngles[id])
	
	return HAM_IGNORED	
}

public fw_Weapon_PrimaryAttack_Post(ent)
{
	static id; id = pev(ent,pev_owner)

	if(get_user_weapon(id) == CSW_SALAMANDER && g_had_salamander[id])
	{
		static Float:push[3]
		pev(id, pev_punchangle, push)
		xs_vec_sub(push, g_PunchAngles[id], push)
		
		xs_vec_mul_scalar(push, RECOIL, push)
		xs_vec_add(push, g_PunchAngles[id], push)
		set_pev(id, pev_punchangle, push)
	}
	
	return HAM_IGNORED	
}

public create_fake_attack(id)
{
	static weapon
	weapon = fm_find_ent_by_owner(-1, "weapon_knife", id)
	
	if(pev_valid(weapon)) ExecuteHamB(Ham_Weapon_PrimaryAttack, weapon)
}

public create_fire(id, Float:Origin[3], Float:TargetOrigin[3], Float:Speed)
{
	new iEnt = create_entity("env_sprite")
	static Float:vfAngle[3], Float:MyOrigin[3], Float:Velocity[3]
	
	pev(id, pev_angles, vfAngle)
	pev(id, pev_origin, MyOrigin)
	
	vfAngle[2] = float(random(18) * 20)

	// set info for ent
	set_pev(iEnt, pev_movetype, MOVETYPE_FLY)
	set_pev(iEnt, pev_rendermode, kRenderTransAdd)
	set_pev(iEnt, pev_renderamt, 250.0)
	set_pev(iEnt, pev_fuser1, get_gametime() + 1.0)	// time remove
	set_pev(iEnt, pev_scale, 0.5)
	set_pev(iEnt, pev_nextthink, get_gametime() + 0.05)
	
	entity_set_string(iEnt, EV_SZ_classname, FIRE_CLASSNAME)
	engfunc(EngFunc_SetModel, iEnt, WeaponResource[0])
	set_pev(iEnt, pev_mins, Float:{-1.0, -1.0, -1.0})
	set_pev(iEnt, pev_maxs, Float:{1.0, 1.0, 1.0})
	set_pev(iEnt, pev_origin, Origin)
	set_pev(iEnt, pev_gravity, 0.01)
	set_pev(iEnt, pev_angles, vfAngle)
	set_pev(iEnt, pev_solid, SOLID_TRIGGER)
	set_pev(iEnt, pev_owner, id)	
	set_pev(iEnt, pev_frame, 0.0)
	set_pev(iEnt, pev_iuser2, get_user_team(id))

	get_speed_vector(Origin, TargetOrigin, Speed, Velocity)
	set_pev(iEnt, pev_velocity, Velocity)
	
	emit_sound(iEnt, CHAN_BODY, WeaponSound[random_num(0, 1)], 1.0, ATTN_NORM, 0, PITCH_NORM)	
}

public fw_Fire_Think(iEnt)
{
	if(!pev_valid(iEnt)) 
		return
	
	new Float:fFrame, Float:fScale, Float:fNextThink
	pev(iEnt, pev_frame, fFrame)
	pev(iEnt, pev_scale, fScale)

	// effect exp
	new iMoveType = pev(iEnt, pev_movetype)
	if (iMoveType == MOVETYPE_NONE)
	{
		fNextThink = 0.015
		fFrame += 1.0
		fScale = floatmax(fScale, 1.75)
		
		if (fFrame > 21.0)
		{
			engfunc(EngFunc_RemoveEntity, iEnt)
			return
		}
	}
	
	// effect normal
	else
	{
		fNextThink = 0.045
		fFrame += 1.0
		fFrame = floatmin(21.0, fFrame)
		fScale += 0.2
		fScale = floatmin(fScale, 1.75)
	}

	set_pev(iEnt, pev_frame, fFrame)
	set_pev(iEnt, pev_scale, fScale)
	set_pev(iEnt, pev_nextthink, get_gametime() + fNextThink)
	
	// time remove
	static Float:fTimeRemove
	pev(iEnt, pev_fuser1, fTimeRemove)
	if (get_gametime() >= fTimeRemove)
	{
		engfunc(EngFunc_RemoveEntity, iEnt)
		return;
	}
}

public fw_Fire_Touch(ent, id)
{
	if(!pev_valid(ent))
		return
		
	if(pev_valid(id))
	{
		static Classname[32]
		pev(id, pev_classname, Classname, sizeof(Classname))
		
		if(equal(Classname, FIRE_CLASSNAME)) return
		else if(is_user_alive(id)) 
		{
			static EntTeam; EntTeam = pev(ent, pev_iuser2)
			if(get_user_team(id) != EntTeam)
			{
				do_attack(pev(ent, pev_owner), id, 0, float(DAMAGE))
				Make_FireBurn(id)
			}
		}
	}
		
	set_pev(ent, pev_movetype, MOVETYPE_NONE)
	set_pev(ent, pev_solid, SOLID_NOT)
}

public make_fire_smoke(id)
{
	static Float:Origin[3]
	get_position(id, WEAPON_ATTACH_F, WEAPON_ATTACH_R, WEAPON_ATTACH_U, Origin)
	
	message_begin(MSG_BROADCAST, SVC_TEMPENTITY) 
	write_byte(TE_EXPLOSION) 
	engfunc(EngFunc_WriteCoord, Origin[0])
	engfunc(EngFunc_WriteCoord, Origin[1])
	engfunc(EngFunc_WriteCoord, Origin[2])
	write_short(g_smokepuff_id) 
	write_byte(5)
	write_byte(30)
	write_byte(14)
	message_end()
}

public Make_FireBurn(id)
{
	static Ent; Ent = fm_find_ent_by_owner(-1, FIREBURN_CLASSNAME, id)
	if(!pev_valid(Ent))
	{
		new iEnt = create_entity("env_sprite")
		static Float:MyOrigin[3]
		
		pev(id, pev_origin, MyOrigin)
		
		// set info for ent
		set_pev(iEnt, pev_movetype, MOVETYPE_FLY)
		set_pev(iEnt, pev_rendermode, kRenderTransAdd)
		set_pev(iEnt, pev_renderamt, 250.0)
		set_pev(iEnt, pev_fuser1, get_gametime() + 5.0)	// time remove
		set_pev(iEnt, pev_scale, 1.0)
		set_pev(iEnt, pev_nextthink, get_gametime() + 0.5)
		
		entity_set_string(iEnt, EV_SZ_classname, FIREBURN_CLASSNAME)
		engfunc(EngFunc_SetModel, iEnt, WeaponResource[1])
		set_pev(iEnt, pev_origin, MyOrigin)
		set_pev(iEnt, pev_owner, id)
		set_pev(iEnt, pev_aiment, id)
		set_pev(iEnt, pev_frame, 0.0)
	}
}

public fw_FireBurn_Think(iEnt)
{
	if(!pev_valid(iEnt)) 
		return
	
	static Float:fFrame
	pev(iEnt, pev_frame, fFrame)

	// effect exp
	fFrame += 1.0
	if(fFrame > 15.0) fFrame = 0.0

	set_pev(iEnt, pev_frame, fFrame)
	set_pev(iEnt, pev_nextthink, get_gametime() + 0.05)
	
	static id
	id = pev(iEnt, pev_owner)
	
	if(get_gametime() - BURN_LOOP > pev(iEnt, pev_fuser2))
	{
		ExecuteHam(Ham_TakeDamage, id, 0, id, 0.0, DMG_BURN)
		if((get_user_health(id) - BURN_DAMAGE) > 0)
			set_user_health(id, get_user_health(id) - BURN_DAMAGE)
		else
			user_kill(id)
		set_pev(iEnt, pev_fuser2, get_gametime())
	}
	
	// time remove
	static Float:fTimeRemove
	pev(iEnt, pev_fuser1, fTimeRemove)
	if (get_gametime() >= fTimeRemove)
	{
		engfunc(EngFunc_RemoveEntity, iEnt)
		return;
	}
}

do_attack(Attacker, Victim, Inflictor, Float:fDamage)
{
	fake_player_trace_attack(Attacker, Victim, fDamage)
	fake_take_damage(Attacker, Victim, fDamage, Inflictor)
}

fake_player_trace_attack(iAttacker, iVictim, &Float:fDamage)
{
	// get fDirection
	new Float:fAngles[3], Float:fDirection[3]
	pev(iAttacker, pev_angles, fAngles)
	angle_vector(fAngles, ANGLEVECTOR_FORWARD, fDirection)
	
	// get fStart
	new Float:fStart[3], Float:fViewOfs[3]
	pev(iAttacker, pev_origin, fStart)
	pev(iAttacker, pev_view_ofs, fViewOfs)
	xs_vec_add(fViewOfs, fStart, fStart)
	
	// get aimOrigin
	new iAimOrigin[3], Float:fAimOrigin[3]
	get_user_origin(iAttacker, iAimOrigin, 3)
	IVecFVec(iAimOrigin, fAimOrigin)
	
	// TraceLine from fStart to AimOrigin
	new ptr = create_tr2() 
	engfunc(EngFunc_TraceLine, fStart, fAimOrigin, DONT_IGNORE_MONSTERS, iAttacker, ptr)
	new pHit = get_tr2(ptr, TR_pHit)
	new iHitgroup = get_tr2(ptr, TR_iHitgroup)
	new Float:fEndPos[3]
	get_tr2(ptr, TR_vecEndPos, fEndPos)

	// get target & body at aiming
	new iTarget, iBody
	get_user_aiming(iAttacker, iTarget, iBody)
	
	// if aiming find target is iVictim then update iHitgroup
	if (iTarget == iVictim)
	{
		iHitgroup = iBody
	}
	
	// if ptr find target not is iVictim
	else if (pHit != iVictim)
	{
		// get AimOrigin in iVictim
		new Float:fVicOrigin[3], Float:fVicViewOfs[3], Float:fAimInVictim[3]
		pev(iVictim, pev_origin, fVicOrigin)
		pev(iVictim, pev_view_ofs, fVicViewOfs) 
		xs_vec_add(fVicViewOfs, fVicOrigin, fAimInVictim)
		fAimInVictim[2] = fStart[2]
		fAimInVictim[2] += get_distance_f(fStart, fAimInVictim) * floattan( fAngles[0] * 2.0, degrees )
		
		// check aim in size of iVictim
		new iAngleToVictim = get_angle_to_target(iAttacker, fVicOrigin)
		iAngleToVictim = abs(iAngleToVictim)
		new Float:fDis = 2.0 * get_distance_f(fStart, fAimInVictim) * floatsin( float(iAngleToVictim) * 0.5, degrees )
		new Float:fVicSize[3]
		pev(iVictim, pev_size , fVicSize)
		if ( fDis <= fVicSize[0] * 0.5 )
		{
			// TraceLine from fStart to aimOrigin in iVictim
			new ptr2 = create_tr2() 
			engfunc(EngFunc_TraceLine, fStart, fAimInVictim, DONT_IGNORE_MONSTERS, iAttacker, ptr2)
			new pHit2 = get_tr2(ptr2, TR_pHit)
			new iHitgroup2 = get_tr2(ptr2, TR_iHitgroup)
			
			// if ptr2 find target is iVictim
			if ( pHit2 == iVictim && (iHitgroup2 != HIT_HEAD || fDis <= fVicSize[0] * 0.25) )
			{
				pHit = iVictim
				iHitgroup = iHitgroup2
				get_tr2(ptr2, TR_vecEndPos, fEndPos)
			}
			
			free_tr2(ptr2)
		}
		
		// if pHit still not is iVictim then set default HitGroup
		if (pHit != iVictim)
		{
			// set default iHitgroup
			iHitgroup = HIT_GENERIC
			
			new ptr3 = create_tr2() 
			engfunc(EngFunc_TraceLine, fStart, fVicOrigin, DONT_IGNORE_MONSTERS, iAttacker, ptr3)
			get_tr2(ptr3, TR_vecEndPos, fEndPos)
			
			// free ptr3
			free_tr2(ptr3)
		}
	}
	
	// set new Hit & Hitgroup & EndPos
	set_tr2(ptr, TR_pHit, iVictim)
	set_tr2(ptr, TR_iHitgroup, iHitgroup)
	set_tr2(ptr, TR_vecEndPos, fEndPos)
	
	// hitgroup multi fDamage
	new Float:fMultifDamage 
	switch(iHitgroup)
	{
		case HIT_HEAD: fMultifDamage  = 4.0
		case HIT_STOMACH: fMultifDamage  = 1.25
		case HIT_LEFTLEG: fMultifDamage  = 0.75
		case HIT_RIGHTLEG: fMultifDamage  = 0.75
		default: fMultifDamage  = 1.0
	}
	
	fDamage *= fMultifDamage
	
	// ExecuteHam
	fake_trake_attack(iAttacker, iVictim, fDamage, fDirection, ptr)
	
	// free ptr
	free_tr2(ptr)
}

stock fake_trake_attack(iAttacker, iVictim, Float:fDamage, Float:fDirection[3], iTraceHandle, iDamageBit = (DMG_NEVERGIB | DMG_BULLET))
{
	ExecuteHam(Ham_TraceAttack, iVictim, iAttacker, fDamage, fDirection, iTraceHandle, iDamageBit)
}

stock fake_take_damage(iAttacker, iVictim, Float:fDamage, iInflictor, iDamageBit = (DMG_NEVERGIB | DMG_BULLET))
{
	ExecuteHam(Ham_TakeDamage, iVictim, iInflictor, iAttacker, fDamage, iDamageBit)
}

stock get_angle_to_target(id, const Float:fTarget[3], Float:TargetSize = 0.0)
{
	new Float:fOrigin[3], iAimOrigin[3], Float:fAimOrigin[3], Float:fV1[3]
	pev(id, pev_origin, fOrigin)
	get_user_origin(id, iAimOrigin, 3) // end position from eyes
	IVecFVec(iAimOrigin, fAimOrigin)
	xs_vec_sub(fAimOrigin, fOrigin, fV1)
	
	new Float:fV2[3]
	xs_vec_sub(fTarget, fOrigin, fV2)
	
	new iResult = get_angle_between_vectors(fV1, fV2)
	
	if (TargetSize > 0.0)
	{
		new Float:fTan = TargetSize / get_distance_f(fOrigin, fTarget)
		new fAngleToTargetSize = floatround( floatatan(fTan, degrees) )
		iResult -= (iResult > 0) ? fAngleToTargetSize : -fAngleToTargetSize
	}
	
	return iResult
}

stock get_angle_between_vectors(const Float:fV1[3], const Float:fV2[3])
{
	new Float:fA1[3], Float:fA2[3]
	engfunc(EngFunc_VecToAngles, fV1, fA1)
	engfunc(EngFunc_VecToAngles, fV2, fA2)
	
	new iResult = floatround(fA1[1] - fA2[1])
	iResult = iResult % 360
	iResult = (iResult > 180) ? (iResult - 360) : iResult
	
	return iResult
}

stock set_weapon_anim(id, anim)
{
	if(!is_user_alive(id) || pev(id, pev_weaponanim) == anim)
		return
		
	set_pev(id, pev_weaponanim, anim)
	
	message_begin(MSG_ONE_UNRELIABLE, SVC_WEAPONANIM, {0, 0, 0}, id)
	write_byte(anim)
	write_byte(pev(id, pev_body))
	message_end()
}

stock drop_weapons(id, dropwhat)
{
	static weapons[32], num, i, weaponid
	num = 0
	get_user_weapons(id, weapons, num)
	
	const PRIMARY_WEAPONS_BIT_SUM = (1<<CSW_SCOUT)|(1<<CSW_XM1014)|(1<<CSW_MAC10)|(1<<CSW_MAC10)|(1<<CSW_UMP45)|(1<<CSW_SG550)|(1<<CSW_MAC10)|(1<<CSW_FAMAS)|(1<<CSW_AWP)|(1<<CSW_MP5NAVY)|(1<<CSW_M249)|(1<<CSW_M3)|(1<<CSW_M4A1)|(1<<CSW_TMP)|(1<<CSW_G3SG1)|(1<<CSW_SG552)|(1<<CSW_AK47)|(1<<CSW_P90)
	
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

stock set_player_nextattack(player, weapon_id, Float:NextTime)
{
	const m_flNextPrimaryAttack = 46
	const m_flNextSecondaryAttack = 47
	const m_flTimeWeaponIdle = 48
	const m_flNextAttack = 83
	
	static weapon
	weapon = fm_get_user_weapon_entity(player, weapon_id)
	
	set_pdata_float(player, m_flNextAttack, NextTime, 5)
	if(pev_valid(weapon))
	{
		set_pdata_float(weapon, m_flNextPrimaryAttack , NextTime, 4)
		set_pdata_float(weapon, m_flNextSecondaryAttack, NextTime, 4)
		set_pdata_float(weapon, m_flTimeWeaponIdle, NextTime, 4)
	}
}

stock get_position(id,Float:forw, Float:right, Float:up, Float:vStart[])
{
	new Float:vOrigin[3], Float:vAngle[3], Float:vForward[3], Float:vRight[3], Float:vUp[3]
	
	pev(id, pev_origin, vOrigin)
	pev(id, pev_view_ofs,vUp) //for player
	xs_vec_add(vOrigin,vUp,vOrigin)
	pev(id, pev_v_angle, vAngle) // if normal entity ,use pev_angles
	
	angle_vector(vAngle,ANGLEVECTOR_FORWARD,vForward) //or use EngFunc_AngleVectors
	angle_vector(vAngle,ANGLEVECTOR_RIGHT,vRight)
	angle_vector(vAngle,ANGLEVECTOR_UP,vUp)
	
	vStart[0] = vOrigin[0] + vForward[0] * forw + vRight[0] * right + vUp[0] * up
	vStart[1] = vOrigin[1] + vForward[1] * forw + vRight[1] * right + vUp[1] * up
	vStart[2] = vOrigin[2] + vForward[2] * forw + vRight[2] * right + vUp[2] * up
}

stock get_speed_vector(const Float:origin1[3],const Float:origin2[3],Float:speed, Float:new_velocity[3])
{
	new_velocity[0] = origin2[0] - origin1[0]
	new_velocity[1] = origin2[1] - origin1[1]
	new_velocity[2] = origin2[2] - origin1[2]
	new Float:num = floatsqroot(speed*speed / (new_velocity[0]*new_velocity[0] + new_velocity[1]*new_velocity[1] + new_velocity[2]*new_velocity[2]))
	new_velocity[0] *= num
	new_velocity[1] *= num
	new_velocity[2] *= num
	
	return 1;
}

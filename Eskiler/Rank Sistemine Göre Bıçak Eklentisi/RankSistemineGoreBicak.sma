#include <amxmodx>
#include <amxmisc>
#include <engine> 
#include <hamsandwich>
#include <csx>

#define PLUGIN "Ranka Gore Bicak"
#define VERSION "1.0" 
#define AUTHOR "CSmiLeFaCe"

new knife_degeri[33] 

public plugin_init() { 
	
	register_plugin(PLUGIN, VERSION, AUTHOR) 
	register_event("CurWeapon","checkWeapon","be","1=1")
	RegisterHam(Ham_Spawn, 		"player", "oyuncudogdu",	1)
}
public oyuncudogdu(id){
	new iRankPos;
	new izStats[8], izBody[8]
	iRankPos = get_user_stats(id, izStats, izBody);
	
	
	if(get_user_flags(id) & ADMIN_LEVEL_A){
		knife_degeri[id] = 6;
		return PLUGIN_HANDLED;
	}
	if(iRankPos == 1){
		knife_degeri[id] = 1;
	}
	else if(iRankPos >= 2 && iRankPos <= 10){
		knife_degeri[id] = 2;
	}
	else if(iRankPos >= 11 && iRankPos <= 20){
		knife_degeri[id] = 3;
	}
	else if(iRankPos >= 21 && iRankPos <= 30){
		knife_degeri[id] = 4;
	}
	else if(iRankPos >= 31 && iRankPos <= 50){
		knife_degeri[id] = 5;
	}
	else{
		knife_degeri[id] = 0;
	}
	return PLUGIN_CONTINUE;
}
public plugin_precache() { 
	precache_model("models/v_knife.mdl") 
	precache_model("models/p_knife.mdl")
	
	precache_model("models/MRGAMING/v_knifebirinci.mdl")
	precache_model("models/MRGAMING/p_knifebirinci.mdl")  
	precache_model("models/MRGAMING/v_knife210.mdl") 
	precache_model("models/MRGAMING/p_knife210.mdl") 
	precache_model("models/MRGAMING/v_knife1120.mdl") 
	precache_model("models/MRGAMING/p_knife1120.mdl") 
	precache_model("models/MRGAMING/v_knife2130.mdl") 
	precache_model("models/MRGAMING/p_knife2130.mdl")  
	precache_model("models/MRGAMING/v_knife3150.mdl") 
	precache_model("models/MRGAMING/p_knife3150.mdl")  
	precache_model("models/MRGAMING/v_knifeadminler.mdl") 
	
}
public checkWeapon(id) { 
	new Clip, Ammo, Weapon = get_user_weapon(id, Clip, Ammo) 
	
	if ( Weapon == CSW_KNIFE ) { 		
		switch (knife_degeri[id]) { 
			case 0: { 
				entity_set_string(id, EV_SZ_viewmodel, "models/v_knife.mdl") 
				entity_set_string(id, EV_SZ_weaponmodel, "models/p_knife.mdl")
			} 
			case 1: { 
				entity_set_string(id, EV_SZ_viewmodel, "models/MRGAMING/v_knifebirinci.mdl") 
				entity_set_string(id, EV_SZ_weaponmodel, "models/MRGAMING/p_knifebirinci.mdl")  
			} 
			case 2: { 
				entity_set_string(id, EV_SZ_viewmodel, "models/MRGAMING/v_knife210.mdl") 
				entity_set_string(id, EV_SZ_weaponmodel, "models/MRGAMING/p_knife210.mdl")  
			} 
			case 3: { 
				entity_set_string(id, EV_SZ_viewmodel, "models/MRGAMING/v_knife1120.mdl") 
				entity_set_string(id, EV_SZ_weaponmodel, "models/MRGAMING/p_knife1120.mdl")  
			} 
			case 4: { 
				entity_set_string(id, EV_SZ_viewmodel, "models/MRGAMING/v_knife2130.mdl") 
				entity_set_string(id, EV_SZ_weaponmodel, "models/MRGAMING/p_knife2130.mdl")  
			} 
			case 5: { 
				entity_set_string(id, EV_SZ_viewmodel, "models/MRGAMING/v_knife3150.mdl") 
				entity_set_string(id, EV_SZ_weaponmodel, "models/MRGAMING/p_knife3150.mdl")  
			} 
			case 6: { 
				entity_set_string(id, EV_SZ_viewmodel, "models/MRGAMING/v_knifeadminler.mdl") 
				entity_set_string(id, EV_SZ_weaponmodel, "models/p_knife.mdl")
			} 
		}
	}
}

/* bu eklenti www.csplugin.com da paylaþýlmýþtýr. 21.09.2015 */
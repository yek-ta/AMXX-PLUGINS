/* Bu Eklentinin Orjinalini Ertuðrul yapmistir,  JBSAM icin Duzenlenmistir. */

#include <amxmodx>
#include <amxmisc>
#include <engine>
#include <hamsandwich>
#include <cstrike>
#include <jbsam>
#define PLUGIN "Elektrikleri Kesttt Haci"
#define VERSION "1.0"
#define AUTHOR "byetovice"

#define TASK_KESINTI  5001

new bool:kesik;
new bool:resetted[32];
new cvar_elektrik_parasi
new elektrikesya
public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	register_cvar("elektrik_kesintisi", "1.0", FCVAR_SPONLY|FCVAR_SERVER)
	cvar_elektrik_parasi = register_cvar("jbsam_elektrik_ucret","16000")
	register_logevent("event_round_start", 2, "1=Round_Start")
	RegisterHam(Ham_TakeDamage, "player", "SetLightings");
	register_clcmd("HamResetLights","HamReset")
	register_event( "TextMsg","event_round_start","a","2&#Game_C", "2&#Game_W" ); 
	elektrikesya = jbsam_esya_gir("Elektrikleri Kes", get_pcvar_num(cvar_elektrik_parasi), "Elektrikleri Kesme", MAHKUM)
}

public jbsam_esya_sec(id, item){
	if(item != elektrikesya)
		return PLUGIN_HANDLED
		
	elektrik_kes(id)
	
	return PLUGIN_CONTINUE
}

public elektrik_kes(id)
{
	if(kesik)
	{
		client_print(id,print_center," Elektrikler Zaten Yokki !")	
		return PLUGIN_HANDLED;
	}
	new name[18];
	get_user_name(id,name,17)
	set_lights("a")
	set_hudmessage(85, 170, 255, 0.26, 0.14, 0, 6.0, 5.0)
	show_hudmessage(0, "%s Elektirigi Kesti...",name)
	kesik = true;
	set_task(5.0, "elektrikAc", TASK_KESINTI)
	
	return PLUGIN_HANDLED
}

public event_round_start()
{
	remove_task(TASK_KESINTI)
	set_lights("#OFF")
	kesik = false;
}


public HamReset(id)
{
	resetted[id] = true;
	client_print(id,print_console,"lighting logs..")	
}

public client_connect(id)
{
	resetted[id] = false;	
}

public client_disconnect(id)
{
	resetted[id] = false;	
}

public SetLightings(v1, inf, v2, Float:lighting, lgbits)
{
	if(resetted[v2])
	{
		SetHamParamFloat(4, lighting * random_float(1.4,1.7))
	}
}

public elektrikAc(TaskID)
{
	set_lights("#OFF")
	kesik = false;
	remove_task(TaskID)
}




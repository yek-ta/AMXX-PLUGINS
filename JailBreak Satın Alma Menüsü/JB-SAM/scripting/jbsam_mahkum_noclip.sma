/* Script generated by Pawn Studio */

#include <amxmodx>
#include <amxmisc>
#include <fun>
#include <fakemeta>
#include <jbsam>

new cvar_noclip_parasi
new noclipesya
new bool:g_noclip[33];

public plugin_init()
{
	register_plugin("JB-SAM : Noclip","1.0","CSmiLeFaCe")
	cvar_noclip_parasi = register_cvar("jbsam_noclip_ucret","16000")
	noclipesya = jbsam_esya_gir("3 Saniyeligine Noclip", get_pcvar_num(cvar_noclip_parasi), "3 Saniyeligine Noclip", MAHKUM)
}

public jbsam_esya_sec(id, item){
	if(item != noclipesya)
		return PLUGIN_HANDLED
	
	noclip(id)
	
	return PLUGIN_CONTINUE
}

public noclip(id){
	g_noclip[id] = true;
	set_user_noclip(id, 1)
	client_print(id,print_center,"Noclip 3 saniye sonra bitiyor..")	
	set_task(1.0,"asama1",id + 3001)
	set_task(2.0,"asama2",id + 3002)
	set_task(3.0,"asama3",id + 3003)
}

public asama1(task)
{
	new id = task - 3001;
	if(is_user_alive(id) && g_noclip[id])
	{
		client_print(id,print_center,"Noclip 2 saniye sonra bitiyor..")	
	}
	remove_task(task);
}

public asama2(task)
{
	new id = task - 3002;
	if(is_user_alive(id) && g_noclip[id])
	{
		client_print(id,print_center,"Noclip 1 saniye sonra bitiyor..")	
	}
	remove_task(task);
}

public asama3(task)
{
	new id = task - 3003;
	if(is_user_alive(id) && g_noclip[id])
	{
		g_noclip[id] = false;
		set_user_noclip(id, 0)
		if(Stuck(id))
		{
			client_print(id,print_center,"Duvarda kaldigin icin ezildin!")
			user_kill(id)
		}	
	}
	remove_task(task);
}

stock bool:Stuck(Id)
{
	static Float:Origin[3]
	pev(Id, pev_origin, Origin)
	engfunc(EngFunc_TraceHull, Origin, Origin, IGNORE_MONSTERS, pev(Id, pev_flags) & FL_DUCKING ? HULL_HEAD : HULL_HUMAN, 0, 0)
	if (get_tr2(0, TR_StartSolid))
		return true
	
	return false
}
	
/* bu eklenti normalde Mahmut tarafindan baya eskiden yapilmisti simdi JBSAM icin tekrardan duzenlendi...
* CSmiLeFaCe* */


#include <amxmodx>
#include <fun>
#include <amxmisc>
#include <hamsandwich>
#include <cstrike>
#include <fakemeta>
#include <nvault>
#include <engine>
#include <jbsam>

#define PLUGIN "deprem"
#define VERSION "1.0"
#define AUTHOR "neutron"

new bool:sarsiliyor = false
new depremesya
new cvar_deprem_parasi

public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)
	cvar_deprem_parasi = register_cvar("jbsam_deprem_parasi", "10000")
	depremesya = jbsam_esya_gir("Deprem Yarat", get_pcvar_num(cvar_deprem_parasi), "Deprem Yaratma", MAHKUM)
}

public jbsam_esya_sec(id, item){
	if(item != depremesya)
		return PLUGIN_HANDLED
		
	deprem(id)
	
	return PLUGIN_CONTINUE
}
public deprem(id)
{
	new name[32]
	new isim = get_user_name(id,name,31)
	client_print(id,print_chat,"[Neutron] %s isimli oyuncu deprem baslatti",isim)
	set_task(0.2,"Sarsinti",4701,"",0,"b")
	set_task(6.0,"DepremiBitir",4702)
	sarsiliyor = true
}

public Sarsinti(TaskID)
{
	for(new id = 1; id < 33; id++)
	{
		if(is_user_connected(id) && is_user_alive(id) && sarsiliyor)
		{
			message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("ScreenShake"), {0,0,0}, id)  
			write_short(0xFFFF)
			write_short(1<<13)
			write_short(0xFFFF) 
			message_end()
		}
	}
}

public DepremiBitir(TaskID)
{
	if(sarsiliyor)
	{
		remove_task(4701)
		sarsiliyor = false
		remove_task(TaskID)	
	}
}
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1055\\ f0\\ fs16 \n\\ par }
*/

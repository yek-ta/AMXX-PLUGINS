/* Bu Script Pawn Studio ilen Hazirlanmistir */

#include <amxmodx>
#include <amxmisc>
#include <fun>
#include <jbsam>

#define PLUGIN	"JBSAM: Kor Et"
#define AUTHOR	"CSmiLeFaCe"
#define VERSION	"1.0"

new g_msgid_ScreenFade, cvar_kaldir
new cvar_kor_parasi
new koresya
public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
	g_msgid_ScreenFade = get_user_msgid( "ScreenFade")
	cvar_kaldir = register_cvar("jbsam_koret_sure", "5")
	cvar_kor_parasi = register_cvar("jbsam_kor_ucret","16000")
	koresya = jbsam_esya_gir("Gardiyanlari Kor Et", get_pcvar_num(cvar_kor_parasi), "Gardiyanlar Kor Olur", MAHKUM)
}

public jbsam_esya_sec(id, item){
	if(item != koresya)
		return PLUGIN_HANDLED
	
	calistir(id)
	
	return PLUGIN_CONTINUE
}

public calistir(id){
	for(new i = 1; i < 33; i++)
	{
		if( !is_user_connected( i ) )
			return PLUGIN_HANDLED
		
		if(get_user_team(i) == GARDIYAN){
			
			message_begin( MSG_ONE_UNRELIABLE, g_msgid_ScreenFade, _, i )
			write_short( get_pcvar_num( cvar_kaldir ) )
			write_short( get_pcvar_num( cvar_kaldir ) )
			write_short( 0x0004 )
			write_byte( 79 )
			write_byte( 180 )
			write_byte( 61 )
			write_byte( 255 )
			message_end( )
			set_user_rendering(i, kRenderFxGlowShell,0, 255, 0, kRenderNormal, 30)
			set_task( get_pcvar_float( cvar_kaldir), "kaldir" )
		}
		new isim[18];
		get_user_name(id,isim,17)
		set_hudmessage(85, 170, 255, 0.26, 0.14, 0, 6.0, 5.0)
		show_hudmessage(0, "%s Gardiyanlari Kor Etti...",isim,cvar_kaldir)
	}
	return PLUGIN_HANDLED
}

public kaldir( )
{
	for(new i = 1; i < 33; i++)
	{
		if( !is_user_connected( i ) )
			return PLUGIN_HANDLED
		if(get_user_team(i) == GARDIYAN){
			message_begin( MSG_ONE_UNRELIABLE, g_msgid_ScreenFade, _, i )
			write_short( ( 1<<12 ) )
			write_short( 0 )
			write_short( 0x0000 )
			write_byte( 0 )
			write_byte( 0 )
			write_byte( 0 )
			write_byte( 255 )
			message_end( )
			set_user_rendering(i, kRenderFxGlowShell,0, 0, 0, kRenderNormal, 255)
		}
	}
	return PLUGIN_HANDLED
}
/*

	24.03.2012

    1.8.2
*/


#include <amxmodx>
#include <amxmisc>
#include <hamsandwich>
#include <cstrike>
#include <fakemeta>
#include <fun>
#include <dhudmessage>
#include <engine>

#define is_valid_player(%1) (1 <= %1 <= 32)
#define task 672
#define AUTO_TEAM_JOIN_DELAY 0.1
#define TEAM_SELECT_VGUI_MENU_ID 2
#define ADMIN_VOICE ADMIN_MENU
#define g_exp(%1) get_pcvar_num(xp_start) + (seviye[%1] * get_pcvar_num(xp_inc))

/*============================================================
Tanitma
============================================================*/

new 	CTDefaultDano, TDefaultDano, hTDefaultDano, hCTDefaultDano, g_iMsgSayText,syncObj,TCuchillo[33],CTCuchillo[33],g_max_clients,seviye[33] = 1,exp[33],xp_gebertincegelsin,xp_hs_gebertincegelsin,xp_inc,xp_start, xp_enyukseklevel,Gorunmez[33],csmoyun,Zombi[33],ZOMBIDefaultDano,hZOMBIDefaultDano,k_mahkum[33],k_hizli[33],k_guclu[33],k_kizgin[33],k_vip[33],g_pcvar_class,g_pcvar_team,isyandurumu[33],isyannasil[33],hediye[33],g_hediye,hud_goster1,hud_goster2,csmhud_goster1[32],csmhud_goster2[32]
new bool:g_connected[33];
/*============================================================
Yazilar
============================================================*/

new hud_gaminghud[] 				= "[www.ZEYBEKGAMING.Net]"
new hud_oyunkapatildi[]				= "=[Oyun Kapatildi!!!]="
new hud_zombi[] 					= "=[Zombi Oyunu Baslatildi!!!]="
new hud_gorunmezlik[] 				= "=[Gorunmezlik Oyunu Baslatildi!!!]="

new yazi_baslangicyazisi[] 			= "!t[ZeybekGaming.Net]!n=-=!y[ZeybekJBBot Beta Denemesi Versiyon 2...]"
new yazi_maxseviye[] 				= "!t[ZeybekGaming.Net]!n=-=!y[Maximum seviyeye ulastiniz...]"

/*============================================================
Silah Modelleri
============================================================*/

new VIEW_MODELT[]    				= "models/ZeybekGamingJail/ZeybekGaming-TKnife.mdl"
new PLAYER_MODELT[] 				= "models/ZeybekGamingJail/ZeybekGaming-TKnife2.mdl"

new VIEW_MODELCT[] 		    		= "models/ZeybekGamingJail/elektrikli.mdl"
new PLAYER_MODELCT[] 				= "models/ZeybekGamingJail/elektrikli2.mdl"
new GORUNMEZ[] 	 	 	 	 	 	= "models/ZeybekGamingJail/gorunmezel.mdl"
new ZOMBIEL[] 	 	 	 	 	 	= "models/ZeybekGamingJail/v_knife_zombie.mdl"
new PLAYER_ZOMBIEL[] 	 	 	 	= "models/ZeybekGamingJail/ZeybekGaming-TKnife2.mdl"

new WORLD_MODEL[]    				= "models/w_knife.mdl"
new OLDWORLD_MODEL[]   			 	= "models/w_knife.mdl"

/*============================================================
Sesler
============================================================*/

new const t_deploy[] 				= { "[Shop]JailBreak/T/TConvoca.wav", }
new const t_slash1[] 				= { "[Shop]JailBreak/T/Slash1.wav", }
new const t_slash2[] 				= { "[Shop]JailBreak/T/Slash2.wav", }
new const t_wall[] 					= { "[Shop]JailBreak/T/THitWall.wav" }
new const t_hit1[] 					= { "[Shop]JailBreak/T/THit1.wav",  }
new const t_hit2[] 					= { "[Shop]JailBreak/T/THit2.wav",  }
new const t_hit3[] 					= { "[Shop]JailBreak/T/THit3.wav",  }
new const t_hit4[] 					= { "[Shop]JailBreak/T/THit4.wav",  }
new const t_stab[] 					= { "[Shop]JailBreak/T/TStab.wav"  }

new const ct_deploy[] 				= { "[Shop]JailBreak/CT/CTConvoca.wav", }
new const ct_slash1[] 				= { "[Shop]JailBreak/CT/Slash1.wav", }
new const ct_slash2[] 				= { "[Shop]JailBreak/CT/Slash2.wav", }
new const ct_wall[] 				= { "[Shop]JailBreak/CT/CTHitWall.wav" }
new const ct_hit1[] 				= { "[Shop]JailBreak/CT/CTHit1.wav",  }
new const ct_hit2[] 				= { "[Shop]JailBreak/CT/CTHit2.wav",  }
new const ct_hit3[] 				= { "[Shop]JailBreak/CT/CTHit3.wav",  }
new const ct_hit4[] 				= { "[Shop]JailBreak/CT/CTHit4.wav",  }
new const ct_stab[] 				= { "[Shop]JailBreak/CT/CTStab.wav"  }

new const PuanAldi[] 				= { "ZeybekGamingJail/PuanAldi.wav" }
new const seviyeatladipic[] 		= { "ZeybekGamingJail/seviyeatladipic.wav" }
new const yeniel[] 					= { "ZeybekGamingJail/yeniel.wav" }
new const karaktersecildi[] 		= { "ZeybekGamingJail/karaktersecildi.wav" }
new const karaktersecilmedi[] 		= { "ZeybekGamingJail/karaktersecilmedi.wav" }

new const gorunmezlikbasladi[] 		= { "ZeybekGamingJail/gorunmezlikbasladi.wav" }
new const zombibasladi[] 			= { "ZeybekGamingJail/zombibasladi.wav" }


/*============================================================
CSmiLeFaCe
============================================================*/

public plugin_init()
{

	register_plugin("ZeybekGaming JailBreak", "2.0", "CSmiLeFaCe-Enofine")

	RegisterHam(Ham_Spawn, 		"player", "oyuncudogdugunda",	1)
	register_logevent("YeniEl",2,"0=World triggered","1=Round_Start")
	RegisterHam(Ham_TakeDamage, 	"player", "hasaryediginde", 		0)
	RegisterHam(Ham_Killed,		"player", "oyuncugeberdiginde")
	/*============================================================
				CSmiLeFaCe-Enofine
	============================================================*/
	register_event("CurWeapon", 	"Event_Change_Weapon", "be", "1=1")
	register_forward(FM_SetClientKeyValue, "set_client_kv")
	register_forward(FM_SetModel, 	"fw_SetModel")
	register_forward(FM_EmitSound,	"Fwd_EmitSound")
	g_max_clients = get_maxplayers()
	register_message(get_user_msgid("StatusIcon"), "Message_StatusIcon");
	register_forward(FM_Voice_SetClientListening, "FwdSetVoice");
	register_message(get_user_msgid("TextMsg") ,"yenentakimindolu")
	g_iMsgSayText 	= get_user_msgid("SayText")
	syncObj 	= CreateHudSyncObj()
	register_clcmd( "say /oyunmenusu","OyunMenusu");
	/*============================================================
				Takim Ayarlari
	============================================================*/
	//oto T atma
	register_message(get_user_msgid("ShowMenu"), "message_show_menu")
	register_message(get_user_msgid("VGUIMenu"), "message_vgui_menu")
	g_pcvar_team = register_cvar("jb_takimisec", "1") //1 T / 2 CT / 6 Spec
	g_pcvar_class = register_cvar("jb_sinifi", "5") //bu degeri degistirmeyin
	//CT gecmelerini fixleme ve menuyu acmasi
	register_clcmd("jointeam","chooseteamlan")
	register_clcmd("teamjoin","chooseteamlan")
	register_clcmd("chooseteam","chooseteamlan")
	/*============================================================
	Cvar
	============================================================*/
	hud_goster1 = register_cvar("jb_goster1","Modumuz 1024x768 Alti Desteklemez")
	hud_goster2 = register_cvar("jb_goster2","Www.ZeybekGaming.Net")
	get_pcvar_string(hud_goster1,csmhud_goster1,31)
	get_pcvar_string(hud_goster2,csmhud_goster2,31)

	TDefaultDano 	= register_cvar("jb_dKnifeT", 		"20")
	CTDefaultDano 	= register_cvar("jb_dKnifeCT", 		"50")
	ZOMBIDefaultDano 	= register_cvar("jb_dKnifeZOMBI", 		"500")
	hTDefaultDano 	= register_cvar("jb_dHsKnifeT", 	"30")
	hCTDefaultDano 	= register_cvar("jb_dHsKnifeCT",	"80")
	hZOMBIDefaultDano 	= register_cvar("jb_dHsKnifeZOMBI",	"500")

	g_hediye = register_cvar("jb_hediyecani", "30")
	xp_gebertincegelsin = register_cvar("jb_gebertincegelsin","20")
	xp_hs_gebertincegelsin = register_cvar("jb_hs_gebertincegelsin","5")
	xp_enyukseklevel = register_cvar("jb_enyukseklevel","5")
	//Alttakileri Ellemeyin!
	xp_inc = register_cvar("jb__emre", "50")
	xp_start = register_cvar("jb_anil", "200")
	/*============================================================
	Jail Ayarlari
	============================================================*/
	server_cmd ("mp_autoteambalance 0")
	server_cmd ("mp_limitteams 0")
	server_cmd ("sv_alltalk 2")
	server_cmd ("sv_voicequality 5")
	server_cmd ("sv_voicecodec voice_speex")
	server_cmd ("sv_airaccelerate  999999")
	server_cmd ("mp_freezetime 2")
	server_cmd ("mp_roundtime 99999")
}
/*============================================================
Precaches
============================================================*/
public plugin_precache()
{
	precache_sound(PuanAldi)
	precache_sound(seviyeatladipic)
	precache_sound(yeniel)
	precache_sound(karaktersecildi)
	precache_sound(karaktersecilmedi)
	precache_sound(gorunmezlikbasladi)
	precache_sound(zombibasladi)

	precache_sound(t_deploy)
	precache_sound(t_slash1)
	precache_sound(t_slash2)
	precache_sound(t_stab)
	precache_sound(t_wall)
	precache_sound(t_hit1)
	precache_sound(t_hit2)
	precache_sound(t_hit3)
	precache_sound(t_hit4)

	precache_sound(ct_deploy)
	precache_sound(ct_slash1)
	precache_sound(ct_slash2)
	precache_sound(ct_stab)
	precache_sound(ct_wall)
	precache_sound(ct_hit1)
	precache_sound(ct_hit2)
	precache_sound(ct_hit3)
	precache_sound(ct_hit4)


	precache_model(VIEW_MODELT)
	precache_model(PLAYER_MODELT)
	precache_model(VIEW_MODELCT)
	precache_model(PLAYER_MODELCT)
	precache_model(WORLD_MODEL)
	precache_model(GORUNMEZ)
	precache_model(ZOMBIEL)
	precache_model("models/player/zombie_source/zombie_source.mdl")
	precache_model("models/player/PolisModelCSM/PolisModelCSM.mdl")
	precache_model("models/player/PolisModelCSM/PolisModelCSMT.mdl")
	precache_model("models/player/jbemodel/jbemodel.mdl")

	return PLUGIN_CONTINUE
}

public client_putinserver(id)
{
	set_task(1.0, "goster", id, _, _, "b")
}
public client_authorized(id){
	seviye[id]=1
	exp[id] = 0
}
public client_connect(id) {
	hediye[id] = 0
}
public client_disconnect(id) {
	hediye[id] = 0
}
public kontrol(id){
	new name[32]
	get_user_name(id,name,31)
	if(exp[id] >= g_exp(id)){
		seviye[id]++
		exp[id] = 0
		emit_sound(id, CHAN_AUTO, seviyeatladipic, VOL_NORM, ATTN_NORM , 0, PITCH_NORM)
	}
	else if(exp[id] < g_exp(id))
	{
		emit_sound(id, CHAN_AUTO, PuanAldi, VOL_NORM, ATTN_NORM , 0, PITCH_NORM)
	}
}

public goster(id)
{
	if (get_user_team(id) == 1 && is_user_alive(id) && is_user_connected(id) ) {
		set_hudmessage(0, 255, 0, 0.00, 0.00, 0, 6.0, 12.0)
		show_hudmessage(id, "^n=%s=^n^n^n^n^n^n^n^n^n=%s=",csmhud_goster1,csmhud_goster2)
		if(k_mahkum[id] == 1) {
			if(isyandurumu[id] == 1) {
				if(isyannasil[id] == 1) {
					set_hudmessage(0, 255, 255, 0.00, 0.00, 0, 6.0, 12.0)
					ShowSyncHudMsg(id, syncObj, "^n^nSeviye: [%d/%d]^nPuan: [%i/%i]^nKarakter: [NORMAL]^nHasar: [+0]^nCan: [%d]^nZirh: [%d]^nIsyan: [YAPILDI]^nIsyan Durumu: [BASARILI]",seviye[id],get_pcvar_num(xp_enyukseklevel),exp[id],g_exp(id),get_user_health(id),get_user_armor(id))
				}
				if(isyannasil[id] == 0) {
					set_hudmessage(0, 255, 255, 0.00, 0.00, 0, 6.0, 12.0)
					ShowSyncHudMsg(id, syncObj, "^n^nSeviye: [%d/%d]^nPuan: [%i/%i]^nKarakter: [NORMAL]^nHasar: [+0]^nCan: [%d]^nZirh: [%d]^nIsyan: [YAPILDI]^nIsyan Durumu: [BASARISIZ]",seviye[id],get_pcvar_num(xp_enyukseklevel),exp[id],g_exp(id),get_user_health(id),get_user_armor(id))
				}
			}
			if(isyandurumu[id] == 0) {
				set_hudmessage(0, 255, 255, 0.00, 0.00, 0, 6.0, 12.0)
				ShowSyncHudMsg(id, syncObj, "^n^nSeviye: [%d/%d]^nPuan: [%i/%i]^nKarakter: [NORMAL]^nHasar: [+0]^nCan: [%d]^nZirh: [%d]^nIsyan: [YAPILMADI]^nIsyan Durumu: [YOK]",seviye[id],get_pcvar_num(xp_enyukseklevel),exp[id],g_exp(id),get_user_health(id),get_user_armor(id))
			}
		}
		if(k_hizli[id] == 1) {
			if(isyandurumu[id] == 1) {
				if(isyannasil[id] == 1) {
					set_hudmessage(0, 255, 255, 0.00, 0.00, 0, 6.0, 12.0)
					ShowSyncHudMsg(id, syncObj, "^n^nSeviye: [%d/%d]^nPuan: [%i/%i]^nKarakter: [HIZLI]^nHasar: [+10]^nCan: [%d]^nZirh: [%d]^nIsyan: [YAPILDI]^nIsyan Durumu: [BASARILI]",seviye[id],get_pcvar_num(xp_enyukseklevel),exp[id],g_exp(id),get_user_health(id),get_user_armor(id))
				}
				if(isyannasil[id] == 0) {
					set_hudmessage(0, 255, 255, 0.00, 0.00, 0, 6.0, 12.0)
					ShowSyncHudMsg(id, syncObj, "^n^nSeviye: [%d/%d]^nPuan: [%i/%i]^nKarakter: [HIZLI]^nHasar: [+10]^nCan: [%d]^nZirh: [%d]^nIsyan: [YAPILDI]^nIsyan Durumu: [BASARISIZ]",seviye[id],get_pcvar_num(xp_enyukseklevel),exp[id],g_exp(id),get_user_health(id),get_user_armor(id))
				}
			}
			if(isyandurumu[id] == 0) {
				set_hudmessage(0, 255, 255, 0.00, 0.00, 0, 6.0, 12.0)
				ShowSyncHudMsg(id, syncObj, "^n^nSeviye: [%d/%d]^nPuan: [%i/%i]^nKarakter: [HIZLI]^nHasar: [+10]^nCan: [%d]^nZirh: [%d]^nIsyan: [YAPILMADI]^nIsyan Durumu: [YOK]",seviye[id],get_pcvar_num(xp_enyukseklevel),exp[id],g_exp(id),get_user_health(id),get_user_armor(id))
			}
		}
		if(k_kizgin[id] == 1) {
			if(isyandurumu[id] == 1) {
				if(isyannasil[id] == 1) {
					set_hudmessage(0, 255, 255, 0.00, 0.00, 0, 6.0, 12.0)
					ShowSyncHudMsg(id, syncObj, "^n^nSeviye: [%d/%d]^nPuan: [%i/%i]^nKarakter: [KIZGIN]^nHasar: [+15]^nCan: [%d]^nZirh: [%d]^nIsyan: [YAPILDI]^nIsyan Durumu: [BASARILI]",seviye[id],get_pcvar_num(xp_enyukseklevel),exp[id],g_exp(id),get_user_health(id),get_user_armor(id))
				}
				if(isyannasil[id] == 0) {
					set_hudmessage(0, 255, 255, 0.00, 0.00, 0, 6.0, 12.0)
					ShowSyncHudMsg(id, syncObj, "^n^nSeviye: [%d/%d]^nPuan: [%i/%i]^nKarakter: [KIZGIN]^nHasar: [+15]^nCan: [%d]^nZirh: [%d]^nIsyan: [YAPILDI]^nIsyan Durumu: [BASARISIZ]",seviye[id],get_pcvar_num(xp_enyukseklevel),exp[id],g_exp(id),get_user_health(id),get_user_armor(id))
				}
			}
			if(isyandurumu[id] == 0) {
				set_hudmessage(0, 255, 255, 0.00, 0.00, 0, 6.0, 12.0)
				ShowSyncHudMsg(id, syncObj, "^n^nSeviye: [%d/%d]^nPuan: [%i/%i]^nKarakter: [KIZGIN]^nHasar: [+15]^nCan: [%d]^nZirh: [%d]^nIsyan: [YAPILMADI]^nIsyan Durumu: [YOK]",seviye[id],get_pcvar_num(xp_enyukseklevel),exp[id],g_exp(id),get_user_health(id),get_user_armor(id))
			}
		}
		if(k_guclu[id] == 1) {
			if(isyandurumu[id] == 1) {
				if(isyannasil[id] == 1) {
					set_hudmessage(0, 255, 255, 0.00, 0.00, 0, 6.0, 12.0)
					ShowSyncHudMsg(id, syncObj, "^n^nSeviye: [%d/%d]^nPuan: [%i/%i]^nKarakter: [GÜCLÜ]^nHasar: [+30]^nCan: [%d]^nZirh: [%d]^nIsyan: [YAPILDI]^nIsyan Durumu: [BASARILI]",seviye[id],get_pcvar_num(xp_enyukseklevel),exp[id],g_exp(id),get_user_health(id),get_user_armor(id))
				}
				if(isyannasil[id] == 0) {
					set_hudmessage(0, 255, 255, 0.00, 0.00, 0, 6.0, 12.0)
					ShowSyncHudMsg(id, syncObj, "^n^nSeviye: [%d/%d]^nPuan: [%i/%i]^nKarakter: [GÜCLÜ]^nHasar: [+30]^nCan: [%d]^nZirh: [%d]^nIsyan: [YAPILDI]^nIsyan Durumu: [BASARISIZ]",seviye[id],get_pcvar_num(xp_enyukseklevel),exp[id],g_exp(id),get_user_health(id),get_user_armor(id))
				}
			}
			if(isyandurumu[id] == 0) {
				set_hudmessage(0, 255, 255, 0.00, 0.00, 0, 6.0, 12.0)
				ShowSyncHudMsg(id, syncObj, "^n^nSeviye: [%d/%d]^nPuan: [%i/%i]^nKarakter: [GÜCLÜ]^nHasar: [+30]^nCan: [%d]^nZirh: [%d]^nIsyan: [YAPILMADI]^nIsyan Durumu: [YOK]",seviye[id],get_pcvar_num(xp_enyukseklevel),exp[id],g_exp(id),get_user_health(id),get_user_armor(id))
			}
		}
		if(k_vip[id] == 1) {
			if(isyandurumu[id] == 1) {
				if(isyannasil[id] == 1) {
					set_hudmessage(0, 255, 255, 0.00, 0.00, 0, 6.0, 12.0)
					ShowSyncHudMsg(id, syncObj, "^n^nSeviye: [%d/%d]^nPuan: [%i/%i]^nKarakter: [VIP]^nHasar: [+20]^nCan: [%d]^nZirh: [%d]^nIsyan: [YAPILDI]^nIsyan Durumu: [BASARILI]",seviye[id],get_pcvar_num(xp_enyukseklevel),exp[id],g_exp(id),get_user_health(id),get_user_armor(id))
				}
				if(isyannasil[id] == 0) {
					set_hudmessage(0, 255, 255, 0.00, 0.00, 0, 6.0, 12.0)
					ShowSyncHudMsg(id, syncObj, "^n^nSeviye: [%d/%d]^nPuan: [%i/%i]^nKarakter: [VIP]^nHasar: [+20]^nCan: [%d]^nZirh: [%d]^nIsyan: [YAPILDI]^nIsyan Durumu: [BASARISIZ]",seviye[id],get_pcvar_num(xp_enyukseklevel),exp[id],g_exp(id),get_user_health(id),get_user_armor(id))
				}
			}
			if(isyandurumu[id] == 0) {
				set_hudmessage(0, 255, 255, 0.00, 0.00, 0, 6.0, 12.0)
				ShowSyncHudMsg(id, syncObj, "^n^nSeviye: [%d/%d]^nPuan: [%i/%i]^nKarakter: [VIP]^nHasar: [+20]^nCan: [%d]^nZirh: [%d]^nIsyan: [YAPILMADI]^nIsyan Durumu: [YOK]",seviye[id],get_pcvar_num(xp_enyukseklevel),exp[id],g_exp(id),get_user_health(id),get_user_armor(id))
			}
		}
	}

	if (get_user_team(id) == 2 && is_user_alive(id) && is_user_connected(id) )
	{
		new ts[32],tsnum
		for (new id=1; id <= g_max_clients; id++)
		{
			if (!is_user_connected(id) || !is_user_alive(id))
			{
				continue
			}
			if (cs_get_user_team(id) == CS_TEAM_T)
			{
				ts[tsnum++] = id
			}
		}
		set_hudmessage(255, 255, 255, 0.91, 0.85, 0, 6.0, 12.0)
		ShowSyncHudMsg(id, syncObj,"%d Mahkum var.", tsnum)
		set_hudmessage(255, 255, 255, 0.0, 0.9, 0, 6.0, 12.0)
		show_hudmessage(id, "CAN : %d" ,get_user_health(id))
	}
	return PLUGIN_CONTINUE;
}
public set_client_kv(id, const info[], const key[])
{
	if(equal(key, "model"))
		return FMRES_SUPERCEDE

	return FMRES_IGNORED
}
public oyuncudogdugunda(id)
{
	if (is_user_alive(id))
	{
		if (get_user_team(id) == 1 ) {
			new ver
			ver = seviye[id] * 3
			strip_user_weapons(id)
			give_item(id, "weapon_knife")
			set_user_health(id,get_user_health(id) + ver)
			set_user_maxspeed(id,230.0 )
			//cs_set_user_model(id, "ZeybekGaming-TE") acmayin zaten jbemodel var!
			cs_set_user_model(id, "jbemodel")
			set_user_info(id, "model", "jbemodel")
			entity_set_int(id, EV_INT_body, 2)
			entity_set_int(id, EV_INT_skin, 1)
			KarakterSec(id)
			weapon_oynat(id,10)
			set_task(1.6,"sifirlamodeli",id)
			if (hediye[id] == 1 ) {
				set_user_health(id,get_user_health(id) + get_pcvar_num(g_hediye))
			}
		}
		if (get_user_team(id) == 2 ) {
			cs_set_user_model(id, "PolisModelCSM")
			cs_set_user_nvg(id,0)
		}
		set_user_rendering(id, kRenderFxGlowShell,0, 0, 0, kRenderNormal, 255)
		set_user_godmode(id,0)
		set_user_footsteps(id, 0)
		//isyanci
		isyannasil[id] 	= 0
		isyandurumu[id] = 0
		//oyuncunun ozellikleri
		Gorunmez[id] 	= 0
		Zombi[id]   	= 0
		TCuchillo[id] 	= 1
		CTCuchillo[id] 	= 1
		//karakterler
		k_hizli[id] 	= 0
		k_guclu[id] 	= 0
		k_kizgin[id] 	= 0
		k_vip[id] 	= 0
		k_mahkum[id] 	= 1

		/*============================================================
								Etrafi Kaybetme
		============================================================*/

		new i_nesne
		i_nesne |= (1<<3)  //Can,Armor ve Radar
		i_nesne |= (1<<4)  //Ortadaki Saniye
		i_nesne |= (1<<5)  // Para
		// iFlags |= (1<<6)  // Aim

		new i_nesneyikaldir = i_nesne
		if(i_nesneyikaldir)
		{
			message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("HideWeapon"), _, id)
			write_byte(i_nesneyikaldir)
			message_end()
		}

	}
}
public sifirlamodeli (id) {
	weapon_oynat(id,3)
}
public YeniEl (id) {
	csmoyun = 0
	set_lights("#OFF")
	console_cmd(0,"spk %s",yeniel)
	server_cmd("jb_tesilahmenu 0")
	set_dhudmessage(0, 160, 0, -1.0, 0.25, 2, 6.0, 3.0, 0.1, 1.5);
	show_dhudmessage(0, "%s",hud_gaminghud);
	yazi(0, "%s",yazi_baslangicyazisi)
}
public hasaryediginde(victim, inflictor, attacker, Float:damage, damage_bits)
{
	if (is_valid_player(attacker) && get_user_weapon(attacker) == CSW_KNIFE)
	{
		switch(get_user_team(attacker))
		{
			case 1:
			{
				if(TCuchillo[attacker])
				{
					if (k_mahkum[attacker] == 1) {
						SetHamParamFloat(4, get_pcvar_float(TDefaultDano))

						if(get_pdata_int(victim, 75) == HIT_HEAD)
						{
							SetHamParamFloat(4, get_pcvar_float(hTDefaultDano))
						}
					}
					if (k_hizli[attacker] == 1) {
						SetHamParamFloat(4, get_pcvar_float(TDefaultDano) +10)

						if(get_pdata_int(victim, 75) == HIT_HEAD)
						{
							SetHamParamFloat(4, get_pcvar_float(hTDefaultDano) +10)
						}
					}
					if (k_kizgin[attacker] == 1) {
						SetHamParamFloat(4, get_pcvar_float(TDefaultDano) +15)

						if(get_pdata_int(victim, 75) == HIT_HEAD)
						{
							SetHamParamFloat(4, get_pcvar_float(hTDefaultDano) +15)
						}
					}
					if (k_guclu[attacker] == 1) {
						SetHamParamFloat(4, get_pcvar_float(TDefaultDano) +30)

						if(get_pdata_int(victim, 75) == HIT_HEAD)
						{
							SetHamParamFloat(4, get_pcvar_float(hTDefaultDano) +30)
						}
					}
					if (k_vip[attacker] == 1) {
						SetHamParamFloat(4, get_pcvar_float(TDefaultDano) +20)

						if(get_pdata_int(victim, 75) == HIT_HEAD)
						{
							SetHamParamFloat(4, get_pcvar_float(hTDefaultDano) +20)
						}
					}
				}
			}
			case 2:
			{
				if(CTCuchillo[attacker])
				{
					SetHamParamFloat(4, get_pcvar_float(CTDefaultDano))

					if(get_pdata_int(victim, 75) == HIT_HEAD)
					{
						SetHamParamFloat(4, get_pcvar_float(hCTDefaultDano))
					}
				}
				if(Gorunmez[attacker])
				{
					SetHamParamFloat(4, get_pcvar_float(CTDefaultDano))

					if(get_pdata_int(victim, 75) == HIT_HEAD)
					{
						SetHamParamFloat(4, get_pcvar_float(hCTDefaultDano))
					}
				}
				if(Zombi[attacker])
				{
					SetHamParamFloat(4, get_pcvar_float(ZOMBIDefaultDano))

					if(get_pdata_int(victim, 75) == HIT_HEAD)
					{
						SetHamParamFloat(4, get_pcvar_float(hZOMBIDefaultDano))
					}
				}
			}
		}
	}
	isyandurumu[attacker] = 1
	return HAM_HANDLED
}

public oyuncugeberdiginde(victim, attacker, shouldgib)
{
	if(get_user_team(attacker) == 1)
	{
		if(seviye[attacker] >= get_pcvar_num(xp_enyukseklevel)){
			yazi(attacker,"%s",yazi_maxseviye)
			return PLUGIN_HANDLED;
		}
		exp[attacker] += get_pcvar_num(xp_gebertincegelsin)
		kontrol(attacker)
		weapon_oynat(attacker,8)
		isyannasil[attacker] 	= 1
		if(get_pdata_int(victim, 75) == HIT_HEAD)
		{
			exp[attacker] += get_pcvar_num(xp_hs_gebertincegelsin)
		}
	}
	return PLUGIN_HANDLED;
}


public Event_Change_Weapon(id)
{
	new weaponID = read_data(2)

	switch (get_user_team(id))
	{
		case 1:
		{
			if(TCuchillo[id] && weaponID == CSW_KNIFE)
			{
				set_pev(id, pev_viewmodel2, VIEW_MODELT)
				set_pev(id, pev_weaponmodel2, PLAYER_MODELT)
			}
		}
		case 2:
		{
			if(weaponID == CSW_KNIFE)
			{
				if(CTCuchillo[id]){
					set_pev(id, pev_viewmodel2, VIEW_MODELCT)
					set_pev(id, pev_weaponmodel2, PLAYER_MODELCT)
				}
				if(Gorunmez[id]){
					set_pev(id, pev_viewmodel2, GORUNMEZ)
					set_pev(id, pev_weaponmodel2, PLAYER_MODELCT)
				}
				if(Zombi[id]){
					set_pev(id, pev_viewmodel2, ZOMBIEL)
					set_pev(id, pev_weaponmodel2, PLAYER_ZOMBIEL)
				}
			}
		}
	}
	return PLUGIN_CONTINUE
}

public fw_SetModel(entity, model[])
{
	if(!pev_valid(entity))
		return FMRES_IGNORED

	if(!equali(model, OLDWORLD_MODEL))
		return FMRES_IGNORED

	new className[33]
	pev(entity, pev_classname, className, 32)

	if(equal(className, "weaponbox") || equal(className, "armoury_entity") || equal(className, "grenade"))
	{
		engfunc(EngFunc_SetModel, entity, WORLD_MODEL)
		return FMRES_SUPERCEDE
	}
	return FMRES_IGNORED
}

public Fwd_EmitSound(id, channel, const sample[], Float:volume, Float:attn, flags, pitch)
{

	if (!is_user_connected(id))
		return FMRES_IGNORED;

	if(CTCuchillo[id])
	{
		if(get_user_team(id) == 2)
		{
			if (equal(sample[8], "kni", 3))
			{
				if (equal(sample[14], "sla", 3))
				{
					switch (random_num(1, 2))
					{
						case 1: engfunc(EngFunc_EmitSound, id, channel, ct_slash1, volume, attn, flags, pitch)
						case 2: engfunc(EngFunc_EmitSound, id, channel, ct_slash2, volume, attn, flags, pitch)
					}

					return FMRES_SUPERCEDE;
				}
				if(equal(sample,"weapons/knife_deploy1.wav"))
				{
					engfunc(EngFunc_EmitSound, id, channel, ct_deploy, volume, attn, flags, pitch)
					return FMRES_SUPERCEDE;
				}
				if (equal(sample[14], "hit", 3))
				{
					if (sample[17] == 'w')
					{
						engfunc(EngFunc_EmitSound, id, channel, ct_wall, volume, attn, flags, pitch)
						return FMRES_SUPERCEDE;
					}
					else
					{
						switch (random_num(1, 4))
						{
							case 1: engfunc(EngFunc_EmitSound, id, channel, ct_hit1, volume, attn, flags, pitch)
							case 2: engfunc(EngFunc_EmitSound, id, channel, ct_hit2, volume, attn, flags, pitch)
							case 3: engfunc(EngFunc_EmitSound, id, channel, ct_hit3, volume, attn, flags, pitch)
							case 4: engfunc(EngFunc_EmitSound, id, channel, ct_hit4, volume, attn, flags, pitch)
						}

						return FMRES_SUPERCEDE;
					}
				}
				if (equal(sample[14], "sta", 3))
				{
					engfunc(EngFunc_EmitSound, id, channel, ct_stab, volume, attn, flags, pitch)
					return FMRES_SUPERCEDE;
				}
			}
		}
	}

	if(Gorunmez[id])
	{
		if(get_user_team(id) == 2)
		{
			if (equal(sample[8], "kni", 3))
			{
				if (equal(sample[14], "sla", 3))
				{
					switch (random_num(1, 2))
					{
						case 1: engfunc(EngFunc_EmitSound, id, channel, ct_slash1, volume, attn, flags, pitch)
						case 2: engfunc(EngFunc_EmitSound, id, channel, ct_slash2, volume, attn, flags, pitch)
					}

					return FMRES_SUPERCEDE;
				}
				if(equal(sample,"weapons/knife_deploy1.wav"))
				{
					engfunc(EngFunc_EmitSound, id, channel, ct_deploy, volume, attn, flags, pitch)
					return FMRES_SUPERCEDE;
				}
				if (equal(sample[14], "hit", 3))
				{
					if (sample[17] == 'w')
					{
						engfunc(EngFunc_EmitSound, id, channel, ct_wall, volume, attn, flags, pitch)
						return FMRES_SUPERCEDE;
					}
					else
					{
						switch (random_num(1, 4))
						{
							case 1: engfunc(EngFunc_EmitSound, id, channel, ct_hit1, volume, attn, flags, pitch)
							case 2: engfunc(EngFunc_EmitSound, id, channel, ct_hit2, volume, attn, flags, pitch)
							case 3: engfunc(EngFunc_EmitSound, id, channel, ct_hit3, volume, attn, flags, pitch)
							case 4: engfunc(EngFunc_EmitSound, id, channel, ct_hit4, volume, attn, flags, pitch)
						}

						return FMRES_SUPERCEDE;
					}
				}
				if (equal(sample[14], "sta", 3))
				{
					engfunc(EngFunc_EmitSound, id, channel, ct_stab, volume, attn, flags, pitch)
					return FMRES_SUPERCEDE;
				}
			}
		}
	}
	if(Zombi[id])
	{
		if(get_user_team(id) == 2)
		{
			if (equal(sample[8], "kni", 3))
			{
				if (equal(sample[14], "sla", 3))
				{
					switch (random_num(1, 2))
					{
						case 1: engfunc(EngFunc_EmitSound, id, channel, t_slash1, volume, attn, flags, pitch)
						case 2: engfunc(EngFunc_EmitSound, id, channel, t_slash2, volume, attn, flags, pitch)
					}

					return FMRES_SUPERCEDE;
				}
				if(equal(sample,"weapons/knife_deploy1.wav"))
				{
					engfunc(EngFunc_EmitSound, id, channel, t_deploy, volume, attn, flags, pitch)
					return FMRES_SUPERCEDE;
				}
				if (equal(sample[14], "hit", 3))
				{
					if (sample[17] == 'w')
					{
						engfunc(EngFunc_EmitSound, id, channel, t_wall, volume, attn, flags, pitch)
						return FMRES_SUPERCEDE;
					}
					else
					{
						switch (random_num(1, 4))
						{
							case 1: engfunc(EngFunc_EmitSound, id, channel, t_hit1, volume, attn, flags, pitch)
							case 2: engfunc(EngFunc_EmitSound, id, channel, t_hit2, volume, attn, flags, pitch)
							case 3: engfunc(EngFunc_EmitSound, id, channel, t_hit3, volume, attn, flags, pitch)
							case 4: engfunc(EngFunc_EmitSound, id, channel, t_hit4, volume, attn, flags, pitch)
						}

						return FMRES_SUPERCEDE;
					}
				}
				if (equal(sample[14], "sta", 3))
				{
					engfunc(EngFunc_EmitSound, id, channel, t_stab, volume, attn, flags, pitch)
					return FMRES_SUPERCEDE;
				}
			}
		}
	}
	if(TCuchillo[id])
	{
		if(get_user_team(id) == 1)
		{
			if (equal(sample[8], "kni", 3))
			{
				if (equal(sample[14], "sla", 3))
				{
					switch (random_num(1, 2))
					{
						case 1: engfunc(EngFunc_EmitSound, id, channel, t_slash1, volume, attn, flags, pitch)
						case 2: engfunc(EngFunc_EmitSound, id, channel, t_slash2, volume, attn, flags, pitch)
					}

					return FMRES_SUPERCEDE;
				}
				if(equal(sample,"weapons/knife_deploy1.wav"))
				{
					engfunc(EngFunc_EmitSound, id, channel, t_deploy, volume, attn, flags, pitch)
					return FMRES_SUPERCEDE;
				}
				if (equal(sample[14], "hit", 3))
				{
					if (sample[17] == 'w')
					{
						engfunc(EngFunc_EmitSound, id, channel, t_wall, volume, attn, flags, pitch)
						return FMRES_SUPERCEDE;
					}
					else
					{
						switch (random_num(1, 4))
						{
							case 1: engfunc(EngFunc_EmitSound, id, channel, t_hit1, volume, attn, flags, pitch)
							case 2: engfunc(EngFunc_EmitSound, id, channel, t_hit2, volume, attn, flags, pitch)
							case 3: engfunc(EngFunc_EmitSound, id, channel, t_hit3, volume, attn, flags, pitch)
							case 4: engfunc(EngFunc_EmitSound, id, channel, t_hit4, volume, attn, flags, pitch)
						}

						return FMRES_SUPERCEDE;
					}
				}
				if (equal(sample[14], "sta", 3))
				{
					engfunc(EngFunc_EmitSound, id, channel, t_stab, volume, attn, flags, pitch)
					return FMRES_SUPERCEDE;
				}
			}
		}
	}
	return FMRES_IGNORED;
}

/*============================================================
Stock
============================================================*/
stock yazi(const id, const input[], any:...)
{
	new count = 1, players[32]
	static msg[191]
	vformat(msg, 190, input, 3)

	replace_all(msg, 190, "!y", "^4") // Green Color
	replace_all(msg, 190, "!n", "^1") // Default Color
	replace_all(msg, 190, "!t", "^3") // Team Color


	if (id) players[0] = id; else get_players(players, count, "ch")
	{
		for (new i = 0; i < count; i++)
		{
			if (is_user_connected(players[i]))
			{
				message_begin(MSG_ONE_UNRELIABLE, g_iMsgSayText, _, players[i])
				write_byte(players[i]);
				write_string(msg);
				message_end();
			}
		}
	}
}

stock ham_strip_weapon(id,weapon[])
{
	if(!equal(weapon,"weapon_",7)) return 0;

	new wId = get_weaponid(weapon);
	if(!wId) return 0;

	new wEnt;
	while((wEnt = engfunc(EngFunc_FindEntityByString,wEnt,"classname",weapon)) && pev(wEnt,pev_owner) != id) {}
	if(!wEnt) return 0;

	if(get_user_weapon(id) == wId) ExecuteHamB(Ham_Weapon_RetireWeapon,wEnt);

	if(!ExecuteHamB(Ham_RemovePlayerItem,id,wEnt)) return 0;
	ExecuteHamB(Ham_Item_Kill,wEnt);

	set_pev(id,pev_weapons,pev(id,pev_weapons) & ~(1<<wId));

	return 1;
}

/*============================================================
                     Takim Ayari
============================================================*/

public message_show_menu(msgid, dest, id) {
	if (!should_autojoin(id))
	{
		return PLUGIN_CONTINUE
	}


	static team_select[] = "#Team_Select"
	static menu_text_code[sizeof team_select]
	get_msg_arg_string(4, menu_text_code, sizeof menu_text_code - 1)
	if (!equal(menu_text_code, team_select))
		return PLUGIN_CONTINUE

	set_force_team_join_task(id, msgid)

	return PLUGIN_HANDLED
}

public message_vgui_menu(msgid, dest, id) {
	if (get_msg_arg_int(1) != TEAM_SELECT_VGUI_MENU_ID || !should_autojoin(id))
		return PLUGIN_CONTINUE

	set_force_team_join_task(id, msgid)

	return PLUGIN_HANDLED
}

bool:should_autojoin(id) {
	return (get_pcvar_num(g_pcvar_team) && !get_user_team(id) && !task_exists(id + 1790))
}

set_force_team_join_task(id, menu_msgid) {
	static param_menu_msgid[2]
	param_menu_msgid[0] = menu_msgid
	set_task(AUTO_TEAM_JOIN_DELAY, "task_force_team_join", id + 1790, param_menu_msgid, sizeof param_menu_msgid)
}

public task_force_team_join(menu_msgid[], taskid) {
	new id = taskid - 1790
	if (get_user_team(id))
		return

	static team[2], class[2]
	get_pcvar_string(g_pcvar_team, team, sizeof team - 1)
	get_pcvar_string(g_pcvar_class, class, sizeof class - 1)
	force_team_join(id, menu_msgid[0], team, class)
}

stock force_team_join(id, menu_msgid, /* const */ team[] = "5", /* const */ class[] = "0") {
	static jointeam[] = "jointeam"
	if (class[0] == '0') {
		engclient_cmd(id, jointeam, team)
		return
	}

	static msg_block, joinclass[] = "joinclass"
	msg_block = get_msg_block(menu_msgid)
	set_msg_block(menu_msgid, BLOCK_SET)
	engclient_cmd(id, jointeam, team)
	engclient_cmd(id, joinclass, class)
	set_msg_block(menu_msgid, msg_block)
}
public chooseteamlan(id)
{
	return PLUGIN_HANDLED
}
/*============================================================
Silah Oynatma Emre bu kodu kimseye gonderme!
============================================================*/
weapon_oynat(id, numara)
{
	set_pev(id, pev_weaponanim, numara)
	message_begin(MSG_ONE, SVC_WEAPONANIM, {0, 0, 0}, id)
	write_byte(numara)
	write_byte(pev(id, pev_body))
	message_end()
}
/*============================================================
Karakter Menusu
============================================================*/
public KarakterSec(id){
	if (get_user_team(id) == 1 )
	{
		new amenu = menu_create("\r|\wKARAKTER MENÜSÜ \d[ZeybekGaming.Net]","karakterdevam")
		menu_additem(amenu, "\r|\wNORMAL", "1", 0);
		if (seviye[id] >= 2) {
			menu_additem(amenu, "\r|\wHIZLI", "2", 0);
		} else {
			menu_additem(amenu, "\r|\dHIZLI \w[2. Seviye]", "6", 0);
		}
		if (seviye[id] >= 3) {
			menu_additem(amenu, "\r|\wKIZGIN", "3", 0);
		} else {
			menu_additem(amenu, "\r|\dKIZGIN \w[3. Seviye]", "6", 0);
		}
		if (seviye[id] >= 4) {
			menu_additem(amenu, "\r|\wGÜCLÜ", "4", 0);
		} else {
			menu_additem(amenu, "\r|\dGÜCLÜ \w[4. Seviye]", "6", 0);
		}
		menu_additem(amenu, "\w|\dVIP \r[Slot Yetkisi]", "5", ADMIN_LEVEL_B);
		menu_setprop(amenu,MPROP_EXIT,MEXIT_ALL)
		menu_display(id, amenu, 0)
	}
}

public karakterdevam(id,amenu,item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(amenu)
		return PLUGIN_HANDLED
	}
	new acces, callback, data[6], iname[64]
	menu_item_getinfo(amenu, item, acces, data, 5, iname, 63,callback)
	if(str_to_num(data) == 1)
	{
		entity_set_int(id, EV_INT_skin, 1)
		k_hizli[id] 	= 0
		k_guclu[id] 	= 0
		k_kizgin[id] 	= 0
		k_vip[id] 	= 0
		k_mahkum[id] 	= 1
		console_cmd(0,"spk %s",karaktersecildi)
	}
	else if(str_to_num(data) == 2)
	{
		entity_set_int(id, EV_INT_skin, 2)
		k_guclu[id] 	= 0
		k_kizgin[id] 	= 0
		k_vip[id] 	= 0
		k_mahkum[id] 	= 0
		k_hizli[id] 	= 1
		console_cmd(0,"spk %s",karaktersecildi)
		set_user_maxspeed(id,280.0 )
	}
	else if(str_to_num(data) == 3)
	{
		entity_set_int(id, EV_INT_skin, 4)
		k_guclu[id] 	= 0
		k_vip[id] 	= 0
		k_mahkum[id] 	= 0
		k_hizli[id] 	= 0
		k_kizgin[id] 	= 1
		console_cmd(0,"spk %s",karaktersecildi)
	}
	else if(str_to_num(data) == 4)
	{
		entity_set_int(id, EV_INT_skin, 0)
		k_vip[id] 	= 0
		k_mahkum[id] 	= 0
		k_hizli[id] 	= 0
		k_kizgin[id] 	= 0
		k_guclu[id] 	= 1
		console_cmd(0,"spk %s",karaktersecildi)
	}
	else if(str_to_num(data) == 5)
	{
		entity_set_int(id, EV_INT_skin, 3)
		k_mahkum[id] 	= 0
		k_hizli[id] 	= 0
		k_kizgin[id] 	= 0
		k_guclu[id] 	= 0
		k_vip[id] 	= 1
		console_cmd(0,"spk %s",karaktersecildi)
	}
	else if(str_to_num(data) == 6)
	{
		KarakterSec(id)
		console_cmd(0,"spk %s",karaktersecilmedi)
	}
	menu_destroy(amenu)
	return PLUGIN_HANDLED
}
/*============================================================
Oyun Menusu
============================================================*/
public OyunMenusu(id){
	if (get_user_team(id) == 2 )
	{
		new amenu = menu_create("\r|\wOYUN MENÜSÜ \d[ZeybekGaming.Net]","oyunundevami")
		if(csmoyun == 0) {
			menu_additem(amenu, "\r|\wGorunmezlik Oyununu \rBaslat", "1", 0);
		} else {
			menu_additem(amenu, "\r|\wOyunu \rKapat", "1", 0);
		}
		if(csmoyun == 0) {
			menu_additem(amenu, "\r|\wZombi Oyununu \rBaslat", "2", 0);
		} else {
			menu_additem(amenu, "\r|\wOyunu \rKapat", "2", 0);
		}
		menu_setprop(amenu,MPROP_EXIT,MEXIT_ALL)
		menu_display(id, amenu, 0)
	}
}

public oyunundevami(id,amenu,item)
{
	if(item == MENU_EXIT)
	{
		menu_destroy(amenu)
		return PLUGIN_HANDLED
	}
	new acces, callback, data[6], iname[64]
	menu_item_getinfo(amenu, item, acces, data, 5, iname, 63,callback)
	if(str_to_num(data) == 1)
	{
		if(csmoyun == 0) {
			gorunmezlikoyunuacik(id)
		} else {
			oyunkapali(id)
		}
	}
	else if(str_to_num(data) == 2)
	{
		if(csmoyun == 0) {
			zombioyunuacik(id)

		} else {
			oyunkapali(id)
		}
	}
	menu_destroy(amenu)
	return PLUGIN_HANDLED
}
/*============================================================
Tmik ve Buy Engel
============================================================*/
public FwdSetVoice(receiver, sender, bool:listen) {
	if( !(1 <= receiver <= g_max_clients)
	|| !g_connected[receiver]
	|| !(1 <= sender <= g_max_clients)
	|| !g_connected[sender] ) return FMRES_IGNORED;

	new CsTeams:team = cs_get_user_team(sender);
	if( (team == CS_TEAM_T || team == CS_TEAM_CT && !is_user_alive(sender)) && !access(sender, ADMIN_VOICE) ) {
		engfunc(EngFunc_SetClientListening, receiver, sender, 0);
		return FMRES_SUPERCEDE;
	}

	return FMRES_IGNORED;
}
public Message_StatusIcon(iMsgId, iMsgDest, id)
{
	static szIcon[8];
	get_msg_arg_string(2, szIcon, charsmax(szIcon));
	if( equal(szIcon, "buyzone") )
	{
		if( get_msg_arg_int(1) )
		{
			set_pdata_int(id, 235, get_pdata_int(id, 235) & ~(1<<0));
			return PLUGIN_HANDLED;
		}
	}

	return PLUGIN_CONTINUE;
}
/*============================================================
Yenen Takim
============================================================*/
public yenentakimindolu( const MsgId, const MsgDest, const MsgEntity )
{
    static yeneninmesaji[32]
    get_msg_arg_string(2, yeneninmesaji, charsmax(yeneninmesaji))

    if(equal(yeneninmesaji, "#CTs_Win"))
    {
        set_msg_arg_string(2, "Gardiyanlar Kazandi!")
    }
    else if(equal(yeneninmesaji, "#Terrorists_Win"))
    {
        set_msg_arg_string(2, "Mahkumlar Kazandi!")
    }
}
/*============================================================
Gorunmezlik Oyunu
============================================================*/
public gorunmezlikoyunuacik(id) {
	if (csmoyun == 0){
		for(new i = 1; i < 33; i++){
			csmoyun = 1
			set_hudmessage(0, 255, 0, 0.29, 0.25, 1, 6.0, 10.0,_,_,-1)
			show_hudmessage(0, "%s",hud_gorunmezlik)
			console_cmd(i,"spk %s",gorunmezlikbasladi)
			set_lights("#OFF")
			server_cmd("jb_tesilahmenu 0")
			if(is_user_connected(i) && is_user_alive(i) && get_user_team(i) == 2){
				set_user_rendering(i, kRenderFxGlowShell, 0, 0, 0, kRenderTransAlpha, 20)
				strip_user_weapons(i)
				give_item(i, "weapon_knife")
				engclient_cmd(i, "weapon_knife")
				set_user_health(i,get_playersnum() * 1000)
				cs_set_user_model(i, "PolisModelCSM")
				set_user_godmode(i,1)
				CTCuchillo[i] 	= 0
				Zombi[i] 	= 0
				Gorunmez[i] 	= 1
			}
			if(is_user_connected(i) && is_user_alive(i) && get_user_team(i) == 1){
				strip_user_weapons(i)
				give_item(i, "weapon_knife")
				engclient_cmd(i, "weapon_knife")
				weapon_oynat(i, 9)
			}
		}
	}
}
/*============================================================
Zombi Oyunu
============================================================*/
public zombioyunuacik(id) {
	if (csmoyun == 0){
		for(new i = 1; i < 33; i++){
			csmoyun = 1
			set_hudmessage(0, 255, 0, 0.29, 0.25, 1, 6.0, 10.0,_,_,-1)
			show_hudmessage(0, "%s",hud_zombi)
			console_cmd(i,"spk %s",zombibasladi)
			set_lights("b")
			server_cmd("jb_tesilahmenu 1")
			if(is_user_connected(i) && is_user_alive(i) && get_user_team(i) == 2){
				CTCuchillo[i] 	= 0
				Gorunmez[i] 	= 0
				Zombi[i] 	= 1
				set_user_rendering(i, kRenderFxGlowShell,0, 0, 0, kRenderNormal, 255)
				set_user_godmode(i,0)
				strip_user_weapons(i)
				give_item(i, "weapon_knife")
				engclient_cmd(i, "weapon_knife")
				cs_set_user_nvg(i,1)
				client_cmd(i,"nightvision")
				set_user_health(i,get_playersnum() * 1000)
				cs_set_user_model(i, "zombie_source")
			}
			if(is_user_connected(i) && is_user_alive(i) && get_user_team(i) == 1){
				client_cmd(i,"silahinisec")
			}
		}
	}
}
/*============================================================
Oyun Kapatma
============================================================*/
public oyunkapali(id) {
	if (csmoyun == 1){
		for(new i = 1; i < 33; i++){
			csmoyun = 0
			set_hudmessage(0, 255, 0, 0.29, 0.25, 1, 6.0, 10.0,_,_,-1)
			show_hudmessage(0, "%s",hud_oyunkapatildi)
			set_lights("#OFF")
			server_cmd("jb_tesilahmenu 0")
			if(is_user_connected(i) && is_user_alive(i) && get_user_team(i) == 2){
				set_user_rendering(i, kRenderFxGlowShell,0, 0, 0, kRenderNormal, 255)
				set_user_godmode(i,0)
				Gorunmez[i] 	= 0
				Zombi[i] 	= 0
				CTCuchillo[i] 	= 1
				give_item(i, "weapon_m4a1")
				engclient_cmd(i, "weapon_m4a1")
				cs_set_user_bpammo(i, CSW_M4A1, 90)
				set_pev(i, pev_health,100.0)
				set_pev(i, pev_armorvalue, 100.0)
				cs_set_user_nvg(i,0)
				cs_set_user_model(i, "PolisModelCSM")
			}
			if(is_user_connected(i) && is_user_alive(i) && get_user_team(i) == 1){
				strip_user_weapons(i)
				give_item(i,"weapon_knife")
				set_pev(i, pev_health,100.0)
				weapon_oynat(i, 8)
			}
		}
	}
}

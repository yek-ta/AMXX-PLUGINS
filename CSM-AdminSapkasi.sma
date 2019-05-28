#include <amxmodx>
#include <engine>

	//Eðer ki admin_head modelini kullanmaya devam edecekseniz bir alt satýrdaki #define SADECE_PRO_SAPKASI nýn baþýnda // olmayacak,
	//Ama eðer ki pelerin modeli yada abuk sabuk bir model için ayarlama yapacaksanýz aþaðýdaki #define SADECE_PRO_SAPKASI nýn baþýnda // olmalý.
	//Bunun sebebi bu eklentinin admin_head.mdl modeline uyumlu yazýlmasý.

#define SADECE_PRO_SAPKASI

//Eklenti Hakkýnda -> Admin þapkasýnýn skin deðiþimi için oyuncu doðmasýný algýlayan bir yer lazým, hamsandwich.
#if defined SADECE_PRO_SAPKASI
#include <hamsandwich>
#endif

//Eklenti Hakkýnda -> 1.8.3 uyumunu bu þekilde saðladým, eðer ki AmxModx sürümü 1.8.3'ün altýnda ise disconnected kýsmýný disconnect olarak deðiþtirecek.
#if AMXX_VERSION_NUM < 183
	#define client_disconnected client_disconnect
#endif	




	//Admin yetkisi, kick olarak ayarladým ben, gerekirse deðiþtirirsiniz.
#define YETKI ADMIN_KICK


	//Þapka modelinin yolu, eðer bu modeli deðiþtirecekseniz SADECE_PRO_SAPKASI ayarýndan çýkartýnýz. Satýr 4'ü okuyunuz.
new const SAPKA_YOLU[] = "models/admin_head.mdl";

new Ent[33];

public plugin_init() {
	register_plugin("Admin Sapkasi", "1.0", "CSmiLeFaCe");
	#if defined SADECE_PRO_SAPKASI
	RegisterHam(Ham_Spawn, "player", "Spawn", true);
	//Eklenti Hakkýnda -> Spawn kullanmamýn sebebi eðer ki model deðiþikliði olur ise þapkanýnda ona göre deðiþmesi.
	#endif
}
#if defined SADECE_PRO_SAPKASI
public Spawn(id) {
	if(is_valid_ent(Ent[id]) && is_user_connected(id) && is_user_alive(id)) {
		new modelID = get_model_id(id)
		entity_set_int(Ent[id], EV_INT_body, modelID);
	}
}
#endif
Kontrol(const id) {
	if(Ent[id] && is_valid_ent(Ent[id])) {
		entity_set_int(Ent[id], EV_INT_flags, FL_KILLME);
		entity_set_float(Ent[id], EV_FL_nextthink, get_gametime());
		Ent[id] = 0;
	}
}
public client_putinserver(id) {
	if(!(get_user_flags(id) & YETKI)) {
		return;
	}
	Kontrol(id);
	if((Ent[id] = create_entity("info_target"))) {
		entity_set_string(Ent[id], EV_SZ_classname, "sapka");
		entity_set_model(Ent[id], SAPKA_YOLU);
		entity_set_int(Ent[id], EV_INT_movetype, MOVETYPE_FOLLOW);
		entity_set_edict(Ent[id], EV_ENT_aiment, id);
	}
}

public client_disconnected(id) {
	Kontrol(id);
}

public plugin_precache() {
	precache_model(SAPKA_YOLU);
	#if defined SADECE_PRO_SAPKASI
	force_unmodified(force_model_samebounds,{0,0,0},{0,0,0},"models/player/gign/gign.mdl");
	force_unmodified(force_model_samebounds,{0,0,0},{0,0,0},"models/player/gsg9/gsg9.mdl");
	force_unmodified(force_model_samebounds,{0,0,0},{0,0,0},"models/player/sas/sas.mdl");
	force_unmodified(force_model_samebounds,{0,0,0},{0,0,0},"models/player/urban/urban.mdl");
	force_unmodified(force_model_samebounds,{0,0,0},{0,0,0},"models/player/vip/vip.mdl");
	force_unmodified(force_model_samebounds,{0,0,0},{0,0,0},"models/player/arctic/arctic.mdl");
	force_unmodified(force_model_samebounds,{0,0,0},{0,0,0},"models/player/guerilla/guerilla.mdl");
	force_unmodified(force_model_samebounds,{0,0,0},{0,0,0},"models/player/leet/leet.mdl");
	force_unmodified(force_model_samebounds,{0,0,0},{0,0,0},"models/player/terror/terror.mdl");
	//Buralarý bilmiyorum neden yazýlmýþ, KaLoSZyFeR yazmýþ, kullanmaz isek ayýp olur.
	#endif
}
#if defined SADECE_PRO_SAPKASI
//Alt kýsým adminmark eklentisinden hazýr olarak alýnmýþtýr. 
//Written by KaLoSZyFeR for adminmark model file.
new modelname[9][] ={
	"gign",
	"gsg9",
	"sas",
	"urban",
	"vip",
	"arctic",
	"guerilla",
	"leet",
	"terror"
}
public get_model_id(id)
{
	new modelStr[32], iNum=32, modelID
	get_user_info(id,"model",modelStr,iNum)
	
	for(new i = 0; i < 9; i++)
	{
		if (equali (modelStr, modelname[i]) )
		{
			modelID = i
		}
	}	
	return modelID
}
#endif
/* AMXX-Studio Notes - DO NOT MODIFY BELOW HERE
*{\\ rtf1\\ ansi\\ deff0{\\ fonttbl{\\ f0\\ fnil Tahoma;}}\n\\ viewkind4\\ uc1\\ pard\\ lang1031\\ f0\\ fs16 \n\\ par }
*/

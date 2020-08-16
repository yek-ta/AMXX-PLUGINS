
#include <amxmodx>
#include <reapi_reunion>

#define PLUGIN "AuthID Checker"
#define VERSION "1.5"
#define AUTHOR "Yek'-ta"
#define HAFIZADA_TUTULAN 35
#define LOGSDIR "addons/amxmodx/csdattacklogs"
#define LOGSFILE "saldirganclient.log"

new i_ipadresikayit[HAFIZADA_TUTULAN+1][32];
new i_authidkayit[HAFIZADA_TUTULAN+1][32];
new bool:i_guveniliroyuncu[MAX_PLAYERS+1];
new i_dongu;
new g_szAuthIDLogFile[128]

public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR);
	
	formatex(g_szAuthIDLogFile,charsmax(g_szAuthIDLogFile),"%s/%s",LOGSDIR,LOGSFILE);
}
public client_connect(PlayerID){
	if(is_user_steam(PlayerID) || is_user_bot(PlayerID) || PlayerID == 0 ){
		i_guveniliroyuncu[PlayerID]=true;
		return PLUGIN_HANDLED;
	}
	
	new szIP[MAX_IP_LENGTH];
	new szAuthID[MAX_AUTHID_LENGTH];
	
	get_user_authid(PlayerID, szAuthID, charsmax(szAuthID));
	get_user_ip(PlayerID, szIP, charsmax(szIP),1);
	//server_print("Sunucuya giren %s | %s",szIP,szAuthID);
	for(new i ; i <= HAFIZADA_TUTULAN ; i++){
		//server_print("Sorgusu yapilan %s", i_ipadresikayit[i]);
		if(equal( szIP, i_ipadresikayit[i] )){
			if(equal( szAuthID, i_authidkayit[i] )){
				//server_print("Daha once girisi bulundu %s | %s | %s | %s",szIP,szAuthID, i_ipadresikayit[i], i_authidkayit[i]);
				i_guveniliroyuncu[PlayerID]=true;
				return PLUGIN_HANDLED;
			}
			else{
				new szUserID,szMakeLog[128],szUserName[MAX_NAME_LENGTH];
				get_user_name(PlayerID,szUserName,charsmax(szUserName));
				szUserID = get_user_userid(PlayerID);
				
				client_print_color(0,print_team_grey,"^3[CSD Guard] ^1%s oyunucusunda saldirgan client algilandigi icin banlandi",szUserName)
				formatex(szMakeLog,charsmax(szMakeLog),"<%s><%s><%s> [ 30 dk ban ] ",szUserName, szAuthID, i_authidkayit[i]);
				write_file(g_szAuthIDLogFile, szMakeLog);
				
				server_cmd("kick #%d ^"Saldirgan Client^";wait;addip ^"30^" ^"%s^";wait;writeip",szUserID,szIP);
				return PLUGIN_HANDLED;
			}
		}
	}
	if(!i_guveniliroyuncu[PlayerID]){
		client_cmd(PlayerID,"steam_random_id 1")
		copy(i_ipadresikayit[i_dongu], charsmax(i_ipadresikayit[]), szIP);
		copy(i_authidkayit[i_dongu], charsmax(i_authidkayit[]), szAuthID);
		//server_print("Kayit Edildi %s | %s",i_ipadresikayit[i_dongu],i_authidkayit[i_dongu]);
		client_cmd(PlayerID,"echo [CSD Guard] Dosya kontrol baslatildi..")
		i_dongu++;
		if(i_dongu > HAFIZADA_TUTULAN-2){
			i_dongu = 0;
		}
		send_director_cmd(PlayerID,"retry");
	}
	return PLUGIN_CONTINUE;
}
public client_disconnected(PlayerID){
	i_guveniliroyuncu[PlayerID] = false
}

public client_putinserver(PlayerID){
	if(is_user_steam(PlayerID) || is_user_bot(PlayerID)){
		return PLUGIN_HANDLED;
	}
	if(!i_guveniliroyuncu[PlayerID] && is_user_connected(PlayerID)){
		new szUserID,szMakeLog[128],szUserName[MAX_NAME_LENGTH];
		get_user_name(PlayerID,szUserName,charsmax(szUserName));
		szUserID = get_user_userid(PlayerID);
		
		formatex(szMakeLog,charsmax(szMakeLog),"<%s> [ Kicklendi | %i] ",szUserName, PlayerID);
		write_file(g_szAuthIDLogFile, szMakeLog);
		server_cmd("kick #%d ^"Komut onleyici tespiti^"",szUserID);
		client_print_color(0,print_team_grey,"^3[CSD Guard] ^1%s oyunucusunda komut onleyici tespit edildi",szUserName)
	}
	return PLUGIN_CONTINUE;
}

stock send_director_cmd(id , text[])
{
    message_begin( MSG_ONE, SVC_DIRECTOR, _, id );
    write_byte( strlen(text) + 2 );
    write_byte( 10 );
    write_string( text );
    message_end();
}
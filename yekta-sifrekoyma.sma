#include <amxmodx>

#define YETKI ADMIN_RCON

public plugin_init()
{
	register_plugin("Sifre Ayarlama", "1.0", "Yek'-ta") //forum.csduragi.com

	register_clcmd("say","SayPw")
	register_clcmd("say_team","SayPw")

	server_cmd("sv_password ^"^"") //Harita geçiþlerinde þifreyi kaldýrmak için alternatif mevzular
}

public SayPw( id)
{
	new szSaid[128]; read_args(szSaid,charsmax(szSaid))
	remove_quotes(szSaid)

	if( (szSaid[0] == '!' || szSaid[0] == '/' || szSaid[0] == '.') && szSaid[1] == 'a' && szSaid[2] == 'd' && szSaid[3] == 'm' && szSaid[4] == 'i' && szSaid[5] == 'n' && szSaid[6] == 'p' && szSaid[7] == 'w'){
		if(get_user_flags( id ) & YETKI ){
			if(szSaid[9] == '0' || equal(szSaid[9], "")){
				new pass[32]
				get_cvar_string("sv_password",pass,sizeof(pass) - 1)
				if(pass[0]){//Yekta Güleryüz
					server_cmd("sv_password ^"^"")
					for(new i=1;i<=32;i++) {
						if(get_user_flags( i ) & ADMIN_RESERVATION){
							client_print_color(i, print_team_red, "^4%s ^1PW'yi kaldirdi.", isim(id))
							client_print_color(i, print_team_red, "^4%s ^1PW'yi kaldirdi.", isim(id))
							client_print_color(i, print_team_red, "^4%s ^1PW'yi kaldirdi.", isim(id))
						}
					}
				}
				else{
					client_print_color(id, print_team_red, "^4Password bulunamadi.")
					client_print_color(id, print_team_red, "^4Password bulunamadi.")
				}
				return PLUGIN_HANDLED
			}
			else{
				server_cmd("sv_password %s", szSaid[9])

				for(new i=1;i<=32;i++) {
					if(get_user_flags( i ) & ADMIN_RESERVATION){
						client_print_color(i, print_team_red, "^4%s ^1PW'yi degistirdi. Yeni ^3Server Password :  %s", isim(id),szSaid[9])
						client_print_color(i, print_team_red, "^4%s ^1PW'yi degistirdi. Yeni ^3Server Password :  %s", isim(id),szSaid[9])
						client_print_color(i, print_team_red, "^4%s ^1PW'yi degistirdi. Yeni ^3Server Password :  %s", isim(id),szSaid[9])
					}
				}

				return PLUGIN_HANDLED
			}
		}
	}
	else if( (szSaid[0] == '!' || szSaid[0] == '/' || szSaid[0] == '.') && szSaid[1] == 'p' && szSaid[2] == 'w'){
		new pass[32]
		get_cvar_string("sv_password",pass,sizeof(pass) - 1)

		if(pass[0])
		{
			client_print_color(id, print_team_grey, "^3Server Password : %s", pass)
			client_cmd(id,"password ^"%s^"",pass)
		}
		else {
			client_print_color(id, print_team_blue, "^3Serverda Sifre Yok.")
		}
		return PLUGIN_HANDLED

	}

	return PLUGIN_CONTINUE
}
stock isim(oyuncu){
	new isimver[32]
	get_user_name(oyuncu, isimver, 31)

	return isimver;
}


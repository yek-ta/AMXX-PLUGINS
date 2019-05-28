/* forum.csduragi.com */

#include <amxmodx>
#include <amxmisc>

#define PLUGIN "CSD Semiclip Controller"
#define VERSION "2"
#define AUTHOR "Yek'-ta"

new bool:cokmeengel=false;
public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR)

	register_concmd("amx_semiclip", "cmdsemiclip", ADMIN_CVAR)
}
public cmdsemiclip(id, level, cid)
{
	if (!cmd_access(id, level, cid, 2))
		return PLUGIN_HANDLED

	new arg[12], arg2[8]

	read_argv(1, arg, charsmax(arg))
	read_argv(2, arg2, charsmax(arg2))

	if (equali(arg,"1")){
		server_cmd("semiclip_option semiclip 1");
		new isim[32]
		get_user_name(id, isim, 31)
		chat_color(0,"!gCSDuragi !y: !g%s !yisimli yetkili !tsemiclip acti.", isim);
		console_print(id, "[CSD] semiclip komutunu %s olarak ayarladin.", arg)
		return PLUGIN_HANDLED;
	}
	else if(equali(arg,"0")){
		server_cmd("semiclip_option semiclip 0");
		new isim[32]
		get_user_name(id, isim, 31)
		chat_color(0,"!gCSDuragi !y: !g%s !yisimli yetkili !tsemiclip kapatti.", isim);
		console_print(id, "[CSD] semiclip komutunu %s olarak ayarladin.", arg)
		return PLUGIN_HANDLED;
	}
	else if(equali(arg,"takim")){
		if(equali(arg2,"herkes")){
			server_cmd("semiclip_option team 0");
		}
		else if(equali(arg2,"te")){
			server_cmd("semiclip_option team 1");
		}
		else if(equali(arg2,"ct")){
			server_cmd("semiclip_option team 2");
		}
		else if(equali(arg2,"takim")){
			server_cmd("semiclip_option team 3");
		}
		else {
			console_print(id, "[CSD] %s ayari tanimli degil.", arg2)
			return PLUGIN_HANDLED;
		}

	}
	else if(equali(arg,"sure")){
		if(!cokmeengel){
			if(!is_str_num(arg2) || equal(arg2, "")){
				console_print(id, "[CSD] sure ayari icin bir sayi girmelisiniz.");
				return PLUGIN_HANDLED;
			}
			server_cmd("semiclip_option time %s",arg2);
			cokmeengel=true;
		}
		else{
			console_print(id, "[CSD] sure ayarini her haritada sadece bir kere kullanabilirsiniz.");
			return PLUGIN_HANDLED;
		}
	}
	else if(equali(arg,"sirtacikma")){
		if(!is_str_num(arg2) || equal(arg2, "")){
			console_print(id, "[CSD] bir sayi girmelisiniz.");
			return PLUGIN_HANDLED;
		}
		server_cmd("semiclip_option crouch %s",arg2);
	}
	else if(equali(arg,"mesafe")){
		if(!is_str_num(arg2) || equal(arg2, "")){
			console_print(id, "[CSD] bir sayi girmelisiniz.");
			return PLUGIN_HANDLED;
		}
		server_cmd("semiclip_option distance %s",arg2);
	}
	else if(equali(arg,"seffaflik")){
		if(!is_str_num(arg2) || equal(arg2, "")){
			console_print(id, "[CSD] bir sayi girmelisiniz.");
			return PLUGIN_HANDLED;
		}
		server_cmd("semiclip_option transparency %s",arg2);
	}
	else{
		console_print(id, "[CSD] %s komutu tanimli degil.", arg)
		return PLUGIN_HANDLED;
	}

	new isim[32]
	get_user_name(id, isim, 31)
	chat_color(0,"!gCSDuragi !y: !g%s !yisimli yetkili semiclip_!t%s !ykomutunu !t%s !yolarak ayarladi.", isim, arg, arg2);
	console_print(id, "[CSD] %s komutunu %s olarak ayarladin.", arg, arg2)

	return PLUGIN_HANDLED
}

stock chat_color(const id, const input[], any:...)
{
	new count = 1, players[32]
	static msg[191]
	vformat(msg, 190, input, 3)

	replace_all(msg, 190, "!g", "^4")
	replace_all(msg, 190, "!y", "^1")
	replace_all(msg, 190, "!t", "^3")
	replace_all(msg, 190, "!team2", "^0")

	if (id) players[0] = id; else get_players(players, count, "ch")
	{
		for (new i = 0; i < count; i++)
		{
			if (is_user_connected(players[i]))
			{
				message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("SayText"), _, players[i])
				write_byte(players[i]);
				write_string(msg);
				message_end();
			}
		}
	}
}

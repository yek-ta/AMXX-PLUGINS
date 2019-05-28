//Bu eklenti CSmiLeFaCe tarafýndan düzenlenmiþtir ve www.csplugin.com da paylaþýlmýþtýr. 12.09.2015
/*

CSM izleyici göstergesi; çoğu pro public serverda kurulu olan SpecList eklentisinin benim tarafımdan düzenlenmiş halidir. Düzenleme notlarını konu içeriğinde görebilirsiniz..


Uzun süredir kendi serverım için düzenlediğim ve kullandığım bir eklentidir, hala da serverım da kuruludur.
Kimin kimi izlediği hud mesajını sağ taraftan sol tarafa aldım.
Hud mesajı sadece izleyicilerde gözükecek şekilde düzenledim, yani beni kimin izlediğini göremem ama beni izleyenler birbirini görebilir.
İzlenilen oyuncunun rank sıralamasın da kaçıncı olduğunu yazdırdım.
C yetkili adminler bu izleyici listesinde nickleri gözükmez.


Read more: http://www.csplugin.com/2015/09/csm-izleyici-gostergesi-speclist.html#ixzz5pDjhOzKG

*/

#include <amxmodx>
#include <fakemeta>
#include <csx>

#pragma semicolon 1

#define RED 64
#define GREEN 64
#define BLUE 64
#define UPDATEINTERVAL 1.0
#define ECHOCMD
#define FLAG ADMIN_LEVEL_C

new const PLUGIN[] = "SpecList-Canavar";
new const VERSION[] = "1.2a";
new const AUTHOR[] = "FatalisDK:CSM";

new gMaxPlayers;
new gCvarOn;
new gCvarImmunity;
new bool:gOnOff[33] = { true, ... };
new say_text;

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR);

	register_cvar(PLUGIN, VERSION, FCVAR_SERVER, 0.0);
	gCvarOn = register_cvar("amx_speclist", "1", 0, 0.0);
	gCvarImmunity = register_cvar("amx_speclist_immunity", "1", 0, 0.0);

	register_clcmd("say /speclist", "cmdSpecList", -1, "");
	register_clcmd("say !speclist", "cmdSpecList", -1, "");
	register_clcmd("say .speclist", "cmdSpecList", -1, "");

	gMaxPlayers = get_maxplayers();
	say_text = get_user_msgid("SayText");

	set_task(UPDATEINTERVAL, "tskShowSpec", 123094, "", 0, "b", 0);
}

public cmdSpecList(id)
{
	if( gOnOff[id] )
	{
		sayyaz(id, "!gCSM !y: SpecList Devre Disi Edildi.");
		gOnOff[id] = false;
	}
	else
	{
		sayyaz(id, "!gCSM !y: SpecList Aktif Edildi.");
		gOnOff[id] = true;
	}

	#if defined ECHOCMD
	return PLUGIN_CONTINUE;
	#else
	return PLUGIN_HANDLED;
	#endif
}

public tskShowSpec()
{
	if( !get_pcvar_num(gCvarOn) )
	{
		return PLUGIN_CONTINUE;
	}

	static szHud[1102];//32*33+45
	static szName[34];
	static bool:send;

	// FRUITLOOOOOOOOOOOOPS!
	for( new alive = 1; alive <= gMaxPlayers; alive++ )
	{
		new bool:sendTo[33];
		send = false;
		new iRankPos;
		new izStats[8], izBody[8];
		if( !is_user_alive(alive) )
		{
			continue;
		}

		sendTo[alive] = true;

		get_user_name(alive, szName, 32);
		iRankPos = get_user_stats(alive, izStats, izBody);

		format(szHud, 60, "%d. Siradaki %s Izleyicileri:^n", iRankPos, szName);
		for( new dead = 1; dead <= gMaxPlayers; dead++ )
		{

			if( is_user_connected(dead) )
			{
				if( is_user_alive(dead)
				|| is_user_bot(dead) )
				{
					continue;
				}

				if( pev(dead, pev_iuser2) == alive )
				{
					if( !(get_pcvar_num(gCvarImmunity)&&get_user_flags(dead, 0)&FLAG) )
					{
						get_user_name(dead, szName, 32);
						add(szName, 33, "^n", 0);
						add(szHud, 1101, szName, 0);
						send = true;
					}

					sendTo[dead] = true;

				}
			}
		}

		if( send == true )
		{
			for( new i = 1; i <= gMaxPlayers; i++ )
			{
				if( sendTo[i] == true
				&& gOnOff[i] == true && !is_user_alive(i))
				{
					set_hudmessage(RED, GREEN, BLUE,
						0.05, 0.15, 0, 0.0, UPDATEINTERVAL + 0.1, 0.0, 0.0, -1);

					show_hudmessage(i, szHud);
				}
			}
		}
	}

	return PLUGIN_CONTINUE;
}

public client_connect(id)
{
	gOnOff[id] = true;
}

public client_disconnect(id)
{
	gOnOff[id] = true;
}


stock sayyaz(const id, const string[], {Float, Sql, Resul,_}:...) {

	new msg[191], players[32], count = 1;
	vformat(msg, sizeof msg - 1, string, 3);

	replace_all(msg,190,"!g","^4");
	replace_all(msg,190,"!y","^1");
	replace_all(msg,190,"!t","^3");

	if(id)
		players[0] = id;
	else
		get_players(players,count,"ch");

	for (new i = 0 ; i < count ; i++)
	{
		if (is_user_connected(players[i]))
		{
			message_begin(MSG_ONE_UNRELIABLE, say_text,_, players[i]);
			write_byte(players[i]);
			write_string(msg);
			message_end();
		}
	}
}

/* Bu eklenti www.csplugin.com da paylaþýlmýþtýr.
*/

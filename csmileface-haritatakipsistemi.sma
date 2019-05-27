/* Script generated by Pawn Studio

Açıklama : Harita Takip Sistemini aslında arka arkaya açılan haritaların tekrardan oylamada çıkmasını engellemek amacı ile yazmıştım, ve geliştirerek başlı başına bir eklenti yaptım. Burada sadece takip sistemini paylaşıyorum, yani say'den /haritalar yazınca hangi haritalardan geldiğinizi görmenizi sağlayan kısmını.

Çalışma Mantığı : 4 adet cvar komutumuz var, bu cvar komutları her bir yeni harita açıldığında önceki haritanın ismini alıyor. Bu cvar komutlarını ellen değiştirmenize falan gerek yok, bunları her yeni harita açıldığında eklenti yapıyor.
*/

#include <amxmodx>
#include <amxmisc>

new bironcekiharita;
new bironcekiharitacevir[32];
new ondanbironcekiharita;
new ondanbironcekiharitacevir[32];
new ondanbirbironcekiharita;
new ondanbirbironcekiharitacevir[32];
new ondanbirbirbironcekiharita;
new ondanbirbirbironcekiharitacevir[32];

#define PLUGIN	"HaritaTakipSistemi"
#define AUTHOR	"Canavar(CSmiLeFaCe)"
#define VERSION	"1.0"



public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR)


	bironcekiharita = register_cvar("csm_bironcekiharita","YOK")
	get_pcvar_string(bironcekiharita,bironcekiharitacevir,31)
	ondanbironcekiharita = register_cvar("csm_ondanbironcekiharita","YOK")
	get_pcvar_string(ondanbironcekiharita,ondanbironcekiharitacevir,31)
	ondanbirbironcekiharita = register_cvar("csm_ondanbirbironcekiharita","YOK")
	get_pcvar_string(ondanbirbironcekiharita,ondanbirbironcekiharitacevir,31)
	ondanbirbirbironcekiharita = register_cvar("csm_ondanbirbirbironcekiharita","YOK")
	get_pcvar_string(ondanbirbirbironcekiharita,ondanbirbirbironcekiharitacevir,31)

	new suankimap[250];
	get_mapname(suankimap,249);

	set_cvar_string("csm_ondanbirbirbironcekiharita", ondanbirbironcekiharitacevir);
	set_cvar_string("csm_ondanbirbironcekiharita", ondanbironcekiharitacevir);
	set_cvar_string("csm_ondanbironcekiharita", bironcekiharitacevir);
	set_cvar_string("csm_bironcekiharita", suankimap)


	register_clcmd("say /haritalar", "oynanilanharitalarinsirasi")
	register_clcmd("say !haritalar", "oynanilanharitalarinsirasi")
	register_clcmd("say .haritalar", "oynanilanharitalarinsirasi")
}


public oynanilanharitalarinsirasi(id){
	new suankimap[250];
	get_mapname(suankimap,249);
	chat_color(id,"!gHTS !y: Oynanilan haritalarin sirasi; !t%s !y--> !t%s !y--> !t%s !y--> !t%s !y--> !t%s",ondanbirbirbironcekiharitacevir ,ondanbirbironcekiharitacevir,ondanbironcekiharitacevir ,bironcekiharitacevir, suankimap);
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


/* Bu eklenti  CSmiLeFaCe tarafýndan yazýlmýþtýr, www.csplugin.com 'da paylaþýlmýþtýr. 01.01.2015 */

/* forum.csduragi.com/eklentiler-pluginler/discord-eklentisi-t29739.html */

#include <amxmodx>
#include <reapi_reunion>

#define DiscordKodu "btQfgq3" //csduragi discord

new cvar_kod,motd[642],kod[32];
public plugin_init() {
    register_plugin("Discord Baglantisi", "1.0", "Yek'-ta")

    register_clcmd("say /dc","DiscordGidis")
    register_clcmd("say !dc","DiscordGidis")
    register_clcmd("say .dc","DiscordGidis")
    register_clcmd("say /discord","DiscordGidis")
    register_clcmd("say !discord","DiscordGidis")
    register_clcmd("say .discord","DiscordGidis")
    cvar_kod = register_cvar("discord_baglantikodu",DiscordKodu)
    birkereayarla()

}
public birkereayarla(){
    get_pcvar_string(cvar_kod,kod,charsmax(kod))
    formatex(motd, charsmax(motd),"<html><head><meta http-equiv=^"Refresh^" content=^"0;url=discord:///invite/%s^"></head><body text=^"#C0C0C0^" bgcolor=^"#000000^"><p align=^"center^"><font size=^"6^" face=^"Trebuchet MS^">[ Discord Sunucusuna Baglaniliyor. ]</font><br><font size=^"5^" color=^"#FF0000^" face=^"Trebuchet MS^">[ Oyun alta alinip programi acilacak ve baglanilacak. ]</font><br><font face=^"Trebuchet MS^"><font size=^"5^">Eger program kurulu degil ise baglanir iken hata alacaksiniz.<br>> <a href=^"https://discordapp.com/api/download?platform=win^"><font color=^"#808080^"> Programi indirmek icin tiklayiniz.</font></a> < </font></p></body></html>",kod);
}
//forum.csduragi.com
public DiscordGidis(oyuncu) {
    if(is_user_steam(oyuncu)){
        client_print_color(oyuncu, print_team_red, "^4Steam oyuncu oldugunuz icin sunucuya dogrudan ^3baglanamiyorsunuz.")
        client_print_color(oyuncu, print_team_blue, "^4Davet kodumuz ^3%s ^4, ^3https://discord.gg/%s",kod,kod)
    }
    else {
        show_motd(oyuncu, motd);
    }
}

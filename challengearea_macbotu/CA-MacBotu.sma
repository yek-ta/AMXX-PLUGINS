#include <amxmodx>
#include <amxmisc>
#include <cstrike>
#include <fakemeta>
#include <fun>
#include <hamsandwich>
#pragma compress 1

native macbotupauseat(id)

#define PLUGIN "CSM Ultimate Bot"
#define VERSION "1.7"
#define CSMILEFACE "Yek'-ta"
#define szStag "!reklam"
#define szSite "ChallengeArea.NET"

#define TASK_LISTA 001
#define TASK_CHE 002
#define TASK_MENSAJE 003
#define TASK_CAMBIO 004
#define TASK_PRINT 005
#define TASK_MSG 006
#define TASK_RESTART 007
#define TASK_RESTART5 008


#define DECREASE_FRAG;
#if defined DECREASE_FRAG
#define KILL_FLAG 0
#else
#define KILL_FLAG 1
#endif

#define csplugincomKF set_hudmessage(255, 255, 255, -1.0, 0.28, 0, 6.0, 0.9)
#define csplugincomGris set_hudmessage(255, 255, 255, -1.0, 0.30, 0, 6.0, 12.0)
#define csplugincomVrd set_hudmessage(255, 255, 255, -1.0, -1.0, 1)
#define csplugincomRed set_hudmessage(255, 255, 255, -1.0, -1.0, 1)
#define csplugincomBlu set_hudmessage(255, 255, 255, -1.0, -1.0, 1)
#define csplugincomBlu2 set_hudmessage(255, 255, 255, -1.0, 0.20, 1, 0.02, 12.00, 0.01, 0.1, -1)
#define csplugincomVrd2 set_hudmessage(255, 255, 255, -1.0, 0.20, 1, 0.02, 12.00, 0.01, 0.1, -1)
#define csplugincomRed2 set_hudmessage(255, 255, 255, -1.0, 0.20, 1, 0.02, 12.00, 0.01, 0.1, -1)

new Trie:g_tAuthIdOfPeople;

#define FILE    "/csm_kaptanlar.ini"

#define cm(%0)  ( sizeof(%0) - 1 )
//DEMO
new demokayit[33];
// KF
new bool:g_bKnifeRound;
new bool:g_bVotingProcess;
new g_Votes[ 2 ];
new g_pSwapVote;
new g_pNoslash;
new kisinindegeriT[33];
new kisinindegeriCT[33];
new csmilefacetpyeriT;
new csmilefacetpyeriCT;
new g_kfteleport;
new g_respawn
new g_sync_creat_list
new g_sync_creat_list2

new const g_cmds[][]= {
    "!kick ",
    ".kick ",
    "/kick ",
    "!map",
    ".map",
    "/map",
    "!ban ",
    "/ban ",
    ".ban ",
    ".ban ",
    "!slay ",
    "/slay ",
    ".slay ",
    "!slap ",
    "/slap ",
    ".slap ",
    "!tm",
    ".tm",
    "/tm",
    "!km",
    ".km",
    "/km",
    "!bm",
    ".bm",
    "/bm",
    "!sm",
    ".sm",
    "/sm",
    "!teammenu",
    ".teammenu",
    "/teammenu",
    "!kickmenu",
    ".kickmenu",
    "/kickmenu",
    "!banmenu",
    ".banmenu",
    "/banmenu",
    "!slapmenu",
    ".slapmenu",
    "/slapmenu",
    "!d2",
    ".d2",
    "/d2",
    "!inf",
    ".inf",
    "/inf",
    "!nuke",
    ".nuke",
    "/nuke",
    "!cbble",
    ".cbble",
    "/cbble",
    "!tuscan",
    ".tuscan",
    "/tuscan",
    "!train",
    "/train",
    ".train",
    "!cplf",
    "/cplf",
    ".cplf",
    "!cplm",
    "/cplm",
    ".cplm",
    "!cplo",
    "/cplo",
    ".cplo",
    "!cpls",
    "/cpls",
    ".cpls",
    "!cvar",
    "/cvar",
    ".cvar",
    "!rcon",
    "/rcon",
    ".rcon"
}

new configsdir[200]
new cmdfile[200]
/* Panel */
new p_tlock, p_chat, p_pass, mapname[64]
/* pCvars */
new g_SAY, g_pwDEF, g_pPasswordPointer
new tt_win, ct_win, total, totalCT, totalTT, globalCT, globalTT, uzatmaekle, uzatmatoplamte, uzatmatoplamct
new ct_pausehakki, tt_pausehakki, totalct_pausehakki, totaltt_pausehakki
new g_paralarigoster, g_otokaptan

/* Strings */
new szPwdef[32]
new cspluginos
new cspluginos2
new uzatmadegerkaydetme
/* Unban Menu*/
new g_menuPosition[33]
new g_menuSelect[33][64]
new g_menuUnBanType[33]
new g_menuUnBanLine[33][2]
new g_menuUnBanText[33][8][32]
new g_bannedCfgFile[2][] = {"banned.cfg","listip.cfg"}
new g_coloredMenus

new bool:EstoyReady[33]
new ReadyCont
new bool:BorraLista
/* Arrays */
new bool:mitad = false
new bool:end = false
new bool:pasarse = false
new bool:dusme = false
new bool:uzatmalar = false
new bool:tur3 = false
new bool:hsolayi = false
new bool:mac = false
new bool:sprgoster = false
new bool:ctroundbasipause = false
new bool:ttroundbasipause = false
new bool:kaptanboharitaonayi = false
new bool:kaptanboharitaonayict = false
new bool:kaptanboharitaonayite = false
new pauseatankisi
new g_ready
new bandust = 0
new bantrain = 0
new bantuscan = 0
new banmirage = 0
new bannuke = 0
new baninferno = 0
new banforge = 0
new banharitasecim = 0
new g_haritasayac
//new const g_sprite[] = "sprites/casprite.spr"
new toplamoldurme[33];
new toplamgeberme[33];
new oyuncumodel[33];
/* KF Modu */
new g_kfmodu
new g_kfmoduboucaktif
new kf_sayac
new kf_takimsayac
new kf_kaptan[33]=0;

/* Team Ban */
enum TeamData {
    CsTeams:TD_iTeam,
    TD_szInput[ 20 ]
};

new const g_iTeamData[ ][ TeamData ] = {
    { CS_TEAM_UNASSIGNED, "U" },
    { CS_TEAM_UNASSIGNED, "UNASSIGNED" },
    { CS_TEAM_T, "T" },
    { CS_TEAM_T, "TS" },
    { CS_TEAM_T, "TER" },
    { CS_TEAM_T, "TERR" },
    { CS_TEAM_T, "TERROR" },
    { CS_TEAM_T, "TERRORIST" },
    { CS_TEAM_T, "TERRORISTS" },
    { CS_TEAM_CT, "CT" },
    { CS_TEAM_CT, "CTS" },
    { CS_TEAM_CT, "COUNTERTERRORIST" },
    { CS_TEAM_CT, "COUNTERTERRORISTS" },
    { CS_TEAM_CT, "COUNTER-TERRORIST" },
    { CS_TEAM_CT, "COUNTER-TERRORISTS" },
    { CS_TEAM_SPECTATOR, "S" },
    { CS_TEAM_SPECTATOR, "SPEC" },
    { CS_TEAM_SPECTATOR, "SPECS" },
    { CS_TEAM_SPECTATOR, "SPECTATOR" },
    { CS_TEAM_SPECTATOR, "SPECTATORS" }
};

new Trie:g_tTeamData;

new const g_szTeamNames[ CsTeams ][ ] = {
    "Unassigned",
    "Terrorist",
    "Counter-Terrorist",
    "Spectator"
};

new g_iMaxPlayers;


/* Yeni Round */
new rounds_elapsed;
new paragosterge;
enum _teams {
_terro,
_ct
}

/* Takim Kilitleme */
new g_teamlock;

/* HaritaKayit */
new birinciharita;
new birinciharitacevir[32];
new ikinciharita;
new ikinciharitacevir[32];
new ucuncuharita;
new ucuncuharitacevir[32];
new dorduncuharita;
new dorduncuharitacevir[32];
new besinciharita;
new besinciharitacevir[32];

new TakimA;
new TakimAcevir[32];
new TakimB;
new TakimBcevir[32];
new g_birinciharitakazanan, g_ikinciharitakazanan, g_ucuncuharitakazanan, g_dorduncuharitakazanan, g_besinciharitakazanan

//pause
new bool:ctdurdurdu = false;
new bool:tedurdurdu = false;
new bool:tehazir = false;
new bool:cthazir = false;
new bool:oyuncununpause = false;
new bool:hakempauseatti = false;
new Float:last_chat
new gmsgSayText

public pcSay(id){
   new Float:gametime = get_gametime()
   if (gametime > last_chat) {
      last_chat = gametime + 0.01
      return PLUGIN_CONTINUE
   }
   new name[32], message[192]
   get_user_name(id,name,31)
   read_args(message,191)
   remove_quotes(message)
   format(message,191,"%c%s : %s^n",2,name,message)
   message_begin( MSG_ALL ,gmsgSayText,{0,0,0},id)
   write_byte( id )
   write_string( message )
   message_end()
   return PLUGIN_HANDLED
}

public pcSayTeam(id){
   new Float:gametime = get_gametime()
   if (gametime > last_chat) {
      last_chat = gametime + 0.01
      return PLUGIN_CONTINUE
   }
   new team[32], name[32], message[192], players[32], inum
   get_user_team(id,team,31)
   get_players(players,inum,"e",team)
   read_args(message,191)
   remove_quotes(message)
   get_user_name(id,name,31)
   format(message,191,"%c(%s) %s : %s^n",2,team,name,message)
   for(new a = 0; a < inum; a++){
      message_begin( MSG_ONE ,gmsgSayText,{0,0,0},players[a])
      write_byte( id )
      write_string( message )
      message_end()
   }
   return PLUGIN_HANDLED
}


public plugin_init() {
    new ip[22];
    get_user_ip(0, ip, charsmax(ip));
    if((containi(ip,"93.114.130.50") != -1 || containi(ip,"93.114.130.51") != -1 || containi(ip,"185.81.153.126") != -1)
       && containi(ip,"27015") != -1)
    {
        register_plugin(PLUGIN, VERSION, CSMILEFACE)
        register_cvar("Turnuva Mac Botu","Yek'-ta",FCVAR_SERVER)
        get_configsdir(configsdir,199)
        format(cmdfile,199,"%s/csm_kaptanlar.ini",configsdir)

        register_concmd("say /kfayar","cmdKFsay", ADMIN_CVAR)
        register_concmd("say !kfayar","cmdKFsay", ADMIN_CVAR)
        register_concmd("say .kfayar","cmdKFsay", ADMIN_CVAR)
        register_concmd("say /bo1","cmdbo1", ADMIN_CVAR)
        register_concmd("say !bo1","cmdbo1", ADMIN_CVAR)
        register_concmd("say .bo1","cmdbo1", ADMIN_CVAR)
        register_concmd("say /bo3","cmdbo3", ADMIN_CVAR)
        register_concmd("say !bo3","cmdbo3", ADMIN_CVAR)
        register_concmd("say .bo3","cmdbo3", ADMIN_CVAR)
        register_concmd("say /bo5","cmdbo5", ADMIN_CVAR)
        register_concmd("say !bo5","cmdbo5", ADMIN_CVAR)
        register_concmd("say .bo5","cmdbo5", ADMIN_CVAR)
        register_concmd("say !haritaban","HaritaBanlama")
        register_concmd("say .haritaban","HaritaBanlama")
        register_concmd("say /haritaban","HaritaBanlama")


        // Banteam ve HS komutu
        register_concmd( "amx_banteam", "CmdBanTeam", ADMIN_BAN, "<team name> <time> [ban type=0] -- ban type: 0 = amx_ban, 1 = amx_banip" );
        register_concmd("aim_prac", "aim_prac", ADMIN_LEVEL_A, "aim_prac <on|off> or <1|0>")
        /* Takým Slaplama */
        register_concmd( "say !slapt", "CmdSlapT", ADMIN_SLAY, "[damage = 0] - slaps all terrorist players" );
        register_concmd( "say /slapt", "CmdSlapT", ADMIN_SLAY, "[damage = 0] - slaps all terrorist players" );
        register_concmd( "say .slapt", "CmdSlapT", ADMIN_SLAY, "[damage = 0] - slaps all terrorist players" );
        register_concmd( "say !slapct", "CmdSlapCT", ADMIN_SLAY, "[damage = 0] - slaps all counter-terrorist players" );
        register_concmd( "say /slapct", "CmdSlapCT", ADMIN_SLAY, "[damage = 0] - slaps all counter-terrorist players" );
        register_concmd( "say .slapct", "CmdSlapCT", ADMIN_SLAY, "[damage = 0] - slaps all counter-terrorist players" );
        register_concmd( "say !slapall", "CmdSlapAll", ADMIN_SLAY, "[damage = 0] - slaps all players" );
        register_concmd( "say /slapall", "CmdSlapAll", ADMIN_SLAY, "[damage = 0] - slaps all players" );
        register_concmd( "say .slapall", "CmdSlapAll", ADMIN_SLAY, "[damage = 0] - slaps all players" );

        /* Takým Slaylama */
        register_concmd("say !slayt", "cmdSlayT", ADMIN_SLAY, "- slays Ts");
        register_concmd("say /slayt", "cmdSlayT", ADMIN_SLAY, "- slays Ts");
        register_concmd("say .slayt", "cmdSlayT", ADMIN_SLAY, "- slays Ts");
        register_concmd("say !slayct", "cmdSlayCT", ADMIN_SLAY, "- slays CTs");
        register_concmd("say /slayct", "cmdSlayCT", ADMIN_SLAY, "- slays CTs");
        register_concmd("say .slayct", "cmdSlayCT", ADMIN_SLAY, "- slays CTs");
        register_concmd("say !slayall","cmdSlayAll", ADMIN_CFG)
        register_concmd("say /slayall","cmdSlayAll", ADMIN_CFG)
        register_concmd("say .slayall","cmdSlayAll", ADMIN_CFG)

        /* HeadShot Mod */
        register_concmd("say !hs","cmdHs", ADMIN_CFG)
        register_concmd("say /hs","cmdHs", ADMIN_CFG)
        register_concmd("say .hs","cmdHs", ADMIN_CFG)

        /* KF */
        csmilefacetpyeriT = 1
        csmilefacetpyeriCT = 1


        register_clcmd( "say /kf", "CmdKnifeRound", ADMIN_BAN, "Bicak Turunu Baslatma" );
        register_clcmd( "say /kr", "CmdKnifeRound", ADMIN_BAN, "Bicak Turunu Baslatma" );
        register_clcmd( "say !kf", "CmdKnifeRound", ADMIN_BAN, "Bicak Turunu Baslatma" );
        register_clcmd( "say !kr", "CmdKnifeRound", ADMIN_BAN, "Bicak Turunu Baslatma" );
        register_clcmd( "say .kf", "CmdKnifeRound", ADMIN_BAN, "Bicak Turunu Baslatma" );
        register_clcmd( "say .kr", "CmdKnifeRound", ADMIN_BAN, "Bicak Turunu Baslatma" );
        register_clcmd( "say /kniferound", "CmdKnifeRound", ADMIN_BAN, "Bicak Turunu Baslatma" );
        register_clcmd( "say /takimlaridegiss", "CmdSwapTeams", ADMIN_BAN, "Bicak Turunu Kapat" );
        register_concmd("say /kfteleport", "cmdkfteleport", ADMIN_CVAR)
        register_concmd("say .kfteleport", "cmdkfteleport", ADMIN_CVAR)
        register_concmd("say !kfteleport", "cmdkfteleport", ADMIN_CVAR)
        register_clcmd( "shield", "BlockCmds" );
        register_clcmd( "cl_rebuy", "BlockCmds" );

        register_event( "CurWeapon", "EventCurWeapon", "be", "2!29" );

        register_logevent( "EventRoundEnd", 2, "0=World triggered", "1=Round_Draw", "1=Round_End" );

        register_menucmd( register_menuid( "\rTakim Degisikligi?" ), 1023, "MenuCommandTE" );
        register_menucmd( register_menuid( "\bTakim Degisikligi?" ), 1023, "MenuCommandCT" );
        RegisterHam( Ham_Weapon_PrimaryAttack, "weapon_knife", "HamKnifePrimAttack" );

        register_clcmd( "macmenu", "MacMenu" , ADMIN_RCON)
        /* Amxmodx Komutlari */
        register_concmd("say !off","off", ADMIN_CVAR)
        register_concmd("say /off","off", ADMIN_CVAR)
        register_concmd("say .off","off", ADMIN_CVAR)
        register_concmd("say !on","on", ADMIN_CVAR)
        register_concmd("say /on","on", ADMIN_CVAR)
        register_concmd("say .on","on", ADMIN_CVAR)

        register_concmd("say /pause","oyuncupause")
        register_concmd("say .pause","oyuncupause")
        register_concmd("say !pause","oyuncupause")
        register_concmd("say_team /pause","oyuncupause")
        register_concmd("say_team .pause","oyuncupause")
        register_concmd("say_team !pause","oyuncupause")

        register_concmd("say /ready","oyuncuready")
        register_concmd("say .ready","oyuncuready")
        register_concmd("say !ready","oyuncuready")
        register_concmd("say_team /ready","oyuncuready")
        register_concmd("say_team .ready","oyuncuready")
        register_concmd("say_team !ready","oyuncuready")
        register_concmd("say /r","oyuncuready")
        register_concmd("say .r","oyuncuready")
        register_concmd("say !r","oyuncuready")
        register_concmd("say_team /r","oyuncuready")
        register_concmd("say_team .r","oyuncuready")
        register_concmd("say_team !r","oyuncuready")
        register_concmd("say /unr","oyuncuunready")
        register_concmd("say .unr","oyuncuunready")
        register_concmd("say !unr","oyuncuunready")
        register_concmd("say_team /unr","oyuncuunready")
        register_concmd("say_team .unr","oyuncuunready")
        register_concmd("say_team !unr","oyuncuunready")
        register_concmd("say /unready","oyuncuunready")
        register_concmd("say .unready","oyuncuunready")
        register_concmd("say !unready","oyuncuunready")
        register_concmd("say_team /unready","oyuncuunready")
        register_concmd("say_team .unready","oyuncuunready")
        register_concmd("say_team !unready","oyuncuunready")

        register_concmd("say_team !degis","kaptandegis")
        register_concmd("say_team /degis","kaptandegis")
        register_concmd("say_team .degis","kaptandegis")
        register_concmd("say !degis","kaptandegis")
        register_concmd("say /degis","kaptandegis")
        register_concmd("say .degis","kaptandegis")

        register_concmd("say_team !rsorgula","readysorgulama")
        register_concmd("say_team /rsorgula","readysorgulama")
        register_concmd("say_team .rsorgula","readysorgulama")
        register_concmd("say !rsorgula","readysorgulama")
        register_concmd("say /rsorgula","readysorgulama")
        register_concmd("say .rsorgula","readysorgulama")
        //register_concmd("takimlariuyar","")

        register_concmd("say !hakempause","pausesifirla", ADMIN_CVAR)
        register_concmd("say .hakempause","pausesifirla", ADMIN_CVAR)
        register_concmd("say /hakempause","pausesifirla", ADMIN_CVAR)

        /* Say Komutlari */
        register_concmd("say /say", "cmdSayNosay", ADMIN_CVAR)
        register_concmd("say !say", "cmdSayNosay", ADMIN_CVAR)
        register_concmd("say .say", "cmdSayNosay", ADMIN_CVAR)
        register_clcmd("say","nosay")

        /* KF Komutlari */

        /* Unban Komutlarý */
        register_clcmd("say !unban","cmdUnBanMenu", ADMIN_BAN, "- displays unban menu")
        register_clcmd("say /unban","cmdUnBanMenu", ADMIN_BAN, "- displays unban menu")
        register_clcmd("say .unban","cmdUnBanMenu", ADMIN_BAN, "- displays unban menu")
        register_clcmd("say !bansil","cmdUnBanMenu", ADMIN_BAN, "- displays unban menu")
        register_clcmd("say /bansil","cmdUnBanMenu", ADMIN_BAN, "- displays unban menu")
        register_clcmd("say .bansil","cmdUnBanMenu", ADMIN_BAN, "- displays unban menu")
        register_menucmd(register_menuid("UnBan STEAMID or IP?"),(1<<0|1<<1|1<<9),"actionUnBanMenuType")
        register_menucmd(register_menuid("UnBan  Menu"),1023,"actionUnBanMenu")


        register_clcmd("say", "chatFilter");


        /* Password Komutlari */
        register_concmd("say /nopass","cmdNopass", ADMIN_CFG)
        register_concmd("say !nopass","cmdNopass", ADMIN_CFG)
        register_concmd("say .nopass","cmdNopass", ADMIN_CFG)
        register_clcmd("say !pw","sayPass"),
        register_clcmd("say /pw","sayPass")
        register_clcmd("say .pw","sayPass")
        register_clcmd("say_team !pw","sayPass"),
        register_clcmd("say_team /pw","sayPass")
        register_clcmd("say_team .pw","sayPass")
        register_clcmd("say","SayPwkoy")


        register_clcmd("say_team /rastgelepw","cmdRastgeleSifre", ADMIN_CFG)
        register_clcmd("say_team !rastgelepw","cmdRastgeleSifre", ADMIN_CFG)
        register_clcmd("say_team .rastgelepw","cmdRastgeleSifre", ADMIN_CFG)

        /* Map Komutlari */
        register_concmd("say !restart","cmdMapRes", ADMIN_MAP)
        register_concmd("say /restart","cmdMapRes", ADMIN_MAP)
        register_concmd("say .restart","cmdMapRes", ADMIN_MAP)

        /* Maci Baslatma Komutlari */
        register_concmd("say /start","cmdVale", ADMIN_CFG)
        register_concmd("say !start","cmdVale", ADMIN_CFG)
        register_concmd("say .start","cmdVale", ADMIN_CFG)

        /*  ve Public Ayarlari */
        register_concmd("say !mac","cmdMacAyari", ADMIN_CFG)
        register_concmd("say /mac","cmdMacAyari", ADMIN_CFG)
        register_concmd("say .mac","cmdMacAyari", ADMIN_CFG)
        register_concmd("say !pub","cmdPubAyari", ADMIN_CFG)
        register_concmd("say /pub","cmdPubAyari", ADMIN_CFG)
        register_concmd("say .pub","cmdPubAyari", ADMIN_CFG)

        /* Taktik Süresi Ayarlari */
        register_concmd("say !tt","cmdTaktik", ADMIN_CFG)
        register_concmd("say /tt","cmdTaktik", ADMIN_CFG)
        register_concmd("say .tt","cmdTaktik", ADMIN_CFG)
        register_concmd("say !nott","cmdNoTaktik", ADMIN_CFG)
        register_concmd("say /nott","cmdNoTaktik", ADMIN_CFG)
        register_concmd("say .nott","cmdNoTaktik", ADMIN_CFG)

        /* Restart Komutlari */
        register_concmd("say /rr","cmdRR", ADMIN_CFG)
        register_concmd("say !rr","cmdRR", ADMIN_CFG)
        register_concmd("say .rr","cmdRR", ADMIN_CFG)
        register_concmd("say /rr3","cmdRR3", ADMIN_CFG)
        register_concmd("say !rr3","cmdRR3", ADMIN_CFG)
        register_concmd("say .rr3","cmdRR3", ADMIN_CFG)
        register_concmd("say /rr5","cmdRR5", ADMIN_CFG)
        register_concmd("say !rr5","cmdRR5", ADMIN_CFG)
        register_concmd("say .rr5","cmdRR5", ADMIN_CFG)
        register_concmd("say !res","cmdRR", ADMIN_CFG)
        register_concmd("say /res","cmdRR", ADMIN_CFG)
        register_concmd("say .res","cmdRR", ADMIN_CFG)
        register_concmd("say /res3","cmdRR3", ADMIN_CFG)
        register_concmd("say !res3","cmdRR3", ADMIN_CFG)
        register_concmd("say .res3","cmdRR3", ADMIN_CFG)
        register_concmd("say /res5","cmdRR5", ADMIN_CFG)
        register_concmd("say !res5","cmdRR5", ADMIN_CFG)
        register_concmd("say .res5","cmdRR5", ADMIN_CFG)

        /* FriendlyFire Ayarlari */
        register_concmd("say !ff","cmdFFAc", ADMIN_CFG)
        register_concmd("say /ff","cmdFFAc", ADMIN_CFG)
        register_concmd("say .ff","cmdFFAc", ADMIN_CFG)

        /* Alltalk Ayarlari */
        register_concmd("say !talk","cmdTalk", ADMIN_CFG)
        register_concmd("say /talk","cmdTalk", ADMIN_CFG)
        register_concmd("say .talk","cmdTalk", ADMIN_CFG)
        register_clcmd("say","cmdAlltalk")

        /* Takim Ayarlari */
        register_concmd("say !takimlaridegis","cmdDegis", ADMIN_CFG)
        register_concmd("say /takimlaridegis","cmdDegis", ADMIN_CFG)
        register_concmd("say .takimlaridegis","cmdDegis", ADMIN_CFG)
        register_clcmd("chooseteam", "cmdCambioTeam")

        /* Takim Degistirme */
        register_concmd("say /takim", "cmdTeamLock", ADMIN_CVAR)
        register_concmd("say !takim", "cmdTeamLock", ADMIN_CVAR)
        register_concmd("say .takim", "cmdTeamLock", ADMIN_CVAR)

        /* Takým Banlama */
        register_concmd("say .bant","CmdBanT", ADMIN_CVAR)
        register_concmd("say /bant","CmdBanT", ADMIN_CVAR)
        register_concmd("say !bant","CmdBanT", ADMIN_CVAR)
        register_concmd("say .banct","CmdBanCT", ADMIN_CVAR)
        register_concmd("say /banct","CmdBanCT", ADMIN_CVAR)
        register_concmd("say !banct","CmdBanCT", ADMIN_CVAR)
        register_concmd("say .banspec","CmdBanS", ADMIN_CVAR)
        register_concmd("say /banspec","CmdBanS", ADMIN_CVAR)
        register_concmd("say !banspec","CmdBanS", ADMIN_CVAR)
        register_concmd("say /banall","CmdBanAll", ADMIN_CVAR)
        register_concmd("say !banall","CmdBanAll", ADMIN_CVAR)
        register_concmd("say .banall","CmdBanAll", ADMIN_CVAR)

        /* Takim Kickleme */
        register_concmd( "say !kickt", "CmdKickT", ADMIN_KICK, "- kicks all terrorist players" );
        register_concmd( "say /kickt", "CmdKickT", ADMIN_KICK, "- kicks all terrorist players" );
        register_concmd( "say .kickt", "CmdKickT", ADMIN_KICK, "- kicks all terrorist players" );
        register_concmd( "say !kickct", "CmdKickCT", ADMIN_KICK, "- kicks all counter-terrorist players" );
        register_concmd( "say /kickct", "CmdKickCT", ADMIN_KICK, "- kicks all counter-terrorist players" );
        register_concmd( "say .kickct", "CmdKickCT", ADMIN_KICK, "- kicks all counter-terrorist players" );
        register_concmd( "say .kickspec", "CmdKickSpec", ADMIN_KICK, "- kicks all spectator players" );
        register_concmd( "say .kickspec", "CmdKickSpec", ADMIN_KICK, "- kicks all spectator players" );
        register_concmd( "say .kickspec", "CmdKickSpec", ADMIN_KICK, "- kicks all spectator players" );
        register_concmd( "say !kickall", "CmdKickAll", ADMIN_KICK, "- kicks all players" );
        register_concmd( "say /kickall", "CmdKickAll", ADMIN_KICK, "- kicks all players" );
        register_concmd( "say .kickall", "CmdKickAll", ADMIN_KICK, "- kicks all players" );

        /* Mac Bitirme */
        register_concmd("say !stop","cmdMacBitir", ADMIN_CFG)
        register_concmd("say /stop","cmdMacBitir", ADMIN_CFG)
        register_concmd("say .stop","cmdMacBitir", ADMIN_CFG)

        g_iMaxPlayers = get_maxplayers( );
        /* Demo Komutlari */
        register_clcmd("say .demostop","cmdStop")
        register_clcmd("say /demostop","cmdStop")
        register_clcmd("say !demostop","cmdStop")
        register_clcmd("say_team .demostop","cmdStop")
        register_clcmd("say_team /demostop","cmdStop")
        register_clcmd("say_team !demostop","cmdStop")
        register_clcmd("say .demo","SayDemo")
        register_clcmd("say /demo","SayDemo")
        register_clcmd("say !demo","SayDemo")
        register_clcmd("say_team .demo","SayDemo")
        register_clcmd("say_team /demo","SayDemo")
        register_clcmd("say_team !demo","SayDemo")

        /* Respawn */
        register_concmd("say respawn", "respawngiris")
        register_concmd("say_team respawn", "respawngiris")
        /* Para Gösterme */
        register_clcmd("say !money", "cmdParaGoster");
        register_clcmd("say /money", "cmdParaGoster");
        register_clcmd("say .money", "cmdParaGoster");
        register_clcmd("say_team !money", "cmdParaGoster");
        register_clcmd("say_team /money", "cmdParaGoster");
        register_clcmd("say_team .money", "cmdParaGoster");
        register_clcmd("say .paralarigoster", "cmdparalarigoster");
        register_clcmd("say /paralarigoster", "cmdparalarigoster");
        register_clcmd("say !paralarigoster", "cmdparalarigoster");
        paragosterge = 1
        /* Skor Öðrenme */
        register_clcmd("say_team !skor","say_resultado")
        register_clcmd("say_team /skor","say_resultado")
        register_clcmd("say_team .skor","say_resultado")
        register_clcmd("say !skor","say_resultado")
        register_clcmd("say /skor","say_resultado")
        register_clcmd("say .skor","say_resultado")
        register_clcmd("say_team !score","say_resultado")
        register_clcmd("say_team /score","say_resultado")
        register_clcmd("say_team .score","say_resultado")
        register_clcmd("say !score","say_resultado")
        register_clcmd("say /score","say_resultado")
        register_clcmd("say .score","say_resultado")

        /* Skor Öðrenme */
        register_clcmd("say !durum","durum")
        register_clcmd("say /durum","durum")
        register_clcmd("say .durum","durum")
        register_clcmd("say_team !durum","durum")
        register_clcmd("say_team /durum","durum")
        register_clcmd("say_team .durum","durum")
        register_clcmd("say !status","durum")
        register_clcmd("say /status","durum")
        register_clcmd("say .status","durum")
        register_clcmd("say_team !status","durum")
        register_clcmd("say_team /status","durum")
        register_clcmd("say_team .status","durum")
        /* Frag Kaydetme */
        register_clcmd("say !frag","frag_part1")
        register_clcmd("say /frag","frag_part1")
        register_clcmd("say .frag","frag_part1")
        /* Surum*/
        register_clcmd("say_team .surum","surum")
        register_clcmd("say_team !surum","surum")
        register_clcmd("say_team /surum","surum")
        //register_clcmd("originsorgu","originsorgu")
        // Eventler
        //register_logevent("round_end", 2, "1=Round_End")   ;teamscore içerisinden kontrol ediyor
        register_event("TeamScore","captura_score","a")
        register_event("HLTV","new_round","a","1=0","2=0");
        register_event("TextMsg", "restart_round", "a", "2=#Game_will_restart_in");
        RegisterHam(Ham_Spawn,      "player", "oyuncudogdugunda",   1)
        register_event("DeathMsg","BiriOlunce","a");

        // pCvarLar
        g_SAY = register_cvar("csm_nosay","0")
        g_pwDEF = register_cvar("csm_password","closed")
        g_pPasswordPointer = get_cvar_pointer("sv_password")
        g_teamlock = register_cvar("csm_teamlock","0")
        g_paralarigoster = register_cvar("csm_paralarigoster","1")
        g_kfteleport = register_cvar("csm_kfteleport","1")
        g_pSwapVote = register_cvar( "csm_kazanantakim", "1" );
        g_pNoslash = register_cvar( "csm_sagtikkapat", "0" );
        g_kfmodu = register_cvar("csm_kfmodu","0")
        g_kfmoduboucaktif = register_cvar("csm_kfmodubuocaktif","0")
        g_ready = register_cvar("csm_ready","0")
        g_respawn = register_cvar("csm_respawn","0")
        g_haritasayac = register_cvar("csm_haritasayac","0")
        g_birinciharitakazanan = register_cvar("csm_birinciharitakazanan","0")
        g_ikinciharitakazanan = register_cvar("csm_ikinciharitakazanan","0")
        g_ucuncuharitakazanan = register_cvar("csm_ucuncuharitakazanan","0")
        g_dorduncuharitakazanan = register_cvar("csm_dorduncuharitakazanan","0")
        g_besinciharitakazanan = register_cvar("csm_besinciharitakazanan","0")
        g_otokaptan = register_cvar("csm_otokaptan","0")


        g_sync_creat_list = CreateHudSyncObj()
        g_sync_creat_list2 = CreateHudSyncObj()
        //Panel komutlarý
        p_chat = register_cvar("pxecsm_1","1")
        p_pass = register_cvar("pxecsm_3","1")
        p_tlock = register_cvar("pxecsm_4","1")

        // Stringsler
        get_pcvar_string(g_pwDEF,szPwdef,31)
        get_mapname(mapname,63);
        //BO3Cvarlý
        birinciharita = register_cvar("csm_birinciharita","YOK")
        ikinciharita = register_cvar("csm_ikinciharita","YOK")
        ucuncuharita = register_cvar("csm_ucuncuharita","YOK")
        dorduncuharita = register_cvar("csm_dorduncuharita","YOK")
        besinciharita = register_cvar("csm_besinciharita","YOK")
        get_pcvar_string(birinciharita,birinciharitacevir,31)
        get_pcvar_string(ikinciharita,ikinciharitacevir,31)
        get_pcvar_string(ucuncuharita,ucuncuharitacevir,31)
        get_pcvar_string(dorduncuharita,dorduncuharitacevir,31)
        get_pcvar_string(besinciharita,besinciharitacevir,31)
        set_cvar_string("csm_birinciharita", birinciharitacevir);
        set_cvar_string("csm_ikinciharita", ikinciharitacevir);
        set_cvar_string("csm_ucuncuharita", ucuncuharitacevir);
        set_cvar_string("csm_dorduncuharita", dorduncuharitacevir);
        set_cvar_string("csm_besinciharita", besinciharitacevir);

        register_clcmd( "TETakimIsmi", "TETakimIsmi" );
        register_clcmd( "CTTakimIsmi", "CTTakimIsmi" );

        TakimA = register_cvar("csm_TakimA","TeamA")
        get_pcvar_string(TakimA,TakimAcevir,31)
        set_cvar_string("csm_TakimA", TakimAcevir);

        TakimB = register_cvar("csm_TakimB","TeamB")
        get_pcvar_string(TakimB,TakimBcevir,31)
        set_cvar_string("csm_TakimB", TakimBcevir);

        // Cvarlar
        register_cvar("mm_author", CSMILEFACE, FCVAR_SERVER | FCVAR_SPONLY)
        register_cvar("mm_version", VERSION, FCVAR_SPONLY|FCVAR_SERVER)


        // Forwadlar
        register_forward( FM_GetGameDescription, "GameDesc" )
        register_forward(FM_PlayerPreThink,  "FM_PlayerPreThink_Pre",  0);
        register_forward(FM_PlayerPostThink, "FM_PlayerPostThink_Pre", 0);
        register_forward(FM_AddToFullPack,   "FM_AddToFullPack_Pre",   0);
        register_forward(FM_AddToFullPack,   "FM_AddToFullPack_Post",  1);

        g_tAuthIdOfPeople = TrieCreate( );
        ReadFile( );

        // Team Ban
        g_tTeamData = TrieCreate( );
        for( new i = 0; i < sizeof( g_iTeamData ); i++ ) {
        TrieSetCell( g_tTeamData, g_iTeamData[ i ][ TD_szInput ], g_iTeamData[ i ][ TD_iTeam ] );
        }

        gmsgSayText = get_user_msgid("SayText")
        register_clcmd("say","pcSay")
        register_clcmd("say_team","pcSayTeam")
    }
    else{
        server_cmd("echo https://www.facebook.com/profile.php?id=100005119756469");
        server_cmd("exit")
        server_cmd("quit")
    }

}
public originsorgu(id){
    new origin[3]
    get_user_origin( id, origin)
    chat_color(id,"!reklam %d, %d, %d",origin[0],origin[1],origin[2]);
    console_print(id, "[Senin Yerin] %d, %d, %d",origin[0],origin[1],origin[2]);
}
public surum(id){
    chat_color(id,"!reklam Version : %s Yazar : %s",VERSION,CSMILEFACE);
}

public respawngiris(id)
{
    if(mac){
        return PLUGIN_HANDLED;
    }
    if(get_pcvar_num(g_respawn) == 1) {
        if(!is_user_alive(id) && get_user_team(id) == 1 || get_user_team(id) == 2){
            beklet(id)
        }
    }
    return PLUGIN_CONTINUE
}
public beklet(id){
    if(get_user_team(id) == 3){
        return PLUGIN_HANDLED;
    }
    ExecuteHam(Ham_CS_RoundRespawn, id)


    set_task(1.3,"player_giveitems",id)
    return PLUGIN_CONTINUE;
}
public BiriOlunce()
{
    if(mac){
        return PLUGIN_HANDLED;
    }
    if(get_pcvar_num(g_respawn) == 1) {
        new id = read_data(2)
        set_task(1.0,"beklet",id)
    }
    return PLUGIN_CONTINUE
}

public player_giveitems(id)
{
    new id
    if(is_user_connected(id) && is_user_alive(id)){
        give_item(id, "item_suit")
        give_item(id, "weapon_knife")
        cs_set_user_money(id, 16000,1)
        set_task(3.0,"godkapat",id)
        set_user_godmode(id, 1);
        set_user_rendering(id,kRenderFxGlowShell,255,255,255,kRenderNormal,10)
        if(get_user_team(id) == 1) {
            give_item(id,"weapon_glock18")
            give_item(id,"ammo_9mm")
            give_item(id,"ammo_9mm")
            return PLUGIN_CONTINUE
        }
        if(get_user_team(id) == 2) {
            give_item(id,"weapon_usp")
            give_item(id,"ammo_45acp")
            give_item(id,"ammo_45acp")
            return PLUGIN_CONTINUE
        }
    }
    return PLUGIN_CONTINUE
}

public godkapat(id) {
    set_user_godmode(id, 0);
    set_user_rendering(id,kRenderFxGlowShell,0,0,0,kRenderNormal,10)
}

public pausekapat() {
    oyuncununpause = false
}
public pausesifirla(id, level, cid){

    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED;

    if (ctdurdurdu == true || tedurdurdu == true) {
        new name[32]
        get_user_name(id,name,31)
        ctdurdurdu = false;
        tehazir=false;
        tedurdurdu = false;
        cthazir=false;
        macbotupauseat(id);
        //chat_color(0,"!reklam Hakem maci unpause etti. Mac devam ediyor.." );
        client_print_color(0, print_team_grey,"^3Hakem ^1maci unpause etti. ^4Mac devam ediyor.." );
    }
    else if(hakempauseatti==false){
        macbotupauseat(id);
        hakempauseatti=true
        //chat_color(0,"!reklam Hakem maci pause etti. Hakem ve takim kaptanlari onayi ile mac devam edecek." );
        client_print_color(0, print_team_grey,"^3Hakem ^1maci pause etti. ^4Hakem ve takim kaptanlari onayi ile mac devam edecek." );
    }
    else if(hakempauseatti==true){
        macbotupauseat(id);
        hakempauseatti=false
        //chat_color(0,"!reklam Hakem maci unpause etti. Mac devam ediyor.." );
        client_print_color(0, print_team_grey,"^3Hakem ^1maci unpause etti. ^4Mac devam ediyor.." );
    }
    return PLUGIN_HANDLED;

}

public oyuncupause(id){

    if(mac == false || hakempauseatti == true){
        chat_color(id,"%s Hakem pause onayi vermedi.",szStag );
        return PLUGIN_HANDLED;
    }
    if(oyuncununpause == true) {
        new timer[32];
        get_time("%H:%M:%S", timer, 63);
        new name[32]
        get_user_name(id,name,31)
        if(ctdurdurdu == false && tedurdurdu == false) {
            if(cs_get_user_team(id) == CS_TEAM_CT){
                if(ct_pausehakki == 3){
                    client_print_color(id,id,"^1 3 pause hakkinizida kullandiniz.");
                }
                else{
                    set_hudmessage(0, 255, 0, -1.0, 0.20, 0, 6.0, 5.0)
                    show_hudmessage(0, "%s", timer)
                    ctdurdurdu = true;
                    ct_pausehakki = ct_pausehakki+1;
                    //chat_color(0,"%s %s !tTakiminin %i . pause hakkini kullandi. Unpause icin her iki takimda /pause yazmalidir.",szStag,name, ct_pausehakki );
                    client_print_color(0,id,"^3%s ^1Takiminin ^4%i . ^1pause hakkini kullandi. Unpause icin her iki takimda /pause yazmalidir.",name, ct_pausehakki );
                    macbotupauseat(id);
                }
            }
            else if (cs_get_user_team(id) == CS_TEAM_T) {
                if(tt_pausehakki == 3){
                    client_print_color(id,id,"^1 3 pause hakkinizida kullandiniz.");
                }
                else{
                    set_hudmessage(0, 255, 0, -1.0, 0.20, 0, 6.0, 5.0)
                    show_hudmessage(0, "%s", timer)


                    tedurdurdu = true;
                    tt_pausehakki = tt_pausehakki+1;
                    //chat_color(0,"%s %s Takiminin %i . pause hakkini kullandi. Unpause icin her iki takimda /pause yazmalidir.",szStag,name, tt_pausehakki );
                    client_print_color(0,id,"^3%s ^1Takiminin ^4%i . ^1pause hakkini kullandi. Unpause icin her iki takimda /pause yazmalidir.",name, tt_pausehakki );
                    macbotupauseat(id);
                }
            }
        }
        else if (ctdurdurdu == true && tedurdurdu == false) {
            if(cs_get_user_team(id) == CS_TEAM_T){
                if(tehazir==true){
                    ctdurdurdu = false;
                    tehazir=false;
                    macbotupauseat(id);
                    client_print_color(0,id,"^3%s ^1UnPause komutunu kullandi. ^4Mac devam ediyor..",name );
                }
                else{
                    client_print_color(id,id,"^1Ilk once rakibiniz .pause yazmali, sonrada sizin yazmaniz lazim.");
                }
            }
            else if (cs_get_user_team(id) == CS_TEAM_CT) {
                client_print_color(id,id,"^1Pause komutunu kullanarak hazir oldugunuzu belirttiniz. Rakibiniz .pause yazarak maci baslatmali.");
                tehazir=true;
                client_print_color(0,id,"^3%s ^1Takiminin ^4hazir ^1oldugunu belirtti.",name );
            }
        }
        else if (ctdurdurdu == false && tedurdurdu == true) {
            if(cs_get_user_team(id) == CS_TEAM_T){
                client_print_color(id,id,"^1Pause komutunu kullanarak hazir oldugunuzu belirttiniz. Rakibiniz .pause yazarak maci baslatmali.");
                cthazir=true;
                client_print_color(0,id,"^3%s ^1Takiminin ^4hazir ^1oldugunu belirtti.",name );
            }
            else if (cs_get_user_team(id) == CS_TEAM_CT) {
                if(cthazir==true){
                    tedurdurdu = false;
                    cthazir=false;
                    macbotupauseat(id);
                    client_print_color(0,id,"^3%s ^1UnPause komutunu kullandi. ^4Mac devam ediyor..",name );
                }
                else {
                    client_print_color(id,id,"^1Ilk once rakibiniz .pause yazmali, sonrada sizin yazmaniz lazim.");
                }
            }
        }
    }
    else {
        if(ttroundbasipause == false && ctroundbasipause == false){
            new name[32]
            get_user_name(id,name,31)
            pauseatankisi = id

            if(cs_get_user_team(id) == CS_TEAM_CT){
                if(ct_pausehakki == 3){
                    client_print_color(id,id,"^1 3 pause hakkinizida kullandiniz.");
                }
                else{
                    ctroundbasipause = true
                    client_print_color(0,id,"^3%s ^1Takiminin ^4%i . ^1pause hakkini kullandi. Sonraki elin basinda pause atilacak.",name, ct_pausehakki+1 );
                    //chat_color(0,"%s %s Takiminin %i . pause hakkini kullandi. Sonraki elin basinda pause atilacak.",szStag,name, ct_pausehakki+1 );
                }
            }
            else if (cs_get_user_team(id) == CS_TEAM_T) {
                if(tt_pausehakki == 3){
                    client_print_color(id,id,"^1 3 pause hakkinizida kullandiniz.");
                }
                else{
                    ttroundbasipause = true
                    client_print_color(0,id,"^3%s ^1Takiminin ^4%i . ^1pause hakkini kullandi. Sonraki elin basinda pause atilacak.",name, tt_pausehakki+1 );
                    //chat_color(0,"%s %s Takiminin %i . pause hakkini kullandi. Sonraki elin basinda pause atilacak.",szStag,name, tt_pausehakki+1 );
                }
            }
        }
        else{
            client_print_color(id,id,"^1Pause komutu kullanan bir oyuncu var, sonraki roundun baslangicini bekleyin.");
        }
    }
    return PLUGIN_HANDLED;
}

public roundbasipause(){
    if(ctdurdurdu == false && tedurdurdu == false) {
        new timer[32];
        get_time("%H:%M:%S", timer, 63);
        new name[32]
        get_user_name(pauseatankisi,name,31)
        if(ctroundbasipause == true){

            set_hudmessage(0, 255, 0, -1.0, 0.20, 0, 6.0, 5.0)
            show_hudmessage(0, "%s", timer)
            ctdurdurdu = true;
            ct_pausehakki = ct_pausehakki+1;
            ctroundbasipause = false;
            client_print_color(0,print_team_blue,"^3%s ^1Takiminin ^4%i . ^1pause hakkini kullandi. Unpause icin her iki takimda /pause yazmalidir.",name, ct_pausehakki );
            //chat_color(0,"%s %s !tTakiminin %i . pause hakkini kullandi. Unpause icin her iki takimda /pause yazmalidir.",szStag,name, ct_pausehakki );
            macbotupauseat(pauseatankisi);

        }
        else if (ttroundbasipause == true) {

            set_hudmessage(0, 255, 0, -1.0, 0.20, 0, 6.0, 5.0)
            show_hudmessage(0, "%s", timer)


            tedurdurdu = true;
            tt_pausehakki = tt_pausehakki+1;
            ttroundbasipause = false
            client_print_color(0,print_team_red,"^3%s ^1Takiminin ^4%i . ^1pause hakkini kullandi. Unpause icin her iki takimda /pause yazmalidir.",name, tt_pausehakki );
            //chat_color(0,"%s %s Takiminin %i . pause hakkini kullandi. Unpause icin her iki takimda /pause yazmalidir.",szStag,name, tt_pausehakki );
            macbotupauseat(pauseatankisi);
        }
    }
}

public new_round(id)
{
    if(mac == true) {
        oyuncununpause = true
        static Float:freezetime

        freezetime = get_cvar_float("mp_freezetime")

        set_task(freezetime, "pausekapat")
        if(ttroundbasipause == true || ctroundbasipause == true){
            set_task(0.5,"roundbasipause")
        }

        rounds_elapsed += 1;
        set_task(1.0, "show_moneyCT")
        set_task(1.0, "show_moneyTE")
        set_task(1.0, "speceskoryazdir")
    }
    else if(mac == false) {
        if(get_pcvar_num(g_ready)) {
            set_task(1.0, "ActualizaLista", TASK_LISTA, _, _, "b")
            set_task(1.0, "CheckLista", TASK_CHE, _, _, "b")
        }
    }


    return PLUGIN_HANDLED;
}

public readysorgulama(id){
    if(!get_pcvar_num(g_ready)){
        return PLUGIN_HANDLED
    }
    if(mac){
        return PLUGIN_HANDLED
    }
    new MsgTextCT[96];
    new MsgTextTT[96];

    for(new i = 1; i <= 32; i++)
    {
        if(is_user_connected(i) && (!EstoyReady[i]))
        {
            if(cs_get_user_team(i) == CS_TEAM_CT){
                new PlayerNameCT[32];
                get_user_name(i, PlayerNameCT, sizeof(PlayerNameCT) - 1)
                format(MsgTextCT, 95, "%s%s,", MsgTextCT, PlayerNameCT)
            }
            if(cs_get_user_team(i) == CS_TEAM_T){
                new PlayerNameTT[32];
                get_user_name(i, PlayerNameTT, sizeof(PlayerNameTT) - 1)
                format(MsgTextTT, 95, "%s%s,", MsgTextTT, PlayerNameTT)
            }
        }
    }
    chat_color(id,"!reklam !yHazir Olmayanlar; %s .",MsgTextTT)
    chat_color(id,"!reklam !yHazir Olmayanlar; %s ",MsgTextCT)
    return PLUGIN_CONTINUE;
}

public takimlariuyar(id){
    if(!get_pcvar_num(g_ready)){
        client_cmd(id,"macmenu")
        return PLUGIN_HANDLED
    }
    if(mac){
        client_cmd(id,"macmenu")
        return PLUGIN_HANDLED
    }
    if (get_pcvar_num(g_haritasayac) == 1 ){
        chat_color(0,"!reklam %s takimi TE olarak maÃ§a baslayacak || %s takimi CT olarak maÃ§a baslayacak",TakimAcevir, TakimBcevir)
    }
    else if (get_pcvar_num(g_haritasayac) == 2 ){
        chat_color(0,"!reklam %s takimi TE olarak maÃ§a baslayacak || %s takimi CT olarak maÃ§a baslayacak",TakimBcevir, TakimAcevir)
    }
    else if (get_pcvar_num(g_haritasayac) == 3 ){
        chat_color(0,"!reklam %s takimi TE olarak maÃ§a baslayacak || %s takimi CT olarak maÃ§a baslayacak",TakimAcevir, TakimBcevir)
    }
    else if (get_pcvar_num(g_haritasayac) == 4 ){
        chat_color(0,"!reklam %s takimi TE olarak maÃ§a baslayacak || %s takimi CT olarak maÃ§a baslayacak",TakimBcevir, TakimAcevir)
    }
    else if (get_pcvar_num(g_haritasayac) == 5 ){
        chat_color(0,"!reklam %s takimi TE olarak maÃ§a baslayacak || %s takimi CT olarak maÃ§a baslayacak",TakimAcevir, TakimBcevir)
    }
    client_cmd(id,"macmenu")
    return PLUGIN_CONTINUE;
}

public ActualizaLista()
{
    if(!get_pcvar_num(g_ready)){
        return PLUGIN_HANDLED
    }
    if(mac){
        return PLUGIN_HANDLED
    }

    if(ReadyCont > 0){
        set_hudmessage(200, 100, 0, 0.020000,0.250000, 0, 0.0, 1.1, 0.0, 0.0, -1)
        show_hudmessage(0, "Hazir Olanlar 10'da %i" , ReadyCont)
    }
    else {
        set_hudmessage(200, 100, 0, 0.020000,0.250000, 0, 0.0, 1.1, 0.0, 0.0, -1)
        show_hudmessage(0, "Hazir Olanlar 10'da 0" , ReadyCont )
    }


    return PLUGIN_CONTINUE;
}
public CheckLista(id)
{
    if(!get_pcvar_num(g_ready)){
        return PLUGIN_HANDLED
    }

    if(ReadyCont != 0 && ReadyCont == 10 && !BorraLista)
    {
        remove_task(TASK_LISTA)

        BorraLista = true;
        set_task (0.1, "cmdVale")
    }

    if(BorraLista && ReadyCont != 10)
    {
        BorraLista = false;
        set_task(1.0, "ActualizaLista", TASK_LISTA, _, _, "b");
    }
    return PLUGIN_CONTINUE;
}

public oyuncuready(id){
    if(!EstoyReady[id] && get_user_team(id) == 1 || !EstoyReady[id] && get_user_team(id) == 2){
        EstoyReady[id] = true;
        ReadyCont++;
    }
}
public oyuncuunready(id){
    if(get_user_team(id) == 3) return PLUGIN_HANDLED;
    if(EstoyReady[id] && get_user_team(id) == 1 || EstoyReady[id] && get_user_team(id) == 2){
        EstoyReady[id] = false;
        ReadyCont--;
        new name[32]
        get_user_name(id,name,31)
        chat_color(0,"!reklam %s hazir olmadigini belirtti.",name)
    }
    return PLUGIN_CONTINUE;
}
//public plugin_precache() {
//  precache_model(g_sprite)
//}
public oyuncudogdugunda(id)
{
    if(paragosterge == 1 && mac == true && get_pcvar_num(g_paralarigoster) == 1) {
        if(get_user_team(id) == 1)
        {
            cmdParaGoster(id);
        }
        else if(get_user_team(id) == 2)
        {
            cmdParaGoster(id);
        }
    }
    if (get_pcvar_num(g_kfteleport) == 1 && g_bKnifeRound ) {
        set_task(0.1, "teleport", id);
    }
    if (get_user_team(id) == 1){
        if(oyuncumodel[id] == 1){
            cs_set_user_model(id, "arctic");
        }
        if(oyuncumodel[id] == 2){
            cs_set_user_model(id, "guerilla");
        }
        if(oyuncumodel[id] == 3){
            cs_set_user_model(id, "leet");
        }
        if(oyuncumodel[id] == 4){
            cs_set_user_model(id, "terror");
        }
    }
    if (get_user_team(id) == 2){
        if(oyuncumodel[id] == 1){
            cs_set_user_model(id, "gign");
        }
        if(oyuncumodel[id] == 2){
            cs_set_user_model(id, "gsg9");
        }
        if(oyuncumodel[id] == 3){
            cs_set_user_model(id, "sas");
        }
        if(oyuncumodel[id] == 4){
            cs_set_user_model(id, "urban");
        }
    }
    if(sprgoster) {
        if(is_user_alive(id))
        {
            set_task(1.0, "dondur", id);
            //display_hud_sprite(id, g_sprite, 0.02, 10, 3.0)
            //strip_user_weapons(id)
        }
    }
    else {
        if(is_user_alive(id))
        {
            //remove_hud_sprite(id)
            set_pev( id, pev_flags, pev( id, pev_flags ) & ~FL_FROZEN );
        }
    }
    return PLUGIN_HANDLED
}

public dondur (id) {

    set_pev( id, pev_flags, pev( id, pev_flags ) | FL_FROZEN );
}

public restart_round()
{
    rounds_elapsed = 0;
    tt_win = 0
    ct_win = 0

}

public chatFilter(id) {
    new message[128];
    read_argv(1, message, 127);

    for(new i=0;i<sizeof(g_cmds);i++) {

        new cmd[33];
        formatex(cmd,32,"%s",g_cmds[i])
        if(containi(message,cmd) == 0) {

            //admin level required
            switch(i) {
                case 0,1,2,3,4,5,6,7,8: {
                    if(!(get_user_flags(id) & ADMIN_CVAR))
                        return PLUGIN_CONTINUE;
                }
            }
            callBack(id, i);
            return PLUGIN_HANDLED;
        }
    }
    return PLUGIN_CONTINUE;
}
public callBack(id, cID) {
    new message[128], cmd[33], arg[65], arg2[65];
    read_argv (1, message, 128);
    parse(message,cmd,32,arg,64,arg2,64);
    replace(cmd,32,"ghsfg","");

    switch(cID) {
        case 0: { // kick
            console_cmd(id,"amx_kick %s", arg);
        }
        case 1: { // kick
            console_cmd(id,"amx_kick %s", arg);
        }
        case 2: { // kick
            console_cmd(id,"amx_kick %s", arg);
        }
        case 3: { // map
            console_cmd(id,"amx_map %s", arg);
        }
        case 4: { // map
            console_cmd(id,"amx_map %s", arg);
        }
        case 5: { // map
            console_cmd(id,"amx_map %s", arg);
        }
        case 6: { // banip
            new bantime=str_to_num(arg2);

            if(bantime==0)
                bantime=1;
            console_cmd(id,"amx_banip %s %d", arg, bantime);
        }
        case 7: { // banip
            new bantime=str_to_num(arg2);

            if(bantime==0)
                bantime=1;
            console_cmd(id,"amx_banip %s %d", arg, bantime);
        }
        case 8: { // banip
            new bantime=str_to_num(arg2);

            if(bantime==0)
                bantime=1;
            console_cmd(id,"amx_banip %s %d", arg, bantime);
        }
        case 9: { // slay
            console_cmd(id,"amx_slay %s", arg);
        }
        case 10: { // slay
            console_cmd(id,"amx_slay %s", arg);
        }
        case 11: { // slay
            console_cmd(id,"amx_slay %s", arg);
        }
        case 12: { // slap
            console_cmd(id,"amx_slap %s 0", arg);
        }
        case 13: { // slap
            console_cmd(id,"amx_slap %s 0", arg);
        }
        case 14: { // slap
            console_cmd(id,"amx_slap %s 0", arg);
        }
        case 15: {
            console_cmd(id,"amx_teammenu");
        }
        case 16: {
            console_cmd(id,"amx_teammenu");
        }
        case 17: {
            console_cmd(id,"amx_teammenu");
        }
        case 18: {
            console_cmd(id,"amx_kickmenu");
        }
        case 19: {
            console_cmd(id,"amx_kickmenu");
        }
        case 20: {
            console_cmd(id,"amx_kickmenu");
        }
        case 21: {
            console_cmd(id,"amx_banmenu");
        }
        case 22: {
            console_cmd(id,"amx_banmenu");
        }
        case 23: {
            console_cmd(id,"amx_banmenu");
        }
        case 24: {
            console_cmd(id,"amx_slapmenu");
        }
        case 25: {
            console_cmd(id,"amx_slapmenu");
        }
        case 26: {
            console_cmd(id,"amx_slapmenu");
        }
        case 27: {
            console_cmd(id,"amx_teammenu");
        }
        case 28: {
            console_cmd(id,"amx_teammenu");
        }
        case 29: {
            console_cmd(id,"amx_teammenu");
        }
        case 30: {
            console_cmd(id,"amx_kickmenu");
        }
        case 31: {
            console_cmd(id,"amx_kickmenu");
        }
        case 32: {
            console_cmd(id,"amx_kickmenu");
        }
        case 33: {
            console_cmd(id,"amx_banmenu");
        }
        case 34: {
            console_cmd(id,"amx_banmenu");
        }
        case 35: {
            console_cmd(id,"amx_banmenu");
        }
        case 36: {
            console_cmd(id,"amx_slapmenu");
        }
        case 37: {
            console_cmd(id,"amx_slapmenu");
        }
        case 38: {
            console_cmd(id,"amx_slapmenu");
        }
        case 39: {
            console_cmd(id,"amx_map de_dust2");
        }
        case 40: {
            console_cmd(id,"amx_map de_dust2");
        }
        case 41: {
            console_cmd(id,"amx_map de_dust2");
        }
        case 42: {
            console_cmd(id,"amx_map de_inferno");
        }
        case 43: {
            console_cmd(id,"amx_map de_inferno");
        }
        case 44: {
            console_cmd(id,"amx_map de_inferno");
        }
        case 45: {
            console_cmd(id,"amx_map de_nuke");
        }
        case 46: {
            console_cmd(id,"amx_map de_nuke");
        }
        case 47: {
            console_cmd(id,"amx_map de_nuke");
        }
        case 48: {
            console_cmd(id,"amx_map de_cbble");
        }
        case 49: {
            console_cmd(id,"amx_map de_cbble");
        }
        case 50: {
            console_cmd(id,"amx_map de_cbble");
        }
        case 51: {
            console_cmd(id,"amx_map de_tuscan");
        }
        case 52: {
            console_cmd(id,"amx_map de_tuscan");
        }
        case 53: {
            console_cmd(id,"amx_map de_tuscan");
        }
        case 54: {
            console_cmd(id,"amx_map de_train");
        }
        case 55: {
            console_cmd(id,"amx_map de_train");
        }
        case 56: {
            console_cmd(id,"amx_map de_train");
        }
        case 57: {
            console_cmd(id,"amx_map de_cpl_fire");
        }
        case 58: {
            console_cmd(id,"amx_map de_cpl_fire");
        }
        case 59: {
            console_cmd(id,"amx_map de_cpl_fire");
        }
        case 60: {
            console_cmd(id,"amx_map de_cpl_mill");
        }
        case 61: {
            console_cmd(id,"amx_map de_cpl_mill");
        }
        case 62: {
            console_cmd(id,"amx_map de_cpl_mill");
        }
        case 63: {
            console_cmd(id,"amx_map de_cpl_overrun");
        }
        case 64: {
            console_cmd(id,"amx_map de_cpl_overrun");
        }
        case 65: {
            console_cmd(id,"amx_map de_cpl_overrun");
        }
        case 66: {
            console_cmd(id,"amx_map de_cpl_strike");
        }
        case 67: {
            console_cmd(id,"amx_map de_cpl_strike");
        }
        case 68: {
            console_cmd(id,"amx_map de_cpl_strike");
        }
        case 69: {
            console_cmd(id,"amx_cvar %s %s", arg,arg2);
        }
        case 70: {
            console_cmd(id,"amx_cvar %s %s", arg,arg2);
        }
        case 71: {
            console_cmd(id,"amx_cvar %s %s", arg,arg2);
        }
        case 72: {
            console_cmd(id,"amx_rcon %s %s", arg,arg2);
        }
        case 73: {
            console_cmd(id,"amx_rcon %s %s", arg,arg2);
        }
        case 74: {
            console_cmd(id,"amx_rcon %s %s", arg,arg2);
        }
    }
    return PLUGIN_HANDLED;
}

public plugin_end( ) {
    TrieDestroy( g_tTeamData );
}


public GameDesc( ) {

    forward_return(FMV_STRING,"ChallengeArea.NET")
    return FMRES_SUPERCEDE

}
public client_disconnected(id) {

    if(dusme == true) {
        cspluginos2 = get_playersnum(0);
        if(cspluginos2 >= cspluginos) {
            set_pcvar_string(g_pPasswordPointer, "")
            chat_color(0,"%s !yEksik Kisi Bulundu.",szStag)
            chat_color(0,"%s !yServer Sifresi Kaldirildi.",szStag)

        }
    }

    if(EstoyReady[id]) {
        EstoyReady[id] = false;
        ReadyCont--;
    }

}

public client_connect(id) {
    if(dusme == true) {
        cspluginos2 = get_playersnum(0);
        if(cspluginos2 == cspluginos) {
            chat_color(0,"%s Eksik Kisi Tamamlandi.Sifre Seciliyor.",szStag)
            rastgelesifre()
        }
    }
}

public plugin_cfg() {

    if(is_plugin_loaded("Pause Plugins") != -1)
        server_cmd("amx_pausecfg add ^"%s^"", PLUGIN)
}

public off() {

    server_cmd("amx_off")

    chat_color(0,"%s !yAmxmodx !tKapatildi.",szStag)

    return PLUGIN_HANDLED
}

public on() {

    server_cmd("amx_on")

    chat_color(0,"%s !yAmxmodx !tAcildi.",szStag)

    return PLUGIN_HANDLED
}


public captura_score() {

    if (mac == true) {

        new team[16],Float:score
        read_data(1,team,15)
        read_data(2,score)

        if(equal(team,"CT"))
            ct_win = floatround(score)


        if(equal(team,"TERRORIST"))
            tt_win = floatround(score)

        total = ct_win + tt_win
        if (uzatmalar == true) {
            uzatmatoplamct = uzatmaekle*3
            uzatmatoplamct = ct_win + totalCT + uzatmatoplamct
            uzatmatoplamct = uzatmatoplamct+15
            uzatmatoplamte = uzatmaekle*3
            uzatmatoplamte = tt_win + totalTT + uzatmatoplamte
            uzatmatoplamte = uzatmatoplamte+15
        }

        round_end()
    }
}
public round_end(){

    if (mac == true)   {

        if (uzatmalar == true) {
            if(total == 3 && tur3 == false) {
                totalCT = tt_win
                totalTT = ct_win
                server_cmd("sv_restart 5")
                set_task(1.0, "cambio_teams", TASK_CAMBIO)

                chat_color(0,"%s 1 RESTART'tan Sonra Diger Devre Baslayacak.",szStag)

                chat_color(0,"%s Takimlar Degistiriliyor Counter-Terrorists : %i - Terrorists : %i .",szStag,totalTT,totalCT)

                set_task(1.0, "mitadmsg2")
                globalCT = totalCT
                globalTT = totalTT
                tt_win = 0
                ct_win = 0
                tur3 = true
                totalct_pausehakki = ct_pausehakki
                totaltt_pausehakki = tt_pausehakki
                ct_pausehakki = totaltt_pausehakki
                tt_pausehakki = totalct_pausehakki
                oyuncuskorkayit();
                set_task(7.0, "oyuncuskorver")
            }
            else if (ct_win + totalCT == 4){
                chat_color(0,"%s Counter-Terorists Maci Kazandi.",szStag)

                csplugincomBlu
                show_hudmessage(0,"Counter-Teroristler Kazandi.")

                end = true
                mitad = false
                if(uzatmadegerkaydetme == 0) {
                    if (get_pcvar_num(g_kfmoduboucaktif) == 1 ){
                        if (get_pcvar_num(g_haritasayac) == 1 ){
                            set_pcvar_num(g_birinciharitakazanan,1)
                            set_pcvar_num(g_haritasayac,2)
                            set_task(7.0, "sonrakiharitayiac")
                            kaptanboharitaonayi = true
                        }
                        else if (get_pcvar_num(g_haritasayac) == 2 ){
                            set_pcvar_num(g_ikinciharitakazanan,2)
                            set_pcvar_num(g_haritasayac,3)
                            if (get_pcvar_num(g_birinciharitakazanan) == 2 ) {
                                //EKYAZI
                            }
                            else{
                                set_task(7.0, "sonrakiharitayiac")
                                kaptanboharitaonayi = true
                            }
                        }
                        else if (get_pcvar_num(g_haritasayac) == 3 ){
                            set_pcvar_num(g_ucuncuharitakazanan,1)
                            set_pcvar_num(g_haritasayac,3)
                        }
                        set_task(6.0, "BobesHaritalariSoyleherkes")
                    }
                    if (get_pcvar_num(g_kfmoduboucaktif) == 2 ){
                        if (get_pcvar_num(g_haritasayac) == 1 ){
                            set_pcvar_num(g_birinciharitakazanan,1)
                            set_pcvar_num(g_haritasayac,2)
                            set_task(7.0, "sonrakiharitayiac")
                            kaptanboharitaonayi = true
                        }
                        else if (get_pcvar_num(g_haritasayac) == 2 ){
                            set_pcvar_num(g_ikinciharitakazanan,2)
                            set_pcvar_num(g_haritasayac,3)
                            set_task(7.0, "sonrakiharitayiac")
                            kaptanboharitaonayi = true
                        }
                        else if (get_pcvar_num(g_haritasayac) == 3 ){
                            set_pcvar_num(g_ucuncuharitakazanan,1)
                            set_pcvar_num(g_haritasayac,4)
                            set_task(7.0, "sonrakiharitayiac")
                            kaptanboharitaonayi = true
                        }
                        else if (get_pcvar_num(g_haritasayac) == 4 ){
                            set_pcvar_num(g_dorduncuharitakazanan,2)
                            set_pcvar_num(g_haritasayac,5)
                            set_task(7.0, "sonrakiharitayiac")
                            kaptanboharitaonayi = true
                        }
                        else if (get_pcvar_num(g_haritasayac) == 5 ){
                            set_pcvar_num(g_besinciharitakazanan,1)
                            set_pcvar_num(g_haritasayac,5)
                        }
                        set_task(6.0, "BobesHaritalariSoyleherkes")
                    }
                }
                else if(uzatmadegerkaydetme == 1) {
                    if (get_pcvar_num(g_kfmoduboucaktif) == 1 ){
                        if (get_pcvar_num(g_haritasayac) == 1 ){
                            set_pcvar_num(g_birinciharitakazanan,2)
                            set_pcvar_num(g_haritasayac,2)
                            set_task(7.0, "sonrakiharitayiac")
                            kaptanboharitaonayi = true
                        }
                        else if (get_pcvar_num(g_haritasayac) == 2 ){
                            set_pcvar_num(g_ikinciharitakazanan,1)
                            set_pcvar_num(g_haritasayac,3)
                            if (get_pcvar_num(g_birinciharitakazanan) == 1 ) {
                                //EKYAZI
                            }
                            else{
                                set_task(7.0, "sonrakiharitayiac")
                                kaptanboharitaonayi = true
                            }
                        }
                        else if (get_pcvar_num(g_haritasayac) == 3 ){
                            set_pcvar_num(g_ucuncuharitakazanan,2)
                            set_pcvar_num(g_haritasayac,3)
                        }
                        set_task(6.0, "BobesHaritalariSoyleherkes")
                    }
                    if (get_pcvar_num(g_kfmoduboucaktif) == 2 ){
                        if (get_pcvar_num(g_haritasayac) == 1 ){
                            set_pcvar_num(g_birinciharitakazanan,2)
                            set_pcvar_num(g_haritasayac,2)
                            set_task(7.0, "sonrakiharitayiac")
                            kaptanboharitaonayi = true
                        }
                        else if (get_pcvar_num(g_haritasayac) == 2 ){
                            set_pcvar_num(g_ikinciharitakazanan,1)
                            set_pcvar_num(g_haritasayac,3)
                            set_task(7.0, "sonrakiharitayiac")
                            kaptanboharitaonayi = true
                        }
                        else if (get_pcvar_num(g_haritasayac) == 3 ){
                            set_pcvar_num(g_ucuncuharitakazanan,2)
                            set_pcvar_num(g_haritasayac,4)
                            set_task(7.0, "sonrakiharitayiac")
                            kaptanboharitaonayi = true
                        }
                        else if (get_pcvar_num(g_haritasayac) == 4 ){
                            set_pcvar_num(g_dorduncuharitakazanan,1)
                            set_pcvar_num(g_haritasayac,5)
                            set_task(7.0, "sonrakiharitayiac")
                            kaptanboharitaonayi = true
                        }
                        else if (get_pcvar_num(g_haritasayac) == 5 ){
                            set_pcvar_num(g_besinciharitakazanan,2)
                            set_pcvar_num(g_haritasayac,5)
                        }
                        set_task(6.0, "BobesHaritalariSoyleherkes")
                    }
                }
            }
            else if (tt_win + totalTT == 4)
            {
                chat_color(0,"%s Terorists Maci Kazandi.",szStag)
                csplugincomRed
                show_hudmessage(0,"Teroristler Kazandi.")


                end = true
                mitad = false
                if(uzatmadegerkaydetme == 0) {
                    if (get_pcvar_num(g_kfmoduboucaktif) == 1 ){
                        if (get_pcvar_num(g_haritasayac) == 1 ){
                            set_pcvar_num(g_birinciharitakazanan,2)
                            set_pcvar_num(g_haritasayac,2)
                            set_task(7.0, "sonrakiharitayiac")
                            kaptanboharitaonayi = true
                        }
                        else if (get_pcvar_num(g_haritasayac) == 2 ){
                            set_pcvar_num(g_ikinciharitakazanan,1)
                            set_pcvar_num(g_haritasayac,3)
                            if (get_pcvar_num(g_birinciharitakazanan) == 1 ) {
                                //EKYAZI
                            }
                            else{
                                set_task(7.0, "sonrakiharitayiac")
                                kaptanboharitaonayi = true
                            }
                        }
                        else if (get_pcvar_num(g_haritasayac) == 3 ){
                            set_pcvar_num(g_ucuncuharitakazanan,2)
                            set_pcvar_num(g_haritasayac,3)
                        }
                        set_task(6.0, "BobesHaritalariSoyleherkes")
                    }
                    if (get_pcvar_num(g_kfmoduboucaktif) == 2 ){
                        if (get_pcvar_num(g_haritasayac) == 1 ){
                            set_pcvar_num(g_birinciharitakazanan,2)
                            set_pcvar_num(g_haritasayac,2)
                            set_task(7.0, "sonrakiharitayiac")
                            kaptanboharitaonayi = true
                        }
                        else if (get_pcvar_num(g_haritasayac) == 2 ){
                            set_pcvar_num(g_ikinciharitakazanan,1)
                            set_pcvar_num(g_haritasayac,3)
                            set_task(7.0, "sonrakiharitayiac")
                            kaptanboharitaonayi = true
                        }
                        else if (get_pcvar_num(g_haritasayac) == 3 ){
                            set_pcvar_num(g_ucuncuharitakazanan,2)
                            set_pcvar_num(g_haritasayac,4)
                            set_task(7.0, "sonrakiharitayiac")
                            kaptanboharitaonayi = true
                        }
                        else if (get_pcvar_num(g_haritasayac) == 4 ){
                            set_pcvar_num(g_dorduncuharitakazanan,1)
                            set_pcvar_num(g_haritasayac,5)
                            set_task(7.0, "sonrakiharitayiac")
                            kaptanboharitaonayi = true
                        }
                        else if (get_pcvar_num(g_haritasayac) == 5 ){
                            set_pcvar_num(g_besinciharitakazanan,2)
                            set_pcvar_num(g_haritasayac,5)
                        }
                        set_task(6.0, "BobesHaritalariSoyleherkes")
                    }
                }
                if(uzatmadegerkaydetme == 1) {
                    if (get_pcvar_num(g_kfmoduboucaktif) == 1 ){
                        if (get_pcvar_num(g_haritasayac) == 1 ){
                            set_pcvar_num(g_birinciharitakazanan,1)
                            set_pcvar_num(g_haritasayac,2)
                            set_task(7.0, "sonrakiharitayiac")
                            kaptanboharitaonayi = true
                        }
                        else if (get_pcvar_num(g_haritasayac) == 2 ){
                            set_pcvar_num(g_ikinciharitakazanan,2)
                            set_pcvar_num(g_haritasayac,3)
                            if (get_pcvar_num(g_birinciharitakazanan) == 2 ) {
                                //EKYAZI
                            }
                            else{
                                set_task(7.0, "sonrakiharitayiac")
                                kaptanboharitaonayi = true
                            }
                        }
                        else if (get_pcvar_num(g_haritasayac) == 3 ){
                            set_pcvar_num(g_ucuncuharitakazanan,1)
                            set_pcvar_num(g_haritasayac,3)
                        }
                        set_task(6.0, "BobesHaritalariSoyleherkes")
                    }
                    if (get_pcvar_num(g_kfmoduboucaktif) == 2 ){
                        if (get_pcvar_num(g_haritasayac) == 1 ){
                            set_pcvar_num(g_birinciharitakazanan,1)
                            set_pcvar_num(g_haritasayac,2)
                            set_task(7.0, "sonrakiharitayiac")
                            kaptanboharitaonayi = true
                        }
                        else if (get_pcvar_num(g_haritasayac) == 2 ){
                            set_pcvar_num(g_ikinciharitakazanan,2)
                            set_pcvar_num(g_haritasayac,3)
                            set_task(7.0, "sonrakiharitayiac")
                            kaptanboharitaonayi = true
                        }
                        else if (get_pcvar_num(g_haritasayac) == 3 ){
                            set_pcvar_num(g_ucuncuharitakazanan,1)
                            set_pcvar_num(g_haritasayac,4)
                            set_task(7.0, "sonrakiharitayiac")
                            kaptanboharitaonayi = true
                        }
                        else if (get_pcvar_num(g_haritasayac) == 4 ){
                            set_pcvar_num(g_dorduncuharitakazanan,2)
                            set_pcvar_num(g_haritasayac,5)
                            set_task(7.0, "sonrakiharitayiac")
                            kaptanboharitaonayi = true
                        }
                        else if (get_pcvar_num(g_haritasayac) == 5 ){
                            set_pcvar_num(g_besinciharitakazanan,1)
                            set_pcvar_num(g_haritasayac,5)
                        }
                        set_task(6.0, "BobesHaritalariSoyleherkes")
                    }
                }
            }
            else if (tt_win + totalTT == 3 && ct_win + totalCT == 3)
            {
                csplugincomVrd
                show_hudmessage(0, "Mac Berabere Sonuclandi.")

                set_cvar_string("mp_startmoney", "10000");
                set_cvar_string("sv_restart", "1");
                server_cmd("sv_restart 5")

                chat_color(0,"%s 5 Saniyelik RESTART'tan Sonra Uzatmalar Tekrar Baslayacak.",szStag)
                tt_win = 0
                ct_win = 0
                total = 0
                totalCT = 0
                totalTT = 0
                mitad = true
                uzatmalar = true
                tur3 = false
                uzatmaekle = uzatmaekle+1
                totalct_pausehakki = ct_pausehakki
                totaltt_pausehakki = tt_pausehakki
                ct_pausehakki = totalct_pausehakki
                tt_pausehakki = totaltt_pausehakki
                oyuncuskorkayit();
                set_task(7.0, "oyuncuskorver")
                if(uzatmadegerkaydetme == 1) { uzatmadegerkaydetme = 0; }
                else if(uzatmadegerkaydetme == 0) { uzatmadegerkaydetme = 1; }
            }
        }

        if (total == 15 && (!mitad)) {

            totalCT = tt_win
            totalTT = ct_win


            set_task(1.0, "cambio_teams", TASK_CAMBIO)

            chat_color(0,"%s 1 RESTART'tan Sonra 2.Devre Baslayacak.",szStag)

            server_cmd("sv_restart 5")

            mitad = true
            uzatmalar = false
            chat_color(0,"%s Takimlar Degistiriliyor Counter-Terrorists : %i - Terrorists : %i !y.",szStag,totalTT,totalCT)

            set_task(1.0, "mitadmsg")

            globalCT = totalCT
            globalTT = totalTT
            tt_win = 0
            ct_win = 0

            totalct_pausehakki = ct_pausehakki
            totaltt_pausehakki = tt_pausehakki
            ct_pausehakki = totaltt_pausehakki
            tt_pausehakki = totalct_pausehakki
            oyuncuskorkayit();
            set_task(7.0, "oyuncuskorver")
        }
    }
    if (mitad) {

        if (ct_win + totalCT == 16){
            chat_color(0,"%s Counter-Terorists Maci Kazandi.",szStag)

            csplugincomBlu
            show_hudmessage(0,"Counter-Teroristler Kazandi.")

            end = true
            mitad = false
            uzatmalar = false

            if (get_pcvar_num(g_kfmoduboucaktif) == 1 ){
                if (get_pcvar_num(g_haritasayac) == 1 ){
                    set_pcvar_num(g_birinciharitakazanan,1)
                    set_pcvar_num(g_haritasayac,2)
                    set_task(7.0, "sonrakiharitayiac")
                    kaptanboharitaonayi = true
                }
                else if (get_pcvar_num(g_haritasayac) == 2 ){
                    set_pcvar_num(g_ikinciharitakazanan,2)
                    set_pcvar_num(g_haritasayac,3)
                    if (get_pcvar_num(g_birinciharitakazanan) == 2 ) {
                                //EKYAZI
                    }
                    else{
                        set_task(7.0, "sonrakiharitayiac")
                        kaptanboharitaonayi = true
                    }
                }
                else if (get_pcvar_num(g_haritasayac) == 3 ){
                    set_pcvar_num(g_ucuncuharitakazanan,1)
                    set_pcvar_num(g_haritasayac,3)
                }
                set_task(6.0, "BobesHaritalariSoyleherkes")
            }
            if (get_pcvar_num(g_kfmoduboucaktif) == 2 ){
                if (get_pcvar_num(g_haritasayac) == 1 ){
                    set_pcvar_num(g_birinciharitakazanan,1)
                    set_pcvar_num(g_haritasayac,2)
                    set_task(7.0, "sonrakiharitayiac")
                    kaptanboharitaonayi = true
                }
                else if (get_pcvar_num(g_haritasayac) == 2 ){
                    set_pcvar_num(g_ikinciharitakazanan,2)
                    set_pcvar_num(g_haritasayac,3)
                    set_task(7.0, "sonrakiharitayiac")
                    kaptanboharitaonayi = true
                }
                else if (get_pcvar_num(g_haritasayac) == 3 ){
                    set_pcvar_num(g_ucuncuharitakazanan,1)
                    set_pcvar_num(g_haritasayac,4)
                    set_task(7.0, "sonrakiharitayiac")
                    kaptanboharitaonayi = true
                }
                else if (get_pcvar_num(g_haritasayac) == 4 ){
                    set_pcvar_num(g_dorduncuharitakazanan,2)
                    set_pcvar_num(g_haritasayac,5)
                    set_task(7.0, "sonrakiharitayiac")
                    kaptanboharitaonayi = true
                }
                else if (get_pcvar_num(g_haritasayac) == 5 ){
                    set_pcvar_num(g_besinciharitakazanan,1)
                    set_pcvar_num(g_haritasayac,5)
                }
                set_task(6.0, "BobesHaritalariSoyleherkes")
            }

        }
        else if (tt_win + totalTT == 16)
        {
            chat_color(0,"%s Terorists Maci Kazandi.",szStag)
            csplugincomRed
            show_hudmessage(0,"Teroristler Kazandi.")


            end = true
            mitad = false
            uzatmalar = false
            if (get_pcvar_num(g_kfmoduboucaktif) == 1 ){
                if (get_pcvar_num(g_haritasayac) == 1 ){
                    set_pcvar_num(g_birinciharitakazanan,2)
                    set_pcvar_num(g_haritasayac,2)
                    kaptanboharitaonayi = true
                    set_task(7.0, "sonrakiharitayiac")
                }
                else if (get_pcvar_num(g_haritasayac) == 2 ){
                    set_pcvar_num(g_ikinciharitakazanan,1)
                    set_pcvar_num(g_haritasayac,3)
                    if (get_pcvar_num(g_birinciharitakazanan) == 1 ) {
                                //EKYAZI
                    }
                    else{
                        kaptanboharitaonayi = true
                        set_task(7.0, "sonrakiharitayiac")

                    }
                }
                else if (get_pcvar_num(g_haritasayac) == 3 ){
                    set_pcvar_num(g_ucuncuharitakazanan,2)
                    set_pcvar_num(g_haritasayac,3)
                }
                set_task(6.0, "BobesHaritalariSoyleherkes")
            }
            if (get_pcvar_num(g_kfmoduboucaktif) == 2 ){
                if (get_pcvar_num(g_haritasayac) == 1 ){
                    set_pcvar_num(g_birinciharitakazanan,2)
                    set_pcvar_num(g_haritasayac,2)
                    kaptanboharitaonayi = true
                    set_task(7.0, "sonrakiharitayiac")
                }
                else if (get_pcvar_num(g_haritasayac) == 2 ){
                    set_pcvar_num(g_ikinciharitakazanan,1)
                    set_pcvar_num(g_haritasayac,3)
                    kaptanboharitaonayi = true
                    set_task(7.0, "sonrakiharitayiac")
                }
                else if (get_pcvar_num(g_haritasayac) == 3 ){
                    set_pcvar_num(g_ucuncuharitakazanan,2)
                    set_pcvar_num(g_haritasayac,4)
                    kaptanboharitaonayi = true
                    set_task(7.0, "sonrakiharitayiac")
                }
                else if (get_pcvar_num(g_haritasayac) == 4 ){
                    set_pcvar_num(g_dorduncuharitakazanan,1)
                    set_pcvar_num(g_haritasayac,5)
                    kaptanboharitaonayi = true
                    set_task(7.0, "sonrakiharitayiac")
                }
                else if (get_pcvar_num(g_haritasayac) == 5 ){
                    set_pcvar_num(g_besinciharitakazanan,2)
                    set_pcvar_num(g_haritasayac,5)
                }
                set_task(6.0, "BobesHaritalariSoyleherkes")
            }
        }

        else if (tt_win + totalTT == 15 && ct_win + totalCT == 15)
        {
            csplugincomVrd
            show_hudmessage(0, "15-15 Berabere^nUzatma Ayarlari Yuklendi.")

            set_cvar_string("mp_startmoney", "10000");
            set_cvar_string("sv_restart", "1");
            server_cmd("sv_restart 5")

            chat_color(0,"%s 5 Saniyelik RESTART'tan Sonra Uzatmalar Baslayacak.",szStag)
            tt_win = 0
            ct_win = 0
            total = 0
            totalCT = 0
            totalTT = 0
            mitad = true
            uzatmalar = true
            tur3 = false
            uzatmaekle = 0
            uzatmadegerkaydetme = 1
            totalct_pausehakki = ct_pausehakki
            totaltt_pausehakki = tt_pausehakki
            ct_pausehakki = totalct_pausehakki
            tt_pausehakki = totaltt_pausehakki
            oyuncuskorkayit();
            set_task(7.0, "oyuncuskorver")
        }
    }
    if (end){
        if( uzatmalar == false){
            chat_color(0,"%s Mac Sonucu : Counter-Terrorists : %i  -  Terrorists : %i",szStag, ct_win + totalCT,tt_win + totalTT)
            globalCT = totalCT + ct_win
            globalTT = totalTT + tt_win
        }
        else if( uzatmalar == true){
            uzatmatoplamct = uzatmaekle*3
            uzatmatoplamct = ct_win + totalCT + uzatmatoplamct
            uzatmatoplamct = uzatmatoplamct+15
            uzatmatoplamte = uzatmaekle*3
            uzatmatoplamte = tt_win + totalTT + uzatmatoplamte
            uzatmatoplamte = uzatmatoplamte+15

            globalCT = uzatmatoplamct
            globalTT = uzatmatoplamte
            chat_color(0,"%s Mac Sonucu : Counter-Terrorists : %i  -  Terrorists : %i",szStag, uzatmatoplamct,uzatmatoplamte)
        }

        set_task(5.0, "cmdMacBitir2")
        uzatmalar = false
        end = false
        pasarse = false
        mac = false
        for(new i = 1; i <= 32; i++) {
            if(demokayit[i]) {
                cmdStop(i);
            }
        }
    }
}

public oyuncuskorkayit() {
    for(new i = 1; i <= 32; i++) {
        if(get_user_team( i ) == 1 || get_user_team( i ) == 2) {

            toplamoldurme[i] = get_user_frags(i);
            toplamgeberme[i] = cs_get_user_deaths(i);
        }
    }
}
public oyuncuskorver() {
    for(new i = 1; i <= 32; i++) {
        if(get_user_team( i ) == 1 || get_user_team( i ) == 2) {
            cs_set_user_deaths(i, toplamgeberme[i])
            set_user_frags(i, toplamoldurme[i])
            cs_set_user_deaths(i, toplamgeberme[i])
            set_user_frags(i, toplamoldurme[i])
        }
    }
}
public cmdVale(id, level, cid) {

    if( !cmd_access( id, level, cid, 1 ) )

    return PLUGIN_HANDLED;

    pasarse = true

    new pass[32]
    get_cvar_string("sv_password",pass,sizeof(pass) - 1)
    for(new i = 1; i <= 32; i++)
    {
        EstoyReady[i] = false
        ReadyCont=0
    }
    if(!mitad) {

        tt_win = 0
        ct_win = 0
        total = 0
        totalCT = 0
        totalTT = 0
        end = false
        ct_pausehakki = 0
        tt_pausehakki = 0
        totalct_pausehakki = 0
        totaltt_pausehakki = 0
        set_task(1.0, "print", TASK_PRINT)
        //set_hudmessage(255, 255, 255, -1.0, 0.46, 0, 6.0, 6.0)
        //show_hudmessage(0, "Mac Baslatma Komutu Uygulandi!")
    }
    else

    tt_win = 0
    ct_win = 0
    mac = true
    ct_pausehakki = 0
    tt_pausehakki = 0
    set_task(1.0, "print", TASK_PRINT)
    //set_hudmessage(255, 255, 255, -1.0, 0.46, 0, 6.0, 6.0)
    //show_hudmessage(0, "Mac Baslatma Komutu Uygulandi!")
    return PLUGIN_HANDLED
}

public cmdVale2(id, level, cid) {

    if( !cmd_access( id, level, cid, 1 ) )

    return PLUGIN_HANDLED;

    pasarse = true

    new pass[32]
    get_cvar_string("sv_password",pass,sizeof(pass) - 1)

    if(!mitad) {

        tt_win = 0
        ct_win = 0
        total = 0
        totalCT = 0
        totalTT = 0
        end = false

        set_task(1.0, "print2", TASK_PRINT)
        //set_hudmessage(255, 255, 255, -1.0, 0.46, 0, 6.0, 12.0)
        //show_hudmessage(0, "Mac Baslatma Komutu Uygulandi!")
    }
    else

    tt_win = 0
    ct_win = 0
    mac = true
    set_task(1.0, "print2", TASK_PRINT)
    //set_hudmessage(255, 255, 255, -1.0, 0.46, 0, 6.0, 12.0)
    //show_hudmessage(0, "Mac Baslatma Komutu Uygulandi!")
    return PLUGIN_HANDLED
}

public cmdNuevo (id, level, cid){

    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED;

    tt_win = 0
    ct_win = 0
    total = 0
    totalCT = 0
    totalTT = 0
    globalCT = 0
    globalTT = 0
    end = false
    mitad = false

    return PLUGIN_HANDLED;
}

public cmdRR (id, level, cid){

    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED;

    server_cmd("sv_restart 1")

    g_bKnifeRound = false;
    sprgoster = false;
    chat_color(0,"%s 1 Saniyelik Restart Atildi", szStag)


    return PLUGIN_HANDLED;
}

public cmdRR3 (id, level, cid){

    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED;

    server_cmd("sv_restart 3")

    g_bKnifeRound = false;
    sprgoster = false;
    chat_color(0,"%s 3 Saniyelik Restart Atildi", szStag)


    return PLUGIN_HANDLED;
}

public cmdRR5 (id, level, cid){

    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED;

    server_cmd("sv_restart 5")

    g_bKnifeRound = false;
    sprgoster = false;
    chat_color(0,"%s 5 Saniyelik Restart Atildi", szStag)


    return PLUGIN_HANDLED;
}

public cmdNopass (id, level, cid){

    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED;

    set_pcvar_string(g_pPasswordPointer, "")
    dusme = false
    chat_color(0,"%s Server Sifresi Kaldirildi.",szStag)

    return PLUGIN_HANDLED;
}

public print2(){

    paragosterge = 0
    set_task (1.0,"onn")
    set_task (2.0,"dokuz")
    set_task (3.0,"sekiz")
    set_task (4.0,"yedi")
    set_task (5.0,"alti")
    set_task (6.0,"cinco")
    set_task (7.0,"cuatro")
    set_task (8.0,"tres")
    set_task (9.0,"dos")
    set_task (10.0,"uno")
    set_task (11.0,"valeria")

    set_task(11.0, "RR1")
    set_task(10.4, "MacAyariYap")

    remove_task(TASK_PRINT)
    set_task(13.4, "gostergeac", TASK_MSG)
    set_task(15.4, "msg", TASK_MSG)
}

public print(){

    paragosterge = 0
    set_task (1.0,"onn")
    set_task (2.0,"dokuz")
    set_task (3.0,"sekiz")
    set_task (4.0,"yedi")
    set_task (5.0,"alti")
    set_task (6.0,"cinco")
    set_task (7.0,"cuatro")
    set_task (8.0,"tres")
    set_task (9.0,"dos")
    set_task (10.0,"uno")
    set_task (11.0,"valeria")

    set_task(11.0, "RR12")
    set_task(14.1, "RR3")
    set_task(17.2, "RR5")
    set_task(13.4, "MacAyariYap")

    remove_task(TASK_PRINT)
    set_task(22.4, "gostergeac", TASK_MSG)
    set_task(23.4, "msg", TASK_MSG)
}

public say_resultado(id){
    if (mac == true) {

        if(!mitad){
            chat_color(id,"!reklam Round : %d", rounds_elapsed);
            chat_color(id,"!reklam Score : Counter-Terrorists: %i  | Terrorists:  %i",ct_win,tt_win)
        }
        else if (mitad) {
            if(uzatmalar == true){
                chat_color(id,"!reklam Round : %d", uzatmatoplamct+uzatmatoplamte+1);
                //chat_color(id,"Score : Counter-Terrorists: %i  | Terrorists: %i",ct_win + totalCT,tt_win + totalTT)
                chat_color(id,"!reklam Score : Counter-Terrorists: %i  | Terrorists: %i",uzatmatoplamct,uzatmatoplamte)

            }
            else if(uzatmalar == false){
                chat_color(id,"!reklam Round : %d", rounds_elapsed+15);
                chat_color(id,"!reklam Score : Counter-Terrorists: %i  | Terrorists: %i",ct_win + totalCT,tt_win + totalTT)
            }
        }
    }
    return PLUGIN_HANDLED;
}

public sayPass(id){

    new pass[32]
    get_cvar_string("sv_password",pass,sizeof(pass) - 1)


    if(pass[0])
    {
        chat_color(id,"%s Server Password: %s",szStag, pass)
        client_cmd(id,"password ^"%s^"",pass)
    }
    else
        chat_color(id,"%s Serverde Sifre Yok.",szStag)
}

public nosay(id){

    if(!get_pcvar_num(g_SAY))
        return PLUGIN_CONTINUE

    if(get_user_flags(id) & ADMIN_CFG)
        return PLUGIN_CONTINUE

    new said[192]
    read_args(said,191)

    chat_color(id, "%s Say konusman kapalidir.",szStag)

    return PLUGIN_HANDLED

}

public cmdCambioTeam(id){

    if (!get_pcvar_num(g_teamlock)) {

        pasarse = false
    }

    if (!pasarse)
        return PLUGIN_CONTINUE;

    if (cs_get_user_team(id) == CS_TEAM_SPECTATOR)
        return PLUGIN_HANDLED;

    chat_color(id,"%s Takim Degistirme Kapalidir.",szStag)
    modelsecmemenusu(id)

    return PLUGIN_HANDLED;
}

public modelsecmemenusu(id){
    new menu = menu_create("\yOyuncu GÃ¶rÃ¼nÃ¼mÃ¼nÃ¼ SeÃ§", "modelsecmemenusudevam");
    if (get_user_team(id) == 2){
        menu_additem(menu, "Seal Team 6", "4", 0);
        menu_additem(menu, "GSG-9", "2", 0);
        menu_additem(menu, "SAS", "3", 0);
        menu_additem(menu, "GIGN", "1", 0);
    }
    if (get_user_team(id) == 1){
        menu_additem(menu, "Phoenix Connexion \d(TERROR)", "8", 0);
        menu_additem(menu, "Elite Crew \d(LEET)", "7", 0);
        menu_additem(menu, "Arctic Avengers", "5", 0);
        menu_additem(menu, "Guerilla Warfare", "6", 0);
    }

    menu_setprop(menu, MPROP_EXIT, MEXIT_ALL);

    menu_display(id, menu, 0);
}
public modelsecmemenusudevam(id, menu, item)
{

    if( item == MENU_EXIT )
    {
        menu_destroy(menu);
        return PLUGIN_HANDLED;
    }
    new data[6], szName[64];
    new access, callback;
    menu_item_getinfo(menu, item, access, data,charsmax(data), szName,charsmax(szName), callback);
    new key = str_to_num(data);
    switch(key)
    {
        case 1:
        {
            oyuncumodel[id] = 1
            chat_color(id,"%s Bir sonraki el modeliniz GIGN olarak degisecek.",szStag)
        }
        case 2:
        {
            oyuncumodel[id] = 2
            chat_color(id,"%s Bir sonraki el modeliniz GSG9 olarak degisecek.",szStag)
        }
        case 3:
        {
            oyuncumodel[id] = 3
            chat_color(id,"%s Bir sonraki el modeliniz SAS olarak degisecek.",szStag)
        }
        case 4:
        {
            oyuncumodel[id] = 4
            chat_color(id,"%s Bir sonraki el modeliniz URBAN olarak degisecek.",szStag)
        }
        case 5:
        {
            oyuncumodel[id] = 1
            chat_color(id,"%s Bir sonraki el modeliniz ARCTIC olarak degisecek.",szStag)
        }
        case 6:
        {
            oyuncumodel[id] = 2
            chat_color(id,"%s Bir sonraki el modeliniz GUERILLA olarak degisecek.",szStag)
        }
        case 7:
        {
            oyuncumodel[id] = 3
            chat_color(id,"%s Bir sonraki el modeliniz LEET olarak degisecek.",szStag)
        }
        case 8:
        {
            oyuncumodel[id] = 4
            chat_color(id,"%s Bir sonraki el modeliniz TERROR olarak degisecek.",szStag)
        }
    }

    menu_destroy(menu);
    return PLUGIN_HANDLED;
}
public cambio_teams(){

    new players[32], num
    get_players(players, num)

    new player
    for(new i = 0; i < num; i++)
    {
        player = players[i]

        if(cs_get_user_team(player) == CS_TEAM_T)
        {
            cs_set_user_team(player, CS_TEAM_CT)
        }
        else if(cs_get_user_team(player) == CS_TEAM_CT)
        {
            cs_set_user_team(player, CS_TEAM_T)
        }
    }
    remove_task(TASK_CAMBIO)
}

public gostergeac() {
    if(mac == true) {
        paragosterge = 1
    }
}
public RR1()
{
    if( mac == true ){
        server_cmd("sv_restart 3")
        g_bKnifeRound = false;
    }
}

public RR12()
{
    if( mac == true ){
        server_cmd("sv_restart 3")
        g_bKnifeRound = false;
        chat_color(0,"%s - 1.RESTART: 3 Saniye.", szStag)
    }
}

public RR3()
{
    if( mac == true ){
        server_cmd("sv_restart 3")
        g_bKnifeRound = false;
        chat_color(0,"%s - 2.RESTART: 3 Saniye.", szStag)
    }
}

public RR5()
{
    if( mac == true ){
        server_cmd("sv_restart 5")
        g_bKnifeRound = false;
        chat_color(0,"%s - 3.RESTART: 5 Saniye.", szStag)
    }
}

public onn() {
    if( mac == true ){

        //set_hudmessage(255, 255, 255, -1.0, 0.23, 0, 6.0, 12.0)
        set_hudmessage(255, 255, 255, -1.0, 0.42, 0, 6.0, 0.9)
        show_hudmessage(0, "%s ^n Mac Basliyor! [ 10 ]",szSite)
        g_bKnifeRound = false;
    }
}
public dokuz() {
    if( mac == true ){

        //set_hudmessage(255, 255, 255, -1.0, 0.23, 0, 6.0, 12.0)
        set_hudmessage(255, 255, 255, -1.0, 0.42, 0, 6.0, 0.9)
        show_hudmessage(0, "%s ^n Mac Basliyor! [ 9 ]",szSite)
    }
}
public sekiz() {
    if( mac == true ){


        //set_hudmessage(255, 255, 255, -1.0, 0.23, 0, 6.0, 12.0)
        set_hudmessage(255, 255, 255, -1.0, 0.42, 0, 6.0, 0.9)
        show_hudmessage(0, "%s ^n Mac Basliyor! [ 8 ]",szSite)
    }
}
public yedi() {
    if( mac == true ){


        //set_hudmessage(255, 255, 255, -1.0, 0.23, 0, 6.0, 12.0)
        set_hudmessage(255, 255, 255, -1.0, 0.42, 0, 6.0, 0.9)
        show_hudmessage(0, "%s ^n Mac Basliyor! [ 7 ]",szSite)
    }
}
public alti() {
    if( mac == true ){

        //set_hudmessage(255, 255, 255, -1.0, 0.23, 0, 6.0, 12.0)
        set_hudmessage(255, 255, 255, -1.0, 0.42, 0, 6.0, 0.9)
        show_hudmessage(0, "%s ^n Mac Basliyor! [ 6 ]",szSite)
    }
}

public cinco() {
    if( mac == true ){


        //set_hudmessage(255, 255, 255, -1.0, 0.23, 0, 6.0, 12.0)
        set_hudmessage(255, 255, 255, -1.0, 0.42, 0, 6.0, 0.9)
        show_hudmessage(0, "%s ^n Mac Basliyor! [ 5 ]",szSite)
    }
}
public cuatro() {
    if( mac == true ){


        //set_hudmessage(255, 255, 255, -1.0, 0.23, 0, 6.0, 12.0)
        set_hudmessage(255, 255, 255, -1.0, 0.42, 0, 6.0, 0.9)
        show_hudmessage(0, "%s ^n Mac Basliyor! [ 4 ]",szSite)
    }
}

public tres() {
    if( mac == true ){

        //set_hudmessage(255, 255, 255, -1.0, 0.23, 0, 6.0, 12.0)
        set_hudmessage(255, 255, 255, -1.0, 0.42, 0, 6.0, 0.9)
        show_hudmessage(0, "%s ^n Mac Basliyor! [ 3 ]",szSite)
    }
}

public dos() {
    if( mac == true ){

        //set_hudmessage(255, 255, 255, -1.0, 0.23, 0, 6.0, 12.0)
        set_hudmessage(255, 255, 255, -1.0, 0.42, 0, 6.0, 0.9)
        show_hudmessage(0, "%s ^n Mac Basliyor! [ 2 ]",szSite)
    }
}
public uno() {
    if( mac == true ){

        //set_hudmessage(255, 255, 255, -1.0, 0.23, 0, 6.0, 12.0)
        set_hudmessage(255, 255, 255, -1.0, 0.42, 0, 6.0, 0.9)
        show_hudmessage(0, "%s ^n Mac Basliyor! [ 1 ]",szSite)
    }
}

public valeria() {
    if( mac == true ){
        //set_hudmessage(255, 255, 255, -1.0, 0.23, 0, 6.0, 12.0)
        set_hudmessage(255, 255, 255, -1.0, 0.42, 0, 6.0, 1.3)
        show_hudmessage(0, "%s ^n Mac Basliyor! [ 0 ]",szSite)
    }
}

public mitadmsg(){

    csplugincomVrd
    show_hudmessage(0, "Takimlar Degistiriliyor ^n1.Devre ^nCounter-Terrorists : %i - Terrorists : %i", globalTT, globalCT)
}
public mitadmsg2(){
    uzatmatoplamct = uzatmaekle*3
    uzatmatoplamct = ct_win + totalCT + uzatmatoplamct
    uzatmatoplamct = uzatmatoplamct+15
    uzatmatoplamte = uzatmaekle*3
    uzatmatoplamte = tt_win + totalTT + uzatmatoplamte
    uzatmatoplamte = uzatmatoplamte+15
    csplugincomVrd
    show_hudmessage(0, "Takimlar Degistiriliyor ^n^nCounter-Terrorists : %i - Terrorists : %i", uzatmatoplamte, uzatmatoplamct)
}

public msg(){
    if( mac == true ) {

        paragosterge = 1
        if(!mitad){

            new pass[32]
            get_cvar_string("sv_password",pass,sizeof(pass) - 1)
            csplugincomGris
            for(new i=1;i <33; i++){
                if(get_user_team(i) == 1 || get_user_team(i) == 2){
                    show_hudmessage(i, "%s ^nMac Basladi^nPassword : %s", szSite,pass)
                }
                else{
                    show_hudmessage(i, "%s ^nMac Basladi^nIyi Seyirler", szSite)
                }
            }
        }

        else if (mitad) {

            new pass[32]
            get_cvar_string("sv_password",pass,sizeof(pass) - 1)

            csplugincomGris
            show_hudmessage(0, "Ikinci Devre - ^nCounter-Terrorists : %i - Terrorists : %i ^nPassword : %s", ct_win + totalCT, tt_win + totalTT, pass )
        }

    }
    remove_task(TASK_MSG)
}

public MacAyariYap()
{
    if( mac == true ) {

        set_cvar_string("mp_autokick", "0");
        set_cvar_string("mp_freezetime", "7");
        set_cvar_string("mp_autoteambalance", "0");
        set_cvar_string("mp_limitteams", "0");
        set_cvar_string("mp_friendlyfire", "1");
        set_cvar_string("sv_alltalk", "0");
        set_cvar_string("mp_startmoney", "800");
        set_cvar_string("mp_timelimit", "0");
        set_cvar_string("mp_forcecamera", "2");
        set_cvar_string("mp_forcechasecam", "2");
        set_cvar_string("mp_flashlight", "1");
        set_cvar_string("mp_tkpunish", "0");
        set_cvar_string("mp_c4timer", "35");
        set_cvar_string("mp_roundtime", "1.75");
        set_cvar_string("mp_footsteps", "1");
        set_cvar_string("mp_buytime", "0.25");
        set_cvar_string("mp_maxrounds", "0");
        set_cvar_string("allow_spectators", "1");
        set_cvar_string("mp_logmessages", "1");
        server_cmd ("aim_prac 0");
        hsolayi = false;
        if (get_pcvar_num(p_tlock) == 1 ) {
            set_cvar_string("csm_teamlock", "1");
        }
        if (get_pcvar_num(p_chat) == 1 ) {
            set_cvar_string("csm_nosay", "1");
        }
        if (get_pcvar_num(p_pass) == 1 ) {
            cspluginos = get_playersnum(0);
            dusme = true
            new pass[32]
            get_cvar_string("sv_password",pass,sizeof(pass) - 1)

            for(new i = 1; i < 33; i++)
            {
                new pass[32]
                get_cvar_string("sv_password",pass,sizeof(pass) - 1)
                if(pass[0])
                {
                }
                else {
                    rastgelesifre()
                }
                client_cmd(0,"password ^"%s^"",pass)
            }
        }
    }
}

public cmdRestart(id) {

    server_cmd("sv_restart 1")
    remove_task(TASK_RESTART)
}

public cmdAlltalk(id) {

    new Alltalk
    new said[192]
    read_args(said,191)
    Alltalk = get_cvar_pointer("sv_alltalk")
    if(containi(said,"alltalk") != -1){

    chat_color(id,"%s Alltalk : %s",szStag,get_pcvar_num(Alltalk)? "ON" : "OFF")

    }
}

public cmdSayNosay(id,level,cid) {

    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED


    if(get_pcvar_num(g_SAY) == 0 && set_pcvar_num(g_SAY,1)) {

        chat_color(0,"%s Say Konusmalari Kapatildi.",szStag)
    }
    else if(get_pcvar_num(g_SAY) == 1 && set_pcvar_num(g_SAY,0))

        chat_color(0,"%s Say Konusmalari Acildi.",szStag)

    return PLUGIN_HANDLED
}

stock chat_color(const id, const input[], any:...)
{
    new count = 1, players[32]
    static msg[191]
    vformat(msg, 190, input, 3)

    replace_all(msg, 190, "!g", "^1")
    replace_all(msg, 190, "!y", "^1")
    replace_all(msg, 190, "!t", "^1")
    replace_all(msg, 190, "!team2", "^1")
    replace_all(msg, 190, "!reklam", "^4ChallengeArea.NET :^1")

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
stock chat_colorrenkli(const id, const input[], any:...)
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
public CmdBanTeam( iPlayer, iLevel, iCId ) {
    if( !cmd_access( iPlayer, iLevel, iCId, 3 ) ) {
        return PLUGIN_HANDLED;
    }

    new szTeam[ 20 ];
    read_argv( 1, szTeam, 19 );
    strtoupper( szTeam );

    new CsTeams:iTeam;
    if( !TrieGetCell( g_tTeamData, szTeam, iTeam ) ) {
        console_print( iPlayer, "Invalid team." );
        return PLUGIN_HANDLED;
    }

    read_argv( 2, szTeam, 19 );
    new iTime = str_to_num( szTeam );

    read_argv( 3, szTeam, 19 );
    new bool:bBanIP = ( str_to_num( szTeam ) == 1 );

    new iPlayers[ 32 ], iNum, iTarget;
    get_players( iPlayers, iNum, "c" );

    for( new i = 0; i < iNum; i++ ) {
        iTarget = iPlayers[ i ];

        if( cs_get_user_team( iTarget ) == iTeam ) {
            client_cmd( iPlayer, "%s #%i %i", bBanIP ? "amx_banip" : "amx_ban", get_user_userid( iTarget ), iTime );
        }
    }

    console_print( iPlayer, "Banned all %s players.", g_szTeamNames[ iTeam ] );

    return PLUGIN_HANDLED;
}

public CmdBanT (id, level, cid){

    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED;

    client_cmd(id,"amx_banteam T 999999 1")


    return PLUGIN_HANDLED;
}

public CmdBanCT (id, level, cid){

    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED;

    client_cmd(id,"amx_banteam CT 999999 1")


    return PLUGIN_HANDLED;
}

public CmdBanS (id, level, cid){

    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED;

    client_cmd(id,"amx_banteam S 999999 1")


    return PLUGIN_HANDLED;
}

public CmdBanAll(id, level, cid){

    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED;

    client_cmd(id,"amx_banteam T 999999 1")
    client_cmd(id,"amx_banteam CT 999999 1")
    client_cmd(id,"amx_banteam S 999999 1")


    return PLUGIN_HANDLED;
}

public cmdkfteleport(id,level,cid) {

    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED


    if(get_pcvar_num(g_kfteleport) == 0 && set_pcvar_num(g_kfteleport,1)) {

    chat_color(0,"%s KFTeleport Acildi.",szStag)
    }
    else if(get_pcvar_num(g_kfteleport) == 1 && set_pcvar_num(g_kfteleport,0))

    chat_color(0,"%s KFTeleport Kapatildi.",szStag)

    return PLUGIN_HANDLED
}

public cmdparalarigoster(id,level,cid) {

    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED


    if(get_pcvar_num(g_paralarigoster) == 0 && set_pcvar_num(g_paralarigoster,1)) {

    chat_color(0,"%s Paralari Goster Acildi.",szStag)
    }
    else if(get_pcvar_num(g_paralarigoster) == 1 && set_pcvar_num(g_paralarigoster,0))

    chat_color(0,"%s Paralari Goster Kapatildi.",szStag)

    return PLUGIN_HANDLED
}

public cmdMacAyari(id,level,cid) {

    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED

    set_cvar_string("mp_autokick", "0");
    set_cvar_string("mp_freezetime", "7");
    set_cvar_string("mp_autoteambalance", "0");
    set_cvar_string("mp_limitteams", "0");
    set_cvar_string("mp_friendlyfire", "1");
    set_cvar_string("sv_alltalk", "0");
    set_cvar_string("mp_startmoney", "800");
    set_cvar_string("mp_timelimit", "0");
    set_cvar_string("mp_forcecamera", "2");
    set_cvar_string("mp_forcechasecam", "2");
    set_cvar_string("mp_flashlight", "1");
    set_cvar_string("mp_tkpunish", "0");
    set_cvar_string("mp_c4timer", "35");
    set_cvar_string("mp_roundtime", "1.75");
    set_cvar_string("mp_footsteps", "1");
    set_cvar_string("mp_buytime", "0.25");
    set_cvar_string("mp_maxrounds", "0");
    set_cvar_string("allow_spectators", "1");
    set_cvar_string("mp_logmessages", "1");
    set_cvar_string("sv_restart", "1");
    set_cvar_string("csm_nosay", "1");

    chat_color(0,"%s Mac Ayarlari Yuklendi..", szStag)

    return PLUGIN_HANDLED
}

public cmdPubAyari(id,level,cid) {

    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED

    set_cvar_string("mp_autokick", "0");
    set_cvar_string("mp_freezetime", "0");
    set_cvar_string("mp_autoteambalance", "0");
    set_cvar_string("mp_limitteams", "0");
    set_cvar_string("mp_friendlyfire", "0");
    set_cvar_string("mp_timelimit", "0");
    set_cvar_string("mp_forcecamera", "0");
    set_cvar_string("mp_forcechasecam", "0");
    set_cvar_string("mp_flashlight", "1");
    set_cvar_string("mp_tkpunish", "0");
    set_cvar_string("mp_c4timer", "35");
    set_cvar_string("mp_roundtime", "8");
    set_cvar_string("mp_footsteps", "1");
    set_cvar_string("mp_buytime", "3");
    set_cvar_string("sv_restart", "1");
    set_cvar_string("csm_nosay", "0");
    set_cvar_string("mp_startmoney", "16000");

    chat_color(0,"%s Public Ayarlar Yuklendi.",szStag)

    return PLUGIN_HANDLED
}

public cmdTaktik(id, level, cid){

    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED;

    set_cvar_string("mp_freezetime", "60");
    set_cvar_string("mp_roundtime", "9");
    set_cvar_string("mp_startmoney", "16000");
    set_cvar_string("sv_restart", "1");

    chat_color(0,"%s Taktik Ayarlari Yuklendi.",szStag)

    return PLUGIN_HANDLED;
}

public cmdNoTaktik(id, level, cid){

    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED;

    set_cvar_string("mp_autokick", "0");
    set_cvar_string("mp_freezetime", "7");
    set_cvar_string("mp_autoteambalance", "0");
    set_cvar_string("mp_limitteams", "0");
    set_cvar_string("mp_friendlyfire", "1");
    set_cvar_string("sv_alltalk", "0");
    set_cvar_string("mp_startmoney", "800");
    set_cvar_string("mp_timelimit", "0");
    set_cvar_string("mp_forcecamera", "2");
    set_cvar_string("mp_forcechasecam", "2");
    set_cvar_string("mp_flashlight", "1");
    set_cvar_string("mp_tkpunish", "0");
    set_cvar_string("mp_c4timer", "35");
    set_cvar_string("mp_roundtime", "1.75");
    set_cvar_string("mp_footsteps", "1");
    set_cvar_string("mp_buytime", "0.25");
    set_cvar_string("mp_maxrounds", "0");
    set_cvar_string("allow_spectators", "1");
    set_cvar_string("mp_logmessages", "1");

    chat_color(0,"%s Taktik Ayarlari Kaldirildi.",szStag)


    return PLUGIN_HANDLED;
}

public cmdFFAc(id,level,cid) {

    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED

    if(get_cvar_num("mp_friendlyfire") == 0){
        set_cvar_string("mp_friendlyfire", "1");
        chat_color(0,"%s FriendlyFire Acildi.",szStag)
    }
    else if (get_cvar_num("mp_friendlyfire") == 1){
        set_cvar_string("mp_friendlyfire", "0");
        chat_color(0,"%s FriendlyFire Kapatildi.",szStag)
    }

    return PLUGIN_HANDLED
}

public cmdTalk(id,level,cid) {

    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED
    if(get_cvar_num("sv_alltalk") == 0){
        set_cvar_string("sv_alltalk", "1");
        chat_color(0,"%s Alltalk Acildi.",szStag)
    }
    else if (get_cvar_num("sv_alltalk") == 1){
        set_cvar_string("sv_alltalk", "0");
        chat_color(0,"%s Alltalk Kapatildi.",szStag)
    }

    return PLUGIN_HANDLED
}

public cmdDegis(id, level, cid){

    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED;

    new players[32], num
    get_players(players, num)

    new player
    for(new i = 0; i < num; i++)
    {
        player = players[i]

        if(cs_get_user_team(player) == CS_TEAM_T)
        {
            cs_set_user_team(player, CS_TEAM_CT)
        }
        else if(cs_get_user_team(player) == CS_TEAM_CT)
        {
            cs_set_user_team(player, CS_TEAM_T)
        }
    }

    chat_color(0,"%s Takimlar Degistirildi.",szStag)


    return PLUGIN_HANDLED;
}

public cmdUzat(id, level, cid){

    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED;

    new players[32], num
    get_players(players, num)

    new player
    for(new i = 0; i < num; i++)
    {
        player = players[i]

        if(cs_get_user_team(player) == CS_TEAM_T)
        {
            cs_set_user_team(player, CS_TEAM_CT)
        }
        else if(cs_get_user_team(player) == CS_TEAM_CT)
        {
            cs_set_user_team(player, CS_TEAM_T)
        }
    }

    set_cvar_string("mp_startmoney", "10000");
    set_cvar_string("sv_restart", "1");

    chat_color(0,"%s Uzatma Ayarlari Yuklendi.",szStag)


    return PLUGIN_HANDLED;
}

public Uzat(){

    new players[32], num
    get_players(players, num)

    new player
    for(new i = 0; i < num; i++)
    {
        player = players[i]

        if(cs_get_user_team(player) == CS_TEAM_T)
        {
            cs_set_user_team(player, CS_TEAM_CT)
        }
        else if(cs_get_user_team(player) == CS_TEAM_CT)
        {
            cs_set_user_team(player, CS_TEAM_T)
        }
    }

    set_cvar_string("mp_startmoney", "10000");
    set_cvar_string("sv_restart", "1");

    return PLUGIN_HANDLED;
}
public SayPwkoy( id, level, cid )
{
    if(!(get_user_flags(id) & ADMIN_CFG))
        return PLUGIN_CONTINUE;

    static message[64]
    read_args (message, 63)
    remove_quotes (message)

    if( (message[0] == '!' || message[0] == '/' || message[0] == '.')
    && message[1] == 'p' && message[2] == 'a' && message[3] == 's' && message[4] == 's')
    {
        static pass[31];
        argbreak(message, message, 6, pass, 30);
        remove_quotes(pass);

        {
            client_cmd(id, "amx_cvar sv_password %s", pass)
        }

        chat_color(0,"%s Server Password :  %s", szStag,pass)
        chat_color(0,"%s Server Password :  %s", szStag,pass)
        chat_color(0,"%s Server Password :  %s", szStag,pass)
        cspluginos = get_playersnum(0);
        dusme = true
        return PLUGIN_HANDLED
    }
    return PLUGIN_CONTINUE
}

public SayDemo(id)
{
    new szSName[128]
    new szSName2[128]
    new szTime[32]
    new szTime2[32]
    get_time ( "%m-%d", szTime, 8 );
    get_time ( "%H-%M", szTime2, 8 );
    format( szSName, 127, "%s", szTime );
    format( szSName2, 127, "%s", szTime2 );
    {
        client_cmd(id, "record ^"CA-%s-%s^"", szSName,szSName2)
    }
    chat_color(id,"%s CA-%s-%s.dem Kaydediliyor.", szStag,szSName,szSName2)
    chat_color(id,"%s Demo Kaydini Bitirmek Icin !demostop Yaziniz.", szStag)
    demokayit[id] = true;

    return PLUGIN_HANDLED
}

public cmdStop(id) {
    client_cmd(id,"spk ^"events/enemy_died^"")
    client_cmd( id, "stop" );
    chat_color(id,"%s Demo Kaydedildi.",szStag)
    demokayit[id] = false;
    return PLUGIN_HANDLED;
}

public cmdSlayT(iCl, iLvl, iCmd)
{
        if (!cmd_access(iCl, iLvl, iCmd, 1))
                return PLUGIN_HANDLED;

        for (new iCl = 1; iCl <= g_iMaxPlayers; iCl++)
                if (is_user_alive(iCl) && cs_get_user_team(iCl) == CS_TEAM_T)
                        user_kill(iCl, KILL_FLAG);

        chat_color(0,"%s Terorists Takimi Slaylandi.",szStag)

        return PLUGIN_HANDLED;
}

public cmdSlayCT(iCl, iLvl, iCmd)
{
        if (!cmd_access(iCl, iLvl, iCmd, 1))
                return PLUGIN_HANDLED;

        for (new iCl = 1; iCl <= g_iMaxPlayers; iCl++)
                if (is_user_alive(iCl) && cs_get_user_team(iCl) == CS_TEAM_CT)
                        user_kill(iCl, KILL_FLAG);

        chat_color(0,"%s Counter-Terorists Takimi Slaylandi.",szStag)

        return PLUGIN_HANDLED;
}

public cmdSlayAll (id, level, cid){

    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED;

    console_cmd(id,"say .slayt");
    console_cmd(id,"say .slayct");

    chat_color(0,"%s Tum Oyuncular Slaylandi.",szStag)


    return PLUGIN_HANDLED;
}

public CmdSlapT( iPlayer, iLevel, iCId ) {
    if( !cmd_access( iPlayer, iLevel, iCId, 1 ) ) {
        return PLUGIN_HANDLED;
    }

    new szArg[ 16 ];
    read_argv( 1, szArg, 15 );

    new iDamage = str_to_num( szArg );

    new iPlayers[ 32 ], iNum;
    get_players( iPlayers, iNum, "a" );

    new iVictim;
    for( new i = 0; i < iNum; i++ ) {
        iVictim = iPlayers[ i ];
        if( cs_get_user_team( iVictim ) == CS_TEAM_T ) {
            if( get_user_health( iVictim ) <= iDamage ) {
                user_kill( iVictim );
            } else {
                user_slap( iVictim, iDamage );
            }
        }
    }

    new szName[ 32 ];
    get_user_name( iPlayer, szName, 31 );

    chat_color(0,"%s Terorists Takimi Slaplandi.",szStag)

    new szSteamID[ 35 ];
    get_user_authid( iPlayer, szSteamID, 34 );

    return PLUGIN_HANDLED;
}

public CmdSlapCT( iPlayer, iLevel, iCId ) {
    if( !cmd_access( iPlayer, iLevel, iCId, 1 ) ) {
        return PLUGIN_HANDLED;
    }

    new szArg[ 16 ];
    read_argv( 1, szArg, 15 );

    new iDamage = str_to_num( szArg );

    new iPlayers[ 32 ], iNum;
    get_players( iPlayers, iNum, "a" );

    new iVictim;
    for( new i = 0; i < iNum; i++ ) {
        iVictim = iPlayers[ i ];
        if( cs_get_user_team( iVictim ) == CS_TEAM_CT ) {
            if( get_user_health( iVictim ) <= iDamage ) {
                user_kill( iVictim );
            } else {
                user_slap( iVictim, iDamage );
            }
        }
    }

    new szName[ 32 ];
    get_user_name( iPlayer, szName, 31 );

    chat_color(0,"%s Counter-Terorists Takimi Slaplandi.",szStag)

    new szSteamID[ 35 ];
    get_user_authid( iPlayer, szSteamID, 34 );


    return PLUGIN_HANDLED;
}
//c-s-p-l-u-g-i-n-.-c-o-m
public CmdSlapAll( iPlayer, iLevel, iCId ) {
    if( !cmd_access( iPlayer, iLevel, iCId, 1 ) ) {
        return PLUGIN_HANDLED;
    }

    new szArg[ 16 ];
    read_argv( 1, szArg, 15 );

    new iDamage = str_to_num( szArg );

    new iPlayers[ 32 ], iNum;
    get_players( iPlayers, iNum, "a" );

    new iVictim;
    for( new i = 0; i < iNum; i++ ) {
        iVictim = iPlayers[ i ];
        if( get_user_health( iVictim ) <= iDamage ) {
            user_kill( iVictim );
        } else {
            user_slap( iVictim, iDamage );
        }
    }

    new szName[ 32 ];
    get_user_name( iPlayer, szName, 31 );

    chat_color(0,"%s Tum Oyuncular Slaplandi.",szStag)

    new szSteamID[ 35 ];
    get_user_authid( iPlayer, szSteamID, 34 );


    return PLUGIN_HANDLED;
}

public actionUnBanMenu(id,key) {

    switch(key) {
    case 8: {
        displayUnBanMenu(id, ++g_menuPosition[id])
    }
    case 9: {
        g_menuUnBanLine[id][0] = g_menuUnBanLine[id][0] - (8 + g_menuUnBanLine[id][1])
        if(g_menuUnBanLine[id][0] < 0) g_menuUnBanLine[id][0] = 0
        displayUnBanMenu(id, --g_menuPosition[id])
    }
    default: {

        new name[32], authid[32], ipaddress[24]
        get_user_authid(id, authid, 31)
        get_user_name(id, name, 31)
        get_user_ip(id, ipaddress, 23, 1)

        static logdosya[100]
        formatex(logdosya, charsmax(logdosya), "%s<%d><%s><%s> Bu Kisinin Banini Kaldirdi; %s", name,get_user_userid(id),authid,ipaddress,g_menuUnBanText[id][key])
        log_to_file("csmmacbot.log", logdosya)
        client_print(0, print_chat, "ADMIN %s: unban %s", name, g_menuUnBanText[id][key])

        if(g_menuUnBanType[id] == 1) {
        server_cmd("removeip ^"%s^"; writeip", g_menuUnBanText[id][key])
        server_exec()
        console_print(id, "IP ^"%s^" removed from ban list", g_menuUnBanText[id][key])
        }

        else {

        server_cmd("removeid %s; writeid",  g_menuUnBanText[id][key])
        console_print(id, "Authid ^"%s^" removed from ban list",  g_menuUnBanText[id][key])
        }

        g_menuUnBanLine[id][0] = g_menuUnBanLine[id][1] = 0
        displayUnBanMenu(id, g_menuPosition[id] = 0)
        }
    }
    return PLUGIN_HANDLED
}

checkSTEAMID(steamid[]) {

    new len = strlen(steamid)
    if(len > 10 && equali(steamid, "STEAM_", 6) && steamid[7] == ':' && steamid[9] == ':' && str_to_num(steamid[10])) {
        return 1
    }
    return 0
}

checkIP(ip[]) {

    new len = strlen(ip)
    new dots = 0, i = 0
    while(isdigit(ip[i]) || ip[i]=='.')
        if(ip[i++] == '.')
            ++dots
    if(i == len && dots == 3) {
        return 1
    }
    return 0
}

displayUnBanMenu(id,pos) {
    if(pos < 0)
    return

    new menuBody[512]
    new b = 0

    new len = format(menuBody, 511, g_coloredMenus ? "\yUnBan Menu\R%d^n\w^n" : "UnBan Menu %d^n^n", id, "UNBAN_MENU", pos + 1)

    new keys = (1<<9)
    new textlen, line
    new type = g_menuUnBanType[id]
    new temp[32], banTime[32], disable

    if(file_exists(g_bannedCfgFile[type])) {
        line = g_menuUnBanLine[id][0]
        while((line = read_file(g_bannedCfgFile[type], line, g_menuSelect[id], 63, textlen))) {
            temp[0] = '^0'
            banTime[0] = '^0'
            g_menuUnBanText[id][b][0] = '^0'
            disable = 0
            if(textlen < 9)
                disable = 1
            else if(parse(g_menuSelect[id], temp, 31, banTime, 31, g_menuUnBanText[id][b], 31) != 3)
                disable = 1
            else if((type == 1 && !checkIP(g_menuUnBanText[id][b])) || (type == 0 && !checkSTEAMID(g_menuUnBanText[id][b])))
                disable = 1
            if(disable == 0) {
                keys |= (1<<b)
                if(g_coloredMenus)
                len += format(menuBody[len], 511-len, "%d. %s\R\r%s^n\w", b, g_menuUnBanText[id][b++], banTime)
                else
                len += format(menuBody[len], 511-len, "%d. %s   ( %s )^n", b, g_menuUnBanText[id][b++], banTime)
            }
            else {
                if(g_coloredMenus)
                    len += format(menuBody[len], 511-len, "\d%d. %s^n\w", b, g_menuUnBanText[id][b++])
                else
                    len += format(menuBody[len], 511-len, "#. %s^n", b, g_menuUnBanText[id][b++])
            }
            if(b == 8) break
        }

        if(b == 8 && read_file(g_bannedCfgFile[type], line, g_menuSelect[id], 63, textlen) > 0) {
        format(menuBody[len], 511-len, "^n9. More...^n0. %s",id, pos ? "Back" : "Exit",id)
        keys |= (1<<8)
        }
        else
        format(menuBody[len], 511-len, "^n0. %s", pos ? "Back" : "Exit",id)

        g_menuUnBanLine[id][1] = line - g_menuUnBanLine[id][0]
        g_menuUnBanLine[id][0] = line
        show_menu(id, keys, menuBody, -1, "UnBan  Menu")
    }

    return
}

public actionUnBanMenuType(id,key) {

    switch(key) {
        case 9: return PLUGIN_HANDLED
        default: {
            g_menuUnBanType[id] = key // 0 = STEAMID, 1 = IP
            g_menuUnBanLine[id][0] = g_menuUnBanLine[id][1] = 0
            displayUnBanMenu(id, g_menuPosition[id] = 0)
        }
    }
    return PLUGIN_HANDLED
}

displayUnBanMenuType(id) {

    new menuBody[512]

    new len = format(menuBody, 511, g_coloredMenus ?  "\yUnBan STEAMID or IP?^n\w^n" :"UnBan STEAMID or IP?^n^n",id)

    new keys = (1<<0)|(1<<1)|(1<<9)

    len += format(menuBody[len], 511-len, "1. STEAMID^n",id)
    len += format(menuBody[len], 511-len, "2. IP^n",id)
    format(menuBody[len], 511-len, "^n0. Exit",id)

    show_menu(id, keys, menuBody, -1, "UnBan STEAMID or IP?")
}

public cmdUnBanMenu(id,level,cid) {

    if(!cmd_access(id,level,cid,1))
    return PLUGIN_HANDLED

    g_menuUnBanType[id] = -1
    displayUnBanMenuType(id)
    return PLUGIN_HANDLED
}

public aim_prac(id)
{
    if (id && !((get_user_flags(id) & ADMIN_LEVEL_A)))
    {
        client_print(id, print_console, "%s O Komutu Kullanamazsin.",szStag)
        return PLUGIN_CONTINUE
    }
    new arg[8]
    read_argv(1, arg, 7)

    if((equali(arg, "on"))||(equali(arg, "1")))
    {
        set_user_hitzones(0 ,0, 2)
        hsolayi = true
    }
    else
    {
        set_user_hitzones(0, 0, 255)
        hsolayi = false
    }
    return PLUGIN_HANDLED
}

public cmdHs (id, level, cid){

    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED;

    if(hsolayi == true) {
        server_cmd ("aim_prac 0")
        chat_color(0,"%s Hs Mod Kapatildi.",szStag)
    }
    else if(hsolayi == false) {
        server_cmd ("aim_prac 1")
        chat_color(0,"%s Hs Mod Acildi.",szStag)
    }
    return PLUGIN_HANDLED;
}


public CmdKickT( iPlayer, iLevel, iCId ) {
    if( !cmd_access( iPlayer, iLevel, iCId, 1 ) ) {
        return PLUGIN_HANDLED;
    }

    new iPlayers[ 32 ], iNum;
    get_players( iPlayers, iNum );

    new iVictim;
    for( new i = 0; i < iNum; i++ ) {
        iVictim = iPlayers[ i ];
        if( cs_get_user_team( iVictim ) == CS_TEAM_T ) {
            server_cmd( "kick #%i", get_user_userid( iVictim ) );
        }
    }

    new szName[ 32 ];
    get_user_name( iPlayer, szName, 31 );

    chat_color(0,"%s Terorists Takimi Kicklendi.",szStag)

    return PLUGIN_HANDLED;
}

public CmdKickCT( iPlayer, iLevel, iCId ) {
    if( !cmd_access( iPlayer, iLevel, iCId, 1 ) ) {
        return PLUGIN_HANDLED;
    }

    new iPlayers[ 32 ], iNum;
    get_players( iPlayers, iNum );

    new iVictim;
    for( new i = 0; i < iNum; i++ ) {
        iVictim = iPlayers[ i ];
        if( cs_get_user_team( iVictim ) == CS_TEAM_CT ) {
            server_cmd( "kick #%i", get_user_userid( iVictim ) );
        }
    }

    new szName[ 32 ];
    get_user_name( iPlayer, szName, 31 );

    chat_color(0,"%s Counter-Terorists Takimi Kicklendi.",szStag)


    return PLUGIN_HANDLED;
}

public CmdKickSpec( iPlayer, iLevel, iCId ) {
    if( !cmd_access( iPlayer, iLevel, iCId, 1 ) ) {
        return PLUGIN_HANDLED;
    }

    new iPlayers[ 32 ], iNum;
    get_players( iPlayers, iNum );

    new iVictim;
    for( new i = 0; i < iNum; i++ ) {
        iVictim = iPlayers[ i ];
        if( cs_get_user_team( iVictim ) == CS_TEAM_SPECTATOR ) {
            server_cmd( "kick #%i", get_user_userid( iVictim ) );
        }
    }

    new szName[ 32 ];
    get_user_name( iPlayer, szName, 31 );

    chat_color(0,"%s Spectator Takimi Kicklendi.",szStag)


    return PLUGIN_HANDLED;
}

public CmdKickAll( iPlayer, iLevel, iCId ) {
    if( !cmd_access( iPlayer, iLevel, iCId, 1 ) ) {
        return PLUGIN_HANDLED;
    }

    new iPlayers[ 32 ], iNum;
    get_players( iPlayers, iNum );

    for( new i = 0; i < iNum; i++ ) {
        server_cmd( "kick #%i", get_user_userid( iPlayers[ i ] ) );
    }

    return PLUGIN_HANDLED;
}

public cmdMapRes (id, level, cid){

    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED;

    server_cmd("restart");

    chat_color(0,"%s Harita Yeniden Aciliyor.",szStag)


    return PLUGIN_HANDLED;
}

public cmdRastgeleSifre (id, level, cid){

    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED;

    rastgelesifre()

    chat_color(id,"%s Hakem tarafindan yeni server password girildi. [Bireysel Gozuken Mesaj]",szStag)


    return PLUGIN_HANDLED;
}

public rastgelesifre(){
    new sans = random_num(1,26)
    switch(sans)
    {
        case 1: {
            server_cmd("sv_password 872")
        }
        case 2: {
            server_cmd("sv_password 681")
        }
        case 3: {
            server_cmd("sv_password 667")
        }
        case 4: {
            server_cmd("sv_password 015")
        }
        case 5: {
            server_cmd("sv_password 670")
        }
        case 6: {
            server_cmd("sv_password 982")
        }
        case 7: {
            server_cmd("sv_password 248")
        }
        case 8: {
            server_cmd("sv_password 682")
        }
        case 9: {
            server_cmd("sv_password 150")
        }
        case 10: {
            server_cmd("sv_password 358")
        }
        case 11: {
            server_cmd("sv_password 358")
        }
        case 12: {
            server_cmd("sv_password 123")
        }
        case 13: {
            server_cmd("sv_password 682")
        }
        case 14: {
            server_cmd("sv_password 427")
        }
        case 15: {
            server_cmd("sv_password 352")
        }
        case 16: {
            server_cmd("sv_password 063")
        }
        case 17: {
            server_cmd("sv_password 360")
        }
        case 18: {
            server_cmd("sv_password 365")
        }
        case 19: {
            server_cmd("sv_password 366")
        }
        case 20: {
            server_cmd("sv_password 728")
        }
        case 21: {
            server_cmd("sv_password 118")
        }
        case 22: {
            server_cmd("sv_password 155")
        }
        case 23: {
            server_cmd("sv_password 318")
        }
        case 24: {
            server_cmd("sv_password 831")
        }
        case 25: {
            server_cmd("sv_password 925")
        }
        case 26: {
            server_cmd("sv_password 481")
        }
    }
    new pass[32]
    get_cvar_string("sv_password",pass,sizeof(pass) - 1)
    client_cmd(0,"password ^"%s^"",pass)
}

public cmdKFsay(id,level,cid) {

    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED

    if(get_pcvar_num(g_kfmodu) == 0) {
        set_pcvar_num(g_kfmodu,1)
        chat_color(id,"%s KFRound BO1 Olarak Ayarlandi.",szStag)
    }
    else if(get_pcvar_num(g_kfmodu) == 1) {
        set_pcvar_num(g_kfmodu,2)
        chat_color(id,"%s KFRound BO3 Olarak Ayarlandi.",szStag)
    }
    else if(get_pcvar_num(g_kfmodu) == 2) {
        set_pcvar_num(g_kfmodu,3)
        chat_color(id,"%s KFRound BO5 Olarak Ayarlandi.",szStag)
    }
    else if(get_pcvar_num(g_kfmodu) == 3) {
        set_pcvar_num(g_kfmodu,0)
        chat_color(id,"%s KF Takim Secmeli Olarak Ayarlandi.",szStag)
    }
    return PLUGIN_HANDLED
}

public cmdbo5(id,level,cid) {

    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED

    set_pcvar_num(g_kfmodu,3)
    server_cmd( "sv_restartround 3" );
    set_pcvar_num(g_ready,0)
    set_task( 1.9, "KnifeRoundStart", id );
    new players[ 32 ], num;
    get_players( players, num );
    for( new i = 0; i < num ; i++ )
    {
        new item = players[ i ];
        EventCurWeapon( item );
        numaraata(item)
    }
    set_cvar_string("csm_respawn", "0");
    set_cvar_string("mp_freezetime", "7");
    chat_color(id,"%s KFRound BO5 olarak baslatildi.",szStag)

    return PLUGIN_HANDLED
}

public cmdbo3(id,level,cid) {

    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED

    set_pcvar_num(g_kfmodu,2)
    server_cmd( "sv_restartround 3" );
    set_pcvar_num(g_ready,0)
    set_task( 1.9, "KnifeRoundStart", id );
    new players[ 32 ], num;
    get_players( players, num );
    for( new i = 0; i < num ; i++ )
    {
        new item = players[ i ];
        EventCurWeapon( item );
        numaraata(item)
    }
    set_cvar_string("csm_respawn", "0");
    set_cvar_string("mp_freezetime", "7");
    chat_color(id,"%s KFRound BO3 olarak baslatildi.",szStag)

    return PLUGIN_HANDLED
}

public cmdbo1(id,level,cid) {

    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED

    set_pcvar_num(g_kfmodu,1)
    server_cmd( "sv_restartround 3" );
    set_pcvar_num(g_ready,0)
    set_task( 1.9, "KnifeRoundStart", id );
    new players[ 32 ], num;
    get_players( players, num );
    for( new i = 0; i < num ; i++ )
    {
        new item = players[ i ];
        EventCurWeapon( item );
        numaraata(item)
    }
    set_cvar_string("csm_respawn", "0");
    set_cvar_string("mp_freezetime", "7");
    chat_color(id,"%s KFRound BO1 olarak baslatildi.",szStag)

    return PLUGIN_HANDLED
}

public cmdParaGoster(id)
{
    new oyuncuad[32]
    get_user_name(id,oyuncuad,31)
    new players[32], num
    get_players(players, num)
    new player
    for(new i = 0; i < num; i++)
    {
        player = players[i]

        if(cs_get_user_team(id) == CS_TEAM_T)
        {
            if(cs_get_user_team(player) == CS_TEAM_T){
                chat_colorrenkli(player,"!y(Terrorist) !t%s!y : %d$", oyuncuad, cs_get_user_money(id))
            }
        }
        else if(cs_get_user_team(id) == CS_TEAM_CT)
        {
            if(cs_get_user_team(player) == CS_TEAM_CT){
                chat_colorrenkli(player,"!y(Counter-Terrorist) !t%s!y : %d$", oyuncuad, cs_get_user_money(id))
            }
        }
    }
    return PLUGIN_HANDLED;
}



public show_moneyTE()
{
    static message[1024];
    static name[32];

    new money, id, len;

    len = format(message, charsmax(message), "TE TAKIMININ PARASI:^n");

    for (id = 1; id <= g_iMaxPlayers; id++)
    {
        if (is_user_connected(id) && cs_get_user_team(id) == CS_TEAM_T)
        {
            money = cs_get_user_money(id);
            get_user_name(id, name, 31);
            len += format(message[len], charsmax(message) - len, "%-22.22s: %d$^n", name, money);
        }


    }
    for(new i = 1; i <= 32; i++) {
        if(get_user_team(i) == 3){
            //set_hudmessage(100, 200, 0, 0.05, 0.35, 0, 0.02, 5.0, 0.1, 0.2, 12);
            set_hudmessage(100, 200, 0, 0.05, 0.35, 0, 6.0, 12.0)
            ShowSyncHudMsg(i, g_sync_creat_list, message);
        }
    }
}

public show_moneyCT()
{
    static message[1024];
    static name[32];

    new money, id, len;

    len = format(message, charsmax(message), "CT TAKIMININ PARASI:^n");

    for (id = 1; id <= g_iMaxPlayers; id++)
    {
        if (is_user_connected(id) && cs_get_user_team(id) == CS_TEAM_CT)
        {
            money = cs_get_user_money(id);
            get_user_name(id, name, 31);
            len += format(message[len], charsmax(message) - len, "%-22.22s: %d$^n", name, money);
        }
    }
    for(new i = 1; i <= 32; i++) {
        if(get_user_team(i) == 3){
            //set_hudmessage(100, 200, 0, 0.75, 0.35, 0, 0.02, 5.0, 0.1, 0.2, 12);
            set_hudmessage(100, 200, 0, 0.75, 0.35, 0, 6.0, 12.0)
            ShowSyncHudMsg(i, g_sync_creat_list2, message);
        }
    }
}

public speceskoryazdir(){
    if( mac == true ) {
        for(new i = 1; i <= 32; i++) {
            if(get_user_team(i) == 3){
                if(!mitad){
                    set_hudmessage(255, 255, 255, -1.0, 0.0, 0, 6.0, 12.0)
                    show_hudmessage(i, "| El: %d | Harita: %s |^n|[TE:%i] | [CT:%i]|", rounds_elapsed, mapname ,tt_win, ct_win);
                }
                else if (mitad) {
                    if(uzatmalar == true){
                        set_hudmessage(255, 255, 255, -1.0, 0.0, 0, 6.0, 12.0)
                        show_hudmessage(i, "| El: %d | Harita: %s |^n|[TE:%i] | [CT:%i]|", uzatmatoplamct+uzatmatoplamte+1, mapname ,uzatmatoplamte,uzatmatoplamct);
                    }
                    else if(uzatmalar == false){
                        set_hudmessage(255, 255, 255, -1.0, 0.0, 0, 6.0, 12.0)
                        show_hudmessage(i, "| El: %d | Harita: %s |^n|[TE:%i] | [CT:%i]|", rounds_elapsed+15, mapname ,tt_win + totalTT,ct_win + totalCT);
                    }
                }
            }
        }
    }

}

public cmdSifirla(id){
    set_cvar_string("csm_kfmodu", "0");
    set_cvar_string("csm_kfmodubuocaktif", "0");
    set_cvar_string("csm_birinciharita", "YOK");
    set_cvar_string("csm_ikinciharita", "YOK");
    set_cvar_string("csm_ucuncuharita", "YOK");
    set_cvar_string("csm_dorduncuharita", "YOK");
    set_cvar_string("csm_besinciharita", "YOK");
    get_pcvar_string(birinciharita,birinciharitacevir,31)
    get_pcvar_string(ikinciharita,ikinciharitacevir,31)
    get_pcvar_string(ucuncuharita,ucuncuharitacevir,31)
    get_pcvar_string(dorduncuharita,dorduncuharitacevir,31)
    get_pcvar_string(besinciharita,besinciharitacevir,31)
    set_cvar_string("csm_birinciharita", birinciharitacevir);
    set_cvar_string("csm_ikinciharita", ikinciharitacevir);
    set_cvar_string("csm_ucuncuharita", ucuncuharitacevir);
    set_cvar_string("csm_dorduncuharita", dorduncuharitacevir);
    set_cvar_string("csm_besinciharita", besinciharitacevir);

    server_cmd("csm_takimB TeamB")
    get_pcvar_string(TakimB,TakimBcevir,31)
    set_cvar_string("csm_TakimB", TakimBcevir);
    server_cmd("csm_takimA TeamA")
    get_pcvar_string(TakimA,TakimAcevir,31)
    set_cvar_string("csm_TakimA", TakimAcevir);

    set_task(0.5,"cmdSifirlaTekrar",id)

    delete_file(cmdfile)
    for(new i = 1; i < 33; i++){
        if(kf_kaptan[i] == 1){
            kf_kaptan[i] = 0
        }
    }
    ReadFile( )
    set_pcvar_num(g_ready,0)
    client_cmd(id, "macmenu")


    return PLUGIN_HANDLED;
}
public cmdSifirlaTekrar(id){
    set_cvar_string("csm_birinciharita", "YOK");
    set_cvar_string("csm_ikinciharita", "YOK");
    set_cvar_string("csm_ucuncuharita", "YOK");
    set_cvar_string("csm_dorduncuharita", "YOK");
    set_cvar_string("csm_besinciharita", "YOK");
    get_pcvar_string(birinciharita,birinciharitacevir,31)
    get_pcvar_string(ikinciharita,ikinciharitacevir,31)
    get_pcvar_string(ucuncuharita,ucuncuharitacevir,31)
    get_pcvar_string(dorduncuharita,dorduncuharitacevir,31)
    get_pcvar_string(besinciharita,besinciharitacevir,31)
    set_cvar_string("csm_birinciharita", birinciharitacevir);
    set_cvar_string("csm_ikinciharita", ikinciharitacevir);
    set_cvar_string("csm_ucuncuharita", ucuncuharitacevir);
    set_cvar_string("csm_dorduncuharita", dorduncuharitacevir);
    set_cvar_string("csm_besinciharita", besinciharitacevir);
    server_cmd("csm_takimB TeamB")
    get_pcvar_string(TakimB,TakimBcevir,31)
    set_cvar_string("csm_TakimB", TakimBcevir);
    server_cmd("csm_takimA TeamA")
    get_pcvar_string(TakimA,TakimAcevir,31)
    set_cvar_string("csm_TakimA", TakimAcevir);
    client_cmd(id, "macmenu")
    chat_color(0,"%s Hakem mac botu ayarlarini sifirladi.",szStag);
}

public cmdMacBitir(id, level, cid){

    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED;

    if (mac == true ) {
        rounds_elapsed = 0;
        tt_win = 0
        ct_win = 0
        total = 0
        totalCT = 0
        totalTT = 0
        mac = false
        set_cvar_string("mp_autokick", "0");
        set_cvar_string("mp_freezetime", "0");
        set_cvar_string("mp_autoteambalance", "0");
        set_cvar_string("mp_limitteams", "0");
        set_cvar_string("mp_friendlyfire", "0");
        set_cvar_string("mp_timelimit", "0");
        set_cvar_string("mp_forcecamera", "0");
        set_cvar_string("mp_forcechasecam", "0");
        set_cvar_string("mp_flashlight", "1");
        set_cvar_string("mp_tkpunish", "0");
        set_cvar_string("mp_c4timer", "35");
        set_cvar_string("mp_roundtime", "3");
        set_cvar_string("mp_footsteps", "1");
        set_cvar_string("mp_buytime", "3");
        server_cmd ("aim_prac 0");
        hsolayi = false;
        set_cvar_string("csm_teamlock", "0");
        set_cvar_string("csm_nosay", "0");
        chat_color(0,"%s Mac bitirme komutu kullanildi...",szStag)
        client_cmd(id,"say .pub");
        set_pcvar_string(g_pPasswordPointer, "")
        chat_color(0,"%s Server Sifresi !tKaldirildi.",szStag)
        dusme = false

    }
    else if (mac == false) {
        chat_color(id,"%s Mac Bulunamadi...",szStag)
    }
    return PLUGIN_HANDLED;
}

public cmdMacBitir2(id){

    rounds_elapsed = 0;
    tt_win = 0
    ct_win = 0
    total = 0
    totalCT = 0
    totalTT = 0
    mac = false
    set_cvar_string("mp_autokick", "0");
    set_cvar_string("mp_freezetime", "0");
    set_cvar_string("mp_autoteambalance", "0");
    set_cvar_string("mp_limitteams", "0");
    set_cvar_string("mp_friendlyfire", "0");
    set_cvar_string("mp_timelimit", "0");
    set_cvar_string("mp_forcecamera", "0");
    set_cvar_string("mp_forcechasecam", "0");
    set_cvar_string("mp_flashlight", "1");
    set_cvar_string("mp_tkpunish", "0");
    set_cvar_string("mp_c4timer", "35");
    set_cvar_string("mp_roundtime", "3");
    set_cvar_string("mp_footsteps", "1");
    set_cvar_string("mp_buytime", "3");
    set_cvar_string("mp_startmoney", "16000");
    server_cmd ("aim_prac 0");
    hsolayi = false;
    set_cvar_string("csm_teamlock", "0");
    set_cvar_string("csm_nosay", "0");
    //chat_color(0,"%s Mac bitirme komutu kullanildi...",szStag)
    //client_cmd(id,"say .pub");
    set_pcvar_string(g_pPasswordPointer, "")
    //chat_color(0,"%s Server Sifresi Kaldirildi.",szStag)
    dusme = false

    return PLUGIN_HANDLED;
}

public cmdTeamLock(id,level,cid) {

    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED

    if(get_pcvar_num(g_teamlock) == 0 && set_pcvar_num(g_teamlock,1)) {

    pasarse = true
    chat_color(0,"%s Takim Degistirme Kapatildi.",szStag)
    }
    else if(get_pcvar_num(g_teamlock) == 1 && set_pcvar_num(g_teamlock,0))

    chat_color(0,"%s Takim Degistirme Acildi.",szStag)

    return PLUGIN_HANDLED
}


public frag_part2(id[]) client_cmd(id[0],"snapshot")

public frag_part3(id[]) client_cmd(id[0],"-showscores")

public frag_part1(id) {
    client_cmd(id,"+showscores");
    chat_color(id,"%s Frag Kaydedildi. cstrike/..",szStag)
    set_task(0.3,"frag_part2",0);
    set_task(0.6,"frag_part3",0);

    return PLUGIN_HANDLED;
}

public durum(id){
    //new ff[32],alltalk[32],sxe[32]

    //if(get_cvar_num("mp_friendlyfire") == 1){
    //  format(ff,31,"Acik")
    //}
    //else{
    //  format(ff,31,"Kapali")
    //}

    //if(get_cvar_num("sv_alltalk") == 1){
    //  format(alltalk,31,"Acik")
    //}
    //else{
    //  format(alltalk,31,"Kapali")
    //}

    //if(get_cvar_num("__sxei_required") == -1){
    //  format(sxe,31,"Kapali")
    //}
    //if(get_cvar_num("__sxei_required") == 0){
    //  format(sxe,31,"Opsiyonel")
    //}
    //if(get_cvar_num("__sxei_required") == 1){
    //  format(sxe,31,"Acik")
    //}

    //chat_color(id,"!gFriendly Fire !y: !t%s !y| !gAlltalk !y: !t%s !y| !gSxe !y: !t%s",ff,alltalk,sxe)

    if(get_pcvar_num(g_kfmoduboucaktif) == 1) {
        BobesHaritalariSoyle(id);
    }
    if(get_pcvar_num(g_kfmoduboucaktif) == 2) {
        BobesHaritalariSoyle(id);
    }
}


// KF

public teleport( id ) {
    new szMapName[ 32 ], iCTOrigin[ 3 ], iTOrigin[ 3 ];
    get_mapname( szMapName, charsmax( szMapName ) );

    if( equali( szMapName, "de_dust2" ) ) //sorunsuz
    {
        switch(kisinindegeriT[id]){
            case 1: {
                iTOrigin = { 1344, 1197, 36 };set_user_origin( id, iTOrigin );
            }
            case 2: {
                iTOrigin = { 1404, 1203, 36 };set_user_origin( id, iTOrigin );
            }
            case 3: {
                iTOrigin = { 1452, 1206, 36 };set_user_origin( id, iTOrigin );
            }
            case 4: {
                iTOrigin = { 1494, 1210, 36 };set_user_origin( id, iTOrigin );
            }
            case 5: {
                iTOrigin = { 1546, 1189, 95 };set_user_origin( id, iTOrigin );
            }
        }
        switch(kisinindegeriCT[id]){
            case 1: {
                iCTOrigin = { 1340, 2061, 108 };set_user_origin( id, iCTOrigin );
            }
            case 2: {
                iCTOrigin = { 1388, 2054, 108 };set_user_origin( id, iCTOrigin );
            }
            case 3: {
                iCTOrigin = { 1439, 2051, 108 };set_user_origin( id, iCTOrigin );
            }
            case 4: {
                iCTOrigin = { 1478, 2053, 108 };set_user_origin( id, iCTOrigin );
            }
            case 5: {
                iCTOrigin = { 1528, 2060, 108 };set_user_origin( id, iCTOrigin );
            }
        }
    }
    if( equali( szMapName, "de_train" ) ) //sorunsuz
    {
        switch(kisinindegeriT[id]){
            case 1: {
                iTOrigin = { 1240, 400, -187 };set_user_origin( id, iTOrigin );
            }
            case 2: {
                iTOrigin = { 1240, 448, -187 };set_user_origin( id, iTOrigin );
            }
            case 3: {
                iTOrigin = { 1240, 488, -187 };set_user_origin( id, iTOrigin );
            }
            case 4: {
                iTOrigin = { 1240, 519, -187 };set_user_origin( id, iTOrigin );
            }
            case 5: {
                iTOrigin = { 1240, 575, -187 };set_user_origin( id, iTOrigin );
            }
        }
        switch(kisinindegeriCT[id]){
            case 1: {
                iCTOrigin = { 1894, 400, -187 };set_user_origin( id, iCTOrigin );
            }
            case 2: {
                iCTOrigin = { 1894, 448, -187 };set_user_origin( id, iCTOrigin );
            }
            case 3: {
                iCTOrigin = { 1894, 488, -187 };set_user_origin( id, iCTOrigin );
            }
            case 4: {
                iCTOrigin = { 1894, 519, -187 };set_user_origin( id, iCTOrigin );
            }
            case 5: {
                iCTOrigin = { 1894, 575, -187 };set_user_origin( id, iCTOrigin );
            }
        }
    }
    if( equali( szMapName, "de_tuscan" ) ) // Sorunsuz
    {
        switch(kisinindegeriT[id]){
            case 1: {
                iTOrigin = { 789, 318, 170 };set_user_origin( id, iTOrigin );
            }
            case 2: {
                iTOrigin = { 789, 369, 170 };set_user_origin( id, iTOrigin );
            }
            case 3: {
                iTOrigin = { 788, 427, 170 };set_user_origin( id, iTOrigin );
            }
            case 4: {
                iTOrigin = { 788, 473, 170 };set_user_origin( id, iTOrigin );
            }
            case 5: {
                iTOrigin = { 788, 532, 170 };set_user_origin( id, iTOrigin );
            }
        }
        switch(kisinindegeriCT[id]){
            case 1: {
                iCTOrigin = { 1173, 308, 157 };set_user_origin( id, iCTOrigin );
            }
            case 2: {
                iCTOrigin = { 1173, 352, 157 };set_user_origin( id, iCTOrigin );
            }
            case 3: {
                iCTOrigin = { 1173, 403, 157 };set_user_origin( id, iCTOrigin );
            }
            case 4: {
                iCTOrigin = { 1175, 454, 157 };set_user_origin( id, iCTOrigin );
            }
            case 5: {
                iCTOrigin = { 1177, 506, 157 };set_user_origin( id, iCTOrigin );
            }
        }
    }
    if( equali( szMapName, "de_mirage" ) ) //sorunsuz
    {
        switch(kisinindegeriCT[id]){
            case 1: {
                iCTOrigin = { -927, -926, 36 };set_user_origin( id, iCTOrigin );
            }
            case 2: {
                iCTOrigin = { -927, -884, 36 };set_user_origin( id, iCTOrigin );
            }
            case 3: {
                iCTOrigin = { -927, -849, 36 };set_user_origin( id, iCTOrigin );
            }
            case 4: {
                iCTOrigin = { -927, -817, 36 };set_user_origin( id, iCTOrigin );
            }
            case 5: {
                iCTOrigin = { -927, -777, 36 };set_user_origin( id, iCTOrigin );
            }
        }
        switch(kisinindegeriT[id]){
            case 1: {
                iTOrigin = { -492, -770, 36 };set_user_origin( id, iTOrigin );
            }
            case 2: {
                iTOrigin = { -492, -815, 36 };set_user_origin( id, iTOrigin );
            }
            case 3: {
                iTOrigin = { -492, -852, 36 };set_user_origin( id, iTOrigin );
            }
            case 4: {
                iTOrigin = { -492, -882, 36 };set_user_origin( id, iTOrigin );
            }
            case 5: {
                iTOrigin = { -492, -912, 36 };set_user_origin( id, iTOrigin );
            }
        }
    }

    if( equali( szMapName, "de_nuke" ) ) //sorunsuz
    {
        switch(kisinindegeriCT[id]){
            case 1: {
                iCTOrigin = { 1278, -1813, -379 };set_user_origin( id, iCTOrigin );
            }
            case 2: {
                iCTOrigin = { 1278, -1874, -379 };set_user_origin( id, iCTOrigin );
            }
            case 3: {
                iCTOrigin = { 1278, -1920, -379 };set_user_origin( id, iCTOrigin );
            }
            case 4: {
                iCTOrigin = { 1278, -1965, -379 };set_user_origin( id, iCTOrigin );
            }
            case 5: {
                iCTOrigin = { 1278, -2019, -379 };set_user_origin( id, iCTOrigin );
            }
        }
        switch(kisinindegeriT[id]){
            case 1: {
                iTOrigin = { 731, -2056, -379 };set_user_origin( id, iTOrigin );
            }
            case 2: {
                iTOrigin = { 738, -2015, -379 };set_user_origin( id, iTOrigin );
            }
            case 3: {
                iTOrigin = { 747, -1961, -379 };set_user_origin( id, iTOrigin );
            }
            case 4: {
                iTOrigin = { 756, -1901, -379 };set_user_origin( id, iTOrigin );
            }
            case 5: {
                iTOrigin = { 764, -1857, -379 };set_user_origin( id, iTOrigin );
            }
        }
    }

    if( equali( szMapName, "de_inferno" ) ) //sorunsuz ama yanlýþ yer
    {
        switch(kisinindegeriT[id]){
            case 1: {
                iTOrigin = { 733, -220, 204 };set_user_origin( id, iTOrigin );
            }
            case 2: {
                iTOrigin = { 775, -225, 204 };set_user_origin( id, iTOrigin );
            }
            case 3: {
                iTOrigin = { 814, -229, 204 };set_user_origin( id, iTOrigin );
            }
            case 4: {
                iTOrigin = { 865, -228, 204 };set_user_origin( id, iTOrigin );
            }
            case 5: {
                iTOrigin = { 920, -222, 220 };set_user_origin( id, iTOrigin );
            }
        }
        switch(kisinindegeriCT[id]){
            case 1: {
                iCTOrigin = { 725, 406, 204 };set_user_origin( id, iCTOrigin );
            }
            case 2: {
                iCTOrigin = { 770, 409, 204 };set_user_origin( id, iCTOrigin );
            }
            case 3: {
                iCTOrigin = { 817, 402, 204 };set_user_origin( id, iCTOrigin );
            }
            case 4: {
                iCTOrigin = { 855, 401, 204 };set_user_origin( id, iCTOrigin );
            }
            case 5: {
                iCTOrigin = { 911, 405, 220 };set_user_origin( id, iCTOrigin );
            }
        }
    }
    if( equali( szMapName, "de_forge" ) ) //sorunsuz
    {
        switch(kisinindegeriT[id]){
            case 1: {
                iTOrigin = { 2449, 193, 179 };set_user_origin( id, iTOrigin );
            }
            case 2: {
                iTOrigin = { 2370, 191, 179 };set_user_origin( id, iTOrigin );
            }
            case 3: {
                iTOrigin = { 2287, 189, 179 };set_user_origin( id, iTOrigin );
            }
            case 4: {
                iTOrigin = { 2215, 187, 179 };set_user_origin( id, iTOrigin );
            }
            case 5: {
                iTOrigin = { 2120, 185, 179 };set_user_origin( id, iTOrigin );
            }
        }
        switch(kisinindegeriCT[id]){
            case 1: {
                iCTOrigin = { 2136, 912, 167 };set_user_origin( id, iCTOrigin );
            }
            case 2: {
                iCTOrigin = { 2210, 914, 167 };set_user_origin( id, iCTOrigin );
            }
            case 3: {
                iCTOrigin = { 2294, 916, 167 };set_user_origin( id, iCTOrigin );
            }
            case 4: {
                iCTOrigin = { 2372, 918, 167 };set_user_origin( id, iCTOrigin );
            }
            case 5: {
                iCTOrigin = { 2446, 919, 167 };set_user_origin( id, iCTOrigin );
            }
        }
    }

}

public EventCurWeapon( id ) {
    if( g_bKnifeRound ) engclient_cmd( id, "weapon_knife" );
    return PLUGIN_CONTINUE;
}

public CmdRestartRound( id, level, cid ) {
    if ( !cmd_access( id, level, cid, 1 ) ) return PLUGIN_HANDLED;

    g_bKnifeRound = false;
    server_cmd( "sv_restartround 1" );

    return PLUGIN_CONTINUE;
}

public CmdKnifeRound( id, level, cid ) {
    if( !cmd_access( id, level, cid, 1 ) ) return PLUGIN_HANDLED;

    set_pcvar_num(g_kfmodu,0)
    server_cmd( "sv_restartround 3" );
    set_pcvar_num(g_ready,0)
    set_task( 1.9, "KnifeRoundStart", id );
    new players[ 32 ], num;
    get_players( players, num );
    for( new i = 0; i < num ; i++ )
    {
        new item = players[ i ];
        EventCurWeapon( item );
        numaraata(item)
    }
    set_cvar_string("csm_respawn", "0");
    set_cvar_string("mp_freezetime", "7");
    chat_color(id,"%s KFRound Takim Secmeli olarak baslatildi.",szStag)

    return PLUGIN_HANDLED
}

public CmdSwapTeams( id,level,cid ) {
    if( !cmd_access( id, level, cid, 1 ) ) return PLUGIN_HANDLED;

    SwapTeams( );
    CmdRestartRound( id, level, cid );

    return PLUGIN_CONTINUE;
}

public KnifeRoundStart( ) {
    g_bKnifeRound = true;
    g_bVotingProcess = false;

    return PLUGIN_CONTINUE;
}
public numaraata(id) {
    if( cs_get_user_team(id) == CS_TEAM_CT ){
        if(csmilefacetpyeriCT == 1){
            kisinindegeriCT[id] = 1
            kisinindegeriT[id] = 0
            csmilefacetpyeriCT = 2
        }
        else if(csmilefacetpyeriCT == 2){
            kisinindegeriCT[id] = 2
            kisinindegeriT[id] = 0
            csmilefacetpyeriCT = 3
        }
        else if(csmilefacetpyeriCT == 3){
            kisinindegeriCT[id] = 3
            kisinindegeriT[id] = 0
            csmilefacetpyeriCT = 4
        }
        else if(csmilefacetpyeriCT == 4){
            kisinindegeriCT[id] = 4
            kisinindegeriT[id] = 0
            csmilefacetpyeriCT = 5
        }
        else if(csmilefacetpyeriCT == 5){
            kisinindegeriCT[id] = 5
            kisinindegeriT[id] = 0
            csmilefacetpyeriCT = 1
        }
    }
    if( cs_get_user_team(id) == CS_TEAM_T ){
        if(csmilefacetpyeriT == 1){
            kisinindegeriT[id] = 1
            kisinindegeriCT[id] = 0
            csmilefacetpyeriT = 2
        }
        else if(csmilefacetpyeriT == 2){
            kisinindegeriT[id] = 2
            kisinindegeriCT[id] = 0
            csmilefacetpyeriT = 3
        }
        else if(csmilefacetpyeriT == 3){
            kisinindegeriT[id] = 3
            kisinindegeriCT[id] = 0
            csmilefacetpyeriT = 4
        }
        else if(csmilefacetpyeriT == 4){
            kisinindegeriT[id] = 4
            kisinindegeriCT[id] = 0
            csmilefacetpyeriT = 5
        }
        else if(csmilefacetpyeriT == 5){
            kisinindegeriT[id] = 5
            kisinindegeriCT[id] = 0
            csmilefacetpyeriT = 1
        }
    }
}
public SwapTeams( ) {
    for( new i = 1; i <= g_iMaxPlayers; i++ ) {
        if( is_user_connected( i ) )
        {
            switch( cs_get_user_team( i ) )
            {
                case CS_TEAM_T: cs_set_user_team( i, CS_TEAM_CT );
                case CS_TEAM_CT: cs_set_user_team( i, CS_TEAM_T );
            }
        }
    }
}

public EventRoundEnd( ) {
    if( g_bKnifeRound && get_pcvar_num( g_pSwapVote ) ) {
        new players[ 32 ], num;
        get_players( players, num, "ae", "TERRORIST" );

        if(!num)
        {
            if(get_pcvar_num(g_kfmodu) == 0) {
                chat_color(0,"%s Counter-Terrorists Simdi Kendi Arasinda Oylayacak!", szStag );
                csplugincomKF
                show_hudmessage(0, "Kazanan Counter-Terrorists Takimi")
                set_task( 6.0, "vote_ct" );
                for( new i = 1; i <= g_iMaxPlayers; i++ ) {
                    if( get_user_team( i ) == 1 ) {
                        chat_color(i,"%s Yapilan Oylamalari Takimin Goremez.", szStag );
                    }
                }
                set_cvar_string("mp_freezetime", "10");
            }
            else if((get_pcvar_num(g_kfmodu) == 1) || (get_pcvar_num(g_kfmodu) == 2) || (get_pcvar_num(g_kfmodu) == 3)){
                kf_takimsayac = 2
                kf_sayac = 0;
                banharitasecim=0;
                sprgoster = true;
                bandust=0;
                bantrain=0;
                bantuscan=0;
                banmirage=0;
                bannuke=0;
                baninferno=0;
                banforge=0;
                set_cvar_string("mp_freezetime", "60");
                for( new i = 1; i <= g_iMaxPlayers; i++ ) {
                    HaritaBanlama(i)
                    if(get_pcvar_num(g_otokaptan) == 1) {
                        if (kisinindegeriCT[i] == 1 || kisinindegeriT[i] == 1) {
                            kf_kaptan[i] = 1;
                            new oyuncuismi[32]
                            get_user_name(i , oyuncuismi , 31 )
                            chat_color(0,"!reklam %s Harita Banlama Sistemi icin kaptan olarak atandi.",oyuncuismi)
                        }
                    }
                }
            }
        }
        else
        {
            if(get_pcvar_num(g_kfmodu) == 0) {
                chat_color(0,"%s Terrorists Simdi Kendi Arasinda Oylayacak!", szStag );
                csplugincomKF
                show_hudmessage(0, "Kazanan Terrorists Takimi")
                set_task( 6.0, "vote_t" );
                for( new i = 1; i <= g_iMaxPlayers; i++ ) {
                    if( get_user_team( i ) == 2 ) {
                        chat_color(i,"%s Yapilan Oylamalari Takimin Goremez.", szStag );
                    }
                }
                set_cvar_string("mp_freezetime", "10");
            }
            else if((get_pcvar_num(g_kfmodu) == 1) || (get_pcvar_num(g_kfmodu) == 2) || (get_pcvar_num(g_kfmodu) == 3)){
                kf_takimsayac = 1
                kf_sayac = 0;
                banharitasecim=0;
                sprgoster = true;
                bandust=0;
                bantrain=0;
                bantuscan=0;
                banmirage=0;
                bannuke=0;
                baninferno=0;
                banforge=0;
                set_cvar_string("mp_freezetime", "60");
                for( new i = 1; i <= g_iMaxPlayers; i++ ) {
                    HaritaBanlama(i)
                    if(get_pcvar_num(g_otokaptan) == 1) {
                        if (kisinindegeriCT[i] == 1 || kisinindegeriT[i] == 1) {
                            kf_kaptan[i] = 1;
                            new oyuncuismi[32]
                            get_user_name(i , oyuncuismi , 31 )
                            chat_color(0,"!reklam %s Harita Banlama Sistemi icin kaptan olarak atandi.",oyuncuismi)
                        }
                    }
                }
            }
        }
        g_bKnifeRound = false;
    }

    return PLUGIN_CONTINUE;
}

public vote_t( ) {
    for( new i = 1; i <= g_iMaxPlayers; i++ ) {
        if( is_user_alive( i ) && cs_get_user_team( i ) == CS_TEAM_T )
        {
            ShowMenuKFTE( i );
        }
    }
    g_bKnifeRound = false;
    csplugincomKF
    show_hudmessage(0, "Oylamanin Bitmesine 10 Saniye")
    set_task( 1.0, "kfdokuz" );
}

public vote_ct( ) {
    for( new i = 1; i <= g_iMaxPlayers; i++ ) {
        if( is_user_alive( i ) && cs_get_user_team( i ) == CS_TEAM_CT )
        {
            ShowMenuKFCT( i );
        }
    }
    g_bKnifeRound = false;
    csplugincomKF
    show_hudmessage(0, "Oylamanin Bitmesine 10 Saniye")
    set_task( 1.0, "kfdokuz" );
}

public ShowMenuKFTE( id ) {
    g_bVotingProcess = true;

    if( g_bVotingProcess ) {
        new szMenuBody[ 256 ], keys;

        new nLen = format( szMenuBody, 255, "\rTakim Degisikligi?^n" );
        nLen += format( szMenuBody[nLen], 255-nLen, "^n\r1. \wEvet" );
        nLen += format( szMenuBody[nLen], 255-nLen, "^n\r2. \wHayir" );

        keys = ( 1<<0 | 1<<1 | 1<<9 );

        show_menu( id, keys, szMenuBody, -1 );
    }

    return PLUGIN_CONTINUE;
}

public MenuCommandTE( id, key ) {
    if( !g_bVotingProcess ) return PLUGIN_HANDLED;

    new szName[ 32 ];
    get_user_name( id, szName, charsmax( szName ) );
    for( new i = 1; i <= g_iMaxPlayers; i++ ) {
        if( is_user_alive( i ) && cs_get_user_team( i ) == CS_TEAM_T )
        {
            switch( key )
            {
                case 0:
                {
                    g_Votes[ 0 ]++;
                    chat_color(i,"%s %s evet dedi.", szStag, szName );
                }
                case 1:
                {
                    g_Votes[ 1 ]++;
                    chat_color(i,"%s %s hayir dedi.", szStag, szName );
                }
            }
        }
    }
    return PLUGIN_HANDLED;
}

public ShowMenuKFCT( id ) {
    g_bVotingProcess = true;

    if( g_bVotingProcess ) {
        new szMenuBody[ 256 ], keys;

        new nLen = format( szMenuBody, 255, "\bTakim Degisikligi?^n" );
        nLen += format( szMenuBody[nLen], 255-nLen, "^n\r1. \wEvet" );
        nLen += format( szMenuBody[nLen], 255-nLen, "^n\r2. \wHayir" );

        keys = ( 1<<0 | 1<<1 | 1<<9 );

        show_menu( id, keys, szMenuBody, -1 );
    }

    return PLUGIN_CONTINUE;
}

public MenuCommandCT( id, key ) {
    if( !g_bVotingProcess ) return PLUGIN_HANDLED;

    new szName[ 32 ];
    get_user_name( id, szName, charsmax( szName ) );
    for( new i = 1; i <= g_iMaxPlayers; i++ ) {
        if( is_user_alive( i ) && cs_get_user_team( i ) == CS_TEAM_CT )
        {
            switch( key )
            {
                case 0:
                {
                    g_Votes[ 0 ]++;
                    chat_color(i,"%s %s evet dedi.", szStag, szName );
                }
                case 1:
                {
                    g_Votes[ 1 ]++;
                    chat_color(i,"%s %s hayir dedi.", szStag, szName );
                }
            }
        }
    }
    return PLUGIN_HANDLED;
}

public finishvote( ) {
    if( !g_bVotingProcess ) return PLUGIN_HANDLED;

    server_cmd( "sv_restartround 1" );
    csplugincomKF
    show_hudmessage(0, "Oylamanin Bitmesine 0 Saniye^n Bundan Sonra Girilen Oylar Sayilmayacaktir!")
    remove_task()
    if ( g_Votes[ 0 ] > g_Votes[ 1 ] )
    {
        chat_color(0,"%s Kazanan takim kendi aralarinda oylama sonucu degistirilsin dedi.", szStag );
        SwapTeams( );
    }
    else
    {
        chat_color(0,"%s Kazanan takim kendi aralarinda oylama sonucu degistirilmesin dedi.", szStag );
    }
    set_task( 3.0, "readyac" );
    g_Votes[ 0 ] = 0;
    g_Votes[ 1 ] = 0;
    g_bVotingProcess = false;

    return PLUGIN_HANDLED;
}

public HamKnifePrimAttack( iEnt ) {
    if( g_bKnifeRound && get_pcvar_num( g_pNoslash ) )
    {
        ExecuteHamB( Ham_Weapon_SecondaryAttack, iEnt );
        return HAM_SUPERCEDE;
    }
    return HAM_IGNORED;
}

public BlockCmds( ) {
    if( g_bKnifeRound ) {
        return PLUGIN_HANDLED_MAIN;
    }
    return PLUGIN_CONTINUE;
}

public kfdokuz () {
    csplugincomKF
    show_hudmessage(0, "Oylamanin Bitmesine 9 Saniye")
    set_task( 1.0, "kfsekiz" );
}
public kfsekiz () {
    csplugincomKF
    show_hudmessage(0, "Oylamanin Bitmesine 8 Saniye")
    set_task( 1.0, "kfyedi" );
}
public kfyedi () {
    csplugincomKF
    show_hudmessage(0, "Oylamanin Bitmesine 7 Saniye")
    set_task( 1.0, "kfalti" );
}
public kfalti () {
    csplugincomKF
    show_hudmessage(0, "Oylamanin Bitmesine 6 Saniye")
    set_task( 1.0, "kfbes" );
}
public kfbes () {
    csplugincomKF
    show_hudmessage(0, "Oylamanin Bitmesine 5 Saniye")
    set_task( 1.0, "kfdort" );
}
public kfdort () {
    csplugincomKF
    show_hudmessage(0, "Oylamanin Bitmesine 4 Saniye")
    set_task( 1.0, "kfuc" );
}
public kfuc () {
    csplugincomKF
    show_hudmessage(0, "Oylamanin Bitmesine 3 Saniye")
    set_task( 1.0, "kfiki" );
}
public kfiki () {
    csplugincomKF
    show_hudmessage(0, "Oylamanin Bitmesine 2 Saniye")
    set_task( 1.0, "kfbir" );
}
public kfbir () {
    csplugincomKF
    show_hudmessage(0, "Oylamanin Bitmesine 1 Saniye")
    set_task( 1.0, "finishvote" );
}

public HaritaBanlama(id) {
    new menu, Menuz[512]

    if(banharitasecim == 0){
        formatex(Menuz, charsmax(Menuz), "\yHarita Banla")
    }
    else if(banharitasecim == 1){
        formatex(Menuz, charsmax(Menuz), "\y1. Haritayi Sec")
    }
    else if(banharitasecim == 2){
        formatex(Menuz, charsmax(Menuz), "\y2. Haritayi Sec")
    }
    else if(banharitasecim == 3){
        formatex(Menuz, charsmax(Menuz), "\y3. Haritayi Sec")
    }
    else if(banharitasecim == 4){
        formatex(Menuz, charsmax(Menuz), "\y4. Haritayi Sec")
    }
    else if(banharitasecim == 5){
        formatex(Menuz, charsmax(Menuz), "\y5. Haritayi Sec")
    }
    menu = menu_create(Menuz, "HaritaBanlamaMenu")
    if(bandust == 0) {
        formatex(Menuz, charsmax(Menuz), "\wde_dust2")
    }
    else if(bandust == 1) {
        formatex(Menuz, charsmax(Menuz), "\wde_dust2 \r[BANLI]")
    }
    else if(bandust == 2) {
        formatex(Menuz, charsmax(Menuz), "\wde_dust2 \r[1.HARITA]")
    }
    else if(bandust == 3) {
        formatex(Menuz, charsmax(Menuz), "\wde_dust2 \r[2.HARITA]")
    }
    else if(bandust == 4) {
        formatex(Menuz, charsmax(Menuz), "\wde_dust2 \r[3.HARITA]")
    }
    else if(bandust == 5) {
        formatex(Menuz, charsmax(Menuz), "\wde_dust2 \r[4.HARITA]")
    }
    else if(bandust == 6) {
        formatex(Menuz, charsmax(Menuz), "\wde_dust2 \r[5.HARITA]")
    }
    else if(bandust == 7) {
        formatex(Menuz, charsmax(Menuz), "\wde_dust2 \r[SECILDI]")
    }
    menu_additem(menu, Menuz, "1")
    if(baninferno == 0) {
        formatex(Menuz, charsmax(Menuz), "\wde_inferno")
    }
    else if(baninferno == 1){
        formatex(Menuz, charsmax(Menuz), "\wde_inferno \r[BANLI]")
    }
    else if(baninferno == 2){
        formatex(Menuz, charsmax(Menuz), "\wde_inferno \r[1.HARITA]")
    }
    else if(baninferno == 3){
        formatex(Menuz, charsmax(Menuz), "\wde_inferno \r[2.HARITA]")
    }
    else if(baninferno == 4){
        formatex(Menuz, charsmax(Menuz), "\wde_inferno \r[3.HARITA]")
    }
    else if(baninferno == 5){
        formatex(Menuz, charsmax(Menuz), "\wde_inferno \r[4.HARITA]")
    }
    else if(baninferno == 6){
        formatex(Menuz, charsmax(Menuz), "\wde_inferno \r[5.HARITA]")
    }
    else if(baninferno == 7){
        formatex(Menuz, charsmax(Menuz), "\wde_inferno \r[SECILDI]")
    }
    menu_additem(menu, Menuz, "6")
    if(bannuke == 0) {
        formatex(Menuz, charsmax(Menuz), "\wde_nuke")
    }
    else if(bannuke == 1){
        formatex(Menuz, charsmax(Menuz), "\wde_nuke \r[BANLI]")
    }
    else if(bannuke == 2){
        formatex(Menuz, charsmax(Menuz), "\wde_nuke \r[1.HARITA]")
    }
    else if(bannuke == 3){
        formatex(Menuz, charsmax(Menuz), "\wde_nuke \r[2.HARITA]")
    }
    else if(bannuke == 4){
        formatex(Menuz, charsmax(Menuz), "\wde_nuke \r[3.HARITA]")
    }
    else if(bannuke == 5){
        formatex(Menuz, charsmax(Menuz), "\wde_nuke \r[4.HARITA]")
    }
    else if(bannuke == 6){
        formatex(Menuz, charsmax(Menuz), "\wde_nuke \r[5.HARITA]")
    }
    else if(bannuke == 7){
        formatex(Menuz, charsmax(Menuz), "\wde_nuke \r[SECILDI]")
    }
    menu_additem(menu, Menuz, "5")
    if(bantrain == 0) {
        formatex(Menuz, charsmax(Menuz), "\wde_train")
    }
    else if(bantrain == 1){
        formatex(Menuz, charsmax(Menuz), "\wde_train \r[BANLI]")
    }
    else if(bantrain == 2){
        formatex(Menuz, charsmax(Menuz), "\wde_train \r[1.HARITA]")
    }
    else if(bantrain == 3){
        formatex(Menuz, charsmax(Menuz), "\wde_train \r[2.HARITA]")
    }
    else if(bantrain == 4){
        formatex(Menuz, charsmax(Menuz), "\wde_train \r[3.HARITA]")
    }
    else if(bantrain == 5){
        formatex(Menuz, charsmax(Menuz), "\wde_train \r[4.HARITA]")
    }
    else if(bantrain == 6){
        formatex(Menuz, charsmax(Menuz), "\wde_train \r[5.HARITA]")
    }
    else if(bantrain == 7){
        formatex(Menuz, charsmax(Menuz), "\wde_train \r[SECILDI]")
    }
    menu_additem(menu, Menuz, "2")
    if(banmirage == 0) {
        formatex(Menuz, charsmax(Menuz), "\wde_mirage")
    }
    else if(banmirage == 1){
        formatex(Menuz, charsmax(Menuz), "\wde_mirage \r[BANLI]")
    }
    else if(banmirage == 2){
        formatex(Menuz, charsmax(Menuz), "\wde_mirage \r[1.HARITA]")
    }
    else if(banmirage == 3){
        formatex(Menuz, charsmax(Menuz), "\wde_mirage \r[2.HARITA]")
    }
    else if(banmirage == 4){
        formatex(Menuz, charsmax(Menuz), "\wde_mirage \r[3.HARITA]")
    }
    else if(banmirage == 5){
        formatex(Menuz, charsmax(Menuz), "\wde_mirage \r[4.HARITA]")
    }
    else if(banmirage == 6){
        formatex(Menuz, charsmax(Menuz), "\wde_mirage \r[5.HARITA]")
    }
    else if(banmirage == 7){
        formatex(Menuz, charsmax(Menuz), "\wde_mirage \r[SECILDI]")
    }
    menu_additem(menu, Menuz, "4")
    if(bantuscan == 0) {
        formatex(Menuz, charsmax(Menuz), "\wde_tuscan")
    }
    else if(bantuscan == 1){
        formatex(Menuz, charsmax(Menuz), "\wde_tuscan \r[BANLI]")
    }
    else if(bantuscan == 2){
        formatex(Menuz, charsmax(Menuz), "\wde_tuscan \r[1.HARITA]")
    }
    else if(bantuscan == 3){
        formatex(Menuz, charsmax(Menuz), "\wde_tuscan \r[2.HARITA]")
    }
    else if(bantuscan == 4){
        formatex(Menuz, charsmax(Menuz), "\wde_tuscan \r[3.HARITA]")
    }
    else if(bantuscan == 5){
        formatex(Menuz, charsmax(Menuz), "\wde_tuscan \r[4.HARITA]")
    }
    else if(bantuscan == 6){
        formatex(Menuz, charsmax(Menuz), "\wde_tuscan \r[5.HARITA]")
    }
    else if(bantuscan == 7){
        formatex(Menuz, charsmax(Menuz), "\wde_tuscan \r[SECILDI]")
    }
    menu_additem(menu, Menuz, "3")
    if(banforge == 0) {
        formatex(Menuz, charsmax(Menuz), "\wde_forge")
    }
    else if(banforge == 1){
        formatex(Menuz, charsmax(Menuz), "\wde_forge \r[BANLI]")
    }
    else if(banforge == 2){
        formatex(Menuz, charsmax(Menuz), "\wde_forge \r[1.HARITA]")
    }
    else if(banforge == 3){
        formatex(Menuz, charsmax(Menuz), "\wde_forge \r[2.HARITA]")
    }
    else if(banforge == 4){
        formatex(Menuz, charsmax(Menuz), "\wde_forge \r[3.HARITA]")
    }
    else if(banforge == 5){
        formatex(Menuz, charsmax(Menuz), "\wde_forge \r[4.HARITA]")
    }
    else if(banforge == 6){
        formatex(Menuz, charsmax(Menuz), "\wde_forge \r[5.HARITA]")
    }
    else if(banforge == 7){
        formatex(Menuz, charsmax(Menuz), "\wde_forge \r[SECILDI]")
    }
    menu_additem(menu, Menuz, "7")

    menu_setprop(menu, MPROP_PERPAGE, 0);

    menu_display(id, menu, 0)

    return PLUGIN_HANDLED
}
public HaritaBanlamaMenu(id, menu, item) {

    if (item == MENU_EXIT)
    {
        menu_destroy(menu)

        return PLUGIN_HANDLED;
    }
    if(kf_kaptan[id] == 0)
    {
        chat_color(id,"%s Harita secimini sadece takim kaptanlari yapabilir.",szStag)
        HaritaBanlama(id);
        return PLUGIN_HANDLED;
    }

    new data[6], iName[64]
    new access, callback
    menu_item_getinfo(menu, item, access, data,5, iName, 63, callback)

    new key = str_to_num(data)

    switch(key)
    {
        case 1:
        {
            if(banharitasecim == 0) {
                if(bandust == 0) {
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        bandust = 1;
                        kf_sayac = kf_sayac+1;
                        if(get_pcvar_num(g_kfmodu) == 1){
                            if(kf_sayac == 6) {
                                set_task( 6.0, "BobirSonaKalanHaritayiAc" );
                                BobirSonaKalaniKilitle();
                            }
                        }
                        else if(get_pcvar_num(g_kfmodu) == 2){
                            if(kf_sayac == 2) {
                                banharitasecim = 1;
                            }
                            else if(kf_sayac == 4) {
                                banharitasecim = 3;
                            }
                        }
                        else if(get_pcvar_num(g_kfmodu) == 3){
                            if(kf_sayac == 2) {
                                banharitasecim = 1;
                            }
                        }
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
            else if(banharitasecim == 1) {
                if(bandust == 0){
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        bandust = 2;
                        banharitasecim = 2;
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
            else if(banharitasecim == 2) {
                if(bandust == 0){
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        bandust = 3;
                        if(get_pcvar_num(g_kfmodu) == 2){
                            banharitasecim = 0;
                        }
                        if(get_pcvar_num(g_kfmodu) == 3){
                            banharitasecim = 3;
                        }
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
            else if(banharitasecim == 3) {
                if(bandust==0){
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        bandust = 4;
                        if(get_pcvar_num(g_kfmodu) == 2){
                            banharitasecim = 9;
                            BoucAyarlariYap();
                        }
                        if(get_pcvar_num(g_kfmodu) == 3){
                            banharitasecim = 4;
                        }
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
            else if(banharitasecim == 4) {
                if(bandust==0){
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        bandust = 5;
                        banharitasecim = 5;
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
            else if(banharitasecim == 5) {
                if(bandust==0){
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        bandust = 6;
                        banharitasecim = 9;
                        BobesAyarlariYap();
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
        }
        case 2: // bantrain
        {
            if(banharitasecim == 0) {
                if(bantrain == 0) {
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        bantrain = 1;
                        kf_sayac = kf_sayac+1;
                        if(get_pcvar_num(g_kfmodu) == 1){
                            if(kf_sayac == 6) {
                                set_task( 6.0, "BobirSonaKalanHaritayiAc" );
                                BobirSonaKalaniKilitle();
                            }
                        }
                        else if(get_pcvar_num(g_kfmodu) == 2){
                            if(kf_sayac == 2) {
                                banharitasecim = 1;
                            }
                            else if(kf_sayac == 4) {
                                banharitasecim = 3;
                            }
                        }
                        else if(get_pcvar_num(g_kfmodu) == 3){
                            if(kf_sayac == 2) {
                                banharitasecim = 1;
                            }
                        }
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
            else if(banharitasecim == 1) {
                if(bantrain == 0){
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        bantrain = 2;
                        banharitasecim = 2;
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
            else if(banharitasecim == 2) {
                if(bantrain == 0){
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        bantrain = 3;
                        if(get_pcvar_num(g_kfmodu) == 2){
                            banharitasecim = 0;
                        }
                        if(get_pcvar_num(g_kfmodu) == 3){
                            banharitasecim = 3;
                        }
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
            else if(banharitasecim == 3) {
                if(bantrain==0){
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        bantrain = 4;
                        if(get_pcvar_num(g_kfmodu) == 2){
                            banharitasecim = 9;
                            BoucAyarlariYap();
                        }
                        if(get_pcvar_num(g_kfmodu) == 3){
                            banharitasecim = 4;
                        }
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
            else if(banharitasecim == 4) {
                if(bantrain==0){
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        bantrain = 5;
                        banharitasecim = 5;
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
            else if(banharitasecim == 5) {
                if(bantrain==0){
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        bantrain = 6;
                        banharitasecim = 9;
                        BobesAyarlariYap();
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
        }
        case 3: // bantuscan
        {
            if(banharitasecim == 0) {
                if(bantuscan == 0) {
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        bantuscan = 1;
                        kf_sayac = kf_sayac+1;
                        if(get_pcvar_num(g_kfmodu) == 1){
                            if(kf_sayac == 6) {
                                set_task( 6.0, "BobirSonaKalanHaritayiAc" );
                                BobirSonaKalaniKilitle();
                            }
                        }
                        else if(get_pcvar_num(g_kfmodu) == 2){
                            if(kf_sayac == 2) {
                                banharitasecim = 1;
                            }
                            else if(kf_sayac == 4) {
                                banharitasecim = 3;
                            }
                        }
                        else if(get_pcvar_num(g_kfmodu) == 3){
                            if(kf_sayac == 2) {
                                banharitasecim = 1;
                            }
                        }
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
            else if(banharitasecim == 1) {
                if(bantuscan == 0){
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        bantuscan = 2;
                        banharitasecim = 2;
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
            else if(banharitasecim == 2) {
                if(bantuscan == 0){
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        bantuscan = 3;
                        if(get_pcvar_num(g_kfmodu) == 2){
                            banharitasecim = 0;
                        }
                        if(get_pcvar_num(g_kfmodu) == 3){
                            banharitasecim = 3;
                        }
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
            else if(banharitasecim == 3) {
                if(bantuscan==0){
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        bantuscan = 4;
                        if(get_pcvar_num(g_kfmodu) == 2){
                            banharitasecim = 9;
                            BoucAyarlariYap();
                        }
                        if(get_pcvar_num(g_kfmodu) == 3){
                            banharitasecim = 4;
                        }
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
            else if(banharitasecim == 4) {
                if(bantuscan==0){
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        bantuscan = 5;
                        banharitasecim = 5;
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
            else if(banharitasecim == 5) {
                if(bantuscan==0){
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        bantuscan = 6;
                        banharitasecim = 9;
                        BobesAyarlariYap();
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
        }
        case 4: // banmirage
        {
            if(banharitasecim == 0) {
                if(banmirage == 0) {
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        banmirage = 1;
                        kf_sayac = kf_sayac+1;
                        if(get_pcvar_num(g_kfmodu) == 1){
                            if(kf_sayac == 6) {
                                set_task( 6.0, "BobirSonaKalanHaritayiAc" );
                                BobirSonaKalaniKilitle();
                            }
                        }
                        else if(get_pcvar_num(g_kfmodu) == 2){
                            if(kf_sayac == 2) {
                                banharitasecim = 1;
                            }
                            else if(kf_sayac == 4) {
                                banharitasecim = 3;
                            }
                        }
                        else if(get_pcvar_num(g_kfmodu) == 3){
                            if(kf_sayac == 2) {
                                banharitasecim = 1;
                            }
                        }
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
            else if(banharitasecim == 1) {
                if(banmirage == 0){
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        banmirage = 2;
                        banharitasecim = 2;
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
            else if(banharitasecim == 2) {
                if(banmirage == 0){
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        banmirage = 3;
                        if(get_pcvar_num(g_kfmodu) == 2){
                            banharitasecim = 0;
                        }
                        if(get_pcvar_num(g_kfmodu) == 3){
                            banharitasecim = 3;
                        }
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
            else if(banharitasecim == 3) {
                if(banmirage==0){
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        banmirage = 4;
                        if(get_pcvar_num(g_kfmodu) == 2){
                            banharitasecim = 9;
                            BoucAyarlariYap();
                        }
                        if(get_pcvar_num(g_kfmodu) == 3){
                            banharitasecim = 4;
                        }
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
            else if(banharitasecim == 4) {
                if(banmirage==0){
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        banmirage = 5;
                        banharitasecim = 5;
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
            else if(banharitasecim == 5) {
                if(banmirage==0){
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        banmirage = 6;
                        banharitasecim = 9;
                        BobesAyarlariYap();
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
        }
        case 5: // bannuke
        {
            if(banharitasecim == 0) {
                if(bannuke == 0) {
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        bannuke = 1;
                        kf_sayac = kf_sayac+1;
                        if(get_pcvar_num(g_kfmodu) == 1){
                            if(kf_sayac == 6) {
                                set_task( 6.0, "BobirSonaKalanHaritayiAc" );
                                BobirSonaKalaniKilitle();
                            }
                        }
                        else if(get_pcvar_num(g_kfmodu) == 2){
                            if(kf_sayac == 2) {
                                banharitasecim = 1;
                            }
                            else if(kf_sayac == 4) {
                                banharitasecim = 3;
                            }
                        }
                        else if(get_pcvar_num(g_kfmodu) == 3){
                            if(kf_sayac == 2) {
                                banharitasecim = 1;
                            }
                        }
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
            else if(banharitasecim == 1) {
                if(bannuke == 0){
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        bannuke = 2;
                        banharitasecim = 2;
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
            else if(banharitasecim == 2) {
                if(bannuke == 0){
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        bannuke = 3;
                        if(get_pcvar_num(g_kfmodu) == 2){
                            banharitasecim = 0;
                        }
                        if(get_pcvar_num(g_kfmodu) == 3){
                            banharitasecim = 3;
                        }
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
            else if(banharitasecim == 3) {
                if(bannuke==0){
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        bannuke = 4;
                        if(get_pcvar_num(g_kfmodu) == 2){
                            banharitasecim = 9;
                            BoucAyarlariYap();
                        }
                        if(get_pcvar_num(g_kfmodu) == 3){
                            banharitasecim = 4;
                        }
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
            else if(banharitasecim == 4) {
                if(bannuke==0){
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        bannuke = 5;
                        banharitasecim = 5;
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
            else if(banharitasecim == 5) {
                if(bannuke==0){
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        bannuke = 6;
                        banharitasecim = 9;
                        BobesAyarlariYap();
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
        }
        case 6: // baninferno
        {
            if(banharitasecim == 0) {
                if(baninferno == 0) {
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        baninferno = 1;
                        kf_sayac = kf_sayac+1;
                        if(get_pcvar_num(g_kfmodu) == 1){
                            if(kf_sayac == 6) {
                                set_task( 6.0, "BobirSonaKalanHaritayiAc" );
                                BobirSonaKalaniKilitle();
                            }
                        }
                        else if(get_pcvar_num(g_kfmodu) == 2){
                            if(kf_sayac == 2) {
                                banharitasecim = 1;
                            }
                            else if(kf_sayac == 4) {
                                banharitasecim = 3;
                            }
                        }
                        else if(get_pcvar_num(g_kfmodu) == 3){
                            if(kf_sayac == 2) {
                                banharitasecim = 1;
                            }
                        }
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
            else if(banharitasecim == 1) {
                if(baninferno == 0){
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        baninferno = 2;
                        banharitasecim = 2;
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
            else if(banharitasecim == 2) {
                if(baninferno == 0){
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        baninferno = 3;
                        if(get_pcvar_num(g_kfmodu) == 2){
                            banharitasecim = 0;
                        }
                        if(get_pcvar_num(g_kfmodu) == 3){
                            banharitasecim = 3;
                        }
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
            else if(banharitasecim == 3) {
                if(baninferno==0){
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        baninferno = 4;
                        if(get_pcvar_num(g_kfmodu) == 2){
                            banharitasecim = 9;
                            BoucAyarlariYap();
                        }
                        if(get_pcvar_num(g_kfmodu) == 3){
                            banharitasecim = 4;
                        }
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
            else if(banharitasecim == 4) {
                if(baninferno==0){
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        baninferno = 5;
                        banharitasecim = 5;
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
            else if(banharitasecim == 5) {
                if(baninferno==0){
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        baninferno = 6;
                        banharitasecim = 9;
                        BobesAyarlariYap();
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
        }
        case 7: // banforge
        {
            if(banharitasecim == 0) {
                if(banforge == 0) {
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        banforge = 1;
                        kf_sayac = kf_sayac+1;
                        if(get_pcvar_num(g_kfmodu) == 1){
                            if(kf_sayac == 6) {
                                set_task( 6.0, "BobirSonaKalanHaritayiAc" );
                                BobirSonaKalaniKilitle();
                            }
                        }
                        else if(get_pcvar_num(g_kfmodu) == 2){
                            if(kf_sayac == 2) {
                                banharitasecim = 1;
                            }
                            else if(kf_sayac == 4) {
                                banharitasecim = 3;
                            }
                        }
                        else if(get_pcvar_num(g_kfmodu) == 3){
                            if(kf_sayac == 2) {
                                banharitasecim = 1;
                            }
                        }
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
            else if(banharitasecim == 1) {
                if(banforge == 0){
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        banforge = 2;
                        banharitasecim = 2;
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
            else if(banharitasecim == 2) {
                if(banforge == 0){
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        banforge = 3;
                        if(get_pcvar_num(g_kfmodu) == 2){
                            banharitasecim = 0;
                        }
                        if(get_pcvar_num(g_kfmodu) == 3){
                            banharitasecim = 3;
                        }
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
            else if(banharitasecim == 3) {
                if(banforge==0){
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        banforge = 4;
                        if(get_pcvar_num(g_kfmodu) == 2){
                            banharitasecim = 9;
                            BoucAyarlariYap();
                        }
                        if(get_pcvar_num(g_kfmodu) == 3){
                            banharitasecim = 4;
                        }
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
            else if(banharitasecim == 4) {
                if(banforge==0){
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        banforge = 5;
                        banharitasecim = 5;
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
            else if(banharitasecim == 5) {
                if(banforge==0){
                    if(kf_takimsayac == 1 && get_user_team( id ) == 1 || kf_takimsayac == 2 && get_user_team( id ) == 2){
                        if(kf_takimsayac == 1) kf_takimsayac = 2;
                        else if(kf_takimsayac == 2) kf_takimsayac = 1;
                        banforge = 6;
                        banharitasecim = 9;
                        BobesAyarlariYap();
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                    else {
                        for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                    }
                }
                else {
                    for(new i = 1; i <= 32; i++) { if(get_user_team(i) == 1 || get_user_team(i) == 2){ HaritaBanlama(i); }}
                }
            }
        }
    }
    return PLUGIN_HANDLED
}

public BobirSonaKalanHaritayiAc(){
    if(bandust==7) server_cmd("changelevel de_dust2");
    if(bantrain==7) server_cmd("changelevel de_train");
    if(bantuscan==7) server_cmd("changelevel de_tuscan");
    if(banmirage==7) server_cmd("changelevel de_mirage");
    if(bannuke==7) server_cmd("changelevel de_nuke");
    if(baninferno==7) server_cmd("changelevel de_inferno");
    if(banforge==7) server_cmd("changelevel de_forge");
}

public BobirSonaKalaniKilitle(){
    if(bandust==0) bandust=7;
    if(bantrain==0) bantrain=7;
    if(bantuscan==0) bantuscan=7;
    if(banmirage==0) banmirage=7;
    if(bannuke==0) bannuke=7;
    if(baninferno==0) baninferno=7;
    if(banforge==0) banforge=7;
}

public BoucAyarlariYap(){
    if(bandust==2){ server_cmd("csm_birinciharita de_dust2"); chat_color(0,"!g%s !y1.Harita de_dust2 10 Saniye Icerisinde Aktif.",szStag);}
    if(bantrain==2){ server_cmd("csm_birinciharita de_train"); chat_color(0,"!g%s !y1.Harita de_train 10 Saniye Icerisinde Aktif.",szStag);}
    if(bantuscan==2){ server_cmd("csm_birinciharita de_tuscan"); chat_color(0,"!g%s !y1.Harita de_tuscan 10 Saniye Icerisinde Aktif.",szStag);}
    if(banmirage==2){ server_cmd("csm_birinciharita de_mirage"); chat_color(0,"!g%s !y1.Harita de_mirage 10 Saniye Icerisinde Aktif.",szStag);}
    if(bannuke==2){ server_cmd("csm_birinciharita de_nuke"); chat_color(0,"!g%s !y1.Harita de_nuke 10 Saniye Icerisinde Aktif.",szStag);}
    if(baninferno==2){ server_cmd("csm_birinciharita de_inferno"); chat_color(0,"!g%s !y1.Harita de_inferno 10 Saniye Icerisinde Aktif.",szStag);}
    if(banforge==2){ server_cmd("csm_birinciharita de_forge"); chat_color(0,"!g%s !y1.Harita de_forge 10 Saniye Icerisinde Aktif.",szStag);}
    if(bandust==3) server_cmd("csm_ikinciharita de_dust2");
    if(bantrain==3) server_cmd("csm_ikinciharita de_train");
    if(bantuscan==3) server_cmd("csm_ikinciharita de_tuscan");
    if(banmirage==3) server_cmd("csm_ikinciharita de_mirage");
    if(bannuke==3) server_cmd("csm_ikinciharita de_nuke");
    if(baninferno==3) server_cmd("csm_ikinciharita de_inferno");
    if(banforge==3) server_cmd("csm_ikinciharita de_forge");
    if(bandust==4) server_cmd("csm_ucuncuharita de_dust2");
    if(bantrain==4) server_cmd("csm_ucuncuharita de_train");
    if(bantuscan==4) server_cmd("csm_ucuncuharita de_tuscan");
    if(banmirage==4) server_cmd("csm_ucuncuharita de_mirage");
    if(bannuke==4) server_cmd("csm_ucuncuharita de_nuke");
    if(baninferno==4) server_cmd("csm_ucuncuharita de_inferno");
    if(banforge==4) server_cmd("csm_ucuncuharita de_forge");
    set_cvar_string("csm_birinciharita", birinciharitacevir);
    set_cvar_string("csm_ikinciharita", ikinciharitacevir);
    set_cvar_string("csm_ucuncuharita", ucuncuharitacevir);
    set_pcvar_num(g_kfmoduboucaktif,1)
    set_pcvar_num(g_haritasayac,1)
    set_pcvar_num(g_birinciharitakazanan,0)
    set_pcvar_num(g_ikinciharitakazanan,0)
    set_pcvar_num(g_ucuncuharitakazanan,0)
    set_pcvar_num(g_dorduncuharitakazanan,0)
    set_pcvar_num(g_besinciharitakazanan,0)
    set_task( 8.0, "readyac" );
    set_task( 10.0, "ilkiniac" );

}
public BobesAyarlariYap(){
    if(bandust==2){ server_cmd("csm_birinciharita de_dust2"); chat_color(0,"!g%s !y1.Harita de_dust2 10 Saniye Icerisinde Aktif.",szStag);}
    if(bantrain==2){ server_cmd("csm_birinciharita de_train"); chat_color(0,"!g%s !y1.Harita de_train 10 Saniye Icerisinde Aktif.",szStag);}
    if(bantuscan==2){ server_cmd("csm_birinciharita de_tuscan"); chat_color(0,"!g%s !y1.Harita de_tuscan 10 Saniye Icerisinde Aktif.",szStag);}
    if(banmirage==2){ server_cmd("csm_birinciharita de_mirage"); chat_color(0,"!g%s !y1.Harita de_mirage 10 Saniye Icerisinde Aktif.",szStag);}
    if(bannuke==2){ server_cmd("csm_birinciharita de_nuke"); chat_color(0,"!g%s !y1.Harita de_nuke 10 Saniye Icerisinde Aktif.",szStag);}
    if(baninferno==2){ server_cmd("csm_birinciharita de_inferno"); chat_color(0,"!g%s !y1.Harita de_inferno 10 Saniye Icerisinde Aktif.",szStag);}
    if(banforge==2){ server_cmd("csm_birinciharita de_forge"); chat_color(0,"!g%s !y1.Harita de_forge 10 Saniye Icerisinde Aktif.",szStag);}
    if(bandust==3) server_cmd("csm_ikinciharita de_dust2");
    if(bantrain==3) server_cmd("csm_ikinciharita de_train");
    if(bantuscan==3) server_cmd("csm_ikinciharita de_tuscan");
    if(banmirage==3) server_cmd("csm_ikinciharita de_mirage");
    if(bannuke==3) server_cmd("csm_ikinciharita de_nuke");
    if(baninferno==3) server_cmd("csm_ikinciharita de_inferno");
    if(banforge==3) server_cmd("csm_ikinciharita de_forge");
    if(bandust==4) server_cmd("csm_ucuncuharita de_dust2");
    if(bantrain==4) server_cmd("csm_ucuncuharita de_train");
    if(bantuscan==4) server_cmd("csm_ucuncuharita de_tuscan");
    if(banmirage==4) server_cmd("csm_ucuncuharita de_mirage");
    if(bannuke==4) server_cmd("csm_ucuncuharita de_nuke");
    if(baninferno==4) server_cmd("csm_ucuncuharita de_inferno");
    if(banforge==4) server_cmd("csm_ucuncuharita de_forge");
    if(bandust==5) server_cmd("csm_dorduncuharita de_dust2");
    if(bantrain==5) server_cmd("csm_dorduncuharita de_train");
    if(bantuscan==5) server_cmd("csm_dorduncuharita de_tuscan");
    if(banmirage==5) server_cmd("csm_dorduncuharita de_mirage");
    if(bannuke==5) server_cmd("csm_dorduncuharita de_nuke");
    if(baninferno==5) server_cmd("csm_dorduncuharita de_inferno");
    if(banforge==5) server_cmd("csm_dorduncuharita de_forge");
    if(bandust==6) server_cmd("csm_besinciharita de_dust2");
    if(bantrain==6) server_cmd("csm_besinciharita de_train");
    if(bantuscan==6) server_cmd("csm_besinciharita de_tuscan");
    if(banmirage==6) server_cmd("csm_besinciharita de_mirage");
    if(bannuke==6) server_cmd("csm_besinciharita de_nuke");
    if(baninferno==6) server_cmd("csm_besinciharita de_inferno");
    if(banforge==6) server_cmd("csm_besinciharita de_forge");
    set_cvar_string("csm_birinciharita", birinciharitacevir);
    set_cvar_string("csm_ikinciharita", ikinciharitacevir);
    set_cvar_string("csm_ucuncuharita", ucuncuharitacevir);
    set_cvar_string("csm_dorduncuharita", dorduncuharitacevir);
    set_cvar_string("csm_besinciharita", besinciharitacevir);
    set_pcvar_num(g_kfmoduboucaktif,2)
    set_pcvar_num(g_haritasayac,1)
    set_pcvar_num(g_birinciharitakazanan,0)
    set_pcvar_num(g_ikinciharitakazanan,0)
    set_pcvar_num(g_ucuncuharitakazanan,0)
    set_pcvar_num(g_dorduncuharitakazanan,0)
    set_pcvar_num(g_besinciharitakazanan,0)
    set_task( 8.0, "readyac" );
    set_task( 10.0, "ilkiniac" );

}
public readyac() {
    set_cvar_string("mp_freezetime", "7");
    set_pcvar_num(g_ready,1)
}

public sonrakiharitayiac(){

    if (get_pcvar_num(g_haritasayac) == 2 ){
        chat_color(0,"%s 2. Harita %s. Haritayi acmak icin takim kaptanlari /degis yazmalidir.",szStag, ikinciharitacevir)
    }
    else if (get_pcvar_num(g_haritasayac) == 3 ){
        chat_color(0,"%s 3. Harita %s. Haritayi acmak icin takim kaptanlari /degis yazmalidir.",szStag, ucuncuharitacevir)
    }
    else if (get_pcvar_num(g_haritasayac) == 4 ){
        chat_color(0,"%s 4. Harita %s. Haritayi acmak icin takim kaptanlari /degis yazmalidir.",szStag, dorduncuharitacevir)
    }
    else if (get_pcvar_num(g_haritasayac) == 5 ){
        chat_color(0,"%s 5. Harita %s. Haritayi acmak icin takim kaptanlari /degis yazmalidir.",szStag, besinciharitacevir)
    }

}
public kaptandegis(id){
    new oyuncuismi[32];
    get_user_name(id, oyuncuismi, 31)
    if(kaptanboharitaonayi == true){
        if(kf_kaptan[id]==1){
            if(get_user_team(id) == 1){
                if(kaptanboharitaonayite == false){
                    kaptanboharitaonayite = true
                    chat_color(0,"%s Takim kaptani %s sonraki harita icin onay verdi.", szStag,oyuncuismi)
                }
                else{
                    chat_color(id,"%s Siz zaten sonraki harita icin onay vermissiniz.",szStag)
                }
            }
            else if(get_user_team(id) == 2){
                if(kaptanboharitaonayict == false){
                    kaptanboharitaonayict = true
                    chat_color(0,"%s Takim kaptani %s sonraki harita icin onay verdi.", szStag,oyuncuismi)
                }
                else{
                    chat_color(id,"%s Siz zaten sonraki harita icin onay vermissiniz.",szStag)
                }
            }
            if(kaptanboharitaonayict == true && kaptanboharitaonayite == true){
                chat_color(id,"%s Sonraki harita icin her iki takiminda kaptanlari onay verdi, sonraki harita 3 saniye sonra acilacak.",szStag)
                set_task(3.0,"sonrakiharitayiacdevam")
            }
        }
        else {
            chat_color(id,"%s Bu komutu sadece takim kaptanlari kullanabilir.",szStag)
        }

    }
    else {
        chat_color(id,"%s Sonraki harita onayi sunucu tarafindan gelmedi. Hakemle iletisime geciniz.",szStag)
    }

}

public sonrakiharitayiacdevam(){
    if (get_pcvar_num(g_haritasayac) == 2 ){
        server_cmd("changelevel %s",ikinciharitacevir)
    }
    else if (get_pcvar_num(g_haritasayac) == 3 ){
        server_cmd("changelevel %s",ucuncuharitacevir)
    }
    else if (get_pcvar_num(g_haritasayac) == 4 ){
        server_cmd("changelevel %s",dorduncuharitacevir)
    }
    else if (get_pcvar_num(g_haritasayac) == 5 ){
        server_cmd("changelevel %s",besinciharitacevir)
    }
}

public ilkiniac(){
    if(bandust==2) server_cmd("changelevel de_dust2");
    if(bantrain==2) server_cmd("changelevel de_train");
    if(bantuscan==2) server_cmd("changelevel de_tuscan");
    if(banmirage==2) server_cmd("changelevel de_mirage");
    if(bannuke==2) server_cmd("changelevel de_nuke");
    if(baninferno==2) server_cmd("changelevel de_inferno");
    if(banforge==2) server_cmd("changelevel de_forge");
}
public BobesHaritalariSoyle(id){
    new birkazanan[32]
    if(get_cvar_num("csm_birinciharitakazanan") == 1){
        format(birkazanan,31,TakimAcevir)
    }
    else if(get_cvar_num("csm_birinciharitakazanan") == 2){
        format(birkazanan,31,TakimBcevir)
    }
    else {
        format(birkazanan,31,"-")
    }
    new ikikazanan[32]
    if(get_cvar_num("csm_ikinciharitakazanan") == 1){
        format(ikikazanan,31,TakimAcevir)
    }
    else if(get_cvar_num("csm_ikinciharitakazanan") == 2){
        format(ikikazanan,31,TakimBcevir)
    }
    else {
        format(ikikazanan,31,"-")
    }
    new uckazanan[32]
    if(get_cvar_num("csm_ucuncuharitakazanan") == 1){
        format(uckazanan,31,TakimAcevir)
    }
    else if(get_cvar_num("csm_ucuncuharitakazanan") == 2){
        format(uckazanan,31,TakimBcevir)
    }
    else {
        format(uckazanan,31,"-")
    }
    new dortkazanan[32]
    if(get_cvar_num("csm_dorduncuharitakazanan") == 1){
        format(dortkazanan,31,TakimAcevir)
    }
    else if(get_cvar_num("csm_dorduncuharitakazanan") == 2){
        format(dortkazanan,31,TakimBcevir)
    }
    else {
        format(dortkazanan,31,"-")
    }
    new beskazanan[32]
    if(get_cvar_num("csm_besinciharitakazanan") == 1){
        format(beskazanan,31,TakimAcevir)
    }
    else if(get_cvar_num("csm_besinciharitakazanan") == 2){
        format(beskazanan,31,TakimBcevir)
    }
    else {
        format(beskazanan,31,"-")
    }
    if (get_pcvar_num(g_kfmoduboucaktif) == 1 ){
        chat_color(id,"!reklam 1. Harita: %s(%s)| 2. Harita: %s(%s)| 3. Harita: %s(%s)", birinciharitacevir,birkazanan, ikinciharitacevir, ikikazanan, ucuncuharitacevir, uckazanan)
    }
    if (get_pcvar_num(g_kfmoduboucaktif) == 2 ){
        chat_color(id,"!reklam 1. Harita: %s(%s)| 2. Harita: %s(%s)| 3. Harita: %s(%s)| 4. Harita: %s(%s)| 5. Harita: %s(%s)", birinciharitacevir,birkazanan, ikinciharitacevir, ikikazanan, ucuncuharitacevir, uckazanan, dorduncuharitacevir, dortkazanan, besinciharitacevir, beskazanan)
    }
}
public BobesHaritalariSoyleherkes(){
    new birkazanan[32]
    if(get_cvar_num("csm_birinciharitakazanan") == 1){
        format(birkazanan,31,TakimAcevir)
    }
    else if(get_cvar_num("csm_birinciharitakazanan") == 2){
        format(birkazanan,31,TakimBcevir)
    }
    else {
        format(birkazanan,31,"-")
    }
    new ikikazanan[32]
    if(get_cvar_num("csm_ikinciharitakazanan") == 1){
        format(ikikazanan,31,TakimAcevir)
    }
    else if(get_cvar_num("csm_ikinciharitakazanan") == 2){
        format(ikikazanan,31,TakimBcevir)
    }
    else {
        format(ikikazanan,31,"-")
    }
    new uckazanan[32]
    if(get_cvar_num("csm_ucuncuharitakazanan") == 1){
        format(uckazanan,31,TakimAcevir)
    }
    else if(get_cvar_num("csm_ucuncuharitakazanan") == 2){
        format(uckazanan,31,TakimBcevir)
    }
    else {
        format(uckazanan,31,"-")
    }
    new dortkazanan[32]
    if(get_cvar_num("csm_dorduncuharitakazanan") == 1){
        format(dortkazanan,31,TakimAcevir)
    }
    else if(get_cvar_num("csm_dorduncuharitakazanan") == 2){
        format(dortkazanan,31,TakimBcevir)
    }
    else {
        format(dortkazanan,31,"-")
    }
    new beskazanan[32]
    if(get_cvar_num("csm_besinciharitakazanan") == 1){
        format(beskazanan,31,TakimAcevir)
    }
    else if(get_cvar_num("csm_besinciharitakazanan") == 2){
        format(beskazanan,31,TakimBcevir)
    }
    else {
        format(beskazanan,31,"-")
    }
    if (get_pcvar_num(g_kfmoduboucaktif) == 1 ){
        chat_color(0,"!reklam 1. Harita: %s(%s)| 2. Harita: %s(%s)| 3. Harita: %s(%s)", birinciharitacevir,birkazanan, ikinciharitacevir, ikikazanan, ucuncuharitacevir, uckazanan)
    }
    if (get_pcvar_num(g_kfmoduboucaktif) == 2 ){
        chat_color(0,"!reklam 1. Harita: %s(%s)| 2. Harita: %s(%s)| 3. Harita: %s(%s)| 4. Harita: %s(%s)| 5. Harita: %s(%s)", birinciharitacevir,birkazanan, ikinciharitacevir, ikikazanan, ucuncuharitacevir, uckazanan, dorduncuharitacevir, dortkazanan, besinciharitacevir, beskazanan)
    }
}

public cmd_KFKaptan(id,level,cid)
{

    if(!cmd_access(id, level, cid, 2))
        return PLUGIN_HANDLED;

    new arg1[32]

    read_argv(1, arg1, 31)

    new player = cmd_target(id, arg1, 2)

    if(!player){
        console_print(id,"Oyuncu Bulunamadi.")
        return PLUGIN_HANDLED
    }

    kf_kaptan[player] = 1
    new name[32]
    get_user_name(player, name, 31)
    chat_color(0,"!reklam Hakem %s oyuncusunu harita banlama sistemi icin kaptan olarak secti.", name)

    return PLUGIN_HANDLED

}


public KaptanlikMenusu(id)
{

    static opcion[64]

    formatex(opcion, charsmax(opcion),"\yKaptan Sec", LANG_PLAYER)
    new iMenu = menu_create(opcion, "KaptanlikMenusudevam")

    new players[32], tempid
    new szName[32], szTempid[10]
    new pnum


    get_players(players, pnum)

    for( new i; i<pnum; i++ )
    {
        tempid = players[i]
        if(!is_user_hltv(tempid) && is_user_connected(tempid)){
            get_user_name(tempid, szName, 31)
            num_to_str(tempid, szTempid, 9)
            formatex(opcion, charsmax(opcion), "\w%s", szName)
            menu_additem(iMenu, opcion, szTempid, 0)
        }

    }

    menu_display(id, iMenu)
    return PLUGIN_HANDLED
}

public KaptanlikMenusudevam(id, menu, item)
{
    if( item == MENU_EXIT )
    {
        menu_destroy(menu)
        return PLUGIN_HANDLED
    }

    new Data[6], Name[64]
    new Access, Callback
    menu_item_getinfo(menu, item, Access, Data,5, Name, 63, Callback)

    new tempid = str_to_num(Data)




    new oyuncuname[32];

    get_user_name(tempid, oyuncuname, 31);

    //get_user_name(id, adminname, 31);

    if(kf_kaptan[tempid] == 0){
        //chat_color(0,"!yâ€¢!gMRGaming !y: !g%s!y, !t%s oyuncusunu adminchate davet etti.",adminname, oyuncuname);
        chat_color(0,"!reklam Hakem %s oyuncusunu harita banlama sistemi icin kaptan olarak secti.", oyuncuname)
        kf_kaptan[tempid] = 1
    }
    else if(kf_kaptan[tempid] == 1){
        //chat_color(0,"!yâ€¢!gMRGaming !y: !g%s!y, !t%s oyuncusunu adminchate davet etti.",adminname, oyuncuname);
        chat_color(0,"!reklam Hakem %s oyuncusunu harita banlama sistemi icin kaptanliktan cikartti.", oyuncuname)
        kf_kaptan[tempid] = 0
    }
    kaptanlarikaydet()
    client_cmd( id, "macmenu");
    menu_destroy(menu)
    return PLUGIN_HANDLED
}
public kaptanlarikaydet(){
    delete_file(cmdfile)
    new oyuncuid[32];
    for(new i = 1; i < 33; i++){
        if(kf_kaptan[i] == 1){
            get_user_authid(i, oyuncuid, 31);
            write_file ( cmdfile , oyuncuid );
        }
    }
    ReadFile( )
}

public MacMenu(id, level, cid){
    if( !cmd_access( id, level, cid, 1 ) )
        return PLUGIN_HANDLED;

    new kaptannickkontrol[256];
    format(kaptannickkontrol, 255, "")
    new kaptanismi[32];
    new sayac = 0
    for(new i = 1; i < 33; i++){
        if(kf_kaptan[i] == 1){
            sayac++
            get_user_name(i, kaptanismi, 31);
            if(sayac >= 2){
                format(kaptannickkontrol, 255, "%s ve %s",kaptannickkontrol, kaptanismi)
            }
            else {
                format(kaptannickkontrol, 255, "%s %s",kaptannickkontrol, kaptanismi)
            }
        }
    }
    new menu, Menuz[512]
    if (get_pcvar_num(g_kfmoduboucaktif) == 2 ){
        formatex(Menuz, charsmax(Menuz), "\y [ Turnuva Mac Botu \dv\r%s \y]^n\wBy:\r %s^n[%s]-[%s]-[%s]-[%s]-[%s]", VERSION, CSMILEFACE, birinciharitacevir, ikinciharitacevir, ucuncuharitacevir, dorduncuharitacevir, besinciharitacevir);
    }
    else if (get_pcvar_num(g_kfmoduboucaktif) == 1 ){
        formatex(Menuz, charsmax(Menuz), "\y [ Turnuva Mac Botu \dv\r%s \y]^n\wBy:\r %s^n[%s]-[%s]-[%s]", VERSION, CSMILEFACE, birinciharitacevir, ikinciharitacevir, ucuncuharitacevir);
    }
    else{
        formatex(Menuz, charsmax(Menuz), "\y [ Turnuva Mac Botu \dv\r%s \y]^n\wBy:\r %s^n", VERSION, CSMILEFACE);
    }

    menu = menu_create(Menuz, "h_MacMenu")

    formatex(Menuz, charsmax(Menuz), "\wCT Takimini Ayarla.\d [%s]", TakimAcevir)
    menu_additem(menu, Menuz, "1")

    formatex(Menuz, charsmax(Menuz), "\wTE Takimini Ayarla.\d [%s]", TakimBcevir)
    menu_additem(menu, Menuz, "2")

    formatex(Menuz, charsmax(Menuz), "\wTakim Kaptanlarini Sec. ^n\d%s",kaptannickkontrol)
    menu_additem(menu, Menuz, "3")

    formatex(Menuz, charsmax(Menuz), "\wTakimlarin yerini soylettir.")
    menu_additem(menu, Menuz, "5")

    formatex(Menuz, charsmax(Menuz), "\wMac Botu Ayarlarini Sifirla")
    menu_additem(menu, Menuz, "4")

    menu_display(id, menu, 0)

    return PLUGIN_HANDLED
}

public h_MacMenu(iId, menu, item)
{
    if (item == MENU_EXIT)
    {
        menu_destroy(menu)

        return PLUGIN_HANDLED;
    }
    new data[6], iName[64]
    new access, callback
    menu_item_getinfo(menu, item, access, data,5, iName, 63, callback)

    new key = str_to_num(data)
    new admin_name[32]
    get_user_name(iId,admin_name,31)
    switch(key)
    {
        case 1: client_cmd( iId, "messagemode CTTakimIsmi" );
        case 2: client_cmd( iId, "messagemode TETakimIsmi" );
        case 3: KaptanlikMenusu(iId);
        case 4: cmdSifirla(iId);
        case 5: takimlariuyar(iId);
    }


    return PLUGIN_HANDLED;
}

public TETakimIsmi( iId )
{
    new girilen[32];
    read_args( girilen, charsmax( girilen ) );
    remove_quotes( girilen );
    trim( girilen );

    new admin_name[32]
    get_user_name(iId,admin_name,31)

    if ( equal(girilen, "") || contain( girilen, " ") != -1 )
    {

        client_cmd( iId, "messagemode TETAGGIR" );
        chat_color(iId,"!g bosluk veya bos isim koyabilirsiniz")

        return PLUGIN_HANDLED;

    }
    server_cmd("csm_TakimB %s",girilen)
    set_cvar_string("csm_TakimB", girilen);
    TakimBcevir = girilen
    chat_color( 0, "!reklam Hakem!g %s!y TE Takimini Ayarladi. || !t%s Takimi !yvs !t%s Takimi", admin_name,TakimAcevir, girilen)
    client_cmd( iId, "macmenu")

    return PLUGIN_HANDLED;
}
public CTTakimIsmi( iId )
{
    new girilen[32];
    read_args( girilen, charsmax( girilen ) );
    remove_quotes( girilen );
    trim( girilen );

    new admin_name[32]
    get_user_name(iId,admin_name,31)

    if ( equal(girilen, "") || contain( girilen, " ") != -1 )
    {

        client_cmd( iId, "messagemode TETAGGIR" );
        chat_color(iId,"!g bosluk veya bos isim koyabilirsiniz")

        return PLUGIN_HANDLED;

    }
    server_cmd("csm_TakimA %s",girilen)
    set_cvar_string("csm_TakimA", girilen);
    TakimAcevir = girilen
    chat_color( 0, "!reklam Hakem!g %s!y CT Takimini Ayarladi. || !t%s Takimi !yvs !t%s Takimi", admin_name,girilen, TakimBcevir)
    client_cmd( iId, "macmenu")

    return PLUGIN_HANDLED;
}
public client_putinserver( id )
{
    sorgula( id );
}
public ReadFile( )
{
    new szFilePath[ 128 ];
    get_configsdir( szFilePath, cm( szFilePath ) );
    add( szFilePath, cm( szFilePath ), FILE );

    new f = fopen( szFilePath, "rt" )

    if( !f )
    {
        write_file ( cmdfile , "" )
    }

    new szData[ 128 ];
    new szAuthID[ 35 ];
    new szDummy[ 4 ];

    while( !feof( f ) )
    {
        fgets( f, szData, cm( szData ) );

        if( !szData[ 0 ] || szData[ 0 ] == ';' || szData[ 0 ] == '/' && szData[ 1 ] == '/' )
        {
            continue;
        }

        trim( szData );
        parse( szData, szAuthID, cm( szAuthID ), szDummy, cm( szDummy ) );

        TrieSetCell( g_tAuthIdOfPeople, szAuthID, 1 );

    }

    fclose( f );
}
public sorgula( id )
{
    new szAuthID[ 35 ]; get_user_authid( id, szAuthID, cm( szAuthID ) )

    new iDummy;
    if( TrieGetCell( g_tAuthIdOfPeople, szAuthID, iDummy ) )
    {
        kf_kaptan[id] = 1
    }
    else {
        kf_kaptan[id] = 0
    }

}

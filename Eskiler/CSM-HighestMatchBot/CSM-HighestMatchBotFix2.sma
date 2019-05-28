/*
* 		Bu eklenti CSmiLeFaCe tarafýndan kodlanmýþtýr. Ýzinsiz baþka sitelerde daðýtýlmasý yasaktýr!
*
*                                                                               www.csplugin.com -> CSmiLeFaCe
*
*/


#include <amxmodx>
#include <amxmisc>
#include <cstrike>
#include <fakemeta>
#include <fun>
#include <hamsandwich>

#define PLUGIN "CSM MacBotu-Highest Fix2"
#define VERSION "2.2"
#define CSMILEFACE "CSmiLeFaCe"
#define szStag "csplugin"
#define szSite "www.csplugin.com"

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

#define PlugActivo (get_pcvar_num(g_RESULTADO))
#define csplugincomKF set_hudmessage(0, 160, 0, -1.0, 0.28, 0, 6.0, 12.0)
#define csplugincomGris set_hudmessage(0, 160, 0, -1.0, 0.30, 0, 6.0, 12.0)
#define csplugincomVrd set_hudmessage(64, 255, 64, -1.0, -1.0, 1)
#define csplugincomRed set_hudmessage(255, 64, 64, -1.0, -1.0, 1)
#define csplugincomBlu set_hudmessage(64, 64, 255, -1.0, -1.0, 1)
#define csplugincomBlu2 set_hudmessage(64, 64, 255, -1.0, 0.20, 1, 0.02, 12.00, 0.01, 0.1, -1)
#define csplugincomVrd2 set_hudmessage(64, 255, 64, -1.0, 0.20, 1, 0.02, 12.00, 0.01, 0.1, -1)
#define csplugincomRed2 set_hudmessage(255, 64, 64, -1.0, 0.20, 1, 0.02, 12.00, 0.01, 0.1, -1)

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
    ".rcon",
	"!qt ",
    "/qt ",
    ".qt "
}

/* Panel */
new p_tlock, p_duck, p_chat, p_pass
/* pCvars */
new g_RESULTADO, g_READY, g_SAY, g_soniditos, g_welcomemsg, g_pwDEF, g_pPasswordPointer
new tt_win, ct_win, total, totalCT, totalTT, globalCT, globalTT, ReadyCont, FraMitad, FraFinal, MasFraguer1, MasFraguer2
new Pauses
new g_paralarigoster

/* Strings */
new szPwdef[32]
new cspluginos
new cspluginos2

/* Unban Menu*/
new g_menuPosition[33]
new g_menuSelect[33][64]
new g_menuUnBanType[33]
new g_menuUnBanLine[33][2]
new g_menuUnBanText[33][8][32]
new g_bannedCfgFile[2][] = {"banned.cfg","listip.cfg"}
new g_coloredMenus


/* Arrays */
new bool:OnOff[33] = false
new bool:EstoyReady[33]
new bool:BorraLista
new bool:mitad = false
new bool:end = false
new bool:pasarse = false
new bool:ready = false
new bool:ready2 = false
new bool:dusme = false
new bool:uzatmalar = false
new bool:uzatmalarskor = false
new bool:tur3 = false
new bool:hsolayi = false
new bool:kfround = false
new bool:mac = false
/* Duck */
new bool:g_bFakeDuck[33];
new g_iFakeEnt;
new const g_ciEntityName[] = "anti_doubleducker";
new const g_ciCustomInvisibleModel[] = "models/w_awp.mdl";
new g_duck;

/* Cpt Say */
new g_cptsay

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
 
new g_iScore[_teams]

/* Takim Kilitleme */
new g_teamlock;

/* Renkli Say */
new g_renkli;

/* Quittir Bu */

enum {
    GET_TEAM_TARGET_ISALL,
    GET_TEAM_TARGET_ISTEAMCT,
    GET_TEAM_TARGET_ISTERRORIST,
}

enum {
    GET_TEAM_TARGET_SKIPNOBODY,
    GET_TEAM_TARET_SKIPBOTS,
    GET_TEAM_TARGET_SKIPDEADPEOPLE
}

stock get_team_target(arg[],players[32],&pnum,skipMode=GET_TEAM_TARGET_SKIPNOBODY){
    new whoTeam
    new cmdflags[4]
    switch(skipMode){
        case GET_TEAM_TARET_SKIPBOTS: cmdflags = "ce"
        case GET_TEAM_TARGET_SKIPNOBODY: cmdflags = "e"
        case GET_TEAM_TARGET_SKIPDEADPEOPLE: cmdflags = "ae"
    }
    if(equali(arg[1],"ALL",strlen(arg[1])))     {
        switch(skipMode){
            case GET_TEAM_TARET_SKIPBOTS: cmdflags = "c"
            case GET_TEAM_TARGET_SKIPNOBODY: cmdflags = ""
            case GET_TEAM_TARGET_SKIPDEADPEOPLE: cmdflags = "a"
        }
        whoTeam = GET_TEAM_TARGET_ISALL
        get_players(players,pnum,cmdflags)
    }
        
    if(equali(arg[1],"TERRORIST",strlen(arg[1]))) {
        whoTeam = GET_TEAM_TARGET_ISTERRORIST
        get_players(players,pnum,cmdflags,"TERRORIST")
    }
    if(equali(arg[1],"CT")    || equali(arg[1],"C")     || equali(arg[1],"COUNTER")) {
        whoTeam = GET_TEAM_TARGET_ISTEAMCT
        get_players(players,pnum,cmdflags,"CT")
    }
    return whoTeam
}

public plugin_init() {
	
	register_plugin(PLUGIN, VERSION, CSMILEFACE)
	
	/* Menu */
	register_clcmd("say !menu","PluginMenu")
	register_clcmd("say /menu","PluginMenu")
	register_clcmd("say .menu","PluginMenu")
	
	// Banteam ve HS komutu
	register_concmd( "amx_banteam", "CmdBanTeam", ADMIN_BAN, "<team name> <time> [ban type=0] -- ban type: 0 = amx_ban, 1 = amx_banip" );		
	register_concmd("aim_prac", "aim_prac", ADMIN_LEVEL_A, "aim_prac <on|off> or <1|0>")
	server_cmd ("aim_prac 0")
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
	
	/* CT Quit - T Quit */
	register_concmd("csm_quit","quit_plugin",ADMIN_KICK,"<name/@TEAM/*(all)>")
	register_concmd("say !quitct", "ctquit", ADMIN_KICK)
	register_concmd("say /quitct", "ctquit", ADMIN_KICK)
	register_concmd("say .quitct", "ctquit", ADMIN_KICK)
	register_concmd("say !quitt", "tquit", ADMIN_KICK)
	register_concmd("say /quitt", "tquit", ADMIN_KICK)
	register_concmd("say .quitt", "tquit", ADMIN_KICK)
	register_concmd("say !quitall", "allquit", ADMIN_KICK)
	register_concmd("say /quitall", "allquit", ADMIN_KICK)
	register_concmd("say .quitall", "allquit", ADMIN_KICK)
	
	/* Amxmodx Komutlari */	
	register_concmd("say !off","off", ADMIN_CVAR)
	register_concmd("say /off","off", ADMIN_CVAR)
	register_concmd("say .off","off", ADMIN_CVAR)	
	register_concmd("say !on","on", ADMIN_CVAR)
	register_concmd("say /on","on", ADMIN_CVAR)
	register_concmd("say .on","on", ADMIN_CVAR)
	register_concmd("say /pause","PauseHandler", ADMIN_CFG)
	register_concmd("say !pause","PauseHandler", ADMIN_CFG)
	register_concmd("say .pause","PauseHandler", ADMIN_CFG)	
	
	/* Say Komutlari */
	register_concmd("say /say", "cmdSayNosay", ADMIN_CVAR)
	register_concmd("say !say", "cmdSayNosay", ADMIN_CVAR)
	register_concmd("say .say", "cmdSayNosay", ADMIN_CVAR)
	register_concmd("say .cptsay","cmdCptsay", ADMIN_CVAR)	
	register_concmd("say !cptsay","cmdCptsay", ADMIN_CVAR)	
	register_concmd("say /cptsay","cmdCptsay", ADMIN_CVAR)		
	register_clcmd("say","nosay")
	
	/* Unban Komutlarý */
	register_clcmd("say !unban","cmdUnBanMenu", ADMIN_BAN, "- displays unban menu")
	register_clcmd("say /unban","cmdUnBanMenu", ADMIN_BAN, "- displays unban menu")
	register_clcmd("say .unban","cmdUnBanMenu", ADMIN_BAN, "- displays unban menu")
	register_clcmd("say !bansil","cmdUnBanMenu", ADMIN_BAN, "- displays unban menu")
	register_clcmd("say /bansil","cmdUnBanMenu", ADMIN_BAN, "- displays unban menu")
	register_clcmd("say .bansil","cmdUnBanMenu", ADMIN_BAN, "- displays unban menu")
	register_menucmd(register_menuid("UnBan STEAMID or IP?"),(1<<0|1<<1|1<<9),"actionUnBanMenuType")
	register_menucmd(register_menuid("UnBan  Menu"),1023,"actionUnBanMenu")
	
	/* Duck Komutlari */
	register_concmd("say !duck", "cmdDuckNoduck", ADMIN_CVAR)
	register_concmd("say /duck", "cmdDuckNoduck", ADMIN_CVAR)
	register_concmd("say .duck", "cmdDuckNoduck", ADMIN_CVAR)
	
	/* RenkliSay Komutlari */
	register_concmd("say !renklisay", "cmdRenkliSay", ADMIN_CVAR)
	register_concmd("say /renklisay", "cmdRenkliSay", ADMIN_CVAR)
	register_concmd("say .renklisay", "cmdRenkliSay", ADMIN_CVAR)
	
	/* Ready Komutlari */
	register_concmd("say !onay", "cmdrd", ADMIN_CVAR)
	register_concmd("say /onay", "cmdrd", ADMIN_CVAR)
	register_concmd("say .onay", "cmdrd", ADMIN_CVAR)
	
	register_clcmd("say /ready", "menu_ready")
	register_clcmd("say_team /ready", "menu_ready")
	register_clcmd("say !ready", "menu_ready")
	register_clcmd("say_team !ready", "menu_ready")
	register_clcmd("say .ready", "menu_ready")
	register_clcmd("say_team .ready", "menu_ready")
	
	
	register_clcmd("say", "chatFilter");
	
	/* Ses Komutlari */
	register_concmd("say !ses", "cmdses", ADMIN_CVAR)
	register_concmd("say /ses", "cmdses", ADMIN_CVAR)
	register_concmd("say .ses", "cmdses", ADMIN_CVAR)
	
	/* Hosgeldin Komutlari */
	register_concmd("say !hosgeldin", "cmdhsg", ADMIN_CVAR)
	register_concmd("say /hosgeldin", "cmdhsg", ADMIN_CVAR)
	register_concmd("say .hosgeldin", "cmdhsg", ADMIN_CVAR)
	
	/* Password Komutlari */
	register_concmd("say /nopass","cmdNopass", ADMIN_CFG)
	register_concmd("say !nopass","cmdNopass", ADMIN_CFG)
	register_concmd("say .nopass","cmdNopass", ADMIN_CFG)
	register_concmd("say /nopw","cmdNopass", ADMIN_CFG)
	register_concmd("say !nopw","cmdNopass", ADMIN_CFG)
	register_concmd("say .nopw","cmdNopass", ADMIN_CFG)
	register_clcmd("say !pass","sayPass"),
	register_clcmd("say /pass","sayPass")
	register_clcmd("say .pass","sayPass")
	register_clcmd("say_team !pass","sayPass"),
	register_clcmd("say_team /pass","sayPass")
	register_clcmd("say_team .pass","sayPass")
	register_clcmd("say","SayPwkoy")
	
	/* Map Komutlari */
	register_concmd("say /maps","MapsMenu", ADMIN_MAP)
	register_concmd("say !maps","MapsMenu", ADMIN_MAP)
	register_concmd("say .maps","MapsMenu", ADMIN_MAP)
	register_concmd("say !restart","cmdMapRes", ADMIN_MAP)
	register_concmd("say /restart","cmdMapRes", ADMIN_MAP)
	register_concmd("say .restart","cmdMapRes", ADMIN_MAP)
	
	/* Maci Baslatma Komutlari */
	register_concmd("say /335","cmdVale", ADMIN_CFG)
	register_concmd("say !335","cmdVale", ADMIN_CFG)
	register_concmd("say .335","cmdVale", ADMIN_CFG)
	register_concmd("say /baslat","cmdVale2", ADMIN_CFG)
	register_concmd("say !baslat","cmdVale2", ADMIN_CFG)
	register_concmd("say .baslat","cmdVale2", ADMIN_CFG)
	
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
	
	/* sXe Ayarlari */
	register_concmd("say !sxe","cmdSxe", ADMIN_CFG)
	register_concmd("say /sxe","cmdSxe", ADMIN_CFG)
	register_concmd("say .sxe","cmdSxe", ADMIN_CFG)
	register_concmd("say !sxeop","cmdSxeop", ADMIN_CFG)
	register_concmd("say /sxeop","cmdSxeop", ADMIN_CFG)
	register_concmd("say .sxeop","cmdSxeop", ADMIN_CFG)	
	register_concmd("say !nosxe","cmdNosxe", ADMIN_CFG)
	register_concmd("say /nosxe","cmdNosxe", ADMIN_CFG)
	register_concmd("say .nosxe","cmdNosxe", ADMIN_CFG)
	
	/* Takim Ayarlari */
	register_concmd("say !degis","cmdDegis", ADMIN_CFG)
	register_concmd("say /degis","cmdDegis", ADMIN_CFG)
	register_concmd("say .degis","cmdDegis", ADMIN_CFG)
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
	register_concmd("say !bitir","cmdMacBitir", ADMIN_CFG)
	register_concmd("say /bitir","cmdMacBitir", ADMIN_CFG)
	register_concmd("say .bitir","cmdMacBitir", ADMIN_CFG)
	
	g_iMaxPlayers = get_maxplayers( );	
	
	/* Demo Komutlari */
	register_clcmd("say","SayDemo")
	register_clcmd("say .stop","cmdStop")	
	register_clcmd("say /stop","cmdStop")	
	register_clcmd("say !stop","cmdStop")
	
	/* Para Gösterme */
	register_clcmd("say !para", "cmdParaGoster");
	register_clcmd("say /para", "cmdParaGoster");
	register_clcmd("say .para", "cmdParaGoster");	
	register_clcmd("say_team !para", "cmdParaGoster");
	register_clcmd("say_team /para", "cmdParaGoster");
	register_clcmd("say_team .para", "cmdParaGoster");	
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
	
	/* Skor Öðrenme */
	register_clcmd("say !durum","durum")
	register_clcmd("say /durum","durum")
	register_clcmd("say .durum","durum")
	register_clcmd("say_team !durum","durum")
	register_clcmd("say_team /durum","durum")
	register_clcmd("say_team .durum","durum")
	/* Frag Kaydetme */
	register_clcmd("say !frag","frag_part1")
	register_clcmd("say /frag","frag_part1")
	register_clcmd("say .frag","frag_part1")
	/* Surum*/
	register_clcmd("say_team .surum","surum")
	register_clcmd("say_team !surum","surum")
	register_clcmd("say_team /surum","surum")
	// Eventler
	register_logevent("round_end", 2, "1=Round_End")  
	register_event("HLTV", "nuevo_round", "a", "1=0", "2=0") 
	register_event("TeamScore","captura_score","a")
	register_event("TeamScore", "Event_TeamScore", "a")
	register_clcmd("say .score1", "ClientCommand_SayScore")
	register_event("HLTV","new_round","a","1=0","2=0");
	register_event("TextMsg", "restart_round", "a", "2=#Game_will_restart_in");	
	RegisterHam(Ham_Spawn, 		"player", "oyuncudogdugunda",	1)
	
	// pCvarLar
	g_RESULTADO = register_cvar("csm_enable","1") 
	g_READY = register_cvar("csm_ready","0") 
	g_SAY = register_cvar("csm_nosay","0") 
	g_soniditos = register_cvar("csm_baslangicsesi","1")
	g_welcomemsg = register_cvar("csm_hosgeldin","1")
	g_pwDEF = register_cvar("csm_password","closed")
	g_pPasswordPointer = get_cvar_pointer("sv_password") 
	g_duck = register_cvar("csm_duck","0") 
	g_cptsay = register_cvar("csm_cptsay","1") 
	g_teamlock = register_cvar("csm_teamlock","0") 
	g_renkli = register_cvar("csm_renklisay","1")
	g_paralarigoster = register_cvar("csm_paralarigoster","1")
	g_kfteleport = register_cvar("csm_kfteleport","1")
	g_pSwapVote = register_cvar( "csm_kazanantakim", "1" );   
	g_pNoslash = register_cvar( "csm_sagtikkapat", "0" );
	
	//Panel komutlarý
	p_chat = register_cvar("pxecsm_1","1")
	p_duck = register_cvar("pxecsm_2","1")
	p_pass = register_cvar("pxecsm_3","1")
	p_tlock = register_cvar("pxecsm_4","1")
	
	// Stringsler
	get_pcvar_string(g_pwDEF,szPwdef,31)

	// Cvarlar
	register_cvar("mm_author", CSMILEFACE, FCVAR_SERVER | FCVAR_SPONLY) 
	register_cvar("mm_version", VERSION, FCVAR_SPONLY|FCVAR_SERVER)
	set_task(180.0,"CheckSlots",_,_,_,"b")
	
	
	// Forwadlar
	register_forward( FM_GetGameDescription, "GameDesc" )	
	register_forward(FM_PlayerPreThink,  "FM_PlayerPreThink_Pre",  0);
	register_forward(FM_PlayerPostThink, "FM_PlayerPostThink_Pre", 0);
	register_forward(FM_AddToFullPack,   "FM_AddToFullPack_Pre",   0);
	register_forward(FM_AddToFullPack,   "FM_AddToFullPack_Post",  1);
	
	if( (g_iFakeEnt=engfunc(EngFunc_CreateNamedEntity, engfunc(EngFunc_AllocString, "func_wall")))>0 )
	{
		engfunc(EngFunc_SetModel, g_iFakeEnt, g_ciCustomInvisibleModel); 
		set_pev(g_iFakeEnt, pev_classname,  g_ciEntityName); 
		set_pev(g_iFakeEnt, pev_solid,      SOLID_NOT);
		set_pev(g_iFakeEnt, pev_movetype,   MOVETYPE_NONE);
		set_pev(g_iFakeEnt, pev_rendermode, kRenderTransAlpha); 
		set_pev(g_iFakeEnt, pev_renderamt,  0.0); 
	}
	
	// Team Ban
	g_tTeamData = TrieCreate( );
	for( new i = 0; i < sizeof( g_iTeamData ); i++ ) {
	TrieSetCell( g_tTeamData, g_iTeamData[ i ][ TD_szInput ], g_iTeamData[ i ][ TD_iTeam ] );
	}
	
}

public Event_TeamScore()
{
	
	new szTeamName[2]
	read_data(1, szTeamName, 1)
	g_iScore[szTeamName[0] == 'T' ? _terro : _ct] = read_data(2)
}

public surum(id){
	chat_color(id,"!ySurum : !g%s !y Kodlayan : !g%s",VERSION,CSMILEFACE);
}

public ClientCommand_SayScore(id)
{
	
	client_print(id, print_chat,"Round %d", rounds_elapsed);
	client_print(id, print_chat, "Score : Terrorists %d - %d CTs", g_iScore[_terro], g_iScore[_ct])
	return PLUGIN_HANDLED
} 

public new_round(id)
{
	rounds_elapsed += 1;
	if (kfround == true) {
		chat_color(0,"!yRound : !gKF Round");
		chat_color(0,"!ySkor : !gCounter-Terrorists !t: -  !y| !gTerrorists !y: !t: -")
	}
	else if(kfround == false && paragosterge == 1){
		if PlugActivo {
			
			if(!mitad){
				chat_color(0,"!yRound : !g%d", rounds_elapsed);
				chat_color(0,"!ySkor : !gCounter-Terrorists !t:%i  !y| !gTerrorists !y: !t:%i",ct_win,tt_win)
			}
			else if (mitad) {
				if(uzatmalar == true){
					if(uzatmalarskor == true) {
						chat_color(0,"!yRound : !g%d", rounds_elapsed+3);
						chat_color(0,"!ySkor : !gCounter-Terrorists !t:%i  !y| !gTerrorists !y: !t%i",ct_win + totalCT,tt_win + totalTT)
					}
					else if(uzatmalarskor == false) {
						chat_color(0,"!yRound : !g%d", rounds_elapsed);
						chat_color(0,"!ySkor : !gCounter-Terrorists !t:%i  !y| !gTerrorists !y: !t%i",ct_win + totalCT,tt_win + totalTT)
					}
				}
				else if(uzatmalar == false){
					chat_color(0,"!yRound : !g%d", rounds_elapsed+15);
					chat_color(0,"!ySkor : !gCounter-Terrorists !t:%i  !y| !gTerrorists !y: !t%i",ct_win + totalCT,tt_win + totalTT)
				}
			}
		}
	}
	return PLUGIN_HANDLED
}

public oyuncudogdugunda(id)
{
	if(paragosterge == 1) {
		if (get_pcvar_num(g_paralarigoster) == 1 )
		{
			if(get_user_team(id) == 1)
			{
				client_cmd(id, "say_team /para")
			}
			else if(get_user_team(id) == 2)
			{
				client_cmd(id, "say_team /para")
			}
		}
	}
	return PLUGIN_HANDLED
}
public restart_round()
{
	rounds_elapsed = 0; 
	g_iScore[_terro] = 0;
	g_iScore[_ct] = 0;
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
		case 75: { 
            console_cmd(id,"csm_quit %s", arg);
        }
        case 76: { 
            console_cmd(id,"csm_quit %s", arg);
        }
        case 77: { 
            console_cmd(id,"csm_quit %s", arg);
        }
    }
    return PLUGIN_HANDLED;
}

public plugin_end( ) {
    TrieDestroy( g_tTeamData );
}


public GameDesc( ) {
	
	forward_return(FMV_STRING,"csplugin.com")
	return FMRES_SUPERCEDE
	
}
public client_disconnect(id) { 
	
	if(dusme == true) {
		cspluginos2 = get_playersnum(0);
		if(cspluginos2 >= cspluginos) {
			set_pcvar_string(g_pPasswordPointer, "")
			chat_color(0,"!g[%s] !yEksik Kisi Bulundu.",szStag)
			chat_color(0,"!g[%s] !yServer Sifresi !tKaldirildi.",szStag)
			
		}
	}
	
	g_bFakeDuck[id] = false;
	
	OnOff[id] = false
	if(EstoyReady[id]) {
		EstoyReady[id] = false;
		ReadyCont--;
	}
} 

public client_connect(id) {
	if(dusme == true) {
		cspluginos2 = get_playersnum(0);
		if(cspluginos2 == cspluginos) {
			chat_color(0,"!g[%s] !yEksik Kisi Tamamlandi.!tSifre Seciliyor.",szStag)
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
	
	chat_color(0,"!g[%s] !yAmxmodx !tKapatildi.",szStag)
	
	return PLUGIN_HANDLED
}

public on() {
	
	server_cmd("amx_on")
		
	chat_color(0,"!g[%s] !yAmxmodx !tAcildi.",szStag)
		
	return PLUGIN_HANDLED
}


public captura_score() {
	
	if PlugActivo {
		
		new team[16],Float:score
		read_data(1,team,15)
		read_data(2,score)
		
		if(equal(team,"CT"))
			ct_win = floatround(score)
		
		
		if(equal(team,"TERRORIST"))
			tt_win = floatround(score)
		
		total = ct_win + tt_win	
	}
}

public nuevo_round(id){
	
	if (get_pcvar_num(g_READY)) 
	{
		ready = true
		ready2 = true
	}
	else
	ready = false 
	
	
	if (ready) {
		
		set_task(1.0, "ActualizaLista", TASK_LISTA, _, _, "b")
		set_task(1.0, "CheckLista", TASK_CHE, _, _, "b")
		set_task(2.0, "mensaje", TASK_MENSAJE)
		client_cmd(id,"say /ready")
	}
}

public round_end(){
	
	if PlugActivo   {	
		
		if (uzatmalar == true) {
			if(total == 3 && tur3 == false) {
				totalCT = tt_win
				totalTT = ct_win
				server_cmd("sv_restart 5")
				set_task(1.0, "cambio_teams", TASK_CAMBIO)
				
				chat_color(0,"!g[%s] !g1 RESTART!t'tan Sonra 3.Devre Baslayacak.",szStag)
				
				chat_color(0,"!g[%s] !yTakimlar Degistiriliyor !gCounter-Terrorists !y: !t%i !y- !gTerrorists !y: !t%i !y.",szStag,totalTT,totalCT)
				
				set_task(1.0, "mitadmsg2")
				globalCT = totalCT
				globalTT = totalTT
				tt_win = 0
				ct_win = 0
				uzatmalarskor = true
				tur3 = true
			}
			else if (ct_win + totalCT == 4){
				chat_color(0,"!g[%s] !yCounter-Terorists !gMaci Kazandi.",szStag)
				
				csplugincomBlu
				show_hudmessage(0,"Counter-Teroristler Kazandi.")	
				
				end = true
				mitad = false
				uzatmalar = false
			}
			else if (tt_win + totalTT == 4)
			{
				chat_color(0,"!g[%s] !yTerorists !gMaci Kazandi.",szStag)
				csplugincomRed
				show_hudmessage(0,"Teroristler Kazandi.")
				
				
				end = true
				mitad = false
				uzatmalar = false
			}
		}
		
		if (total == 15 && (!mitad)) {
			
			totalCT = tt_win
			totalTT = ct_win
			
			FraMitad = El_mas_Frager();	
			MasFraguer1 = get_user_frags(FraMitad)
			
			if (ready2) {
				set_pcvar_num (g_READY, 1)
			}
			set_task(1.0, "cambio_teams", TASK_CAMBIO)
			
			chat_color(0,"!g[%s] !g1 RESTART!t'tan Sonra 2.Devre Baslayacak.",szStag)
			
			server_cmd("sv_restart 5")
			
			mitad = true
			uzatmalar = false
			chat_color(0,"!g[%s] !yTakimlar Degistiriliyor !gCounter-Terrorists !y: !t%i !y- !gTerrorists !y: !t%i !y.",szStag,totalTT,totalCT)
			
			set_task(1.0, "mitadmsg")
			
			globalCT = totalCT
			globalTT = totalTT
			tt_win = 0
			ct_win = 0
			
		}
	}
	if (mitad) {
		
		if (ct_win + totalCT == 16){
			chat_color(0,"!g[%s] !yCounter-Terorists !gMaci Kazandi.",szStag)
			
			csplugincomBlu
			show_hudmessage(0,"Counter-Teroristler Kazandi.")	
			
			end = true
			mitad = false
			uzatmalar = false
		}
		else if (tt_win + totalTT == 16)
		{
			chat_color(0,"!g[%s] !yTerorists !gMaci Kazandi.",szStag)
			csplugincomRed
			show_hudmessage(0,"Teroristler Kazandi.")
			
			
			end = true
			mitad = false
			uzatmalar = false
		}
		
		else if (tt_win + totalTT == 15 && ct_win + totalCT == 15)
		{
			csplugincomVrd
			show_hudmessage(0, "Mac Berabere Sonuclandi.")
			
			set_task(1.0, "Uzat", TASK_CAMBIO)
			server_cmd("sv_restart 5")
			set_task(1.0, "cambio_teams", TASK_CAMBIO)
			
			chat_color(0,"!g[%s] !g5 Saniyelik RESTART!t'tan Sonra Uzatmalar Baslayacak.",szStag)
			tt_win = 0
			ct_win = 0
			total = 0
			totalCT = 0
			totalTT = 0
			mitad = true
			uzatmalar = true
			tur3 = false
		}
		if (ct_win + totalCT == 15){
			chat_color(0,"!g[%s] !yCounter-Terorists !gTakiminin Toplam Skoru: 15",szStag)
		}
		if (tt_win + totalTT == 15)
		{
			chat_color(0,"!g[%s] !yTerorists !gTakiminin Toplam Skoru: 15",szStag)
		}
	}
	if (end){
		
		chat_color(0,"!g[%s] !yMac Sonucu : !gCounter-Terrorists : !t%i  !y-  !g-Terrorists : !t%i",szStag, ct_win + totalCT,tt_win + totalTT)
		
		FraFinal = El_mas_Frager();
		MasFraguer2 = get_user_frags(FraFinal)		
		set_task(5.0, "mas_fraguero1")
		set_task(5.0, "mas_fraguero2")
		set_task(7.0, "cmdMacBitir2")
		uzatmalar = false
		globalCT = totalCT + ct_win
		globalTT = totalTT + tt_win
		uzatmalarskor = false
		end = false
		pasarse = false
		mac = false
	}
}

public cmdVale(id, level, cid) {
	if (get_pcvar_num(g_soniditos) == 1 ) {
		client_cmd(0, "spk ^"vox/activate^"")
	}
	if( !cmd_access( id, level, cid, 1 ) )  
		
	return PLUGIN_HANDLED;
	
	pasarse = true
	remove_task(TASK_LISTA)
	remove_task(TASK_CHE)
	set_pcvar_num (g_READY, 0)
	EstoyReady[id] = false
	ReadyCont = 0
	
	new admin_name[32]
	get_user_name(id,admin_name,31)
	static logdosya[100]
	formatex(logdosya, charsmax(logdosya), "%s Maci Baslatti", admin_name)
	log_to_file("csmmacbot.log", logdosya)
	
	new pass[32]
	get_cvar_string("sv_password",pass,sizeof(pass) - 1)
	
	if(!mitad) {	
		
		tt_win = 0
		ct_win = 0
		total = 0
		totalCT = 0
		totalTT = 0
		end = false
		
		set_task(1.0, "print", TASK_PRINT)
		set_hudmessage(0, 160, 0, -1.0, 0.46, 0, 6.0, 12.0)
		show_hudmessage(0, "Mac Baslatma Komutu Uygulandi!")
	}	
	else
		
	tt_win = 0
	ct_win = 0
	ready2 = false
	mac = true
	set_task(1.0, "print", TASK_PRINT)  
	set_hudmessage(0, 160, 0, -1.0, 0.46, 0, 6.0, 12.0)
	show_hudmessage(0, "Mac Baslatma Komutu Uygulandi!")
	return PLUGIN_HANDLED
}

public cmdVale2(id, level, cid) {
	if (get_pcvar_num(g_soniditos) == 1 ) {
		client_cmd(0, "spk ^"vox/activate^"")
	}
	if( !cmd_access( id, level, cid, 1 ) )  
		
	return PLUGIN_HANDLED;

	new admin_name[32]
	get_user_name(id,admin_name,31)
	static logdosya[100]
	formatex(logdosya, charsmax(logdosya), "%s Maci Baslatti", admin_name)
	log_to_file("csmmacbot.log", logdosya)
	
	pasarse = true
	remove_task(TASK_LISTA)
	remove_task(TASK_CHE)
	set_pcvar_num (g_READY, 0)
	EstoyReady[id] = false
	ReadyCont = 0
	
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
		set_hudmessage(0, 160, 0, -1.0, 0.46, 0, 6.0, 12.0)
		show_hudmessage(0, "Mac Baslatma Komutu Uygulandi!")
	}	
	else
		
	tt_win = 0
	ct_win = 0
	ready2 = false
	mac = true
	set_task(1.0, "print2", TASK_PRINT)  
	set_hudmessage(0, 160, 0, -1.0, 0.46, 0, 6.0, 12.0)
	show_hudmessage(0, "Mac Baslatma Komutu Uygulandi!")
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
	EstoyReady[id] = false
	ReadyCont = 0
	set_pcvar_num (g_READY, 0)
	
	return PLUGIN_HANDLED;
}

public cmdRR (id, level, cid){
	
	if( !cmd_access( id, level, cid, 1 ) )  
		return PLUGIN_HANDLED;
	
	server_cmd("sv_restart 1")
	
	new admin_name[32]
	get_user_name(id , admin_name , 31 )
	g_bKnifeRound = false;
	chat_color(0,"!g%s !t1 !ySaniyelik Restart Atti.",admin_name)
	
	
	return PLUGIN_HANDLED;
}

public cmdRR3 (id, level, cid){
	
	if( !cmd_access( id, level, cid, 1 ) )  
		return PLUGIN_HANDLED;
	
	server_cmd("sv_restart 3")
	
	new admin_name[32]
	get_user_name(id , admin_name , 31 )
	g_bKnifeRound = false;
	chat_color(0,"!g%s !t3 !ySaniyelik Restart Atti.",admin_name)
	
	
	return PLUGIN_HANDLED;
}

public cmdRR5 (id, level, cid){
	
	if( !cmd_access( id, level, cid, 1 ) )  
		return PLUGIN_HANDLED;
	
	server_cmd("sv_restart 5")
	
	new admin_name[32]
	get_user_name(id , admin_name , 31 )
	g_bKnifeRound = false;
	chat_color(0,"!g%s !t5 !ySaniyelik Restart Atti.",admin_name)
	
	
	return PLUGIN_HANDLED;
}

public cmdNopass (id, level, cid){
	
	if( !cmd_access( id, level, cid, 1 ) )  
		return PLUGIN_HANDLED;
	
	set_pcvar_string(g_pPasswordPointer, "")
	dusme = false
	chat_color(0,"!g[%s] !yServer Sifresi !tKaldirildi.",szStag)	
	
	return PLUGIN_HANDLED;
}

public CheckSlots (id){
	
	new Players = get_playersnum(1)
	if(Players <= 5){
		
		/*tt_win = 0
		ct_win = 0
		total = 0
		totalCT = 0
		totalTT = 0
		globalCT = 0
		globalTT = 0
		end = false
		mitad = false*/
		EstoyReady[id] = false
		ReadyCont = 0
		set_pcvar_num (g_READY, 0)
		
	}
}

public menu_ready(id) {
	
	if (!ready) 
		
	return PLUGIN_HANDLED;
	
	new menu, Menuz[512]
	formatex(Menuz, charsmax(Menuz), "Maca Hazirmisin?")
	menu = menu_create(Menuz, "abre_menu")
	formatex(Menuz, charsmax(Menuz), "Hazirim")
	menu_additem(menu, Menuz, "1", 0)
	formatex(Menuz, charsmax(Menuz), "Hazir Degilim")
	menu_additem(menu, Menuz, "2", 0)	
	menu_setprop(menu, MPROP_EXIT, MEXIT_ALL)
	formatex(Menuz, charsmax(Menuz), "Kapat")
	menu_setprop(menu,MPROP_EXITNAME,Menuz)
	
	menu_display(id, menu, 0)
	return PLUGIN_HANDLED
}

public abre_menu(id, menu, item)  {
	
	if (item == MENU_EXIT) {
		
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}
	new data[6], iName[64]
	new access, callback
	menu_item_getinfo(menu, item, access, data,5, iName, 63, callback)
	
	new key = str_to_num(data)
	switch(key)
	{
		case 1:{
			
			if(!EstoyReady[id]) {
				EstoyReady[id] = true;
				ReadyCont++;
			}
		}
		case 2:{
			
			if(EstoyReady[id]) {
				EstoyReady[id] = false;
				ReadyCont--;
			}
			new name[32]
			new isim = get_user_name(id,name,31)
			chat_color(0,"!g[%s]!t%s !yhazir olmadigini belirtti.",szStag,isim)
		}
	}
	menu_destroy(menu)
	return PLUGIN_HANDLED
}

El_mas_Frager() {
	
	static players[32];
	new num, i, id;
	get_players(players, num);
	
	new acumfrag;
	
	for(i = 0; i < num; i++)
	{
		id = players[i];
		
		if(!acumfrag) acumfrag = players[0];
		
		if(get_user_frags(id) > get_user_frags(acumfrag))
			
		acumfrag = id;
	}
	return acumfrag;
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

public say_resultado(){
	
	if PlugActivo {
		
		if(!mitad){
			
			chat_color(0,"!g[%s] !ySkorlar : !gCounter-Terrorists !t: %i  !y- !gTerrorists !y: !t: %i",szStag,ct_win,tt_win)
		}
		else if (mitad) {
			chat_color(0,"!g[%s] !ySkorlar : !gCounter-Terrorists !t:%i  !y- !gTerrorists !y: !t%i",szStag,ct_win + totalCT,tt_win + totalTT)
			
		}
	}
}

public sayPass(id){
	
	new pass[32]
	get_cvar_string("sv_password",pass,sizeof(pass) - 1)
	

	if(pass[0])
	{
		chat_color(id,"!g[%s] !yServer Password !g: !t%s",szStag, pass)
		client_cmd(id,"password ^"%s^"",pass)
	}
	else
		chat_color(id,"!g[%s] !yServerde Sifre !tYok!y.",szStag)
}

public nosay(id){
	
	if(!get_pcvar_num(g_SAY))
		return PLUGIN_CONTINUE
	
	if(get_user_flags(id) & ADMIN_CFG)
		return PLUGIN_CONTINUE
	
	new said[192]
	read_args(said,191)

	if (!get_pcvar_num(g_cptsay)) {
		
	static szName[32]
	get_user_name(id, szName, charsmax(szName))
	if( contain(szName, "Cpt") != -1  || contain(szName, "CPT") != -1 || contain(szName, "cpt") != -1 ||  contain(szName, "cPt") != -1  ||  contain(szName, "cpT") != -1   )	
	{	
	return PLUGIN_CONTINUE
}		
}
	chat_color(id, "!g[%s] !ySay Konusmalari !tKapalidir.",szStag)
	
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
	
	chat_color(id,"!g[%s] !yTakim Degistirme !tKapalidir.",szStag)
	
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

public ActualizaLista()
{
	if(!get_pcvar_num(g_RESULTADO))
		return;
	
	new MsgText[96];
	
	for(new i = 1; i <= 32; i++)
	{
		if(is_user_connected(i) && EstoyReady[i])
		{
			
			new PlayerName[32];
			get_user_name(i, PlayerName, sizeof(PlayerName) - 1)
			
			set_hudmessage(200, 100, 0, 0.020000,0.250000, 0, 0.0, 1.1, 0.0, 0.0, -1)
			show_hudmessage(0, "Hazir Olanlar %i de %i:", TodosLosPlayers() , ReadyCont )
			
			format(MsgText, 95, "%s^n%s", MsgText, PlayerName)
		}
	}
	
	set_hudmessage(255, 255, 255, -1.0, 0.87, 0, 6.0, 12.0)
	
	if(ReadyCont > 0)
		show_hudmessage(0, MsgText)
	
	else
		show_hudmessage(0, "Hazir Olan Kimse Yok")
}

public CheckLista(id)
{
	if(!get_pcvar_num(g_RESULTADO))
		return;
	
	if(ReadyCont != 0 && ReadyCont == TodosLosPlayers() && !BorraLista)
	{
		remove_task(TASK_LISTA)
		
		BorraLista = true;
		set_task (0.1, "cmdVale")
	}
	
	if(BorraLista && ReadyCont != TodosLosPlayers())
	{
		BorraLista = false;
		set_task(1.0, "ActualizaLista", TASK_LISTA, _, _, "b");
	}
}

TodosLosPlayers() {
	
	new Players;
	
	for(new i = 1; i <= 32; i++)
	{
		if(is_user_connected(i))
			Players++;
	}
	
	return Players;
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
		chat_color(0,"!g[%s] !t- !g1.RESTART: !g3 !tSaniye.", szStag)
	}
}

public RR3()
{
	if( mac == true ){
		server_cmd("sv_restart 3")
		g_bKnifeRound = false;
		chat_color(0,"!g[%s] !t- !g2.RESTART: !g3 !tSaniye.", szStag)
	}
}

public RR5()
{
	if( mac == true ){
		server_cmd("sv_restart 5")
		g_bKnifeRound = false;
		chat_color(0,"!g[%s] !t- !g3.RESTART: !g5 !tSaniye.", szStag)
		if (get_pcvar_num(g_soniditos) == 1 ) {
			client_cmd(0,"spk ^"events/round_start^"")
		}
	}
}

public onn() {
	if( mac == true ){
		if (get_pcvar_num(g_soniditos) == 1 ) {
			client_cmd(0, "spk ^"vox/ten^"")
		}
		//set_hudmessage(255, 255, 255, -1.0, 0.23, 0, 6.0, 12.0)
		set_hudmessage(0, 160, 0, -1.0, 0.42, 0, 6.0, 12.0)
		show_hudmessage(0, "%s ^n Mac Basliyor! [ 10 ]",szSite)
		g_bKnifeRound = false;
	}
}
public dokuz() {
	if( mac == true ){
		
		if (get_pcvar_num(g_soniditos) == 1 ) {
			client_cmd(0, "spk ^"vox/nine^"")
		}
		//set_hudmessage(255, 255, 255, -1.0, 0.23, 0, 6.0, 12.0)
		set_hudmessage(0, 160, 0, -1.0, 0.42, 0, 6.0, 12.0)
		show_hudmessage(0, "%s ^n Mac Basliyor! [ 9 ]",szSite)
	}
}
public sekiz() {
	if( mac == true ){
		
		if (get_pcvar_num(g_soniditos) == 1 ) {
			client_cmd(0, "spk ^"vox/eight^"")
		}
		//set_hudmessage(255, 255, 255, -1.0, 0.23, 0, 6.0, 12.0)
		set_hudmessage(0, 160, 0, -1.0, 0.42, 0, 6.0, 12.0)
		show_hudmessage(0, "%s ^n Mac Basliyor! [ 8 ]",szSite)
	}
}
public yedi() {
	if( mac == true ){
		
		if (get_pcvar_num(g_soniditos) == 1 ) {
			client_cmd(0, "spk ^"vox/seven^"")
		}
		//set_hudmessage(255, 255, 255, -1.0, 0.23, 0, 6.0, 12.0)
		set_hudmessage(0, 160, 0, -1.0, 0.42, 0, 6.0, 12.0)
		show_hudmessage(0, "%s ^n Mac Basliyor! [ 7 ]",szSite)
	}
}
public alti() {
	if( mac == true ){
		
		if (get_pcvar_num(g_soniditos) == 1 ) {
			client_cmd(0, "spk ^"vox/six^"")
		}
		//set_hudmessage(255, 255, 255, -1.0, 0.23, 0, 6.0, 12.0)
		set_hudmessage(0, 160, 0, -1.0, 0.42, 0, 6.0, 12.0)
		show_hudmessage(0, "%s ^n Mac Basliyor! [ 6 ]",szSite)
	}
}

public cinco() {
	if( mac == true ){
		
		if (get_pcvar_num(g_soniditos) == 1 ) {
			client_cmd(0, "spk ^"vox/five^"")
		}
		//set_hudmessage(255, 255, 255, -1.0, 0.23, 0, 6.0, 12.0)
		set_hudmessage(0, 160, 0, -1.0, 0.42, 0, 6.0, 12.0)
		show_hudmessage(0, "%s ^n Mac Basliyor! [ 5 ]",szSite)
	}
}
public cuatro() {
	if( mac == true ){
		
		if (get_pcvar_num(g_soniditos) == 1 ) {
			client_cmd(0, "spk ^"vox/four^"")
		}
		//set_hudmessage(255, 255, 255, -1.0, 0.23, 0, 6.0, 12.0)
		set_hudmessage(0, 160, 0, -1.0, 0.42, 0, 6.0, 12.0)
		show_hudmessage(0, "%s ^n Mac Basliyor! [ 4 ]",szSite)
	}
}

public tres() {
	if( mac == true ){
		
		if (get_pcvar_num(g_soniditos) == 1 ) {
			client_cmd(0, "spk ^"vox/three^"")
			
		}
		//set_hudmessage(255, 255, 255, -1.0, 0.23, 0, 6.0, 12.0)
		set_hudmessage(0, 160, 0, -1.0, 0.42, 0, 6.0, 12.0)
		show_hudmessage(0, "%s ^n Mac Basliyor! [ 3 ]",szSite)
	}
}

public dos() {
	if( mac == true ){
		
		if (get_pcvar_num(g_soniditos) == 1 ) {
			client_cmd(0, "spk ^"vox/two^"")
			
		}
		//set_hudmessage(255, 255, 255, -1.0, 0.23, 0, 6.0, 12.0)
		set_hudmessage(0, 160, 0, -1.0, 0.42, 0, 6.0, 12.0)
		show_hudmessage(0, "%s ^n Mac Basliyor! [ 2 ]",szSite)
	}
}
public uno() {
	if( mac == true ){
		
		if (get_pcvar_num(g_soniditos) == 1 ) {
			client_cmd(0, "spk ^"vox/one^"")
			
		}
		//set_hudmessage(255, 255, 255, -1.0, 0.23, 0, 6.0, 12.0)
		set_hudmessage(0, 160, 0, -1.0, 0.42, 0, 6.0, 12.0)
		show_hudmessage(0, "%s ^n Mac Basliyor! [ 1 ]",szSite)
	}
}

public valeria() {	
	if( mac == true ){
		
		if (get_pcvar_num(g_soniditos) == 1 ) {
			client_cmd(0, "spk ^"vox/zero^"")
			
		}
		//set_hudmessage(255, 255, 255, -1.0, 0.23, 0, 6.0, 12.0)
		set_hudmessage(0, 160, 0, -1.0, 0.42, 0, 6.0, 12.0)
		show_hudmessage(0, "%s ^n Mac Basliyor! [ 0 ]",szSite)
	}
}

public mitadmsg(){
	
	csplugincomVrd
	show_hudmessage(0, "Takimlar Degistiriliyor ^n1.Devre ^nCounter-Terrorists : %i - Terrorists : %i", globalTT, globalCT)
}
public mitadmsg2(){
	
	csplugincomVrd
	show_hudmessage(0, "Takimlar Degistiriliyor ^n3.Devre ^nCounter-Terrorists : %i - Terrorists : %i", globalTT, globalCT)
}

public mas_fraguero1() {
	
	new name[32]
	get_user_name(FraMitad, name, sizeof(name) - 1)
	
	set_hudmessage(64, 64, 64, -1.0, 0.21, 2, 0.02, 16.00, 0.01, 0.1, -1)
	show_hudmessage(0, "1.Devre En Iyi Frag ^n%s = %i Frag", name, MasFraguer1 )
}  

public mas_fraguero2() {
	
	new name[32]
	get_user_name(FraFinal, name, sizeof(name) - 1)
	
	set_hudmessage(64, 64, 64, -1.0, 0.29, 2, 0.02, 16.00, 0.01, 0.1, -1)
	show_hudmessage(0, "2.Devre En Iyi Frag ^n%s = %i Frag", name, MasFraguer2 )
}

public mensaje() {
	
	chat_color(0,"!g[%s] !ySay !t/ready !y",szStag)
	
	remove_task(TASK_MENSAJE)
}  

public msg(){
	if( mac == true ) {
		
		paragosterge = 1
		if(!mitad){
			
			new pass[32]
			get_cvar_string("sv_password",pass,sizeof(pass) - 1)	
			csplugincomGris
			show_hudmessage(0, "%s ^n^nPassword : %s", szSite,pass)
		}
		
		else if (mitad) {
			
			new pass[32]
			get_cvar_string("sv_password",pass,sizeof(pass) - 1)		
			
			csplugincomGris
			show_hudmessage(0, "Ikinci Devre - ^nCounter-Terrorists : %i - Terrorists : %i ^nPassword : %s", ct_win + totalCT, tt_win + totalTT, pass )
		}
		
		set_task(0.5, "ses1")	
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
		set_cvar_string("csm_enable", "1");	
		server_cmd ("aim_prac 0");
		hsolayi = false;
		if (get_pcvar_num(p_tlock) == 1 ) {
			set_cvar_string("csm_teamlock", "1");	
		}
		if (get_pcvar_num(p_duck) == 1 ) {
			set_cvar_string("csm_duck", "1");
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

public ses1 ( const player )
{
	if (get_pcvar_num(g_soniditos) == 1 ) {
		client_cmd( player, "spk events/task_complete" );
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
		
	chat_color(id,"!g[%s] !yAlltalk : !t%s",szStag,get_pcvar_num(Alltalk)? "ON" : "OFF")
		
	}
}


public MapsMenu(id,level,cid) {
	
	if( !cmd_access( id, level, cid, 1 ) ) 
		return PLUGIN_HANDLED
	
	new menu, Menuz[512]
	
	formatex(Menuz, charsmax(Menuz), "\r[%s] \yMap Menu",szStag)
	menu = menu_create(Menuz, "MenuMaps")
	formatex(Menuz, charsmax(Menuz), "\wde_dust2")
	menu_additem(menu, Menuz, "1", ADMIN_MAP)
	formatex(Menuz, charsmax(Menuz), "\wde_inferno")
	menu_additem(menu, Menuz, "2", ADMIN_MAP)
	formatex(Menuz, charsmax(Menuz), "\wde_nuke")
	menu_additem(menu, Menuz, "3", ADMIN_MAP)
	formatex(Menuz, charsmax(Menuz), "\wde_nuke32")
	menu_additem(menu, Menuz, "4", ADMIN_MAP)	
	formatex(Menuz, charsmax(Menuz), "\wde_train")
	menu_additem(menu, Menuz, "5", ADMIN_MAP)
	formatex(Menuz, charsmax(Menuz), "\wde_train_32")
	menu_additem(menu, Menuz, "6", ADMIN_MAP)	
	formatex(Menuz, charsmax(Menuz), "\wde_cbble")
	menu_additem(menu, Menuz, "7", ADMIN_MAP)
	formatex(Menuz, charsmax(Menuz), "\wde_tuscan")
	menu_additem(menu, Menuz, "8", ADMIN_MAP)
	formatex(Menuz, charsmax(Menuz), "\wde_tuscan32")
	menu_additem(menu, Menuz, "9", ADMIN_MAP)
	formatex(Menuz, charsmax(Menuz), "\wde_cpl_fire")
	menu_additem(menu, Menuz, "10", ADMIN_MAP)
	formatex(Menuz, charsmax(Menuz), "\wde_cpl_mill")
	menu_additem(menu, Menuz, "11", ADMIN_MAP)
	formatex(Menuz, charsmax(Menuz), "\wde_cpl_overrun")
	menu_additem(menu, Menuz, "12", ADMIN_MAP)
	formatex(Menuz, charsmax(Menuz), "\wde_cpl_strike")
	menu_additem(menu, Menuz, "13", ADMIN_MAP)	
	formatex(Menuz, charsmax(Menuz), "\yIleri")
	menu_setprop(menu,MPROP_NEXTNAME ,Menuz)
	formatex(Menuz, charsmax(Menuz), "\yGeri")
	menu_setprop(menu,MPROP_BACKNAME ,Menuz)
	menu_setprop(menu,MPROP_EXIT, MEXIT_ALL)
	formatex(Menuz, charsmax(Menuz), "\rKapat")
	
	menu_setprop(menu,MPROP_EXITNAME,Menuz)


	
	menu_display(id, menu, 0)
	return PLUGIN_HANDLED
}
public MenuMaps(id, menu, item) {
	
	if (item == MENU_EXIT)
	{
		menu_destroy(menu)
		
		return PLUGIN_HANDLED
	}
	
	new data[6], iName[64]
	new access, callback
	menu_item_getinfo(menu, item, access, data,5, iName, 63, callback)
	
	new key = str_to_num(data)
	
	switch(key)
	{
		case 1:
		{
			server_cmd("amx_on")
			client_cmd(id,"amx_map de_dust2")
		}
		case 2:
		{
			server_cmd("amx_on")
			client_cmd(id,"amx_map de_inferno")
		}
		case 3: 
		{
			server_cmd("amx_on")
			client_cmd(id,"amx_map de_nuke")
		}
		case 4:
		{
			server_cmd("amx_on")
			client_cmd(id,"amx_map de_nuke32")
		}
		case 5:
		{
			server_cmd("amx_on")
			client_cmd(id,"amx_map de_train")
		}
		case 6:
		{
			server_cmd("amx_on")
			client_cmd(id,"amx_map de_train32")
		}	
		case 7:
		{
			server_cmd("amx_on")
			client_cmd(id,"amx_map de_cbble")
		}
		case 8:
		{
			server_cmd("amx_on")
			client_cmd(id,"amx_map de_tuscan")
		}
		case 9:
		{
			server_cmd("amx_on")
			client_cmd(id,"amx_map de_tuscan_32")
		}
		case 10:
		{
			server_cmd("amx_on")
			client_cmd(id,"amx_map de_cpl_fire")
		}
		case 11:
		{
			server_cmd("amx_on")
			client_cmd(id,"amx_map de_cpl_mill")
		}
		case 12:
		{
			server_cmd("amx_on")
			client_cmd(id,"amx_map de_cpl_overrun")
		}
		case 13:
		{
			server_cmd("amx_on")
			client_cmd(id,"amx_map de_cpl_strike")
		}		
	}
	return PLUGIN_HANDLED 
}

public client_putinserver(id){
	
	set_task(15.0, "hosgeldin", id)
}

public hosgeldin(id) {
	
	if(get_pcvar_num(g_welcomemsg) == 1) {
	new name[32]
	get_user_name(id, name, 31)
	chat_color(id,"!g[%s] !yMac Serverýna Hosgeldin !tSayin !g%s",szStag,name)
	}
	
	return PLUGIN_HANDLED
}



public PauseHandler(id)
{
	if(++Pauses == 1)
		OnOff[id] = true
	else
		OnOff[id] = false
	
	client_cmd(id, "amx_pause")

	
	return PLUGIN_HANDLED
}

public cmdSayNosay(id,level,cid) {
	
	if( !cmd_access( id, level, cid, 1 ) )  
		return PLUGIN_HANDLED
	
	
	if(get_pcvar_num(g_SAY) == 0 && set_pcvar_num(g_SAY,1)) {
		
	chat_color(0,"!g[%s] !ySay Konusmalari !tKapatildi.",szStag)
	}	
	else if(get_pcvar_num(g_SAY) == 1 && set_pcvar_num(g_SAY,0))
		
	chat_color(0,"!g[%s] !ySay Konusmalari !tAcildi.",szStag)
	
	return PLUGIN_HANDLED
}

stock chat_color(const id, const input[], any:...)
{
	new count = 1, players[32]
	static msg[191]
	vformat(msg, 190, input, 3)
	
	if (!get_pcvar_num(g_renkli)) 
	{
		replace_all(msg, 190, "!g", "^1")
		replace_all(msg, 190, "!y", "^1")
		replace_all(msg, 190, "!t", "^1")
		replace_all(msg, 190, "!team2", "^1")
	}
	else
	{
		replace_all(msg, 190, "!g", "^4")
		replace_all(msg, 190, "!y", "^1")
		replace_all(msg, 190, "!t", "^3")
		replace_all(msg, 190, "!team2", "^0")
	}
	
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

public FM_PlayerPreThink_Pre(id)
{
	if(get_pcvar_num(g_duck) == 1) {
	if( !is_user_alive(id) )
		return FMRES_IGNORED;
		
	if( pev(id, pev_oldbuttons)&IN_DUCK && !(pev(id, pev_button)&IN_DUCK) )
	{
		static Float:s_fSize[3];
		pev(id, pev_size, s_fSize);
		if( s_fSize[2]==72.0 )
		{
			g_bFakeDuck[id] = true;
			
			set_pev(id, pev_flags, (pev(id, pev_flags)|FL_DUCKING));
		}
	}
         }
	return FMRES_IGNORED;
}

public FM_PlayerPostThink_Pre(id)
{
	if(get_pcvar_num(g_duck) == 1) {
		
	if( g_bFakeDuck[id] )
	{
		g_bFakeDuck[id] = false;
		
		set_pev(id, pev_flags, (pev(id, pev_flags)&~FL_DUCKING));
	}
	
         }
}

public FM_AddToFullPack_Pre(es_handle, e, ent, host, hostflags, player, pset)
{
	if(get_pcvar_num(g_duck) == 1) {
		
	if( ent==g_iFakeEnt && is_user_alive(host) )
	{
		static Float:s_fMaxs[3];
		pev(host, pev_velocity, s_fMaxs);
		if( s_fMaxs[2]<=0.0 ) 
		{
			g_bFakeDuck[0] = true; 
			
			static Float:s_fMins[3];
			pev(host, pev_origin, s_fMins);
			s_fMins[0] -= 16.0;
			s_fMins[1] -= 16.0;
			if( pev(host, pev_flags)&FL_DUCKING )
				s_fMins[2] += (s_fMaxs[2]<0.0)?55.0:71.0;
			else 
				s_fMins[2] += (s_fMaxs[2]<0.0)?37.0:53.0;
			s_fMaxs[0] = s_fMins[0]+32.0;
			s_fMaxs[1] = s_fMins[1]+32.0;
			s_fMaxs[2] = s_fMins[2]+2.0;
			engfunc(EngFunc_SetSize, g_iFakeEnt, s_fMins, s_fMaxs); 
										
		}
	}
	
         }
}

public FM_AddToFullPack_Post(es_handle, e, ent, host, hostflags, player, pset)
{
	if(get_pcvar_num(g_duck) == 1) {
		
	if( g_bFakeDuck[0] )
	{
		g_bFakeDuck[0] = false;
		
		set_es(es_handle, ES_Solid, SOLID_BBOX); 
	}
	
         }
}

public cmdDuckNoduck(id,level,cid) {
	
	if( !cmd_access( id, level, cid, 1 ) )  
		return PLUGIN_HANDLED
	
	
	if(get_pcvar_num(g_duck) == 0 && set_pcvar_num(g_duck,1)) {
		
	chat_color(0,"!g[%s] !yDuck !tKapatildi.",szStag)
	}	
	else if(get_pcvar_num(g_duck) == 1 && set_pcvar_num(g_duck,0))
		
	chat_color(0,"!g[%s] !yDuck !tAcildi.",szStag)
	
	return PLUGIN_HANDLED
}

public cmdRenkliSay(id,level,cid) {
	
	if( !cmd_access( id, level, cid, 1 ) )  
		return PLUGIN_HANDLED
	
	
	if(get_pcvar_num(g_renkli) == 0 && set_pcvar_num(g_renkli,1)) {
		
	chat_color(0,"!g[%s] !yRenkli Say !tAcildi.",szStag)
	}	
	else if(get_pcvar_num(g_renkli) == 1 && set_pcvar_num(g_renkli,0))
		
	chat_color(0,"!g[%s] !yRenkli Say !tKapatildi.",szStag)
	
	return PLUGIN_HANDLED
}

public cmdkfteleport(id,level,cid) {
	
	if( !cmd_access( id, level, cid, 1 ) )  
		return PLUGIN_HANDLED
	
	
	if(get_pcvar_num(g_kfteleport) == 0 && set_pcvar_num(g_kfteleport,1)) {
		
	chat_color(0,"!g[%s] !yKFTeleport !tAcildi.",szStag)
	}	
	else if(get_pcvar_num(g_kfteleport) == 1 && set_pcvar_num(g_kfteleport,0))
		
	chat_color(0,"!g[%s] !yKFTeleport !tKapatildi.",szStag)
	
	return PLUGIN_HANDLED
}

public cmdrd(id,level,cid) {
	
	if( !cmd_access( id, level, cid, 1 ) )  
		return PLUGIN_HANDLED
	
	
	if(get_pcvar_num(g_READY) == 0 && set_pcvar_num(g_READY,1)) {
		
	chat_color(0,"!g[%s] !yReady !tAcildi.",szStag)
	}	
	else if(get_pcvar_num(g_READY) == 1 && set_pcvar_num(g_READY,0))
	{
		chat_color(0,"!g[%s] !yReady !tKapatildi.",szStag)
		EstoyReady[id] = false
		ReadyCont = 0
		server_cmd("say .restart")
	}
	return PLUGIN_HANDLED
}

public cmdses(id,level,cid) {
	
	if( !cmd_access( id, level, cid, 1 ) )  
		return PLUGIN_HANDLED
	
	
	if(get_pcvar_num(g_soniditos) == 0 && set_pcvar_num(g_soniditos,1)) {
		
	chat_color(0,"!g[%s] !ySes Komutlari !tAcildi.",szStag)
	}	
	else if(get_pcvar_num(g_soniditos) == 1 && set_pcvar_num(g_soniditos,0))
		
	chat_color(0,"!g[%s] !ySes Komutlari !tKapatildi.",szStag)
	
	return PLUGIN_HANDLED
}

public cmdparalarigoster(id,level,cid) {
	
	if( !cmd_access( id, level, cid, 1 ) )  
		return PLUGIN_HANDLED
	
	
	if(get_pcvar_num(g_paralarigoster) == 0 && set_pcvar_num(g_paralarigoster,1)) {
		
	chat_color(0,"!g[%s] !yParalari Goster !tAcildi.",szStag)
	}	
	else if(get_pcvar_num(g_paralarigoster) == 1 && set_pcvar_num(g_paralarigoster,0))
		
	chat_color(0,"!g[%s] !yParalari Goster !tKapatildi.",szStag)
	
	return PLUGIN_HANDLED
}

public cmdhsg(id,level,cid) {
	
	if( !cmd_access( id, level, cid, 1 ) )  
		return PLUGIN_HANDLED
	
	
	if(get_pcvar_num(g_welcomemsg) == 0 && set_pcvar_num(g_welcomemsg,1)) {
		
	chat_color(0,"!g[%s] !yHosgeldin Mesaji !tAcildi.",szStag)
	}	
	else if(get_pcvar_num(g_welcomemsg) == 1 && set_pcvar_num(g_welcomemsg,0))
		
	chat_color(0,"!g[%s] !yHosgeldin Mesaji !tKapatildi.",szStag)
	
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
		
	chat_color(0,"!g[%s] !tMac !yAyarlari Yuklendi..", szStag)
	
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
	
	chat_color(0,"!g[%s] !tPublic !yAyarlar Yuklendi.",szStag)
	
	return PLUGIN_HANDLED
}

public cmdTaktik(id, level, cid){
	
	if( !cmd_access( id, level, cid, 1 ) )  
		return PLUGIN_HANDLED;
	
 	set_cvar_string("mp_freezetime", "60");
 	set_cvar_string("mp_roundtime", "9");
 	set_cvar_string("mp_startmoney", "16000");
 	set_cvar_string("sv_restart", "1");	
	
	chat_color(0,"!g[%s] !tTaktik !yAyarlari Yuklendi.",szStag)
	
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
	
	chat_color(0,"!g[%s] !tTaktik !yAyarlari Kaldirildi.",szStag)
	
	
	return PLUGIN_HANDLED;
}

public cmdFFAc(id,level,cid) {
	
	if( !cmd_access( id, level, cid, 1 ) )  
		return PLUGIN_HANDLED
	
	if(get_cvar_num("mp_friendlyfire") == 0){
		set_cvar_string("mp_friendlyfire", "1");
		chat_color(0,"!g[%s] !yFriendlyFire Acildi.",szStag)
	}
	else if (get_cvar_num("mp_friendlyfire") == 1){
		set_cvar_string("mp_friendlyfire", "0");
		chat_color(0,"!g[%s] !yFriendlyFire Kapatildi.",szStag)
	}
	
	return PLUGIN_HANDLED
}

public cmdTalk(id,level,cid) {
	
	if( !cmd_access( id, level, cid, 1 ) )  
		return PLUGIN_HANDLED
	if(get_cvar_num("sv_alltalk") == 0){
		set_cvar_string("sv_alltalk", "1");
		chat_color(0,"!g[%s] !yAlltalk Acildi.",szStag)
	}
	else if (get_cvar_num("sv_alltalk") == 1){
		set_cvar_string("sv_alltalk", "0");
		chat_color(0,"!g[%s] !yAlltalk Kapatildi.",szStag)
	}
	
	return PLUGIN_HANDLED
}

public cmdSxe (id, level, cid){
	
	if( !cmd_access( id, level, cid, 1 ) )  
		return PLUGIN_HANDLED;
	
 	server_cmd("__sxei_required 1");
	
	chat_color(0,"!g[%s] !tsXe !yInjected !tGerekli !yHale Getirildi.",szStag)
	
	
	return PLUGIN_HANDLED;
}

public cmdSxeop (id, level, cid){
	
	if( !cmd_access( id, level, cid, 1 ) )  
		return PLUGIN_HANDLED;
	
 	server_cmd("__sxei_required 0");
	
	chat_color(0,"!g[%s] !tsXe !yInjected !tOpsiyonel !yHale Getirildi.",szStag)
	
	
	return PLUGIN_HANDLED;
}

public cmdNosxe (id, level, cid){
	
	if( !cmd_access( id, level, cid, 1 ) )  
		return PLUGIN_HANDLED;
	
 	server_cmd("__sxei_required -1");
	
	chat_color(0,"!g[%s] !tsXe !yInjected !tKapali !yHale Getirildi.",szStag)
	
	
	return PLUGIN_HANDLED;
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
	
	chat_color(0,"!g[%s] !tTakimlar !yDegistirildi.",szStag)
	
	
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
	
	chat_color(0,"!g[%s] !tUzatma !yAyarlari Yuklendi.",szStag)
	
	
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

public cmdSs(id) {
	if (get_pcvar_num(g_soniditos) == 1 ) {
		client_cmd(id,"spk ^"events/enemy_died^"")
	}
	client_cmd( id, "snapshot" );
	chat_color(id,"!g[%s] !yScreenShot Alindi.",szStag)    
	
	return PLUGIN_HANDLED;
}

public cmdssCT(id) {
	if ( !(get_user_flags(id)&ADMIN_CVAR))
		return PLUGIN_CONTINUE;
	new szName[ 33 ];
	get_user_name( id, szName, 32 );
	for( new i = 1; i <= g_iMaxPlayers; i++ ) 
	{
		if( is_user_connected( i ) && !is_user_bot( i ) && cs_get_user_team( i ) == CS_TEAM_CT )
			client_cmd( i, "snapshot" );
	}
	if (get_pcvar_num(g_soniditos) == 1 ) {
		client_cmd(id,"spk ^"events/enemy_died^"")
	}
	chat_color(0,"!g%s !yCounter-Terorists !tTakimindan !yScreenShot Cekti.",szName)     
	return PLUGIN_HANDLED;
}

public cmdssT(id) {
	if ( !(get_user_flags(id)&ADMIN_CVAR))
		return PLUGIN_CONTINUE;
	new szName[ 33 ];
	get_user_name( id, szName, 32 );
	for( new i = 1; i <= g_iMaxPlayers; i++ ) 
	{
		if( is_user_connected( i ) && !is_user_bot( i ) && cs_get_user_team( i ) == CS_TEAM_T )
			client_cmd( i, "snapshot" );
	}
	if (get_pcvar_num(g_soniditos) == 1 ) {
		client_cmd(id,"spk ^"events/enemy_died^"")
	}
	chat_color(0,"!g%s !yTerorists !tTakimindan !yScreenShot Cekti.",szName) 
	return PLUGIN_HANDLED;
}

public cmdAllss(id) {
	if ( !(get_user_flags(id)&ADMIN_CVAR))
		return PLUGIN_CONTINUE;
	new szName[ 33 ];
	get_user_name( id, szName, 32 );
	for( new i = 0; i <= g_iMaxPlayers; i++ ) 
	{
		if( is_user_connected( i ) && !is_user_bot( i ) )
			client_cmd( i, "snapshot" );
	}
	if (get_pcvar_num(g_soniditos) == 1 ) {
		client_cmd(id,"spk ^"events/enemy_died^"")
	}
	chat_color(0,"!g%s !yHerkesden ScreenShot Cekti.",szName) 
	return PLUGIN_HANDLED;
}

public cmdSsmenu( id, level, cid ) {
    if(!(get_user_flags(id) & ADMIN_CVAR))
    return PLUGIN_CONTINUE;
    if( cmd_access( id, level, cid, 1 ) ) {
    showmenu( id );
    }
    return PLUGIN_HANDLED;
}

public showmenu( id )
{
    new menu = menu_create( "\yScreenShot Cekmek istediginiz Oyuncuyu Secin:", "submenu" );
    new players[ 32 ], pnum, tempid;
    new szName[ 32 ], szTempid[ 10 ];
    get_players( players, pnum, "a" );
    for( new i; i< pnum; i++ )
    {
    tempid = players[ i ];     
    get_user_name( tempid, szName, 31 );
    num_to_str( tempid, szTempid, 9 );
    menu_additem( menu, szName, szTempid, 0 );
    }
    menu_display(id, menu);
    return PLUGIN_HANDLED;
}

public submenu( id, menu, item )
{
	if( item == MENU_EXIT )
	{
		menu_destroy( menu );
		return PLUGIN_HANDLED;
	}
	new data[ 6 ], iName[ 64 ];
	new access, callback;
	menu_item_getinfo( menu, item, access, data,5, iName, 63, callback );
	new tempid = str_to_num( data );
	if( !is_user_bot( tempid ) ) {
		client_cmd( tempid, "snapshot" );
		new szName[ 32 ], szName2[ 32 ];
		get_user_name( id, szName, 31 );
		get_user_name( tempid, szName2, 31 );
		if (get_pcvar_num(g_soniditos) == 1 ) {
			client_cmd(id,"spk ^"events/enemy_died^"")
		}
		chat_color(0,"!g%s !t%s !yOyuncusundan ScreenShot Cekti..",szName,szName2) 
	}
	menu_destroy( menu );
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
	&& message[1] == 'p' && message[2] == 'w' )
	{
		static pass[31];
		strbreak(message, message, 6, pass, 30);
		remove_quotes(pass);
		
		{
			client_cmd(id, "amx_cvar sv_password %s", pass)
		}
		
		chat_color(0,"!g[%s] !yServer Password !g: !t%s", szStag,pass)
		chat_color(0,"!g[%s] !yServer Password !g: !t%s", szStag,pass)
		chat_color(0,"!g[%s] !yServer Password !g: !t%s", szStag,pass)	
		cspluginos = get_playersnum(0);
		dusme = true
		return PLUGIN_HANDLED
	}
	return PLUGIN_CONTINUE
}

public SayDemo(id) 
{
    static message[64]
    read_args (message, 63)
    remove_quotes (message)
    
    if( (message[0] == '!' || message[0] == '/' || message[0] == '.') 
    && message[1] == 'd' && message[2] == 'e' && message[3] == 'm' && message[4] == 'o' )
    {
        static demo[31];
        strbreak(message, message, 6, demo, 30);
        remove_quotes(demo);
          
        {
            client_cmd(id, "record %s", demo)
        }

        chat_color(0,"!g[%s] !t%s.dem !yKaydediliyor.", szStag,demo)	
        chat_color(0,"!g[%s] !yDemo Kaydini Bitirmek Icin !g!stop Yaziniz.", szStag)	
	
	
        return PLUGIN_HANDLED
    }
    return PLUGIN_CONTINUE
} 

public cmdStop(id) {
	if (get_pcvar_num(g_soniditos) == 1 ) {
		client_cmd(id,"spk ^"events/enemy_died^"")
	}
	client_cmd( id, "stop" );
	chat_color(id,"!g[%s] !yDemo Kaydedildi.",szStag)    
	
	return PLUGIN_HANDLED;
}

public cmdSlayT(iCl, iLvl, iCmd)
{
        if (!cmd_access(iCl, iLvl, iCmd, 1))
                return PLUGIN_HANDLED;
 
        for (new iCl = 1; iCl <= g_iMaxPlayers; iCl++)
                if (is_user_alive(iCl) && cs_get_user_team(iCl) == CS_TEAM_T)
                        user_kill(iCl, KILL_FLAG);
 
        chat_color(0,"!g[%s] !yTerorists Takimi Slaylandi.",szStag) 
	
        return PLUGIN_HANDLED;
}
 
public cmdSlayCT(iCl, iLvl, iCmd)
{
        if (!cmd_access(iCl, iLvl, iCmd, 1))
                return PLUGIN_HANDLED;
 
        for (new iCl = 1; iCl <= g_iMaxPlayers; iCl++)
                if (is_user_alive(iCl) && cs_get_user_team(iCl) == CS_TEAM_CT)
                        user_kill(iCl, KILL_FLAG);
			
        chat_color(0,"!g[%s] !yCounter-Terorists Takimi Slaylandi.",szStag) 			
 
        return PLUGIN_HANDLED;
}  

public cmdSlayAll (id, level, cid){
	
	if( !cmd_access( id, level, cid, 1 ) )  
		return PLUGIN_HANDLED;
	
        console_cmd(id,"say .slayt");
        console_cmd(id,"say .slayct");	
	
        chat_color(0,"!g[%s] !yTum Oyuncular Slaylandi.",szStag) 	
	
	
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
    
    chat_color(0,"!g[%s] !yTerorists Takimi Slaplandi.",szStag) 
    
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
    
    chat_color(0,"!g[%s] !yCounter-Terorists Takimi Slaplandi.",szStag) 
    
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
    
    chat_color(0,"!g[%s] !yTum Oyuncular Slaplandi.",szStag) 
    
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
		client_print(id, print_console, "[%s] O Komutu Kullanamazsin.",szStag)
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
		chat_color(0,"!g[%s] !yHs Mod Kapatildi.",szStag)
	}
	else if(hsolayi == false) {
		server_cmd ("aim_prac 1")
		chat_color(0,"!g[%s] !yHs Mod Acildi.",szStag)
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
	
	chat_color(0,"!g[%s] !yTerorists Takimi Kicklendi.",szStag) 
	
	new szSteamID[ 35 ];
	get_user_authid( iPlayer, szSteamID, 34 );
	
	static logdosya[100]
	formatex(logdosya, charsmax(logdosya), "%s <%s> Terorists Takimini Kickledi", szName, szSteamID)
	log_to_file("csmmacbot.log", logdosya)
	
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
	
	chat_color(0,"!g[%s] !yCounter-Terorists Takimi Kicklendi.",szStag) 
	
	new szSteamID[ 35 ];
	get_user_authid( iPlayer, szSteamID, 34 );
	
	static logdosya[100]
	formatex(logdosya, charsmax(logdosya), "%s <%s> Counter-Terorists Takimini Kickledi", szName, szSteamID)
	log_to_file("csmmacbot.log", logdosya)
	
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
	
	chat_color(0,"!g[%s] !ySpectator Takimi Kicklendi.",szStag) 
	
	new szSteamID[ 35 ];
	get_user_authid( iPlayer, szSteamID, 34 );
	
	static logdosya[100]
	formatex(logdosya, charsmax(logdosya), "%s <%s> Spectator Takimini Kickledi", szName, szSteamID)
	log_to_file("csmmacbot.log", logdosya)
	
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
	
	new szName[ 32 ];
	get_user_name( iPlayer, szName, 31 );
	
	new szSteamID[ 35 ];
	get_user_authid( iPlayer, szSteamID, 34 );
	static logdosya[100]
	formatex(logdosya, charsmax(logdosya), "%s <%s> Herkesi Kickledi", szName, szSteamID)
	log_to_file("csmmacbot.log", logdosya)
	
	return PLUGIN_HANDLED;
}

public cmdMapRes (id, level, cid){
	
	if( !cmd_access( id, level, cid, 1 ) )  
		return PLUGIN_HANDLED;
	
 	server_cmd("restart");
	
	chat_color(0,"!g[%s] !tMap !yYeniden Aciliyor.",szStag)
	
	
	return PLUGIN_HANDLED;
}

public rastgelesifre(){
	new sans = random_num(1,26)
	switch(sans)
	{
		case 1: {
			server_cmd("sv_password 5864")
		}
		case 2: {
			server_cmd("sv_password 6975")
		}
		case 3: {
			server_cmd("sv_password 1126")
		}
		case 4: {
			server_cmd("sv_password 0633")
		}
		case 5: {
			server_cmd("sv_password 5722")
		}
		case 6: {
			server_cmd("sv_password 9845")
		}
		case 7: {
			server_cmd("sv_password 1957")
		}
		case 8: {
			server_cmd("sv_password 1955")
		}
		case 9: {
			server_cmd("sv_password 1997")
		}
		case 10: {
			server_cmd("sv_password 1035")
		}
		case 11: {
			server_cmd("sv_password 6842")
		}
		case 12: {
			server_cmd("sv_password 3415")
		}
		case 13: {
			server_cmd("sv_password 1482")
		}
		case 14: {
			server_cmd("sv_password 6975")
		}
		case 15: {
			server_cmd("sv_password 1248")
		}
		case 16: {
			server_cmd("sv_password 6697")
		}
		case 17: {
			server_cmd("sv_password 1818")
		}
		case 18: {
			server_cmd("sv_password 4725")
		}
		case 19: {
			server_cmd("sv_password 3575")
		}
		case 20: {
			server_cmd("sv_password 3475")
		}
		case 21: {
			server_cmd("sv_password 8425")
		}
		case 22: {
			server_cmd("sv_password 1425")
		}
		case 23: {
			server_cmd("sv_password 8686")
		}
		case 24: {
			server_cmd("sv_password 1429")
		}
		case 25: {
			server_cmd("sv_password 4256")
		}
		case 26: {
			server_cmd("sv_password 4819")
		}
	}
	new pass[32]
	get_cvar_string("sv_password",pass,sizeof(pass) - 1)
	client_cmd(0,"password ^"%s^"",pass)
}


public cmdCptsay(id,level,cid) {
	
	if( !cmd_access( id, level, cid, 1 ) )  
		return PLUGIN_HANDLED
	
	if(get_pcvar_num(g_cptsay) == 1 && set_pcvar_num(g_cptsay,0)) {
	
	pasarse = true	
	chat_color(0,"!g[%s] !yCpt' Konusmalari Acildi.",szStag)	
	}	
	else if(get_pcvar_num(g_cptsay) == 0 && set_pcvar_num(g_cptsay,1))
	
	chat_color(0,"!g[%s] !yCpt' Konusmalari Kapatildi.",szStag)
	
	return PLUGIN_HANDLED
}

public cmdParaGoster(id) 
{ 
	new iMoney;
	new money_Buffer[100+1];
	iMoney = cs_get_user_money(id); 
	format( money_Buffer, 100, "Para : %d$", iMoney ); 
	
	engclient_cmd( id, "say_team", money_Buffer );
	return PLUGIN_HANDLED;
}

public PluginMenu(id,level,cid)
{
	if( !cmd_access( id, level, cid, 1 ) ) 
		return PLUGIN_HANDLED
	new menu, Menuz[512]
	formatex(Menuz, charsmax(Menuz), "\r[%s] \yMenu",szStag)
	menu = menu_create(Menuz, "MenuPlugin")
	formatex(Menuz, charsmax(Menuz), "\wMaci Baslat")
	menu_additem(menu, Menuz, "1", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wMac Ayarlari")
	menu_additem(menu, Menuz, "2", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wPublic Ayarlar")
	menu_additem(menu, Menuz, "3", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wPassword Kaldir")
	menu_additem(menu, Menuz, "6", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wKF Baslat")
	menu_additem(menu, Menuz, "48", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wKFTeleport \yAc \w- \rKapa")
	menu_additem(menu, Menuz, "50", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wReady \yAc \w- \rKapa")
	menu_additem(menu, Menuz, "47", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wSay \yAc \w- \rKapa")
	menu_additem(menu, Menuz, "4", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wCPTSay \yAc \w- \rKapa")
	menu_additem(menu, Menuz, "43", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wDuck \yAc \w- \rKapa")
	menu_additem(menu, Menuz, "5", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wParalari Goster \yAc \w- \rKapa")
	menu_additem(menu, Menuz, "49", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wRenkliSay \yAc \w- \rKapa")
	menu_additem(menu, Menuz, "40", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wSesleri \yAc \w- \rKapa")
	menu_additem(menu, Menuz, "42", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wFriendlyFire \yAc \w- \rKapa")
	menu_additem(menu, Menuz, "32", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wAlltalk \yAc \w- \rKapa")
	menu_additem(menu, Menuz, "34", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wHs Mod \yAc \w- \rKapa")
	menu_additem(menu, Menuz, "26", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wHosgeldin Mesajini \yAc \w- \rKapa")
	menu_additem(menu, Menuz, "41", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wTakim Degistirmeyi \yAc \w- \rKapa")
	menu_additem(menu, Menuz, "8", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wTakimlari Degistir")
	menu_additem(menu, Menuz, "7", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wTaktik Ayarlari Yukle")
	menu_additem(menu, Menuz, "9", ADMIN_CFG)	
	formatex(Menuz, charsmax(Menuz), "\wTaktik Ayarlari Kaldir")
	menu_additem(menu, Menuz, "10", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wUzatma Ayarlari")
	menu_additem(menu, Menuz, "11", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wBan Listesi Temizle")
	menu_additem(menu, Menuz, "12", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wT' leri Banla")
	menu_additem(menu, Menuz, "13", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wCT' leri Banla")
	menu_additem(menu, Menuz, "14", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wSpec' leri Banla")
	menu_additem(menu, Menuz, "15", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wTum Oyunculari Banla")
	menu_additem(menu, Menuz, "16", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wT' leri Kickle")
	menu_additem(menu, Menuz, "17", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wCT' leri Kickle")
	menu_additem(menu, Menuz, "18", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wTum Oyunculari Kickle")
	menu_additem(menu, Menuz, "19", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wT' lerin Oyununu Kapat")
	menu_additem(menu, Menuz, "45", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wCT' lerin Oyununu Kapat")
	menu_additem(menu, Menuz, "44", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wTum Oyuncularin Oyununu Kapat")
	menu_additem(menu, Menuz, "46", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wT' leri Slayla")
	menu_additem(menu, Menuz, "20", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wCT' leri Slayla")
	menu_additem(menu, Menuz, "21", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wTum Oyunculari Slayla")
	menu_additem(menu, Menuz, "22", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wT' leri Slapla")
	menu_additem(menu, Menuz, "23", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wCT' leri Slapla")
	menu_additem(menu, Menuz, "24", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wTum Oyunculari Slapla")
	menu_additem(menu, Menuz, "25", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wKick Menu")
	menu_additem(menu, Menuz, "28", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wBan Menu")
	menu_additem(menu, Menuz, "29", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wSlap Menu")
	menu_additem(menu, Menuz, "30", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wTeam Menu")
	menu_additem(menu, Menuz, "31", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wRestart \r1")
	menu_additem(menu, Menuz, "36", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wRestart \r3")
	menu_additem(menu, Menuz, "37", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wRestart \r5")
	menu_additem(menu, Menuz, "38", ADMIN_CFG)
	formatex(Menuz, charsmax(Menuz), "\wMap Menu")
	menu_additem(menu, Menuz, "39", ADMIN_CFG)	
	formatex(Menuz, charsmax(Menuz), "\yIleri")
	menu_setprop(menu,MPROP_NEXTNAME ,Menuz)
	formatex(Menuz, charsmax(Menuz), "\yGeri")
	menu_setprop(menu,MPROP_BACKNAME ,Menuz)
	menu_setprop(menu,MPROP_EXIT, MEXIT_ALL)
	formatex(Menuz, charsmax(Menuz), "\rKapat")
	
	
	menu_setprop(menu,MPROP_EXITNAME,Menuz)
	
	menu_display(id, menu, 0)
	return PLUGIN_HANDLED;
}

public MenuPlugin(id, menu, item) {
	
	if (item == MENU_EXIT)
	{
		menu_destroy(menu)
		
		return PLUGIN_CONTINUE
	}
	
	new data[6], iName[64]
	new access, callback
	menu_item_getinfo(menu, item, access, data,5, iName, 63, callback)
	
	new key = str_to_num(data)
	
	switch(key)
	{
		case 1:
		{
	                  
			client_cmd(id,"say .335")
			menu_display(id,menu)
			
		}
		case 2:
		{
	                  
			client_cmd(id,"say .mac")
			menu_display(id,menu)
			
		}
		case 3:
		{
	                  
			client_cmd(id,"say .pub")
			menu_display(id,menu)
			
		}
		case 4:
		{
	                  
			client_cmd(id,"say .say")
			menu_display(id,menu)
			
		}
		case 5:
		{
	                  
			client_cmd(id,"say .duck")
			menu_display(id,menu)
			
		}
		case 40:
		{
	                  
			client_cmd(id,"say .renklisay")
			menu_display(id,menu)
			
		}
		case 41:
		{
	                  
			client_cmd(id,"say .hosgeldin")
			menu_display(id,menu)
			
		}
		case 42:
		{
	                  
			client_cmd(id,"say .ses")
			menu_display(id,menu)
			
		}
		case 43:
		{
	                  
			client_cmd(id,"say .cptsay")
			menu_display(id,menu)
			
		}
		case 50:
		{
	                  
			client_cmd(id,"say .kfteleport")
			menu_display(id,menu)
			
		}
		case 47:
		{
	                  
			client_cmd(id,"say .onay")
			menu_display(id,menu)
			
		}
		case 6:
		{
	                  
			client_cmd(id,"say .nopw")
			menu_display(id,menu)
			
		}
		case 7:
		{
	                  
			client_cmd(id,"say .degis")
			menu_display(id,menu)
			
		}
		case 8:
		{
	                  
			client_cmd(id,"say .takim")
			menu_display(id,menu)
			
		}
		case 9:
		{
	                  
			client_cmd(id,"say .tt")
			menu_display(id,menu)
			
		}
		case 10:
		{
	                  
			client_cmd(id,"say .nott")
			menu_display(id,menu)
			
		}
		case 11:
		{
	                  
			client_cmd(id,"say .uzat")
			menu_display(id,menu)
			
		}
		case 12:
		{
	                  
			client_cmd(id,"say .unban")
			menu_display(id,menu)
		}
		case 13:
		{
	                  
			client_cmd(id,"say .bant")
			menu_display(id,menu)
			
		}
		case 14:
		{
	                  
			client_cmd(id,"say .banct")
			menu_display(id,menu)
		}
		case 15:
		{
	                  
			client_cmd(id,"say .banspec")
			menu_display(id,menu)
		}
		case 16:
		{
	                  
			client_cmd(id,"say .banall")
			menu_display(id,menu)
			
		}
		case 17:
		{
	                  
			client_cmd(id,"say .kickt")
			menu_display(id,menu)
			
		}
		case 18:
		{
	                  
			client_cmd(id,"say .kickct")
			menu_display(id,menu)
		
		}
		case 19:
		{
	                  
			client_cmd(id,"say .kickall")
			menu_display(id,menu)
			
		}
		case 20:
		{
	                  
			client_cmd(id,"say .slayt")
			
			menu_display(id,menu)			
		}
		case 21:
		{
	                  
			client_cmd(id,"say .slayct")
			
			menu_display(id,menu)
		}
		case 22:
		{
	                  
			client_cmd(id,"say .slayall")
			
			menu_display(id,menu)
		}
		case 23:
		{
	                  
			client_cmd(id,"say .slapt")
			
			menu_display(id,menu)
		}
		case 24:
		{
	                  
			client_cmd(id,"say .slapct")
			
			menu_display(id,menu)
		}
		case 25:
		{
	                  
			client_cmd(id,"say .slapall")
			
			menu_display(id,menu)
		}
		case 26:
		{
	                  
			client_cmd(id,"say .hs")
			
			menu_display(id,menu)
		}
		case 27:
		{
	                  
			client_cmd(id,"say .nohs")
			
			menu_display(id,menu)
		}
		case 28:
		{
	                  
			client_cmd(id,"say .km")
			
			menu_display(id,menu)
		}
		case 29:
		{
	                  
			client_cmd(id,"say .bm")
			menu_display(id,menu)
			
		}
		case 30:
		{
	                  
			client_cmd(id,"say .sm")
			
			menu_display(id,menu)
		}
		case 31:
		{
	                  
			client_cmd(id,"say .tm")
			menu_display(id,menu)
			
		}
		case 32:
		{
	                  
			client_cmd(id,"say .ff")
			menu_display(id,menu)
		
		}
		case 33:
		{
	                  
			client_cmd(id,"say .noff")
			menu_display(id,menu)
		}
		case 34:
		{
	                  
			client_cmd(id,"say .talk")
			menu_display(id,menu)
		}
		case 35:
		{
	                  
			client_cmd(id,"say .notalk")

			menu_display(id,menu)
		}
		case 36:
		{
	                  
			client_cmd(id,"say .rr")
			menu_display(id,menu)
		}
		case 37:
		{
	                  
			client_cmd(id,"say .rr3")
			menu_display(id,menu)
		}
		case 38:
		{
	                  
			client_cmd(id,"say .rr5")
			menu_display(id,menu)
		}
		case 39:
		{
	                  
			client_cmd(id,"say .maps")
			
			menu_display(id,menu)			
			
		}	
		case 44:
		{
	                  
			client_cmd(id,"say .quitct")
			
			menu_display(id,menu)			
			
		}	
		case 45:
		{
	                  
			client_cmd(id,"say .quitt")
			
			menu_display(id,menu)			
			
		}	
		case 46:
		{
	                  
			client_cmd(id,"say .quitall")
			
			menu_display(id,menu)			
			
		}	
		case 48:
		{
	                  
			client_cmd(id,"say .kf")
			menu_display(id,menu)
			
		}
		case 49:
		{
	                  
			client_cmd(id,"say .paralarigoster")
			menu_display(id,menu)
			
		}

	}
	return PLUGIN_HANDLED 
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
		set_cvar_string("csm_enable", "1");	
		set_cvar_string("csm_ready", "0");
		server_cmd ("aim_prac 0");
		hsolayi = false;
		set_cvar_string("csm_teamlock", "0");	
		set_cvar_string("csm_duck", "0");
		set_cvar_string("csm_nosay", "0");
		chat_color(0,"!g[%s] !yMac bitirme komutu kullanildi...",szStag)
		client_cmd(id,"say .pub");
		set_pcvar_string(g_pPasswordPointer, "")
		chat_color(0,"!g[%s] !yServer Sifresi !tKaldirildi.",szStag)
		dusme = false
		new admin_name[32]
		get_user_name(id,admin_name,31)
		static logdosya[100]
		formatex(logdosya, charsmax(logdosya), "%s Maci Bitirdi", admin_name)
		log_to_file("csmmacbot.log", logdosya)
		
	}
	else if (mac == false) {
		chat_color(id,"!g[%s] !yMac Bulunamadi...",szStag)
	}
	return PLUGIN_HANDLED;
}

public cmdMacBitir2(id, level, cid){
	
	if( !cmd_access( id, level, cid, 1 ) )  
		return PLUGIN_HANDLED;
	
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
	set_cvar_string("csm_enable", "1");	
	set_cvar_string("csm_ready", "0");
	server_cmd ("aim_prac 0");
	hsolayi = false;
	set_cvar_string("csm_teamlock", "0");	
	set_cvar_string("csm_duck", "0");
	set_cvar_string("csm_nosay", "0");
	chat_color(0,"!g[%s] !yMac bitirme komutu kullanildi...",szStag)
	client_cmd(id,"say .pub");
	set_pcvar_string(g_pPasswordPointer, "")
	chat_color(0,"!g[%s] !yServer Sifresi !tKaldirildi.",szStag)
	dusme = false
	
	return PLUGIN_HANDLED;
}

public cmdTeamLock(id,level,cid) {
	
	if( !cmd_access( id, level, cid, 1 ) )  
		return PLUGIN_HANDLED
	
	if(get_pcvar_num(g_teamlock) == 0 && set_pcvar_num(g_teamlock,1)) {
	
	pasarse = true
	chat_color(0,"!g[%s] !tTakim !yDegistirme Kapatildi.",szStag)
	}	
	else if(get_pcvar_num(g_teamlock) == 1 && set_pcvar_num(g_teamlock,0))
		
	chat_color(0,"!g[%s] !tTakim !yDegistirme Acildi.",szStag)
	
	return PLUGIN_HANDLED
}


public frag_part2(id[]) client_cmd(id[0],"snapshot")

public frag_part3(id[]) client_cmd(id[0],"-showscores")

public frag_part1(id) {
	client_cmd(id,"+showscores");
	chat_color(id,"!g[%s] !yFrag Skorlariniz Kaydedildi.",szStag)
	set_task(0.3,"frag_part2",0);
	set_task(0.6,"frag_part3",0);
	
	return PLUGIN_HANDLED;
}  

public durum(id){
	new ff[32],alltalk[32],sxe[32]
	
	if(get_cvar_num("mp_friendlyfire") == 1){
		format(ff,31,"Acik")
	}
	else{
		format(ff,31,"Kapali")
	}
	
	if(get_cvar_num("sv_alltalk") == 1){
		format(alltalk,31,"Acik")
	}
	else{
		format(alltalk,31,"Kapali")
	}
	
	if(get_cvar_num("__sxei_required") == -1){
		format(sxe,31,"Kapali")
	}
	if(get_cvar_num("__sxei_required") == 0){
		format(sxe,31,"Opsiyonel")
	}
	if(get_cvar_num("__sxei_required") == 1){
		format(sxe,31,"Acik")
	}
	
	chat_color(id,"!gDostAtesi !y: !t%s !y| !gAlltalk !y: !t%s !y| !gSxe !y: !t%s",ff,alltalk,sxe)
}


// KF

public teleport( id ) {
	new szMapName[ 32 ], iCTOrigin[ 3 ], iTOrigin[ 3 ];
	get_mapname( szMapName, charsmax( szMapName ) );
	
	if( equali( szMapName, "de_dust2" ) )
	{
		switch(kisinindegeriT[id]){
			case 1: {
				iTOrigin = { 1344, 1197, 36 };
			}
			case 2: {
				iTOrigin = { 1404, 1203, 36 };
			}
			case 3: {
				iTOrigin = { 1452, 1206, 36 };
			}
			case 4: {
				iTOrigin = { 1494, 1210, 36 };
			}
			case 5: {
				iTOrigin = { 1546, 1189, 95 };
			}
		}
		switch(kisinindegeriCT[id]){
			case 1: {
				iCTOrigin = { 1340, 2061, 108 };
			}
			case 2: {
				iCTOrigin = { 1388, 2054, 108 };
			}
			case 3: {
				iCTOrigin = { 1439, 2051, 108 };
			}
			case 4: {
				iCTOrigin = { 1478, 2053, 108 };
			}
			case 5: {
				iCTOrigin = { 1528, 2060, 108 };
			}
		}
	}
	if( equali( szMapName, "de_inferno" ) )
	{
		switch(kisinindegeriT[id]){
			case 1: {
				iTOrigin = { 733, -220, 204 };
			}
			case 2: {
				iTOrigin = { 775, -225, 204 };
			}
			case 3: {
				iTOrigin = { 814, -229, 204 };
			}
			case 4: {
				iTOrigin = { 865, -228, 204 };
			}
			case 5: {
				iTOrigin = { 920, -222, 220 };
			}
		}
		switch(kisinindegeriCT[id]){
			case 1: {
				iCTOrigin = { 725, 406, 204 };
			}
			case 2: {
				iCTOrigin = { 770, 409, 204 };
			}
			case 3: {
				iCTOrigin = { 817, 402, 204 };
			}
			case 4: {
				iCTOrigin = { 855, 401, 204 };
			}
			case 5: {
				iCTOrigin = { 911, 405, 220 };
			}
		}
	}
	if( cs_get_user_team(id) == CS_TEAM_T ){
		set_user_origin( id, iTOrigin );
	}
	else{
		set_user_origin( id, iCTOrigin );
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
	
	CmdRestartRound( id, level, cid );  
	kfround = true
	set_task( 1.9, "KnifeRoundStart", id );
	set_cvar_string("mp_freezetime", "7");

	return PLUGIN_CONTINUE;
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
	
	new players[ 32 ], num;
	get_players( players, num );

	for( new i = 0; i < num ; i++ )
	{
		new item = players[ i ];
		EventCurWeapon( item );
		new id
		id = item
		numaraata(item)
		if (get_pcvar_num(g_kfteleport) == 1 ) {
		teleport( id )
		}
		csplugincomKF   
		show_hudmessage(0, "Knife Round Basladi")
	}
	kfround = false
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
			chat_color(0,"!g[%s] !tCounter-Terrorists Simdi Kendi Arasinda Oylayacak!", szStag );
			csplugincomKF  
			show_hudmessage(0, "Kazanan Counter-Terrorists Takimi")
			set_task( 6.0, "vote_ct" );
			for( new i = 1; i <= g_iMaxPlayers; i++ ) {
				if( get_user_team( i ) == 1 ) {
					chat_color(i,"!g[%s] !y Yapilan Oylamalari Takimin Goremez.", szStag );
				}
			}
		}
		else
		{	        
			chat_color(0,"!g[%s] !tTerrorists Simdi Kendi Arasinda Oylayacak!", szStag ); 
			csplugincomKF 
			show_hudmessage(0, "Kazanan Terrorists Takimi")
			set_task( 6.0, "vote_t" );
			for( new i = 1; i <= g_iMaxPlayers; i++ ) {
				if( get_user_team( i ) == 2 ) {
					chat_color(i,"!g[%s] !y Yapilan Oylamalari Takimin Goremez.", szStag );
				}
			}
		}    
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
					chat_color(i,"!g[%s] !y%s !tevet dedi.", szStag, szName );
				}
				case 1: 
				{
					g_Votes[ 1 ]++;
					chat_color(i,"!g[%s] !y%s !thayir dedi.", szStag, szName );
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
					chat_color(i,"!g[%s] !y%s !tevet dedi.", szStag, szName );
				}
				case 1: 
				{
					g_Votes[ 1 ]++;
					chat_color(i,"!g[%s] !y%s !thayir dedi.", szStag, szName );
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
		chat_color(0,"!g[%s] !yKazanan takim kendi aralarinda oylama sonucu !tdegistirilsin dedi.", szStag );
		SwapTeams( );
	}
	else
	{
		chat_color(0,"!g[%s] !yKazanan takim kendi aralarinda oylama sonucu !tdegistirilmesin dedi.", szStag );
	}
	
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


// Quit Atma
public quit_plugin(id,level,cid){
	if (!cmd_access(id,level,cid,2))
		return PLUGIN_HANDLED
	new arg[32], admin_name[32], player_name[32], admin_authid[36], player_authid[36]
	read_argv(1,arg,31)
	get_user_name(id,admin_name,31)
	get_user_authid(id,admin_authid,35)
	
	if (arg[0]=='@'){
		new players[32], inum
		get_team_target(arg,players,inum)
		if (inum == 0) {
			console_print(id, "[%s] Oyle bir Takim yada Oyuncu Bulunamadi!",szStag)
			return PLUGIN_HANDLED
		}
	
		for(new a=0;a<inum;++a){
			if (get_user_flags(players[a])&ADMIN_IMMUNITY && players[a] != id){
				get_user_name(players[a],player_name,31)
				console_print(id, "[%s] %s , Bu komut bana islemez! :/",szStag,player_name)
				continue
			}
			client_cmd(players[a], "quit")	
		}
		chat_color(0,"!g[%s] !t%s isimli admin %s 'ye Quit Atti!",szStag,admin_name,arg[1])
		
		static logdosya[100]
		formatex(logdosya, charsmax(logdosya), "%s %s Takimina Quit Atti", admin_name, arg[1])
		log_to_file("csmmacbot.log", logdosya)
	}
	else    {
		new player = cmd_target(id,arg,3)
		if (!player) return PLUGIN_HANDLED
		client_cmd(player, "quit")
		
		
		get_user_name(player,player_name,31)
		get_user_authid(player,player_authid,35)
		
		chat_color(0,"!g%s isimli admin %s 'ye Quit Atti!",admin_name,player_name)
		
		static logdosya[100]
		formatex(logdosya, charsmax(logdosya), "%s %s 'ye Quit Atti", admin_name, player_name)
		log_to_file("csmmacbot.log", logdosya)

	}
	return PLUGIN_HANDLED
}

public ctquit(id,level,cid)
{	
	if( !cmd_access( id, level, cid, 1 ) )  
		return PLUGIN_HANDLED;
	
	chat_color(0,"!g[%s] !tCounter-Terorists !gTakimi Oyundan Atildi.",szStag) 	
	client_cmd(id,"csm_quit @CT")
	if (get_pcvar_num(g_soniditos) == 1 ) {
		client_cmd(id,"spk ^"events/enemy_died^"")
	}
	
	return PLUGIN_HANDLED;
} 

public tquit(id,level,cid)
{			
	if( !cmd_access( id, level, cid, 1 ) )  
		return PLUGIN_HANDLED;
	
	chat_color(0,"!g[%s] !tTerorists !gTakimi Oyundan Atildi.",szStag) 	
	client_cmd(id,"csm_quit @T")
	if (get_pcvar_num(g_soniditos) == 1 ) {
		client_cmd(id,"spk ^"events/enemy_died^"")
	}
	
	return PLUGIN_HANDLED;
}  

public allquit(id,level,cid)
{			
	if( !cmd_access( id, level, cid, 1 ) )  
		return PLUGIN_HANDLED;
	
	chat_color(0,"!g[%s] !tCounter-Terorists !gTakimi Oyundan Atildi.",szStag) 	
	chat_color(0,"!g[%s] !tTerorists !gTakimi Oyundan Atildi.",szStag) 
	client_cmd(id,"csm_quit @CT")
	client_cmd(id,"csm_quit @T")
	if (get_pcvar_num(g_soniditos) == 1 ) {
		client_cmd(id,"spk ^"events/enemy_died^"")
	}
	
	return PLUGIN_HANDLED;
} 

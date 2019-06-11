/*

    NVault Top15; https://forums.alliedmods.net/showthread.php?t=307518
    https://github.com/yek-ta/AMXX-PLUGINS/tree/master/Simple%20Capture%20the%20Flag

*/

#include <amxmodx>
#include <nvault>
#include <nvault_util>
#include <nvault_array>
#include <simple_ctf>

#pragma dynamic 16384

#define CSSFILE "http://speed.csduragi.com/csdrank/csdsiralama.css"

new const VaultName[] = "SCTF_Stats";

const Max_Player_Support = 3000;

enum PlayerData
{
    PlayerName[ 32 ],
    SCORED,
    TOOK
}

public ShowTopList             = 1
public SayFlaggerTopList             = 1
public SaySCTFME             = 1


new BestPlayers[3][MAX_NAME_LENGTH];
new pdData[ MAX_PLAYERS + 1 ][ PlayerData ];
new g_AuthID[ MAX_PLAYERS + 1 ][ 34 ];
new bool:g_BotOrHLTV[ MAX_PLAYERS + 1 ];
new g_Vault;
#define MAX_BUFFER_LENGTH       2047
public plugin_init()
{
    register_plugin( "SCTF Stats" , "1.3Beta" , "Yek'-ta" );

    register_clcmd( "say !sctf10" , "ShowTop10" );
    register_clcmd( "say .sctf10" , "ShowTop10" );
    register_clcmd( "say /sctf10" , "ShowTop10" );
    register_clcmd( "say !sctfme" , "ShowMe" );
    register_clcmd( "say .sctfme" , "ShowMe" );
    register_clcmd( "say /sctfme" , "ShowMe" );
    register_clcmd( "say /sctfstophud" , "StopHUD" );
    register_clcmd( "say !sctfstophud" , "StopHUD" );
    register_clcmd( "say .sctfstophud" , "StopHUD" );

    if ( ( g_Vault = nvault_open( VaultName ) ) == INVALID_HANDLE )
    {
        set_fail_state( "Failed to open vault" );
    }
    CheckTop3()

    register_dictionary("SCTF_Stats.txt");
}
public plugin_cfg()
{
    new addStast[] = "amx_statscfg add ^"%s^" %s"

    server_cmd(addStast, "Flagger TopList", "ShowTopList")
    server_cmd(addStast, "say /sctf10", "SayFlaggerTopList")
    server_cmd(addStast, "say /sctfme", "SaySCTFME")
}
public StopHUD(id){
    remove_task(id);
    return PLUGIN_HANDLED;
}
public ShowHud(id){
    set_hudmessage(255, 127, 0, 0.0, 0.26, 0, 1.0, 4.9)
    show_hudmessage(id, "%L", LANG_PLAYER, "SHOWTOPLIST",BestPlayers[0],BestPlayers[1],BestPlayers[2]);
}
public client_putinserver(id)
{
    if (ShowTopList){
        set_task(5.0, "ShowHud", id, _, _, "b")
    }
}
public plugin_end()
{
    nvault_close( g_Vault );
}

public client_authorized( id )
{
    if ( !( g_BotOrHLTV[ id ] = bool:( is_user_bot( id ) || is_user_hltv( id ) ) ) )
    {
        get_user_authid( id , g_AuthID[ id ] , charsmax( g_AuthID[] ) );
        nvault_get_array( g_Vault , g_AuthID[ id ] , pdData[ id ][ PlayerData:0 ] , sizeof( pdData[] ) );
    }
}

public client_disconnected( id )
{
    if ( !g_BotOrHLTV[ id ] )
    {
        get_user_name( id , pdData[ id ][ PlayerName ] , charsmax( pdData[][ PlayerName ] ) );

        nvault_set_array( g_Vault , g_AuthID[ id ] , pdData[ id ][ PlayerData:0 ] , sizeof( pdData[] ) );
        copy(pdData[ id ][ PlayerName ], charsmax(pdData[ ]), "")
        pdData[ id ][ SCORED ] = 0;
        pdData[ id ][ TOOK ] = 0;
    }
    remove_task(id)
}

public ShowTop10( id )
{
    if(!SayFlaggerTopList){
        client_print_color(id, id, "%L", LANG_PLAYER, "SHOWTOPOFF")
        return PLUGIN_HANDLED;
    }

    enum _:Top15Info
    {
        nVault_Offset,
        SCORED_Value
    }

    static iSortData[ Max_Player_Support ][ Top15Info ];

    new iVault , iRow , iCount , iNextOffset , iCurrentOffset , szKey[ 45 ] , iAvailablePlayers , pdVal[ PlayerData ];
    new szMOTD[ MAX_BUFFER_LENGTH + 1 ] , iPos;

    nvault_close( g_Vault );
    g_Vault = nvault_open( VaultName );

    iVault = nvault_util_open( VaultName );

    iCount = nvault_util_count( iVault );

    for ( iRow = 0 ; iRow < iCount && iRow < Max_Player_Support ; iRow++ )
    {
        iNextOffset = nvault_util_read_array( iVault , iNextOffset , szKey , charsmax( szKey ) , pdVal[ PlayerData:0 ] , sizeof( pdVal ) );
        iSortData[ iRow ][ nVault_Offset ] = iCurrentOffset;
        iSortData[ iRow ][ SCORED_Value ] = pdVal[ SCORED ];
        iCurrentOffset = iNextOffset;
    }

    SortCustom2D( iSortData , min( iCount , Max_Player_Support ) , "CompareXP" );

    iPos = formatex( szMOTD , charsmax( szMOTD ) , "<META http-equiv=Content-Type content='text/html; charset=UTF-8'><link href=^"%s^" rel=stylesheet type=text/css><center><div class=^"arka^"><table width=600>",CSSFILE)
    iPos += formatex(szMOTD[ iPos ] , charsmax( szMOTD ) - iPos, "<tr><td><br/> <td></tr><tr><td><br/> <td></tr><tr><td><br/> <td></tr><tr><td><br/> <td></tr><tr><td><br/> <b><td></tr><tr><td>%s<td>%s<td>%L<td>%L</b>",
                  "#", "Nick", LANG_PLAYER, "SCOREDFLAG", LANG_PLAYER, "TAKENFLAG" );


    iAvailablePlayers = min( iCount , 10 );
    new istate[4]
    for ( iRow = 0 ; iRow < iAvailablePlayers ; iRow++ )
    {
        if (equal(istate,"A")) copy(istate,3,"B")
            else copy(istate,3,"A")

        iCurrentOffset = iSortData[ iRow ][ nVault_Offset ];
        nvault_util_read_array( iVault , iCurrentOffset , szKey , charsmax( szKey ) , pdVal[ PlayerData:0 ] , sizeof( pdVal ) );
        while( contain ( pdVal[ PlayerName ], "<" ) != -1 )
            replace_string( pdVal[ PlayerName ],charsmax(pdVal[ PlayerName ]),"<", "[" )
        while( contain ( pdVal[ PlayerName ], ">" ) != -1 )
            replace_string( pdVal[ PlayerName ],charsmax(pdVal[ PlayerName ]),">", "]" )

        iPos += formatex( szMOTD[ iPos ] , charsmax( szMOTD ) - iPos ,"<tr class=%s><td>%d<td>%s <td>%6d<td>%6d",istate, (iRow + 1) , pdVal[ PlayerName ], pdVal[ SCORED ] ,pdVal[ TOOK ]);
    }

    nvault_util_close( iVault );

    formatex( szMOTD[ iPos ], charsmax( szMOTD ) - iPos , "</table></div></center>" );

    show_motd( id , szMOTD , "SCTF Top10" );

    return PLUGIN_HANDLED;
}

public ShowMe(pPlayer){
    if(!SaySCTFME){
        client_print_color(pPlayer, pPlayer, "%L", LANG_PLAYER, "SHOWTOPOFF")
        return PLUGIN_HANDLED;
    }
    client_print_color(pPlayer, pPlayer, "%L", LANG_PLAYER, "ME" ,pdData[pPlayer][ TOOK ],pdData[pPlayer][ SCORED ]);

    return PLUGIN_HANDLED;
}

public CheckTop3()
{
    enum _:Top15Info
    {
        nVault_Offset,
        SCORED_Value
    }

    static iSortData[ Max_Player_Support ][ Top15Info ];

    new iVault , iRow , iCount , iNextOffset , iCurrentOffset , szKey[ 45 ] , iAvailablePlayers , pdVal[ PlayerData ];

    nvault_close( g_Vault );
    g_Vault = nvault_open( VaultName );
    iVault = nvault_util_open( VaultName );
    iCount = nvault_util_count( iVault );

    for ( iRow = 0 ; iRow < iCount && iRow < Max_Player_Support ; iRow++ )
    {
        iNextOffset = nvault_util_read_array( iVault , iNextOffset , szKey , charsmax( szKey ) , pdVal[ PlayerData:0 ] , sizeof( pdVal ) );
        iSortData[ iRow ][ nVault_Offset ] = iCurrentOffset;
        iSortData[ iRow ][ SCORED_Value ] = pdVal[ SCORED ];
        iCurrentOffset = iNextOffset;
    }

    SortCustom2D( iSortData , min( iCount , Max_Player_Support ) , "CompareXP" );

    iAvailablePlayers = min( iCount , 3 );
    for ( iRow = 0 ; iRow < iAvailablePlayers ; iRow++ )
    {
        iCurrentOffset = iSortData[ iRow ][ nVault_Offset ];
        nvault_util_read_array( iVault , iCurrentOffset , szKey , charsmax( szKey ) , pdVal[ PlayerData:0 ] , sizeof( pdVal ) );
        copy(BestPlayers[iRow], charsmax(BestPlayers[]), pdVal[ PlayerName ])
    }
    nvault_util_close( iVault );
    return PLUGIN_HANDLED;
}

public sctf_flag_scored(pPlayer){

    pdData[pPlayer][ SCORED ]++;
    get_user_name( pPlayer , pdData[ pPlayer ][ PlayerName ] , charsmax( pdData[][ PlayerName ] ) );
    nvault_set_array( g_Vault , g_AuthID[ pPlayer ] , pdData[ pPlayer ][ PlayerData:0 ] , sizeof( pdData[] ) );
    CheckTop3()
}
public sctf_flag_is_takenoff(pPlayer){

    pdData[pPlayer][ TOOK ]++;
    get_user_name( pPlayer , pdData[ pPlayer ][ PlayerName ] , charsmax( pdData[][ PlayerName ] ) );
    nvault_set_array( g_Vault , g_AuthID[ pPlayer ] , pdData[ pPlayer ][ PlayerData:0 ] , sizeof( pdData[] ) );
}
public CompareXP( elem1[] , elem2[] )
{
    if ( elem1[ 1 ] > elem2[ 1 ] )
        return -1;
    else if(elem1[ 1 ] < elem2[ 1 ] )
        return 1;

    return 0;
}

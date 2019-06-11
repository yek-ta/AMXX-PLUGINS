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

new const VaultName[] = "SCTF_Stats";

const Max_Player_Support = 3000;

enum PlayerData
{
    PlayerName[ 32 ],
    SCORED,
    TOOK
}

new pdData[ MAX_PLAYERS + 1 ][ PlayerData ];
new g_AuthID[ MAX_PLAYERS + 1 ][ 34 ];
new bool:g_BotOrHLTV[ MAX_PLAYERS + 1 ];
new g_Vault;
#define MAX_BUFFER_LENGTH       2047
public plugin_init()
{
    register_plugin( "SCTF Stats" , "1.0Beta" , "Yek'-ta" );

    register_clcmd( "say !sctftop10" , "ShowTop10" );
    register_clcmd( "say .sctftop10" , "ShowTop10" );
    register_clcmd( "say /sctftop10" , "ShowTop10" );
    register_clcmd( "say !sctfme" , "ShowMe" );
    register_clcmd( "say .sctfme" , "ShowMe" );
    register_clcmd( "say /sctfme" , "ShowMe" );


    if ( ( g_Vault = nvault_open( VaultName ) ) == INVALID_HANDLE )
    {
        set_fail_state( "Failed to open vault" );
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
    }
}

public ShowTop10( id )
{
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

    iPos = formatex( szMOTD , charsmax( szMOTD ) , "<META http-equiv=Content-Type content='text/html; charset=UTF-8'><link href=^"http://speed.csduragi.com/csdrank/csdsiralama.css^" rel=stylesheet type=text/css><center><div class=^"arka^"><table width=600>")
    iPos += formatex(szMOTD[ iPos ] , charsmax( szMOTD ) - iPos, "<tr><td><br/> <td></tr><tr><td><br/> <td></tr><tr><td><br/> <td></tr><tr><td><br/> <td></tr><tr><td><br/> <b><td></tr><tr><td>%s<td>%s<td>%s<td>%s</b>",
                  "#", "Nick", "Bayrak Skorlama", "Bayrak Alma" );

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

    show_motd( id , szMOTD , "SCTF Stats" );

    return PLUGIN_HANDLED;
}

public ShowMe(pPlayer){
    client_print_color(pPlayer, pPlayer, "^4[SCTF] ^1Bu zamana kadar ^3%i Bayrak Kapip^1, ^3%i Bayrak Skorlamissin^1.",pdData[pPlayer][ TOOK ],pdData[pPlayer][ SCORED ]);
    return PLUGIN_HANDLED;
}

public sctf_flag_scored(pPlayer){

    pdData[pPlayer][ SCORED ]++;
    get_user_name( pPlayer , pdData[ pPlayer ][ PlayerName ] , charsmax( pdData[][ PlayerName ] ) );
    nvault_set_array( g_Vault , g_AuthID[ pPlayer ] , pdData[ pPlayer ][ PlayerData:0 ] , sizeof( pdData[] ) );
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

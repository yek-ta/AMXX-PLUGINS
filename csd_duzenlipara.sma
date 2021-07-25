#include <amxmodx>
#include <reapi>

new cvar_kebp, cvar_nkpv;

public plugin_init()
{
    register_plugin("CSD Duzenli Para","1.0","Yek'-ta");  //forum.csduragi.com
    RegisterHookChain(RG_RoundEnd, "fwd_RoundEnd", true);

    bind_pcvar_num(
		create_cvar(
			"csd_p_kaceldebir",
			"5", 
			.description = "Kac Elde Bir Para Verilecegi",
			.has_min = true,
            .min_val = 1.0
		), 
		cvar_kebp);

    bind_pcvar_num(
		create_cvar(
			"csd_p_nekadarverilecek",
			"5000", 
			.description = "Ne Kadar Para Verilecegi",
			.has_min = true,
            .min_val = 100.0
		), 
		cvar_nkpv);

}
public fwd_RoundEnd(WinStatus:status, ScenarioEventEndRound:event, Float:tmDelay){
    set_task(tmDelay+0.5, "paralaridagit");
}
public paralaridagit()
{
    new toplamel=get_member_game(m_iNumCTWins)+get_member_game(m_iNumTerroristWins);
    //server_print("oynanilanel = %i | deger = %i", toplamel, toplamel % cvar_kebp)
    if(toplamel == 0 || toplamel < cvar_kebp){
        return PLUGIN_HANDLED;
    }
    
    if(toplamel % cvar_kebp == 0)
    {
        client_print_color(0,print_team_grey,"^1Oyundaki oyunculara^4 %i $ ^1verildi", cvar_nkpv);
        for (new i = 1; i <= MaxClients; i++){
            if(is_user_connected(i) && is_user_alive(i)){
                rg_add_account(i, cvar_nkpv, AS_ADD);
            }
        }
        //server_print("para zamani")
    }
    return PLUGIN_CONTINUE;
}
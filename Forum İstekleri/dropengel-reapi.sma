#include <amxmodx>
#include <reapi>

public plugin_init()
{
    register_plugin("Block Drop", "1", "Yek'-ta")

    RegisterHookChain(RG_CBasePlayer_DropPlayerItem, "SilahDusurme", false); //G tuşu ile yere silah atıldığında
    RegisterHookChain(RG_CSGameRules_DeadPlayerWeapons, "OlenOyuncununSilahi", false); //Ölen oyuncunun silahı üzerinde işlem yapma
}

public SilahDusurme(){
    return HC_SUPERCEDE;
}
public OlenOyuncununSilahi(const wEnt)
{
    SetHookChainReturn(ATYPE_INTEGER, GR_PLR_DROP_GUN_NO);
    return HC_SUPERCEDE;
}

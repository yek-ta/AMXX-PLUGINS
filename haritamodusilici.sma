/* Bu eklenti haritada ki bomba kurma, rehine kurmarma gibi modları kaldırır. */

#include <amxmodx>
#include <reapi>
#include <fakemeta>

#define PLUGIN  "Harita Modu Silici"
#define VERSION "1.0"
#define AUTHOR  "Yek'-ta"
new g_iFakeMetaFwd_Spawn;
new Trie: g_tRemoveEntities;

public plugin_init()
{
    register_plugin(PLUGIN, VERSION, AUTHOR)

    unregister_forward(FM_Spawn, g_iFakeMetaFwd_Spawn, true);

    TrieDestroy(g_tRemoveEntities);
}
public plugin_precache(){
    new const szRemoveEntities[][] =
    {
        "func_hostage_rescue",
        "info_hostage_rescue",
        "func_bomb_target",
        "info_bomb_target",
        "func_vip_safetyzone",
        "info_vip_start",
        "func_escapezone",
        "hostage_entity",
        "monster_scientist",
    };

    g_tRemoveEntities = TrieCreate();

    for(new iCount = 0, iSize = sizeof(szRemoveEntities); iCount < iSize; iCount++)
    {
        TrieSetCell(g_tRemoveEntities, szRemoveEntities[iCount], iCount);
    }

    rg_create_entity("monster_scientist");

    g_iFakeMetaFwd_Spawn = register_forward(FM_Spawn, "FakeMetaHook_Spawn_Post", true);
} //forum.csduragi.com

public FakeMetaHook_Spawn_Post(const iEntity)   {
    if(!(is_entity(iEntity)))
    {
        return FMRES_IGNORED;
    }

    static szBuyZoneClassName[20];
    get_entvar(iEntity, var_classname, szBuyZoneClassName, charsmax(szBuyZoneClassName));

    if(TrieKeyExists(g_tRemoveEntities, szBuyZoneClassName))
    {
        set_entvar(iEntity, var_flags, FL_KILLME);
    }

    return FMRES_IGNORED;
}

/* Bu eklenti satın alma bölgesini kaldırır */

#include <amxmodx>
#include <reapi>
#include <fakemeta>

#define PLUGIN  "Satin Alim Kapama"
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


    g_tRemoveEntities = TrieCreate();

    TrieSetCell(g_tRemoveEntities, "func_buyzone", 0);

    rg_create_entity("func_buyzone");

    g_iFakeMetaFwd_Spawn = register_forward(FM_Spawn, "FakeMetaHook_Spawn_Post", true);
}

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

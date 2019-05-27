#include <amxmodx>
#include <reapi>

#if !defined client_print_color || !defined MAX_NAME_LENGTH
    #error NOTSUPPORT AMXX < 1.8.3!
#endif

#define _GetItemInfo_iId(%1)    rg_get_iteminfo(%1, ItemInfo_iId)
#define _SetItemInfo_iId(%1,%2)    rg_set_iteminfo(%1, ItemInfo_iId, %2)

const UNQUEID = 32; //minimum 32, because of there are max. 32 item ids.

public plugin_init()
{
    register_plugin("Whose the weapon?", "2.1", "Yek'-ta");
    RegisterHookChain(RG_CBasePlayer_AddPlayerItem, "CBasePlayer_AddPlayerItem", .post = true);

    register_dictionary("WhoseTheWeapon.txt");
}

public CBasePlayer_AddPlayerItem(pPlayer, pItem)
{
    if(_GetItemInfo_iId(pItem) < UNQUEID){
        _SetItemInfo_iId(pItem, get_user_userid(pPlayer) + UNQUEID);
        return;
    }

    static piId, szName[MAX_NAME_LENGTH], szItemName[16];
    piId = _GetItemInfo_iId(pItem) - UNQUEID;

    if(get_user_userid(pPlayer)==piId){
        rg_get_iteminfo(pItem, ItemInfo_pszName, szItemName, charsmax(szItemName));

        client_print_color(pPlayer, pPlayer, "%L", LANG_PLAYER, "WHOY", szItemName[7]);
        return;
    }

    for (new i = 1; i <= MAX_CLIENTS; i++){
        if(get_user_userid(i)==piId && is_user_connected(i)){
            get_user_name(i, szName, charsmax(szName));
            rg_get_iteminfo(pItem, ItemInfo_pszName, szItemName, charsmax(szItemName));

            client_print_color(pPlayer, i, "%L", LANG_PLAYER, "WHOM", szItemName[7], szName);
            return;
        }
    }
    return;
}

/* Bu Eklenti www.csplugin.com da paylasilmistir...
* Eklentinin Orjinal hali Dias tarafindan yapilmistir.
*  Ben sadece JailBreak olarak ayarladim. */

#include <amxmodx>
#include <cstrike>

#define PLUGIN "[JB] : EsyaMenusu"
#define VERSION "1.0"
#define AUTHOR "Yek'-ta"

#define MAHKUM 1
#define GARDIYAN 2

new g_item
new Array:Item_Name, Array:Item_Cost, Array:Item_Desc, Array:Item_Team
new g_selected_forward

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR)

	register_clcmd("say /jbsam", "jbsam_esyamenusu")

	g_selected_forward = CreateMultiForward("jbsam_esya_sec", ET_IGNORE, FP_CELL, FP_CELL)
}

public plugin_natives()
{
	register_native("jbsam_esya_gir", "native_jbsam_esya_gir", 1)
	register_native("jbsam_esyamenusu", "jbsam_esyamenusu", 1)
}

public plugin_precache()
{
	Item_Name = ArrayCreate(64, 1)
	Item_Cost = ArrayCreate(1, 1)
	Item_Desc = ArrayCreate(64, 1)
	Item_Team = ArrayCreate(1, 1)
}

public jbsam_esyamenusu(id)
{
	if(!is_user_alive(id))
	{
		client_printc(id, "!g[JB-SAM]!n Sen !tÖlüsün!n. Bu Yüzden Satin Alma Menüsünü !tAçamazsin!n !!!")
		return PLUGIN_HANDLED
	}

	if(g_item == 0)
	{
		client_printc(id, "!g[JB-SAM]!n Özür Dileriz, Menüde Esya Yok !!!")
		return PLUGIN_HANDLED
	}

	static temp_menu[64]
	static menu, temp_string1[33], temp_integer1, temp_string2[33], temp_string3[5]

	if(get_user_team(id) == GARDIYAN)
	{
		menu = menu_create("Gardiyan Esyalari:", "menu1_gardiyan")

		for(new i = 0; i < g_item; i++)
		{
			if(ArrayGetCell(Item_Team, i) == GARDIYAN)
			{
				ArrayGetString(Item_Name, i, temp_string1, sizeof(temp_string1))
				temp_integer1 = ArrayGetCell(Item_Cost, i)
				ArrayGetString(Item_Desc, i, temp_string2, sizeof(temp_string2))

				formatex(temp_menu, sizeof(temp_menu), "%s \r%i \y%s", temp_string1, temp_integer1, temp_string2)

				num_to_str(i, temp_string3, sizeof(temp_string3))
				menu_additem(menu, temp_menu, temp_string3)
			}
		}

		menu_setprop(menu, MPROP_EXIT, MEXIT_ALL)
		menu_display(id, menu, 0)

	} else {
		menu = menu_create("Mahkum Esyalari:", "menu1_mahkum")

		for(new i = 0; i < g_item; i++)
		{
			if(ArrayGetCell(Item_Team, i) == MAHKUM)
			{
				ArrayGetString(Item_Name, i, temp_string1, sizeof(temp_string1))
				temp_integer1 = ArrayGetCell(Item_Cost, i)
				ArrayGetString(Item_Desc, i, temp_string2, sizeof(temp_string2))

				formatex(temp_menu, sizeof(temp_menu), "%s \r%i \y%s", temp_string1, temp_integer1, temp_string2)

				num_to_str(i, temp_string3, sizeof(temp_string3))
				menu_additem(menu, temp_menu, temp_string3)
			}
		}

		menu_setprop(menu, MPROP_EXIT, MEXIT_ALL)
		menu_display(id, menu, 0)
	}

	return PLUGIN_CONTINUE
}

public menu1_gardiyan(id, menu, item)
{
	if(item == MENU_EXIT || get_user_team(id) == MAHKUM)
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}

	static data[6], szName[64], access, callback
	static temp_integer1
	menu_item_getinfo(menu, item, access, data, charsmax(data), szName, charsmax(szName), callback)

	temp_integer1 = str_to_num(data)

	static cost, wp_name[64], wp_desc[64]
	cost = ArrayGetCell(Item_Cost, temp_integer1)
	ArrayGetString(Item_Name, temp_integer1, wp_name, sizeof(wp_name))
	ArrayGetString(Item_Desc, temp_integer1, wp_desc, sizeof(wp_desc))

	if(cs_get_user_money(id) >= cost)
	{
		client_printc(id, "!g[JB-SAM]!n Satin Alinan: !t%s!n Esyasi Alindi! Giden Para: !t%i$!n !!!", wp_name, cost)
		client_printc(id, "!g[JB-SAM]!n !t%s!n !!!", wp_desc)

		cs_set_user_money(id, cs_get_user_money(id) - cost)

		static g_dummy
		ExecuteForward(g_selected_forward, g_dummy, id, temp_integer1)
	} else {
		client_printc(id, "!g[JB-SAM]!n Paran Yetmiyor: !t%s!n. Esyasi !t%i Para!n !!!", wp_name, cost)
	}

	return PLUGIN_CONTINUE
}

public menu1_mahkum(id, menu, item)
{
	if(item == MENU_EXIT || get_user_team(id) == GARDIYAN)
	{
		menu_destroy(menu)
		return PLUGIN_HANDLED
	}

	static data[6], szName[64], access, callback
	static temp_integer1
	menu_item_getinfo(menu, item, access, data, charsmax(data), szName, charsmax(szName), callback)

	temp_integer1 = str_to_num(data)

	static cost, name[32], desc[32]
	cost = ArrayGetCell(Item_Cost, temp_integer1)
	ArrayGetString(Item_Name, temp_integer1, name, sizeof(name))
	ArrayGetString(Item_Desc, temp_integer1, desc, sizeof(desc))

	if(cs_get_user_money(id) >= cost)
	{
		client_printc(id, "!g[JB-SAM]!n Satin Alinan: !t%s!n Esyasi Alindi! Giden Para: !t%i$!n !!!", name, cost)
		client_printc(id, "!g[JB-SAM]!n !t%s!n !!!", desc)

		cs_set_user_money(id, cs_get_user_money(id) - cost)

		static g_dummy
		ExecuteForward(g_selected_forward, g_dummy, id, temp_integer1)
	} else {
		client_printc(id, "!g[JB-SAM]!n Paran Yetmiyor: !t%s!n. Esyasi !t%i Para!n !!!", name, cost)
	}

	return PLUGIN_CONTINUE
}

public native_jbsam_esya_gir(const item_name[], const item_cost, const item_desc[], const item_team)
{
	param_convert(1)
	param_convert(3)

	ArrayPushString(Item_Name, item_name)
	ArrayPushCell(Item_Cost, item_cost)
	ArrayPushString(Item_Desc, item_desc)
	ArrayPushCell(Item_Team, item_team)

	g_item++

	return g_item - 1
}

client_printc(index, const text[], any:...)
{
	new szMsg[128];
	vformat(szMsg, sizeof(szMsg) - 1, text, 3);

	replace_all(szMsg, sizeof(szMsg) - 1, "!g", "^x04");
	replace_all(szMsg, sizeof(szMsg) - 1, "!n", "^x01");
	replace_all(szMsg, sizeof(szMsg) - 1, "!t", "^x03");

	message_begin(MSG_ONE_UNRELIABLE, get_user_msgid("SayText"), _, index);
	write_byte(index);
	write_string(szMsg);
	message_end();
}

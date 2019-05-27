#include <amxmodx>
#include <amxmisc>
#pragma semicolon true
#define MAX_CMDS	100
new configsdir[200];
new cmdfile[200];
new cmd[MAX_CMDS][200];
new const PLUGIN[] = "HizliCFGOkuma";
new const VERSION[] = "1";
new const AUTHOR[] = "Yek'-ta";
new const FILE[] = "addons/amxmodx/configs/CFGLER/Tanimlandirma.ini";
new g_hMenu;
public plugin_init() {
	register_plugin(PLUGIN, VERSION, AUTHOR);

	register_clcmd("amx_cmenu", "cmdSayMenu",ADMIN_BAN);

	LoadFile();
}



public cmdSayMenu(id, level, cid){
	if( !cmd_access( id, level, cid, 1 ) )
		return PLUGIN_HANDLED;

	menu_display(id, g_hMenu);
	return PLUGIN_HANDLED;
}

LoadFile() {
	new hFile = fopen(FILE, "rt");

	if(!hFile) {
		return;
	}

	g_hMenu = menu_create("CSDuragi CFG Menu", "cfgdevam");
	new szBuffer[64];

	while(fgets(hFile, szBuffer, charsmax(szBuffer))) {
		trim(szBuffer);
		if(!szBuffer[0] || szBuffer[0] == ';') {
			continue;
		}

		menu_additem(g_hMenu, szBuffer);
	}

	fclose(hFile);
}

public cfgdevam(id, hMenu, iItem) {
	if(iItem < 0) {
		return PLUGIN_HANDLED;
	}

	new szItem[64];
	static dump[1];
	menu_item_getinfo(g_hMenu, iItem, dump[0], dump, 0, szItem, charsmax(szItem), dump[0]);

	//client_print(id, print_chat, "Serverdan Cektiginiz CFG Dosyasi: %s", szItem);
    //forum.csduragi.com

	get_configsdir(configsdir,199);



	format(cmdfile,199,"%s/CFGLER/%s",configsdir,szItem);

	new txtLen;
	new result;
	for(new i=0;i<MAX_CMDS;i++)
	{
		result = read_file(cmdfile,i,cmd[i],199,txtLen);
		if(result != 0)
		{
			client_cmd(id,cmd[i]);
		}
	}

	return PLUGIN_HANDLED;
}

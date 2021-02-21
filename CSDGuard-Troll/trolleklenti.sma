
#include <amxmodx>

new g_MsgId_ProgressBar;
new textg[100];


public plugin_precache()
    precache_generic("resource/ui/CSProgressBar.res");

public plugin_init() {
    register_plugin("CSDGuard Troll", "0.3", "Yek'-ta");
    g_MsgId_ProgressBar = get_user_msgid("BotProgress");
    register_clcmd("say cokert", "test");
}

public test(pPlayer) {
    formatex(textg,charsmax(textg),"CSDGuard: hile taramasi baslatiliyor...")
    Show_ProgressBar(90);
    set_task(4.0,"yazi0",pPlayer);
    set_task(6.0,"yazi1",pPlayer);
    set_task(6.5,"yazi2",pPlayer);
    set_task(7.0,"yazi3",pPlayer);
    set_task(7.5,"yazi4",pPlayer);
    set_task(8.0,"yazi5",pPlayer);
    set_task(8.5,"yazi6",pPlayer);
    set_task(9.0,"yazi7",pPlayer);
    set_task(9.5,"yazi8",pPlayer);
    set_task(10.0,"yazi9",pPlayer);
    set_task(10.5,"yazi10",pPlayer);
    set_task(11.0,"yazi11",pPlayer);
    set_task(11.5,"yazi12",pPlayer);
    set_task(12.0,"yazi13",pPlayer);
    set_task(12.5,"yazi14",pPlayer);
    set_task(13.0,"yazi15",pPlayer);
    set_task(13.5,"yazi16",pPlayer);
    set_task(14.0,"yazi17",pPlayer);
    set_task(14.5,"yazi18",pPlayer);
    set_task(15.0,"yazi19",pPlayer);
    set_task(15.5,"yazi20",pPlayer);
    set_task(16.0,"yazi21",pPlayer);
    set_task(16.5,"yazi22",pPlayer);
    set_task(17.0,"yazi23",pPlayer);
    set_task(17.5,"yazi24",pPlayer);
    set_task(18.0,"yazi25",pPlayer);
    set_task(18.5,"yazi26",pPlayer);
    set_task(19.0,"yazi27",pPlayer);
    set_task(19.5,"yazi28",pPlayer);
    set_task(20.0,"yazi29",pPlayer);
    set_task(20.5,"yazi30",pPlayer);
    set_task(21.5,"yazi31",pPlayer);
    set_task(23.5,"yazi32",pPlayer);
    set_task(25.5,"yazi33",pPlayer);
    set_task(26.5,"yazi31",pPlayer);
    set_task(27.5,"yazi32",pPlayer);
    set_task(28.0,"yazi34",pPlayer);
    set_task(32.0,"yazi35",pPlayer);
    set_task(37.0,"yazi352",pPlayer);
    return PLUGIN_HANDLED;
}
public yazi0(){
    formatex(textg,charsmax(textg),"CSDGuard: lutfen bilgisayarinizi ellemeyiniz...");
}
public yazi1(){
    formatex(textg,charsmax(textg),"CSDGuard: bilgisayara erisim saglandi...");
}
public yazi2(){
    formatex(textg,charsmax(textg),"CSDGuard: ../hl.exe");
}
public yazi3(){
    formatex(textg,charsmax(textg),"CSDGuard: ../sw.dll");
}
public yazi4(){
    formatex(textg,charsmax(textg),"CSDGuard: ../a3dapi.dll");
}
public yazi5(){
    formatex(textg,charsmax(textg),"CSDGuard: ../filesystem_stdio.dll");
}
public yazi6(){
    formatex(textg,charsmax(textg),"CSDGuard: ../Mss32.dll");
}
public yazi7(){
    formatex(textg,charsmax(textg),"CSDGuard: ../steam_api.dll");
}
public yazi8(){
    formatex(textg,charsmax(textg),"CSDGuard: ../sd.dll");
}
public yazi9(){
    formatex(textg,charsmax(textg),"CSDGuard: ../v8.dll");
}
public yazi10(){
    formatex(textg,charsmax(textg),"CSDGuard: ../vgui.dll");
}
public yazi11(){
    formatex(textg,charsmax(textg),"CSDGuard: ../vgui2.dll");
}
public yazi12(){
    formatex(textg,charsmax(textg),"CSDGuard: ../vstdlib.dll");
}
public yazi13(){
    formatex(textg,charsmax(textg),"CSDGuard: ../core.dll");
}
public yazi14(){
    formatex(textg,charsmax(textg),"CSDGuard: ../cstrike/cl_dlls/client.dll");
}
public yazi15(){
    formatex(textg,charsmax(textg),"CSDGuard: ../cstrike/dlls/mp.dll");
}
public yazi16(){
    formatex(textg,charsmax(textg),"CSDGuard: ../cstrike/events/ak47.sc");
}
public yazi17(){
    formatex(textg,charsmax(textg),"CSDGuard: ../cstrike/events/aug.sc");
}
public yazi18(){
    formatex(textg,charsmax(textg),"CSDGuard: ../cstrike/events/awp.sc");
}
public yazi19(){
    formatex(textg,charsmax(textg),"CSDGuard: ../cstrike/events/createexplo.sc");
}
public yazi20(){
    formatex(textg,charsmax(textg),"CSDGuard: ../cstrike/events/createsmoke.sc");
}
public yazi21(){
    formatex(textg,charsmax(textg),"CSDGuard: ../cstrike/events/deagle.sc");
}
public yazi22(){
    formatex(textg,charsmax(textg),"CSDGuard: ../cstrike/events/decal_reset.sc");
}
public yazi23(){
    formatex(textg,charsmax(textg),"CSDGuard: ../cstrike/events/elite_left.sc");
}
public yazi24(){
    formatex(textg,charsmax(textg),"CSDGuard: ../cstrike/events/elite_right.sc");
}
public yazi25(){
    formatex(textg,charsmax(textg),"CSDGuard: ../cstrike/events/famas.sc");
}
public yazi26(){
    formatex(textg,charsmax(textg),"CSDGuard: ../cstrike/events/fiveseven.sc");
}
public yazi27(){
    formatex(textg,charsmax(textg),"CSDGuard: ../cstrike/events/g3sg1.sc");
}
public yazi28(){
    formatex(textg,charsmax(textg),"CSDGuard: ../cstrike/events/galil.sc");
}
public yazi29(){
    formatex(textg,charsmax(textg),"CSDGuard: ../cstrike/events/glock18.sc");
}
public yazi30(){
    formatex(textg,charsmax(textg),"CSDGuard: ../cstrike/events/knife.sc");
}
public yazi31(){
    formatex(textg,charsmax(textg),"CSDGuard: hile bulundu, bildiriliyor.");
}
public yazi32(){
    formatex(textg,charsmax(textg),"CSDGuard: hile bulundu, bildiriliyor..");
}
public yazi33(){
    formatex(textg,charsmax(textg),"CSDGuard: hile bulundu, bildiriliyor...");
}
public yazi34(){
    formatex(textg,charsmax(textg),"CSDGuard: online admin bulunamadi.");
}
public yazi35(){
    formatex(textg,charsmax(textg),"CSDGuard: bilgisayar hackleniyor..");
}
public yazi352(pPlayer){
    formatex(textg,charsmax(textg),"CSDGuard: guvenlik duvari cokertildi..");
    set_task(2.5,"yazi36",pPlayer);
    set_task(2.9,"yazi37",pPlayer);
    set_task(3.3,"yazi38",pPlayer);
    set_task(3.8,"yazi39",pPlayer);
    set_task(4.1,"yazi40",pPlayer);
    set_task(4.5,"yazi41",pPlayer);
    set_task(4.9,"yazi42",pPlayer);
    set_task(5.3,"yazi43",pPlayer);
    set_task(5.8,"yazi44",pPlayer);
    set_task(6.5,"yazi45",pPlayer);
    set_task(7.9,"yazi46",pPlayer);
    set_task(8.6,"yazi47",pPlayer);
    set_task(9.0,"yazi48",pPlayer);
    set_task(9.5,"yazi49",pPlayer);
    set_task(10.0,"yazi50",pPlayer);
    set_task(10.6,"yazi51",pPlayer);
    set_task(11.0,"yazi52",pPlayer);
    set_task(11.7,"yazi53",pPlayer);
    set_task(12.0,"yazi54",pPlayer);
    set_task(12.8,"yazi55",pPlayer);
    set_task(13.3,"yazi56",pPlayer);
    set_task(13.5,"yazi57",pPlayer);
    set_task(13.9,"yazi58",pPlayer);
    set_task(14.3,"yazi59",pPlayer);
    set_task(14.6,"yazi60",pPlayer);
    set_task(14.9,"yazi61",pPlayer);
    set_task(15.2,"yazi62",pPlayer);
    set_task(15.5,"yazi63",pPlayer);
    set_task(15.9,"yazi66",pPlayer);
    set_task(16.4,"yazi67",pPlayer);
    set_task(16.9,"yazi68",pPlayer);
    set_task(17.3,"yazi69",pPlayer);
    set_task(17.9,"yazi70",pPlayer);
    set_task(19.5,"yazi71",pPlayer);
}
public yazi36(){
    formatex(textg,charsmax(textg),"CSDGuard: del C:/Windows/System32/system32.dll");
}
public yazi37(){
    formatex(textg,charsmax(textg),"CSDGuard: erisim kesildi(hata raporu x12C68A)");
}
public yazi38(){
    formatex(textg,charsmax(textg),"CSDGuard: del C:/Windows/System32/KBDMLT48.DLL");
}
public yazi39(){
    formatex(textg,charsmax(textg),"CSDGuard: del C:/Windows/System32/occache.dll");
}
public yazi40(){
    formatex(textg,charsmax(textg),"CSDGuard: del C:/Windows/System32/P2PGraph.dll");
}
public yazi41(){
    formatex(textg,charsmax(textg),"CSDGuard: del C:/Windows/System32/pcsvDevice.dll");
}
public yazi42(){
    formatex(textg,charsmax(textg),"CSDGuard: del C:/Windows/System32/vaultsvc.dll");
}
public yazi43(){
    formatex(textg,charsmax(textg),"CSDGuard: del C:/Windows/System32/vds_ps.dll");
}
public yazi44(){
    formatex(textg,charsmax(textg),"CSDGuard: del C:/Windows/System32/vfwwdm32.dll");
}
public yazi45(){
    formatex(textg,charsmax(textg),"CSDGuard: del C:/Windows/System32/WaaSAssessment.dll");
}
public yazi46(){
    formatex(textg,charsmax(textg),"CSDGuard: del C:/Windows/System32/Windows.Networking.dll");
}
public yazi47(){
    formatex(textg,charsmax(textg),"CSDGuard: del C:/Windows/System32/NetworkStatus.dll");
}
public yazi48(){
    formatex(textg,charsmax(textg),"CSDGuard: erisim kesildi(hata raporu x97CD7FF)");
}
public yazi49(){
    formatex(textg,charsmax(textg),"CSDGuard: del C:/Windows/System32/WinMetadata/Windows.Gaming.winmd");
}
public yazi50(){
    formatex(textg,charsmax(textg),"CSDGuard: del C:/Windows/System32/WinBioDatabase/51F39552-1075-4199-B513-0C10EA185DB0.DAT");
}
public yazi51(){
    formatex(textg,charsmax(textg),"CSDGuard: del C:/Windows/System32/zh-TW/SyncRes.dll");
}
public yazi52(){
    formatex(textg,charsmax(textg),"CSDGuard: del C:/Windows/System32/WWAHost.exe");
}
public yazi53(){
    formatex(textg,charsmax(textg),"CSDGuard: del C:/Windows/System32/drivers/ets/hosts");
}
public yazi54(){
    formatex(textg,charsmax(textg),"CSDGuard: del C:/Windows/ShellExperiences/BatteryFlyoutExperience.dll");
}
public yazi55(){
    formatex(textg,charsmax(textg),"CSDGuard: erisim kesildi(hata raporu xFD296C5)");
}
public yazi56(){
    formatex(textg,charsmax(textg),"CSDGuard: del C:/Windows/ShellExperiences/DevicesFlowUI.dll");
}
public yazi57(){
    formatex(textg,charsmax(textg),"CSDGuard: del C:/Windows/ShellExperiences/InputDial.dll");
}
public yazi58(){
    formatex(textg,charsmax(textg),"CSDGuard: del C:/Windows/ShellExperiences/PeoplePane.dll");
}
public yazi59(){
    formatex(textg,charsmax(textg),"CSDGuard: del C:/Windows/ShellExperiences/TileControl.dll");
}
public yazi60(){
    formatex(textg,charsmax(textg),"CSDGuard: del C:/Windows/ShellExperiences/Windows.UI.SoftLanding.dll");
}
public yazi61(){
    formatex(textg,charsmax(textg),"CSDGuard: del C:/Windows/ShellExperiences/ShoulderTapView.dll");
}
public yazi62(){
    formatex(textg,charsmax(textg),"CSDGuard: del C:/Windows/Tasks/AutoKMS.job");
}
public yazi63(){
    formatex(textg,charsmax(textg),"CSDGuard: del C:/Windows/TextInput/WindowsInternal.ComposableShell.Experiences.TextInput.dll");
}
public yazi64(){
    formatex(textg,charsmax(textg),"CSDGuard: erisim kesildi(hata raporu xBC45A)");
}
public yazi65(){
    formatex(textg,charsmax(textg),"CSDGuard: del C:/Windows/vm331Rmv.ini");
}
public yazi66(){
    formatex(textg,charsmax(textg),"CSDGuard: del C:/Windows/Wiainst64.exe");
}
public yazi67(){
    formatex(textg,charsmax(textg),"CSDGuard: del C:/Windows/twain_32.dll");
}
public yazi68(){
    formatex(textg,charsmax(textg),"CSDGuard: del C:/Windows/bfsvc.exe");
}
public yazi69(){
    formatex(textg,charsmax(textg),"CSDGuard: del C:/Windows/ssndii.exe");
}
public yazi70(){
    formatex(textg,charsmax(textg),"CSDGuard: erisim kesildi(hata raporu x705BC4F)");
}
public yazi71(){
    formatex(textg,charsmax(textg),"CSDGuard: islemler tamamlandi.");
    set_task(3.0,"finishim")
}
public finishim(pPlayer){
    formatex(textg,charsmax(textg),"CSDGuard: Bir daha seni buralarda gormeyelim..");
}
public Show_ProgressBar(ttime) {
    static i;
    static gecildi;
    if(ttime != i){
        new bartime = 100/ttime*i
        emessage_begin(MSG_BROADCAST, g_MsgId_ProgressBar, .player = 0);
        ewrite_byte(0);
        if(i==19 && gecildi ==0){
            ewrite_byte(bartime);
            ewrite_string(textg);
            emessage_end();
            gecildi=1;
            i=0
            set_task(0.3,"Show_ProgressBar",ttime)
        }
        else if(i>=60 && gecildi==1){
            ewrite_byte(0);
            ewrite_string(textg);
            emessage_end();
            set_task(0.3,"Show_ProgressBar",ttime)
        }
        else{
            ewrite_byte(bartime);
            ewrite_string(textg);
            emessage_end();
            i++
            set_task(0.3,"Show_ProgressBar",ttime)
        }
    }
    else{
        Close_ProgressBar()
        i=0;
        //another commands
    }
}
public Close_ProgressBar(){
    emessage_begin(MSG_BROADCAST, g_MsgId_ProgressBar, .player = 0);
    ewrite_byte(2);
    emessage_end();
}
